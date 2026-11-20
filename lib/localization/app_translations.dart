import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static const Locale fallbackLocale = Locale('en');

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          TranslationKeys.loginTitle.key: 'Welcome Back',
          TranslationKeys.loginPage.key: 'Login Page',
          TranslationKeys.loginSubtitle.key:
              'Enter any email and password to continue.',
          TranslationKeys.loginEmailLabel.key: 'Email',
          TranslationKeys.loginEmailHint.key: 'you@example.com',
          TranslationKeys.loginPasswordLabel.key: 'Password',
          TranslationKeys.loginPasswordHint.key: 'Enter password',
          TranslationKeys.loginSubmit.key: 'Log In',
          TranslationKeys.loginGoToSignUp.key: 'Create an account',
          TranslationKeys.loginErrorMessage.key:
              'Unable to log in. Please try again.',
          TranslationKeys.signUpTitle.key: 'Create Account',
          TranslationKeys.signUpSubtitle.key:
              'Enter any details to create a demo account.',
          TranslationKeys.signUpNameLabel.key: 'Name',
          TranslationKeys.signUpNameHint.key: 'Your name',
          TranslationKeys.signUpEmailLabel.key: 'Email',
          TranslationKeys.signUpEmailHint.key: 'you@example.com',
          TranslationKeys.signUpPasswordLabel.key: 'Password',
          TranslationKeys.signUpPasswordHint.key: 'Enter password',
          TranslationKeys.signUpConfirmPasswordLabel.key: 'Confirm Password',
          TranslationKeys.signUpConfirmPasswordHint.key: 'Re-enter password',
          TranslationKeys.signUpSubmit.key: 'Sign Up',
          TranslationKeys.signUpGoToLogin.key:
              'Already have an account? Log in',
          TranslationKeys.signUpErrorMessage.key:
              'Unable to sign up. Please try again.',
          TranslationKeys.homePage.key: 'Home Page',
          TranslationKeys.validationRequired.key: 'This field is required',
          TranslationKeys.validationMinLength.key:
              'Must be at least @min characters',
          TranslationKeys.validationPositiveNumber.key:
              'Enter a number greater than zero',
          TranslationKeys.validationNonNegativeInteger.key:
              'Enter a whole number of zero or more',
          TranslationKeys.errorTitle.key: 'Error',
          TranslationKeys.serverErrorTitle.key: 'Server Error',
          TranslationKeys.serverMaintenanceMessage.key:
              'The server is temporarily unavailable. Please try again later.',
          TranslationKeys.noInternetTitle.key: 'No Internet Connection',
          TranslationKeys.noInternetMessage.key:
              'Please connect to use the app.',
          TranslationKeys.settingsTitle.key: 'Settings',
          TranslationKeys.settingsLanguageTitle.key: 'Language',
          TranslationKeys.settingsLanguageSubtitle.key:
              'Switch between English and Arabic',
          TranslationKeys.settingsThemeTitle.key: 'Dark Mode',
          TranslationKeys.settingsThemeSubtitle.key:
              'Toggle light and dark appearance',
          TranslationKeys.snackbarDismiss.key: 'DISMISS',
          TranslationKeys.drawerSettings.key: 'Settings',
          TranslationKeys.drawerCreateProduct.key: 'Create Product',
          TranslationKeys.drawerLogout.key: 'Log Out',
          TranslationKeys.appName.key: 'Flutter Template',
          TranslationKeys.commonDone.key: 'Done',
          TranslationKeys.productsCreateTitle.key: 'Create Product',
          TranslationKeys.productsCreateSubtitle.key:
              'Fill in the details below to add a new product.',
          TranslationKeys.productsNameLabel.key: 'Name',
          TranslationKeys.productsNameHint.key: 'Product name',
          TranslationKeys.productsDescriptionLabel.key: 'Description',
          TranslationKeys.productsDescriptionHint.key:
              'Short product description',
          TranslationKeys.productsPriceLabel.key: 'Price',
          TranslationKeys.productsPriceHint.key: '0.00',
          TranslationKeys.productsStockLabel.key: 'Stock',
          TranslationKeys.productsStockHint.key: '0',
          TranslationKeys.productsCreateSubmit.key: 'Create Product',
          TranslationKeys.productsCreateSuccessTitle.key: 'Success',
          TranslationKeys.productsCreateSuccessMessage.key:
              'Product created successfully',
          TranslationKeys.productsCreateErrorMessage.key:
              'Failed to create product. Please try again.',
          TranslationKeys.homeHeadline.key:
              'Private AI,\nright on your device',
          TranslationKeys.homeSubtitle.key:
              'Chat with a small language model that runs fully offline. Nothing ever leaves your phone.',
          TranslationKeys.homeHighlightOffline.key:
              'Works without internet',
          TranslationKeys.homeHighlightPrivate.key:
              'Your prompts stay on this device',
          TranslationKeys.homeHighlightModel.key:
              'Powered by SmolLM2 135M',
          TranslationKeys.homeStartChat.key:
              'Start chatting',
          TranslationKeys.chatTitle.key:
              'Chat',
          TranslationKeys.chatPreparingModel.key:
              'Preparing model',
          TranslationKeys.chatLoadingModel.key:
              'Loading model into memory',
          TranslationKeys.chatLoadingHint.key:
              'This can take a few moments the first time.',
          TranslationKeys.chatLoadErrorTitle.key:
              'Could not load the model',
          TranslationKeys.chatRetry.key:
              'Try again',
          TranslationKeys.chatEmptyTitle.key:
              'Ask anything',
          TranslationKeys.chatEmptySubtitle.key:
              'The model is ready. Type a prompt below to get a reply.',
          TranslationKeys.chatInputHint.key:
              'Type a prompt',
          TranslationKeys.chatYouLabel.key:
              'You',
          TranslationKeys.chatModelLabel.key:
              'SmolLM2',
          TranslationKeys.chatGenerating.key:
              'Thinking',
          TranslationKeys.chatGenerationError.key:
              'Something went wrong while generating a reply.',
        },
        'ar': {
          TranslationKeys.loginTitle.key: 'مرحباً بعودتك',
          TranslationKeys.loginPage.key: 'صفحة تسجيل الدخول',
          TranslationKeys.loginSubtitle.key:
              'أدخل أي بريد إلكتروني وكلمة مرور للمتابعة.',
          TranslationKeys.loginEmailLabel.key: 'البريد الإلكتروني',
          TranslationKeys.loginEmailHint.key: 'you@example.com',
          TranslationKeys.loginPasswordLabel.key: 'كلمة المرور',
          TranslationKeys.loginPasswordHint.key: 'أدخل كلمة المرور',
          TranslationKeys.loginSubmit.key: 'تسجيل الدخول',
          TranslationKeys.loginGoToSignUp.key: 'إنشاء حساب',
          TranslationKeys.loginErrorMessage.key:
              'تعذر تسجيل الدخول. يرجى المحاولة مرة أخرى.',
          TranslationKeys.signUpTitle.key: 'إنشاء حساب',
          TranslationKeys.signUpSubtitle.key:
              'أدخل أي بيانات لإنشاء حساب تجريبي.',
          TranslationKeys.signUpNameLabel.key: 'الاسم',
          TranslationKeys.signUpNameHint.key: 'اسمك',
          TranslationKeys.signUpEmailLabel.key: 'البريد الإلكتروني',
          TranslationKeys.signUpEmailHint.key: 'you@example.com',
          TranslationKeys.signUpPasswordLabel.key: 'كلمة المرور',
          TranslationKeys.signUpPasswordHint.key: 'أدخل كلمة المرور',
          TranslationKeys.signUpConfirmPasswordLabel.key: 'تأكيد كلمة المرور',
          TranslationKeys.signUpConfirmPasswordHint.key:
              'أعد إدخال كلمة المرور',
          TranslationKeys.signUpSubmit.key: 'إنشاء حساب',
          TranslationKeys.signUpGoToLogin.key: 'لديك حساب؟ تسجيل الدخول',
          TranslationKeys.signUpErrorMessage.key:
              'تعذر إنشاء الحساب. يرجى المحاولة مرة أخرى.',
          TranslationKeys.homePage.key: 'الصفحة الرئيسية',
          TranslationKeys.validationRequired.key: 'هذا الحقل مطلوب',
          TranslationKeys.validationMinLength.key:
              'يجب أن يكون على الأقل @min أحرف',
          TranslationKeys.validationPositiveNumber.key:
              'أدخل رقماً أكبر من صفر',
          TranslationKeys.validationNonNegativeInteger.key:
              'أدخل عدداً صحيحاً صفر أو أكثر',
          TranslationKeys.errorTitle.key: 'خطأ',
          TranslationKeys.serverErrorTitle.key: 'خطأ في الخادم',
          TranslationKeys.serverMaintenanceMessage.key:
              'الخادم غير متاح مؤقتاً. يرجى المحاولة مرة أخرى لاحقاً.',
          TranslationKeys.noInternetTitle.key: 'لا يوجد اتصال بالإنترنت',
          TranslationKeys.noInternetMessage.key:
              'يرجى الاتصال بالإنترنت لاستخدام التطبيق.',
          TranslationKeys.settingsTitle.key: 'الإعدادات',
          TranslationKeys.settingsLanguageTitle.key: 'اللغة',
          TranslationKeys.settingsLanguageSubtitle.key:
              'التبديل بين الإنجليزية والعربية',
          TranslationKeys.settingsThemeTitle.key: 'الوضع الداكن',
          TranslationKeys.settingsThemeSubtitle.key:
              'التبديل بين المظهر الفاتح والداكن',
          TranslationKeys.snackbarDismiss.key: 'إغلاق',
          TranslationKeys.drawerSettings.key: 'الإعدادات',
          TranslationKeys.drawerCreateProduct.key: 'إنشاء منتج',
          TranslationKeys.drawerLogout.key: 'تسجيل الخروج',
          TranslationKeys.appName.key: 'قالب فلاتر',
          TranslationKeys.commonDone.key: 'تم',
          TranslationKeys.productsCreateTitle.key: 'إنشاء منتج',
          TranslationKeys.productsCreateSubtitle.key:
              'املأ التفاصيل أدناه لإضافة منتج جديد.',
          TranslationKeys.productsNameLabel.key: 'الاسم',
          TranslationKeys.productsNameHint.key: 'اسم المنتج',
          TranslationKeys.productsDescriptionLabel.key: 'الوصف',
          TranslationKeys.productsDescriptionHint.key: 'وصف قصير للمنتج',
          TranslationKeys.productsPriceLabel.key: 'السعر',
          TranslationKeys.productsPriceHint.key: '0.00',
          TranslationKeys.productsStockLabel.key: 'المخزون',
          TranslationKeys.productsStockHint.key: '0',
          TranslationKeys.productsCreateSubmit.key: 'إنشاء المنتج',
          TranslationKeys.productsCreateSuccessTitle.key: 'نجاح',
          TranslationKeys.productsCreateSuccessMessage.key:
              'تم إنشاء المنتج بنجاح',
          TranslationKeys.productsCreateErrorMessage.key:
              'فشل إنشاء المنتج. يرجى المحاولة مرة أخرى.',
          TranslationKeys.homeHeadline.key:
              'ذكاء اصطناعي خاص،\nعلى جهازك مباشرة',
          TranslationKeys.homeSubtitle.key:
              'تحدث مع نموذج لغوي صغير يعمل بدون إنترنت بالكامل. لا شيء يغادر هاتفك.',
          TranslationKeys.homeHighlightOffline.key:
              'يعمل بدون إنترنت',
          TranslationKeys.homeHighlightPrivate.key:
              'تبقى رسائلك على هذا الجهاز',
          TranslationKeys.homeHighlightModel.key:
              'مدعوم بنموذج SmolLM2 135M',
          TranslationKeys.homeStartChat.key:
              'ابدأ المحادثة',
          TranslationKeys.chatTitle.key:
              'المحادثة',
          TranslationKeys.chatPreparingModel.key:
              'جارٍ تجهيز النموذج',
          TranslationKeys.chatLoadingModel.key:
              'جارٍ تحميل النموذج في الذاكرة',
          TranslationKeys.chatLoadingHint.key:
              'قد يستغرق هذا بعض الوقت في المرة الأولى.',
          TranslationKeys.chatLoadErrorTitle.key:
              'تعذر تحميل النموذج',
          TranslationKeys.chatRetry.key:
              'حاول مرة أخرى',
          TranslationKeys.chatEmptyTitle.key:
              'اسأل أي شيء',
          TranslationKeys.chatEmptySubtitle.key:
              'النموذج جاهز. اكتب رسالة بالأسفل للحصول على رد.',
          TranslationKeys.chatInputHint.key:
              'اكتب رسالتك',
          TranslationKeys.chatYouLabel.key:
              'أنت',
          TranslationKeys.chatModelLabel.key:
              'SmolLM2',
          TranslationKeys.chatGenerating.key:
              'جارٍ التفكير',
          TranslationKeys.chatGenerationError.key:
              'حدث خطأ أثناء إنشاء الرد.',
        },
      };
}
