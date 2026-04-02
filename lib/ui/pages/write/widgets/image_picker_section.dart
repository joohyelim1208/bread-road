import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSection extends StatefulWidget {
  final List<String> imagePaths;
  final Function(List<String>) onImagesChanged;

  const ImagePickerSection({
    super.key,
    required this.imagePaths,
    required this.onImagesChanged,
  });

  @override
  State<ImagePickerSection> createState() => _ImagePickerSectionState();
}

class _ImagePickerSectionState extends State<ImagePickerSection> {
  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('갤러리에서 선택하기'),
                onTap: () async {
                  Navigator.pop(context);
                  if (widget.imagePaths.length >= 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('사진은 최대 10장까지 추가할 수 있습니다.')),
                    );
                    return;
                  }
                  final XFile? pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    final newPaths = List<String>.from(widget.imagePaths)
                      ..add(pickedFile.path);
                    widget.onImagesChanged(newPaths);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('직접 촬영하기'),
                onTap: () async {
                  Navigator.pop(context);
                  if (widget.imagePaths.length >= 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('사진은 최대 10장까지 추가할 수 있습니다.')),
                    );
                    return;
                  }
                  final XFile? pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    final newPaths = List<String>.from(widget.imagePaths)
                      ..add(pickedFile.path);
                    widget.onImagesChanged(newPaths);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () => _showImageSourceActionSheet(context),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: widget.imagePaths.isEmpty
                        ? Colors.grey[400]
                        : colorScheme.secondary,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.imagePaths.length} / 10",
                    style: textTheme.labelSmall?.copyWith(
                      color: widget.imagePaths.isEmpty
                          ? Colors.grey[400]
                          : colorScheme.secondary,
                      fontWeight: widget.imagePaths.isEmpty
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          ...widget.imagePaths.asMap().entries.map((entry) {
            final index = entry.key;
            final imagePath = entry.value;
            return Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: imagePath.startsWith('http')
                      ? NetworkImage(imagePath)
                      : FileImage(File(imagePath)) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        final newPaths = List<String>.from(widget.imagePaths)
                          ..removeAt(index);
                        widget.onImagesChanged(newPaths);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                  if (index == 0)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '대표사진',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
