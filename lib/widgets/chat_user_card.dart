import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatyy/apis/apis.dart';
import 'package:chatyy/helper/my_date_util.dart';
import 'package:chatyy/main.dart';
import 'package:chatyy/models/chat_user.dart';
import 'package:chatyy/models/message.dart';
import 'package:chatyy/screens/chat_screen.dart';
import 'package:chatyy/widgets/dialogs/profile_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Card to represent single user in Home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // if last message is null

  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
        // color: const Color.fromARGB(255, 171, 181, 190),
        elevation: 0.5,
        margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
        child: InkWell(
            onTap: () {
              // navigate to Chatscreen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(
                            user: widget.user,
                          )));
            },
            child: StreamBuilder(
                stream: APIs.getLastMessage(widget.user),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final list =
                      data?.map((e) => Message.fromJson(e.data())).toList() ??
                          [];
                  if (list.isNotEmpty) {
                    _message = list[0];
                  }

                  return ListTile(
                      // User Profile Picture
                      leading: InkWell(
                        onTap: () {
                          showDialog(context: context, builder: (_) => ProfileDialog(user: widget.user,));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .3),
                          child: CachedNetworkImage(
                            width: mq.height * .055,
                            height: mq.height * .055,
                            imageUrl: widget.user.image,
                            // placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                                    child: Icon(CupertinoIcons.person)),
                          ),
                        ),
                      ),

                      // User Name
                      title: Text(widget.user.name),

                      // Last message
                      subtitle: Text(
                        _message != null
                            ? _message!.type == Type.image
                                ? 'Image'
                                : _message!.msg
                            : widget.user.about,
                        maxLines: 1,
                      ),

                      // Last Message time
                      trailing: _message == null
                          ? null // show nothing when no message
                          : _message!.read.isEmpty &&
                                  _message!.fromid != APIs.user.uid
                              ?
                              // show for unread message
                              Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent.shade400,
                                    borderRadius: BorderRadius.circular(10),
                                  ))
                              : Text(
                                  MyDateUtil.getLastMessageTime(
                                      context: context, time: _message!.sent),
                                  style: TextStyle(color: Colors.black54),
                                ));
                })));
  }
}
