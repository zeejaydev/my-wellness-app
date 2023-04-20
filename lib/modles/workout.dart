class Workout {
  String? docUid;
  String name;
  String type;
  int reps;
  int sets;
  int dist;
  int duration;
  String distanceType;
  String durationType;
  int weight;
  Workout(
      {this.docUid,
      this.name = "",
      this.type = "",
      this.reps = 0,
      this.dist = 0,
      this.duration = 0,
      this.durationType = "",
      this.distanceType = "",
      this.sets = 0,
      this.weight = 0});

  Workout.fromJson(Map<String, dynamic> json, String id)
      : this(
            docUid: id,
            name: json['name'] ?? "",
            type: json['type'] ?? "",
            reps: json['reps'] ?? 0,
            dist: json['dist'] ?? 0,
            duration: json['duration'] ?? 0,
            sets: json['sets'] ?? 0,
            distanceType: json['distanceType'] ?? "",
            durationType: json['durationType'] ?? "",
            weight: json['weight'] ?? 0);

  Map<String, Object?> toJson() {
    return {
      'docId': docUid,
      'name': name,
      'type': type,
      'reps': reps,
      'dist': dist,
      'duration': duration,
      'sets': sets,
      'distanceType': distanceType,
      'durationType': durationType,
      'weight': weight
    };
  }
}
