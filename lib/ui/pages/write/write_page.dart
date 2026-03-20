import 'package:bread_road/core/enum/write_category_type.dart';
import 'package:bread_road/ui/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:bread_road/core/utils/validator_util.dart';
import 'package:bread_road/ui/widgets/bottom_navigation_bar.dart';

class WritePage extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const WritePage({super.key, this.initialData});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  // 1번. 현재 선택한 타입. 기본값은 빵류
  WriteCategoryType _currentType = WriteCategoryType.bread;

  // 1번. 타입에 따라서 카테고리 데이터를 나눠즘 (게터함수)
  List<String> get _categories => _currentType == WriteCategoryType.bread
      ? ["전체", "식사빵", "부드러운빵", "롤빵", "페이스트리", "충전빵", "건강빵"]
      : ["전체", "케이크", "쿠키", "파이/타르트", "페이스트리", "슈크림", "초콜릿디저트"];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bakeryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String _breadName = "";
  String _selectedCategory = "전체";
  double _rating = 0.0;
  bool _isFavorite = false;
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _nameController.text = data["name"] ?? "";
      _bakeryController.text = data["bakery"] ?? "";
      _breadName = _nameController.text;
      _rating = double.tryParse(data["rating"].toString()) ?? 0.0;
      _isFavorite = data["isFavorite"] == true;
      _isDone = data["isDone"] == true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bakeryController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBarWidget(
          title: '글쓰기',
          actions: [
            TextButton(
              onPressed: () {
                // 등록 완료 플래그와 함께 팝업
                Navigator.pop(context, {"isRegister": true});
              },
              child: const Text(
                '등록완료',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    // 1. 빵류 / 과자류 선택 영역
                    _buildCategorySelector(colorScheme, textTheme),
                    const SizedBox(height: 32),
                    // 2. 사진 추가 영역
                    _buildImagePickerArea(colorScheme, textTheme),
                    const SizedBox(height: 32),
                    // 3. 내가 먹은 빵 (제품명) 입력 필드 영역
                    Text(
                      "제품명",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      onChanged: (value) => setState(() => _breadName = value),
                      maxLength: 30,
                      decoration: InputDecoration(
                        hintText: '제품명을 입력해주세요.',
                        counterText: "${_breadName.length} / 30",
                        counterStyle: TextStyle(
                          color: _breadName.length > 30
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                      validator: ValidatorUtil.validatorBreadNameError,
                    ),

                    const SizedBox(height: 16),
                    // 4. 카테고리 선택 (가로 스크롤)
                    _buildCategorySelector(colorScheme, textTheme),
                    const SizedBox(height: 16),

                    Text(
                      "자세한 설명",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // 5. 가게명 입력 필드 영역. 하단에 위치표시 시군구
                    _buildBakeryNameField(colorScheme, textTheme),

                    const SizedBox(height: 24),

                    // 6. 가격 추가 영역
                    const SizedBox(height: 24),

                    // 7. 시식여부 선택 영역. isDone
                    const SizedBox(height: 24),
                    // 8. 맛, 풍미, 향 식감 선택영역. 하나의 카드섹션으로 나눠야 하는지?

                    // 9. 별점 기능 영역
                    _buildRatingBar(colorScheme, textTheme),
                    const SizedBox(height: 32),
                    // 10. 글쓰기 (내용)
                    Text(
                      "글쓰기",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 100,
                      decoration: const InputDecoration(
                        hintText: '내용을 입력해주세요.',
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 48),
                    // 11. 저장하기 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // 저장 시 종합 데이터 반환
                          final recordData = {
                            "mainType": _currentType == WriteCategoryType.bread
                                ? "빵류"
                                : "과자류",
                            "subCategory": _selectedCategory,
                            "name": _nameController.text.isEmpty
                                ? "빵 이름을 등록해주세요."
                                : _nameController.text,
                            "bakery": _bakeryController.text.isEmpty
                                ? "가게명 없음"
                                : _bakeryController.text,
                            "rating": _rating.toString(),
                          };
                          Navigator.pop(context, recordData);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "저장하기",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 2,
          onTap: (index) {
            // 클릭 시 홈으로 이동함
            Navigator.pop(context, index);
          },
        ),
      ),
    );
  }

  // 1. 빵류 / 과자류 선택 영역 위젯
  Widget _buildTypeSelector(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _typeButton("빵류", WriteCategoryType.bread), // 텍스트테마 적용
        const SizedBox(width: 12),
        _typeButton("과자류", WriteCategoryType.snack),
      ],
    );
  }

  Widget _typeButton(String label, WriteCategoryType type) {
    // 선택값 담아주기. 상단 버튼을 누르면 하단 리스트뷰의 리스트 자체가 바뀜!
    final isSelected = _currentType == type;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() {
        _currentType = type;
        _selectedCategory = "전체"; // 전체로 초기화 해주는 것이 중요!! 과자류에 없는 식사빵 선택 오류 방지
      }),
      child: Text(
        label,
        style: isSelected
            ? textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              )
            : textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
      ),
    );
  }

  // 2. 사진 추가 영역 위젯
  Widget _buildImagePickerArea(ColorScheme colorScheme, TextTheme textTheme) {
    return InkWell(
      onTap: () {
        // 이미지 피커 호출 (나중에 추가)
        print("이미지 추가 클릭");
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              "사진 추가하기",
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. 카테고리 선택 위젯. 내정보에서도 변경 가능하고, 프로필 등록 후 셀렉트 페이지에서도 먼저 설정하고 들어올 수 있음!
  // 빵류 / 과자류 분기처리
  Widget _buildCategorySelector(ColorScheme colorScheme, TextTheme textTheme) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == _categories[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = _categories[index]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.grey[100],
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected ? colorScheme.primary : Colors.grey[300]!,
                ),
              ),
              child: Text(
                _categories[index],
                style: textTheme.bodyMedium?.copyWith(
                  color: isSelected ? colorScheme.onPrimary : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 5. 가게명 입력 필드 위젯
  Widget _buildBakeryNameField(ColorScheme colorScheme, TextTheme textTheme) {
    return TextFormField(
      controller: _bakeryController,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "가게명",
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(width: 1.5, height: 16, color: Colors.grey[400]),
            ],
          ),
        ),
        hintText: "가게명을 입력해주세요.",
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
  // 6. 가격 추가 영역 위젯

  // 7. 시식여부 선택영역 위젯

  // 8. 맛, 풍미, 향, 식김 선택영역 위젯

  // 9. 별점 위젯. 별점 옆에 '총점0.0' 실시간 반영하기
  Widget _buildRatingBar(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = index + 1.0;
                });
              },
              child: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: index < _rating ? Colors.amber : Colors.grey[300],
                size: 32,
              ),
            );
          }),
        ),
        // 실시간 총점표시
        Text(
          "총점 ${_rating.toStringAsFixed(1)}",
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
