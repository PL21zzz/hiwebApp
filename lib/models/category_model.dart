import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final String emoji;
  final IconData? icon;
  final Color? bgColor;
  final Color? iconColor;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.emoji,
    this.icon,
    this.bgColor,
    this.iconColor,
  });

  static const List<CategoryModel> mockCategories = [
    CategoryModel(id: 'c1', emoji: '💊', title: 'Thực phẩm chức năng'),
    CategoryModel(id: 'c2', emoji: '✨', title: 'Collagen'),
    CategoryModel(id: 'c3', emoji: '💄', title: 'Mỹ phẩm'),
    CategoryModel(id: 'c4', emoji: '👶', title: 'Mẹ và bé'),
    CategoryModel(id: 'c5', emoji: '👕', title: 'Thời trang'),
  ];
}

class DrawerCategoryModel {
  final String id;
  final String emoji;
  final String title;

  const DrawerCategoryModel({
    required this.id,
    required this.emoji,
    required this.title,
  });

  static const List<DrawerCategoryModel> mockDrawerCategories = [
    DrawerCategoryModel(id: 'dc1', emoji: '🔧', title: 'Phụ kiện'),
    DrawerCategoryModel(id: 'dc2', emoji: '🎨', title: 'Nghệ thuật & Đồ sưu tầm'),
    DrawerCategoryModel(id: 'dc3', emoji: '👜', title: 'Túi xách & Ví'),
    DrawerCategoryModel(id: 'dc4', emoji: '💄', title: 'Chăm sóc cơ thể & Sắc đẹp'),
    DrawerCategoryModel(id: 'dc5', emoji: '📚', title: 'Sách, Phim & Âm nhạc'),
    DrawerCategoryModel(id: 'dc6', emoji: '👕', title: 'Quần áo'),
    DrawerCategoryModel(id: 'dc7', emoji: '✂️', title: 'Vật tư & Dụng cụ Thủ công'),
    DrawerCategoryModel(id: 'dc8', emoji: '💻', title: 'Điện tử & Phụ kiện'),
    DrawerCategoryModel(id: 'dc9', emoji: '🏠', title: 'Nhà cửa & Đời sống'),
    DrawerCategoryModel(id: 'dc10', emoji: '💍', title: 'Trang sức'),
    DrawerCategoryModel(id: 'dc11', emoji: '🎉', title: 'Văn phòng phẩm & Đồ dùng ...'),
    DrawerCategoryModel(id: 'dc12', emoji: '🐾', title: 'Đồ dùng cho thú cưng'),
    DrawerCategoryModel(id: 'dc13', emoji: '👟', title: 'Giày dép'),
    DrawerCategoryModel(id: 'dc14', emoji: '🎮', title: 'Đồ chơi & Trò chơi'),
    DrawerCategoryModel(id: 'dc15', emoji: '💒', title: 'Đám cưới'),
  ];
}

class SubcategoryModel {
  final String id;
  final String emoji;
  final String title;
  final bool hasChevron;
  final String? targetCategoryId;

  const SubcategoryModel({
    required this.id,
    required this.emoji,
    required this.title,
    this.hasChevron = false,
    this.targetCategoryId,
  });

