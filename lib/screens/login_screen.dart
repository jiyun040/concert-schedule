import 'package:concert_schedule/const/colors.dart';
import 'package:concert_schedule/const/text_style.dart';
import 'package:concert_schedule/widgets/bottom_button.dart';
import 'package:concert_schedule/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
<<<<<<< HEAD

=======
>>>>>>> ea16fd7 (login_screen 등 화면 추가)
import '../utils/input_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final id = _idController.text;
    final pw = _pwController.text;

    final isValid =
        InputValidator.isValidId(id) && InputValidator.isValidPassword(pw);

    if (!isValid) {
      setState(() {
        errorMessage = '정보가 일치하지 않습니다. 다시 확인 해 주세요.';
      });
      return;
    }

    setState(() {
      errorMessage = null;
    });

    // 로그인 성공 시 실행할 코드
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ContiColors.white,
        appBar: AppBar(
          backgroundColor: ContiColors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: ContiColors.orange200,
              )),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
<<<<<<< HEAD
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
=======
              crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> ea16fd7 (login_screen 등 화면 추가)
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Image.asset('assets/image/logo.png',
                          width: MediaQuery.of(context).size.width * 0.5)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InputField(
                    controller: _idController,
                    labelText: '아이디',
                    hintText: '영어 소문자 6자 내로 입력해 주세요.',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-z]')),
                      LengthLimitingTextInputFormatter(6),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InputField(
                    controller: _pwController,
                    labelText: '비밀번호',
                    hintText: '15자 내로 입력해 주세요. (특수문자는 언더바만 허용)',
                    obsecureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z_]')),
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                ),
<<<<<<< HEAD

=======
>>>>>>> ea16fd7 (login_screen 등 화면 추가)
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage!,
                      style: ContiTextStyle.warning(ContiColors.red),
                    ),
                  ),
<<<<<<< HEAD

=======
>>>>>>> ea16fd7 (login_screen 등 화면 추가)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BottomButton(
                    text: '로그인',
                    onTap: _validateAndSubmit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
