import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplii_fitness/modles/workout.dart';
import 'package:simplii_fitness/services/database.dart';
import 'package:simplii_fitness/styles.dart';

class CardioWorkoutEditor extends StatefulWidget {
  final DatabaseService database;
  final Workout workout;
  final bool canEdit;
  final String currentUserId;
  const CardioWorkoutEditor(
      {required this.workout,
      required this.canEdit,
      required this.database,
      required this.currentUserId,
      super.key});

  @override
  State<CardioWorkoutEditor> createState() => _CardioWorkoutEditorState();
}

class _CardioWorkoutEditorState extends State<CardioWorkoutEditor> {
  DatabaseService get _database => widget.database;
  Workout get _workout => widget.workout;
  bool get _canEdit => widget.canEdit;
  String get _currentUserId => widget.currentUserId;
  final TextEditingController _distController = TextEditingController();
  final TextEditingController _durController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _distController.text = _workout.dist.toString();
    _durController.text = _workout.duration.toString();
  }

  void _distancePlus() {
    int value = int.parse(_distController.text);
    setState(() {
      _distController.text = (value + 1).toString();
    });
  }

  void _distanceMin() {
    int value = int.parse(_distController.text);
    if (value == 0) return;
    setState(() {
      _distController.text = (value - 1).toString();
    });
  }

  void _durPlus() {
    int value = int.parse(_durController.text);
    setState(() {
      _durController.text = (value + 1).toString();
    });
  }

  void _durMin() {
    int value = int.parse(_durController.text);
    if (value == 0) return;
    setState(() {
      _durController.text = (value - 1).toString();
    });
  }

  void _save() {
    _database.updateCardioWorkout(
        _workout.docUid!,
        int.parse(_distController.text),
        int.parse(_durController.text),
        _currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _workout.distanceType != "Foot"
                  ? Text(
                      _workout.distanceType +
                          (_workout.distanceType != "" &&
                                  int.parse(_distController.text) > 1
                              ? "s"
                              : ""),
                      textAlign: TextAlign.center,
                      style: subTitle,
                    )
                  : Text(
                      _workout.distanceType != "" &&
                              int.parse(_distController.text) > 1
                          ? "Feet"
                          : _workout.distanceType,
                      textAlign: TextAlign.center,
                      style: subTitle,
                    )),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: textColor, shadowColor: Colors.white),
                  onPressed: _canEdit ? _distancePlus : null,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 180,
                  child: TextFormField(
                    enabled: _canEdit,
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    controller: _distController,
                    onChanged: (value) {
                      setState(() {
                        if (value == "") {
                          _distController.text = "0";
                        } else {
                          _distController.text = value;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none, counterText: ''),
                    textAlign: TextAlign.center,
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: textColor, shadowColor: Colors.white),
                  onPressed: !_canEdit ? null : _distanceMin,
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  )),
            ],
          ),
          Text(
            _workout.durationType +
                (_workout.durationType != "" &&
                        int.parse(_durController.text) > 1
                    ? "s"
                    : ''),
            textAlign: TextAlign.center,
            style: subTitle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: textColor, shadowColor: Colors.white),
                  onPressed: _canEdit ? _durPlus : null,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 180,
                  child: TextFormField(
                    enabled: _canEdit,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    controller: _durController,
                    onChanged: (value) {
                      setState(() {
                        if (value == "") {
                          _durController.text = "0";
                        } else {
                          _durController.text = value;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none, counterText: ''),
                    textAlign: TextAlign.center,
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: textColor, shadowColor: Colors.white),
                  onPressed: _canEdit ? _durMin : null,
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  )),
            ],
          ),
          if (_canEdit)
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: textColor, shadowColor: Colors.white),
                onPressed:
                    int.parse(_durController.text) != _workout.duration ||
                            int.parse(_distController.text) != _workout.dist
                        ? _save
                        : null,
                child: Text(
                  "SAVE",
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w800, color: Colors.white),
                ))
        ],
      ),
    );
  }
}
