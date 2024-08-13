import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_pick_app/widget/appbar.dart';
import 'package:food_pick_app/widget/button.dart';
import 'package:food_pick_app/widget/text.dart';
import 'package:food_pick_app/widget/textformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daum_postcode_search/data_model.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  File? storeImg;

  final formKey = GlobalKey<FormState>();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeCommentController = TextEditingController();
  DataModel? dataModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: '맛집 등록하기',
        isLeading: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 맛집 사진,
                GestureDetector(
                  child: _buildStoreImg(),
                  onTap: () {
                    showBottomSheetAboutStoreImg();
                  },
                ),

                // 맛집위치,
                const SizedBox(height: 24),
                SectionText(
                  text: '맛집 위치 (도로명 주소)',
                  textColor: Colors.black,
                ),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '클릭하여 주소 입력',
                  isPasswordFild: false,
                  isReadOnly: true,
                  keboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputAddressValidator(value),
                  controller: _storeAddressController,
                  onTap: () async {
                    // 주소검색웹뷰
                    var result =
                        await Navigator.pushNamed(context, '/search_address');

                    if (result != null) {
                      setState(() {
                        dataModel = result as DataModel;
                        _storeAddressController.text =
                            dataModel?.roadAddress ?? '맛집 위치를 선택 해주세요.';
                      });
                    }
                  },
                ),
                // 맛집별명,
                const SizedBox(height: 24),
                SectionText(
                  text: '맛집 별명',
                  textColor: Colors.black,
                ),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '별명을 입력해주세요',
                  isPasswordFild: false,
                  isReadOnly: false,
                  keboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputNickValidator(value),
                  controller: _storeNameController,
                ),
                // 메모,
                const SizedBox(height: 24),
                SectionText(
                  text: '메모',
                  textColor: Colors.black,
                ),
                const SizedBox(height: 8),
                TextFormFieldCustom(
                  hintText: '메모를 입력해주세요',
                  isPasswordFild: false,
                  isReadOnly: false,
                  keboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => inputCommentValidator(value),
                  controller: _storeCommentController,
                  maxLines: 5,
                ),
                // 등록완료,
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 69,
                  child: ElevatedButtonCustom(
                    text: '맛집 등록 완료',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
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

  Widget _buildStoreImg() {
    // default image
    if (storeImg == null) {
      return Container(
        width: double.infinity,
        height: 140,
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: const Icon(
          Icons.image_search,
          size: 96,
          color: Colors.white,
        ),
      );
    }
    // 맛집 정보 사진
    else {
      return Container(
          width: double.infinity,
          height: 140,
          decoration: ShapeDecoration(
            color: Colors.grey[300],
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Image.file(
            storeImg!,
            fit: BoxFit.contain,
          ));
    }
  }

  void showBottomSheetAboutStoreImg() {
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
              storeImg == null
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
        storeImg = File(image.path);
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
        storeImg = File(image.path);
      });
    }
  }

  void deleteProfileImage() {
    setState(() {
      storeImg = null;
    });
  }

  inputAddressValidator(value) {
    if (value.isEmpty) {
      return '주소를 입력해주세요';
    }
    return null;
  }

  inputNickValidator(value) {
    if (value.isEmpty) {
      return '매장별명을 입력해주세요';
    }
    return null;
  }

  inputCommentValidator(value) {
    if (value.isEmpty) {
      return '메모를 입력해주세요';
    }
    return null;
  }
}
