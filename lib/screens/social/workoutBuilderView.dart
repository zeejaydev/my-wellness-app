import 'package:flutter/material.dart';
import 'package:simplii_fitness/modles/workout.dart';
import 'package:simplii_fitness/services/auth.dart';
import 'package:simplii_fitness/styles.dart';

import '../../services/database.dart';

class WorkoutBuilderView extends StatefulWidget {
  final DatabaseService database;
  const WorkoutBuilderView({required this.database, super.key});

  @override
  State<WorkoutBuilderView> createState() => _WorkoutBuilderViewState();
}

class _WorkoutBuilderViewState extends State<WorkoutBuilderView> {
  DatabaseService get _database => widget.database;
  final currentUserUid = AuthService().getCurrentUser()!.uid;
  final _formKey = GlobalKey<FormState>();
  final workout = Workout();

  List<String> types = ["Cardio", "Weight Lifting"];
  Map<String, List<String>> otherTypes = {
    "Cardio-distance": ["Foot", "Mile", "Yard"],
    "Cardio-duration": ["Secound", "Minute", "Hour"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Build your own workout",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: textColor,
        foregroundColor: green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 18, 8, 18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    runSpacing: 18,
                    children: [
                      ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: textColor)),
                              floatingLabelStyle: TextStyle(color: textColor),
                              border: OutlineInputBorder(),
                              labelText: "Workout Type"),
                          items: types
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: ((value) {
                            setState(() {
                              workout.type = value.toString();
                            });
                          }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please chose workout type';
                            }
                            return null;
                          },
                        ),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autocorrect: false,
                        onChanged: ((value) {
                          workout.name = value.toString();
                        }),
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: textColor)),
                            floatingLabelStyle:
                                const TextStyle(color: textColor),
                            border: const OutlineInputBorder(),
                            labelText: 'Workout Name',
                            hintText: workout.type == "Cardio"
                                ? "Running"
                                : "Bench Press"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter workout name';
                          }
                          return null;
                        },
                      ),
                      if (workout.type != "")
                        Wrap(
                          spacing: 8,
                          children: [
                            SizedBox(
                              width: workout.type == "Cardio"
                                  ? 150
                                  : double.infinity,
                              child: TextFormField(
                                maxLength: 3,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                autocorrect: false,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.isEmpty) return;
                                  if (workout.type == "Cardio") {
                                    workout.dist = int.parse(value);
                                  }
                                  if (workout.type == "Weight Lifting") {
                                    workout.sets = int.parse(value);
                                  }
                                },
                                decoration: InputDecoration(
                                    counterText: '',
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: textColor)),
                                    floatingLabelStyle:
                                        const TextStyle(color: textColor),
                                    border: const OutlineInputBorder(),
                                    labelText: workout.type == "Cardio"
                                        ? "Distance"
                                        : "Sets",
                                    hintText:
                                        workout.type == "Cardio" ? "1" : "3"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return workout.type == "Cardio"
                                        ? "Please enter distance"
                                        : "Please enter sets";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            if (workout.type == "Cardio")
                              SizedBox(
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width - 175,
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButtonFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: textColor)),
                                          floatingLabelStyle:
                                              const TextStyle(color: textColor),
                                          border: const OutlineInputBorder(),
                                          labelText: workout.type == "Cardio"
                                              ? "Distance Type"
                                              : "Duration Type"),
                                      value: otherTypes[
                                          "${workout.type}-distance"]![0],
                                      items: otherTypes[
                                              "${workout.type}-distance"]!
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: ((value) {
                                        setState(() {
                                          if (value == null || value.isEmpty)
                                            return;
                                          if (workout.type == "Cardio") {
                                            workout.distanceType = value;
                                          }
                                          if (workout.type ==
                                              "Weight Lifting") {
                                            workout.durationType = value;
                                          }
                                        });
                                      }),
                                    ),
                                  )),
                          ],
                        ),
                      if (workout.type == "Cardio")
                        Wrap(
                          spacing: 8,
                          children: [
                            SizedBox(
                              width: 150,
                              child: TextFormField(
                                maxLength: 3,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                autocorrect: false,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.isEmpty) return;
                                  if (workout.type == "Cardio") {
                                    workout.duration = int.parse(value);
                                  }
                                },
                                decoration: const InputDecoration(
                                    counterText: '',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: textColor)),
                                    floatingLabelStyle:
                                        TextStyle(color: textColor),
                                    border: OutlineInputBorder(),
                                    labelText: "Duration",
                                    hintText: "10"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter duration";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                                height: 60,
                                width: MediaQuery.of(context).size.width - 175,
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButtonFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: textColor)),
                                        floatingLabelStyle:
                                            TextStyle(color: textColor),
                                        border: OutlineInputBorder(),
                                        labelText: "Duration Type"),
                                    value: otherTypes[
                                        "${workout.type}-duration"]![0],
                                    items:
                                        otherTypes["${workout.type}-duration"]!
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: ((value) {
                                      setState(() {
                                        if (value == null || value.isEmpty)
                                          return;
                                        if (workout.type == "Cardio") {
                                          workout.durationType = value;
                                        }
                                      });
                                    }),
                                  ),
                                )),
                          ],
                        ),
                      if (workout.type == "Weight Lifting")
                        TextFormField(
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autocorrect: false,
                          onChanged: ((value) {
                            if (value == "") {
                              workout.reps = 0;
                            } else {
                              workout.reps = int.parse(value);
                            }
                          }),
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: textColor)),
                              floatingLabelStyle: TextStyle(color: textColor),
                              border: OutlineInputBorder(),
                              labelText: 'Reps',
                              hintText: "12"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter number of reps';
                            }
                            return null;
                          },
                        ),
                      if (workout.type == "Weight Lifting")
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          onChanged: ((value) {
                            if (value == "") {
                              workout.weight = 0;
                            } else {
                              workout.weight = int.parse(value);
                            }
                          }),
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: textColor)),
                              floatingLabelStyle: TextStyle(color: textColor),
                              border: OutlineInputBorder(),
                              labelText: 'Weight',
                              hintText: "25 Lb"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter weight';
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: green),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          _database.createWorkoutCollection(
                              currentUserUid,
                              workout,
                              workout.type == "Cardio"
                                  ? otherTypes["${workout.type}-distance"]![0]
                                  : "",
                              workout.type == "Cardio"
                                  ? otherTypes["${workout.type}-duration"]![0]
                                  : "");
                        }
                      },
                      child: Text(
                        "Create Workout",
                        style: subTitle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
