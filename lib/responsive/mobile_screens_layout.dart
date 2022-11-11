
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/globel_veriable.dart';
import 'package:provider/provider.dart';
import 'package:instagram/Model/user.dart' as model;

class MobileScreenLayout extends StatefulWidget{
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page=0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTab(int page){
    _pageController.jumpToPage(page);
  }

  void Pagechanged(int page){
    setState(() {
      _page = page;
    });
  }
  
  @override
  Widget build(BuildContext context){
    // model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        children: HomeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: Pagechanged,
      ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: _page ==0 ? primaryColor : secondryColor ,),
              label: "",
              backgroundColor: primaryColor,
              ),
              BottomNavigationBarItem(
              icon: Icon(Icons.search, color: _page ==1 ? primaryColor : secondryColor ,),
              label: "",
              backgroundColor: primaryColor,
              ),
              BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, color: _page ==2 ? primaryColor : secondryColor ,),
              label: "",
              backgroundColor: primaryColor,
              ),
              BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: _page ==3 ? primaryColor : secondryColor ,),
              label: "",
              backgroundColor: primaryColor,
              ),
              BottomNavigationBarItem(
              icon: Icon(Icons.person, color: _page ==4 ? primaryColor : secondryColor ,),
              label: "",
              backgroundColor: primaryColor,
              ),
          ],
          onTap: navigationTab,
        ),
    );
  }
}