import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
final storage = FlutterSecureStorage();


//애뮬레이터 로컬
final emulatorIp = '10.0.2.2:3000';
//시뮬레이터 로컬
final simulatorIp = '127.0.0.1:3000';
//아이폰일 경우 시뮬레이터 아이피 아닐 경우 애뮬레이터 아이피
final ip = Platform.isIOS ? simulatorIp : emulatorIp;