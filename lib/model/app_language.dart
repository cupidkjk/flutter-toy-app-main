class AppLanguage {
  final String name;
  final String languageCode;

  AppLanguage(this.name, this.languageCode);

  static List<AppLanguage> languages() {
    return <AppLanguage>[
      AppLanguage('English', 'en'),
      AppLanguage('Arabic', 'ar'),
    ];
  }

  @override
  bool operator ==(dynamic other) => other is AppLanguage && name == other.name;

  @override
  int get hashCode => super.hashCode;
}
