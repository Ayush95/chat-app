import 'package:AppSynergy_Chat_app/helper/authenticate.dart';
import 'package:AppSynergy_Chat_app/helper/constants.dart';
import 'package:AppSynergy_Chat_app/helper/helperMethods.dart';
import 'package:AppSynergy_Chat_app/services/auth.dart';
import 'package:AppSynergy_Chat_app/services/database.dart';
import 'package:AppSynergy_Chat_app/views/conversationScreen.dart';
import 'package:AppSynergy_Chat_app/views/search.dart';
import 'package:AppSynergy_Chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    Constants.myname = await HelperMethods.getUserNameFromSharedPreference();
    databaseMethods.getChats(Constants.myname).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });
    setState(() {
      _isLoading = false;
    });
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ListTileWidget(
                    chatUser: snapshot.data.docs[index]
                        .data()['chatRoomId']
                        .toString()
                        .replaceAll('_', "")
                        .replaceAll(Constants.myname, ""),
                    chatRoomId: snapshot.data.docs[index].data()['chatRoomId'],
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 45,
            ),
            SizedBox(width: 10),
            Text('AppSynergies')
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              authMethods.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Authenticate(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : chatRoomList(),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.blueGrey,
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Search(),
            ),
          );
        },
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  final String chatUser;
  final String chatRoomId;

  const ListTileWidget({Key key, this.chatUser, this.chatRoomId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
              chatRoomId: chatRoomId,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "${chatUser.substring(0, 1).toUpperCase()}",
                style: mediumTextStyle(),
              ),
            ),
            const SizedBox(width: 15.0),
            Text(
              chatUser,
              style: mediumTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