  // 1. Phụ kiện
  static const List<SubcategoryModel> mockPhuKien = [
    SubcategoryModel(id: 'sub1', emoji: '📦', title: 'Yếm người lớn'),
    SubcategoryModel(id: 'sub2', emoji: '📦', title: 'Tạp dề'),
    SubcategoryModel(id: 'sub3', emoji: '📦', title: 'Thắt lưng & Dây đeo quần'),
    SubcategoryModel(id: 'sub4', emoji: '📦', title: 'Hoa cài & Hoa cầm tay'),
    SubcategoryModel(id: 'sub5', emoji: '📦', title: 'Vòng cổ cho thú cưng'),
    SubcategoryModel(id: 'sub6', emoji: '📦', title: 'Phụ kiện hóa trang'),
    SubcategoryModel(id: 'sub7', emoji: '📦', title: 'Khẩu trang & Phụ kiện'),
    SubcategoryModel(id: 'sub8', emoji: '📦', title: 'Găng tay & Bao tay'),
    SubcategoryModel(id: 'sub9', emoji: '📦', title: 'Phụ kiện tóc'),
    SubcategoryModel(id: 'sub10', emoji: '📦', title: 'Quạt cầm tay'),
    SubcategoryModel(id: 'sub11', emoji: '📦', title: 'Mũ & Phụ kiện đội đầu'),
    SubcategoryModel(id: 'sub12', emoji: '📦', title: 'Móc khóa & Dây đeo'),
    SubcategoryModel(id: 'sub13', emoji: '📦', title: 'Latkans'),
    SubcategoryModel(id: 'sub14', emoji: '📦', title: 'Miếng dán & Phụ kiện trang trí'),
    SubcategoryModel(id: 'sub15', emoji: '📦', title: 'Ghim & Kẹp'),
    SubcategoryModel(id: 'sub16', emoji: '📦', title: 'Khăn quàng & Khăn choàng'),
    SubcategoryModel(id: 'sub17', emoji: '📦', title: 'Phụ kiện Suit & Cà vạt'),
    SubcategoryModel(id: 'sub18', emoji: '📦', title: 'Kính râm & Kính mắt'),
    SubcategoryModel(id: 'sub19', emoji: '📦', title: 'Ô & Phụ kiện đi mưa'),
  ];

  // 2. Nghệ thuật & Đồ sưu tầm
  static const List<SubcategoryModel> mockNgheThuat = [
    SubcategoryModel(id: 'nt1', emoji: '📦', title: 'Thẻ giao lưu nghệ sĩ'),
    SubcategoryModel(id: 'nt2', emoji: '📦', title: 'Đồ sưu tầm'),
    SubcategoryModel(id: 'nt3', emoji: '📦', title: 'Búp bê & Mô hình thu nhỏ'),
    SubcategoryModel(id: 'nt4', emoji: '📦', title: 'Vẽ & Minh họa'),
    SubcategoryModel(id: 'nt5', emoji: '📦', title: 'Sợi thủ công'),
    SubcategoryModel(id: 'nt6', emoji: '📦', title: 'Gốm mỹ thuật'),
    SubcategoryModel(id: 'nt7', emoji: '📦', title: 'Thủy tinh nghệ thuật'),
    SubcategoryModel(id: 'nt8', emoji: '📦', title: 'Hỗn hợp & Collage'),
    SubcategoryModel(id: 'nt9', emoji: '📦', title: 'Tranh vẽ'),
    SubcategoryModel(id: 'nt10', emoji: '📦', title: 'Nhiếp ảnh'),
    SubcategoryModel(id: 'nt11', emoji: '📦', title: 'Bản in'),
    SubcategoryModel(id: 'nt12', emoji: '📦', title: 'Tượng điêu khắc'),
  ];

  // 3. Túi xách & Ví
  static const List<SubcategoryModel> mockTuiXach = [
    SubcategoryModel(id: 'tx1', emoji: '📦', title: 'Hộp đựng phụ kiện'),
    SubcategoryModel(id: 'tx2', emoji: '📦', title: 'Ba lô'),
    SubcategoryModel(id: 'tx3', emoji: '📦', title: 'Túi đựng quần áo & giày dép'),
    SubcategoryModel(id: 'tx4', emoji: '📦', title: 'Hộp đựng mỹ phẩm & đồ vệ sinh...'),
    SubcategoryModel(id: 'tx5', emoji: '📦', title: 'Túi đựng tã bỉm'),
    SubcategoryModel(id: 'tx6', emoji: '📦', title: 'Túi đeo chéo bụng'),
    SubcategoryModel(id: 'tx7', emoji: '📦', title: 'Túi đựng thực phẩm & Túi giữ nh...'),
    SubcategoryModel(id: 'tx8', emoji: '📦', title: 'Túi xách nữ'),
    SubcategoryModel(id: 'tx9', emoji: '📦', title: 'Hành lý & Đồ du lịch'),
    SubcategoryModel(id: 'tx10', emoji: '📦', title: 'Túi đi chợ'),
    SubcategoryModel(id: 'tx11', emoji: '📦', title: 'Túi đưa thư'),
    SubcategoryModel(id: 'tx12', emoji: '📦', title: 'Túi nhỏ và Ví đựng tiền xu'),
    SubcategoryModel(id: 'tx13', emoji: '📦', title: 'Túi thể thao'),
    SubcategoryModel(id: 'tx14', emoji: '📦', title: 'Túi tote'),
    SubcategoryModel(id: 'tx15', emoji: '📦', title: 'Ví & Kẹp tiền'),
  ];

