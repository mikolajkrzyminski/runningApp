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
  final isSelected = <bool>[false, false, false];
  double _sliderDiscreteValue = 0;

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
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      child: TextField(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: Color(0xFF003259),
                            ),
                            // tekst startowy
                            // controller: TextEditingController(
                            //     text:
                            //         "trening"),
                          decoration: InputDecoration(
                            hintText: "Training",
                            icon: Icon(Icons.edit),
                          ),
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
            Card(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Column(
                  children: <Widget>[
                    Text(
                      "How was it?",
                      style: TextStyle(
                        color: Color(0xFF003259),
                        fontSize: 18,
                      ),
                    ),
                    Divider(
                      color: Colors.grey[900],
                      height: 2,
                    ),
                    SizedBox(height: 20,),
                    Text(
                        "Terrain:",
                    ),
                    SizedBox(height: 10,),
                    ToggleButtons(
                      color: Color(0xFF003259),
                      // kolor wybranego tekstu
                      selectedColor: Color(0xFFFFFFFF),
                      selectedBorderColor: Color(0xFF003259),
                      fillColor: Color(0xFF003259),
                      borderColor: Color(0xFF003259),
                      borderRadius: BorderRadius.circular(10.0),
                      constraints: BoxConstraints(minHeight: 36.0),
                      isSelected: isSelected,
                      onPressed: (index) {
                        // wybór opcji
                        setState(() {
                          for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected[buttonIndex] = !isSelected[buttonIndex];
                            } else {
                              isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35.0),
                          child: Text('TRACK'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35.0),
                          child: Text('ROAD'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35.0),
                          child: Text('TRAIL'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Effort:",
                    ),
                    SizedBox(height: 10,),
                Slider(
                  inactiveColor: Color(0xFFFFFFFF),
                activeColor: Color(0xFF00334E),

                value: _sliderDiscreteValue,
                min: 0,
                max: 10,
                divisions: 9,
                label: _sliderDiscreteValue.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _sliderDiscreteValue = value;
                  });
                },
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
