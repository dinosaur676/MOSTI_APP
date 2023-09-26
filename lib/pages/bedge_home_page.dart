import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_hour/pages/bedge_page.dart';

class BedgeHomePage extends StatefulWidget {
  BedgeHomePage({Key? key}) : super(key: key);

  @override
  _BedgeHomePageState createState() => _BedgeHomePageState();
}

class _BedgeHomePageState extends State<BedgeHomePage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "뱃지 목록",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: BedgePage()),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
