import 'package:flutter/material.dart';

class StudentIdAddPage extends StatefulWidget {
  const StudentIdAddPage({Key? key}) : super(key: key);

  @override
  State<StudentIdAddPage> createState() => _StudentIdAddPageState();
}

class _StudentIdAddPageState extends State<StudentIdAddPage> {
  List<TextEditingController> ctlList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "학생증 추가",
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getInput("이름"),
              getInput("학번"),
              getInput("학과"),
              getInput("검증 주소"),
              SizedBox(
                height: 16.0,
              ),
              TextButton(onPressed: getPicture, child: Text("사진 추가")),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[500]),
                onPressed: createIDCard,
                child: Text(
                  "추가",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void createIDCard() {}

  void getPicture() {}

  Widget getInput(String label) {
    ctlList.add(TextEditingController());

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
            ],
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: TextFormField(
                  controller: ctlList.last,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(),
              )
            ],
          ),
        )
      ],
    );
  }
}
