import 'package:chatapp/services/logout.dart';
import 'package:chatapp/services/theme.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/view/chatscreen.dart';
import 'package:chatapp/view/emptychathistory.dart';
import 'package:chatapp/view/emptychathistory2.dart';
import 'package:chatapp/view/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int index = 0;
  List<Widget> pages = [
    const EmptyChat(),
    const ChatScreen(),
    const Settings()
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Logout().exit(context);
        return false;
      },
      child: Stack(
        children: [
          pages[index],
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width * .9,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: context.watch<ThemeVmC>().isDarkMode
                      ? Colors.blueGrey.shade700
                      : Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(100),
                  ),
                  border: Border.all(
                      color: Colors.black87.withOpacity(0.2), width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.history,
                            size: 25,
                            color: MaterialColors.blue,
                          ),
                          // Image.asset(
                          //   'assets/Profile.png',
                          //   width: 25,
                          //   height: 25,
                          // ),
                          index == 0
                              ? const Icon(Icons.remove)
                              : const SizedBox(height: 0),
                        ],
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatScreen(),
                            ));
                      },
                      child: Image.asset(
                        'assets/Group 279.png',
                        width: 45,
                        height: 45,
                      )),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Right Side.png',
                          width: 25,
                          height: 25,
                        ),
                        index == 2
                            ? const Icon(Icons.remove)
                            : const SizedBox(height: 0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
