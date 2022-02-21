// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel()
  ..objectId = json['objectId'] as String?
  ..username = json['username'] as String? ?? ''
  ..companyName = json['companyName'] as String? ?? ''
  ..email = json['email'] as String? ?? ''
  ..fullName = json['fullName'] as String? ?? ''
  ..firstName = json['firstName'] as String? ?? ''
  ..lastName = json['lastName'] as String? ?? ''
  ..picture = json['picture'] as String? ?? ''
  ..thumbnail = json['thumbnail'] as String? ?? ''
  ..phone = json['phone'] as String? ?? ''
  ..fcmId = json['fcmId'] as String? ?? ''
  ..latitude = (json['latitude'] as num?)?.toDouble() ?? 0.0
  ..longitude = (json['longitude'] as num?)?.toDouble() ?? 0.0
  ..taxId = json['taxId'] as String? ?? ''
  ..online = json['online'] as bool? ?? false
  ..createdAt = json['createdAt'] as int?
  ..updatedAt = json['updatedAt'] as int?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'objectId': instance.objectId,
      'username': instance.username,
      'companyName': instance.companyName,
      'email': instance.email,
      'fullName': instance.fullName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'picture': instance.picture,
      'thumbnail': instance.thumbnail,
      'phone': instance.phone,
      'fcmId': instance.fcmId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'taxId': instance.taxId,
      'online': instance.online,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) => CustomerModel()
  ..objectId = json['objectId'] as String?
  ..userId = json['userId'] as String? ?? ''
  ..firstName = json['firstName'] as String? ?? ''
  ..lastName = json['lastName'] as String? ?? ''
  ..phone = json['phone'] as String? ?? ''
  ..email = json['email'] as String? ?? ''
  ..street = json['street'] as String? ?? ''
  ..streetNumber = json['streetNumber'] as String? ?? ''
  ..apartmentNumber = json['apartmentNumber'] as int? ?? -1
  ..city = json['city'] as String? ?? ''
  ..zipCode = json['zipCode'] as int? ?? 0
  ..picture = json['picture'] as String? ?? ''
  ..createdAt = json['createdAt'] as int?
  ..updatedAt = json['updatedAt'] as int?
  ..visits = (json['meetings'] == null || json['meetings'].length == 0) ? [] : List<Map<String, dynamic>>.from(json['meetings'].map((e) => Map<String, dynamic>.from(e)).toList());
//..visits = (json['visits'] == null) ? []:List<Map<String, dynamic>>.from(json['visits']).map (json['visits'] as List<Map<String, dynamic>>?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? List<Map<String, dynamic>>?()

Map<String, dynamic> _$CustomerModelToJson(CustomerModel instance) => <String, dynamic>{
      'objectId': instance.objectId,
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'email': instance.email,
      'street': instance.street,
      'streetNumber': instance.streetNumber,
      'apartmentNumber': instance.apartmentNumber,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'picture': instance.picture,
      'meetings': instance.visits,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
