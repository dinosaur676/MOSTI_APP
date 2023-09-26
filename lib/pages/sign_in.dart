import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/config/config.dart';
import 'package:travel_hour/manager/address_manager.dart';
import 'package:travel_hour/manager/jwt_manager.dart';
import 'package:travel_hour/manager/keycloak_manager.dart';
import 'package:travel_hour/manager/profile_manager.dart';
import 'package:travel_hour/pages/home.dart';
import 'package:travel_hour/utils/jwt_utils.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:travel_hour/widgets/language.dart';

class SignInPage extends StatefulWidget {
  final String? tag;

  SignInPage({Key? key, this.tag}) : super(key: key);

  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool googleSignInStarted = false;
  bool facebookSignInStarted = false;
  bool appleSignInStarted = false;
  Widget nextPage = HomePage();

  handleSkip() {
    nextScreen(context, nextPage);
  }


  handleKeycloakSiginIn() async {

    await GetIt.instance.get<AddressManager>().createMainCode();

    bool response = await GetIt.instance.get<Keycloak>().signInWithAutoCodeExchange();

    if (response) {
      setLoginData(GetIt.instance.get<JWTManager>().accessToken!);
      afterSignIn();
    }
  }

  getServerData() async {

  }

  setLoginData(String accessToken) {
    GetIt.instance.registerSingleton<ProfileManager>(ProfileManager(parseJwtPayLoad(accessToken)));
  }

  afterSignIn() {
    if (widget.tag == null) {
      nextScreenReplace(context, nextPage);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          widget.tag != null
              ? Container()
              : TextButton(
                  onPressed: () => handleSkip(),
                  child: Text('skip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )).tr()),
          IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.all(0),
            iconSize: 22,
            icon: Icon(
              Icons.language,
            ),
            onPressed: () {
              nextScreenPopup(context, LanguagePopup());
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'welcome to',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700]),
                  ).tr(),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${Config().appName}',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[700],
                        letterSpacing: -0.5,
                        wordSpacing: 1),
                  ),
                ],
              )),
          Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      'welcome message',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]),
                    ).tr(),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width * 0.50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ],
              )),
          Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  keycloakSignin(),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // GoogleSignin(),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // FacebookSignIn(),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // AppleSignIn(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05)
                ],
              )),
        ],
      ),
    );
  }

  Widget keycloakSignin() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.80,
      child: TextButton(
          onPressed: () => handleKeycloakSiginIn(),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.blueAccent),
              shape: MaterialStateProperty.resolveWith((states) =>
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)))),
          child: googleSignInStarted == false
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesome.bitcoin,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Sign In with KeyCloak',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                )
              : Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white),
                )),
    );
  }

//
// Widget GoogleSignin() {
//   return Container(
//     height: 50,
//     width: MediaQuery.of(context).size.width * 0.80,
//     child: TextButton(
//         onPressed: () => handleGoogleSignIn(),
//         style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.blueAccent),
//             shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5)
//             ))
//         ),
//         child: googleSignInStarted == false
//             ? Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               FontAwesome.google,
//               color: Colors.white,
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Text(
//               'Sign In with Google',
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white),
//             )
//           ],
//         )
//             : Center(
//           child: CircularProgressIndicator(
//               backgroundColor: Colors.white),
//         )),
//   );
// }
//
// Widget FacebookSignIn() {
//   return Container(
//     height: 50,
//     width: MediaQuery.of(context).size.width * 0.80,
//     child: TextButton(
//         onPressed: () {
//           handleFacebookSignIn();
//         },
//         style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.indigo),
//             shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5)
//             ))
//         ),
//         child: facebookSignInStarted == false
//             ? Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               FontAwesome.facebook_official,
//               color: Colors.white,
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Text(
//               'Sign In with Facebook',
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white),
//             )
//           ],
//         )
//             : Center(
//           child: CircularProgressIndicator(
//               backgroundColor: Colors.white),
//         )),
//   );
// }
//
// Widget AppleSignIn() {
//  return   Platform.isAndroid
//      ? Container()
//      : Container(
//    height: 50,
//    width: MediaQuery.of(context).size.width * 0.80,
//    child: TextButton(
//        onPressed: () {
//          handleAppleSignIn();
//        },
//        style: ButtonStyle(
//            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.grey[900]),
//            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(5)
//            ))
//        ),
//        child: appleSignInStarted == false
//            ? Row(
//          crossAxisAlignment:
//          CrossAxisAlignment.center,
//          mainAxisAlignment:
//          MainAxisAlignment.center,
//          children: [
//            Icon(
//              FontAwesome.apple,
//              color: Colors.white,
//            ),
//            SizedBox(
//              width: 10,
//            ),
//            Text(
//              'Sign In with Apple',
//              style: TextStyle(
//                  fontSize: 16,
//                  fontWeight: FontWeight.w600,
//                  color: Colors.white),
//            )
//          ],
//        )
//            : Center(
//          child: CircularProgressIndicator(
//              backgroundColor: Colors.white),
//        )),
//  );
// }
}
