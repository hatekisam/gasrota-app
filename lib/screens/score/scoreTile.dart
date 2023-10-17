import 'package:flutter/material.dart';
import 'package:grasrota/models/userscore.dart';

class ScoreTile extends StatelessWidget {
  final UserScore user;
  final int index;
  ScoreTile({required this.user,required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        index.toString(),
        textScaleFactor: 1.0,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: user.profileImg != "" ?
                  NetworkImage(user.profileImg) : const AssetImage("assets/profilePic.png") as ImageProvider,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: RichText(
            overflow: TextOverflow.ellipsis,
            strutStyle: StrutStyle(fontSize: 12.0),
            text: TextSpan(
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
              text: user.name),
            ),
          ),
        ],
      ),
      trailing: Text(
        user.score.toString(),
        textScaleFactor: 1.0,
        style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.cyan
            ),),
    );
  }
}
