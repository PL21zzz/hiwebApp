import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/chat/chat_message_model.dart';
import '../../models/chat/message_model.dart';
import '../../theme/app_colors.dart';

class ChatDetailScreen extends StatefulWidget {
  final MessageModel messageItem;

  const ChatDetailScreen({
    super.key,
    required this.messageItem,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessageModel> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(
      ChatMessageModel.mockChatHistories[widget.messageItem.id] ?? [],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: text,
          time: 'Vừa xong',
          isMe: true,
        ),
      );
    });

    _textController.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildHeaderAvatar() {
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: widget.messageItem.avatarBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.messageItem.avatarLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (widget.messageItem.isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel msg) {
    final isMe = msg.isMe;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(14),
                    topRight: const Radius.circular(14),
                    bottomLeft: Radius.circular(isMe ? 14 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 14),
                  ),
                  boxShadow: isMe
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Text(
                  msg.message,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.35,
                    color: isMe ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              msg.time,
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            // 1. Header Bar
            Container(
              color: AppColors.header,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 2, 8, 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          LucideIcons.arrowLeft,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      _buildHeaderAvatar(),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.messageItem.shopName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 1),
                            Text(
                              widget.messageItem.isOnline
                                  ? 'Đang hoạt động'
                                  : 'Ngoại tuyến',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          LucideIcons.phone,
                          color: Colors.white,
                          size: 19,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          LucideIcons.video,
                          color: Colors.white,
                          size: 19,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Chat Area with Warning Banner + Messages List
            Expanded(
              child: Column(
                children: [
                  // Warning Banner
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFCE8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFEF08A)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          LucideIcons.alertTriangle,
                          size: 15,
                          color: Color(0xFFD97706),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'LƯU Ý: Chỉ mua bán trực tiếp trên VietMade để tránh lừa đảo',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF854D0E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Message List
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(_messages[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // 3. Bottom Input Bar
            Container(
              padding: EdgeInsets.fromLTRB(
                12,
                8,
                12,
                MediaQuery.of(context).padding.bottom > 0
                    ? MediaQuery.of(context).padding.bottom
                    : 8,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0), width: 0.8),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      LucideIcons.image,
                      color: Color(0xFF64748B),
                      size: 21,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      LucideIcons.paperclip,
                      color: Color(0xFF64748B),
                      size: 21,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Center(
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF1E293B),
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Nhập tin nhắn...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF94A3B8),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.send,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
