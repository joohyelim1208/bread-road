import 'package:flutter/material.dart';
import '../write/write_page.dart';
import '../post/post_page.dart';
import '../record/record_page.dart';
import '../../widgets/bottom_navigation_bar.dart';
import 'home_dashboard_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _sortRecords();
  }

  void _sortRecords() {
    setState(() {
      _allRecords.sort((a, b) {
        final dateA = a["visitDate"] ?? a["date"] ?? "";
        final dateB = b["visitDate"] ?? b["date"] ?? "";
        return dateB.compareTo(dateA); // 내림차순 (최신순)
      });
    });
  }

  // 데이터 초기화 (추후 Firebase 연동)
  final List<Map<String, dynamic>> _allRecords = [];

  // 추천 데이터 (추후 Firebase 연동)
  final Map<String, dynamic>? _recommendationData = {
    "name": "초코 소라빵",
    "imageUrl": "https://picsum.photos/400/220?random=10",
  };

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _handleRecordTap(Map<String, dynamic> record) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostPage(record: record)),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final updatedData = result["data"] ?? result;
        if (result["isDeleted"] == true) {
          _allRecords.remove(record);
        } else {
          final index = _allRecords.indexOf(record);
          if (index != -1) {
            _allRecords[index] = Map<String, dynamic>.from(updatedData);
          }
        }
      });
    }
  }

  void _handleFavoriteToggle(Map<String, dynamic> record) {
    setState(() {
      record["isFavorite"] = !(record["isFavorite"] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          HomeDashboardView(
            records: _allRecords,
            recommendationData: _recommendationData,
            onAddPressed: _navigateToWritePage,
            onMorePressed: _onItemTapped,
            onRecordTap: _handleRecordTap,
            onFavoriteToggle: _handleFavoriteToggle,
          ),
          const Center(child: Text("지도 페이지 준비 중")),
          RecordPage(
            records: _allRecords,
            onRecordUpdated: (index, result) {
              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  final updatedData = result["data"] ?? result;
                  if (result["isDeleted"] == true) {
                    _allRecords.removeAt(index);
                  } else {
                    _allRecords[index] = Map<String, dynamic>.from(updatedData);
                  }
                });
              }
            },
            onAddRecord: _navigateToWritePage,
          ),
          const Center(child: Text("설정 페이지 준비 중")),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> _navigateToWritePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WritePage(),
      ),
    );

    if (result != null) {
      setState(() {
        if (result is int) {
          _onItemTapped(result);
          return;
        }

        if (result is Map<String, dynamic>) {
          if (result["isDeleted"] != true) {
            _allRecords.add(Map<String, dynamic>.from(result));
            _sortRecords();
            _onItemTapped(2);
          }
        }
      });
    }
  }
}
