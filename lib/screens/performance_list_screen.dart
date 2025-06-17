import 'package:concert_schedule/const/colors.dart';
import 'package:flutter/material.dart';

class Performance {
  String id;
  String title;
  String venue;
  DateTime startDate;
  DateTime endDate;
  String? imageUrl;
  String category;
  bool isInMyList;
  bool isFavorite;

  Performance({
    required this.id,
    required this.title,
    required this.venue,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
    required this.category,
    this.isInMyList = false,
    this.isFavorite = false,
  });
}

// 전역 공연 데이터 (실제로는 데이터베이스나 API에서 가져올 데이터)
class PerformanceData {
  static List<Performance> allPerformances = [
    Performance(
      id: '1',
      title: 'KT&G 상상실험 뮤지컬페스티벌',
      venue: '상상마당 춘천',
      startDate: DateTime(2025, 4, 19),
      endDate: DateTime(2025, 4, 20),
      category: '뮤지컬',
    ),
    Performance(
      id: '2',
      title: '서울파크뮤직페스티벌',
      venue: '올림픽공원 88잔디마당 / KSPO DOME',
      startDate: DateTime(2025, 6, 28),
      endDate: DateTime(2025, 6, 29),
      category: '페스티벌',
    ),
    Performance(
      id: '3',
      title: '2025 아이유 콘서트 <HEREH>',
      venue: '서울 올림픽공원 잠실실내체육관',
      startDate: DateTime(2025, 3, 15),
      endDate: DateTime(2025, 3, 16),
      category: '콘서트',
    ),
    Performance(
      id: '4',
      title: '뮤지컬 <레미제라블>',
      venue: '샤롯데씨어터',
      startDate: DateTime(2025, 2, 10),
      endDate: DateTime(2025, 5, 10),
      category: '뮤지컬',
    ),
    Performance(
      id: '5',
      title: '클래식 갈라 콘서트',
      venue: '예술의전당 콘서트홀',
      startDate: DateTime(2025, 1, 25),
      endDate: DateTime(2025, 1, 25),
      category: '클래식',
    ),
  ];

  // 내 리스트에 추가된 공연들 (D-day 순으로 정렬)
  static List<Performance> get myListPerformances {
    return allPerformances
        .where((p) => p.isInMyList)
        .toList()
      ..sort((a, b) {
        final aDDay = _calculateDDay(a.startDate);
        final bDDay = _calculateDDay(b.startDate);
        return aDDay.compareTo(bDDay);
      });
  }

  // 찜한 공연들
  static List<Performance> get favoritePerformances {
    return allPerformances.where((p) => p.isFavorite).toList();
  }

  static int _calculateDDay(DateTime performanceDate) {
    final now = DateTime.now();
    final difference = performanceDate.difference(DateTime(now.year, now.month, now.day)).inDays;
    return difference;
  }
}

class PerformanceListScreen extends StatefulWidget {
  final bool showFavoritesOnly;

  const PerformanceListScreen({Key? key, this.showFavoritesOnly = false}) : super(key: key);

  @override
  _PerformanceListScreenState createState() => _PerformanceListScreenState();
}

class _PerformanceListScreenState extends State<PerformanceListScreen> {

  List<Performance> get _displayPerformances {
    if (widget.showFavoritesOnly) {
      return PerformanceData.favoritePerformances;
    }
    return PerformanceData.myListPerformances;
  }

  int _calculateDDay(DateTime performanceDate) {
    final now = DateTime.now();
    final difference = performanceDate.difference(DateTime(now.year, now.month, now.day)).inDays;
    return difference;
  }

  Color _getDDayColor(int dDay) {
    if (dDay < 0) return Colors.grey; // 지난 공연
    if (dDay == 0) return Colors.red; // 오늘
    if (dDay <= 3) return Colors.orange; // 3일 이내
    if (dDay <= 7) return ContiColors.mainOrange; // 7일 이내
    return ContiColors.black500; // 그 외
  }

  String _getDDayText(int dDay) {
    if (dDay < 0) return 'D+${(-dDay)}';
    if (dDay == 0) return 'D-DAY';
    return 'D-$dDay';
  }

