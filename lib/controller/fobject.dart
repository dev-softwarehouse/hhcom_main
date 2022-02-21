import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


// ignore: must_be_immutable
class FObject extends Equatable {

  final String tag = 'FObject';
  final String path;
  final String? subPath;
  Map<String, dynamic>dictionary;

  FObject({required this.path, this.subPath, Map<String, dynamic>? dictionary}) : dictionary = dictionary ?? {};

  @override
  List<Object> get props => [this.path, this.subPath ?? '', this.dictionary];

  static FObject objectWithPath(String path) {
    return FObject(path: path);
  }

  static FObject objectWithPathDic(String path, Map<String, dynamic> dictionary) {
    return FObject(path: path,dictionary: dictionary);
  }

  static FObject objectWithPathSubPath(String path, String? subPath) {
    return FObject(path: path, subPath: subPath);
  }

  static FObject objectWithAll(String path, String subPath, Map<String, dynamic> dictionary) {
    return FObject(path: path, subPath: subPath, dictionary: dictionary);
  }

  String objectId() {
    return dictionary['objectId'];
  }

  Future<void> saveInBackground({bool fireStore = false, bool isUpdate = false}) {
    var reference = databaseReference();
    String? objectId = dictionary['objectId'];
    if (objectId == null || objectId.isEmpty) {
      dictionary['objectId'] = reference.key;
    }
    if (dictionary['createdAt'] == null) {
      dictionary['createdAt'] = DateTime.now().millisecondsSinceEpoch;
    }
    dictionary['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
    return reference.update(dictionary);
  }

  Future<dynamic> updateInBackground() async {
    var reference = databaseReference();
    if (dictionary['objectId'] != null) {
      dictionary['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
      return reference.update(dictionary);
    } else {
      return Future.error('Object cannot be deleted.');
    }
  }

  Future<dynamic> deleteInBackground() {
    var reference = databaseReference();
    if (dictionary['objectId'] != null) {
      return reference.remove();
    } else {
      return Future.error('Object cannot be deleted.');
    }
  }

  Future<void> fetchInBackground() async {
    var reference = databaseReference();
    DataSnapshot snapshot = await reference.once();
    if (snapshot.value != null) {
      this.dictionary = Map<String, dynamic>.from(snapshot.value);
      return;
    }
    throw('Object not found.');
  }

  DatabaseReference databaseReference() {
    DatabaseReference reference;
    if (subPath == null) {
      reference = FirebaseDatabase.instance.reference().child(path);
    } else {
      reference = FirebaseDatabase.instance.reference().child(path).child(subPath!);
    }

    if (dictionary.isEmpty && FirebaseAuth.instance.currentUser?.uid != null) {
      return reference.child((FirebaseAuth.instance.currentUser!.uid)); //[reference child:[FIRAuth auth].currentUser.uid];
    }
    if (dictionary['objectId'] == null) {
      return reference.push();
    } else {
      return reference.child(dictionary['objectId']);
    }
  }
}