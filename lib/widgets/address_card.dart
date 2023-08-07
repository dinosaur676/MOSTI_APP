import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_hour/manager/address_manager.dart';
import 'package:travel_hour/models/address.dart';

class AddressAddFeaturedCard extends StatefulWidget {
  const AddressAddFeaturedCard({Key? key}) : super(key: key);

  @override
  State<AddressAddFeaturedCard> createState() => _AddressAddFeaturedCardState();
}

class _AddressAddFeaturedCardState extends State<AddressAddFeaturedCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(width: 2.0, color: Colors.black),
      ),
      child: Column(
        children: [
          Text(
            "추가",
            style: TextStyle(fontSize: 28.0),
          ),
        ],
      ),
    );
  }

}

class AddressFeaturedCard extends StatelessWidget {
  final Address address;
  late final String publicAddress;
  late final String privateAddress;

  AddressFeaturedCard({
    required this.address,
    Key? key,
  }) : super(key: key) {
    publicAddress = address.getAddressToString()[0];
    privateAddress = address.getAddressToString()[1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(width: 2.0, color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(address.walletName),
          Text(publicAddress.substring(0, 6) + "..."),
          Text(privateAddress.substring(0, 6) + "..."),
        ],
      ),
    );
  }
}
