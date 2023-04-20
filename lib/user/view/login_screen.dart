

import 'dart:convert';
import 'dart:io';

import 'package:delivery_changmin/common/const/colors.dart';
import 'package:delivery_changmin/common/const/data.dart';
import 'package:delivery_changmin/common/layout/default_layout.dart';
import 'package:delivery_changmin/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/component/custom_text_form_field.dart';


class LoginScrenn extends StatefulWidget {
  const LoginScrenn({Key? key}) : super(key: key);

  @override
  State<LoginScrenn> createState() => _LoginScrennState();
}

class _LoginScrennState extends State<LoginScrenn> {

  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final storage = FlutterSecureStorage();
    final dio = Dio();
    //애뮬레이터 로컬
    final emulatorIp = '10.0.2.2:3000';
    //시뮬레이터 로컬
    final simulatorIp = '127.0.0.1:3000';
    //아이폰일 경우 시뮬레이터 아이피 아닐 경우 애뮬레이터 아이피
    final ip = Platform.isIOS ? simulatorIp : emulatorIp;

    return DefaultLayout(
        child:
            //SingleChildScrollView를 사용하면 화면 스크롤 가능
        SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SafeArea(
            top: true,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Title(),
                  const SizedBox(height: 16,),
                  _SubTitle(),
                  Image.asset(
                    'asset/img/misc/logo.png',
                    height: MediaQuery.of(context).size.width /3 * 2,
                  ),
                  const SizedBox(height: 16,),
                  CustomTextFormField(
                    onChanged: (String value) {
                      username = value;
                    },
                    hintText: '이메일을 입력해주세요',
                  ),
                  const SizedBox(height: 16,),
                  CustomTextFormField(
                    onChanged: (String value) {
                      password = value;
                    },
                    hintText: '비밀번호을 입력해주세요',
                    obscureText: true,
                  ),
                  const SizedBox(height: 16,),
                  ElevatedButton(
                      onPressed: () async {
                        //ID:비밀번호
                        final rawString = '$username:$password';
                        //Base 64 인코더
                        Codec<String,String> stringToBase64 = utf8.fuse(base64);
                        //rawString 인코딩
                        String token = stringToBase64.encode(rawString);

                        //에러가 나면 다음 코드 실행X
                        final resp = await dio.post(
                          'http://$ip/auth/login',
                          options: Options(
                            headers: {
                              'authorization': 'Basic $token',
                            }
                          )
                        );

                        final refreshToken = resp.data['refreshToken'];
                        final accessToken = resp.data['accessToken'];

                        await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RootTab())
                        );
                        print(resp.data);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: PRIMARY_COLOR
                      ),
                      child: Text(
                        '로그인'
                      )),
                  TextButton(
                      onPressed: () async {

                      },
                      style: TextButton.styleFrom(
                        primary: Colors.black
                      ),
                      child: Text(
                        '회원가입'
                      )
                  )
                ],
      ),
            ),
          ),
        )
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('환영합니다!',
         style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w500,
          color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n 오늘도 성공적인 주문이 되길 :) ',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR
      ),
    );
  }
}

