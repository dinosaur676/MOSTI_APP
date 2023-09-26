import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_hour/manager/address_manager.dart';
import 'package:travel_hour/manager/api_manager.dart';
import 'package:travel_hour/pages/bedge_detail_page.dart';

import '../models/address.dart';

class BedgePage extends StatefulWidget {

  const BedgePage({Key? key}) : super(key: key);

  @override
  State<BedgePage> createState() => _BedgePageState();
}

class _BedgePageState extends State<BedgePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDatas(),
      builder: (context, snapshot) {
        if(!snapshot.hasData || snapshot.connectionState != ConnectionState.done) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        List list = snapshot.data as List;

        return getGridView(list);
      },
    );
  }
  
  Future<List> getDatas() async {
    Address? address = GetIt.instance.get<AddressManager>().getSelectedAddress();
    if(address == null)
      return [];
    else {
      Map param = {
        "walletName" : address.walletName,
        "walletTag" : address.walletTag,
      };

      return await GetIt.instance.get<APIManager>().GET(APIManager.URL_TOKEN + "/user", param: param);
    }

  }
  
  Widget getGridView(List list) {
    
    return GridView.builder(
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1 / 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => onTap(list[index]["tokenId"], list[index]["metaData"]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(width: 1)
              ),
              child: Center(
                child: Image.asset("assets/images/icon.png", fit: BoxFit.fill),
              ),
            ),
          ),
        );
      },
    );
  }

  void onTap(int tokenId, String metaData) {
    showModalBottomSheet(context: context, builder: (context) {
      return BedgeDetailPage(metaData: metaData, tokenId: tokenId);
    });
  }
}
