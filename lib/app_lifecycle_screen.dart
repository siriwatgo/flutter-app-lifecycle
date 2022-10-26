import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class AppLifecycleScreen extends StatefulWidget {
  const AppLifecycleScreen({Key? key}) : super(key: key);

  @override
  State<AppLifecycleScreen> createState() => _AppLifecycleScreenState();
}

class _AppLifecycleScreenState extends State<AppLifecycleScreen>
    with WidgetsBindingObserver {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool shouldShowImage = false;
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) => {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('state: $state');
    switch (state) {
      case AppLifecycleState.inactive:
        _inactiveState();
        break;
      case AppLifecycleState.resumed:
        _resumedState();
        break;
      case AppLifecycleState.paused:
        _pausedState();
        break;
      case AppLifecycleState.detached:
        _detachedState();
        break;
    }
  }

  @override
  void didUpdateWidget(AppLifecycleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future _inactiveState() async {
    if (this.mounted) {
      setState(() {
        shouldShowImage = true;
      });
    }
  }

  Future _resumedState() async {
    if (this.mounted) {
      setState(() {
        shouldShowImage = false;
      });
    }
  }

  Future _pausedState() async {
    if (this.mounted) {
      setState(() {
        shouldShowImage = false;
      });
    }
  }

  Future _detachedState() async {
    if (this.mounted) {
      setState(() {
        shouldShowImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return shouldShowImage ? boxImage() : contentBody();
  }

  Widget contentBody() {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      // appBar: buildAppBar(context),
      body: WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          final maxDuration = Duration(seconds: 3);
          final isWarning =
              lastPressed == null || now.difference(lastPressed!) > maxDuration;
          if (isWarning) {
            lastPressed = DateTime.now();

            final snackBar = SnackBar(
              content: Text('Double Tap To Close App'),
              duration: maxDuration,
            );

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(snackBar);
            return false;
          } else {
            return true;
          }
        },
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              GestureDetector(
                // onTap: () => FocusScope.of(context).unfocus(),
                // > Flutter version 2.0
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Center(
                              child: Text('Flutter App Lifecycle'),
                            ),
                            ElevatedButton(
                              child: Text('Close App'),
                              onPressed: () async {
                                if (Platform.isAndroid) {
                                  SystemNavigator.pop();
                                } else {
                                  exit(0);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0.0,
      title: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Transform(
          transform: Matrix4.translationValues(-18.0, 0.0, 0.0),
          child: Text('AppBar Demo'),
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget boxImage() {
    return Scaffold(
      body: Container(
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          image: const DecorationImage(
            image:
                AssetImage("assets/images/technology-background-1632715.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: null,
      ),
    );
  }
}
