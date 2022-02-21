import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel();

  String? objectId;
  @JsonKey(defaultValue: '')
  String username = '';

  @JsonKey(defaultValue: '')
  String companyName = '';

  @JsonKey(defaultValue: '')
  String email = '';
  @JsonKey(defaultValue: '')
  String fullName = '';
  @JsonKey(defaultValue: '')
  String firstName = '';
  @JsonKey(defaultValue: '')
  String lastName = '';

  @JsonKey(defaultValue: '')
  String picture = '';
  @JsonKey(defaultValue: '')
  String thumbnail = '';
  @JsonKey(defaultValue: '')
  String phone = '';
  @JsonKey(defaultValue: '')
  String fcmId = '';
  @JsonKey(defaultValue: 0.0)
  double latitude = 0.0;
  @JsonKey(defaultValue: 0.0)
  double longitude = 0.0;
  @JsonKey(defaultValue: '')
  String taxId = '';

  @JsonKey(defaultValue: false)
  bool online = false;

  int? createdAt;
  int? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class CustomerModel extends Equatable {
  String? objectId;
  @JsonKey(defaultValue: '')
  String userId = '';
  @JsonKey(defaultValue: '')
  String firstName = '';
  @JsonKey(defaultValue: '')
  String lastName = '';
  @JsonKey(defaultValue: '')
  String phone = '';

  @JsonKey(defaultValue: '')
  String email = '';

  @JsonKey(defaultValue: '')
  String street = '';
  @JsonKey(defaultValue: '')
  String streetNumber = '';
  @JsonKey(defaultValue: -1)
  int apartmentNumber = -1;
  @JsonKey(defaultValue: '')
  String city = '';
  @JsonKey(defaultValue: 0)
  int zipCode = 0;

  @JsonKey(defaultValue: '')
  String picture = '';
  @JsonKey(defaultValue: [])
  List<Map<String, dynamic>> visits = [];
  /* @JsonKey(defaultValue: '')
  String employee = '';
  @JsonKey(defaultValue: '')
  String location = '';*/

  int? createdAt;
  int? updatedAt;

  CustomerModel();

  DateTime visitDateTime(int date) => DateTime.fromMillisecondsSinceEpoch(date);

  factory CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);

  @override
  List<Object?> get props => [objectId];
}

class CustomerAppointment {
  CustomerAppointment({
    this.createdByUsername,
    this.createdByUserId,
    this.createdForUsername,
    this.createdForUserId,
    this.timestamp,
    this.employee,
    this.location,
    this.employeeId,
    this.isPaymentDone,
    this.paymentMode,
    this.services,
    this.products,
    this.agreements,
    this.notes,
    this.totalCost,
  });

  String? createdByUsername;
  String? createdByUserId;
  String? createdForUsername;
  String? createdForUserId;
  int? timestamp;
  String? employee;
  String? employeeId;
  String? location;
  bool? isPaymentDone;
  String? paymentMode;
  double? totalCost;
  List<dynamic>? services;
  List<dynamic>? products;
  List<dynamic>? notes;
  List<dynamic>? agreements;

