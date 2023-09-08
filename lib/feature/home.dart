import 'package:flutter/material.dart';
import 'package:front/feature/widget/texts.dart';
import 'package:front/feature/widget/title.dart';
import 'package:front/feature/widget/userinfo.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../states/sharedvalue.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _homeState();
}

class _homeState extends State {
  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) => Container(
      color: const Color(0xff101010),
      child: ListView(children: [
        _allScreen(context),
      ]));

  Widget _allScreen(BuildContext context) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("images/logo.png"),
            Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: _middleScreen(context))),
          ],
        ),
      );

  Widget _middleScreen(BuildContext context) {
    var userId = context.watch<SharedValue>().userId;
    if (userId == -1) {
      //로그인 안됨
      return _welcomeScreen(context);
    } else {
      return Column(children: [
        const Heading("로그인 정보"),
        UserInfo(userId: userId),
        const Heading("가장 좋아하는 영화 목록"),
        BodyText("사용자님이 보고 평가한 영화들에는 어떤 것들이 있을까요?"),
        TitleInfo(
            url: MyConst.apiServerUrl +
                r"/api/userRated?userId=" +
                userId.toString()),
      ]);
    }
  }

  var inputnum = -1;

  Widget _welcomeScreen(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1("Nettopulikkusu의 놀라운 영화들을 만나보세요"),
          TextField(
            decoration: const InputDecoration(
              labelText: '유저 번호를 입력하세요.',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              int? val = int.tryParse(value);
              if (val == null || val <= 0) {
                inputnum = -1;
              } else {
                inputnum = val;
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Provider.of<SharedValue>(context, listen: false)
                    .setUserId(inputnum);
                setState(() {});
              },
              child: const Text("로그인"),
            ),
          ),
          const SizedBox(height: 40),
        ],
      );
}
