import 'dart:math';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_with_bloc/auth/google_auth.dart';
import 'package:notes_app_with_bloc/screens/add_note.dart';
import 'package:notes_app_with_bloc/screens/view_note.dart';
import 'package:notes_app_with_bloc/theme/theme.dart';
import 'package:provider/provider.dart';

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
        leading: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh_outlined)),
        actions: [
          IconButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logOut(context);
            },
            icon: Icon(Icons.logout_outlined),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            //
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (snapshot.hasData && snapshot.data.docs.length != 0) {
              //

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    Random random = new Random();
                    Color cardbg = AppTheme.cardsColor[random.nextInt(8)];
                    Map data = snapshot.data!.docs[index].data() as Map;
                    DateTime dateTime = data['created'].toDate();
                    String formattedTime =
                        DateFormat.yMMMd().add_jm().format(dateTime);
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => ViewNotePage(
                                    bgColor: cardbg,
                                    data: data,
                                    time: formattedTime,
                                    ref: snapshot.data!.docs[index].reference)))
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: cardbg,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
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
                              SizedBox(height: 8),
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
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Notes Yet!",
                      style: GoogleFonts.lato(
                          fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                    //
                    SizedBox(
                      height: 3,
                    ),
                    //
                    Text(
                      "Add notes by tapping on plus button.",
                      style: GoogleFonts.lato(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
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