  void _showPerformanceDetail(Performance performance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPerformanceDetailSheet(performance),
    );
  }

  void _addToMyList(Performance performance) {
    if (performance.isInMyList) {
      _showDuplicateDialog('이미 추가된 공연입니다.\n중복으로 추가할 수 없습니다.');
      return;
    }

    setState(() {
      performance.isInMyList = true;
    });

    _showSuccessDialog('리스트에 추가되었습니다!', performance.title);
  }

  void _addToFavorites(Performance performance) {
    if (performance.isFavorite) {
      _showDuplicateDialog('이미 찜한 공연입니다.\n중복으로 찜할 수 없습니다.');
      return;
    }

    setState(() {
      performance.isFavorite = true;
    });

    _showSuccessDialog('찜 목록에 추가되었습니다!', performance.title);
  }

  void _showDuplicateDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ContiColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ContiColors.mainBlack,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
  }

  void _showSuccessDialog(String message, String performanceTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ContiColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: ContiColors.mainOrange,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ContiColors.mainBlack,
                ),
              ),
              SizedBox(height: 8),
              Text(
                performanceTitle,
                style: TextStyle(
                  fontSize: 14,
                  color: ContiColors.black500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
  }

  Widget _buildPerformanceDetailSheet(Performance performance) {
    final dDay = _calculateDDay(performance.startDate);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: ContiColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 핸들바
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 상세 내용
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 공연 이미지 영역
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: ContiColors.black100,
                      borderRadius: BorderRadius.circular(12),
                      image: performance.imageUrl != null
                          ? DecorationImage(
                        image: NetworkImage(performance.imageUrl!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: performance.imageUrl == null
                        ? Center(
                      child: Icon(
                        Icons.image,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                    )
                        : null,
                  ),

                  SizedBox(height: 20),

                  // 공연 제목
                  Text(
                    performance.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ContiColors.mainBlack,
                    ),
                  ),

                  SizedBox(height: 8),

                  // 장소
                  Text(
                    performance.venue,
                    style: TextStyle(
                      fontSize: 16,
                      color: ContiColors.black500,
                    ),
                  ),

                  SizedBox(height: 12),

                  // 날짜
                  Text(
                    '${performance.startDate.year}.${performance.startDate.month.toString().padLeft(2, '0')}.${performance.startDate.day.toString().padLeft(2, '0')} ~ ${performance.endDate.year}.${performance.endDate.month.toString().padLeft(2, '0')}.${performance.endDate.day.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 14,
                      color: ContiColors.black500,
                    ),
                  ),

                  SizedBox(height: 16),

                  // D-Day
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDDayColor(dDay),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getDDayText(dDay),
                      style: TextStyle(
                        color: ContiColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Spacer(),

                  // 버튼들
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _addToFavorites(performance);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: performance.isFavorite
                                ? Colors.grey
                                : ContiColors.mainOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            performance.isFavorite ? '이미 찜한 공연' : '공연 찜하기',
                            style: TextStyle(
                              color: ContiColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _addToMyList(performance);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: performance.isInMyList
                                ? Colors.grey
                                : ContiColors.white,
                            side: BorderSide(
                                color: performance.isInMyList
                                    ? Colors.grey
                                    : ContiColors.mainOrange
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            performance.isInMyList ? '이미 추가된 공연' : '리스트 추가',
                            style: TextStyle(
                              color: performance.isInMyList
                                  ? Colors.grey[600]
                                  : ContiColors.mainOrange,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayPerformances = _displayPerformances;

    return Scaffold(
      backgroundColor: ContiColors.black100,
      body: displayPerformances.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.showFavoritesOnly ? Icons.favorite : Icons.music_note,
              size: 60,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              widget.showFavoritesOnly
                  ? '찜한 공연이 없습니다.'
                  : '리스트에 추가된 공연이 없습니다.',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              widget.showFavoritesOnly
                  ? '공연 상세 페이지에서 찜하기를 눌러보세요!'
                  : '공연 상세 페이지에서 리스트 추가를 눌러보세요!',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: displayPerformances.length,
        itemBuilder: (context, index) {
          final performance = displayPerformances[index];
          final dDay = _calculateDDay(performance.startDate);

          return GestureDetector(
            onTap: () => _showPerformanceDetail(performance),
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ContiColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          performance.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ContiColors.mainBlack,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          performance.venue,
                          style: TextStyle(
                            color: ContiColors.black500,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${performance.startDate.year}.${performance.startDate.month.toString().padLeft(2, '0')}.${performance.startDate.day.toString().padLeft(2, '0')} ~ ${performance.endDate.year}.${performance.endDate.month.toString().padLeft(2, '0')}.${performance.endDate.day.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: ContiColors.black500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // D-Day만 표시 (찜 버튼 제거)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDDayColor(dDay),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getDDayText(dDay),
                      style: TextStyle(
                        color: ContiColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}