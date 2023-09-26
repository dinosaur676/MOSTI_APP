import 'package:flutter/material.dart';

class BedgeDetailPage extends StatefulWidget {
  final int tokenId;
  final String metaData;

  const BedgeDetailPage(
      {Key? key, required this.metaData, required this.tokenId})
      : super(key: key);

  @override
  State<BedgeDetailPage> createState() => _BedgeDetailPageState();
}

class _BedgeDetailPageState extends State<BedgeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "tokenId : ${widget.tokenId}",
            style: TextStyle(
              fontSize: 28.0
            ),
          ),
          Text(
            "metaData : ${widget.metaData}",
            style: TextStyle(
                fontSize: 28.0
            ),
          ),
        ],
      ),
    );
  }
}
