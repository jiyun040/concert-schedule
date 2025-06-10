import 'package:concert_schedule/const/colors.dart';
import 'package:concert_schedule/const/text_style.dart';
import 'package:flutter/material.dart';
import 'package:concert_schedule/screens/record_add_screen.dart';

class PerformanceRecord {
  String id;
  String performanceTitle;
  String venue;
  DateTime recordDate;
  DateTime endDate;
  int rating;
  String? imageUrl;

  PerformanceRecord({
    required this.id,
    required this.performanceTitle,
    required this.venue,
    required this.recordDate,
    required this.endDate,
    required this.rating,
    this.imageUrl,
  });
}

class RecordScreen extends StatefulWidget {
  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<PerformanceRecord> _records = [
    PerformanceRecord(
      id: '1',
      performanceTitle: '2025 아이유 콘서트 <HEREH> - 서울',
      venue: '서울 올림픽공원 잠실실내체육관',
      recordDate: DateTime(2025, 3, 15),
      endDate: DateTime(2025, 3, 16),
      rating: 5,
    ),
    PerformanceRecord(
      id: '2',
      performanceTitle: '2025 아이유 콘서트 <HEREH> - 서울',
      venue: '서울 올림픽공원 잠실실내체육관',
      recordDate: DateTime(2025, 3, 15),
      endDate: DateTime(2025, 3, 16),
      rating: 5,
    ),
    PerformanceRecord(
      id: '3',
      performanceTitle: '2025 아이유 콘서트 <HEREH> - 서울',
      venue: '서울 올림픽공원 잠실실내체육관',
      recordDate: DateTime(2025, 3, 15),
      endDate: DateTime(2025, 3, 16),
      rating: 5,
    ),
    PerformanceRecord(
      id: '4',
      performanceTitle: '2025 아이유 콘서트 <HEREH> - 서울',
      venue: '서울 올림픽공원 잠실실내체육관',
      recordDate: DateTime(2025, 3, 15),
      endDate: DateTime(2025, 3, 16),
      rating: 5,
    ),
    PerformanceRecord(
      id: '5',
      performanceTitle: '2025 아이유 콘서트 <HEREH> - 서울',
      venue: '서울 올림픽공원 잠실실내체육관',
      recordDate: DateTime(2025, 3, 15),
      endDate: DateTime(2025, 3, 16),
      rating: 5,
    ),
    PerformanceRecord(
      id: '6',
      performanceTitle: '2025 아이유 콘서트 <HEREH> - 서울',
      venue: '서울 올림픽공원 잠실실내체육관',
      recordDate: DateTime(2025, 3, 15),
      endDate: DateTime(2025, 3, 16),
      rating: 5,
    ),
  ];

  void _addNewRecord() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordAddScreen(),
      ),
    );

    if (result != null && result is PerformanceRecord) {
      setState(() {
        _records.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ContiColors.white,
      body: Column(
        children: [
          Container(
            color: ContiColors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '총 ${_records.length}개 등록되어 있습니다.',
                  style: ContiTextStyle.hint,
                ),
                ElevatedButton(
                  onPressed: _addNewRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ContiColors.mainOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                  child: Text(
                    '기록하기',
                    style: ContiTextStyle.button,
                  ),
                ),
              ],
            ),
          ),

          // 공연 기록 목록
          Expanded(
            child: _records.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_note, size: 60, color: ContiColors.black500),
                  SizedBox(height: 16),
                  Text(
                    '아직 기록된 공연이 없습니다.',
                    style: TextStyle(color: ContiColors.black500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '첫 번째 공연 기록을 남겨보세요!',
                    style: TextStyle(color: ContiColors.black500),
                  ),
                ],
              ),
            )
                : Container(
              padding: EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final record = _records[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ContiColors.black100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.performanceTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ContiColors.mainOrange,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          record.venue,
                          style: ContiTextStyle.listLocationDate
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${record.recordDate.year}.${record.recordDate.month.toString().padLeft(2, '0')}.${record.recordDate.day.toString().padLeft(2, '0')} ~ ${record.endDate.year}.${record.endDate.month.toString().padLeft(2, '0')}.${record.endDate.day.toString().padLeft(2, '0')}',
                          style: ContiTextStyle.listLocationDate
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}