import 'package:flutter/material.dart';
import 'package:bread_road/ui/pages/post/post_page.dart';
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

  // 최근 기록 임시 데이터
  final List<Map<String, dynamic>> _recentRecords = [
    {
      "name": "바게트 샌드위치",
      "bakery": "건강한 빵집",
      "rating": "4.2",
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

  // 화면 넘기는 리모컨. 애니메이션을 넣어서 부드럽게 동작함
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
      // 화면이 미끄러지듯 전환되게 만드는 위젯 PageView
      body: PageView(
        controller: _pageController,
        // 손가락 터치 시에도 화면전환
        onPageChanged: _onPageChanged,
        children: [
          _buildHomeView(textTheme, colorScheme),
          _buildPlaceholderView("추천 빵집", Icons.bakery_dining, textTheme),
          _buildPlaceholderView("내 기록", Icons.book, textTheme),
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

  // 기존 메인 홈 화면 UI
  Widget _buildHomeView(TextTheme textTheme, ColorScheme colorScheme) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "오늘 먹은 빵 기록하기",
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // writePage로 이동
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WritePage(),
                      ),
                    );

                    // 돌아왔을 때 데이터 추가 및 화면 갱신
                    if (result != null) {
                      setState(() {
                        // 클릭 시 결과가 인덱스 숫자인 경우
                        if (result is int) {
                          _onItemTapped(result);
                          return;
                        }

                        if (result is Map<String, dynamic>) {
                          // 새로 작성 시에는 삭제 버튼을 누를 일이 없음! Map 데이터만 처리
                          if (result["isDeleted"] != true) {
                            _recentRecords.insert(0, {
                              "name": result["name"] as String,
                              "bakery": result["bakery"] as String,
                              "rating": result["rating"] as String,
                              "isFavorite":
                                  result["isFavorite"] as bool? ?? false,
                            });

                            // 보여지는 리스트는 최대 3개까지만 유지함
                            if (_recentRecords.length > 3) {
                              _recentRecords.removeLast();
                            }
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
            const SizedBox(height: 30),
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
                  onPressed: () => _onItemTapped(2), // '내 기록' 탭으로 이동
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
            _buildRecentRecordsList(textTheme),
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
    );
  }

  // 플레이스홀더 뷰 (아직 구현되지 않은 탭)
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

  // 오늘의 빵 기록 카드섹션.
  Widget _buildTodayBreadCard(TextTheme textTheme, ColorScheme colorScheme) {
    // 최신 기록이 있으면 해당 데이터를 사용, 없으면 기본값 표시
    final latestRecord = _recentRecords.isNotEmpty
        ? _recentRecords.first
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                // 좌측: 이름과 가게명
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
                // 우측: 별점과 즐겨찾기 (아이콘 우측 정렬)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 별점
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 18,
                          color: index < rating.floor()
                              ? Colors.amber
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 하트 아이콘 (즐겨찾기 토글)
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (_recentRecords.isNotEmpty) {
                          setState(() {
                            _recentRecords[0]["isFavorite"] = !isFavorite;
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

  // 최근 기록 리스트. 별점 설정 시 값 반영하기. 클릭 시 postPage로 이동함
  Widget _buildRecentRecordsList(TextTheme textTheme) {
    return Column(
      children: List.generate(_recentRecords.length, (index) {
        final record = _recentRecords[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
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
                      Text(
                        "${record["bakery"]}  ⭐ ${record["rating"]}",
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
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
                      setState(() {
                        if (result is Map<String, dynamic>) {
                          if (result["isDeleted"] == true) {
                            // 삭제 처리
                            _recentRecords.removeAt(index);
                          } else {
                            // 수정 처리
                            _recentRecords[index] = {
                              "name": result["name"] as String,
                              "bakery": result["bakery"] as String,
                              "rating": result["rating"] as String,
                              "isFavorite":
                                  result["isFavorite"] as bool? ?? false,
                            };
                          }
                        }
                      });
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

  // 추천 빵집 가로 스와이프 리스트
  Widget _buildRecommendedBakeries(
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 20), // 끝부분 여백
        // 스와이프 기능. 리스트뷰 속성
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[100]!),
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
                    top: Radius.circular(20),
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
}
