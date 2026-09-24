import 'package:hiweb_app_management/features/video/models/video_comment_model.dart';

abstract class VideoCommentsRepository {
  List<VideoCommentModel> getComments(String videoId);
}

class MockVideoCommentsRepository implements VideoCommentsRepository {
  const MockVideoCommentsRepository();

  @override
  List<VideoCommentModel> getComments(String videoId) {
    return const [
      VideoCommentModel(
        id: 'comment-1',
        authorName: 'Hoàng Vy',
        content: 'Đây là cây không shop? Mình đang muốn đặt mấy món làm quà.',
        timeLabel: '35 phút',
        likeCount: 16,
        replies: [
          VideoCommentModel(
            id: 'reply-1',
            authorName: 'DongGia15k',
            content:
                'Dạ có bạn nha. Một số mẫu số lượng ít nên bạn chốt sớm giúp shop ạ.',
            timeLabel: '28 phút',
            likeCount: 6,
          ),
        ],
      ),
      VideoCommentModel(
        id: 'comment-2',
        authorName: 'Kim Oanh',
        content: 'Có được chọn mẫu không hay shop giao ngẫu nhiên vậy ạ?',
        timeLabel: '1 giờ',
        likeCount: 11,
        replies: [
          VideoCommentModel(
            id: 'reply-2',
            authorName: 'DongGia15k',
            content: 'Mẫu nào có phân loại thì mình chọn trực tiếp được ạ.',
            timeLabel: '54 phút',
            likeCount: 4,
          ),
          VideoCommentModel(
            id: 'reply-3',
            authorName: 'Kim Oanh',
            content: 'Ok shop, để mình xem thêm.',
            timeLabel: '50 phút',
            likeCount: 1,
          ),
        ],
      ),
      VideoCommentModel(
        id: 'comment-3',
        authorName: 'Bảo Trân',
        content: 'Video đẹp quá, shop tư vấn thêm giúp mình với ạ.',
        timeLabel: '2 giờ',
        likeCount: 21,
      ),
    ];
  }
}
