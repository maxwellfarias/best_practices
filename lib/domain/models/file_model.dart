class FileModel {
  final String fileName;
  final String fileSize;
  final String dateUploaded;
  final String lastUpdated;
  final UserInfo uploadedBy;
  final String fileType;
  final String iconUrl;

  FileModel({
    required this.fileName,
    required this.fileSize,
    required this.dateUploaded,
    required this.lastUpdated,
    required this.uploadedBy,
    required this.fileType,
    required this.iconUrl,
  });
}

class UserInfo {
  final String name;
  final String email;
  final String? avatarUrl;

  UserInfo({required this.name, required this.email, this.avatarUrl});

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }
}
