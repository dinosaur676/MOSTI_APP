import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:travel_hour/utils/image_math_util.dart';

class Address {

  static final int PUBLIC_KEY = 0;
  static final int PRIVATE_KEY = 1;

  String walletName;
  String walletTag;
  late final HDWallet hdWallet;
  late final PublicKey publicKey;
  late final PrivateKey privateKey;

  Address(String mainKey, this.walletName, this.walletTag) {
    String hexData = hex.encode(compressString(walletName + walletTag, 4));
    String hdWalletKey = mainKey + hexData;

    hdWallet = HDWallet.createWithData(Uint8List.fromList(hex.decode(hdWalletKey)));
    privateKey = hdWallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum);
    publicKey = privateKey.getPublicKeySecp256k1(false);
  }

  // Address.readJson(String jsonPrivateKey) {
  //   privateKey = PrivateKey.createWithData(Uint8List.fromList(hex.decode(jsonPrivateKey)));
  //   publicKey = privateKey.getPublicKeySecp256k1(false);
  // }

  String getJsonData() {
    return hex.encode(privateKey.data());
  }


  List<String> getAddressToString() {
    List<String> output = [];

    AnyAddress anyAddress = AnyAddress.createWithPublicKey(publicKey, TWCoinType.TWCoinTypeEthereum);
    output.add(anyAddress.description());
    output.add(hex.encode(privateKey.data()));

    return output;
  }
}