  // 4. Chăm sóc cơ thể & Sắc đẹp
  static const List<SubcategoryModel> mockChamSoc = [
    SubcategoryModel(id: 'cs1', emoji: '📦', title: 'Chăm sóc Bé & Trẻ nhỏ'),
    SubcategoryModel(id: 'cs2', emoji: '📦', title: 'Phụ kiện phòng tắm'),
    SubcategoryModel(id: 'cs3', emoji: '📦', title: 'Tinh dầu'),
    SubcategoryModel(id: 'cs4', emoji: '📦', title: 'Nước hoa'),
    SubcategoryModel(id: 'cs5', emoji: '📦', title: 'Chăm sóc tóc'),
    SubcategoryModel(id: 'cs6', emoji: '📦', title: 'Trang điểm & Mỹ phẩm'),
    SubcategoryModel(id: 'cs7', emoji: '📦', title: 'Chăm sóc cá nhân'),
    SubcategoryModel(id: 'cs8', emoji: '📦', title: 'Chăm sóc da'),
    SubcategoryModel(id: 'cs9', emoji: '📦', title: 'Xà phòng'),
    SubcategoryModel(id: 'cs10', emoji: '📦', title: 'Spa & Thư giãn'),
  ];

  // 5. Sách, Phim & Âm nhạc
  static const List<SubcategoryModel> mockSachPhim = [
    SubcategoryModel(id: 'sp1', emoji: '📦', title: 'Sách'),
    SubcategoryModel(id: 'sp2', emoji: '📦', title: 'Phim ảnh'),
    SubcategoryModel(id: 'sp3', emoji: '📦', title: 'Âm nhạc'),
    SubcategoryModel(id: 'sp4', emoji: '📦', title: 'Vỏ hộp Video'),
  ];

  // 6. Quần áo
  static const List<SubcategoryModel> mockQuanAo = [
    SubcategoryModel(id: 'qa1', emoji: '📦', title: 'Quần áo bé trai'),
    SubcategoryModel(id: 'qa2', emoji: '📦', title: 'Quần áo người lớn unisex'),
    SubcategoryModel(id: 'qa3', emoji: '📦', title: 'Quần áo trẻ em unisex'),
    SubcategoryModel(id: 'qa4', emoji: '📦', title: 'Quần áo bé gái'),
    SubcategoryModel(id: 'qa5', emoji: '📦', title: 'Thời trang nam'),
    SubcategoryModel(id: 'qa6', emoji: '📦', title: 'Quần áo nữ'),
  ];

