import 'dart:math';

import 'package:flutter/material.dart';
import 'package:front/feature/widget/texts.dart';
import 'package:front/feature/widget/title.dart';
import 'package:front/feature/widget/userinfo.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../states/sharedvalue.dart';

class RecommendScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecommendState();
}

class _RecommendState extends State {
  int userId = -1;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) => Container(
      color: const Color(0xff101010),
      child: ListView(shrinkWrap: true, children: [
        _allScreen(context),
      ]));

  Widget _allScreen(BuildContext context) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        const Heading("같은 직업 기반으로 추천"),
        const BodyText("같은 직업을 가진 분들은 어떤 영화를 선호할까요?"),
        TitleInfo(
            url: MyConst.apiServerUrl+r"/api/userOccupationRF?userId=" +
                userId.toString()),
        const Heading("연령대 기반으로 추천"),
        const BodyText("비슷한 연령대의 넷토플릭서님들은 어떤 영화를 볼까요?"),
        TitleInfo(
            url: MyConst.apiServerUrl+r"/api/userAgeRF?userId=" +
                userId.toString()),
        const Heading("KNN 알고리즘 기반으로 추천"),
        const BodyText("훌륭한 알고리즘 기반의 당신을 만족시켜 줄 영화 목록이에요."),
        TitleInfo(
            url: MyConst.apiServerUrl+r"/api/userKNNRF?userId=" +
                userId.toString()),
        const Heading("좋아하는 장르에서 추천"),
        const BodyText("이런 장르 좋아하시지 않나요?"),
        TitleInfo(
            url: MyConst.apiServerUrl+r"/api/userGenreRF?userId=" +
                userId.toString()),
      ]);
    }
  }

  var inputnum = -1;

  Widget _welcomeScreen(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1("로그인이 필요해요"),
        ],
      );
}
