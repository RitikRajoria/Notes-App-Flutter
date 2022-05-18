import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_with_bloc/screens/add_note.dart';
import 'package:notes_app_with_bloc/screens/view_note.dart';
import 'package:notes_app_with_bloc/theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');

  @override
  Widget build(BuildContext context) {
    final lightbg = lighten(AppTheme.bgColor);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.replay_outlined),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.black54,
        elevation: 0,
        title: Text(
          "NOTES",
          style: GoogleFonts.lato(
              fontSize: 28, letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: lightbg,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNotesPage()))
              .then((value) {
            setState(() {});
          });
        },
        child: Icon(
          Icons.add_rounded,
          color: Colors.black,
          size: 30,
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot>(
          future: ref.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Random random = new Random();
                    Color cardbg = AppTheme.cardsColor[random.nextInt(8)];
                    Map data = snapshot.data!.docs[index].data() as Map;
                    DateTime dateTime = data['created'].toDate();
                    String formattedTime =
                        DateFormat.yMMMd().add_jm().format(dateTime);
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => ViewNotePage(
                                      bgColor: cardbg,
                                      data: data,
                                      time: formattedTime,
                                      ref: snapshot
                                          .data!.docs[index].reference)))
                              .then((value) {
                            setState(() {});
                          });
                        },
                        child: Card(
                          color: cardbg,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data['title']}",
                                  style: GoogleFonts.lato(
                                      color: Colors.black87,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                //
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    child: Text(
                                      formattedTime,
                                      style: GoogleFonts.telex(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Text("loading..."),
              );
            }
          },
        ),
      ),
    );
  }

  Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
