import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'dart:convert';

import '../../constants/constants.dart';

class User{
  int userId;
  int age;
  String gender;
  String occupation;
  String zipcode;

  User({required this.userId, required this.age, required this.gender, required this.occupation, required this.zipcode});

  factory User.fromJson(Map<String, dynamic> parsedJson){
    return User(
      userId: parsedJson['userId'],
      age: parsedJson['age'],
      gender: parsedJson['gender'],
      occupation: parsedJson['occupation'],
      zipcode: parsedJson['zipcode'],
    );
  }
}

class UserInfo extends StatelessWidget{
  int userId;

  UserInfo({required this.userId});

  Future<User> fetchData() async {
    final response = await http.get(Uri.parse(MyConst.apiServerUrl+r"/api/userInfo?userId="+userId.toString()));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final User data = User.fromJson(jsonData);
      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final d = snapshot.data!;
              final icon=[Icons.person, Icons.date_range_sharp, Icons.girl, Icons.sensor_occupied, Icons.place];
              final column=["유저 id", "나이", "성별", "직업", "주소지"];
              final data=[d.userId.toString(), d.age.toString(), d.gender, d.occupation, d.zipcode];
              return Column(
                children: List<Widget>.generate(5, (index) => ListTile(
                  leading: Icon(icon[index], color: Colors.white,),
                  title: Text(column[index]),
                  trailing: Text(data[index]),
                ),),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
    );
  }
}
