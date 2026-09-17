import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_colors.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'FilterDrawer',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.78,
              child: const FilterDrawer(),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedBrands = {};
  final Set<String> _selectedOrigins = {};
  final Set<String> _selectedGenders = {};
  final Set<String> _selectedLocations = {};
  final Set<int> _selectedRatings = {};

  final TextEditingController _minPriceController = TextEditingController(text: '0');
  final TextEditingController _maxPriceController = TextEditingController(text: '5000000');

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  Widget _buildCardSection({
    required String title,
    Widget? icon,
    String? searchHint,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                icon,
                const SizedBox(width: 6),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          if (searchHint != null) ...[
            const SizedBox(height: 8),
            Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.search, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: searchHint,
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 6),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCheckboxRow({
    required String label,
    required String count,
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!isChecked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: isChecked,
                onChanged: onChanged,
                activeColor: AppColors.primary,
                side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '($count)',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow({
    required int stars,
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!isChecked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: isChecked,
                onChanged: onChanged,
                activeColor: AppColors.primary,
                side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  size: 14,
                  color: index < stars ? const Color(0xFFFFB800) : const Color(0xFFCBD5E1),
                );
              }),
            ),
            const SizedBox(width: 6),
            Text(
              '$stars sao',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // Drawer Header with AppColors.primary background matching status bar theme
          Container(
            color: AppColors.primary,
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bộ lọc',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 20, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scrollable Sections Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 4, bottom: 20),
              child: Column(
                children: [
                  // 1. Danh mục sản phẩm
                  _buildCardSection(
                    title: 'Danh mục sản phẩm',
                    searchHint: 'Tìm kiếm danh mục...',
                    children: [
                      _buildCheckboxRow(
                        label: 'Điện thoại',
                        count: '125',
                        isChecked: _selectedCategories.contains('cat1'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedCategories.add('cat1')
                                : _selectedCategories.remove('cat1');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Laptop',
                        count: '86',
                        isChecked: _selectedCategories.contains('cat2'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedCategories.add('cat2')
                                : _selectedCategories.remove('cat2');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Tivi',
                        count: '74',
                        isChecked: _selectedCategories.contains('cat3'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedCategories.add('cat3')
                                : _selectedCategories.remove('cat3');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Tủ lạnh',
                        count: '52',
                        isChecked: _selectedCategories.contains('cat4'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedCategories.add('cat4')
                                : _selectedCategories.remove('cat4');
                          });
                        },
                      ),
                    ],
                  ),

                  // 2. Thương hiệu
                  _buildCardSection(
                    title: 'Thương hiệu',
                    searchHint: 'Tìm kiếm thương hiệu...',
                    children: [
                      _buildCheckboxRow(
                        label: 'Samsung',
                        count: '128',
                        isChecked: _selectedBrands.contains('b1'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedBrands.add('b1')
                                : _selectedBrands.remove('b1');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'LG',
                        count: '96',
                        isChecked: _selectedBrands.contains('b2'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedBrands.add('b2')
                                : _selectedBrands.remove('b2');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Panasonic',
                        count: '72',
                        isChecked: _selectedBrands.contains('b3'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedBrands.add('b3')
                                : _selectedBrands.remove('b3');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Sony',
                        count: '64',
                        isChecked: _selectedBrands.contains('b4'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedBrands.add('b4')
                                : _selectedBrands.remove('b4');
                          });
                        },
                      ),
                    ],
                  ),

                  // 3. Xuất xứ
                  _buildCardSection(
                    title: 'Xuất xứ',
                    searchHint: 'Tìm kiếm xuất xứ...',
                    children: [
                      _buildCheckboxRow(
                        label: 'Việt Nam',
                        count: '1147',
                        isChecked: _selectedOrigins.contains('o1'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedOrigins.add('o1')
                                : _selectedOrigins.remove('o1');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Trung Quốc',
                        count: '1074',
                        isChecked: _selectedOrigins.contains('o2'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedOrigins.add('o2')
                                : _selectedOrigins.remove('o2');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Quảng Châu',
                        count: '425',
                        isChecked: _selectedOrigins.contains('o3'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedOrigins.add('o3')
                                : _selectedOrigins.remove('o3');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Hồng Kông',
                        count: '217',
                        isChecked: _selectedOrigins.contains('o4'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedOrigins.add('o4')
                                : _selectedOrigins.remove('o4');
                          });
                        },
                      ),
                    ],
                  ),

                  // 4. Giới tính
                  _buildCardSection(
                    title: 'Giới tính',
                    children: [
                      _buildCheckboxRow(
                        label: 'Nữ',
                        count: '17',
                        isChecked: _selectedGenders.contains('g1'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedGenders.add('g1')
                                : _selectedGenders.remove('g1');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Unisex',
                        count: '14',
                        isChecked: _selectedGenders.contains('g2'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedGenders.add('g2')
                                : _selectedGenders.remove('g2');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Nam',
                        count: '8',
                        isChecked: _selectedGenders.contains('g3'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedGenders.add('g3')
                                : _selectedGenders.remove('g3');
                          });
                        },
                      ),
                    ],
                  ),

                  // 5. Nơi bán
                  _buildCardSection(
                    title: 'Nơi bán',
                    icon: const Text('📍', style: TextStyle(fontSize: 14)),
                    children: [
                      _buildCheckboxRow(
                        label: 'Hà Nội',
                        count: '598',
                        isChecked: _selectedLocations.contains('l1'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedLocations.add('l1')
                                : _selectedLocations.remove('l1');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Hồ Chí Minh',
                        count: '258',
                        isChecked: _selectedLocations.contains('l2'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedLocations.add('l2')
                                : _selectedLocations.remove('l2');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'Phú Thọ',
                        count: '35',
                        isChecked: _selectedLocations.contains('l3'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedLocations.add('l3')
                                : _selectedLocations.remove('l3');
                          });
                        },
                      ),
                      _buildCheckboxRow(
                        label: 'An Giang',
                        count: '28',
                        isChecked: _selectedLocations.contains('l4'),
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? _selectedLocations.add('l4')
                                : _selectedLocations.remove('l4');
                          });
                        },
                      ),
                    ],
                  ),

                  // 6. Khoảng giá
                  _buildCardSection(
                    title: 'Khoảng giá',
                    children: [
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFCBD5E1)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextField(
                                controller: _minPriceController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 13),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('—', style: TextStyle(color: Color(0xFF94A3B8))),
                          ),
                          Expanded(
                            child: Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFCBD5E1)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextField(
                                controller: _maxPriceController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 13),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF17A2B8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Áp dụng',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 7. Đánh giá
                  _buildCardSection(
                    title: 'Đánh giá',
                    children: [
                      for (int stars = 5; stars >= 1; stars--)
                        _buildRatingRow(
                          stars: stars,
                          isChecked: _selectedRatings.contains(stars),
                          onChanged: (val) {
                            setState(() {
                              val == true
                                  ? _selectedRatings.add(stars)
                                  : _selectedRatings.remove(stars);
                            });
                          },
                        ),
                    ],
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
