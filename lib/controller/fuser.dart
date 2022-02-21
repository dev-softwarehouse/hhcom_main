import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'fobject.dart';

// ignore: must_be_immutable
class FUser extends FObject {

  FUser({required String path, String? subPath, Map<String, dynamic>? dictionary})
      : super(path: path, subPath: subPath, dictionary: dictionary);

  static String? currentId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static FUser? currentUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      String? userStr = Constants.preferences.get('CurrentUser') as String?;
      if (userStr == null || userStr.isEmpty) return null;
      Map<String, dynamic> dictionary = jsonDecode(userStr);
      Constants.userModel = UserModel.fromJson(dictionary);
      return FUser(path: 'User', dictionary: dictionary);
    }
    print('There is no current User!');
    return null;
  }

  static dynamic picture() {
    if (currentUser() == null) return '';
    return currentUser()?.dictionary['picture'];
  }

  static String fullName() {
    if (currentUser() == null) return '';
    return currentUser()?.dictionary['fullName'];
  }

  static FUser userWithId(String userId) {
    var user = FUser(path: FPath.user);
    user.dictionary['objectId'] = userId;
    return user;
  }

  bool isCurrent() {
    if (dictionary['objectId'] == null) return false;
    return (dictionary['objectId'] as String == FUser.currentId());
  }

  saveLocalIfCurrent() async {
    if (isCurrent()) {
      Constants.preferences.setString('CurrentUser', json.encode(dictionary));
      Constants.userModel = UserModel.fromJson(dictionary);
    }
  }

  Future<void> saveInBackground({bool fireStore = false, bool isUpdate = false}) {
    saveLocalIfCurrent();
    return super.saveInBackground();
  }

  Future<void> fetchInBackground() async {
    // if (currentUser() != null && currentUser().dictionary.isNotEmpty) {
    //   dictionary[UserField.online] = true;
    //   await saveInBackground();
    // }
    await super.fetchInBackground();
    saveLocalIfCurrent();
    return;
  }

  static Future<void> signOut() async {
    // await FacebookAuth.instance.logOut();
    await FirebaseAuth.instance.signOut();
    Constants.preferences.remove('CurrentUser');
  }
}
