import 'package:AppSynergy_Chat_app/helper/constants.dart';
import 'package:AppSynergy_Chat_app/services/database.dart';
import 'package:AppSynergy_Chat_app/views/conversationScreen.dart';
import 'package:AppSynergy_Chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController _searchController = new TextEditingController();
  QuerySnapshot searchSnapshot;

  void initiateSearch() {
    databaseMethods
        .getUserbyUsername(_searchController.text.toLowerCase())
        .then(
      (value) {
        setState(() {
          searchSnapshot = value;
        });
      },
    );
  }

  Widget searchTile() {
    if (_searchController.text != Constants.myname) {
      return searchSnapshot != null
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: searchSnapshot.docs.length,
              itemBuilder: (context, index) {
                return searchTileWidget(
                  userName: searchSnapshot.docs[index].data()['name'],
                  userEmail: searchSnapshot.docs[index].data()['email'],
                );
              },
            )
          : Container();
    } else {
      return Container();
    }
  }

  createChatRoomandStartConversation(String userName) {
    String chatRoomId = getChatRoomId(userName, Constants.myname);

    List<String> users = [userName, Constants.myname];
    Map<String, dynamic> chatRoomMap = {
      'users': users,
      'chatRoomId': chatRoomId,
    };

    databaseMethods.createChatRoom(chatRoomId, chatRoomMap);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConversationScreen(chatRoomId: chatRoomId,),
      ),
    );
  }

  Widget searchTileWidget({String userName, String userEmail}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextStyle()),
              const SizedBox(height: 5),
              Text(userEmail, style: mediumTextStyle()),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomandStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                'Message',
                style: mediumTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                color: Colors.grey[600],
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: simpleTextFieldColor(),
                        decoration: InputDecoration(
                          hintText: 'search username...',
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
                        initiateSearch();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
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
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/search_white.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              searchTile(),
            ],
          )),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
