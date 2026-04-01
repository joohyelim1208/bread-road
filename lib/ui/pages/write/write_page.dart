import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bread_road/core/enum/write_category_type.dart';
import 'package:bread_road/core/utils/input_decoration_util.dart';
import 'package:bread_road/core/utils/button_util.dart';
import 'package:bread_road/core/utils/validator_util.dart';
import 'package:bread_road/ui/widgets/app_bar_widget.dart';

import 'widgets/image_picker_section.dart';
import 'widgets/sensory_evaluation_section.dart';
import 'widgets/bread_rating_bar.dart';
import 'widgets/visit_date_picker.dart';
import 'widgets/category_selector.dart';

class WritePage extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const WritePage({super.key, this.initialData});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  WriteCategoryType _currentType = WriteCategoryType.bread;

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
  bool _isScheduled = true;

  final Set<String> _selectedTastes = {};
  String? _selectedFlavor;
  final Set<String> _selectedScents = {};
  final Set<String> _selectedTextures = {};

  DateTime _selectedDate = DateTime.now();

  final List<String> _selectedImages = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
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
      if (data["images"] is List) {
        _selectedImages.addAll((data["images"] as List).cast<String>());
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
                    _buildTypeSelector(colorScheme, textTheme),
                    const SizedBox(height: 12),

                    CategorySelector(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    ImagePickerSection(
                      imagePaths: _selectedImages,
                      onImagesChanged: (newImages) {
                        setState(() {
                          _selectedImages.clear();
                          _selectedImages.addAll(newImages);
                        });
                      },
                    ),
                    const SizedBox(height: 24),

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
                    _buildBakeryNameField(colorScheme, textTheme),
                    const SizedBox(height: 12),

                    _buildPriceField(colorScheme, textTheme),
                    const SizedBox(height: 24),

                    VisitDatePicker(
                      selectedDate: _selectedDate,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 24),

                    _buildTastingStatusArea(colorScheme, textTheme),
                    const SizedBox(height: 32),

                    SensoryEvaluationSection(
                      selectedTastes: _selectedTastes,
                      selectedFlavor: _selectedFlavor,
                      selectedScents: _selectedScents,
                      selectedTextures: _selectedTextures,
                      onTastesChanged: (taste) {
                        setState(() {
                          if (_selectedTastes.contains(taste)) {
                            _selectedTastes.remove(taste);
                          } else {
                            _selectedTastes.add(taste);
                          }
                        });
                      },
                      onFlavorChanged: (flavor) {
                        setState(() {
                          _selectedFlavor = flavor;
                        });
                      },
                      onScentsChanged: (scent) {
                        setState(() {
                          if (_selectedScents.contains(scent)) {
                            _selectedScents.remove(scent);
                          } else {
                            _selectedScents.add(scent);
                          }
                        });
                      },
                      onTexturesChanged: (texture) {
                        setState(() {
                          if (_selectedTextures.contains(texture)) {
                            _selectedTextures.remove(texture);
                          } else {
                            _selectedTextures.add(texture);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 32),

                    BreadRatingBar(
                      rating: _rating,
                      onRatingChanged: (newRating) {
                        setState(() {
                          _rating = newRating;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

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
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ButtonUtil(
          label: "저장하기",
          onTap: () {
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
              "price": _priceController.text,
              "isScheduled": _isScheduled,
              "tastes": _selectedTastes.toList(),
              "flavor": _selectedFlavor,
              "scents": _selectedScents.toList(),
              "textures": _selectedTextures.toList(),
              "content": _contentController.text,
              "visitDate": DateFormat('yyyy-MM-dd').format(_selectedDate),
              "location": "서울 시군구",
              "images": _selectedImages,
            };
            Navigator.pop(context, recordData);
          },
        ),
      ),
    );
  }

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "₩",
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

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
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ',';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    String plainNumber = newValue.text.replaceAll(separator, '');
    if (plainNumber.length > 8) {
      return oldValue;
    }
    final int? value = int.tryParse(plainNumber);
    if (value == null) return oldValue;
    final formatter = NumberFormat('#,###');
    final String newText = formatter.format(value);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
