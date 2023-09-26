import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_hour/config/config.dart';
import 'package:travel_hour/manager/address_manager.dart';
import 'package:travel_hour/manager/keycloak_manager.dart';
import 'package:travel_hour/pages/bedge_home_page.dart';
import 'package:travel_hour/pages/notice_page.dart';
import 'package:travel_hour/pages/address_home_page.dart';
import 'package:travel_hour/pages/mint_wait.dart';
import 'package:travel_hour/pages/profile.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/address.dart';
import '../widgets/featured_places.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  List<IconData> iconList = [
    Feather.home,
    Feather.grid,
    Icons.list,
    Icons.notifications,
    Feather.user
  ];

  void onTabTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(index,
        curve: Curves.easeIn, duration: Duration(milliseconds: 300));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    //context.read<AdsBloc>().dispose();
    super.dispose();
  }

  Future _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      _pageController.animateToPage(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      await SystemChannels.platform
          .invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onWillPop(),
      child: Scaffold(
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          activeColor: Theme.of(context).primaryColor,
          gapLocation: GapLocation.none,
          activeIndex: _currentIndex,
          inactiveColor: Colors.grey[500],
          splashColor: Theme.of(context).primaryColor,
          //blurEffect: true,
          iconSize: 22,
          onTap: (index) => onTabTapped(index),
        ),
        body: Column(
          children: [
            Expanded(
              child: _HomeHeader(onRefresh: onRefresh),
              flex: 2,
            ),
            Expanded(
              flex: 8,
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  AddressDetailHomePage(),
                  BedgeHomePage(),
                  MintWaitPage(),
                  NoticePage(),
                  ProfilePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void test(int index) {
    GetIt.instance.get<Keycloak>().endSession();
  }

  void onRefresh() {
    setState(() {

    });
  }
}

class _HomeHeader extends StatefulWidget {
  final VoidCallback onRefresh;

  const _HomeHeader({Key? key, required this.onRefresh}) : super(key: key);

  @override
  State<_HomeHeader> createState() => _HeaderState();
}

class _HeaderState extends State<_HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Config().appName,
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Muli',
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[800]),
                    ),
                    Text(
                      'school name',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]),
                    ).tr()
                  ],
                ),
                Spacer(),
                InkWell(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, size: 28),
                  ),
                  onTap: onTap,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 5, right: 5),
              padding: EdgeInsets.only(left: 15, right: 15),
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[300]!, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: <Widget>[
                  GetIt.instance.get<AddressManager>().getSelectedAddress() !=
                          null
                      ? Text(GetIt.instance
                          .get<AddressManager>()
                          .getSelectedAddress()!
                          .walletName)
                      : Text("지갑을 선택해 주시길 바랍니다.")
                ],
              ),
            ),
            onTap: onPressAddressTextButton,
          ),
        ],
      ),
    );
  }

  void onPressAddressTextButton() async {
    final addressIndex = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (_) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Featured(),
          );
        });

    Address? address;

    if (addressIndex != null)
      address = GetIt.instance.get<AddressManager>().getAddress(addressIndex);

    if (address != null) {
      GetIt.instance.get<AddressManager>().selectAddress(address);
      widget.onRefresh();
    }
  }

  void onTap() async {

  }
}
