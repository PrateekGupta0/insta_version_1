import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:provider/provider.dart';


class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({Key? key,required this.mobileScreenLayout,required this.webScreenLayout}) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async{// to get user name
    UserProvider _userProvider =Provider.of(context,listen: false);// to listen only one time.
    await _userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    // helps us to build responsive layout ->layout builder
    return LayoutBuilder(
        builder:(context,constraints){
          if(constraints.maxWidth >webScreenSize){
            // web screen
            return widget.webScreenLayout;
          }
          //mobile screen
          return widget.mobileScreenLayout;
        });
  }
}
