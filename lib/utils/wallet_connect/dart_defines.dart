class DartDefines {
  static const String projectId = String.fromEnvironment(
    'PROJECT_ID',
    defaultValue: "d3f8d382062e6bb8b779a431cf045d95",
  );
  static const String kadenaPrivateKey = String.fromEnvironment(
    'KADENA_PRIVATE_KEY',
    defaultValue:
        '7d54a79feeb95ac4efdc6cfd4b702da5ee5dc1c31781b76ea092301c266e2451',
  );
  static const String kadenaPublicKey = String.fromEnvironment(
    'KADENA_PUBLIC_KEY',
    defaultValue:
        'af242a8d963f184eca742271a5134ee3d3e006f0377d667510e15f6fc18e41d9',
  );
}
