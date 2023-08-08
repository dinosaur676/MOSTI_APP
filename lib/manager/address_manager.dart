import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:travel_hour/services/wallet_connect/i_web3wallet_service.dart';
import 'package:travel_hour/services/wallet_connect/web3wallet_service.dart';
import 'package:travel_hour/utils/image_math_util.dart';
import '../models/address.dart';
import 'package:external_path/external_path.dart';

class AddressManager {
  List<Address> _addressList = [];
  String _mainCodeData = "";

  bool _loadMainCode = false;

  Address? _selectedAddress = null;

  bool get isLoadMainCode => _loadMainCode;

  final String _fileName = "address.json";
  final String _jsonWalletTag = "walletTag";
  final String _jsonWalletName = "walletName";
  final String _mainCodeKey = "mnemonic";

  final _storage = new FlutterSecureStorage();

  AddressManager() {

  }

  void test() {
    _mainCodeData = "1234567890abedef12345678";
    createAddress("asdfasdf", "aef197");
  }

  int getListLength() {
    return _addressList.length;
  }

  Address? getAddress(int index) {
    if(index >= _addressList.length)
      return null;

    return _addressList[index];
  }

  Address? getSelectedAddress() {
    return _selectedAddress;
  }

  void selectAddress(Address? address) {
    _selectedAddress = address;
  }

  void createAddress(String walletName, String walletTag) {
    _addressList.add(Address(_mainCodeData, walletName, walletTag));
    saveAddress();
    GetIt.instance.get<IWeb3WalletService>().regist(_addressList.last);
  }

  void deleteAddress(String walletName, String walletTag) async {
    for(int i = 0; i < _addressList.length; ++i) {
      Address address = _addressList[i];
      if(address.walletTag == walletTag && address.walletName == walletName) {
        await _storage.delete(key: getAddressKey(i));
        _addressList.removeAt(i);
      }
    }
  }

  void saveAddress() async {

    await _storage.write(key: _mainCodeKey, value: _mainCodeData);

    for(int i = 0; i < _addressList.length; ++i) {

      Map<String, String> jsonWalletMap = {};
      Address address = _addressList[i];

      jsonWalletMap[_jsonWalletName] = address.walletName;
      jsonWalletMap[_jsonWalletTag] = address.walletTag;

      await _storage.write(key: getAddressKey(i), value: jsonEncode(jsonWalletMap));
    }
  }

  Future<void> initMainCode() async {

    if(_loadMainCode)
      return;

    final storage = await _storage.read(key: _mainCodeKey);

    if(storage == null) {
      return;
    }

    _mainCodeData = storage;
    _loadAddress();

    _loadMainCode = true;
  }

  Future<void> createMainCode() async {
    if(_loadMainCode)
      return;

    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if(pickedFile == null)
      _loadMainCode = false;

    Uint8List imageBytes = await pickedFile!.readAsBytes();

    _mainCodeData = hex.encode(stretchList(compressStringBytes(imageBytes, 12)));

    saveAddress();
  }

  void _loadAddress() async {
    int index = 0;
    while(true) {
      String key = getAddressKey(index);

      String? value = await _storage.read(key: key);

      if(value == null)
        break;

      final jsonAddressData = jsonDecode(value);

      String walletName = jsonAddressData[_jsonWalletName];
      String walletTag = jsonAddressData[_jsonWalletTag];

      _addressList.add(Address(_mainCodeData, walletName, walletTag));
      ++index;
    }
  }

  String getAddressKey(int index) {
    return "Address" + index.toString();
  }
}