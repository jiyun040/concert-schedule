import 'package:concert_schedule/const/colors.dart';
import 'package:concert_schedule/widgets/bottom_button.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ContiColors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset('assets/image/logo.png', width: MediaQuery.of(context).size.width * 0.6,)
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      BottomButton(
                        text: '로그인',
                        width: double.infinity,
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                      SizedBox(height: 20),
                      BottomButton(
                        text: '회원가입',
                        width: double.infinity,
                        onTap: () {
<<<<<<< HEAD
                          Navigator.pushNamed(context, '/join');
=======
                          Navigator.pushNamed(context, '/signup');
>>>>>>> ea16fd7 (login_screen 등 화면 추가)
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
