import 'package:flutter/material.dart';
import 'package:travel_hour/pages/student_id_detail_page.dart';

class StudentIDPage extends StatefulWidget {
  const StudentIDPage({Key? key}) : super(key: key);

  @override
  State<StudentIDPage> createState() => _StudentIDPageState();
}

class _StudentIDPageState extends State<StudentIDPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: onDetailButtonPresssed,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "상세 정보",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  void onDetailButtonPresssed() {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext buildContext) {
          return Scaffold(
            body: SafeArea(
              child: FractionallySizedBox(
                heightFactor: 1.0,
                child: StudentIDDetailPage(isCheck: true),
              ),
            ),
          );
        });
  }
}
