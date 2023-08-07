import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_hour/manager/address_manager.dart';
import 'package:travel_hour/manager/api_manager.dart';
import 'package:travel_hour/manager/controller_manager.dart';
import 'package:travel_hour/utils/next_screen.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Header(),
                Body(),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Bottom(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: GetIt.I<ControllerManager>().getController("body_account"),
      decoration: InputDecoration(
          hintText: "Account nickname", hintStyle: TextStyle(fontSize: 20.0)),
    );
  }
}

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: Text(
            "Add account",
            style: TextStyle(fontSize: 28.0),
          ).tr(),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20.0,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void onTap() {
    Navigator.pop(context);
  }
}

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text("Add"),
    );
  }

  void onPressed() async {
    String accountName =
        GetIt.I<ControllerManager>().getController("body_account").value.text;

    Map<String, String> param = {};

    param["walletName"] = accountName;

    final response = await GetIt.I<APIManager>().PUT("/api/wallet", param);

    GetIt.I<AddressManager>().createAddress(response["walletName"], response["walletTag"]);

    GetIt.I<ControllerManager>().getController("body_account").text = "";

    Navigator.pop(context);
  }
}
