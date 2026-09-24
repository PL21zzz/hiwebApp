class VideoCommentModel {
  final String id;
  final String authorName;
  final String? avatarUrl;
  final String content;
  final String timeLabel;
  final int likeCount;
  final bool isLiked;
  final List<VideoCommentModel> replies;

  const VideoCommentModel({
    required this.id,
    required this.authorName,
    required this.content,
    required this.timeLabel,
    this.avatarUrl,
    this.likeCount = 0,
    this.isLiked = false,
    this.replies = const [],
  });
}
