class ChatMessageModel {
  final String id;
  final String message;
  final String time;
  final bool isMe;

  const ChatMessageModel({
    required this.id,
    required this.message,
    required this.time,
    required this.isMe,
  });

  static Map<String, List<ChatMessageModel>> mockChatHistories = {
    // YoungFit Official Store
    'm1': [
      const ChatMessageModel(
        id: 'c1_1',
        message: 'Chào anh/chị, shop có thể hỗ trợ gì ạ?',
        time: '10:10',
        isMe: false,
      ),
      const ChatMessageModel(
        id: 'c1_2',
        message: 'Cho mình hỏi Viên uống Canxi còn hàng không shop?',
        time: '10:15',
        isMe: true,
      ),
      const ChatMessageModel(
        id: 'c1_3',
        message: 'Dạ sản phẩm còn hàng ạ, anh/chị đặt giúp em nhé',
        time: '10:24',
        isMe: false,
      ),
    ],

    // Life Extension - Hồ Chí Minh
    'm2': [
      const ChatMessageModel(
        id: 'c2_1',
        message: 'Bạn ơi, đơn hàng đã được giao cho vận chuyển',
        time: 'Hôm qua',
        isMe: false,
      ),
    ],

    // Orihiro Vietnam
    'm3': [
      const ChatMessageModel(
        id: 'c3_1',
        message: 'Sản phẩm dùng tốt lắm shop ơi',
        time: '2 ngày',
        isMe: true,
      ),
      const ChatMessageModel(
        id: 'c3_2',
        message: 'Cảm ơn bạn đã ủng hộ shop ạ 💖',
        time: '2 ngày',
        isMe: false,
      ),
    ],

    // Phương Thảo Pharmacy
    'm4': [
      const ChatMessageModel(
        id: 'c4_1',
        message: 'Shop ơi khi nào gửi hàng vậy?',
        time: '3 ngày',
        isMe: true,
      ),
      const ChatMessageModel(
        id: 'c4_2',
        message: 'Shop đã gửi hàng rồi ạ, bạn theo dõi đơn nhé',
        time: '3 ngày',
        isMe: false,
      ),
    ],

    // Blackmores Vietnam
    'm5': [
      const ChatMessageModel(
        id: 'c5_1',
        message: 'Chào bạn, bạn cần hỗ trợ gì không ạ?',
        time: '5 ngày',
        isMe: false,
      ),
    ],
  };
}
