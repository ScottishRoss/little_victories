import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../util/custom_colours.dart';
import '../../util/firebase_analytics.dart';
import '../../util/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_share/social_share.dart';

class ShareImage extends StatefulWidget {
  const ShareImage({Key? key, required this.victory, required this.platform})
      : super(key: key);

  final String victory;
  final String platform;

  @override
  State<ShareImage> createState() => _ShareImageState();
}

class _ShareImageState extends State<ShareImage> {
  final GlobalKey globalKey = GlobalKey();
  late String platform;
  late File _image;
  final ImagePicker _picker = ImagePicker();
  bool _isSuccess = false;

  // ignore: avoid_void_async
  Future<void> getImageFileFromAssets() async {
    const String path = 'story.png';
    final ByteData byteData = await rootBundle.load('assets/$path');

    final File file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    setState(() {
      _image = file;
    });
  }

  Future<void> _delay() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  void shareToChosenPlatform(String platform, String path) {
    switch (platform) {
      case 'Facebook':
        SocialShare.shareFacebookStory(
          appId: '286381316221449',
          imagePath: path,
          backgroundTopColor: CustomColours.darkPurple.toString(),
          backgroundBottomColor: CustomColours.teal.toString(),
          attributionURL: 'https://www.littlevictories.app',
        );

        break;
      case 'Instagram':
        SocialShare.shareInstagramStory(
            appId: '286381316221449', imagePath: path);
        break;
      case 'Other':
        SocialShare.shareOptions(path);
        break;
    }
    FirebaseAnalyticsService().logEvent('share_victory', <String, Object>{
      'platform': platform,
    });
    Navigator.of(context).pop();
  }

  // ignore: unused_element
  Future<void> _capturePng(String platform) async {
    final BuildContext? currentContext = globalKey.currentContext;
    final String randomString = generateRandomString();
    final RenderRepaintBoundary boundary =
        currentContext!.findRenderObject()! as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage(pixelRatio: 10);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    final Directory tempDir = await getTemporaryDirectory();
    final File pngFile =
        await File('${tempDir.path}/LV_$randomString.png').create();
    pngFile.writeAsBytesSync(pngBytes);

    setState(() {
      _isSuccess = true;
    });

    shareToChosenPlatform(platform, pngFile.path);
  }

  Future<void> _imgFromCamera() async {
    // ignore: cast_nullable_to_non_nullable
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    final File selectedImage = File(image!.path);

    setState(() {
      _image = selectedImage;
    });
  }

  Future<void> _imgFromGallery() async {
    // ignore: cast_nullable_to_non_nullable
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    final File selectedImage = File(image!.path);

    setState(() {
      _image = selectedImage;
    });
  }

  void _showGalleryOrCameraPicker(BuildContext context) {
    showModalBottomSheet<Widget>(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();

    getImageFileFromAssets();
    platform = widget.platform;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColours.darkPurple,
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder<void>(
          future: _delay(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                return _shareImage();
              case ConnectionState.none:
                print(snapshot.error.toString());
                break;
              case ConnectionState.active:
                print(snapshot.error.toString());
                break;
            }
            // ignore: always_specify_types
            throw {print('error')};
          }),
    );
  }

  Widget _shareImage() {
    return Stack(
      children: <Widget>[
        RepaintBoundary(
          key: globalKey,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.file(_image),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/lv_main.png',
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height / 4,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: CustomColours.darkPurple,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.victory,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buttonRow(platform),
        ),
      ],
    );
  }

  Widget _buttonRow(String platform) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: _isSuccess
                ? buildCircleProgressIndicator()
                : buildOutlinedButton(
                    textType: 'Share',
                    textSize: 30.0,
                    iconData: Icons.share,
                    textColor: CustomColours.darkPurple,
                    backgroundColor: Colors.transparent,
                    onPressed: () async {
                      setState(() {
                        _isSuccess = true;
                      });
                      await _capturePng(platform);
                      setState(() {
                        _isSuccess = false;
                      });
                    }),
          ),
          TextButton(
            onPressed: () {
              _showGalleryOrCameraPicker(context);
            },
            child: const Text(
              'Change picture',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