  factory CustomerAppointment.fromMap(Map<String, dynamic> json) => CustomerAppointment(
        createdByUsername: json["createdByUsername"] == null ? null : json["createdByUsername"],
        createdByUserId: json["createdByUserId"] == null ? null : json["createdByUserId"],
        createdForUsername: json["createdForUsername"] == null ? null : json["createdForUsername"],
        createdForUserId: json["createdForUserId"] == null ? null : json["createdForUserId"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        employee: json["employee"] == null ? null : json["employee"],
        employeeId: json["employeeId"] == null ? null : json["employeeId"],
        location: json["location"] == null ? null : json["location"],
        isPaymentDone: json["isPaymentDone"] == null ? false : json["isPaymentDone"],
        paymentMode: json["paymentMode"] == null ? null : json["paymentMode"],
        services: json["services"] == null ? [] : json["services"],
        products: json["products"] == null ? [] : json["products"],
        notes: json["notes"] == null ? [] : json["notes"],
        agreements: json["agreements"] == null ? [] : json["agreements"],
        totalCost: json["totalCost"] == null ? null : double.parse(json["totalCost"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "createdByUsername": createdByUsername,
        "createdByUserId": createdByUserId,
        "createdForUsername": createdForUsername,
        "createdForUserId": createdForUserId,
        "timestamp": timestamp,
        "employee": employee,
        "location": location,
        "employeeId": employeeId,
        "isPaymentDone": isPaymentDone,
        "paymentMode": paymentMode,
        "services": services,
        "products": products,
        "notes": notes,
        "agreements": agreements,
        "totalCost": totalCost,
      };
}

class AppointmentItemsModel {
  AppointmentItemsModel({
    required this.name,
    required this.cost,
    required this.quantity,
    required this.type,
  });

  String name;
  double cost;
  int quantity;
  int type;

  factory AppointmentItemsModel.fromMap(Map<String, dynamic> json) => AppointmentItemsModel(
        name: json["name"] == null ? null : json["name"],
        cost: json["cost"] == null ? 0.0 : double.parse(json["cost"].toString()),
        quantity: json["quantity"] == null ? null : json["quantity"],
        type: json["type"] == null ? 0 : json["type"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "cost": cost,
        "quantity": quantity,
        "type": type,
      };
}

class AppointmentServicesModel {
  AppointmentServicesModel({
    required this.name,
    required this.cost,
    required this.quantity,
    required this.type,
  });

  String name;
  double cost;
  int quantity;
  int type;

  factory AppointmentServicesModel.fromMap(Map<String, dynamic> json) => AppointmentServicesModel(
        name: json["name"] == null ? null : json["name"],
        cost: json["cost"] == null ? 0.0 : double.parse(json["cost"].toString()),
        quantity: json["quantity"] == null ? null : json["quantity"],
        type: json["type"] == null ? 0 : json["type"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "cost": cost,
        "quantity": quantity,
        "type": type,
      };
}

class AppointmentProductsModel {
  AppointmentProductsModel({
    required this.name,
    required this.cost,
    required this.quantity,
    required this.type,
  });

  String name;
  double cost;
  int quantity;
  int type;

  factory AppointmentProductsModel.fromMap(Map<String, dynamic> json) => AppointmentProductsModel(
        name: json["name"] == null ? null : json["name"],
        cost: json["cost"] == null ? 0.0 : double.parse(json["cost"].toString()),
        quantity: json["quantity"] == null ? null : json["quantity"],
        type: json["type"] == null ? 1 : json["type"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "cost": cost,
        "quantity": quantity,
        "type": type,
      };
}

class AppointmentAgreementsModel {
  AppointmentAgreementsModel({
    required this.quantity,
    required this.name,
    required this.cost,
    required this.type,
  });

  int quantity;
  String name;
  double cost;
  int type;

  factory AppointmentAgreementsModel.fromMap(Map<String, dynamic> json) => AppointmentAgreementsModel(
        quantity: json["quantity"] == null ? null : json["quantity"],
        name: json["name"] == null ? null : json["name"],
        cost: json["cost"] == null ? 0.0 : double.parse(json["cost"].toString()),
        type: json["type"] == null ? 0 : json["type"],
      );

  Map<String, dynamic> toMap() => {
        "quantity": quantity,
        "name": name,
        "cost": cost,
        "type": type,
      };
}

class AppointmentNotesModel {
  AppointmentNotesModel({
    required this.note,
    required this.timestamp,
  });

  String note;
  int timestamp;

  factory AppointmentNotesModel.fromMap(Map<String, dynamic> json) => AppointmentNotesModel(
        note: json["note"] == null ? null : json["note"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
      );

  Map<String, dynamic> toMap() => {
        "note": note,
        "timestamp": timestamp,
      };
}

class WorkerModel extends Equatable {
  WorkerModel({
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.position,
    this.objectId,
  });

  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? position;
  String? objectId;

  factory WorkerModel.fromJson(Map<String, dynamic> json) => WorkerModel(
        email: json["email"] == null ? null : json["email"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        phone: json["phone"] == null ? null : json["phone"],
        position: json["position"] == null ? null : json["position"],
        objectId: json["objectId"] == null ? null : json["objectId"],
      );

  Map<String, dynamic> toMap() => {
        "email": email == null ? null : email,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "phone": phone == null ? null : phone,
        "position": position == null ? null : position,
        "objectId": objectId == null ? null : objectId,
      };

  @override
  List<Object?> get props => [];
}
