import 'package:flutter/material.dart';
import 'package:bread_road/ui/pages/home/widgets/recommendation_banner.dart';
import 'package:bread_road/ui/pages/home/widgets/section_header.dart';
import 'package:bread_road/ui/pages/home/widgets/recent_records_list.dart';
import 'package:bread_road/ui/pages/home/widgets/bread_grade_card.dart';
import 'package:bread_road/ui/widgets/recommended_bakery_card.dart';

class HomeDashboardView extends StatelessWidget {
  final List<Map<String, dynamic>> records;
  final Map<String, dynamic>? recommendationData;
  final VoidCallback onAddPressed;
  final void Function(int) onMorePressed;
  final void Function(Map<String, dynamic>) onRecordTap;
  final void Function(Map<String, dynamic>) onFavoriteToggle;

  const HomeDashboardView({
    super.key,
    required this.records,
    required this.recommendationData,
    required this.onAddPressed,
    required this.onMorePressed,
    required this.onRecordTap,
    required this.onFavoriteToggle,
  });

  /// ── 추천 빵집 섹션 가로 리스트 ──
  Widget _buildRecommendedBakeries(BuildContext context) {
    // 추천 빵집 데이터는 추후 서버스 연동으로 대체될 부분
    final bakeries = [
      {
        "name": "오베르망",
        "location": "서울 성북구",
        "rating": 4.8,
        "reviews": 124,
        "imageUrl":
            "https://images.unsplash.com/photo-1550617931-e17a7b70dce2?q=80&w=400&auto=format&fit=crop",
      },
      {
        "name": "밀곳간",
        "location": "서울 성동구",
        "rating": 4.6,
        "reviews": 89,
        "imageUrl":
            "https://images.unsplash.com/photo-1517433670267-08bbd4be890f?q=80&w=400&auto=format&fit=crop",
      },
      {
        "name": "런던 베이글",
        "location": "서울 종로구",
        "rating": 4.9,
        "reviews": 350,
        "imageUrl":
            "https://images.unsplash.com/photo-1608198093002-ad4e005484ec?q=80&w=400&auto=format&fit=crop",
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
              // 빵집 상세 또는 검색 등으로 연결 가능
            },
          );
        },
      ),
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("알림"),
        content: const Text("아직 알림이 없습니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) 상단 배경화면 (상태바 영역까지 덮음) 및 앱바 영역
          Stack(
            children: [
              RecommendationBanner(data: recommendationData),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 로고 이미지
                    Image.asset(
                      'assets/images/blacklogo.webp',
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                    // 알림 아이콘
                    GestureDetector(
                      onTap: () => _showNotificationDialog(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // 빵지순례 등급 카드
                BreadGradeCard(totalRecords: records.length),
                const SizedBox(height: 30),

                // 2) 최근 기록 헤더
                SectionHeader(
                  title: "최근 기록",
                  onMoreTap: () => onMorePressed(2), // 2는 탭 인덱스
                ),
                const SizedBox(height: 12),

                // 3) 최근 기록 리스트 (상위 3개)
                RecentRecordsList(
                  records: records,
                  onRecordTap: onRecordTap,
                  onFavoriteToggle: onFavoriteToggle,
                ),

                const SizedBox(height: 30),

                // 4) 추천 빵집 헤더
                SectionHeader(
                  title: "추천 빵집",
                  onMoreTap: () => onMorePressed(1), // 1은 탭 인덱스
                ),
                const SizedBox(height: 12),

                // 5) 추천 빵집 가로 리스트
                _buildRecommendedBakeries(context),

                const SizedBox(height: 100), // 바텀 네비게이션 및 FAB 여백
              ],
            ),
          ),
        ],
      ),
    );
  }
}
