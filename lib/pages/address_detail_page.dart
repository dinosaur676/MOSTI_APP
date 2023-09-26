import 'package:easy_localization/easy_localization.dart';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_hour/manager/address_manager.dart';
import 'package:travel_hour/manager/api_manager.dart';
import 'package:travel_hour/manager/controller_manager.dart';
import 'package:travel_hour/models/address.dart';
import 'package:travel_hour/pages/qr_scan_page.dart';
import 'package:travel_hour/services/wallet_connect/i_web3wallet_service.dart';
import 'package:travel_hour/widgets/wallet_connect/pairing_item.dart';
import 'package:walletconnect_flutter_v2/apis/web3wallet/web3wallet.dart';
import 'package:travel_hour/utils/wallet_connect/constants.dart';
import 'package:travel_hour/widgets/wallet_connect/uri_input_popup.dart';

import '../models/api_models/wallet_connect_log.dart';

class AddressDetailPage extends StatefulWidget {
  final Address address;

  const AddressDetailPage({required this.address, Key? key}) : super(key: key);

  @override
  State<AddressDetailPage> createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  final Web3Wallet web3Wallet = GetIt.I<IWeb3WalletService>().getWeb3Wallet();

  @override
  void initState() {
    super.initState();
    GetIt.instance.get<AddressManager>().selectAddress(widget.address);
  }

  @override
  void dispose() {
    super.dispose();
    GetIt.instance.get<AddressManager>().selectAddress(null);
  }

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
                //_Header(addressName: widget.address.walletName),
                // Divider(
                //   thickness: 1,
                //   height: 1,
                //   color: Colors.grey,
                // ),
                _SubHeader(address: widget.address),
                Expanded(child: _Body())
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Bottom(
                  address: widget.address,
                  web3Wallet: web3Wallet,
                  onSetState: onSetState,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onSetState() {
    setState(() {

    });
  }
}

class _Header extends StatefulWidget {
  String addressName;

  _Header({required this.addressName, Key? key}) : super(key: key);

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 1, child: Container()),
          Expanded(
            flex: 8,
            child: Text(
              widget.addressName,
              style: TextStyle(fontSize: 28.0),
              textAlign: TextAlign.center,
            ),
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
      ),
    );
  }

  void onTap() {
    Navigator.pop(context);
  }
}

class _SubHeader extends StatelessWidget {
  final Address address;
  late final String publicKey;

  _SubHeader({required this.address, Key? key}) : super(key: key) {
    publicKey = address.getAddressToString()[0].substring(0, 6);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: profile(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.walletName,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  publicKey.substring(0, 6) +
                      "..." +
                      publicKey.substring(
                          publicKey.length - 4, publicKey.length),
                  style: TextStyle(fontSize: 12.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget profile() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: 28),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  dynamic getData;

  @override
  void initState() {
    super.initState();

    String publicKey = GetIt.instance
        .get<AddressManager>()
        .getSelectedAddress()!
        .getAddressToString()[Address.PUBLIC_KEY];
    getData = GetIt.instance.get<APIManager>().POST(
        APIManager.URL_WALLET_CONNECT_LOG,
        getWalletConnectLogSelectParam(publicKey: publicKey));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          }
          // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
          else {
            List list = [];
            if(snapshot.data != null)
              list = snapshot.data;

            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: getList(list));
          }
        });
  }

  Widget getList(List data) {
    if(data == null) {
      return Container();
    }

    List<PairingItem> pairingItems = data.map((e) => PairingItem(
              pairingInfo: e,
    )).toList();


    return ListView.builder(
        itemCount: pairingItems.length,
        itemBuilder: (BuildContext conext, int index) {
          return pairingItems[index];
        });
  }
}

class Bottom extends StatefulWidget {
  final Web3Wallet web3Wallet;
  final Address address;
  final void Function() onSetState;

  const Bottom({
    required this.web3Wallet,
    required this.address,
    required this.onSetState,
    Key? key,
  }) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressedConnectButtonByCopy,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
          child: Text(
            "Connect Copy",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ),
        ElevatedButton(
          onPressed: onPressedConnectButton,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
          child: Text(
            "Connect QR Code",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }

  void onPressedConnectButtonByCopy() {
    GetIt.instance.get<AddressManager>().selectAddress(widget.address);
    _onCopyQrCode();
  }

  void onPressedConnectButton() {
    GetIt.instance.get<AddressManager>().selectAddress(widget.address);
    _onScanQrCode();
  }

  void onPressed() async {
    Map<String, String> param = {};

    param["walletName"] = widget.address.walletName;
    param["walletTag"] = widget.address.walletTag;

    final response = await GetIt.I<APIManager>().DELETE("/api/wallet", param);

    GetIt.I<AddressManager>()
        .deleteAddress(response["walletName"], response["walletTag"]);

    GetIt.I<ControllerManager>().getController("body_account").text = "";

    Navigator.pop(context);
  }

  Future _onCopyQrCode() async {
    final String? uri = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return UriInputPopup();
      },
    );

    _onFoundUri(uri);

    widget.onSetState();
  }

  Future _onScanQrCode() async {
    final String? s = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => QRScanPage(title: "QRScan")));

    _onFoundUri(s);
    widget.onSetState();
  }

  Future _onFoundUri(String? uri) async {
    if (uri != null) {
      try {
        final Uri uriData = Uri.parse(uri);
        await widget.web3Wallet.pair(
          uri: uriData,
        );
      } catch (e) {
        _invalidUriToast();
      }
    } else {
      _invalidUriToast();
    }
  }

  void _invalidUriToast() {
    showToast(
      child: Container(
        padding: const EdgeInsets.all(StyleConstants.linear8),
        margin: const EdgeInsets.only(
          bottom: StyleConstants.magic40,
        ),
        decoration: BoxDecoration(
          color: StyleConstants.errorColor,
          borderRadius: BorderRadius.circular(
            StyleConstants.linear16,
          ),
        ),
        child: const Text(
          'Invalid URI',
          style: StyleConstants.bodyTextBold,
        ),
      ),
      context: context,
    );
  }
}
