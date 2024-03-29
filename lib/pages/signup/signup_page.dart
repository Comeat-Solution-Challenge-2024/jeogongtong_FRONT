import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jeogongtong_front/constants/colors.dart';
import 'package:jeogongtong_front/pages/signup/nickname_page.dart';
import 'package:jeogongtong_front/provider/signup/signup_provider.dart';
import 'package:jeogongtong_front/provider/signup/signup_state.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const String routeName = '/signup';
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final nicknameState = context.watch<SignupState>();

    if (nicknameState.signupStatus == SignupStatus.beforeNickname) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, NicknamePage.routeName);
      });
    }
    return SafeArea(
        child: Scaffold(
      backgroundColor: mainColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "공부의 저금고,",
                style: GoogleFonts.blackHanSans(
                  fontSize: 26,
                  color: Colors.white,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "저공통",
              style: GoogleFonts.blackHanSans(
                fontSize: 68,
                color: Colors.white,
                letterSpacing: 4,
                //fontWeight: FontWeight.bold,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Flexible(
                child: SvgPicture.asset(
                  "assets/images/app_icon.svg",
                ),
              ),
            ]),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<SignupProvider>().signInWithGoogle();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, // 패딩 제거
              ),
              child: SvgPicture.asset(
                "assets/images/google_login.svg",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<SignupProvider>().signInWithGoogle();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: SvgPicture.asset(
                "assets/images/kakao_login.svg",
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
