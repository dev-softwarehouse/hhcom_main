import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hhcom/Models/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Colors
const primaryColor = Color(0xFFA3B9C9);
const whiteColor = Color(0xffffffff);
const secondaryColor = Color(0xff889AD2);
const textGreyColor = Color(0xff777777);
const visiterListBg = Color(0xffEEEEEE);
const addCustomerCardBgColor = Color(0xfff3f2f9);
const addCustomerCardTitlebgColor = Color(0xffe5e3ec);

/// Specifies the Navigation transition
const transition = Transition.noTransition;

/// Assets icons
///
const String title_img = 'assets/images/title.png';
const String bg_img = 'assets/images/bg_img.png';
const String registration_title = 'assets/images/registration_title.png';
const String search_bg = 'assets/images/search_bg.png';
const String profile_pic = 'assets/images/profile_pic.png';
const String dummy_user_pic = 'assets/images/dummy_user_pic.png';
const String dummy_user_pic2 = 'assets/images/dummy_user_pic2.png';
const String dummy_user_pic3 = 'assets/images/dummy_user_pic3.png';
const String add_customer = 'assets/images/add_customer.png';
const String add_position_title = 'assets/images/add_position_title.png';
const String pracownicy_title = 'assets/images/pracownicy.png';
const String stanowiska_title = 'assets/images/stanowiska.png';
const String recover_password_title = 'assets/images/recover_password_title.png';

/// Assets images
///
const String signout_icn = 'assets/icons/signout.png';
const String checkbox_icn = 'assets/icons/checkbox.png';
const String eye_icn = 'assets/icons/eye.png';
const String back_icn = 'assets/icons/back_icn.png';
const String profile = 'assets/icons/profile.png';
const String selected_profile = 'assets/icons/selected_profile.png';
const String selected_home = 'assets/icons/selected_home.png';
const String selected_calendar = 'assets/icons/selected_calendar.png';
const String selected_people = 'assets/icons/selected_people.png';
const String people = 'assets/icons/people.png';
const String home = 'assets/icons/home.png';
const String calendar = 'assets/icons/calendar.png';
const String drawer_icn = 'assets/icons/drawer_icn.png';
const String add_customer_icn = 'assets/icons/add_customer_icn.png';
const String search_icn = 'assets/icons/icon_search.png';
const String user_icn = 'assets/icons/user.png';
const String users_icn = 'assets/icons/users.png';
const String stanowiska = 'assets/icons/stanowiska.png';
const String card = 'assets/icons/card.png';
const String help = 'assets/icons/help.png';
const String firma = 'assets/icons/building.png';
const String settings = 'assets/icons/settings.png';
const String checkList = 'assets/icons/checklist.png';
const String phone_icn = 'assets/icons/phone_icn.png';
const String email_icn = 'assets/icons/email.png';
const String hash_icn = 'assets/icons/hash_icn.png';
const String selected_home_customer = 'assets/icons/selected_home_customer.png';
const String selected_building_customer = 'assets/icons/selected_building.png';
const String selected_calendar_customer = 'assets/icons/selected_calendar.png';
const String selected_phone_customer = 'assets/icons/selected_phone.png';
const String selected_email_customer = 'assets/icons/selected_email.png';
const String add_icn = 'assets/icons/add.png';
const String edit_icon = 'assets/icons/edit_icon.png';
const String scissors_icn = 'assets/icons/scissors_icn.png';
const String agent_icn = 'assets/icons/agent_icn.png';
const String book_icn = 'assets/icons/book_icn.png';
const String brush_icn = 'assets/icons/brush_icn.png';

const String dropdown_selected = 'assets/icons/dropdown_selected.png';
const String dropdown_unselected = 'assets/icons/dropdown_unselected.png';

const String calendar_appointment = 'assets/icons/calendar2.png';
const String agreement_appointment = 'assets/icons/agreement.png';
const String note_appointment = 'assets/icons/note.png';
const String product_appointment = 'assets/icons/product.png';
const String flag_appointment = 'assets/icons/flag.png';
const String payment_appointment = 'assets/icons/payment.png';
const String location_appointment = 'assets/icons/location.png';
const String worker_appointment = 'assets/icons/worker.png';
const String time_appointment = 'assets/icons/time.png';
const String time_select_appointment = 'assets/icons/time_big.png';
const String cart_appointment = 'assets/icons/cart.png';
const String top_background_appointment = "assets/images/top_background.png";
const String customer_edit = "assets/icons/edit.png";
const String appointment_background = "assets/images/carrousel_background.png";
const String appointment_edit_background = "assets/images/top_background_edit.png";
const String appointment_edit_full_background = "assets/images/top_background_edit_full.png";

const String service_item_background_undo = "assets/images/service_item_undo.png";
const String service_item_background_delete_view = "assets/images/service_item_background_delete_view.png";
const String service_item_background_delete = "assets/images/service_item_background_delete.png";
const String service_item_background_return = "assets/images/service_item_background_return.png";
const String service_item_delete = "assets/icons/service_item_icon_delete.png";
const String service_item_return = "assets/icons/service_item_icon_return.png";

const String unselected_item = "assets/icons/unselected.png";
const String addService = "assets/icons/edit_service.png";
const String deleteService = "assets/icons/delete_service.png";

