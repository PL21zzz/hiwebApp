class VideoItemModel {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String authorName;
  final String authorAvatar;
  final String caption;
  final String productTitle;
  final String likes;
  final String comments;
  final String saves;
  final String shares;
  bool isLiked;
  bool isSaved;
  bool isFollowing;

  VideoItemModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.authorName,
    required this.authorAvatar,
    required this.caption,
    required this.productTitle,
    required this.likes,
    required this.comments,
    required this.saves,
    required this.shares,
    this.isLiked = false,
    this.isSaved = false,
    this.isFollowing = false,
  });

  static List<VideoItemModel> mockVideos = [
    VideoItemModel(
      id: 'v1',
      videoUrl:
          'assets/videos/videodetail.mp4',
      thumbnailUrl:
          'https://res.cloudinary.com/dypm5avrx/video/upload/so_0/v1789638143/videodetail1_tkmffs.jpg',
      authorName: '@DongGia15k',
      authorAvatar:
          'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
      caption:
          'Đồ xinh đồng giá 15K ✨ Nhiều mẫu mới cập nhật mỗi ngày. Cam kết hàng chính hãng 100%, chất lượng cao, đổi trả dễ dàng trong 7 ngày. Xem ngay các ưu đãi đặc biệt hôm nay!',
      productTitle: 'Xem sản phẩm (1)',
      likes: '1.3K',
      comments: '86',
      saves: 'Lưu',
      shares: 'Chia sẻ',
    ),
    VideoItemModel(
      id: 'v2',
      videoUrl:
          'assets/videos/videodetail.mp4',
      thumbnailUrl:
          'https://res.cloudinary.com/dypm5avrx/video/upload/so_0/v1789638136/videodetail2_zfkwdq.jpg',
      authorName: '@GiaDungViet',
      authorAvatar:
          'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale2_gxg0q7.webp',
      caption:
          'Khám phá các sản phẩm thủ công mỹ nghệ độc đáo cho gia đình bạn ✨ Giá hạt dẻ giao hàng tận nơi siêu tốc trên toàn quốc. Đặt hàng ngay nhận mã giảm giá 20k!',
      productTitle: 'Xem sản phẩm (2)',
      likes: '4.5K',
      comments: '128',
      saves: 'Lưu',
      shares: 'Chia sẻ',
    ),
    VideoItemModel(
      id: 'v3',
      videoUrl:
          'assets/videos/videodetail.mp4',
      thumbnailUrl:
          'https://res.cloudinary.com/dypm5avrx/video/upload/so_0/v1789638201/videodetail3_z6o8sg.jpg',
      authorName: '@MayTreDanShop',
      authorAvatar:
          'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale3_t13kns.webp',
      caption:
          'Túi cói hoạ tiết sen siêu sang chảnh đi biển hay đi chơi đều đẹp. Chất liệu mây tre đan tự nhiên 100% bền bỉ, sản xuất thủ công bởi các nghệ nhân làng nghề lâu năm.',
      productTitle: 'Xem sản phẩm (1)',
      likes: '8.9K',
      comments: '256',
      saves: 'Lưu',
      shares: 'Chia sẻ',
    ),
  ];
}
