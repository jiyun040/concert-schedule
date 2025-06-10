import 'package:concert_schedule/const/colors.dart';
import 'package:concert_schedule/const/text_style.dart';
import 'package:flutter/material.dart';
import 'package:concert_schedule/screens/record_screen.dart';

class SavedPerformance {
  String id;
  String title;
  String venue;
  DateTime startDate;
  DateTime endDate;
  DateTime addedDate;

  SavedPerformance({
    required this.id,
    required this.title,
    required this.venue,
    required this.startDate,
    required this.endDate,
    required this.addedDate,
  });
}

class RecordAddScreen extends StatefulWidget {
  @override
  _RecordAddScreenState createState() => _RecordAddScreenState();
}

class _RecordAddScreenState extends State<RecordAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  final _searchController = TextEditingController();

  SavedPerformance? _selectedPerformance;
  int _rating = 0;
  DateTime? _attendanceDate;
  List<SavedPerformance> _filteredPerformances = [];

  // 사용자가 리스트에 추가한 공연들 (추가된 순서대로 정렬)
  final List<SavedPerformance> _savedPerformances = [
    SavedPerformance(
      id: '1',
      title: '2025 아이유 콘서트 <HEREH> - 서울',
      venue: '서울 올림픽공원 잠실실내체육관',
      startDate: DateTime(2025, 4, 26),
      endDate: DateTime(2025, 4, 27),
      addedDate: DateTime(2025, 3, 1),
    ),
    SavedPerformance(
      id: '2',
      title: 'KT&G 상상실현 페스티벌',
      venue: '올림픽공원',
      startDate: DateTime(2025, 4, 18),
      endDate: DateTime(2025, 4, 19),
      addedDate: DateTime(2025, 3, 5),
    ),
    SavedPerformance(
      id: '3',
      title: '서울파크뮤직페스티벌',
      venue: '올림픽공원 88잔디마당 / KSPO DOME',
      startDate: DateTime(2025, 6, 28),
      endDate: DateTime(2025, 6, 29),
      addedDate: DateTime(2025, 3, 10),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredPerformances = List.from(_savedPerformances);
  }

  void _filterPerformances(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPerformances = List.from(_savedPerformances);
      } else {
        _filteredPerformances = _savedPerformances
            .where((performance) =>
        performance.title.toLowerCase().contains(query.toLowerCase()) ||
            performance.venue.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showAlert(String title, {String? message, bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ContiColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            title,
            style: ContiTextStyle.title,
          ),
          content: message != null ? Text(
            message,
            style: TextStyle(
              color: ContiColors.black500,
            ),
          ) : null,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '확인',
                style: TextStyle(
                  color: isSuccess ? ContiColors.mainOrange : ContiColors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPerformanceSelector() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // 검색 초기화
    _searchController.clear();
    _filteredPerformances = List.from(_savedPerformances);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ContiColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: screenHeight * 0.8,
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: ContiColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    width: screenWidth * 0.1,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    '공연 선택',
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // 검색 필드
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: ContiColors.mainOrange),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '공연명으로 검색 해 주세요.',
                        hintStyle: ContiTextStyle.hint,
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: ContiColors.mainOrange),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.clear, color: ContiColors.black500),
                          onPressed: () {
                            _searchController.clear();
                            _filterPerformances('');
                            setModalState(() {});
                          },
                        )
                            : null,
                      ),
                      onChanged: (value) {
                        _filterPerformances(value);
                        setModalState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  Expanded(
                    child: _filteredPerformances.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '검색 결과가 없습니다.',
                            style: TextStyle(
                                color: ContiColors.black500
                            ),
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      itemCount: _filteredPerformances.length,
                      itemBuilder: (context, index) {
                        final performance = _filteredPerformances[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                          color: ContiColors.white,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              performance.title,
                              style: ContiTextStyle.listTitle,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  performance.venue,
                                  style: ContiTextStyle.listLocationDate,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '${performance.startDate.year}.${performance.startDate.month.toString().padLeft(2, '0')}.${performance.startDate.day.toString().padLeft(2, '0')} ~ ${performance.endDate.year}.${performance.endDate.month.toString().padLeft(2, '0')}.${performance.endDate.day.toString().padLeft(2, '0')}',
                                  style: ContiTextStyle.listLocationDate,
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                _selectedPerformance = performance;
                                _attendanceDate = null; // 날짜 초기화
                              });
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectAttendanceDate() async {
    if (_selectedPerformance == null) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedPerformance!.startDate,
      firstDate: _selectedPerformance!.startDate,
      lastDate: _selectedPerformance!.endDate,
      locale: Locale('ko', 'KR'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ContiColors.mainOrange,
              onPrimary: ContiColors.white,
              onSurface: ContiColors.mainBlack,
              surface: ContiColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ContiColors.mainOrange,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _attendanceDate = picked;
      });
    }
  }

  void _submitRecord() {
    // 1000자 제한 검증
    if (_reviewController.text.length > 1000) {
      _showAlert(
        '후기는 1000자 이내로 작성해주세요.\n(현재: ${_reviewController.text.length}자)',
      );
      return;
    }

    if (_formKey.currentState!.validate() &&
        _selectedPerformance != null &&
        _attendanceDate != null &&
        _rating > 0) {

      final newRecord = PerformanceRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        performanceTitle: _selectedPerformance!.title,
        venue: _selectedPerformance!.venue,
        recordDate: _attendanceDate!,
        rating: _rating,
        endDate: _selectedPerformance!.endDate,
      );

      // 성공 알림 표시 후 화면 닫기
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: ContiColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              '기록 완료',
              style: TextStyle(
                color: ContiColors.mainBlack,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: Text(
              '공연 기록이 성공적으로 저장되었습니다.',
              style: TextStyle(
                color: ContiColors.black500,
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 다이얼로그 닫기
                  Navigator.pop(context, newRecord); // 화면 닫고 데이터 전달
                },
                child: Text(
                  '확인',
                  style: TextStyle(
                    color: ContiColors.mainOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      _showAlert(
        '필수 항목 누락',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ContiColors.mainBlack),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 공연 선택
              GestureDetector(
                onTap: _showPerformanceSelector,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: ContiColors.mainOrange),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedPerformance?.title ?? '공연을 선택해 주세요',
                          style: ContiTextStyle.hint,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: ContiColors.mainOrange,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 관람 날짜 선택
              GestureDetector(
                onTap: _selectedPerformance != null ? _selectAttendanceDate : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedPerformance != null
                          ? ContiColors.mainOrange
                          : ContiColors.mainOrange,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _attendanceDate != null
                              ? '${_attendanceDate!.year}.${_attendanceDate!.month.toString().padLeft(2, '0')}.${_attendanceDate!.day.toString().padLeft(2, '0')}'
                              : '관람 날짜를 선택해 주세요',
                          style: ContiTextStyle.hint,
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color: _selectedPerformance != null
                            ? ContiColors.mainOrange
                            : ContiColors.black500,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // 별점 선택
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: ContiColors.mainOrange,
                    ),
                  );
                }),
              ),
              SizedBox(height: screenHeight * 0.03),

              // 후기 작성
              Container(
                height: screenHeight * 0.25,
                child: TextFormField(
                  controller: _reviewController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: '기록을 남겨 주세요. 길지 않아도 괜찮아요! (단, 1000자 내)',
                    hintStyle: ContiTextStyle.hint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ContiColors.mainOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ContiColors.mainOrange),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ContiColors.mainOrange),
                    ),
                    counterText: '${_reviewController.text.length}/1000',
                    counterStyle: TextStyle(
                      color: _reviewController.text.length > 1000
                          ? ContiColors.red
                          : ContiColors.black500,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    height: 1.5,
                  ),
                  onChanged: (value) {
                    setState(() {}); // 글자 수 업데이트를 위해
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '후기를 작성해주세요';
                    }
                    if (value.length > 1000) {
                      return '후기는 1000자 이내로 작성해주세요';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // 기록하기 버튼 (왼쪽 정렬, 텍스트 크기에 맞춤)
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: _submitRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ContiColors.mainOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    '기록하기',
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
    _reviewController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}