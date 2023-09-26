class ProfileManager {
  late final String email;
  late final String name;
  bool _isSigned = false;

  //TODO : nick name?

  ProfileManager(Map jwtMap) {
    email = jwtMap["email"];
    name = jwtMap["name"];
    _isSigned = true;
  }

  bool get isSignedIn => _isSigned;
}