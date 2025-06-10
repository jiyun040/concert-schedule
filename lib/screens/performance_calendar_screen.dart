import 'package:concert_schedule/const/colors.dart';
import 'package:concert_schedule/const/text_style.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Performance {
  String id;
  String title;
  String location;
  DateTime startDate;
  DateTime endDate;
  String? imageUrl;

  Performance({
    required this.id,
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
  });
}

class PerformanceCalendarScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  PerformanceCalendarScreen({this.onBackPressed});

  @override
  _PerformanceCalendarScreenState createState() => _PerformanceCalendarScreenState();
}

class _PerformanceCalendarScreenState extends State<PerformanceCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showPerformanceList = false;

  final Map<DateTime, List<Performance>> _performances = {
    DateTime.utc(2025, 3, 15): [
      Performance(
        id: '1',
        title: '서울파크뮤직페스티벌',
        location: '올림픽공원 88잔디마당 / KSPO DOME',
        startDate: DateTime.utc(2025, 6, 28),
        endDate: DateTime.utc(2025, 6, 29),
      ),
      Performance(
        id: '2',
        title: '부산재즈페스티벌',
        location: '벡스코 / 부산',
        startDate: DateTime.utc(2025, 3, 15),
        endDate: DateTime.utc(2025, 3, 16),
      ),
    ],
    DateTime.utc(2025, 3, 22): [
      Performance(
        id: '3',
        title: 'KT&G 상상실현 페스티벌',
        location: '올림픽공원',
        startDate: DateTime.utc(2025, 3, 22),
        endDate: DateTime.utc(2025, 3, 23),
      ),
    ],
  };

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<Performance> _getPerformancesForDay(DateTime day) {
    return _performances[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  void _showPerformanceDetail(Performance performance) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PerformanceDetailScreen(
          performance: performance,
          onEdit: (updatedPerformance) {
            setState(() {
              for (var entry in _performances.entries) {
                final list = entry.value;
                final index = list.indexWhere((p) => p.id == performance.id);
                if (index != -1) {
                  list[index] = updatedPerformance;
                  break;
                }
              }
            });
          },
          onDelete: () {
            setState(() {
              for (var entry in _performances.entries) {
                entry.value.removeWhere((p) => p.id == performance.id);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 달력 또는 공연 목록
          Expanded(
            child: _showPerformanceList ? _buildPerformanceListView() : _buildCalendarView(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        TableCalendar(
          locale: 'ko_KR',
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextFormatter: (date, locale) =>
            "${date.year}.${date.month.toString().padLeft(2, '0')}",
            titleTextStyle: ContiTextStyle.calendarDate,
            leftChevronIcon: Icon(Icons.chevron_left),
            rightChevronIcon: Icon(Icons.chevron_right),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: DateTime.now().weekday == DateTime.saturday || DateTime.now().weekday == DateTime.sunday
                  ? ContiColors.mainOrange
                  : ContiColors.mainBlack,
              fontWeight: FontWeight.bold,
            ),
            selectedDecoration: BoxDecoration(
              color: ContiColors.mainOrange,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(
              color: ContiColors.mainOrange,
              fontWeight: FontWeight.bold,
            ),
            defaultTextStyle: TextStyle(
              color: ContiColors.mainBlack,
            ),
            outsideTextStyle: TextStyle(
              color: ContiColors.black500,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) {
              const days = ['일', '월', '화', '수', '목', '금', '토'];
              return days[date.weekday % 7];
            },
            weekdayStyle: TextStyle(
              color: ContiColors.mainBlack,
            ),
            weekendStyle: TextStyle(
              color: ContiColors.mainOrange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceListView() {
    final selectedEvents = _selectedDay != null ? _getPerformancesForDay(_selectedDay!) : [];

    return Column(
      children: [
        // 뒤로가기 버튼
        Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showPerformanceList = false;
              });
            },
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        // 공연 목록
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: selectedEvents.length,
            itemBuilder: (context, index) {
              final performance = selectedEvents[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        performance.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        performance.location,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${performance.startDate.toString().split(' ')[0]} ~ ${performance.endDate.toString().split(' ')[0]}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _showPerformanceDetail(performance),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text('상세보기', style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () => _showPerformanceDetail(performance),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.orange),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text('수정하기', style: TextStyle(color: Colors.orange)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// PerformanceDetailScreen은 이전과 동일하므로 생략...
class PerformanceDetailScreen extends StatelessWidget {
  final Performance performance;
  final Function(Performance) onEdit;
  final VoidCallback onDelete;

  PerformanceDetailScreen({
    required this.performance,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('서울파크뮤직페스티벌', style: TextStyle(color: Colors.black, fontSize: 18)),
        actions: [
          Icon(Icons.search, color: Colors.orange),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 공연 이미지
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note, size: 60, color: Colors.green),
                    Text('SEOUL PARK MUSIC FESTIVAL', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // 공연 정보
            Text(
              performance.location,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '${performance.startDate.toString().split(' ')[0]} ~ ${performance.endDate.toString().split(' ')[0]}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            // 버튼들
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showEditDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('공연 수정', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showDeleteDialog(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.orange),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('삭제', style: TextStyle(color: Colors.orange)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: performance.title);
    final locationController = TextEditingController(text: performance.location);
    final startDateController = TextEditingController(text: performance.startDate.toString().split(' ')[0]);
    final endDateController = TextEditingController(text: performance.endDate.toString().split(' ')[0]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('공연 수정'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: '공연명',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: '장소',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: startDateController,
                decoration: InputDecoration(
                  labelText: '시작일 (yyyy-mm-dd)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: endDateController,
                decoration: InputDecoration(
                  labelText: '종료일 (yyyy-mm-dd)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final updated = Performance(
                id: performance.id,
                title: titleController.text,
                location: locationController.text,
                startDate: DateTime.parse(startDateController.text),
                endDate: DateTime.parse(endDateController.text),
              );
              onEdit(updated);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('저장', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('공연 삭제'),
        content: Text('정말로 이 공연을 삭제하시겠습니까?\n삭제된 공연은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 상세 페이지 닫기
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}