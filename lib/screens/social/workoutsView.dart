import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplii_fitness/components/cardioWorkoutEditor.dart';
import 'package:simplii_fitness/components/weightLiftingEditor.dart';
import 'package:simplii_fitness/modles/workout.dart';
import 'package:simplii_fitness/services/auth.dart';
import 'package:simplii_fitness/services/database.dart';
import 'package:simplii_fitness/styles.dart';
import 'package:simplii_fitness/utlis.dart';

class WorkoutsView extends StatefulWidget {
  final DatabaseService database;
  final User? currentUser;
  final String uuid;
  final String userPic;
  const WorkoutsView(
      {required this.database,
      required this.currentUser,
      required this.uuid,
      required this.userPic,
      super.key});

  @override
  State<WorkoutsView> createState() => _WorkoutsViewState();
}

class _WorkoutsViewState extends State<WorkoutsView> {
  DatabaseService get _database => widget.database;
  String get _userPic => widget.userPic;
  String get _uuid => widget.uuid;
  late final User? _currentUser = AuthService().getCurrentUser();
  late final bool _canEdit = _currentUser!.uid == _uuid;
  late final Stream<QuerySnapshot> exerciseStream = FirebaseFirestore.instance
      .collection('Social')
      .doc(_uuid)
      .collection('userWorkouts')
      .orderBy("createdAt")
      .snapshots();
  double tileHeight = 90;
  int? expandedItemIndex;

  void _onDelete(Workout workout) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    SnackBar snackBar = SnackBar(
      content: Text("Are you sure you want to delete ${workout.name} ?"),
      duration: const Duration(seconds: 8),
      action: SnackBarAction(
          label: 'CANCEL',
          onPressed: () {
            Workout? deletedWorkout = _database.deletedWorkout;
            if (deletedWorkout != null) {
              _database.createWorkoutCollection(
                  AuthService().getCurrentUser()!.uid,
                  deletedWorkout,
                  deletedWorkout.distanceType,
                  deletedWorkout.durationType);
            }
            if (mounted) {
              setState(() {});
            }
          }),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _database.deleteWorkout(workout, _currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: exerciseStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Workout> workouts = snapshot.data!.docs
              .map((doc) =>
                  Workout.fromJson(doc.data()! as Map<String, dynamic>, doc.id))
              .toList();

          return SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Dismissible(
                          background: Container(
                            color: Colors.red,
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          direction: _canEdit
                              ? DismissDirection.endToStart
                              : DismissDirection.none,
                          dismissThresholds: const {
                            DismissDirection.endToStart: 0.8
                          },
                          onDismissed: (direction) =>
                              _onDelete(workouts[index]),
                          key: UniqueKey(),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (expandedItemIndex == index) {
                                  expandedItemIndex = null;
                                } else {
                                  tileHeight = 120;
                                  expandedItemIndex = index;
                                }
                              });
                            },
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        workouts[index].name.toTitleCase(),
                                        style: subTitle,
                                      ),
                                      const Icon(Icons.arrow_drop_down)
                                    ],
                                  ),
                                  if (expandedItemIndex == index &&
                                      workouts[index].type == "Weight Lifting")
                                    WeightLiftingEditor(
                                        workout: workouts[index],
                                        currentUserId: _currentUser!.uid,
                                        canEdit: _canEdit,
                                        database: _database),
                                  if (expandedItemIndex == index &&
                                      workouts[index].type == "Cardio")
                                    CardioWorkoutEditor(
                                      workout: workouts[index],
                                      currentUserId: _currentUser!.uid,
                                      canEdit: _canEdit,
                                      database: _database,
                                    )
                                ],
                              ),
                            ),
                          )),
                    );
                  },
                )),
          );
        });
  }
}
