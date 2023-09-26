import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/config/config.dart';
import 'package:travel_hour/manager/profile_manager.dart';
import 'package:travel_hour/pages/sign_in.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/image_view.dart';
import 'package:travel_hour/widgets/language.dart';
import 'package:easy_localization/easy_localization.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin{

  openAboutDialog () {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AboutDialog(
          applicationName: Config().appName,
          applicationIcon: Image(image: AssetImage(Config().splashIcon), height: 30, width: 30,),
        );
      }
    );
  }


  TextStyle _textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.grey[900]
  );




  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 50),
        children: [
          Text("profile", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600
          ),).tr(),
          GetIt.instance.get<ProfileManager>().isSignedIn == false ? GuestUserUI() : UserUI(),

          Text("general setting", style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),).tr(),


          SizedBox(height: 15,),
          ListTile(
            title: Text('get notifications', style: _textStyle).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.bell, size: 20, color: Colors.white),
            ),
          ),
          Divider(height: 5,),

          ListTile(
            title: Text('language', style: _textStyle).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.globe, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()=> nextScreenPopup(context, LanguagePopup()),
          ),
          Divider(height: 5,),
          
          ListTile(
            title: Text('contact us', style: _textStyle).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.mail, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()async=> await {}
          ),
          Divider(height: 5,),

          ListTile(
            title: Text('rate this app', style: _textStyle).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.star, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()async=> {}
          ),

          Divider(height: 5,),

          ListTile(
            title: Text('privacy policy', style: _textStyle).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.lock, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()=> {}
          ),
          Divider(height: 5,),

          ListTile(
            title: Text('about us', style: _textStyle).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.info, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()=> {}
          ),

          GetIt.instance.get<ProfileManager>().isSignedIn == false ? Container() : SecurityOption(textStyle: _textStyle,),

          Divider(height: 10,),
        ],
      )
      
      
    );
  }

  

  @override
  bool get wantKeepAlive => true;
}


class SecurityOption extends StatelessWidget {
  const SecurityOption({Key? key, required this.textStyle}) : super(key: key);
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 10,),
          ListTile(
            title: Text('security', style: textStyle).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.settings, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()=> {},
          ),
      ],
    );
  }
}


class GuestUserUI extends StatelessWidget {
  const GuestUserUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextStyle _textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.grey[900]
    );


    return Column(
      children: [
        ListTile(
            title: Text('login', style: _textStyle,).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.user, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()=> nextScreenPopup(context, SignInPage(tag: 'popup',)),
          ),
        SizedBox(height: 20,),
      ],
    );
  }
}


class UserUI extends StatelessWidget {
  const UserUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.grey[900]
    );
    return Column(
      children: [
        Container(
          height: 200,
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),

        ListTile(
            title: Text(GetIt.instance.get<ProfileManager>().email),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.mail, size: 20, color: Colors.white),
            ),
          ),
          Divider(height: 5,),

          ListTile(
            title: Text('logout', style: _textStyle,).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.log_out, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()=> openLogoutDialog(context),
          ),



          SizedBox(height: 15,)
        

      ],
    );
  }


  void openLogoutDialog (context) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('logout title').tr(),
          actions: [
            TextButton(
              child: Text('no').tr(),
              onPressed: ()=> Navigator.pop(context),
            ),
            TextButton(
              child: Text('yes').tr(),
              onPressed: ()async{
                Navigator.pop(context);
                // await context.read<SignInBloc>().userSignout()
                // .then((value) => context.read<SignInBloc>().afterUserSignOut())
                // .then((value) => nextScreenCloseOthers(context, SignInPage()));
                
                
              },
            )
          ],
        );
      }
    );
  }
}