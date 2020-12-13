import 'package:AppSynergy_Chat_app/helper/constants.dart';
import 'package:AppSynergy_Chat_app/services/database.dart';
import 'package:AppSynergy_Chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  const ConversationScreen({Key key, this.chatRoomId}) : super(key: key);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController _messageController = new TextEditingController();
  Stream chatMessagesStream;

  void initState() {
    super.initState();
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
  }

  Widget chatMessagesList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  // String data = snapshot.data.docs[index].data()['message'];
                  return MessageTile(
                    message: snapshot.data.docs[index].data()['message'],
                    isSendByMe: snapshot.data.docs[index].data()['sendBy'] ==
                        Constants.myname,
                  );
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': _messageController.text,
        'sendBy': Constants.myname,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      _messageController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Stack(
        children: [
          chatMessagesList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.grey[600],
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: simpleTextFieldColor(),
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle:
                            TextStyle(color: Colors.white70, fontSize: 17),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey[600],
                              Colors.grey,
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.all(13),
                      child: Image.asset(
                        'assets/images/send.png',
                      ),
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

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  const MessageTile({Key key, this.message, this.isSendByMe}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [Color(0xff007EF4), Color(0xff2A75BC)]
                    : [Color(0x1AFFFFFF), Color(0X1AFFFFFF)]),
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  )),
        child: Text(
          message,
          style: mediumTextStyle(),
        ),
      ),
    );
  }
}