  // 7. Vật tư & Dụng cụ Thủ công
  static const List<SubcategoryModel> mockVatTuThucCong = [
    SubcategoryModel(id: 'vt1', emoji: '📦', title: 'Hạt, Đá quý & Cabochons'),
    SubcategoryModel(id: 'vt2', emoji: '📦', title: 'Vật tư Làm đẹp'),
    SubcategoryModel(id: 'vt3', emoji: '📦', title: 'Phôi liệu'),
    SubcategoryModel(id: 'vt4', emoji: '📦', title: 'Cọ vẽ & dụng cụ làm sạch'),
    SubcategoryModel(id: 'vt5', emoji: '📦', title: 'Vải bố & Bề mặt vẽ'),
    SubcategoryModel(id: 'vt6', emoji: '📦', title: 'Khóa & Phụ kiện cài'),
    SubcategoryModel(id: 'vt7', emoji: '📦', title: 'Trang trí & Phụ kiện'),
    SubcategoryModel(id: 'vt8', emoji: '📦', title: 'Vật tư làm búp bê & mô hình'),
    SubcategoryModel(id: 'vt9', emoji: '📦', title: 'Vải & phụ liệu may mặc'),
    SubcategoryModel(id: 'vt10', emoji: '📦', title: 'Phụ kiện kim hoàn'),
    SubcategoryModel(id: 'vt11', emoji: '📦', title: 'Vật tư cắm hoa'),
    SubcategoryModel(id: 'vt12', emoji: '📦', title: 'Khung, Vòng & Chân đế'),
    SubcategoryModel(id: 'vt13', emoji: '📦', title: 'Keo & Chất kết dính'),
    SubcategoryModel(id: 'vt14', emoji: '📦', title: 'Thiết bị hình ảnh & chiếu sáng'),
    SubcategoryModel(id: 'vt15', emoji: '📦', title: 'Dụng cụ nhà bếp'),
    SubcategoryModel(id: 'vt16', emoji: '📦', title: 'Dao & dụng cụ cắt'),
    SubcategoryModel(id: 'vt17', emoji: '📦', title: 'Khuôn'),
    SubcategoryModel(id: 'vt18', emoji: '📦', title: 'Sơn, mực & thuốc nhuộm'),
    SubcategoryModel(id: 'vt19', emoji: '📦', title: 'Mẫu & Hướng dẫn'),
    SubcategoryModel(id: 'vt20', emoji: '📦', title: 'Bút, Chì & Dụng cụ đánh dấu'),
    SubcategoryModel(id: 'vt21', emoji: '📦', title: 'Nguyên liệu thô'),
    SubcategoryModel(id: 'vt22', emoji: '📦', title: 'Vật tư an toàn'),
    SubcategoryModel(id: 'vt23', emoji: '📦', title: 'Con dấu & Mộc'),
    SubcategoryModel(id: 'vt24', emoji: '📦', title: 'Lưu trữ & Sắp xếp'),
    SubcategoryModel(id: 'vt25', emoji: '📦', title: 'Dây & Sợi'),
    SubcategoryModel(id: 'vt26', emoji: '📦', title: 'Dụng cụ & Thiết bị'),
    SubcategoryModel(id: 'vt27', emoji: '📦', title: 'Sợi & Nguyên liệu làm thủ công'),
  ];

  // 8. Điện tử & Phụ kiện
  static const List<SubcategoryModel> mockDienTu = [
    SubcategoryModel(id: 'dt1', emoji: '📦', title: 'Âm thanh'),
    SubcategoryModel(id: 'dt2', emoji: '📦', title: 'Pin & Sạc'),
    SubcategoryModel(id: 'dt3', emoji: '📦', title: 'Cáp & Dây nối'),
    SubcategoryModel(id: 'dt4', emoji: '📦', title: 'Máy ảnh & Thiết bị'),
    SubcategoryModel(id: 'dt5', emoji: '📦', title: 'Phụ tùng & Phụ kiện ô tô'),
    SubcategoryModel(id: 'dt6', emoji: '📦', title: 'Phụ kiện điện thoại'),
    SubcategoryModel(id: 'dt7', emoji: '📦', title: 'Máy tính & Thiết bị ngoại vi'),
    SubcategoryModel(id: 'dt8', emoji: '📦', title: 'Decal & Skin trang trí'),
    SubcategoryModel(id: 'dt9', emoji: '📦', title: 'Đế & Giá đỡ'),
    SubcategoryModel(id: 'dt10', emoji: '📦', title: 'Ốp lưng & Bao da điện tử'),
    SubcategoryModel(id: 'dt11', emoji: '📦', title: 'Thiết bị điện tử tiện ích'),
    SubcategoryModel(id: 'dt12', emoji: '📦', title: 'Vật tư Maker'),
    SubcategoryModel(id: 'dt13', emoji: '📦', title: 'Linh kiện điện tử'),
    SubcategoryModel(id: 'dt14', emoji: '📦', title: 'TV & Máy chiếu'),
    SubcategoryModel(id: 'dt15', emoji: '📦', title: 'Điện thoại & Tai nghe'),
    SubcategoryModel(id: 'dt16', emoji: '📦', title: 'Trò chơi điện tử'),
  ];

