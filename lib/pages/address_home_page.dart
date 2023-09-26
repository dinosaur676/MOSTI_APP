import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/manager/address_manager.dart';
import 'package:travel_hour/pages/address_detail_page.dart';

class AddressDetailHomePage extends StatefulWidget {
  AddressDetailHomePage({Key? key}) : super(key: key);

  _AddressDetailHomePageState createState() => _AddressDetailHomePageState();
}

class _AddressDetailHomePageState extends State<AddressDetailHomePage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GetIt.instance.get<AddressManager>().getSelectedAddress() !=
                  null
              ? AddressDetailPage(
                  address: GetIt.instance
                      .get<AddressManager>()
                      .getSelectedAddress()!)
              : nullSelectedAddress(),
        ));
  }

  @override
  bool get wantKeepAlive => true;

  Widget nullSelectedAddress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "지갑을 골라주시길 바랍니다.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w700
              ),
            ),
          ],
        )
      ],
    );
  }
}
