import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/view/chathistory.dart';
import 'package:chatapp/view/chatscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/theme.dart';

class EmptyChat extends StatefulWidget {
  const EmptyChat({super.key});

  @override
  State<EmptyChat> createState() => _EmptyChatState();
}

class _EmptyChatState extends State<EmptyChat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('chats');

  bool isShowLastMonthActivity = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IPA',
          style: TextStyle(
              color: context.watch<ThemeVmC>().isDarkMode
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 17),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatScreen()));
              },
              child: Icon(
                color: context.watch<ThemeVmC>().isDarkMode
                    ? MaterialColors.lightBlueAccent.shade100
                    : MaterialColors.blue,
                Icons.add,
                size: 25,
              )),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: StreamBuilder(
          stream: isShowLastMonthActivity
              ? _database.child(_auth.currentUser!.uid).onValue
              : _database
                  .child(_auth.currentUser!.uid)
                  .orderByChild('timestamp')
                  .onValue,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError ||
                snapshot.connectionState == ConnectionState.waiting) {
              const EmptyChatsMsgWidget();
            }
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.snapshot.value == null) {
              const EmptyChatsMsgWidget();
            }

            if (snapshot.connectionState == ConnectionState.active) {
              dynamic dataSnapshotValue = snapshot.data!.snapshot.value;
              DateTime currentDate = DateTime.now();
              DateTime last30Days =
                  currentDate.subtract(const Duration(days: 30));

              if (dataSnapshotValue != null &&
                  dataSnapshotValue is Map<dynamic, dynamic>) {
                List messages = [];
                messages.clear();
                dataSnapshotValue.forEach((key, value) {
                  if (isShowLastMonthActivity &&
                      DateTime.fromMillisecondsSinceEpoch(value['timestamp'])
                          .isAfter(last30Days)) {
                    messages.add({
                      'key': key,
                      'mode': value['mode'],
                      'text': value['text'],
                      'timestamp': value['timestamp'],
                      'date': value['date'],
                    });
                  } else {
                    messages.add({
                      'key': key,
                      'mode': value['mode'],
                      'text': value['text'],
                      'timestamp': value['timestamp'],
                      'date': value['date'],
                    });
                  }
                });

                messages
                    .sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
                // if (isShowLastMonthActivity) {
                //   messages.sort((a, b) => b['date'].compareTo(a['date']));
                // } else {
                //   messages
                //       .sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
                // }

                List chatByDate = [];
                Set uniqueDates = Set();

                for (var msg in messages) {
                  if (!uniqueDates.contains(msg['date'])) {
                    uniqueDates.add(msg['date']);
                    chatByDate.add(msg);
                  }
                }

                debugPrint('🥽 : $chatByDate');

                return Column(
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Row(
                        children: [
                          isShowLastMonthActivity == true
                              ? const Text(
                                  'Showing Last Month activity',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                )
                              : const Text(
                                  'Showing All activity',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              isShowLastMonthActivity =
                                  !isShowLastMonthActivity;
                              setState(() {});
                            },
                            child: Image.asset(
                              'assets/Filter.png',
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                        itemCount: chatByDate.length,
                        shrinkWrap: true,
                        controller: ScrollController(),
                        itemBuilder: (context, index) {
                          var message = chatByDate[index];
                          String messageId = message['key'];
                          int timestamp = message['timestamp'];
                          DateTime dateTime =
                              DateTime.fromMillisecondsSinceEpoch(timestamp);
                          DateTime now = DateTime.now();

                          String formattedDateTime;

                          if (dateTime.year == now.year &&
                              dateTime.month == now.month &&
                              dateTime.day == now.day) {
                            formattedDateTime =
                                'today ${DateFormat.jm().format(dateTime)}';
                          } else {
                            formattedDateTime = DateFormat('yyyy-MM-dd hh:mm a')
                                .format(dateTime);
                          }
                          // DateTime dateTime =
                          //     DateTime.fromMillisecondsSinceEpoch(timestamp);
                          // String formattedDateTime =
                          //     DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: context.watch<ThemeVmC>().isDarkMode
                                      ? Colors.blueGrey.shade800
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatHistoryPage(
                                        date: message['date'],
                                        listofchats: messages,
                                      ),
                                    ),
                                  );
                                },
                                tileColor: context.watch<ThemeVmC>().isDarkMode
                                    ? Colors.blueGrey.shade800
                                    : Colors.white,
                                title: Text(
                                  message['text'] ?? '',
                                  style: TextStyle(
                                      color:
                                          context.watch<ThemeVmC>().isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                subtitle: Text(
                                  formattedDateTime,
                                  style: const TextStyle(
                                      color: Color(0xff979797),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      List messageIdList = [];
                                      if (messageIdList.isNotEmpty) {
                                        messageIdList.clear();
                                      }
                                      for (var e in messages) {
                                        if (e['date'].toString() ==
                                            message['date'].toString()) {
                                          messageIdList.add(e['key']);
                                        }
                                      }
                                      deleteChatPopUp(context, messageIdList);
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.grey,
                                      size: 20,
                                    )),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const EmptyChatsMsgWidget();
              }
            } else {
              return const EmptyChatsMsgWidget();
            }
          },
        ),
      ),
    );
  }

  ///////////////
  ////////
  deleteChatPopUp(context, List messageIdList) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(' Want To Delete ?',
              style: TextStyle(
                  fontSize: 18,
                  color: context.watch<ThemeVmC>().isDarkMode
                      ? Colors.white
                      : Colors.black)),
          actions: <Widget>[
            TextButton(
              child: Text('No',
                  style: TextStyle(
                      color: context.watch<ThemeVmC>().isDarkMode
                          ? Colors.grey.shade200
                          : Colors.grey.withOpacity(0.8))),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(
                    color: context.watch<ThemeVmC>().isDarkMode
                        ? Colors.redAccent.shade100
                        : Colors.red.shade700,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                try {
                  DatabaseReference databaseReference =
                      FirebaseDatabase.instance.ref();

                  for (var messageId in messageIdList) {
                    databaseReference
                        .child('chats')
                        .child(_auth.currentUser!.uid)
                        .child(messageId)
                        .remove();
                  }
                  Navigator.pop(context);
                } catch (e) {
                  debugPrint('Error deleting chat message: $e');
                }
              },
            ),
          ],
        );
      },
    );
  } //////////////////
}

class EmptyChatsMsgWidget extends StatelessWidget {
  const EmptyChatsMsgWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.35 / 1),
        const Center(
          child: Text(
            'Empty',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Center(
          child: Text(
            'You have no history.',
            style: TextStyle(
                color: Color(0xff979797),
                fontWeight: FontWeight.w400,
                fontSize: 15),
          ),
        ),
      ],
    );
  }
}
