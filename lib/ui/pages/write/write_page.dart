import 'package:bread_road/core/enum/write_category_type.dart';
import 'package:bread_road/core/utils/input_decoration_util.dart';
import 'package:bread_road/core/utils/button_util.dart';
import 'package:bread_road/ui/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bread_road/core/utils/validator_util.dart';

// 저장된 내용은 postPage에 반영이 된다!
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
  final TextEditingController _priceController = TextEditingController();

  String _breadName = "";
  String _selectedCategory = "전체";
  double _rating = 0.0;
  bool _isScheduled = true; // 8번. 시식여부: 시식예정(true) / 시식완료(false)

  // 9번. 맛, 풍미, 향, 식감 선택 데이터
  final Set<String> _selectedTastes = {};
  String? _selectedFlavor;
  final Set<String> _selectedScents = {};
  final Set<String> _selectedTextures = {};

  // 7번. 방문날짜 캘린더피커. 기본값 오늘날짜
  DateTime _selectedDate = DateTime.now();

  // 날짜 선택 팝업 함수
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010), // 선택가능한 가장 과거 날짜
      lastDate: DateTime.now(), // 오늘 이후 날짜는 선택 불가
      // 한국어 설정 시 showDatePicker 옵션으로 버튼 텍스트 직접 지정가능.
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _nameController.text = data["name"] ?? "";
      _bakeryController.text = data["bakery"] ?? "";
      _breadName = _nameController.text;
      _rating = double.tryParse(data["rating"].toString()) ?? 0.0;

      // 추가 필드 복원
      _currentType = data["mainType"] == "과자류"
          ? WriteCategoryType.snack
          : WriteCategoryType.bread;
      _selectedCategory = data["subCategory"] ?? "전체";
      _priceController.text = data["price"] ?? "";
      _contentController.text = data["content"] ?? "";
      _isScheduled = data["isScheduled"] ?? true;

      if (data["visitDate"] != null) {
        try {
          _selectedDate = DateTime.parse(data["visitDate"]);
        } catch (_) {
          _selectedDate = DateTime.now();
        }
      }

      if (data["tastes"] is List) {
        _selectedTastes.addAll((data["tastes"] as List).cast<String>());
      }
      _selectedFlavor = data["flavor"];
      if (data["scents"] is List) {
        _selectedScents.addAll((data["scents"] as List).cast<String>());
      }
      if (data["textures"] is List) {
        _selectedTextures.addAll((data["textures"] as List).cast<String>());
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bakeryController.dispose();
    _contentController.dispose();
    _priceController.dispose();
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
        appBar: AppBarWidget(title: '글쓰기'),
        // 13. extendBody를 true로 설정하여 바디 콘텐츠가 바텀바 영역까지 흐르도록 함 (투명 효과를 위해)
        extendBody: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // 1. 빵류 / 과자류 선택 영역
                    _buildTypeSelector(colorScheme, textTheme),
                    const SizedBox(height: 12),

                    // 2. 카테고리 선택 (가로 스크롤)
                    _buildCategorySelector(colorScheme, textTheme),
                    const SizedBox(height: 12),

                    // 3. 사진 추가 영역 (비활성화)
                    const SizedBox(height: 12),

                    // 4. 내가 먹은 빵 (제품명) 입력 필드 영역
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
                      decoration: InputDecorationUtil.commonDecoration(
                        context: context,
                        hintText: '제품명을 입력해주세요.',
                        counterText: "${_breadName.length} / 30",
                      ),
                      validator: ValidatorUtil.validatorBreadNameError,
                    ),
                    const SizedBox(height: 12),

                    Text(
                      "자세한 설명",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 5. 가게명 입력 필드 영역
                    _buildBakeryNameField(colorScheme, textTheme),
                    const SizedBox(height: 12),

                    // 6. 가격 추가 영역
                    _buildPriceField(colorScheme, textTheme),
                    const SizedBox(height: 24),

                    // 7. 방문날짜 선택 영역 (타이틀만)
                    _buildVisitDateTitle(textTheme),
                    const SizedBox(height: 24),

                    // 8. 시식여부 선택 영역
                    _buildTastingStatusArea(colorScheme, textTheme),
                    const SizedBox(height: 32),

                    // 9. 맛, 풍미, 향, 식감 선택영역
                    _buildSensoryEvaluationArea(colorScheme, textTheme),
                    const SizedBox(height: 32),

                    // 10. 별점 기능 영역
                    _buildRatingBar(colorScheme, textTheme),
                    const SizedBox(height: 12),

                    // 11. 글쓰기 (내용) 입력창
                    TextFormField(
                      controller: _contentController,
                      minLines: 6,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecorationUtil.commonDecoration(
                        context: context,
                        hintText: '내용을 입력해주세요.',
                      ),
                    ),

                    const SizedBox(height: 40),
                    // 14. 바텀바가 투명이므로 마지막 요소가 가려지지 않게 넉넉한 하단 여백 추가
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 12. 저장하기 버튼을 ButtonUtil로 디자인 통일 및 일관된 레이아웃 적용
        bottomNavigationBar: ButtonUtil(
          label: "저장하기",
          onTap: () {
            final recordData = {
              "mainType": _currentType == WriteCategoryType.bread ? "빵류" : "과자류",
              "subCategory": _selectedCategory,
              "name": _nameController.text.isEmpty
                  ? "빵 이름을 등록해주세요."
                  : _nameController.text,
              "bakery": _bakeryController.text.isEmpty
                  ? "가게명 없음"
                  : _bakeryController.text,
              "rating": _rating.toString(),
              "price": _priceController.text,
              "isScheduled": _isScheduled,
              "tastes": _selectedTastes.toList(),
              "flavor": _selectedFlavor,
              "scents": _selectedScents.toList(),
              "textures": _selectedTextures.toList(),
              // 11번. 글쓰기 내용(content)이 저장되지 않던 문제 해결를 위해 필드 추가
              "content": _contentController.text,
              // 저장하기의 맵에서 요일 정보 없이 이 형식으로만 저장
              "visitDate": DateFormat('yyyy-MM-dd').format(_selectedDate),
              "location": "서울 시군구",
            };
            Navigator.pop(context, recordData);
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
        _mainTypeButton("빵류", WriteCategoryType.bread, textTheme, colorScheme),
        const SizedBox(width: 12),
        _mainTypeButton("과자류", WriteCategoryType.snack, textTheme, colorScheme),
      ],
    );
  }

  Widget _mainTypeButton(
    String label,
    WriteCategoryType type,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final isSelected = _currentType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _currentType = type;
          _selectedCategory = "전체";
        }),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? colorScheme.primary : Colors.grey[300]!,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? colorScheme.primary : Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }

  // 2. 카테고리 선택 위젯
  Widget _buildCategorySelector(ColorScheme colorScheme, TextTheme textTheme) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _bakeryController,
          decoration: InputDecorationUtil.commonDecoration(
            context: context,
            hintText: "가게 이름을 입력해주세요.",
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "상호명",
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 1.5, height: 16, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.location_on_rounded, size: 16, color: Colors.grey[400]),
            const SizedBox(width: 4),
            Text(
              "임시. 위치정보 불러오기",
              style: textTheme.labelMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  // 6. 가격 추가 영역 위젯
  Widget _buildPriceField(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "가격",
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _ThousandsSeparatorInputFormatter(),
          ],
          decoration: InputDecorationUtil.commonDecoration(
            context: context,
            hintText: "가격을 입력해주세요.",
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min, // 중요: Row가 최소 크기만 차지하게 설정
                children: [
                  Text(
                    "₩",
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ), // 여기서 괄호가 누락되었었습니다.
                  ),
                ],
              ),
            ),
          ),
        ), //FormField 닫는 괄호
      ],
    );
  }

  // 7. 방문날짜 선택영역 위젯 (캘린더 피커 )
  Widget _buildVisitDateTitle(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "방문날짜",
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        InkWell(
          // 위에 선언한 변수말고 함수를 호출하기!
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey[400]!, width: 5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat(
                    'yyyy년 MM월 dd일 (E)',
                    'ko_KR',
                  ).format(_selectedDate),
                  style: textTheme.bodyLarge,
                ),
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 8. 시식여부 선택영역 위젯
  Widget _buildTastingStatusArea(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        Center(
          child: Text(
            "시식여부",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildTastingButton(
              label: "시식예정",
              isSelected: _isScheduled,
              onTap: () => setState(() => _isScheduled = true),
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 12),
            _buildTastingButton(
              label: "시식완료",
              isSelected: !_isScheduled,
              onTap: () => setState(() => _isScheduled = false),
              colorScheme: colorScheme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTastingButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.grey[100],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? colorScheme.primary : Colors.grey[300]!,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? Colors.white : Colors.grey[400],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 9. 맛, 풍미, 향, 식감 선택영역 위젯
  Widget _buildSensoryEvaluationArea(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 24),
        _buildSensorySection(
          title: "맛",
          hasMultipleChoice: true,
          options: ["고소함", "느끼함", "단맛", "짠맛", "신맛"],
          selectedOptions: _selectedTastes,
          onTap: (option) {
            setState(() {
              // 한번 터치하면 추가되고 해제되고
              if (_selectedTastes.contains(option)) {
                _selectedTastes.remove(option);
              } else {
                _selectedTastes.add(option);
              }
            });
          },
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 24),
        _buildSensorySection(
          title: "풍미",
          hasMultipleChoice: false,
          options: ["강하다", "약하다"],
          selectedSingle: _selectedFlavor,
          onTap: (option) {
            setState(() {
              _selectedFlavor = option;
            });
          },
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 24),
        _buildSensorySection(
          title: "향",
          hasMultipleChoice: true,
          options: ["버터", "곡물", "치즈", "발효", "과일"],
          selectedOptions: _selectedScents,
          onTap: (option) {
            setState(() {
              if (_selectedScents.contains(option)) {
                _selectedScents.remove(option);
              } else {
                _selectedScents.add(option);
              }
            });
          },
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 24),
        _buildSensorySection(
          title: "식감",
          hasMultipleChoice: true,
          options: ["바삭", "촉촉", "쫄깃", "부드러움"],
          selectedOptions: _selectedTextures,
          onTap: (option) {
            setState(() {
              if (_selectedTextures.contains(option)) {
                _selectedTextures.remove(option);
              } else {
                _selectedTextures.add(option);
              }
            });
          },
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 24),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }

  Widget _buildSensorySection({
    required String title,
    required bool hasMultipleChoice,
    required List<String> options,
    Set<String>? selectedOptions,
    String? selectedSingle,
    required Function(String) onTap,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasMultipleChoice) ...[
              const Spacer(),
              Text(
                "중복선택 가능",
                style: textTheme.labelSmall?.copyWith(color: Colors.grey),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = hasMultipleChoice
                ? selectedOptions!.contains(option)
                : selectedSingle == option;
            return GestureDetector(
              onTap: () => onTap(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? colorScheme.primary : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // 10. 별점 위젯 (드래그 및 0.5단위 지원)
  Widget _buildRatingBar(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "종합평가",
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              // 터치 시작 및 이동 시 별점 계산
              onHorizontalDragUpdate: (details) =>
                  _updateRating(details.localPosition, constraints.maxWidth),
              onTapDown: (details) =>
                  _updateRating(details.localPosition, constraints.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      IconData iconData = Icons.star_border;
                      Color iconColor = Colors.grey[300]!;

                      if (_rating >= index + 1) {
                        iconData = Icons.star;
                        iconColor = Colors.amber;
                      } else if (_rating > index) {
                        iconData = Icons.star_half;
                        iconColor = Colors.amber;
                      }

                      return Icon(
                        iconData,
                        color: iconColor,
                        size: 36, // 크기를 약간 키움
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "총점 ${_rating.toStringAsFixed(1)}",
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // 터치 좌표를 기반으로 별점을 0.5 단위로 계산하는 함수
  void _updateRating(Offset localPosition, double maxWidth) {
    // 별 5개의 전체 너비 대비 터치 위치 비율 (최대 너비를 별 5개 영역 정도로 제한)
    final double starAreaWidth = 36.0 * 5;
    double percent = localPosition.dx / starAreaWidth;
    double rating = (percent * 5).clamp(0.0, 5.0);

    // 0.5 단위로 반올림 (예: 4.2 -> 4.0, 4.3 -> 4.5)
    rating = (rating * 2).round() / 2.0;

    if (rating != _rating) {
      setState(() {
        _rating = rating;
      });
    }
  }
}

// 숫자 입렫 시 실시간으로 천단위 콤마를 찍어주는 '커스텀 포멧터'
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  // 구분자
  static const separator = ',';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // 변경 전 입력값
    TextEditingValue newValue,
  ) {
    // 만약 입력창이 비어있으면 빈 값 초기화
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    // 입력된 문자열에서 기존 콤마는 제거하고 숫자만 보여주기
    String plainNumber = newValue.text.replaceAll(separator, '');
    // 글자수 8자리 초과안됨
    if (plainNumber.length > 8) {
      return oldValue;
    }
    // 문자열은 무조건 정수로 int변환
    final int? value = int.tryParse(plainNumber);
    if (value == null) return oldValue;
    // intl 패키지 넘버포멧을 사용
    final formatter = NumberFormat('#,###');
    final String newText = formatter.format(value);
    // 텍스트와 함께 election커서 위치를 문자열 끝으로 항상 이동시킴!
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
