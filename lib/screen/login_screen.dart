import 'package:flutter/material.dart';
import 'package:food_pick_app/common/snackbar_util.dart';
import 'package:food_pick_app/widget/button.dart';
import 'package:food_pick_app/widget/text.dart';
import 'package:food_pick_app/widget/textformfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 160,
              ),
              const Center(
                child: Text(
                  'Food PICK',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 53,
              ),
              SectionText(
                text: '이메일',
                textColor: const Color(0xff979797),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormFieldCustom(
                hintText: '이메일 입력해주세요',
                isPasswordFild: false,
                isReadOnly: false,
                keboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) => inputEmailValidator(value),
                controller: _emailController,
              ),
              SizedBox(
                height: 24,
              ),
              SectionText(
                text: '비밀번호',
                textColor: const Color(0xff979797),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormFieldCustom(
                hintText: '비밀번호 입력해주세요',
                isPasswordFild: true,
                maxLines: 1,
                isReadOnly: false,
                keboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                validator: (value) => inputPasswordValidator(value),
                controller: _passwordController,
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: double.infinity,
                height: 52,
                child: ElevatedButtonCustom(
                  text: '로그인',
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: () async {
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    bool isLoginSuccess = await loginWithEmail(email, password);

                    if (!context.mounted) return;
                    if (!isLoginSuccess) {
                      showSnackBar(context, '로그인을 실패하였습니다.');
                      return;
                    }

                    Navigator.popAndPushNamed(context, '/main');
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                height: 52,
                child: ElevatedButtonCustom(
                  text: '회원가입',
                  backgroundColor: const Color(0xff979797),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  inputEmailValidator(value) {
    if (value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    return null;
  }

  inputPasswordValidator(value) {
    if (value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    return null;
  }

  Future<bool> loginWithEmail(String email, String password) async {
    bool isLoginSuccess = false;
    final AuthResponse response = await supabase.auth
        .signInWithPassword(email: email, password: password);

    if (response.user != null) {
      isLoginSuccess = true;
    } else {
      isLoginSuccess = false;
    }

    return isLoginSuccess;
  }
}
