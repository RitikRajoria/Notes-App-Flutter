import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app_with_bloc/theme/theme.dart';

class AddNotesPage extends StatefulWidget {
  const AddNotesPage({Key? key}) : super(key: key);

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  String? title;
  String? des;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.arrow_back_ios),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey.shade600,
                              ),
                              onPressed: title == null ? addError : add,
                              child: Icon(Icons.save),
                            ),
                          ],
                        ),
                      ),
                      //
                      SizedBox(
                        height: 12,
                      ),
                      //
                      TextFormField(
                        decoration:
                            InputDecoration.collapsed(hintText: "Title"),
                        style: GoogleFonts.lato(
                            fontSize: 32, fontWeight: FontWeight.bold),
                        onChanged: (_val) {
                          title = _val;
                          print(title);
                        },
                      ),
                      //
                      SizedBox(
                        height: 12,
                      ),
                      //
                      Container(
                        height: (size.height) * 0.75,
                        width: double.infinity,
                        child: TextFormField(
                          decoration: InputDecoration.collapsed(
                              hintText: "Note description"),
                          style: GoogleFonts.lato(
                              fontSize: 18, fontWeight: FontWeight.w400),
                          onChanged: (val) {
                            des = val;
                          },
                          maxLines: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void add() {
    //save to db
    print("inside function");
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes');

    var data = {
      'title': title,
      'description': des,
      'created': DateTime.now(),
    };

    ref.add(data).then((value) {
      print("saved data");
      Navigator.of(context).pop();
    });
    //
  }

  void addError() {
    const snackBar = SnackBar(
      content: Text('Fill Title!'),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
