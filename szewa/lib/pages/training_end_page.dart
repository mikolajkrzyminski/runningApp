import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrainingEndPage extends StatefulWidget {
  @override
  _TrainingEndPageState createState() => _TrainingEndPageState();
}

class _TrainingEndPageState extends State<TrainingEndPage> {
  // ustawia tekst startowy
  // controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

// TODO: połącznie z aplikacją

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF003259),
                        ),
                        // tekst startowy
                        controller: TextEditingController(
                            text:
                                "trening"), // ..selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length)),
                      ),
                    ),
                    Container(
                      height: 275,
                      color: Colors.grey[500],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "2:14:36",
                                style: TextStyle(
                                    color: Color(0xFF003259),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 32),
                              ),
                              TextSpan(
                                text: "\nTime",
                                style: TextStyle(
                                    color: Color(0xFF969696),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "5,19",
                                style: TextStyle(
                                    color: Color(0xFF003259),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 32),
                              ),
                              TextSpan(
                                text: "\nDistance (km)",
                                style: TextStyle(
                                    color: Color(0xFF969696),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "5:19",
                                style: TextStyle(
                                    color: Color(0xFF003259),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 32),
                              ),
                              TextSpan(
                                text: "\nAvg Pace",
                                style: TextStyle(
                                    color: Color(0xFF969696),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Note",
                      style: TextStyle(
                        color: Color(0xFF003259),
                        fontSize: 18,
                      ),
                    ),
                    Divider(
                      color: Colors.grey[900],
                      height: 2,
                    ),
                    TextField(
                      maxLength: 200,
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
