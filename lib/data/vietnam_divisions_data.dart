import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;

class VietnamDivisionsData {
  static List<String> get provinces {
    final list = dvhcvn.level1s.map((l1) {
      return _cleanProvinceName(l1.name);
    }).toList();
    list.sort((a, b) => a.compareTo(b));
    return list;
  }

  static String _cleanProvinceName(String rawName) {
    if (rawName == 'Thành phố Hồ Chí Minh') return 'TP. Hồ Chí Minh';
    return rawName.replaceAll(RegExp(r'^(Thành phố|Tỉnh)\s+'), '');
  }

  static List<String> getWardsForProvince(String selectedProvince) {
    try {
      final l1 = dvhcvn.level1s.firstWhere(
        (item) =>
            _cleanProvinceName(item.name).toLowerCase() ==
                selectedProvince.toLowerCase() ||
            item.name.toLowerCase() == selectedProvince.toLowerCase(),
      );

      final List<String> wards = [];
      for (final child in l1.children) {
        if (child.children.isNotEmpty) {
          for (final ward in child.children) {
            wards.add(ward.name);
          }
        } else {
          wards.add(child.name);
        }
      }
      wards.sort((a, b) => a.compareTo(b));
      if (wards.isNotEmpty) {
        return wards;
      }
    } catch (_) {}

    return const [
      'Phường 1',
      'Phường 2',
      'Phường 3',
      'Phường Tân Định',
      'Phường Bến Thành',
    ];
  }
}
