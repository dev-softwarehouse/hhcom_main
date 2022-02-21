import 'package:get/get.dart' show GetPage, Transition;
import 'package:hhcom/Screens/Appointment/add_edit_customer_appointment.dart';
import 'package:hhcom/Screens/AuthScreens/login_screen.dart';
import 'package:hhcom/Screens/AuthScreens/recover_password_screen.dart';
import 'package:hhcom/Screens/MainScreen/Bindings/customer_binding.dart';
import 'package:hhcom/Screens/MainScreen/Bindings/profile_binding.dart';
import 'package:hhcom/Screens/MainScreen/Bindings/service_item_binding.dart';
import 'package:hhcom/Screens/MainScreen/Bindings/worker_binding.dart';
import 'package:hhcom/Screens/MainScreen/add_customer_screen.dart';
import 'package:hhcom/Screens/MainScreen/main_screen.dart';
import 'package:hhcom/Screens/ProfileScreen/add_position.dart';
import 'package:hhcom/Screens/SplashScreen/splash_screen.dart';
import 'package:hhcom/Utils/Routes/app_routes.dart';

/// Attached the page with the tag and called
///
/// Get.toNamed(Routes.SPLASH_SCREEN);
class AppPages {
  static const Transition transition = Transition.cupertino;

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(name: Routes.SPLASH_SCREEN, page: () => SplashScreen(), transition: transition),
    GetPage(name: Routes.LOGIN_SCREEN, page: () => LoginScreen(), transition: transition),
    GetPage(name: Routes.RECOVER_PASSWORDE, page: () => RecoverPasswordScreen(), transition: transition),
    GetPage(
        name: Routes.MAIN_SCREEN,
        page: () => MainScreen(),
        bindings: [CustomerBinding(), WorkerBinding(), ProfileBinding(), ServiceItemBinding()],
        transition: transition),
    GetPage(name: Routes.ADD_CUSTOMER_SCREEN, page: () => AddCustomerScreen(), transition: transition),
    GetPage(name: Routes.ADD_POSITION, page: () => AddPosition(), transition: transition),
    GetPage(
        name: Routes.ADD_APPOINTMENT,
        page: () => AddEditCustomerAppointment(),
        bindings: [CustomerBinding(), WorkerBinding(), ServiceItemBinding()],
        transition: transition),
  ];
}
