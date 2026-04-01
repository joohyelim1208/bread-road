import 'package:flutter/material.dart';
import 'package:bread_road/ui/pages/home/widgets/recommendation_banner.dart';
import 'package:bread_road/ui/pages/home/widgets/section_header.dart';
import 'package:bread_road/ui/pages/home/widgets/recent_records_list.dart';
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
              // 빵집 상세 또는 검색 등으로 연결 가능
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

    return SafeArea(
      child: Column(
        children: [
          // 1. 고정된 상단 헤더 영역
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
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
                    onPressed: onAddPressed,
                    icon: const Icon(Icons.add_circle, size: 40),
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
                  RecommendationBanner(data: recommendationData),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        
                        // 2) 최근 기록 헤더
                        SectionHeader(
                          title: "최근 기록",
                          onMoreTap: () => onMorePressed(2), // 2는 탭 인덱스
                        ),
                        const SizedBox(height: 10),
                        
                        // 3) 최근 기록 리스트 (상위 3개)
                        RecentRecordsList(
                          records: records,
                          onRecordTap: onRecordTap,
                          onFavoriteToggle: onFavoriteToggle,
                        ),

                        const SizedBox(height: 40),
                        
                        // 4) 추천 빵집 헤더
                        SectionHeader(
                          title: "추천 빵집",
                          onMoreTap: () => onMorePressed(1), // 1은 탭 인덱스
                        ),
                        const SizedBox(height: 10),
                        
                        // 5) 추천 빵집 가로 리스트
                        _buildRecommendedBakeries(context),
                        
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
}
