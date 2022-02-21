import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hhcom/Utils/Routes/app_pages.dart';
import 'package:sizer/sizer.dart';

import 'bloc/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BlocProvider(create: (_) => BaseBloc(), child: MyApp()));
}

/// [GetMaterialApp] used for the simply navigation between screens
///
/// All routes are define in the [AppPages]
///
///```dart
/// Get.toNamed(Routes.SPLASH_SCREEN,arguments: {});
/// ```

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerBloc>(create: (_) => CustomerBloc(context.read<BaseBloc>())),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc(context.read<BaseBloc>())),
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          title: 'HHCom',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        );
      }),
    );
  }
}
