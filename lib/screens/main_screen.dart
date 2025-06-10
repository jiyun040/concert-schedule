import 'dart:async';
import 'package:concert_schedule/const/colors.dart';
import 'package:concert_schedule/const/text_style.dart';
import 'package:concert_schedule/screens/performance_calendar_screen.dart';
import 'package:concert_schedule/screens/performance_list_screen.dart';
import 'package:concert_schedule/screens/record_screen.dart';
import 'package:concert_schedule/screens/regist_screen.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  bool isSearchVisible = false;
  bool isSearching = false;
  bool hasResult = false;
  String searchQuery = '';
  int? selectedTabIndex; // 선택된 탭 인덱스 (null이면 메인 화면)
  final TextEditingController _searchController = TextEditingController();

  final List<String> tabs = [
    '공연달력',
    '공연일정등록',
    '나의공연기록',
    '공연리스트',
    '찜공연',
  ];

  final List<Map<String, String>> performances = [
    {
      'title': 'KT&G 상상실현 페스티벌',
      'image': 'https://via.placeholder.com/300x180.png?text=KT%26G+페스티벌',
      'date': '2025.04.18 ~ 2025.04.19',
    },
    {
      'title': '서울파크뮤직페스티벌',
      'image': 'https://via.placeholder.com/300x180.png?text=서울파크뮤직',
      'date': '2025.06.28 ~ 2025.06.29',
    },
  ];

  int _currentCarousel = 0;
  final PageController _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
  Timer? _carouselTimer;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _startAutoCarousel();
    _selectedDay = DateTime.now();
  }

  void _startAutoCarousel() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        int nextPage = (_currentCarousel + 1) % performances.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  void _goBackToMain() {
    setState(() {
      selectedTabIndex = null;
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearchVisible = !isSearchVisible;
      if (!isSearchVisible) {
        isSearching = false;
        searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _hideSearch() {
    if (isSearchVisible) {
      setState(() {
        isSearchVisible = false;
        isSearching = false;
        searchQuery = '';
        _searchController.clear();
      });
    }
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      isSearching = true;
      searchQuery = query;
      hasResult = performances.any((p) => p['title'] == query);
    });
    if (!hasResult) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: ContiColors.white,
          content: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '해당 일정이 ',
                  style: ContiTextStyle.noResult(ContiColors.mainBlack),
                ),
                TextSpan(
                  text: '존재하지 않습니다.\n',
                  style: ContiTextStyle.noResult(ContiColors.red),
                ),
                TextSpan(
                  text: '올바른 공연명, 아티스트명',
                  style: ContiTextStyle.noResult(ContiColors.red),
                ),
                TextSpan(
                  text: '으로\n검색해 주세요.',
                  style: ContiTextStyle.noResult(ContiColors.mainBlack),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: ContiColors.mainOrange,
              ),
              child: Text('확인'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: ContiColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: ContiColors.mainBlack.withOpacity(0.08),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: ContiColors.mainOrange, width: 1),
        ),
        child: TextField(
          controller: _searchController,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            hintText: '원하시는 공연 / 페스티벌 / 콘서트명 또는 아티스트명을 입력해 주세요.',
            hintStyle: ContiTextStyle.hint,
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: ContiColors.mainOrange),
              onPressed: () => _onSearch(_searchController.text),
            ),
            border: InputBorder.none,
          ),
          onSubmitted: _onSearch,
        ),
      ),
    );
  }

  Widget _buildSearchResult() {
    final result = performances.firstWhere((p) => p['title'] == searchQuery, orElse: () => {});
    if (result.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(Icons.music_note, size: 40, color: Colors.grey[600]),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result['title']!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '올림픽공원 88잔디마당 / KSPO DOME',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      result['date'] ?? '',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ContiColors.mainOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('리스트 추가', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        // 캐러셀 (자동+수동)
        SizedBox(
          height: 160,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: performances.length,
                onPageChanged: (index) {
                  setState(() => _currentCarousel = index);
                },
                itemBuilder: (context, index) {
                  final p = performances[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.music_note, size: 40, color: Colors.grey[600]),
                              SizedBox(height: 8),
                              Text(
                                p['title']!,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // 인디케이터
              Positioned(
                bottom: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    performances.length,
                        (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      width: _currentCarousel == index ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentCarousel == index ? ContiColors.mainOrange : Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 달력
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

  Widget _buildTabBar() {
    return Container(
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tabs.asMap().entries.map((entry) {
                      int index = entry.key;
                      String tab = entry.value;
                      bool isSelected = selectedTabIndex == index;

                      return GestureDetector(
                        onTap: () => _onTabSelected(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(S
                              bottom: BorderSide(
                                color: isSelected ? ContiColors.mainOrange : Colors.transparent,
                              ),
                            ),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? ContiColors.mainOrange : ContiColors.mainBlack,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search, color: ContiColors.mainOrange),
                onPressed: _toggleSearch,
              ),
            ],
          ),
          if (isSearchVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: ContiColors.white,
                child: _buildSearchBar(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    if (selectedTabIndex == null) {
      // 검색 결과가 있을 때만 검색 결과 표시
      if (isSearching && hasResult) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildMainContent(),
              _buildSearchResult(),
            ],
          ),
        );
      } else {
        // 메인 화면만 표시
        return SingleChildScrollView(
          child: _buildMainContent(),
        );
      }
    }

    switch (selectedTabIndex) {
      case 0: // 공연달력
        return PerformanceCalendarScreen(onBackPressed: _goBackToMain);
      case 1: // 공연일정등록
        return RegistrationScreen(); // 직접 위젯 반환
      case 2: // 나의공연기록
        return RecordScreen(); // 직접 위젯 반환
      case 3: // 공연리스트
        return PerformanceListScreen(); // 공연리스트 화면 추가
      case 4: // 찜공연
        return PerformanceListScreen(showFavoritesOnly: true); // 찜공연 화면 추가
      default:
        return SingleChildScrollView(
          child: _buildMainContent(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideSearch,
      child: Scaffold(
        backgroundColor: ContiColors.white,
        body: SafeArea(
          child: Column(
            children: [
              // 상단 로고 + 마이페이지
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _goBackToMain,
                      child: Image.asset('assets/image/logo.png', height: 28),
                    ),
                    Icon(Icons.account_circle, size: 30, color: ContiColors.mainOrange),
                  ],
                ),
              ),
              // TabBar
              _buildTabBar(),
              // 선택된 탭의 내용
              Expanded(
                child: _buildSelectedTabContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}