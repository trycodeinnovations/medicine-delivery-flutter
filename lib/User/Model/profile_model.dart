// To parse this JSON data, do
//
//     final ProfileModel = ProfileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel ProfileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String ProfileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    String email;
    String firstName;
    String lastName;
    int loginid;
    String phoneNo;
    int userid;

    ProfileModel({
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.loginid,
        required this.phoneNo,
        required this.userid,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        email: json["Email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        loginid: json["loginid"],
        phoneNo: json["phone_no"],
        userid: json["userid"],
    );

    Map<String, dynamic> toJson() => {
        "Email": email,
        "first_name": firstName,
        "last_name": lastName,
        "loginid": loginid,
        "phone_no": phoneNo,
        "userid": userid,
    };
}
