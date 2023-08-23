import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatyy/helper/my_date_util.dart';
import 'package:chatyy/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

// for view of Profile
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // hide the key bord
      child: Scaffold(
          // app bar
          appBar: AppBar(title: Text(widget.user.name)),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Joined On: ',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
              Text(
                  MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt,
                      showYear: true),
                  style: TextStyle(color: Colors.blue, fontSize: 16)),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for set image sapcing
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  SizedBox(height: mq.height * .03),
                  // fatching email
                  Text(widget.user.email,
                      style: TextStyle(color: Colors.blue, fontSize: 16)),

                  SizedBox(height: mq.height * .02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('About: ',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                      Text(widget.user.about,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
