import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hhcom/Screens/CalendarScreens/calendar_screen.dart';
import 'package:hhcom/Screens/ProfileScreen/profile_screen.dart';
import 'package:hhcom/Screens/base_scaffold.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/app_theme.dart';
import 'package:hhcom/bloc/base/base.dart';
import 'package:hhcom/bloc/bloc.dart';

import 'customer_screen.dart';
import 'home_screen.dart';

/// Main screen is the app first screen show after user login
///
/// it's contains bottom navigation bar for navigate between the screen
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var currentTab = 0.obs;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    print("AppInitEvent");
    BlocProvider.of<BaseBloc>(context).add(AppInitEvent());
    super.initState();
  }

  void onPageChanged(int index) {
    currentTab.value = index;
  }

  ///This is the method where you get the index of the current tab.
  void onTabTapped(int index) {
    currentTab.value = index;
  }

  bool _listenWhen(BaseState preState, BaseState state) => true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BaseBloc, BaseState>(
          listenWhen: _listenWhen,
          listener: (_, __) {},
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
          // BlocProvider<CustomerBloc>(
          //   create: (_) => CustomerBloc(context.read<BaseBloc>())),
          BlocProvider<CalendarBloc>(create: (_) => CalendarBloc()),
//          BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
        ],
        child: WillPopScope(
          onWillPop: _backBtnAction,
          child: _body(),
        ),
      ),
    );
  }

  Future<bool> _backBtnAction() async {
    bool? value = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?', style: TextStyle(color: AppColors.black)),
          content: Text('Do you want to exit the App?', style: TextStyle(fontSize: 16, color: AppColors.black)),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
    return value ?? false;
  }

  Widget _body() {
    return BaseScaffold(
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.indigo,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
            ),
            type: BottomNavigationBarType.fixed,
            currentIndex: currentTab.value,
            onTap: onTabTapped,
            items: _buildNavItems(),
          )),
      child: Obx(() => _selectPage()),
    );
  }

  /// Method for create the Navigation bar item to show icon and lable
  _buildNavItems() {
    return [
      _customNavItem(label: 'Home', image: home, activeImage: selected_home),
      _customNavItem(label: 'Klienci', image: people, activeImage: selected_people),
      _customNavItem(label: 'Kalendarz', image: calendar, activeImage: selected_calendar),
      _customNavItem(label: 'Profil', image: profile, activeImage: selected_profile),
    ];
  }

  /// Custom Navigation bar item
  BottomNavigationBarItem _customNavItem({String? label, String? activeImage, String? image}) {
    return BottomNavigationBarItem(
      label: label,
      activeIcon: Container(margin: EdgeInsets.only(bottom: 5), child: ImageIcon(AssetImage(activeImage!), size: 25)),
      icon: ImageIcon(AssetImage(image!), size: 20),
    );
  }

  /// Called when index chnage of navbarindex change and return the screen according
  _selectPage() {
    switch (currentTab.value) {
      case 0:
        return HomeScreen();
      case 1:
        return CustomerScreen();
      case 2:
        return CalendarScreen();
      case 3:
        return ProfileScreen();
      default:
    }
  }
}
