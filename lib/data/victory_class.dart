import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Victory {
  Victory({
    required this.docId,
    required this.victory,
    required this.createdOn,
    required this.icon,
  });

  factory Victory.fromDocument(QueryDocumentSnapshot<dynamic> doc) {
    final String docId = doc.id.toString();
    final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    final Map<String, dynamic> result = <String, dynamic>{
      'docId': docId,
      ...data,
    };

    return Victory.fromJson(result);
  }

  factory Victory.fromJson(Map<String, dynamic> json) {
    final Timestamp timestamp = json['createdOn'];

    final String docId = json['docId'];
    final String victory = json['victory'];
    final String createdOn =
        DateFormat('EEEE, MMMM dd yyyy').format(timestamp.toDate());
    final String icon = json['icon'] ?? 'happy';

    return Victory(
      docId: docId,
      victory: victory,
      createdOn: createdOn,
      icon: icon,
    );
  }

  String docId;
  String victory;
  String createdOn;
  String icon;

  Iterable<Map<String, dynamic>> victoryMap(List<dynamic> list) {
    return list.map((dynamic e) {
      return <String, dynamic>{
        'docId': e.docId,
        'victory': e.victory,
        'createdOn': e.createdOn,
        'icon': e.icon,
      };
    });
  }
}
