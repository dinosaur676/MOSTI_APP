
Map<String, dynamic> getWalletConnectLogInsertParam({
  required String name,
  required String description,
  required String url,
  required String publicKey
}) {
  final param = {
    "name" : name,
    "description": description,
    "url": url,
    "publicKey": publicKey
  };

  return param;
}

Map<String, dynamic> getWalletConnectLogSelectParam({
  required String publicKey
}) {
  final param = {
    "publicKey": publicKey
  };

  return param;
}