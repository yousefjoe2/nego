import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Myorders extends StatelessWidget {
  String user_id;
  Myorders(this.user_id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(9),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('orderedbyid', isEqualTo: user_id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text("loading");
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, num) {
                  DocumentSnapshot ds = snapshot.data.documents[num];

                  return Container(
                    child: Column(
                      children: [
                        Text('title: ${ds.data()['title']}'),
                        Text('name: ${ds.data()['orderedbyname']}'),
                        CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                              ds.data()['image'],
                            )),
                        Divider(color: Colors.black)
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
