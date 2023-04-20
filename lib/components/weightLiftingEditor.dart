import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplii_fitness/modles/workout.dart';
import 'package:simplii_fitness/services/database.dart';
import 'package:simplii_fitness/styles.dart';

class WeightLiftingEditor extends StatefulWidget {
  final Workout workout;
  final String currentUserId;
  final bool canEdit;
  final DatabaseService database;
  const WeightLiftingEditor(
      {required this.workout,
      required this.currentUserId,
      required this.canEdit,
      required this.database,
      super.key});

  @override
  State<WeightLiftingEditor> createState() => _WeightLiftingEditorState();
}

class _WeightLiftingEditorState extends State<WeightLiftingEditor> {
  Workout get _workout => widget.workout;
  String get _currentUserId => widget.currentUserId;
  bool get _canEdit => widget.canEdit;
  DatabaseService get _database => widget.database;
  late final TextEditingController _setsController = TextEditingController();
  late final TextEditingController _repsController = TextEditingController();
  late final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setsController.text = _workout.sets.toString();
    _repsController.text = _workout.reps.toString();
    _weightController.text = _workout.weight.toString();
  }

  void _setPlus() {
    int value = int.parse(_setsController.text);
    setState(() {
      _setsController.text = (value + 1).toString();
    });
  }

  void _setMinus() {
    int value = int.parse(_setsController.text);
    if (value == 0) return;
    setState(() {
      _setsController.text = (value - 1).toString();
    });
  }

  void _repPlus() {
    int value = int.parse(_repsController.text);
    setState(() {
      _repsController.text = (value + 1).toString();
    });
  }

  void _repMinus() {
    int value = int.parse(_repsController.text);
    if (value == 0) return;
    setState(() {
      _repsController.text = (value - 1).toString();
    });
  }

  void _weightPlus() {
    int value = int.parse(_weightController.text);
    setState(() {
      _weightController.text = (value + 1).toString();
    });
  }

  void _weightMinus() {
    int value = int.parse(_weightController.text);
    if (value == 0) return;
    setState(() {
      _weightController.text = (value - 1).toString();
    });
  }

  void _save() {
    _database.updateLiftWorkout(
        _workout.docUid!,
        int.parse(_setsController.text),
        int.parse(_repsController.text),
        int.parse(_weightController.text),
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
            child: Text(
              "Sets",
              textAlign: TextAlign.center,
              style: subTitle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: textColor, shadowColor: Colors.white),
                  onPressed: _canEdit ? _setMinus : null,
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 180,
                  child: TextFormField(
                    enabled: _canEdit,
                    keyboardType: TextInputType.number,
                    controller: _setsController,
                    maxLength: 3,
                    onChanged: (value) {
                      setState(() {
                        if (value == "") {
                          _setsController.text = "0";
                        } else {
                          _setsController.text = value;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    textAlign: TextAlign.center,
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: textColor, shadowColor: Colors.white),
                  onPressed: _canEdit ? _setPlus : null,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
            ],
          ),
          Text(
            "Reps",
            textAlign: TextAlign.center,
            style: subTitle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: textColor, shadowColor: Colors.white),
                  onPressed: _canEdit ? _repMinus : null,
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 180,
                  child: TextFormField(
                    enabled: _canEdit,
                    keyboardType: TextInputType.number,
                    controller: _repsController,
                    maxLength: 3,
                    onChanged: (value) {
                      setState(() {
                        if (value == "") {
                          _repsController.text = "0";
                        } else {
                          _repsController.text = value;
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
                  onPressed: _canEdit ? _repPlus : null,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
            ],
          ),
          Text(
            "Weight",
            textAlign: TextAlign.center,
            style: subTitle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: textColor, shadowColor: Colors.white),
                  onPressed: _canEdit ? _weightMinus : null,
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 180,
                  child: TextFormField(
                    enabled: _canEdit,
                    keyboardType: TextInputType.number,
                    controller: _weightController,
                    maxLength: 3,
                    onChanged: (value) {
                      setState(() {
                        if (value == "") {
                          _weightController.text = "0";
                        } else {
                          _weightController.text = value;
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
                  onPressed: _canEdit ? _weightPlus : null,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
            ],
          ),
          if (_canEdit)
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: textColor, shadowColor: Colors.white),
                onPressed: int.parse(_setsController.text) != _workout.sets ||
                        int.parse(_repsController.text) != _workout.reps ||
                        int.parse(_weightController.text) != _workout.weight
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
