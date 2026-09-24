import 'package:hiweb_app_management/features/user/voucher/models/voucher_model.dart';

abstract class VoucherRepository {
  List<VoucherItemModel> getVouchers();
}

class MockVoucherRepository implements VoucherRepository {
  @override
  List<VoucherItemModel> getVouchers() => VoucherItemModel.mockVouchers;
}
