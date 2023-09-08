import 'package:flutter/material.dart';
import 'package:front/feature/widget/texts.dart';
import 'package:front/icons/custom_icon_icons.dart';
import 'package:front/states/sharedvalue.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _settingState();
}

class _settingState extends State {

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: const Color(0xff101010),
      child: _allBody(context),
    );
  }

  Widget _allBody(BuildContext context) {
    final icon = [Icons.person];
    final column = ["로그인 상태"];
    final data = [_loginState];
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          children: [
            const Heading("설정"),
            Column(
              children: List<Widget>.generate(
                icon.length,
                (index) => ListTile(
                  leading: Icon(
                    icon[index],
                    color: Colors.white,
                  ),
                  title: Text(column[index]),
                  trailing: data[index](context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loginState(BuildContext context) {
    var userId = context.watch<SharedValue>().userId;
    if (userId == -1) {
      return Text("로그인 안됨");
    } else {
      return TextButton(
        onPressed: () {
          Provider.of<SharedValue>(context, listen: false).setUserId(-1);
          setState(() {});
        },
        child: const Text("로그아웃"),
      );
    }
  }
}
