import 'package:flutter/material.dart';
import '../write/write_page.dart';
import '../post/post_page.dart';
import '../record/record_page.dart';
import '../../widgets/bread_record_card.dart';
import '../../widgets/recommended_bakery_card.dart';
import '../../widgets/bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // 가상의 데이터 (추후 Firebase 연동)
  final List<Map<String, dynamic>> _allRecords = [
    {
      "name": "성심당 튀김소보로",
      "date": "2024-03-25",
      "time": "14:30",
      "rating": 4.5,
      "isFavorite": true,
      "images": [
        "https://picsum.photos/200/200?random=1",
        "https://picsum.photos/200/200?random=2",
        "https://picsum.photos/200/200?random=3",
      ],
      "bakery": "성심당 본점",
      "location": "대전 중구",
      "description": "역시 명불허전... 바삭하고 달콤해요.",
    },
    {
      "name": "연유 크림빵",
      "date": "2024-03-24",
      "time": "10:00",
      "rating": 4.0,
      "isFavorite": false,
      "images": [], // 이미지 없음 예시
      "bakery": "동네 빵집",
      "location": "서울 성동구",
      "description": "부드럽고 달콤한 연유 크림이 가득해요.",
    },
  ];

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

  Widget _buildHomeView(TextTheme textTheme, ColorScheme colorScheme) {
    return SafeArea(
      child: Column(
        children: [
          // 1. 고정된 상단 헤더 영역
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5), // 라이트 그레이 배경
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "오늘 먹은 빵 기록하기",
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
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
                              _allRecords.insert(
                                0,
                                Map<String, dynamic>.from(result),
                              );
                              _onItemTapped(2);
                            }
                          }
                        });
                      }
                    },
                    icon: const Icon(Icons.add_circle, size: 32),
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),

          // 2. 스크롤 가능한 본문 영역
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1) 오늘의 빵 추천 영역 (가로 꽉 차게)
                  _buildRecommendationArea(textTheme, colorScheme),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "최근 기록",
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => _onItemTapped(2),
                              child: Text(
                                "+ 더보기",
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildRecentRecordsList(textTheme, colorScheme),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "추천 빵집",
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => _onItemTapped(1),
                              child: Text(
                                "+ 더보기",
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildRecommendedBakeries(textTheme, colorScheme),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ── 오늘의 빵 추천 영역 ──
  Widget _buildRecommendationArea(
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    if (_recommendationData == null) {
      return Container(
        width: double.infinity,
        height: 200,
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bakery_dining,
                size: 48,
                color: colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Bread Road',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: colorScheme.primary.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final String name = _recommendationData["name"] ?? "";
    final String? imageUrl = _recommendationData["imageUrl"];

    return Container(
      width: double.infinity,
      height: 220,
      child: Stack(
        children: [
          Positioned.fill(
            child: imageUrl != null
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : Container(color: Colors.grey[200]),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "오늘의 추천",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ── 최근 기록 리스트 ──
  Widget _buildRecentRecordsList(TextTheme textTheme, ColorScheme colorScheme) {
    if (_allRecords.isEmpty) {
      return Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history_toggle_off, size: 60, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                "오늘 먹은 빵을 기록해 주세요.",
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _allRecords.take(3).map((record) {
        return BreadRecordCard(
          record: record,
          onTap: () async {
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
          },
          onFavoriteToggle: () {
            setState(() {
              record["isFavorite"] = !(record["isFavorite"] ?? false);
            });
          },
        );
      }).toList(),
    );
  }

  /// ── 추천 빵집 섹션 ──
  Widget _buildRecommendedBakeries(
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final bakeries = [
      {
        "name": "오베르망",
        "location": "서울 성북구",
        "rating": 4.8,
        "reviews": 124,
        "imageUrl": "https://picsum.photos/160/120?random=20",
      },
      {
        "name": "밀곳간",
        "location": "서울 성동구",
        "rating": 4.6,
        "reviews": 89,
        "imageUrl": "https://picsum.photos/160/120?random=21",
      },
      {
        "name": "런던 베이글",
        "location": "서울 종로구",
        "rating": 4.9,
        "reviews": 350,
        "imageUrl": "https://picsum.photos/160/120?random=22",
      },
    ];

    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bakeries.length,
        itemBuilder: (context, index) {
          return RecommendedBakeryCard(
            bakery: bakeries[index],
            onTap: () {
              // 빵집 상세 또는 검색 등으로 연결 가능 (현재는 미구현)
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          _buildHomeView(textTheme, colorScheme),
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
            onBackToHome: () => _onItemTapped(0),
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
}
