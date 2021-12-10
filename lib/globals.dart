import 'package:puchlo/models/user.dart';
import 'dart:math';

//measurements
double height, width;

//user
UserinApp userinApp;

//categories
List categories = [
  'All',
  'Politics',
  'Technology',
  'Global',
  'Science',
  'Sports',
  'Business',
  'Gaming',
  'Entertainment',
  'Automobile',
  'Health'
];

List categories2 = [
  'Politics',
  'Technology',
  'Global',
  'Science',
  'Sports',
  'Business',
  'Gaming',
  'Entertainment',
  'Automobile',
  'Health'
];

//random string
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
