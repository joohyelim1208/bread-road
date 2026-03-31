import 'package:flutter/material.dart';
import 'package:bread_road/ui/pages/post/post_page.dart';
import 'package:bread_road/ui/pages/record/record_page.dart';
import 'package:bread_road/ui/pages/write/write_page.dart';
import 'package:bread_road/ui/widgets/bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 바텀네비게이션바 컨트롤러
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // 전체 기록 데이터. 화면에서 3개 목록만 보여줌 나머지는 (더보기+)를 통하거나 레코드페이지에서 전체리스트 확인 가능
  final List<Map<String, dynamic>> _allRecords = [
    {
      "name": "바게트 샌드위치",
      "bakery": "건강한 빵집",
      "rating": "4.5",
      "isFavorite": false,
    },
    {"name": "크로와상", "bakery": "빵빵한 빵집", "rating": "4.5", "isFavorite": false},
    {"name": "치아바타", "bakery": "숲속 베이커리", "rating": "4.8", "isFavorite": false},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 손가락 터치시에도 화면 직접 밀면 바텀바 아이콘 바뀜
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // 화면 넘기는 리모컨
  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          _buildHomeView(textTheme, colorScheme),
          _buildPlaceholderView("추천 빵집", Icons.bakery_dining, textTheme),
          // 3. 내 기록 탭에 실제 구현한 RecordPage를 연결.
          RecordPage(
            records: _allRecords,
            onRecordUpdated: (index, result) {
              if (result != null) {
                _handleRecordResult(index, result);
              }
            },
          ),
          _buildPlaceholderView("레시피", Icons.restaurant_menu, textTheme),
          _buildPlaceholderView("내 설정", Icons.person, textTheme),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // 메인 홈 화면 UI
  Widget _buildHomeView(TextTheme textTheme, ColorScheme colorScheme) {
    return SafeArea(
      child: Column(
        children: [
          // 1. 고정된 상단 헤더 영역 (Sticky Header) - 그림자 효과 추가
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
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
                            // 새로 작성 시 전체 리스트 처음에 추가
                            if (result["isDeleted"] != true) {
                              _allRecords.insert(
                                0,
                                Map<String, dynamic>.from(result),
                              );

                              // 작성 후 즉시 내 기록 탭으로 이동하고 싶을 경우
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "오늘의 빵 기록",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTodayBreadCard(textTheme, colorScheme),
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
                  Text(
                    "추천 빵집",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRecommendedBakeries(textTheme, colorScheme),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderView(
    String title,
    IconData icon,
    TextTheme textTheme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "페이지 준비 중입니다.",
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayBreadCard(TextTheme textTheme, ColorScheme colorScheme) {
    final latestRecord = _allRecords.isNotEmpty
        ? _allRecords.first
        : {
            "name": "오늘의 빵",
            "bakery": "비어있음",
            "rating": "0.0",
            "isFavorite": false,
          };

    final String name = latestRecord["name"] ?? "오늘의 빵";
    final String bakery = latestRecord["bakery"] ?? "비어있음";
    final double rating =
        double.tryParse(latestRecord["rating"].toString()) ?? 0.0;
    final bool isFavorite = latestRecord["isFavorite"] == true;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[100],
              child: const Icon(
                Icons.bakery_dining,
                size: 64,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bakery,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 5. 별점 (0.5 단위 반쪽 별 지원)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        IconData iconData = Icons.star_border;
                        Color iconColor = Colors.grey[300]!;

                        if (rating >= index + 1) {
                          iconData = Icons.star;
                          iconColor = Colors.amber;
                        } else if (rating > index) {
                          iconData = Icons.star_half;
                          iconColor = Colors.amber;
                        }

                        return Icon(iconData, size: 18, color: iconColor);
                      }),
                    ),
                    const SizedBox(height: 4),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (_allRecords.isNotEmpty) {
                          setState(() {
                            _allRecords[0]["isFavorite"] = !isFavorite;
                          });
                        }
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRecordsList(TextTheme textTheme, ColorScheme colorScheme) {
    // 메인 홈에서는 최근 3개만 표시
    final displayRecords = _allRecords.take(3).toList();

    if (displayRecords.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text("기록이 없습니다.", style: textTheme.bodySmall),
        ),
      );
    }

    return Column(
      children: List.generate(displayRecords.length, (index) {
        final record = displayRecords[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record["name"] ?? "",
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 별점 (0.5 단위 반쪽 별 지원)
                      Row(
                        children: [
                          Text(
                            "${record["bakery"]}  ",
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          ...List.generate(5, (index) {
                            final double r =
                                double.tryParse(record["rating"].toString()) ??
                                0.0;
                            IconData iconData = Icons.star_border;
                            Color iconColor = Colors.grey[300]!;

                            if (r >= index + 1) {
                              iconData = Icons.star;
                              iconColor = Colors.amber;
                            } else if (r > index) {
                              iconData = Icons.star_half;
                              iconColor = Colors.amber;
                            }

                            return Icon(iconData, size: 12, color: iconColor);
                          }),
                          Text(
                            " ${record["rating"]}",
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostPage(data: record),
                      ),
                    );

                    if (result != null) {
                      _handleRecordResult(index, result);
                    }
                  },
                  icon: const Icon(Icons.chevron_right, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRecommendedBakeries(
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 20),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(5),
                  ),
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: const Center(
                      child: Icon(
                        Icons.storefront,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "맛있는 빵집 ${index + 1}",
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          Text(
                            " 4.9",
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "| 서울 강남구 역삼동",
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 5. 기록 수정/삭제 결과를 통합 처리하는 함수
  void _handleRecordResult(int index, dynamic result) {
    if (result is Map<String, dynamic>) {
      setState(() {
        if (result["isDeleted"] == true) {
          _allRecords.removeAt(index);
        } else {
          final updatedData = result["data"] as Map<String, dynamic>? ?? result;
          _allRecords[index] = Map<String, dynamic>.from(updatedData);

          // PostPage에서 뒤로가기 시 goToRecord 플래그가 있으면 '내 기록' 탭으로 전환
          if (result["goToRecord"] == true) {
            _onItemTapped(2);
          }
        }
      });
    }
  }
}
