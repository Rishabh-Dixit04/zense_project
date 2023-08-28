import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/app_users.dart';
import 'package:zense_project/detail_tile.dart';

class UserContent extends StatefulWidget {
  const UserContent({super.key});

  @override
  State<UserContent> createState() => _UserContentState();
}

class _UserContentState extends State<UserContent> {
  @override
  Widget build(BuildContext context) {
    final details = Provider.of<List<UserDetails>>(context);

    
    // details.forEach((detail) { 
    //   print(detail.name);
    //   print(detail.account);
    //   print(detail.income);
    //   print(detail.months);
    //   print(detail.categories);
    // });
    
    return ListView.builder(
      itemCount: details.length,
      itemBuilder: (context, index) {
        //return DetailTile(detail: details[index]);
      },
    );
  }
}