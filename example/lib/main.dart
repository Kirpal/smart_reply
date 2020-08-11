import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:smart_reply/smart_reply.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _textController = TextEditingController();
  List<String> _suggestedReplies = [];
  List<TextMessage> _messages = [];
  bool _isLocalUser = true;

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getSuggestedReplies() async {
    SmartReply.suggestReplies(_messages).then((replies) {
      setState(() {
        _suggestedReplies = replies;
      });
    });
  }

  void _sendMessage(String message) {
    setState(() {
      _messages.add(TextMessage(
          text: message,
          timestamp: DateTime.now(),
          userId: _isLocalUser ? 'a' : 'b',
          isLocalUser: _isLocalUser));
      _isLocalUser = !_isLocalUser;
      _textController.clear();
    });

    getSuggestedReplies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Smart reply example'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _messages.length,
                      reverse: true,
                      itemBuilder: (context, i) => Align(
                        alignment: _messages[_messages.length - 1 - i].isLocalUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _messages[_messages.length - 1 - i]
                                        .isLocalUser
                                    ? Colors.grey
                                    : Colors.blue),
                            child: Text(
                              _messages[_messages.length - 1 - i].text,
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            )),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _textController,
                    onSubmitted: _sendMessage,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                        labelText: _isLocalUser ? 'To remote' : 'To local'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    child: Wrap(
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.spaceEvenly,
                      children: [
                        for (var s in _suggestedReplies)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: OutlineButton(
                              child: Text(s),
                              onPressed: () => _sendMessage(s),
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
