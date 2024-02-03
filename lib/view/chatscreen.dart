import 'package:chatapp/todb.dart';
import 'package:chatapp/model/ChatModel.dart';
import 'package:chatapp/widgets/chatBubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../services/theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('chats');
  // final TextEditingController _textController = TextEditingController();
  User? _user;

  void _sendMessage() {
    String messageText = chatController.text.trim();
    if (messageText.isNotEmpty) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy').format(now);
      try {
        if (_user != null) {
          DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
          databaseReference.child('chats').child(_user!.uid).push().set({
            'mode': 1,
            'text': messageText,
            'sender': _user!.email,
            'timestamp': ServerValue.timestamp,
            'date': formattedDate,
            // 'date': '25/12/2023',
          });
        }
      } catch (e) {
        debugPrint('$e');
      }
    }
  }

//////////////////////////////////

  var chatController = TextEditingController();
  List<ChatModel> chatList = [];
  GptApi apiController = GptApi();
  bool isLoadingChat = false;
  int currentChatToAnimate = -1;
  ScrollController _controller = ScrollController();
  List<ChatModel>? chatHistory = [];
  List chatDbList = [];
  late Box<ChatModel> box;

  SpeechToText speechToText = SpeechToText();
  bool isListening = false;
  String speechText = '';

  @override
  void initState() {
    super.initState();
    // initializeBox();
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollDown();
    });
    getDbF();
    // initializeSharedPreference();
  }

  // void initializeBox() async {
  //   box = await Hive.openBox<ChatModel>("chatHistory");
  //   log(box.values.length.toString());
  //   box.values.map((e) => log("${e.message}")).toList();
  //   // await box.clear();
  // }

// This is what you're looking for!
  // void _scrollDown() {
  //   _controller.animateTo(
  //     _controller.position.maxScrollExtent,
  //     duration: const Duration(seconds: 0),
  //     curve: Curves.fastOutSlowIn,
  //   );
  // }
  void _scrollDown() {
    print('Scrolling down!');
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  getDbF() async {
    dynamic value = await _database.child(_auth.currentUser!.uid).once();
    chatDbList.clear();
    if (value.snapshot.value != null) {
      value.snapshot.value.forEach((key, value) {
        if (value['mode'].toString() == '1') {
          chatDbList.add(value['text'].toString());
        }
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(
            Icons.view_headline_sharp,
            color: Colors.blue,
          ),
          title: Text('Chat Bot',
              style: TextStyle(
                  color: context.watch<ThemeVmC>().isDarkMode
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17)),
          centerTitle: true),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8 / 1,
              child: StreamBuilder(
                stream: _database
                    .child(_auth.currentUser!.uid)
                    .orderByChild('timestamp')
                    .onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    const WhenNewMsg();
                  }
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.snapshot.value == null) {
                    const WhenNewMsg();
                  }

                  // if (snapshot.connectionState == ConnectionState.active) {
                  dynamic dataSnapshotValue = snapshot.data!.snapshot.value;

                  if (dataSnapshotValue != null &&
                      dataSnapshotValue is Map<dynamic, dynamic>) {
                    List messages = [];
                    // chatDbList.clear();
                    messages.clear();
                    dataSnapshotValue.forEach((key, value) {
                      DateTime now = DateTime.now();
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(now);
                      if (value['date'].toString() ==
                          formattedDate.toString()) {
                        messages.add(value);
                      }
                    });

                    messages.sort(
                        (a, b) => a['timestamp'].compareTo(b['timestamp']));

                    return ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      controller: _controller,
                      itemBuilder: (context, index) {
                        var message = messages[index];

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ChatBubble(
                            message: message['text'] ?? '',
                            mode: message['mode'] ?? 1,
                            index: index,
                            currentChatToAnimate: currentChatToAnimate,
                          ),
                        );
                      },
                    );
                  } else {
                    return const WhenNewMsg();
                  }
                  // } else {
                  //   return const WhenNewMsg();
                  // }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isLoadingChat == true
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: const Color(0xff0C8CE9),
                              size: 30,
                            ),
                          ),
                        )
                      : const SizedBox(height: 0),
                  TextFormField(
                    controller: chatController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      hintStyle: const TextStyle(
                          color: Color(0xff979797),
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                      filled: true,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // context.watch<ThemeVmC>().isDarkMode
                          isListening
                              ? IconButton(
                                  onPressed: () => stopListening(),
                                  icon: const Icon(Icons.stop_circle),
                                )
                              : IconButton(
                                  onPressed: () => startListening(),
                                  icon: const Icon(Icons.mic_outlined),
                                ),

                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            child: Image.asset(
                              'assets/_Messages-sendIcon.png',
                              width: 25,
                              height: 25,
                            ),
                            onTap: () async {
                              if (chatController.text.trim().isNotEmpty) {
                                if (isListening) {
                                  await speechToText.stop();
                                  isListening = false;
                                }
                                setState(() {
                                  isLoadingChat = true;
                                });
                                _sendMessage();
                                // if (chatDbList.isEmpty) {
                                await getDbF();
                                // }
                                apiController
                                    .getResponse(
                                        chatController.text,
                                        chatDbList ?? ['history empty'],
                                        context)
                                    .then((value) async {
                                  // chatController.clear();
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _scrollDown();
                                  });
                                });
                                if (chatController.text.isNotEmpty) {
                                  chatController.clear();
                                }
                                setState(() {
                                  isLoadingChat = false;
                                });
                              }
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xff979797),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xff979797),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xff979797),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /////
  void startListening() async {
    // Check for and request permissions if needed
    if (!await speechToText.hasPermission) {
      // await speechToText.requestPermissions();
    }
    if (!isListening) {
      await speechToText.initialize();
      isListening = true;
      speechToText.listen(
        onResult: (result) {
          speechText = result.recognizedWords;
          chatController.text = speechText;
          setState(() {}); // Update the UI
        },
        // onError: (error) {
        //   print('Error: $error');
        // },
      );
    }
  }

  void stopListening() async {
    isListening = false;
    if (isListening) {
      await speechToText.stop();
    }
    setState(() {});
  }
}

class WhenNewMsg extends StatelessWidget {
  const WhenNewMsg({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.12,
        ),
        Center(
            child: Image.asset(
          context.watch<ThemeVmC>().isDarkMode
              ? 'assets/Logo.png'
              : 'assets/Logo2.png',
          width: 300,
          height: 300,
        )),
        const Center(
          child: Text(
            'Capabilities',
            style: TextStyle(
                color: Color(0xff979797),
                fontWeight: FontWeight.w700,
                fontSize: 17),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            height: 50,
            decoration: BoxDecoration(
              color: context.watch<ThemeVmC>().isDarkMode
                  ? Colors.blueGrey.shade700
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Answer all your questions.\n(Just ask me anything you like!)',
                style: TextStyle(
                  color: context.watch<ThemeVmC>().isDarkMode
                      ? Colors.white
                      : const Color(0xff979797),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
