
import 'package:flutter/material.dart';
import "package:travel_hour/models/notice.dart";

class NoticeDetailPage extends StatefulWidget {
  final Notice notice;
  const NoticeDetailPage({Key? key, required this.notice}) : super(key: key);

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      widthFactor: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("제목"),
            Text(widget.notice.title),
            Text("내용"),
            Text(widget.notice.content)
          ],
        ),
      ),
    );
  }
}
