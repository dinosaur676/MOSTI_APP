import 'package:flutter/material.dart';

class StudentIDDetailPage extends StatefulWidget {
  final bool isCheck;
  const StudentIDDetailPage({Key? key, required this.isCheck}) : super(key: key);

  @override
  State<StudentIDDetailPage> createState() => _StudentIDDetailPageState();
}

class _StudentIDDetailPageState extends State<StudentIDDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getInput("이름", "홍길동"),
                        getInput("학번", "12345678"),
                        getInput("학과", "컴퓨터 공학과")
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

        if(widget.isCheck)
          Positioned(
            right: 15,
            top: 15,
            child: SizedBox(
              width: 50,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green
                ),
                child: Container(),
              ),
            ),
          )

      ],
    );
  }

  Widget getInput(String label, String value) {
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
              Text(
                value,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
            ],
          ),
        )
      ],
    );
  }
}
