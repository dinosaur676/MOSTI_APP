import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_hour/manager/address_manager.dart';
import 'package:travel_hour/manager/api_manager.dart';
import 'package:travel_hour/models/address.dart';
import 'package:travel_hour/widgets/featured_places.dart';

class MintWaitPage extends StatefulWidget {
  const MintWaitPage({Key? key}) : super(key: key);

  @override
  State<MintWaitPage> createState() => _MintWaitPageState();
}

class _MintWaitPageState extends State<MintWaitPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDatas(),
      builder: (context, snapshot) {

        if(!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        List listData = snapshot.data as List;
       
        return ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(8),
          itemCount: listData.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async => onTap(listData[index]["tokenId"]),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  color: Colors.white
                ),
                child: Center(
                  child: Text(
                    "tokenId : ${listData[index]["tokenId"]} "
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }

  void onTap(int tokenId) async {
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

    if(address != null) {
      Map param = {
        "address" : address.getAddressToString()[Address.PUBLIC_KEY],
        "walletName" : address.walletName,
        "walletTag" : address.walletTag,
        "tokenId" : tokenId
      };

      await GetIt.instance.get<APIManager>().POST(APIManager.URL_TOKEN + "/user", param);
    }
  }
  
  Future<List> getDatas() async {
    return await GetIt.instance.get<APIManager>().GET(APIManager.URL_TOKEN + "/wait");
  }
}
