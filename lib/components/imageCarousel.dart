import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final Stream<QuerySnapshot> _videosStream =
      FirebaseFirestore.instance.collection('videos').snapshots();
  final controller = PageController(viewportFraction: 0.8, initialPage: 0);
  int activePage = 0;

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(5),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _videosStream,
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

          return Column(
            children: [
              SizedBox(
                height: 180,
                child: PageView.builder(
                    controller: controller,
                    itemCount: firestoreDocs.length,
                    pageSnapping: true,
                    onPageChanged: (page) {
                      setState(() {
                        activePage = page;
                      });
                    },
                    itemBuilder: (context, pagePosition) {
                      double margin = pagePosition == activePage ? 0 : 20;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                        margin: EdgeInsets.symmetric(horizontal: margin),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                    Colors.black12.withOpacity(0.3),
                                    BlendMode.srcATop),
                                image: NetworkImage(
                                  firestoreDocs[pagePosition]['imageUrl'],
                                ),
                                fit: BoxFit.cover)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: Stack(children: [
                            Positioned(
                                right: 20,
                                top: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: green,
                                      foregroundColor: Colors.black,
                                      shape: const CircleBorder()),
                                  onPressed: () => print('object'),
                                  child: const Icon(Icons.play_arrow),
                                )),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    firestoreDocs[pagePosition]['exerciseName'],
                                    style: GoogleFonts.lato(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    width: 80,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
                                      color: const Color(0xffFFFFFF)
                                          .withOpacity(0.8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Icon(
                                            Icons.whatshot_outlined,
                                            size: 14,
                                          ),
                                        ),
                                        Text(
                                          firestoreDocs[pagePosition]
                                                  ['calories'] +
                                              ' Cal',
                                          style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (firestoreDocs[pagePosition]['duration'] !=
                                      '')
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      width: 70,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                        color: const Color(0xffFFFFFF)
                                            .withOpacity(0.8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Icon(
                                              Icons.timer_outlined,
                                              size: 14,
                                            ),
                                          ),
                                          Text(
                                            firestoreDocs[pagePosition]
                                                ['duration'],
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (firestoreDocs[pagePosition]['reps'] != '')
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      width: 70,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                        color: const Color(0xffFFFFFF)
                                            .withOpacity(0.8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Icon(
                                              Icons.restart_alt_outlined,
                                              size: 14,
                                            ),
                                          ),
                                          Text(
                                            firestoreDocs[pagePosition]['reps'],
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (firestoreDocs[pagePosition]['dest'] != '')
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      width: 70,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                        color: const Color(0xffFFFFFF)
                                            .withOpacity(0.8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Icon(
                                              Icons.directions_run_outlined,
                                              size: 14,
                                            ),
                                          ),
                                          Text(
                                            firestoreDocs[pagePosition]['dest'],
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                ]),
                          ]),
                        ),
                      );
                    }),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicators(firestoreDocs.length, activePage))
            ],
          );
        });
  }
}
