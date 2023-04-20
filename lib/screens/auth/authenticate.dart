import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplii_fitness/components/Button.dart';
import 'package:simplii_fitness/services/auth.dart';
import 'package:simplii_fitness/styles.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/main-pic.png"), fit: BoxFit.cover)),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: loading
                ? BoxDecoration(color: translucentBlack(0.5))
                : BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.2, 0.7],
                        colors: [Colors.white, translucentWhite(0.0)])),
            child: SafeArea(
              child: Stack(children: [
                if (loading)
                  const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Wellness App',
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900)),
                              textAlign: TextAlign.center,
                            ),
                            CustomButton(
                              disabled: loading,
                              buttonTitle: "CONTINUE AS GUEST",
                              backgroundColor: Colors.black87,
                              textColor: Colors.white,
                              splashFactory: NoSplash.splashFactory,
                              onPress: () {
                                setState(() {
                                  loading = true;
                                });
                                _auth.signInAnon().then((value) {
                                  if (value == null) {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                });
                              },
                              height: 50,
                            ),
                            CustomButton(
                                disabled: loading,
                                buttonTitle: "SIGN WITH GOOGLE",
                                backgroundColor: Colors.black87,
                                textColor: Colors.white,
                                onPress: _auth.signInWithGmail,
                                height: 50)
                          ]),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
