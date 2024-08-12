import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_pick_app/common/snackbar_util.dart';
import 'package:food_pick_app/model/user.dart';
import 'package:food_pick_app/widget/appbar.dart';
import 'package:food_pick_app/widget/button.dart';
import 'package:food_pick_app/widget/text.dart';
import 'package:food_pick_app/widget/textformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  File? profileImage;

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _introduceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: 'FOOD PICK 가입하기',
        isLeading: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // profile image,
                GestureDetector(
                  child: _buildProfile(),
                  onTap: () {
                    showBottomSheetAboutProfile();
                  },
                ),

                // section,
                SectionText(text: '닉네임', textColor: Color(0xff979797)),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '닉네임을 입력해주세요',
                  isPasswordFild: false,
                  isReadOnly: false,
                  keboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputNameValidator(value),
                  controller: _nicknameController,
                ),
                const SizedBox(height: 16),

                SectionText(text: '이메일', textColor: Color(0xff979797)),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '이메일 입력해주세요',
                  isPasswordFild: false,
                  isReadOnly: false,
                  keboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputEmailValidator(value),
                  controller: _emailController,
                ),
                const SizedBox(height: 16),

                SectionText(text: '비밀번호', textColor: Color(0xff979797)),
                const SizedBox(height: 8),
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
                const SizedBox(height: 16),

                SectionText(text: '비밀번호 확인', textColor: Color(0xff979797)),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '비밀번호 확인 입력해주세요',
                  isPasswordFild: true,
                  maxLines: 1,
                  isReadOnly: false,
                  keboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputPasswordConfirmValidator(value),
                  controller: _passwordConfirmController,
                ),
                const SizedBox(height: 16),

                SectionText(text: '자기소개', textColor: Color(0xff979797)),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '자기소개를 입력해주세요',
                  isPasswordFild: false,
                  maxLines: 10,
                  isReadOnly: false,
                  keboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputIntroduceValidator(value),
                  controller: _introduceController,
                ),
                const SizedBox(height: 16),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButtonCustom(
                    text: '가입 완료',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () async {
                      // 가입완료시 호출
                      String emailValue = _emailController.text;
                      String passwordValue = _passwordController.text;

                      // 유효성 검사
                      if (!formKey.currentState!.validate()) {
                        // 가입완료
                        return;
                      }

                      // supabase에 계정등록
                      bool result =
                          await registerAccount(emailValue, passwordValue);

                      if (!context.mounted) return;
                      if (result) {
                        // 가입완료
                        showSnackBar(context, '가입에 성공했습니다.');
                        Navigator.pop(context);
                      } else {
                        // 가입실패
                        showSnackBar(context, '가입에 실패했습니다.');
                        return;
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildProfile() {
    return Center(
      child: profileImage == null
          ? CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 48,
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 48,
              ))
          : CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 48,
              backgroundImage: FileImage(profileImage!),
            ),
    );
  }

  void showBottomSheetAboutProfile() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  // 사진촬영
                  Navigator.pop(context);
                  getCameraImage();
                },
                child: Text(
                  '사진촬영',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  getGalleryImage();
                },
                child: Text(
                  '앨범에서 사진선택',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                  ),
                ),
              ),
              profileImage == null
                  ? SizedBox()
                  : TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        deleteProfileImage();
                      },
                      child: Text(
                        '프로필 사진삭제',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getCameraImage() async {
    // 카메라로 사진 촬영하여 이미지 파일 가져오는 메서드
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
    );
    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  Future<void> getGalleryImage() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  void deleteProfileImage() {
    setState(() {
      profileImage = null;
    });
  }

  inputNameValidator(value) {
    if (value.isEmpty) {
      return '닉네임을 입력해주세요';
    }
    return null;
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

  inputPasswordConfirmValidator(value) {
    if (value.isEmpty) {
      return '비밀번호 확인을 입력해주세요';
    }
    return null;
  }

  inputIntroduceValidator(value) {
    if (value.isEmpty) {
      return '자기소개를 입력해주세요';
    }
    return null;
  }

  Future<bool> registerAccount(String emailValue, String passwordValue) async {
    bool isRegisterSuccess = false;
    final AuthResponse res =
        await supabase.auth.signUp(email: emailValue, password: passwordValue);

    if (res.user != null) {
      isRegisterSuccess = true;

      // 프로필 이미지 업로드
      DateTime nowTime = DateTime.now();

      String? imageUrl;
      if (profileImage != null) {
        final imgFile = profileImage!;
        final fineName = 'profiles/${res.user!.id}_${nowTime.toString()}.jpg';

        await supabase.storage.from('food_pick').upload(
              fineName,
              imgFile,
              fileOptions: FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        // 업로드 된 파일 url
        imageUrl = supabase.storage.from('food_pick').getPublicUrl(fineName);
      }

      await supabase.from('user').insert(
            UserModel(
              uid: res.user!.id,
              name: _nicknameController.text,
              email: emailValue,
              introduce: _introduceController.text,
              profileUrl: imageUrl,
            ).toMap(),
          );
      // data insert
    } else {
      isRegisterSuccess = false;
    }

    return isRegisterSuccess;
  }
}
