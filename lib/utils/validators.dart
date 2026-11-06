class Validators {
  // ---------- Login (PRD 9.1) ----------
  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email tidak boleh kosong.';
    final regex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
    if (!regex.hasMatch(text)) return 'Format email tidak valid.';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong.';
    return null;
  }

  // ---------- Form Task (PRD 9.2) ----------
  static String? taskTitle(String? value) {
    // trim() membuat input yang hanya berisi spasi dianggap kosong
    if (value == null || value.trim().isEmpty) {
      return 'Nama tugas wajib diisi.';
    }
    return null;
  }

  static String? category(String? value) {
    if (value == null || value.isEmpty) return 'Silakan pilih kategori.';
    return null;
  }

  static String? deadline(DateTime? value) {
    if (value == null) return 'Silakan pilih deadline.';
    return null;
  }

  static String? priority(String? value) {
    if (value == null || value.isEmpty) return 'Silakan pilih prioritas.';
    return null;
  }
}