  // 9. Nhà cửa & Đời sống
  static const List<SubcategoryModel> mockNhaCua = [
    SubcategoryModel(id: 'nc1', emoji: '📦', title: 'Phòng tắm'),
    SubcategoryModel(id: 'nc2', emoji: '📦', title: 'Chăn ga gối đệm'),
    SubcategoryModel(id: 'nc3', emoji: '📦', title: 'Đồ dùng vệ sinh'),
    SubcategoryModel(id: 'nc4', emoji: '📦', title: 'Rèm cửa & phụ kiện trang trí cửa ...'),
    SubcategoryModel(id: 'nc5', emoji: '📦', title: 'Thảm sàn'),
    SubcategoryModel(id: 'nc6', emoji: '📦', title: 'Thực phẩm & Đồ uống'),
    SubcategoryModel(id: 'nc7', emoji: '📦', title: 'Nội thất'),
    SubcategoryModel(id: 'nc8', emoji: '📦', title: 'Thiết bị gia dụng'),
    SubcategoryModel(id: 'nc9', emoji: '📦', title: 'Trang trí nhà cửa'),
    SubcategoryModel(id: 'nc10', emoji: '📦', title: 'Cải Tạo Nhà Cửa'),
    SubcategoryModel(id: 'nc11', emoji: '📦', title: 'Bếp và Phòng ăn'),
    SubcategoryModel(id: 'nc12', emoji: '📦', title: 'Đèn trang trí'),
    SubcategoryModel(id: 'nc13', emoji: '📦', title: 'Văn phòng phẩm'),
    SubcategoryModel(id: 'nc14', emoji: '📦', title: 'Ngoài trời & Làm vườn'),
    SubcategoryModel(id: 'nc15', emoji: '📦', title: 'Tâm linh & Tôn giáo'),
    SubcategoryModel(id: 'nc16', emoji: '📦', title: 'Lưu Trữ & Sắp Xếp'),
  ];

  // 10. Trang sức
  static const List<SubcategoryModel> mockTrangSuc = [
    SubcategoryModel(id: 'ts1', emoji: '📦', title: 'Trang sức cơ thể'),
    SubcategoryModel(id: 'ts2', emoji: '📦', title: 'Vòng tay'),
    SubcategoryModel(id: 'ts3', emoji: '📦', title: 'Trang sức tưởng niệm'),
    SubcategoryModel(id: 'ts4', emoji: '📦', title: 'Hoa tai'),
    SubcategoryModel(id: 'ts5', emoji: '📦', title: 'Bộ trang sức'),
    SubcategoryModel(id: 'ts6', emoji: '📦', title: 'Hộp đựng trang sức'),
    SubcategoryModel(id: 'ts7', emoji: '📦', title: 'Dây chuyền'),
    SubcategoryModel(id: 'ts8', emoji: '📦', title: 'Nhẫn'),
    SubcategoryModel(id: 'ts9', emoji: '📦', title: 'Trang sức thông minh'),
    SubcategoryModel(id: 'ts10', emoji: '📦', title: 'Đồng hồ'),
  ];

  // 11. Văn phòng phẩm & Đồ dùng ...
  static const List<SubcategoryModel> mockVanPhongPham = [
    SubcategoryModel(id: 'vp1', emoji: '📦', title: 'Giấy tờ'),
    SubcategoryModel(id: 'vp2', emoji: '📦', title: 'Đồ dùng tiệc'),
  ];

  // 12. Đồ dùng cho thú cưng
  static const List<SubcategoryModel> mockThuCung = [
    SubcategoryModel(id: 'tc1', emoji: '📦', title: 'Nuôi ong'),
    SubcategoryModel(id: 'tc2', emoji: '📦', title: 'Vật dụng cho thú cưng'),
    SubcategoryModel(id: 'tc3', emoji: '📦', title: 'Lồng & Nhà cho thú cưng'),
    SubcategoryModel(id: 'tc4', emoji: '📦', title: 'Quần áo, Phụ kiện & Giày dép ch...'),
    SubcategoryModel(id: 'tc5', emoji: '📦', title: 'Vòng cổ & Dây dắt cho thú cưng'),
    SubcategoryModel(id: 'tc6', emoji: '📦', title: 'Đồ dùng cho ăn uống của thú cư...'),
    SubcategoryModel(id: 'tc7', emoji: '📦', title: 'Đồ nội thất cho thú cưng'),
    SubcategoryModel(id: 'tc8', emoji: '📦', title: 'Cửa & Hàng rào cho thú cưng'),
    SubcategoryModel(id: 'tc9', emoji: '📦', title: 'Chăm sóc sức khỏe thú cưng'),
    SubcategoryModel(id: 'tc10', emoji: '📦', title: 'Lưu trữ đồ dùng thú cưng'),
    SubcategoryModel(id: 'tc11', emoji: '📦', title: 'Đồ chơi thú cưng'),
    SubcategoryModel(id: 'tc12', emoji: '📦', title: 'Đồ dùng cho thú cưỡi & Gia súc'),
    SubcategoryModel(id: 'tc13', emoji: '📦', title: 'Huấn luyện thú cưng'),
    SubcategoryModel(id: 'tc14', emoji: '📦', title: 'Hũ tro & Đồ lưu niệm'),
  ];

