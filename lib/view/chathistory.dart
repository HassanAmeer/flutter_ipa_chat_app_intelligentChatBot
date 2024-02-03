import 'package:chatapp/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/theme.dart';

class ChatHistoryPage extends StatefulWidget {
  final dynamic date;
  final List? listofchats;

  const ChatHistoryPage({super.key, this.date, this.listofchats});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  final List chatData = [
    // {
    //   "mode": "1",
    //   "text": "Hello User2! How are you doing today?",
    //   "date": "December 24, 2023"
    // },
    // {
    //   "mode": "2",
    //   "text": "Hi User1! I'm good, thank you. How about you?",
    //   "date": "December 24, 2023"
    // },
  ];

  @override
  void initState() {
    super.initState();
    filterByDate();
  }

  filterByDate() async {
    for (var msg in widget.listofchats!) {
      // debugPrint('✨' + widget.date!.toString());
      // debugPrint('✨' + widget.listofchats!.toString());
      if (msg['date'].toString() == widget.date.toString()) {
        chatData.add(msg);
      }
    }
    debugPrint(chatData.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.date.isNotEmpty ? widget.date! : 'Chat History',
              style: TextStyle(
                  color: context.watch<ThemeVmC>().isDarkMode
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17))),
      body: ListView.builder(
        itemCount: chatData.length,
        shrinkWrap: true,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          final message = chatData[index];
          final mode1 = message['mode'].toString() == '1';

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment:
                  mode1 ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width *
                        0.8, // 80% of the screen width
                  ),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: mode1
                        ? MaterialColors.blue.shade600.withOpacity(0.6)
                        : Colors.blueGrey.shade100.withOpacity(0.6),
                  ),
                  child: Wrap(
                    children: [
                      Text(
                        message['text']!,
                        style: TextStyle(
                            color: mode1 ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
