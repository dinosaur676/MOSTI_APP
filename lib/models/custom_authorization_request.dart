import 'package:flutter_appauth/flutter_appauth.dart';

/// The details of an authorization request to get an authorization code.
class CustomAuthorizationRequest extends AuthorizationRequest{
  String? codeChallenge;
  String? codeChallengeMethod;
  CustomAuthorizationRequest(
      String clientId,
      String redirectUrl, {
        String? issuer,
        String? discoveryUrl,
        AuthorizationServiceConfiguration? serviceConfiguration,
        String? loginHint,
        List<String>? scopes,
        Map<String, String>? additionalParameters,
        List<String>? promptValues,
        bool allowInsecureConnections = false,
        bool preferEphemeralSession = false,
        String? nonce,
        String? responseMode,
        String? codeChallenge,
        String? codeChallengeMethod
      }) : super(clientId, redirectUrl, issuer: issuer,
      discoveryUrl: discoveryUrl, serviceConfiguration: serviceConfiguration,
      loginHint: loginHint, scopes: scopes, additionalParameters:  additionalParameters,
      promptValues:  promptValues, allowInsecureConnections:  allowInsecureConnections,
      preferEphemeralSession: preferEphemeralSession, nonce: nonce, responseMode: responseMode
  ) {
    this.codeChallenge = codeChallenge;
    this.codeChallengeMethod = codeChallengeMethod;
  }
}
