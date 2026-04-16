import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @helloworld.
  ///
  /// In en, this message translates to:
  /// **'helloWorld'**
  String get helloworld;

  /// No description provided for @welcomemessage.
  ///
  /// In en, this message translates to:
  /// **'welcomeMessage'**
  String get welcomemessage;

  /// No description provided for @politicaltest.
  ///
  /// In en, this message translates to:
  /// **'Political Test'**
  String get politicaltest;

  /// No description provided for @mainmenudescription.
  ///
  /// In en, this message translates to:
  /// **'Discover your political alignment through interactive quizzes based on the Nolan Test.'**
  String get mainmenudescription;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @starttest.
  ///
  /// In en, this message translates to:
  /// **'Start Test'**
  String get starttest;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @stronglyagree.
  ///
  /// In en, this message translates to:
  /// **'Strongly agree'**
  String get stronglyagree;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get neutral;

  /// No description provided for @disagree.
  ///
  /// In en, this message translates to:
  /// **'Disagree'**
  String get disagree;

  /// No description provided for @stronglydisagree.
  ///
  /// In en, this message translates to:
  /// **'Strongly disagree'**
  String get stronglydisagree;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @mainmenu.
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get mainmenu;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @continuar.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuar;

  /// No description provided for @question1.
  ///
  /// In en, this message translates to:
  /// **'Should the government ban extreme political or religious opinions to maintain social order?'**
  String get question1;

  /// No description provided for @question2.
  ///
  /// In en, this message translates to:
  /// **'Should compulsory military service be abolished and only a professional volunteer army be maintained?'**
  String get question2;

  /// No description provided for @question3.
  ///
  /// In en, this message translates to:
  /// **'Should consensual sexual acts between people of the same sex be legalized without state interference?'**
  String get question3;

  /// No description provided for @question4.
  ///
  /// In en, this message translates to:
  /// **'Should the use and sale of substances (such as marijuana) be permitted under adult responsibility, rather than being a criminal matter?'**
  String get question4;

  /// No description provided for @question5.
  ///
  /// In en, this message translates to:
  /// **'Should the State be entirely secular and not grant privileges or public funds to any religious institution?'**
  String get question5;

  /// No description provided for @question6.
  ///
  /// In en, this message translates to:
  /// **'Should people have the freedom to cross borders and work, as long as they do not have a criminal record?'**
  String get question6;

  /// No description provided for @question7.
  ///
  /// In en, this message translates to:
  /// **'Should taxes be drastically reduced so that people have a larger share of their income available?'**
  String get question7;

  /// No description provided for @question8.
  ///
  /// In en, this message translates to:
  /// **'Should the government reduce social spending and subsidies to balance the budget and lower debt?'**
  String get question8;

  /// No description provided for @question9.
  ///
  /// In en, this message translates to:
  /// **'Should price and wage controls be eliminated so that the market can determine them freely?'**
  String get question9;

  /// No description provided for @question10.
  ///
  /// In en, this message translates to:
  /// **'Should sectors such as mail, electricity, or transport be moved into private hands instead of being managed by the State?'**
  String get question10;

  /// No description provided for @question11.
  ///
  /// In en, this message translates to:
  /// **'Should free trade be allowed without tariffs or quotas that artificially protect national industry?'**
  String get question11;

  /// No description provided for @question12.
  ///
  /// In en, this message translates to:
  /// **'Should charitable organizations and the private sector take over social welfare instead of mandatory government programs?'**
  String get question12;

  /// No description provided for @loading1.
  ///
  /// In en, this message translates to:
  /// **'Executing ideological compatibility analysis…'**
  String get loading1;

  /// No description provided for @loading2.
  ///
  /// In en, this message translates to:
  /// **'Processing political affinity data…'**
  String get loading2;

  /// No description provided for @loading3.
  ///
  /// In en, this message translates to:
  /// **'Mapping your political spectrum…'**
  String get loading3;

  /// No description provided for @loading4.
  ///
  /// In en, this message translates to:
  /// **'Building your thought profile…'**
  String get loading4;

  /// No description provided for @loading5.
  ///
  /// In en, this message translates to:
  /// **'Synchronizing responses with the system…'**
  String get loading5;

  /// No description provided for @loading6.
  ///
  /// In en, this message translates to:
  /// **'Interpreting patterns from your responses…'**
  String get loading6;

  /// No description provided for @loading7.
  ///
  /// In en, this message translates to:
  /// **'Calculating global ideological consistency…'**
  String get loading7;

  /// No description provided for @loading8.
  ///
  /// In en, this message translates to:
  /// **'Evaluating positioning trends…'**
  String get loading8;

  /// No description provided for @loading9.
  ///
  /// In en, this message translates to:
  /// **'Analyzing matches across the political spectrum…'**
  String get loading9;

  /// No description provided for @loading10.
  ///
  /// In en, this message translates to:
  /// **'Generating political affinity map…'**
  String get loading10;

  /// No description provided for @apptitle.
  ///
  /// In en, this message translates to:
  /// **'Your Political Position'**
  String get apptitle;

  /// No description provided for @yourpoliticaltest.
  ///
  /// In en, this message translates to:
  /// **'Your Political Test'**
  String get yourpoliticaltest;

  /// No description provided for @showpoliticians.
  ///
  /// In en, this message translates to:
  /// **'Show politicians'**
  String get showpoliticians;

  /// No description provided for @yourresult.
  ///
  /// In en, this message translates to:
  /// **'Your Result'**
  String get yourresult;

  /// No description provided for @economicorientation.
  ///
  /// In en, this message translates to:
  /// **'Economic Orientation'**
  String get economicorientation;

  /// No description provided for @socialfreedoms.
  ///
  /// In en, this message translates to:
  /// **'Social Freedoms'**
  String get socialfreedoms;

  /// No description provided for @compatibility.
  ///
  /// In en, this message translates to:
  /// **'Compatibility'**
  String get compatibility;

  /// No description provided for @ultraright.
  ///
  /// In en, this message translates to:
  /// **'Far Right'**
  String get ultraright;

  /// No description provided for @right.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get right;

  /// No description provided for @centerright.
  ///
  /// In en, this message translates to:
  /// **'Center-Right'**
  String get centerright;

  /// No description provided for @center.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get center;

  /// No description provided for @centerleft.
  ///
  /// In en, this message translates to:
  /// **'Center-Left'**
  String get centerleft;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get left;

  /// No description provided for @ultraleft.
  ///
  /// In en, this message translates to:
  /// **'Far Left'**
  String get ultraleft;

  /// No description provided for @liberal.
  ///
  /// In en, this message translates to:
  /// **'Liberal'**
  String get liberal;

  /// No description provided for @moderateliberal.
  ///
  /// In en, this message translates to:
  /// **'Moderate Liberal'**
  String get moderateliberal;

  /// No description provided for @authoritarian.
  ///
  /// In en, this message translates to:
  /// **'Authoritarian'**
  String get authoritarian;

  /// No description provided for @moderateauthoritarian.
  ///
  /// In en, this message translates to:
  /// **'Moderate Authoritarian'**
  String get moderateauthoritarian;

  /// No description provided for @economicleft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get economicleft;

  /// No description provided for @economicright.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get economicright;

  /// No description provided for @liberallabel.
  ///
  /// In en, this message translates to:
  /// **'Liberal'**
  String get liberallabel;

  /// No description provided for @authoritarianlabel.
  ///
  /// In en, this message translates to:
  /// **'Authoritarian'**
  String get authoritarianlabel;

  /// No description provided for @shareresults.
  ///
  /// In en, this message translates to:
  /// **'Share Results'**
  String get shareresults;

  /// No description provided for @repeattest.
  ///
  /// In en, this message translates to:
  /// **'Retake Test'**
  String get repeattest;

  /// No description provided for @backhome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backhome;

  /// No description provided for @liberalleft.
  ///
  /// In en, this message translates to:
  /// **'Liberal\nLeft'**
  String get liberalleft;

  /// No description provided for @liberalright.
  ///
  /// In en, this message translates to:
  /// **'Liberal\nRight'**
  String get liberalright;

  /// No description provided for @authoritarianleft.
  ///
  /// In en, this message translates to:
  /// **'Authoritarian\nLeft'**
  String get authoritarianleft;

  /// No description provided for @authoritarianright.
  ///
  /// In en, this message translates to:
  /// **'Authoritarian\nRight'**
  String get authoritarianright;

  /// No description provided for @invalidposition.
  ///
  /// In en, this message translates to:
  /// **'Invalid position'**
  String get invalidposition;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No results in history'**
  String get noHistory;

  /// No description provided for @viewResult.
  ///
  /// In en, this message translates to:
  /// **'View Result'**
  String get viewResult;

  /// No description provided for @economy.
  ///
  /// In en, this message translates to:
  /// **'Economy:'**
  String get economy;

  /// No description provided for @freedom.
  ///
  /// In en, this message translates to:
  /// **'Freedom:'**
  String get freedom;

  /// No description provided for @ultraRight.
  ///
  /// In en, this message translates to:
  /// **'Far Right'**
  String get ultraRight;

  /// No description provided for @centerRight.
  ///
  /// In en, this message translates to:
  /// **'Center-Right'**
  String get centerRight;

  /// No description provided for @centerLeft.
  ///
  /// In en, this message translates to:
  /// **'Center-Left'**
  String get centerLeft;

  /// No description provided for @ultraLeft.
  ///
  /// In en, this message translates to:
  /// **'Far Left'**
  String get ultraLeft;

  /// No description provided for @moderateLiberal.
  ///
  /// In en, this message translates to:
  /// **'Moderate Liberal'**
  String get moderateLiberal;

  /// No description provided for @moderateAuthoritarian.
  ///
  /// In en, this message translates to:
  /// **'Moderate Authoritarian'**
  String get moderateAuthoritarian;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
