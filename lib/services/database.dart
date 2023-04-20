import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simplii_fitness/modles/workout.dart';
import 'package:simplii_fitness/services/auth.dart';

class DatabaseService {
  final Stream<QuerySnapshot> exerciseStream =
      FirebaseFirestore.instance.collection('exercises').snapshots();

  final CollectionReference socialCollection =
      FirebaseFirestore.instance.collection('Social');

  Workout? deletedWorkout;
  Future updateUserData(String name, String picUrl, String uid) async {
    return await socialCollection
        .doc(uid)
        .set({"name": name, "picUrl": picUrl, "uid": uid}).catchError(
            (error) => print(error));
  }

  Future createWorkoutCollection(String uuid, Workout workout,
      String defalutDistance, String defaultDuration) async {
    return await FirebaseFirestore.instance
        .collection('Social')
        .doc(uuid)
        .collection('userWorkouts')
        .doc()
        .set({
      "name": workout.name,
      "duration": workout.duration,
      "reps": workout.reps,
      "sets": workout.sets,
      "dist": workout.dist,
      "type": workout.type,
      "weight": workout.weight,
      "distanceType": workout.distanceType.isNotEmpty
          ? workout.distanceType
          : defalutDistance,
      "durationType": workout.durationType.isNotEmpty
          ? workout.durationType
          : defaultDuration,
      "createdAt": FieldValue.serverTimestamp()
    });
  }

  Future updateCardioWorkout(
      String docUid, int dist, int duration, String userUid) async {
    return await FirebaseFirestore.instance
        .collection('Social')
        .doc(userUid)
        .collection('userWorkouts')
        .doc(docUid)
        .update({
      "dist": dist,
      "duration": duration,
    });
  }

  Future updateLiftWorkout(
      String docUid, int sets, int reps, int weight, String userUid) async {
    return await FirebaseFirestore.instance
        .collection('Social')
        .doc(userUid)
        .collection('userWorkouts')
        .doc(docUid)
        .update({
      "sets": sets,
      "reps": reps,
      "weight": weight,
    });
  }

  void deleteWorkout(Workout workout, String userUid) {
    deletedWorkout = workout;
    FirebaseFirestore.instance
        .collection('Social')
        .doc(userUid)
        .collection('userWorkouts')
        .doc(workout.docUid)
        .delete();
  }

  void deleteSocialUser(String docId) {
    FirebaseFirestore.instance.collection('Social').doc(docId).delete();
  }
}
