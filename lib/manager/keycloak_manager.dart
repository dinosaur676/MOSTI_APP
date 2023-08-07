import 'package:flutter/cupertino.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_hour/manager/jwt_manager.dart';

class Keycloak {
  bool _isBusy = false;
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  String? _codeVerifier;
  String? _codeChallenge;
  String? _nonce;
  String? _authorizationCode;
  String _state ='';

  String? _userInfo;

  final String sourceServer = 'http://localhost:8490/login/oauth2/code/keycloak';

  // For a list of client IDs, go to https://demo.duendesoftware.com
  final String _clientId = 'mosti-dev-mobile-client';
  final String _redirectUrl = 'com.emblock.auth:/oauthredirect';
  final String _postLogoutRedirectUrl = 'com.emblock.auth:/';
  final List<String> _scopes = <String>[
    'openid',
    'profile',
    'email',
/*    'offline_access',
    'api'*/
  ];

  final AuthorizationServiceConfiguration _serviceConfiguration = const AuthorizationServiceConfiguration(
    authorizationEndpoint: 'http://www.mosti-example.com:8443/realms/mosti-dev/protocol/openid-connect/auth',
    tokenEndpoint: 'http://www.mosti-example.com:8443/realms/mosti-dev/protocol/openid-connect/token',
    endSessionEndpoint: 'http://www.mosti-example.com:8443/realms/mosti-dev/protocol/openid-connect/logout',
  );



  Future<bool> signInWithAutoCodeExchange({bool preferEphemeralSession = false}) async {
    try {
      _setBusy();

      /*
        This shows that we can also explicitly specify the endpoints rather than
        getting from the details from the discovery document.
      */
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
            _clientId,
            _redirectUrl,
            serviceConfiguration: _serviceConfiguration,
            scopes: _scopes,
            preferEphemeralSession: preferEphemeralSession,
            allowInsecureConnections: true
        ),
      );

      /*
        This code block demonstrates passing in values for the prompt
        parameter. In this case it prompts the user login even if they have
        already signed in. the list of supported values depends on the
        identity provider

        ```dart
        final AuthorizationTokenResponse result = await _appAuth
        .authorizeAndExchangeCode(
          AuthorizationTokenRequest(_clientId, _redirectUrl,
              serviceConfiguration: _serviceConfiguration,
              scopes: _scopes,
              promptValues: ['login']),
        );
        ```
      */

      if (result != null) {
        _processAuthTokenResponse(result);
        return true;
      }
    } catch (_) {
      _clearBusy();
      return false;
    }

    return false;
  }

  Future<void> endSession() async {
    try {
      _setBusy();

      EndSessionResponse? result = await _appAuth.endSession(EndSessionRequest(
          idTokenHint: GetIt.instance.get<JWTManager>().idToken,
          postLogoutRedirectUrl: _postLogoutRedirectUrl,
          serviceConfiguration: _serviceConfiguration));
      _clearSessionInfo();
    } catch (_) {
      print(_.toString());
    }
    _clearBusy();
  }

  void _processAuthTokenResponse(AuthorizationTokenResponse response) {
    GetIt.instance.get<JWTManager>().accessToken = response.accessToken!;
    GetIt.instance.get<JWTManager>().idToken = response.idToken!;
    GetIt.instance.get<JWTManager>().refreshToken = response.refreshToken!;
  }



  void _clearSessionInfo() {
    _codeVerifier = null;
    _nonce = null;
    _authorizationCode = null;
    _userInfo = null;
    _state= '';
    _codeChallenge ='';
  }

  void _setBusy() {
    _isBusy = true;
  }

  void _clearBusy() {
    _isBusy = false;
  }
}