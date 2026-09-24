class UserModel {
  static const String googleLogoUrl =
      'https://res.cloudinary.com/dypm5avrx/image/upload/v1789955590/logo_google_z2bxfc.png';

  final String id;
  final String userName;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String? avatarUrl;
  final int points;
  final int voucherCount;
  final int coins;
  final String memberSince;
  final String rank;

  UserModel({
    required this.id,
    required this.userName,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    this.avatarUrl,
    this.points = 1250,
    this.voucherCount = 5,
    this.coins = 0,
    String? memberSince,
    String? rank,
  })  : memberSince = memberSince ?? _formatCurrentDate(),
        rank = rank ?? 'Thành viên từ: ${_formatCurrentDate()}';

  static String _formatCurrentDate() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    return '$day/$month/${now.year}';
  }

  String get fullName {
    final name = '$lastName $firstName'.trim();
    return name.isNotEmpty ? name : userName;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'usr_${json['user_name'] ?? '0'}',
      userName: json['user_name'] as String? ?? '',
      password: json['password'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      points: (json['points'] as num?)?.toInt() ?? 1250,
      voucherCount: (json['voucher_count'] as num?)?.toInt() ?? 5,
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      memberSince: json['member_since'] as String? ?? _formatCurrentDate(),
      rank: json['rank'] as String? ?? 'Thành viên từ: ${_formatCurrentDate()}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'avatar_url': avatarUrl,
      'points': points,
      'voucher_count': voucherCount,
      'coins': coins,
      'member_since': memberSince,
      'rank': rank,
    };
  }

  UserModel copyWith({
    String? id,
    String? userName,
    String? password,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? avatarUrl,
    int? points,
    int? voucherCount,
    int? coins,
    String? memberSince,
    String? rank,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      points: points ?? this.points,
      voucherCount: voucherCount ?? this.voucherCount,
      coins: coins ?? this.coins,
      memberSince: memberSince ?? this.memberSince,
      rank: rank ?? this.rank,
    );
  }
}
