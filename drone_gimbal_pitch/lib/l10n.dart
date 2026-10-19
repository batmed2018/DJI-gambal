import 'package:flutter/material.dart';

class AppL10n {
  const AppL10n(this.locale);

  final Locale locale;

  bool get isArabic => locale.languageCode == 'ar';

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  String get appTitle => isArabic
      ? 'حاسبة زاوية ميل كاميرا الدرون'
      : 'Gimbal Pitch Angle Calculator';

  String get droneType => isArabic ? 'نوع الدرون' : 'Drone type';
  String get cameraType => isArabic ? 'نوع الكاميرا' : 'Camera type';
  String get height => isArabic ? 'الارتفاع عن الهدف (م)' : 'Height above target (m)';
  String get distance =>
      isArabic ? 'المسافة الأفقية عن الهدف (م)' : 'Horizontal distance to target (m)';
  String get calculate => isArabic ? 'احسب زاوية الميل' : 'Calculate Gimbal Pitch';
  String get resultTitle => isArabic ? 'زاوية الميل المطلوبة' : 'Required gimbal pitch';
  String get degrees => isArabic ? 'درجة' : 'degrees';
  String get negativeNote => isArabic
      ? 'الإشارة السالبة تعني أن الكاميرا تميل للأسفل نحو الهدف (Gimbal Pitch سالب).'
      : 'A negative sign means the camera tilts downward toward the target (negative gimbal pitch).';
  String get formulaNote => isArabic
      ? 'الصيغة: Pitch = −atan(Height ÷ Distance) ثم التحويل إلى درجات.'
      : 'Formula: Pitch = −atan(Height ÷ Distance), converted to degrees.';
  String get errorEmpty =>
      isArabic ? 'أدخل الارتفاع والمسافة.' : 'Enter both height and distance.';
  String get errorNumber =>
      isArabic ? 'أدخل أرقاماً صحيحة موجبة.' : 'Enter valid positive numbers.';
  String get errorDistance =>
      isArabic ? 'المسافة الأفقية يجب أن تكون أكبر من صفر.' : 'Distance must be greater than zero.';
  String get language => isArabic ? 'English' : 'العربية';
  String get selectDrone => isArabic ? 'اختر الدرون' : 'Select drone';
  String get selectCamera => isArabic ? 'اختر الكاميرا' : 'Select camera';
}

class AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const AppL10nDelegate();

  @override
  bool isSupported(Locale locale) => {'ar', 'en'}.contains(locale.languageCode);

  @override
  Future<AppL10n> load(Locale locale) async => AppL10n(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppL10n> old) => false;
}
