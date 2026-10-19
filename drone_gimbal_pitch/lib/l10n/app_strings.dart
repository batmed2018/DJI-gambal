import 'package:flutter/widgets.dart';

class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;

  bool get isArabic => locale.languageCode == 'ar';

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  String get appTitle =>
      isArabic ? 'حاسبة زاوية ميل الجيمبل' : 'Gimbal Pitch Calculator';

  String get subtitle => isArabic
      ? 'زاوية ميل كاميرا الدرون نحو الهدف'
      : 'Drone camera pitch toward the target';

  String get drone => isArabic ? 'نوع الدرون' : 'Drone type';
  String get camera => isArabic ? 'نوع الكاميرا' : 'Camera type';
  String get height => isArabic ? 'الارتفاع عن الهدف (م)' : 'Height above target (m)';
  String get distance =>
      isArabic ? 'المسافة الأفقية عن الهدف (م)' : 'Horizontal distance (m)';
  String get calculate =>
      isArabic ? 'احسب زاوية الميل' : 'Calculate Gimbal Pitch';
  String get resultTitle =>
      isArabic ? 'زاوية الميل المطلوبة' : 'Required gimbal pitch';
  String get signNote => isArabic
      ? 'الإشارة السالبة تعني أن الكاميرا تميل للأسفل نحو الهدف.'
      : 'A negative sign means the camera tilts down toward the target.';
  String get formula => isArabic
      ? 'pitch = −atan(الارتفاع ÷ المسافة)'
      : 'pitch = −atan(height ÷ distance)';
  String get invalidNumber =>
      isArabic ? 'أدخل أرقاماً صحيحة أكبر من أو تساوي صفر.' : 'Enter valid numbers ≥ 0.';
  String get bothZero => isArabic
      ? 'لا يمكن أن يكون الارتفاع والمسافة صفراً معاً.'
      : 'Height and distance cannot both be 0.';
  String get outOfRange => isArabic
      ? 'الزاوية خارج نطاق الجيمبل لهذه الكاميرا'
      : 'Angle is outside this camera gimbal range';
  String get inRange =>
      isArabic ? 'ضمن نطاق الجيمبل' : 'Within gimbal range';
  String get english => 'EN';
  String get arabic => 'ع';
}
