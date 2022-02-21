import 'package:get/get.dart';
import 'package:hhcom/Models/model.dart';

class CustomerController extends GetxController {
  var selectedCustomer = CustomerModel().obs;
  var customerList = <CustomerModel>[].obs;

  setSelectedCustomer(CustomerModel? customerModel) {
    selectedCustomer.value = customerModel!;
  }
}

// import 'package:get/get.dart';
// import 'package:hhcom/Models/model.dart';
// import 'package:hhcom/Screens/MainScreen/customer_screen.dart';
// import 'package:hhcom/Utils/Constant/constant.dart';
//
// /// [CustomerController] is used for manage all the customer events
// ///
// class CustomerController extends GetxController {
//   /// Current selected customer
//   var selectedItem = CustomerModel().obs;
//
//   /// Dummy customer List
//   var customerDummyList = <CustomerModel>[].obs;
//
//   /// this method call when [CustomerController] put first time
//   @override
//   void onInit() async {
//     super.onInit();
//     customerDummyList.value = [
//       CustomerModel(
//         id: '1',
//         name: "Tomaszenko, ",
//         mobile: "+380 800 735 532",
//         email: "lidiiia_08@gmail.com",
//         address: "ul. Konopnickiej 30 m. 12403-751 Testowice Małe",
//         city: "Migdałowa",
//         profileImage: dummy_user_pic,
//         visits: [
//           Visits(
//               date: DateTime.now().toIso8601String(),
//               time: DateTime.now().toIso8601String()),
//           Visits(
//               date: DateTime.now().toIso8601String(),
//               time: DateTime.now().toIso8601String()),
//           Visits(
//               date: DateTime.now().toIso8601String(),
//               time: DateTime.now().toIso8601String()),
//           Visits(
//               date: DateTime.now().toIso8601String(),
//               time: DateTime.now().toIso8601String()),
//         ],
//       ),
//       CustomerModel(
//         id: '2',
//         profileImage: profile_pic,
//         name: "Loeew, Lidia",
//         mobile: "+380 800 735 532",
//         email: "lidiiia_08@gmail.com",
//         address: "ul. Konopnickiej 30 m. 12403-751 Testowice Małe",
//         city: "Migdałowa",
//         visits: [
//           Visits(
//               date: DateTime.now().toIso8601String(),
//               time: DateTime.now().toIso8601String())
//         ],
//       ),
//       CustomerModel(
//         id: '3',
//         name: "joghn deo",
//         profileImage: dummy_user_pic2,
//         mobile: "+380 800 735 532",
//         email: "lidiiia_08@gmail.com",
//         address: "ul. Konopnickiej 30 m. 12403-751 Testowice Małe",
//         city: "Migdałowa",
//         visits: [
//           Visits(
//               date: DateTime.now().toIso8601String(),
//               time: DateTime.now().toIso8601String())
//         ],
//       ),
//       CustomerModel(
//         id: '4',
//         name: "Tomaszenko, Lidia",
//         mobile: "+380 800 735 532",
//         profileImage: dummy_user_pic3,
//         email: "lidiiia_08@gmail.com",
//         address: "ul. Konopnickiej 30 m. 12403-751 Testowice Małe",
//         city: "Migdałowa",
//         visits: [
//           Visits(
//               date: DateTime.now().toIso8601String(),
//               time: DateTime.now().toIso8601String())
//         ],
//       )
//     ];
//
//     /// Set the initial selectedItem
//     selectedItem.value = customerDummyList[0];
//   }
//
//   /// set current selected customer to show in the [CustomerScreen], pass object of [CustomerModel] as a parameter
//   changeSelectedItem({CustomerModel? item}) {
//     selectedItem.value = item!;
//   }
// }
