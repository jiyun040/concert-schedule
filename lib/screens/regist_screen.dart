import 'package:concert_schedule/const/colors.dart';
import 'package:concert_schedule/const/text_style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _venueController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _selectedImage;
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickImage() async {
    // 이미지 소스 선택 다이얼로그 표시
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ContiColors.white,
          content: Text('사진을 어떻게 추가하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: Text('카메라', style: TextStyle(color: ContiColors.mainOrange)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: Text('갤러리', style: TextStyle(color: ContiColors.mainOrange)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소', style: TextStyle(color: ContiColors.mainBlack)),
            ),
          ],
        );
      },
    );

    if (source != null) {
      try {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        if (pickedFile != null) {
          setState(() {
            _selectedImage = File(pickedFile.path);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미지를 선택하는 중 오류가 발생했습니다.'),
            backgroundColor: ContiColors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      locale: Locale('ko', 'KR'),
      // 캘린더 색상 테마 설정
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ContiColors.mainOrange, // 헤더 배경색
              onPrimary: ContiColors.white, // 헤더 텍스트 색상
              onSurface: ContiColors.mainBlack, // 캘린더 텍스트 색상
              surface: ContiColors.white, // 캘린더 배경색
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ContiColors.mainOrange, // 버튼 텍스트 색상
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text =
          "${picked.year}.${picked.month.toString().padLeft(2, '0')}.${picked.day.toString().padLeft(2, '0')}";
        } else {
          _endDate = picked;
          _endDateController.text =
          "${picked.year}.${picked.month.toString().padLeft(2, '0')}.${picked.day.toString().padLeft(2, '0')}";
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // 공연 등록 로직
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('공연이 성공적으로 등록되었습니다.'),
          backgroundColor: ContiColors.mainOrange,
        ),
      );
      Navigator.pop(context);
    }
  }

  // 공통 InputDecoration 생성 함수
  InputDecoration _buildInputDecoration(String hintText, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: ContiTextStyle.hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: ContiColors.mainOrange),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: ContiColors.mainOrange),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: ContiColors.mainOrange),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: ContiColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: ContiColors.red),
      ),
      contentPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      suffixIcon: suffixIcon,
      errorStyle: TextStyle(color: ContiColors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ContiColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 공연명 입력
              TextFormField(
                controller: _titleController,
                decoration: _buildInputDecoration(
                  '추가하고 싶은 공연 / 페스티벌명 / 콘서트 등의 이름을 입력 해 주세요.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '공연명을 입력해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              // 이미지 업로드
              Container(
                width: double.infinity,
                height: screenHeight * 0.25,
                decoration: BoxDecoration(
                  border: Border.all(color: ContiColors.mainOrange),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: _selectedImage != null
                    ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 이미지 변경/삭제 버튼
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.edit, color: Colors.white, size: 20),
                              onPressed: _pickImage,
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.white, size: 20),
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : InkWell(
                  onTap: _pickImage,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: screenWidth * 0.1,
                        color: ContiColors.black500,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        '일정에 추가 할 사진을 등록 해 주세요. (포스터)',
                        style: ContiTextStyle.hint,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 출연자 입력
              TextFormField(
                controller: _venueController,
                maxLines: 3,
                decoration: _buildInputDecoration(
                  '출연자들을 입력 해 주세요. (여러명일 경우 엔터로 구분)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '출연자를 입력 해 주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              // 날짜 선택
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context, true),
                      decoration: _buildInputDecoration(
                        '시작 날짜',
                        suffixIcon: Icon(Icons.calendar_month, color: ContiColors.mainOrange),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '시작 날짜를 선택해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('~'),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context, false),
                      decoration: _buildInputDecoration(
                        '종료 날짜',
                        suffixIcon: Icon(Icons.calendar_month, color: ContiColors.mainOrange),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '종료 날짜를 선택해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // 장소 입력
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _buildInputDecoration(
                  '공연 / 페스티벌 / 콘서트가 열리는 장소를 입력 해 주세요.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '공연 장소를 입력해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.04),

              // 등록 버튼
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ContiColors.mainOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    '등록 하기',
                    style: ContiTextStyle.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _venueController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}