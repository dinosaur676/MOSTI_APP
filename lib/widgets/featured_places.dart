import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/manager/address_manager.dart';
import 'package:travel_hour/models/address.dart';
import 'package:travel_hour/pages/address_add.dart';
import 'package:travel_hour/utils/wallet_connect/constants.dart';
import 'package:travel_hour/widgets/address_card.dart';
import 'package:travel_hour/pages/address_detail_page.dart';
import 'package:travel_hour/widgets/wallet_connect/custom_button.dart';

class Featured extends StatefulWidget {
  Featured({Key? key}) : super(key: key);

  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  int addressIndex = 0;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      bottom: true,
      child: Column(
        children: <Widget>[
          Header(),
          Body(),
          SizedBox(
            height: 8,
          ),
          Dot(),
          Expanded(child: Bottom())
        ],
      ),
    );
  }

  void onTapAddressCard(Address address) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (_) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: AddressDetailPage(address: address),
          );
        });
  }

  void onTap() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (_) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: AddAddressPage(),
          );
        });
    setState(() {
      print("setState Test");
    });
  }

  Widget Bottom() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: StyleConstants.successColor
                ),
                onPressed: () {
                  Navigator.pop(
                      context, addressIndex);
                },
                child: Text(
                  "선택",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget Header() {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 15, right: 10, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Text(
            'my avatar',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
                wordSpacing: 1,
                letterSpacing: -0.6),
          ).tr(),
          Spacer(),
        ],
      ),
    );
  }

  Widget Body() {
    double w = MediaQuery.of(context).size.width;

    return Container(
      height: 260,
      width: w,
      child: PageView.builder(
        controller: PageController(initialPage: 0),
        scrollDirection: Axis.horizontal,
        itemCount: GetIt.instance.get<AddressManager>().getListLength() + 1,
        onPageChanged: (index) {
          addressIndex = index;

          print(addressIndex);
        },
        itemBuilder: (BuildContext context, int index) {
          // if(fb.data.isEmpty) return LoadingFeaturedCard();
          // return _FeaturedItemList(d: fb.data[index]);

          if (GetIt.instance.get<AddressManager>().getListLength() == index) {
            return GestureDetector(
                onTap: onTap, child: AddressAddFeaturedCard());
          }

          Address? address =
              GetIt.instance.get<AddressManager>().getAddress(index);

          if (address != null) return AddressFeaturedCard(address: address);
        },
      ),
    );
  }

  Widget Dot() {
    return Center(
      child: DotsIndicator(
        dotsCount: GetIt.instance.get<AddressManager>().getListLength() + 1,
        decorator: DotsDecorator(
          color: Colors.black26,
          activeColor: Colors.black,
          spacing: EdgeInsets.only(left: 6),
          size: const Size.square(5.0),
          activeSize: const Size(20.0, 4.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