  // 13. Giày dép
  static const List<SubcategoryModel> mockGiayDep = [
    SubcategoryModel(id: 'gd1', emoji: '📦', title: 'Giày dép bé trai'),
    SubcategoryModel(id: 'gd2', emoji: '📦', title: 'Giày dép người lớn unisex'),
    SubcategoryModel(id: 'gd3', emoji: '📦', title: 'Giày trẻ em unisex'),
    SubcategoryModel(id: 'gd4', emoji: '📦', title: 'Giày bé gái'),
    SubcategoryModel(id: 'gd5', emoji: '📦', title: 'Miếng lót giày & phụ kiện'),
    SubcategoryModel(id: 'gd6', emoji: '📦', title: 'Giày nam'),
    SubcategoryModel(id: 'gd7', emoji: '📦', title: 'Giày Nữ'),
  ];

  // 14. Đồ chơi & Trò chơi
  static const List<SubcategoryModel> mockDoChoi = [
    SubcategoryModel(id: 'dc_sub1', emoji: '📦', title: 'Trò chơi & Câu đố'),
    SubcategoryModel(id: 'dc_sub2', emoji: '📦', title: 'Thể thao & Ngoài trời'),
    SubcategoryModel(id: 'dc_sub3', emoji: '📦', title: 'Đồ chơi'),
  ];

  // 15. Đám cưới
  static const List<SubcategoryModel> mockDamCuoi = [
    SubcategoryModel(id: 'cw1', emoji: '🔧', title: 'Phụ kiện', hasChevron: true, targetCategoryId: 'dc1'),
    SubcategoryModel(id: 'cw2', emoji: '📦', title: 'Trang Phục Cưới'),
    SubcategoryModel(id: 'cw3', emoji: '📦', title: 'Trang Trí Tiệc Cưới'),
    SubcategoryModel(id: 'cw4', emoji: '📦', title: 'Quà tặng & Kỷ niệm'),
    SubcategoryModel(id: 'cw5', emoji: '📦', title: 'Thiệp & Giấy tờ'),
    SubcategoryModel(id: 'cw6', emoji: '💍', title: 'Trang sức', hasChevron: true, targetCategoryId: 'dc10'),
    SubcategoryModel(id: 'cw7', emoji: '👟', title: 'Giày dép', hasChevron: true, targetCategoryId: 'dc13'),
  ];

  static List<SubcategoryModel> getSubcategoriesForCategory(String categoryId) {
    switch (categoryId) {
      case 'dc1':
        return mockPhuKien;
      case 'dc2':
        return mockNgheThuat;
      case 'dc3':
        return mockTuiXach;
      case 'dc4':
        return mockChamSoc;
      case 'dc5':
        return mockSachPhim;
      case 'dc6':
        return mockQuanAo;
      case 'dc7':
        return mockVatTuThucCong;
      case 'dc8':
        return mockDienTu;
      case 'dc9':
        return mockNhaCua;
      case 'dc10':
        return mockTrangSuc;
      case 'dc11':
        return mockVanPhongPham;
      case 'dc12':
        return mockThuCung;
      case 'dc13':
        return mockGiayDep;
      case 'dc14':
        return mockDoChoi;
      case 'dc15':
        return mockDamCuoi;
      default:
        return mockPhuKien;
    }
  }
}
