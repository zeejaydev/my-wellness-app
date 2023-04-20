import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simplii_fitness/screens/social/socialUserScreen.dart';
import 'package:simplii_fitness/services/auth.dart';
import 'package:simplii_fitness/services/database.dart';
import 'package:simplii_fitness/styles.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final DatabaseService database = DatabaseService();
  final User? currentUser = AuthService().getCurrentUser();
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Social').snapshots();
  final _formKey = GlobalKey<FormState>();
  String name = '';
  bool _admin = false;
  bool deleteUser = false;
  String userToDelete = "";
  @override
  void initState() {
    super.initState();
    _isAdmin();
  }

  Future _isAdmin() async {
    IdTokenResult? result = await currentUser?.getIdTokenResult();

    if (result != null &&
        result.claims != null &&
        result.claims!.containsKey('admin')) {
      setState(() {
        _admin = true;
      });
    }
  }

  Future<String?> openDialog() async => await showDialog<String?>(
      context: context,
      builder: ((context) => AlertDialog(
            title: deleteUser
                ? const Text("Delete User")
                : const Text("Need your name to join social"),
            content: deleteUser
                ? Text("Are you susre you want to delete $name")
                : Form(
                    key: _formKey,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autocorrect: false,
                      onChanged: ((value) {
                        name = value.toString();
                      }),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    if (deleteUser) {
                      database.deleteSocialUser(userToDelete);
                      name = "";
                      userToDelete = "";
                      Navigator.of(context).pop();
                    } else {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(name);
                      }
                    }
                  },
                  child: deleteUser ? const Text("Yes") : const Text("Join")),
            ],
          )));

  _joinSocial() async {
    if (currentUser != null) {
      String picUrl = currentUser?.photoURL ?? '';
      if (currentUser!.displayName == '' || currentUser!.displayName == null) {
        String? enteredName = await openDialog();
        if (enteredName != null && enteredName != '') {
          database.updateUserData(enteredName, picUrl, currentUser!.uid);
          await currentUser!.updateDisplayName(enteredName);
        }
      } else {
        database.updateUserData(
            currentUser!.displayName!, picUrl, currentUser!.uid);
      }
    } else {
      if (kDebugMode) {
        print(currentUser);
      }
    }
  }

  _deleteUser(String username, String docId) {
    deleteUser = true;
    name = username;
    userToDelete = docId;
    openDialog();
  }

  @override
  Widget build(BuildContext context) {
    bool needsToJoinSocial = false;
    return StreamBuilder(
        stream: _usersStream,
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

          if (snapshot.hasData) {
            bool joinedSocial = snapshot.data!.docs
                .where((doc) => doc.id == currentUser!.uid)
                .isNotEmpty;
            if (joinedSocial) {
              needsToJoinSocial = false;
            } else {
              needsToJoinSocial = true;
            }
          }
          List<DocumentSnapshot> firestoreDocs =
              snapshot.data?.docs as List<DocumentSnapshot>;

          return SafeArea(
            child: Scaffold(
              backgroundColor: background,
              floatingActionButton: needsToJoinSocial
                  ? FloatingActionButton.extended(
                      splashColor: Colors.white,
                      backgroundColor: green,
                      onPressed: _joinSocial,
                      label: const Text(
                        'JOIN',
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.w700),
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: textColor,
                      ),
                    )
                  : null,
              body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: firestoreDocs.isEmpty
                      ? const Center(
                          child:
                              Text("Join social to start motivate each other"))
                      : ListView.builder(
                          itemCount: firestoreDocs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                if (firestoreDocs[index]['uid'] == null ||
                                    firestoreDocs[index]['name'] == null) {
                                  return;
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SocialUserScreen(
                                              database: database,
                                              uuid: firestoreDocs[index]['uid'],
                                              userName: firestoreDocs[index]
                                                  ['name'],
                                              userPic: firestoreDocs[index]
                                                  ['picUrl'],
                                              currentUser: currentUser,
                                            )));
                              },
                              onLongPress: _admin
                                  ? () {
                                      _deleteUser(firestoreDocs[index]['name'],
                                          firestoreDocs[index].id);
                                    }
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    firestoreDocs[index]['picUrl'] != ''
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                firestoreDocs[index]['picUrl']),
                                          )
                                        : const CircleAvatar(
                                            backgroundImage:
                                                AssetImage("assets/user.png"),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            firestoreDocs[index]['name'],
                                            style: subTitle,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
            ),
          );
        });
  }
}
