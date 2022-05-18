import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app_with_bloc/theme/theme.dart';

class ViewNotePage extends StatefulWidget {
  final Color bgColor;
  final Map data;
  final String time;
  final DocumentReference ref;

  const ViewNotePage(
      {Key? key,
      required this.bgColor,
      required this.data,
      required this.time,
      required this.ref})
      : super(key: key);

  @override
  State<ViewNotePage> createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DateTime time = DateTime.now();

  FocusNode titleFocus = FocusNode();
  FocusNode desFocus = FocusNode();

  @override
  void initState() {
    titleController.text = widget.data['title'];
    descriptionController.text =
        widget.data['description'] != null ? widget.data['description'] : "";
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color darkbg = darken(widget.bgColor, .4);

    return Scaffold(
      backgroundColor: widget.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(width: 2, color: darkbg),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: update,
                                    icon: Icon(Icons.arrow_back_ios,
                                        color: darkbg),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
                      SizedBox(
                        height: 8,
                      ),
                      //
                      TextField(
                        focusNode: titleFocus,
                        controller: titleController,
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                        decoration:
                            InputDecoration.collapsed(hintText: "Title"),
                        maxLines: 1,
                      ),
                      //
                      SizedBox(
                        height: 10,
                      ),
                      //
                      Container(
                        width: double.infinity,
                        child: Text(
                          "${widget.time}",
                          style: GoogleFonts.lato(
                              color: darkbg,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      //
                      SizedBox(
                        height: 12,
                      ),
                      //
                      Container(
                        height: (size.height) * 0.675,
                        width: double.infinity,
                        child: TextField(
                          focusNode: desFocus,
                          controller: descriptionController,
                          style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration.collapsed(
                              hintText: "Note description"),
                          maxLines: 23,
                        ),
                      ),
                      //
                      SizedBox(
                        height: 8,
                      ),
                      //
                      Container(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: darkbg,
                          ),
                          onPressed: delete,
                          child: Text("DELETE"),
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

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  void delete() async {
    //delete from db

    await widget.ref.delete();
    Navigator.of(context).pop();
  }

  void update() async {
    const snackBar = SnackBar(
      content: Text('Title can\'t be Empty'),
      duration: Duration(seconds: 3),
    );

    // updating to db
    if (titleController.text.isNotEmpty) {
      var data = {
        'title': titleController.text,
        'description': descriptionController.text,
        'created': time,
      };
      await widget.ref.update(data);
      //
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
