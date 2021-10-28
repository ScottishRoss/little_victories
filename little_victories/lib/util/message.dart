import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// Message route arguments.
class MessageArguments {
  /// The RemoteMessage
  final RemoteMessage message;

  /// Whether this message caused the application to open.
  final bool openedApplication;

  // ignore: public_member_api_docs, avoid_positional_boolean_parameters
  MessageArguments(this.message, this.openedApplication);
}

/// Displays information about a [RemoteMessage].
class MessageView extends StatelessWidget {
  /// A single data row.
  Widget row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Row(children: [
        Text('$title: '),
        Text(value),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: cast_nullable_to_non_nullable
    final MessageArguments args = ModalRoute.of(context)!.settings.arguments
        as MessageArguments; // ignore: cast_nullable_to_non_nullable
    final RemoteMessage message = args.message;
    final RemoteNotification notification = message.notification!;

    return Scaffold(
      appBar: AppBar(
        title: Text(message.messageId!),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          row('Triggered application open', args.openedApplication.toString()),
          row('Message ID', message.messageId!),
          row('Sender ID', message.senderId!),
          row('Category', message.category!),
          row('Collapse Key', message.collapseKey!),
          row('Content Available', message.contentAvailable.toString()),
          row('Data', message.data.toString()),
          row('From', message.from!),
          row('Message ID', message.messageId!),
          row('Sent Time', message.sentTime!.toString()),
          row('Thread ID', message.threadId!),
          row('Time to Live (TTL)', message.ttl!.toString()),
          // ignore: unnecessary_null_comparison
          if (notification != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(children: [
                const Text(
                  'Remote Notification',
                  style: TextStyle(fontSize: 18),
                ),
                row(
                  'Title',
                  notification.title!,
                ),
                row(
                  'Body',
                  notification.body!,
                ),
                if (notification.android != null) ...[
                  const Text(
                    'Android Properties',
                    style: TextStyle(fontSize: 18),
                  ),
                  row(
                    'Channel ID',
                    notification.android!.channelId!,
                  ),
                  row(
                    'Click Action',
                    notification.android!.clickAction!,
                  ),
                  row(
                    'Color',
                    notification.android!.color!,
                  ),
                  row(
                    'Count',
                    notification.android!.count!.toString(),
                  ),
                  row(
                    'Image URL',
                    notification.android!.imageUrl!,
                  ),
                  row(
                    'Link',
                    notification.android!.link!,
                  ),
                  row(
                    'Priority',
                    notification.android!.priority.toString(),
                  ),
                  row(
                    'Small Icon',
                    notification.android!.smallIcon!,
                  ),
                  row(
                    'Sound',
                    notification.android!.sound!,
                  ),
                  row(
                    'Ticker',
                    notification.android!.ticker!,
                  ),
                  row(
                    'Visibility',
                    notification.android!.visibility.toString(),
                  ),
                ],
              ]),
            )
          ]
        ]),
      )),
    );
  }
}
