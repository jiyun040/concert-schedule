import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../const/colors.dart';
import '../const/text_style.dart';
import '../widgets/input_field.dart';
import '../widgets/bottom_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();

  String? errorMessage;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _pwConfirmController.dispose();
    super.dispose();
  }

  // TODO: 서버 연동 후 삭제 예정 (임시 아이디 중복 체크)
  bool _isDuplicateId(String id) {
    return id == "asdf"; // 예시: "asdf"는 이미 존재하는 아이디
  }

  void _validateAndSubmit() {
    final id = _idController.text.trim();
    final pw = _pwController.text;
    final pwConfirm = _pwConfirmController.text;

    if (_isDuplicateId(id)) {
      setState(() {
        errorMessage = '중복된 아이디 입니다. 다른 아이디로 바꿔주세요.';
      });
      return;
    }

    if (pw != pwConfirm) {
      setState(() {
        errorMessage = '비밀번호가 일치하지 않습니다. 다시 확인 해 주세요.';
      });
      return;
    }

    setState(() {
      errorMessage = null;
    });

    // 가입 처리 실행 코드
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
            icon: Icon(Icons.arrow_back_ios, color: ContiColors.orange200),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Image.asset(
                      'assets/image/logo.png',
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InputField(
                    controller: _pwConfirmController,
                    labelText: '비밀번호 확인',
                    hintText: '비밀번호를 확인해 주세요.',
                    obsecureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z_]')),
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage!,
                      style: ContiTextStyle.warning(ContiColors.red),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BottomButton(
                    text: '회원가입',
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
