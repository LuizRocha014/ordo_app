class Client {
  final String id;
  final String name;
  final String phone;

  const Client({
    required this.id,
    required this.name,
    required this.phone,
  });

  /// Iniciais derivadas (até 2 letras maiúsculas) — usado no avatar.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
