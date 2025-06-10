import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Performance {
  final String id;
  final String title;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;

  Performance({
    required this.id,
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });
}

class PerformanceService {
  static final List<Performance> _performances = [
    Performance(
      id: '1',
      title: '서울파크뮤직페스티벌',
      location: '올림픽공원 88잔디마당 / KSPO DOME',
      startDate: DateTime(2025, 6, 28),
      endDate: DateTime(2025, 6, 29),
      imageUrl: 'https://via.placeholder.com/300x400',
    ),
  ];

  static final List<Performance> likedPerformances = [];
  static final List<Performance> addedPerformances = [];

  static List<Performance> getPerformancesByDate(DateTime date) {
    return _performances.where((p) =>
    date.isAfter(p.startDate.subtract(const Duration(days: 1))) &&
        date.isBefore(p.endDate.add(const Duration(days: 1)))
    ).toList();
  }

  static void toggleLike(Performance performance, BuildContext context) {
    if (likedPerformances.contains(performance)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('이미 찜한 공연입니다.'),
          content: const Text('중복으로 추가할 수 없습니다.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인'))],
        ),
      );
    } else {
      likedPerformances.add(performance);
    }
  }

  static void addToList(Performance performance, BuildContext context) {
    if (addedPerformances.contains(performance)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('이미 추가된 공연입니다.'),
          content: const Text('중복으로 추가할 수 없습니다.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인'))],
        ),
      );
    } else {
      addedPerformances.add(performance);
    }
  }

  static void deletePerformance(String id) {
    _performances.removeWhere((p) => p.id == id);
  }

  static void updatePerformance(Performance updated) {
    int index = _performances.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _performances[index] = updated;
    }
  }

  static Performance? getById(String id) {
    return _performances.firstWhere((p) => p.id == id, orElse: () => throw Exception('Not found'));
  }
}

class PerformanceDetailScreen extends StatefulWidget {
  final String performanceId;

  const PerformanceDetailScreen({super.key, required this.performanceId});

  @override
  State<PerformanceDetailScreen> createState() => _PerformanceDetailScreenState();
}

class _PerformanceDetailScreenState extends State<PerformanceDetailScreen> {
  late Performance performance;
  bool isEditing = false;
  late TextEditingController titleController;
  late TextEditingController locationController;
  DateTimeRange? selectedDates;

  @override
  void initState() {
    super.initState();
    performance = PerformanceService.getById(widget.performanceId)!;
    titleController = TextEditingController(text: performance.title);
    locationController = TextEditingController(text: performance.location);
    selectedDates = DateTimeRange(start: performance.startDate, end: performance.endDate);
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      performance = Performance(
        id: performance.id,
        title: titleController.text,
        location: locationController.text,
        startDate: selectedDates!.start,
        endDate: selectedDates!.end,
        imageUrl: performance.imageUrl,
      );
      PerformanceService.updatePerformance(performance);
      isEditing = false;
    });
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('정말로 삭제하시겠습니까?'),
        content: const Text('삭제하면 이 공연은 복구할 수 없습니다.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () {
              PerformanceService.deletePerformance(performance.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공연 상세보기')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(performance.imageUrl, width: 200)),
            const SizedBox(height: 16),
            isEditing
                ? TextField(controller: titleController)
                : Text(performance.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            isEditing
                ? TextField(controller: locationController)
                : Text(performance.location),
            const SizedBox(height: 10),
            isEditing
                ? TextButton(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  initialDateRange: selectedDates,
                );
                if (picked != null) setState(() => selectedDates = picked);
              },
              child: Text('${DateFormat('yyyy.MM.dd').format(selectedDates!.start)} - ${DateFormat('yyyy.MM.dd').format(selectedDates!.end)}'),
            )
                : Text('${DateFormat('yyyy.MM.dd').format(performance.startDate)} - ${DateFormat('yyyy.MM.dd').format(performance.endDate)}'),
            const SizedBox(height: 16),
            isEditing
                ? Row(
              children: [
                ElevatedButton(onPressed: _saveChanges, child: const Text('저장')),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => setState(() => isEditing = false),
                  child: const Text('수정 취소'),
                )
              ],
            )
                : Row(
              children: [
                ElevatedButton(
                  onPressed: () => PerformanceService.toggleLike(performance, context),
                  child: const Text('공연 찜하기'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => PerformanceService.addToList(performance, context),
                  child: const Text('리스트 추가'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => setState(() => isEditing = true),
                  child: const Text('수정'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: _confirmDelete,
                  child: const Text('삭제', style: TextStyle(color: Colors.red)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}