const String add_service_vertical_separator = "assets/icons/vertical_separator.png";
const String add_service_save = "assets/icons/save.png";
const String add_service_return = "assets/icons/return.png";
const String add_service_flag = "assets/icons/service_flag.png";
const String add_service_drop_down = "assets/icons/drop_down.png";
const String add_service_background = "assets/icons/cart_selected_background.png";
const String appointment_background_full = "assets/images/add_appointment_top_background.png";
const String bottom_border = "assets/images/bottom_border.png";
const String addNotesIcon = "assets/icons/icon_add_notes.png";
const String deleteNotesIcon = "assets/icons/icon_delete_notes.png";
const String notesBackground = "assets/images/notes_background.png";
const String notesIconBig = "assets/icons/icon_note_big.png";
const String iconTriangle = "assets/icons/icon_triangle.png";

//Szymon
// Strings
const String dateHeader = "Dodaj date";
const String timeHeader = "Dodaj godzine";
const String workerHeader = "Dodaj pracownika";
const String locationHeader = "Dodaj placówkę";
const String paymentHeader = "nieopłacone";
const String saveDateTimeBtnHeader = "Zapisz dane";
const String notTimeSelectedErrMsg = "Please select a time";
const String defaultTimeHrMin = "00";
const String timeSeparator = ":";
const String appointmentStatus = "umawianie wizyty";
const String appointmentEditStatus = "wizyta nadchodząca";
const String workerHintText = "Wybierz pracownika";
const String locationHintText = "Wybierz placówkę";

const String servicesHeader = "services";
const String productsHeader = "products";
const String notesHeader = "notes";
const String agreementsHeader = "agreements";
const String addVisitHeader = "Dodaj wizytę";
const String defaultServiceCount = "1";
const String defaultPrice = "340,00 PLN";
const String defaultCost = "340.00";
//const String emptyPrice = "0,00 PLN";
const String emptyPrice = "0.00";
const String serviceItem0 = "Prostowanie kerat";
const String dropDownItem = "Prostowanie kerat...";
const String serviceItem1 = "Strzyżenie klasyczne";
const String serviceItem2 = "Baleyage";
const String addServiceBtnHeader = "Dodaj usługę";
const String defaultSelectedText = "1x   Prostowanie keratynowe";
const String saveVisitBtn = "Zapisz wizytę";
const String paymentModeHeader = "nieopłacone";
const String currencyHeader = "PLN";
const String emptyNotes = "Brak notatek do wizyty";
const String paymentMode = "opłacone kartą";
const String enterNotesHeader = "Enter Notes";
const String enterNotesHint = "Notes";
const String notesSaveBtn = "Save";
const String notesCancelBtn = "Cancel";
const String enterQuantity = "Enter Quantity";
const String enterQuantityHint = "Quantity";
const String savePositionBtnTitle = 'Dodaj stanowisko';
const String basicInformationTitle = 'Dane podstawowe';

const String generalJobTitle = 'Nazwa stanowiska';
const String generalJobTitleHint = 'Please enter Nazwa stanowiska';

const String maleJobTitle = 'Nazwa stanowiska ♀';
const String maleJobTitleHint = 'Please enter Nazwa stanowiska ♀';
const String femaleJobTitle = 'Nazwa stanowiska ♂';
const String femaleJobTitleHint = 'Please enter Nazwa stanowiska ♂';
const String positionTitle = 'Stanowisko nadrzędne';
const String positionTitleHint = 'Please enter Stanowisko nadrzędne';
const String differentGenderJobs = 'różne nazwy stanowisk dla płci';
const String jobPostOnlyManagerAvailable = "Only Manager option is available";
const String appointmentAddSuccessMsg = "Appointment add successfully";

class Constants {
  static late SharedPreferences preferences;
  static UserModel userModel = UserModel();
  static const String password = '222222';

  static const String test1UserId = '1LgX3W963oaewx9Ss6KlYLefnmj2';
  static const String testUserId = 'BOhIuGPiGnPlDhf6iOMayPlqOhk1';

  static const String test1UserEmail = '6em7x1jyoxzeoqrt6fehyyoivow2@hagoole.com';
  static const String testUserEmail = 'y0umyszziqecpuz6qy3utdgav4z2@hagoole.com';
  static const String FCM_TOKEN = 'fcm_token';
  static late List<String> dictionary = [];
  static late List<int> encodedDictionary = [];
}

abstract class FPath {
  static const String user = 'User';
  static const String customer = 'Customer';
  static const String worker = 'Worker';
  static const String position = 'Position';
  static const String service = 'Service';
}

abstract class PermissionDes {
  static const String Camera =
      'HHCom does not have access to your camera.To enable access, tap Settings and turn on camera';
  static const String Gallery =
      'HHCom does not have access to your Photo.To enable access, tap Settings and turn on photo';
  static const String Storage =
      'HHCom does not have access to your storage.To enable access, tap Settings and turn on storage';
  static const String Contacts =
      'HHCom does not have access to your contacts.To enable access, tap Settings and turn on contacts';
  static const String Location =
      'HHCom does not have access to your location.To enable access, tap Settings and turn on location';
}
