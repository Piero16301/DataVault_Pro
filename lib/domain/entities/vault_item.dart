class VaultItem {
  const VaultItem({
    required this.id,
    required this.title,
    required this.decryptedPayload,
  });

  final String id;
  final String title;
  final String decryptedPayload;
}
