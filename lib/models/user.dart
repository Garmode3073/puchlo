import 'package:flutter/material.dart';

class UserinApp {
  String _uid;
  String _email;
  String _password;
  String _phoneNumber;
  String _name;
  String _bio;
  int _date;
  int _month;
  int _year;

  String get uid => this._uid;
  String get email => this._email;
  String get password => this._password;
  String get phoneNumber => this._phoneNumber;
  String get name => this._name;
  String get bio => this._bio;
  int get date => this._date;
  int get month => this._month;
  int get year => this._year;

  set uid(id) {
    this._uid = id;
  }

  set email(email) {
    this._email = email;
  }

  set password(password) {
    this._password = password;
  }

  set phoneNumber(phoneNumber) {
    this._phoneNumber = phoneNumber;
  }

  set name(name) {
    this._name = name;
  }

  set bio(bio) {
    this._bio = bio;
  }

  set date(date) {
    this._date = date;
  }

  set month(month) {
    this._month = month;
  }

  set year(year) {
    this._year = year;
  }

  UserinApp.fromMap(Map map) {
    this.uid = map["uid"];
    this.email = map["email"];
    this.password = map["password"];
    this.phoneNumber = map["phoneNumber"];
    this.name = map["name"];
    this.bio = map["bio"];
    this.date = map["date"];
    this.month = map["month"];
    this.year = map["year"];
  }

  Map toMap() {
    return {
      'uid': this.uid,
      'email': this.email,
      'password': this.password,
      'phoneNumber': this.phoneNumber,
      'name': this.name,
      "bio": this.bio,
      "date": this.date,
      "month": this.month,
      "year": this.year,
    };
  }
}
