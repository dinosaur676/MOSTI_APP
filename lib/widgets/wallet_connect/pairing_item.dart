import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class PairingItem extends StatefulWidget {
  const PairingItem({
    Key? key,
    required this.pairingInfo,
  });

  final Map pairingInfo;

  @override
  State<PairingItem> createState() => _PairingItemState();
}

class _PairingItemState extends State<PairingItem> {
  @override
  Widget build(BuildContext context) {

    String time = widget.pairingInfo["time"];
    String url = widget.pairingInfo["url"];
    String name = widget.pairingInfo["name"];

    return ListTile(
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(url),
          Text('연결 시간: $time'),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 20.0),
      onTap: onTap,
    );
  }

  void onTap() {
    String time = widget.pairingInfo["time"];
    String url = widget.pairingInfo["url"];
    String name = widget.pairingInfo["name"];
    String description = widget.pairingInfo["description"];

    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text(name),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(description),
              Text(url),
              Text(time),
            ],
          ),
        ),
        actions: [
          TextButton(child: Text("확인"), onPressed: () {
            Navigator.of(context).pop();
          }),
        ],
      );
    });
  }
}
