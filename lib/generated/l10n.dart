// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `ko`
  String get languageCode {
    return Intl.message(
      'ko',
      name: 'languageCode',
      desc: '',
      args: [],
    );
  }

  /// `こんにちは世界！`
  String get helloworld {
    return Intl.message(
      'こんにちは世界！',
      name: 'helloworld',
      desc: 'プログラミング初心者からの伝統的な挨拶',
      args: [],
    );
  }

  /// `일어나곰`
  String get wakeupgom {
    return Intl.message(
      '일어나곰',
      name: 'wakeupgom',
      desc: '',
      args: [],
    );
  }

  /// `SNS 로그인`
  String get snslogin {
    return Intl.message(
      'SNS 로그인',
      name: 'snslogin',
      desc: '',
      args: [],
    );
  }

  /// `상대 연결`
  String get matchprocess {
    return Intl.message(
      '상대 연결',
      name: 'matchprocess',
      desc: '',
      args: [],
    );
  }

  /// `Apple로 로그인`
  String get applelogin {
    return Intl.message(
      'Apple로 로그인',
      name: 'applelogin',
      desc: '',
      args: [],
    );
  }

  /// `Google로 로그인`
  String get googlelogin {
    return Intl.message(
      'Google로 로그인',
      name: 'googlelogin',
      desc: '',
      args: [],
    );
  }

  /// `Email로 로그인`
  String get emaillogin {
    return Intl.message(
      'Email로 로그인',
      name: 'emaillogin',
      desc: '',
      args: [],
    );
  }

  /// `서로의 초대코드를 입력하면 연결돼요.`
  String get codewritematch {
    return Intl.message(
      '서로의 초대코드를 입력하면 연결돼요.',
      name: 'codewritematch',
      desc: '',
      args: [],
    );
  }

  /// `편지를 쓰고, 알람을 설정하고, \n아침에 편지를 확인해보세요.`
  String get writealarmcheck {
    return Intl.message(
      '편지를 쓰고, 알람을 설정하고, \n아침에 편지를 확인해보세요.',
      name: 'writealarmcheck',
      desc: '',
      args: [],
    );
  }

  /// `내 초대코드 (1시간 유효) `
  String get mycode1hour {
    return Intl.message(
      '내 초대코드 (1시간 유효) ',
      name: 'mycode1hour',
      desc: '',
      args: [],
    );
  }

  /// `상대의 초대코드를 전달받았나요?`
  String get writeothercode {
    return Intl.message(
      '상대의 초대코드를 전달받았나요?',
      name: 'writeothercode',
      desc: '',
      args: [],
    );
  }

  /// `일어나곰 알람`
  String get wakeupgomalarm {
    return Intl.message(
      '일어나곰 알람',
      name: 'wakeupgomalarm',
      desc: '',
      args: [],
    );
  }

  /// `알람이 울리고 있어요! 편지를 확인해보세요!`
  String get alarmringletter {
    return Intl.message(
      '알람이 울리고 있어요! 편지를 확인해보세요!',
      name: 'alarmringletter',
      desc: '',
      args: [],
    );
  }

  /// `알람 삭제`
  String get deletealarm {
    return Intl.message(
      '알람 삭제',
      name: 'deletealarm',
      desc: '',
      args: [],
    );
  }

  /// `편지가 없어요...`
  String get noletter {
    return Intl.message(
      '편지가 없어요...',
      name: 'noletter',
      desc: '',
      args: [],
    );
  }

  /// `과거는 지울 수 없어요.`
  String get nodeletepast {
    return Intl.message(
      '과거는 지울 수 없어요.',
      name: 'nodeletepast',
      desc: '',
      args: [],
    );
  }

  /// `삭제`
  String get delete {
    return Intl.message(
      '삭제',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `삭제했습니다.`
  String get deleted {
    return Intl.message(
      '삭제했습니다.',
      name: 'deleted',
      desc: '',
      args: [],
    );
  }

  /// `수정`
  String get edit {
    return Intl.message(
      '수정',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `사용자를 찾을 수 없어요 \n 다시 접속해주세요.`
  String get erroruser {
    return Intl.message(
      '사용자를 찾을 수 없어요 \n 다시 접속해주세요.',
      name: 'erroruser',
      desc: '',
      args: [],
    );
  }

  /// `내용을 적어주세요`
  String get putsometext {
    return Intl.message(
      '내용을 적어주세요',
      name: 'putsometext',
      desc: '',
      args: [],
    );
  }

  /// `메세지가 수정되었습니다.`
  String get letteredited {
    return Intl.message(
      '메세지가 수정되었습니다.',
      name: 'letteredited',
      desc: '',
      args: [],
    );
  }

  /// `편지는 내일부터 쓸 수 있어요`
  String get writetomorrow {
    return Intl.message(
      '편지는 내일부터 쓸 수 있어요',
      name: 'writetomorrow',
      desc: '',
      args: [],
    );
  }

  /// `이미 편지를 썼어요`
  String get alreadywrite {
    return Intl.message(
      '이미 편지를 썼어요',
      name: 'alreadywrite',
      desc: '',
      args: [],
    );
  }

  /// `어떤 날에 편지를 쓸까요?`
  String get whenwrite {
    return Intl.message(
      '어떤 날에 편지를 쓸까요?',
      name: 'whenwrite',
      desc: '',
      args: [],
    );
  }

  /// `날짜를 누르면 편지를 쓸 수 있어요`
  String get datetowrite {
    return Intl.message(
      '날짜를 누르면 편지를 쓸 수 있어요',
      name: 'datetowrite',
      desc: '',
      args: [],
    );
  }

  /// `깨워 볼까요?`
  String get wakeupletter {
    return Intl.message(
      '깨워 볼까요?',
      name: 'wakeupletter',
      desc: '',
      args: [],
    );
  }

  /// `저장 중입니다.`
  String get saving {
    return Intl.message(
      '저장 중입니다.',
      name: 'saving',
      desc: '',
      args: [],
    );
  }

  /// `저장했습니다.`
  String get saved {
    return Intl.message(
      '저장했습니다.',
      name: 'saved',
      desc: '',
      args: [],
    );
  }

  /// `보내기`
  String get lettersave {
    return Intl.message(
      '보내기',
      name: 'lettersave',
      desc: '',
      args: [],
    );
  }

  /// `사진 첨부하기`
  String get selectimage {
    return Intl.message(
      '사진 첨부하기',
      name: 'selectimage',
      desc: '',
      args: [],
    );
  }

  /// `이미지 줄이기`
  String get crop {
    return Intl.message(
      '이미지 줄이기',
      name: 'crop',
      desc: '',
      args: [],
    );
  }

  /// `프로필 편집`
  String get editprofile {
    return Intl.message(
      '프로필 편집',
      name: 'editprofile',
      desc: '',
      args: [],
    );
  }

  /// `오전 hh시 mm분 이후`
  String get afterwakeup {
    return Intl.message(
      '오전 hh시 mm분 이후',
      name: 'afterwakeup',
      desc: '',
      args: [],
    );
  }

  /// `이름`
  String get name {
    return Intl.message(
      '이름',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `생일`
  String get birthday {
    return Intl.message(
      '생일',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `성별`
  String get gender {
    return Intl.message(
      '성별',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `남자`
  String get male {
    return Intl.message(
      '남자',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `여자`
  String get female {
    return Intl.message(
      '여자',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `내 계정 정보`
  String get myaccount {
    return Intl.message(
      '내 계정 정보',
      name: 'myaccount',
      desc: '',
      args: [],
    );
  }

  /// `상대 계정 정보`
  String get coupleaccount {
    return Intl.message(
      '상대 계정 정보',
      name: 'coupleaccount',
      desc: '',
      args: [],
    );
  }

  /// `편지 확인 가능 시간`
  String get wakeuptime {
    return Intl.message(
      '편지 확인 가능 시간',
      name: 'wakeuptime',
      desc: '',
      args: [],
    );
  }

  /// `고객센터`
  String get cscenter {
    return Intl.message(
      '고객센터',
      name: 'cscenter',
      desc: '',
      args: [],
    );
  }

  /// `앱 소개`
  String get appintro {
    return Intl.message(
      '앱 소개',
      name: 'appintro',
      desc: '',
      args: [],
    );
  }

  /// `앱 버전 정보`
  String get appversion {
    return Intl.message(
      '앱 버전 정보',
      name: 'appversion',
      desc: '',
      args: [],
    );
  }

  /// `개인정보처리방침`
  String get inforule {
    return Intl.message(
      '개인정보처리방침',
      name: 'inforule',
      desc: '',
      args: [],
    );
  }

  /// `알람`
  String get alarm {
    return Intl.message(
      '알람',
      name: 'alarm',
      desc: '',
      args: [],
    );
  }

  /// `피드`
  String get feed {
    return Intl.message(
      '피드',
      name: 'feed',
      desc: '',
      args: [],
    );
  }

  /// `편지쓰기`
  String get write {
    return Intl.message(
      '편지쓰기',
      name: 'write',
      desc: '',
      args: [],
    );
  }

  /// `프로필`
  String get profile {
    return Intl.message(
      '프로필',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `알람`
  String get alarms {
    return Intl.message(
      '알람',
      name: 'alarms',
      desc: '',
      args: [],
    );
  }

  /// `저장`
  String get save {
    return Intl.message(
      '저장',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `취소`
  String get cancel {
    return Intl.message(
      '취소',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `내 편지`
  String get myletters {
    return Intl.message(
      '내 편지',
      name: 'myletters',
      desc: '',
      args: [],
    );
  }

  /// `받은 답장`
  String get answers {
    return Intl.message(
      '받은 답장',
      name: 'answers',
      desc: '',
      args: [],
    );
  }

  /// `내 답장`
  String get myanswers {
    return Intl.message(
      '내 답장',
      name: 'myanswers',
      desc: '',
      args: [],
    );
  }

  /// `기본 편지`
  String get dafaultletter {
    return Intl.message(
      '기본 편지',
      name: 'dafaultletter',
      desc: '',
      args: [],
    );
  }

  /// `편지`
  String get letter {
    return Intl.message(
      '편지',
      name: 'letter',
      desc: '',
      args: [],
    );
  }

  /// `음악 반복`
  String get loopalarmaudio {
    return Intl.message(
      '음악 반복',
      name: 'loopalarmaudio',
      desc: '',
      args: [],
    );
  }

  /// `진동`
  String get vibrate {
    return Intl.message(
      '진동',
      name: 'vibrate',
      desc: '',
      args: [],
    );
  }

  /// `음량`
  String get customvolume {
    return Intl.message(
      '음량',
      name: 'customvolume',
      desc: '',
      args: [],
    );
  }

  /// `음악`
  String get sound {
    return Intl.message(
      '음악',
      name: 'sound',
      desc: '',
      args: [],
    );
  }

  /// `로그아웃`
  String get logout {
    return Intl.message(
      '로그아웃',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `예`
  String get yes {
    return Intl.message(
      '예',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `아니요`
  String get no {
    return Intl.message(
      '아니요',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `알람이 없어요`
  String get noalarmset {
    return Intl.message(
      '알람이 없어요',
      name: 'noalarmset',
      desc: '',
      args: [],
    );
  }

  /// `정말 로그아웃할거에요?`
  String get sure {
    return Intl.message(
      '정말 로그아웃할거에요?',
      name: 'sure',
      desc: '',
      args: [],
    );
  }

  /// `계정 서로 연결하기`
  String get connectto {
    return Intl.message(
      '계정 서로 연결하기',
      name: 'connectto',
      desc: '',
      args: [],
    );
  }

  /// `초대 코드로 연결하기`
  String get connectwith {
    return Intl.message(
      '초대 코드로 연결하기',
      name: 'connectwith',
      desc: '',
      args: [],
    );
  }

  /// `연결`
  String get match {
    return Intl.message(
      '연결',
      name: 'match',
      desc: '',
      args: [],
    );
  }

  /// `초대 코드 생성`
  String get generateauthcode {
    return Intl.message(
      '초대 코드 생성',
      name: 'generateauthcode',
      desc: '',
      args: [],
    );
  }

  /// `돌아가서 초대 코드 입력하기`
  String get backtowrite {
    return Intl.message(
      '돌아가서 초대 코드 입력하기',
      name: 'backtowrite',
      desc: '',
      args: [],
    );
  }

  /// `초대 코드 보기`
  String get viewcode {
    return Intl.message(
      '초대 코드 보기',
      name: 'viewcode',
      desc: '',
      args: [],
    );
  }

  /// `안녕`
  String get hello {
    return Intl.message(
      '안녕',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `좋은 아침이야`
  String get goodmorning {
    return Intl.message(
      '좋은 아침이야',
      name: 'goodmorning',
      desc: '',
      args: [],
    );
  }

  /// `자기야 일어나`
  String get honeywakeup {
    return Intl.message(
      '자기야 일어나',
      name: 'honeywakeup',
      desc: '',
      args: [],
    );
  }

  /// `편지 쓸래?`
  String get writealetter {
    return Intl.message(
      '편지 쓸래?',
      name: 'writealetter',
      desc: '',
      args: [],
    );
  }

  /// `사진 보내봐`
  String get sendaphoto {
    return Intl.message(
      '사진 보내봐',
      name: 'sendaphoto',
      desc: '',
      args: [],
    );
  }

  /// `아침에 편지 확인해봐`
  String get checktheletter {
    return Intl.message(
      '아침에 편지 확인해봐',
      name: 'checktheletter',
      desc: '',
      args: [],
    );
  }

  /// `사진 확인해봐`
  String get watchthephoto {
    return Intl.message(
      '사진 확인해봐',
      name: 'watchthephoto',
      desc: '',
      args: [],
    );
  }

  /// `답장해줄래?`
  String get replyletter {
    return Intl.message(
      '답장해줄래?',
      name: 'replyletter',
      desc: '',
      args: [],
    );
  }

  /// `아침에 답장해줄래?`
  String get canyoureply {
    return Intl.message(
      '아침에 답장해줄래?',
      name: 'canyoureply',
      desc: '',
      args: [],
    );
  }

  /// `아침 편지 써줄래?`
  String get writemorning {
    return Intl.message(
      '아침 편지 써줄래?',
      name: 'writemorning',
      desc: '',
      args: [],
    );
  }

  /// `잘 지내?`
  String get howareyou {
    return Intl.message(
      '잘 지내?',
      name: 'howareyou',
      desc: '',
      args: [],
    );
  }

  /// `보고싶어`
  String get imissyou {
    return Intl.message(
      '보고싶어',
      name: 'imissyou',
      desc: '',
      args: [],
    );
  }

  /// `피드백 보내기`
  String get feedback {
    return Intl.message(
      '피드백 보내기',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `계정 삭제`
  String get deleteaccount {
    return Intl.message(
      '계정 삭제',
      name: 'deleteaccount',
      desc: '',
      args: [],
    );
  }

  /// `상대와 연결 끊기`
  String get breakup {
    return Intl.message(
      '상대와 연결 끊기',
      name: 'breakup',
      desc: '',
      args: [],
    );
  }

  /// `계정의 모든 정보가 삭제됩니다. 복구 불가능하게 삭제하실건가요?`
  String get deletesure {
    return Intl.message(
      '계정의 모든 정보가 삭제됩니다. 복구 불가능하게 삭제하실건가요?',
      name: 'deletesure',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'cn'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'my'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
