import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/video/models/video_comment_model.dart';
import 'package:hiweb_app_management/features/video/models/video_model.dart';
import 'package:hiweb_app_management/features/video/repositories/video_comments_repository.dart';
import 'package:hiweb_app_management/core/widgets/common/surfaces/app_bottom_sheet.dart';

class VideoCommentsBottomSheet extends StatefulWidget {
  final VideoItemModel video;
  final VideoCommentsRepository repository;

  const VideoCommentsBottomSheet({
    super.key,
    required this.video,
    this.repository = const MockVideoCommentsRepository(),
  });

  static Future<void> show(
    BuildContext context, {
    required VideoItemModel video,
    VideoCommentsRepository repository = const MockVideoCommentsRepository(),
  }) {
    return AppBottomSheet.show<void>(
      context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => VideoCommentsBottomSheet(video: video, repository: repository),
    );
  }

  @override
  State<VideoCommentsBottomSheet> createState() =>
      _VideoCommentsBottomSheetState();
}

class _VideoCommentsBottomSheetState extends State<VideoCommentsBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  late List<VideoCommentModel> _comments;
  final Set<String> _likedCommentIds = {};

  @override
  void initState() {
    super.initState();
    _comments = widget.repository.getComments(widget.video.id).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _totalCommentCount => _comments.fold(
    _comments.length,
    (total, comment) => total + comment.replies.length,
  );

  void _submitComment() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() {
      _comments.insert(
        0,
        VideoCommentModel(
          id: 'local-${DateTime.now().microsecondsSinceEpoch}',
          authorName: 'Bạn',
          content: content,
          timeLabel: 'Vừa xong',
        ),
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.82,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          _buildHeader(context),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child:
                _comments.isEmpty
                    ? const Center(
                      child: Text(
                        'Chưa có bình luận nào',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      itemCount: _comments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder:
                          (context, index) => _CommentTile(
                            comment: _comments[index],
                            likedCommentIds: _likedCommentIds,
                            onLike: (commentId) {
                              setState(() {
                                if (!_likedCommentIds.add(commentId)) {
                                  _likedCommentIds.remove(commentId);
                                }
                              });
                            },
                          ),
                    ),
          ),
          _buildComposer(bottomInset),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          const SizedBox(width: 48),
          Expanded(
            child: Center(
              child: Text(
                'Bình luận ($_totalCommentCount)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: IconButton(
              tooltip: 'Đóng bình luận',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                LucideIcons.x,
                size: 18,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComposer(double bottomInset) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 10, 8 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFF0EA5E9),
            child: Text(
              'B',
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _submitComment(),
              decoration: InputDecoration(
                hintText: 'Thêm bình luận...',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ),
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Gửi bình luận',
            onPressed: _submitComment,
            icon: const Icon(
              LucideIcons.send,
              size: 19,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final VideoCommentModel comment;
  final Set<String> likedCommentIds;
  final ValueChanged<String> onLike;

  const _CommentTile({
    required this.comment,
    required this.likedCommentIds,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CommentRow(
          comment: comment,
          liked: likedCommentIds.contains(comment.id) || comment.isLiked,
          onLike: onLike,
        ),
        if (comment.replies.isNotEmpty) ...[
          const SizedBox(height: 9),
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Text(
              'Ẩn câu trả lời',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 7),
          ...comment.replies.map(
            (reply) => Padding(
              padding: const EdgeInsets.only(left: 34, top: 5),
              child: _CommentRow(
                comment: reply,
                isReply: true,
                liked: likedCommentIds.contains(reply.id) || reply.isLiked,
                onLike: onLike,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _CommentRow extends StatelessWidget {
  final VideoCommentModel comment;
  final bool isReply;
  final bool liked;
  final ValueChanged<String> onLike;

  const _CommentRow({
    required this.comment,
    required this.liked,
    required this.onLike,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = isReply ? 20.0 : 25.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CommentAvatar(
          name: comment.authorName,
          avatarUrl: comment.avatarUrl,
          size: avatarSize,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.authorName,
                style: TextStyle(
                  fontSize: isReply ? 10 : 10.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                comment.content,
                style: TextStyle(
                  fontSize: isReply ? 10 : 11,
                  height: 1.25,
                  color: const Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    comment.timeLabel,
                    style: const TextStyle(
                      fontSize: 8.5,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Trả lời',
                    style: TextStyle(
                      fontSize: 8.5,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => onLike(comment.id),
          child: Column(
            children: [
              Icon(
                liked ? Icons.favorite : LucideIcons.heart,
                size: 14,
                color:
                    liked ? const Color(0xFFEF4444) : const Color(0xFF94A3B8),
              ),
              const SizedBox(height: 2),
              Text(
                '${comment.likeCount + (liked && !comment.isLiked ? 1 : 0)}',
                style: const TextStyle(fontSize: 8, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double size;

  const _CommentAvatar({
    required this.name,
    required this.avatarUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final child =
        avatarUrl == null
            ? Text(
              name.isEmpty ? '?' : name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: size * 0.34,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF475569),
              ),
            )
            : null;
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: const Color(0xFFE2E8F0),
      backgroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl!),
      child: child,
    );
  }
}
