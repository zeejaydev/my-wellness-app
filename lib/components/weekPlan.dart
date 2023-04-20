import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simplii_fitness/services/database.dart';
import 'package:simplii_fitness/styles.dart';

class WeekPlan extends StatefulWidget {
  const WeekPlan({super.key});

  @override
  State<WeekPlan> createState() => _WeekPlanState();
}

class _WeekPlanState extends State<WeekPlan> {
  final DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: database.exerciseStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SafeArea(
                child: Center(
              child: Text('Something went wrong'),
            ));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SafeArea(
                child: Center(
              child: CircularProgressIndicator(),
            ));
          }
          List<DocumentSnapshot> firestoreDocs =
              snapshot.data?.docs as List<DocumentSnapshot>;

          double displayHeight = MediaQuery.of(context).size.height;
          double height = Platform.isIOS
              ? MediaQuery.of(context).size.height - 370
              : MediaQuery.of(context).size.height - 327;
          return Container(
            constraints: BoxConstraints(maxHeight: height),
            child: ListView.builder(
              itemCount: firestoreDocs.length,
              padding: EdgeInsets.fromLTRB(12, 0, 12, displayHeight * .10),
              itemBuilder: ((context, index) {
                return Container(
                  height: 120,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    firestoreDocs[index]['imageUrl'],
                                  )))),
                      SizedBox(
                        height: 100,
                        width: 210,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firestoreDocs[index]['name'].toString(),
                              style: subTitle,
                            ),
                            Text(firestoreDocs[index]['description']),
                            const LinearProgressIndicator(
                              minHeight: 14,
                              value: .5,
                              backgroundColor: background,
                              color: green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }
}
