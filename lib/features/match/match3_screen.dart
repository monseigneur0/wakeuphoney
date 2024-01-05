import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/loader.dart';
import '../../core/constants/design_constants.dart';
import '../../widgets/drawer.dart';
import 'match_controller.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:weekday_selector/weekday_selector.dart';

//달력
class Match3Screen extends ConsumerStatefulWidget {
  static String routeName = "Match3screen";
  static String routeURL = "/match3";
  const Match3Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Match3ScreenState();
}

class _Match3ScreenState extends ConsumerState<Match3Screen> {
  var logger = Logger();

  List<Locale> locales = [];

  @override
  Widget build(BuildContext context) {
    const title = 'Weekday Selector Example';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: bottomSelectedIndex,
          onTap: onBottomNavigationBarTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Usage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flag),
              label: 'i18n',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit),
              label: 'Styles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.send),
              label: 'Forms',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              label: 'Animated',
            ),
          ],
        ),
        appBar: AppBar(title: const Text(title)),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: const <Widget>[
            UsageExamples(),
            I18nExamples(),
            StylesExamples(),
            FormsExamples(),
            AnimatedExamples(),
          ],
        ),
      ),
      supportedLocales: locales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }

  @override
  void initState() {
    // In the example app, we want to mark every locale that the `intl` package
    // support as supported so that you can test the weekday selector quickly,
    // so we just convert intl symbols to locales, but in your app, it is
    // very likely that you would want something else.
    // Learn more about internationalization here:
    // https://flutter.dev/docs/development/accessibility-and-localization/internationalization
    locales = dateTimeSymbolMap()
        .keys
        .cast<String>()
        .map((String k) => Locale(
            k.split('_')[0], k.split('_').length > 1 ? k.split('_')[1] : null))
        .toList();
    super.initState();
  }

  final pageController = PageController(initialPage: 0, keepPage: true);

  int bottomSelectedIndex = 0;

  void onPageChanged(int index) {
    setState(() => bottomSelectedIndex = index);
  }

  void onBottomNavigationBarTap(int index) {
    bottomSelectedIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }
}

class UsageExamples extends StatelessWidget {
  const UsageExamples({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    final examples = <Widget>[
      const SimpleExampleWeekendsStatic(),
      const SelectedDaysUpdateExample(),
      const DisabledExample(),
      const DisplayedDaysExample(),
      // TODO: use with setstate
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemBuilder: (_, index) => examples[index],
      itemCount: examples.length,
    );
  }
}

class I18nExamples extends StatelessWidget {
  const I18nExamples({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <Widget>[
      const CurrentLocaleExample(),
      const CustomWeekdaysTexts(),
      const ShortAndNarrowGermanExample(),
      const RegionMattersSpanishExample(),
      const FirstDayOfWeekExample(),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemBuilder: (_, index) => examples[index],
      itemCount: examples.length,
    );
  }
}

class StylesExamples extends StatelessWidget {
  const StylesExamples({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <Widget>[
      const SaneDefaultThemeExample(),
      const ElevationExample(),
      const SimpleShapesExample(),
      const CustomShapesExample(),
      const InheritedThemeExample(),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemBuilder: (_, index) => examples[index],
      itemCount: examples.length,
    );
  }
}

class FormsExamples extends StatelessWidget {
  const FormsExamples({super.key});

  @override
  Widget build(BuildContext context) {
    // No forms supprt yet, but it would come here.
    final examples = <Widget>[];
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemBuilder: (_, index) => examples[index],
      itemCount: examples.length,
    );
  }
}

class AnimatedExamples extends StatelessWidget {
  const AnimatedExamples({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <Widget>[];
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemBuilder: (_, index) => examples[index],
      itemCount: examples.length,
    );
  }
}

/// Print the integer value of the day and the day that it corresponds to in English.
///
/// It's added to the example so that you can always see and verify that the
/// code is correct.
printIntAsDay(int day) {
  print('Received integer: $day. Corresponds to day: ${intDayToEnglish(day)}');
}

String intDayToEnglish(int day) {
  if (day % 7 == DateTime.monday % 7) return 'Monday';
  if (day % 7 == DateTime.tuesday % 7) return 'Tueday';
  if (day % 7 == DateTime.wednesday % 7) return 'Wednesday';
  if (day % 7 == DateTime.thursday % 7) return 'Thursday';
  if (day % 7 == DateTime.friday % 7) return 'Friday';
  if (day % 7 == DateTime.saturday % 7) return 'Saturday';
  if (day % 7 == DateTime.sunday % 7) return 'Sunday';
  throw '🐞 This should never have happened: $day';
}

class ExampleTitle extends StatelessWidget {
  final String title;

  const ExampleTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

/// [SimpleExampleWeekendsStatic] shows how to pass initial values to the
/// [WeekdaySelector] widget and demonstrates how the `onChanged`
/// callback works.
class SimpleExampleWeekendsStatic extends StatefulWidget {
  const SimpleExampleWeekendsStatic({super.key});

  @override
  _SimpleExampleWeekendsStaticState createState() =>
      _SimpleExampleWeekendsStaticState();
}

class _SimpleExampleWeekendsStaticState
    extends State<SimpleExampleWeekendsStatic> {
  int? lastTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('onChanged callback'),
        const Text(
            'The selected days are Saturday and Sunday. The onChanged function will be called with the index of the day that the user has tapped on.'),
        const Text(
            'It is up to the user of this library to handle the taps and keep track of the changes'),
        const Text(
            'In accordance with ISO 8601 a week starts with Monday, which has the value of 1. Sunday == 7'),
        Text(
          lastTapped == null
              ? 'onChanged callback was not yet called'
              : 'onChanged callback was last called with $lastTapped',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        WeekdaySelector(
          // We display the last tapped value in the example app
          onChanged: (v) {
            printIntAsDay(v);
            setState(() => lastTapped = v);
          },
          values: const [
            true, // Sunday
            false, // Monday
            false, // Tuesday
            false, // Wednesday
            false, // Thursday
            false, // Friday
            true, // Saturday
          ],
        ),
      ],
    );
  }
}

class DisabledExample extends StatefulWidget {
  const DisabledExample({super.key});

  @override
  _DisabledExampleState createState() => _DisabledExampleState();
}

class _DisabledExampleState extends State<DisabledExample> {
  final values = <bool?>[null, false, true, false, true, false, null];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('Disabled days'),
        const Text(
            'The package also supports disabled days. Maybe, you want to prevent users from selecting weekends. Just use "null".'),
        // Using v == true, as some values could be null!
        Text(
            'The days that are currently selected are: ${valuesToEnglishDays(values, true)}. The following days are disabled: ${valuesToEnglishDays(values, null)}'),
        WeekdaySelector(
          selectedFillColor: Colors.indigo,
          onChanged: (v) {
            printIntAsDay(v);
            setState(() {
              values[v % 7] = !values[v % 7]!;
            });
          },
          values: values,
        ),
      ],
    );
  }
}

class SelectedDaysUpdateExample extends StatefulWidget {
  const SelectedDaysUpdateExample({super.key});

  @override
  _SelectedDaysUpdateExampleState createState() =>
      _SelectedDaysUpdateExampleState();
}

class _SelectedDaysUpdateExampleState extends State<SelectedDaysUpdateExample> {
  final values = List.filled(7, false);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('Stateful widget with selected days'),
        const Text(
            'When the user taps on a day, toggle the state! You can use stateful widgets, or any other methods for managing your state.'),
        // Using v == true, as some values could be null!
        Text(
            'The days that are currently selected are: ${valuesToEnglishDays(values, true)}.'),
        WeekdaySelector(
          selectedFillColor: Colors.indigo,
          onChanged: (v) {
            printIntAsDay(v);
            setState(() {
              values[v % 7] = !values[v % 7];
            });
          },
          values: values,
        ),
      ],
    );
  }
}

class DisplayedDaysExample extends StatefulWidget {
  const DisplayedDaysExample({super.key});

  @override
  _DisplayedDaysExampleState createState() => _DisplayedDaysExampleState();
}

class _DisplayedDaysExampleState extends State<DisplayedDaysExample> {
  final values = List.filled(7, false);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('Displayed days'),
        const Text(
          'You can select which days you want to display to your users. '
          'Though this makes the weekday selector more difficult to understand, '
          'for some use-cases, it can be a good option to consider: if your app '
          'lets teachers select weekdays, then maybe you do not need to display '
          'the days of the weekend?',
        ),
        Text(
          'The days that are currently selected are: '
          '${valuesToEnglishDays(values, true)}.',
        ),
        WeekdaySelector(
          // Just some days you want to display to your users.
          displayedDays: const {
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
          },
          onChanged: (v) {
            printIntAsDay(v);
            setState(() {
              values[v % 7] = !values[v % 7];
            });
          },
          values: values,
        ),
      ],
    );
  }
}

String valuesToEnglishDays(List<bool?> values, bool? searchedValue) {
  final days = <String>[];
  for (int i = 0; i < values.length; i++) {
    final v = values[i];
    // Use v == true, as the value could be null, as well (disabled days).
    if (v == searchedValue) days.add(intDayToEnglish(i));
  }
  if (days.isEmpty) return 'NONE';
  return days.join(', ');
}

class ElevationExample extends StatefulWidget {
  const ElevationExample({super.key});

  @override
  _ElevationExampleState createState() => _ElevationExampleState();
}

class _ElevationExampleState extends State<ElevationExample> {
  final values = <bool?>[null, false, true, false, true, false, null];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('Elevation'),
        const Text('We support custom elevations, too!'),
        WeekdaySelector(
          selectedFillColor: Colors.indigo.shade300,
          onChanged: (v) {
            printIntAsDay(v);
            setState(() {
              values[v % 7] = !values[v % 7]!;
            });
          },
          selectedElevation: 15,
          elevation: 5,
          disabledElevation: 0,
          values: values,
        ),
      ],
    );
  }
}

class CurrentLocaleExample extends StatefulWidget {
  const CurrentLocaleExample({super.key});

  @override
  _CurrentLocaleExampleState createState() => _CurrentLocaleExampleState();
}

class _CurrentLocaleExampleState extends State<CurrentLocaleExample> {
  final values = <bool?>[
    true,
    true,
    true,
    false,
    false,
    false,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: This example should be simpler!
    // TODO: it should work somewhat like this:
    // initializeDateFormatting...
    // final dateSymbols = DateFormat().dateSymbols;
    final locale = Localizations.localeOf(context);
    final DateSymbols dateSymbols = dateTimeSymbolMap()['$locale'];
    final textDirection = getTextDirection(locale);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ExampleTitle(
            'Current locale: $locale (${textDirection == TextDirection.rtl ? "RTL" : "LTR"})'),
        const Text(
            'The WeekdaySelector is built to support multiple languages, locales in one application.'),
        const Text(
          'Just pass the WeekdaySelector the "weekdays", "shortWeekdays", and "firstDayOfWeek" parameters. '
          'You can use the intl package to get these parameters.',
        ),
        Text(
            'The selector below will automatically use your current language.\nCurrently selected: ${valuesToEnglishDays(values, true)}.\nDisabled: ${valuesToEnglishDays(values, null)}.'),
        WeekdaySelector(
          onChanged: (v) {
            printIntAsDay(v);
            setState(() {
              values[v % 7] = !values[v % 7]!;
            });
          },
          values: values,
          // intl package uses 0 for Monday, but DateTime uses 1 for Monday,
          // so we need to make sure the values match
          firstDayOfWeek: dateSymbols.FIRSTDAYOFWEEK + 1,
          shortWeekdays: dateSymbols.STANDALONENARROWWEEKDAYS,
          weekdays: dateSymbols.STANDALONEWEEKDAYS,
          textDirection: textDirection,
        ),
      ],
    );
  }
}

TextDirection getTextDirection(Locale locale) {
  // See GlobalWidgetsLocalizations
  // TODO: there must be a better way to figure out whether a locale is RTL or LTR
  const rtlLanguages = ['ar', 'fa', 'he', 'ps', 'sd', 'ur'];
  return rtlLanguages.contains(locale.languageCode)
      ? TextDirection.rtl
      : TextDirection.ltr;
}

class FirstDayOfWeekDateTime extends StatelessWidget {
  const FirstDayOfWeekDateTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
            'Use the "firstDayOfWeek" property to change which day is the first day of the week.'),
        const Text('Starting with Monday'),
        WeekdaySelector(
          onChanged: print,
          values: valuesSaturdaySunday,
          firstDayOfWeek: DateTime.monday,
        ),
        const Text('Starting with Sunday'),
        WeekdaySelector(
          onChanged: print,
          values: valuesSaturdaySunday,
          firstDayOfWeek: DateTime.sunday,
        ),
        const Text('Starting with Saturday'),
        WeekdaySelector(
          onChanged: print,
          values: valuesSaturdaySunday,
          firstDayOfWeek: DateTime.saturday,
        ),
      ],
    );
  }
}

class CustomWeekdaysTexts extends StatelessWidget {
  const CustomWeekdaysTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('Customizable day tags'),
        const Text(
            'In case you need to support only a couple of languages or for some reason, or you disagree with the labels from the intl package, you can set the days to any strings. In this example, I used emojis to represent days, so for example "😎" is for Sunday.'),
        WeekdaySelector(
          // We display the last tapped value in the example app
          onChanged: printIntAsDay,
          values: valuesSaturdaySunday,
          shortWeekdays: const [
            '😎', // Sunday
            '🌚', // MOONday
            '👽', // https://en.wikipedia.org/wiki/Names_of_the_days_of_the_week
            '🙂', // I ran out of ideas...
            '🍺', // Thirst-day
            '🍻', // It's Friday, Friday, Gotta get down on Friday!
            '🆓', // Everybody's lookin' forward to the weekend, weekend
          ],
        ),
      ],
    );
  }
}

class ShortAndNarrowGermanExample extends StatelessWidget {
  const ShortAndNarrowGermanExample({super.key});

  @override
  Widget build(BuildContext context) {
    final DateSymbols de = dateTimeSymbolMap()['de'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('Narrow and Short weekdays'),
        const Text(
            'Use of the intl package is recommended in case you need to support multiple languages. This example is using the German "short" weekdays.'),
        WeekdaySelector(
          // We display the last tapped value in the example app
          onChanged: printIntAsDay,
          values: List.filled(7, true),
          weekdays: de.STANDALONEWEEKDAYS,
          shortWeekdays: de.STANDALONESHORTWEEKDAYS,
          firstDayOfWeek: de.FIRSTDAYOFWEEK + 1,
        ),
        const Text(
            'This example is using the German "short" weekdays. Use the narrow weekdays if you want a *really short* version of the weekdays.'),
        WeekdaySelector(
          onChanged: printIntAsDay,
          values: List.filled(7, true),
          weekdays: de.STANDALONEWEEKDAYS,
          shortWeekdays: de.STANDALONENARROWWEEKDAYS,
          firstDayOfWeek: de.FIRSTDAYOFWEEK + 1,
        ),
      ],
    );
  }
}

class RegionMattersSpanishExample extends StatelessWidget {
  const RegionMattersSpanishExample({super.key});

  @override
  Widget build(BuildContext context) {
    final DateSymbols mx = dateTimeSymbolMap()['es_MX'];
    final DateSymbols es = dateTimeSymbolMap()['es_ES'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('Country code matters'),
        const Text(
            'The same language from two different countries might use different abbreviations for the weekdays or might start the week with a different value.\n\nIn this example, we used "es_MX" and "es_ES" that correspond to Mexico and Spain. In Mexico, miércoles is abbreviated to M, in Spain, it is X. In Mexico, weeks start with Saturday, and in Spain they start with Sunday.\n\nSaturday and Sunday are the selected days.'),
        WeekdaySelector(
          onChanged: printIntAsDay,
          values: valuesSaturdaySunday,
          weekdays: mx.STANDALONEWEEKDAYS,
          shortWeekdays: mx.STANDALONENARROWWEEKDAYS,
          firstDayOfWeek: mx.FIRSTDAYOFWEEK + 1,
        ),
        WeekdaySelector(
          onChanged: printIntAsDay,
          values: valuesSaturdaySunday,
          weekdays: es.STANDALONEWEEKDAYS,
          shortWeekdays: es.STANDALONENARROWWEEKDAYS,
          firstDayOfWeek: es.FIRSTDAYOFWEEK + 1,
        ),
      ],
    );
  }
}

const x = DateTime.monday;

const valuesSundayTuesdayThursday = <bool>[
  true,
  false,
  true,
  false,
  true,
  false,
  false,
];

const valuesSaturdaySunday = <bool>[
  // Sunday
  true,
  // Monday-Friday
  false,
  false,
  false,
  false,
  false,
  // Saturday
  true,
];

class SaneDefaultThemeExample extends StatefulWidget {
  const SaneDefaultThemeExample({super.key});

  @override
  _SaneDefaultThemeExampleState createState() =>
      _SaneDefaultThemeExampleState();
}

class _SaneDefaultThemeExampleState extends State<SaneDefaultThemeExample> {
  final values = <bool?>[null, null, true, true, false, false, true];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('Sane defaults'),
        const Text(
            'The colors will be picked based on your current theme, so the weekday selector will match your theme without you having to set every color on your own.'),
        const Text(
            'Notice how the colors of the picked days will match the material theme of your app!'),
        WeekdaySelector(
          onChanged: (v) {
            printIntAsDay(v);
            setState(() {
              values[v % 7] = !values[v % 7]!;
            });
          },
          values: values,
        ),
      ],
    );
  }
}

class SimpleShapesExample extends StatefulWidget {
  const SimpleShapesExample({super.key});

  @override
  _SimpleShapesExampleState createState() => _SimpleShapesExampleState();
}

class _SimpleShapesExampleState extends State<SimpleShapesExample> {
  final values = <bool?>[null, false, true, false, true, false, null];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('Shapes'),
        const Text(
            'You can customize the shape of the weekday selector buttons via the "shape", "selectedShape", and "disabledShape" parameters.'),
        WeekdaySelector(
          onChanged: (v) {
            printIntAsDay(v);
            setState(() {
              values[v % 7] = !values[v % 7]!;
            });
          },
          values: values,
          selectedFillColor: Colors.amber,
          selectedColor: Colors.black,
          selectedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.red.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ],
    );
  }
}

class CustomShapesExample extends StatefulWidget {
  const CustomShapesExample({super.key});

  @override
  _CustomShapesExampleState createState() => _CustomShapesExampleState();
}

class _CustomShapesExampleState extends State<CustomShapesExample> {
  final values = <bool?>[null, false, true, false, true, false, null];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('Shapes: Any ShapeBorder works'),
        const Text(
            'Any "ShapeBorder" will do, and you can set the selected, enabled, and disabled shapes differently'),
        WeekdaySelector(
          onChanged: (v) {
            printIntAsDay(v);
            setState(() {
              values[v % 7] = !values[v % 7]!;
            });
          },
          values: values,
          selectedFillColor: Colors.amber,
          selectedTextStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textStyle: const TextStyle(color: Colors.black),
          selectedShape: const BeveledRectangleBorder(
            side: BorderSide(color: Colors.black, width: 4),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          shape: const BeveledRectangleBorder(
            side: BorderSide(color: Colors.green, width: 2),
            borderRadius: BorderRadius.all(
              Radius.elliptical(100, 10),
            ),
          ),
          disabledShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          disabledFillColor: Colors.black45,
          disabledColor: Colors.yellowAccent,
        ),
      ],
    );
  }
}

class InheritedThemeExample extends StatelessWidget {
  const InheritedThemeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return WeekdaySelectorTheme(
      data: WeekdaySelectorThemeData(
        color: Colors.red,
        fillColor: Colors.white70,
        selectedFillColor: Colors.red,
        // Warning: text style overwrites this!
        selectedColor: Colors.black,
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          // Beautiful!
          decoration: TextDecoration.overline,
          decorationColor: Colors.black,
          decorationThickness: 4,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ExampleTitle('WeekdaySelectorTheme'),
          const Text(
            'The package also has its own theme widget: "WeekdaySelectorTheme". '
            'This theme is an inherited theme and you can control the appearance of all descendant weekday selectors. '
            'You can still overwrite the theme by passing values directly to the widget.',
          ),
          WeekdaySelector(
            onChanged: printIntAsDay,
            values: List.filled(7, true),
          ),
          const Text(
              'You can still overwrite every value! Let\'s make it green by passing the "selectedFillColor" value!'),
          WeekdaySelector(
            onChanged: printIntAsDay,
            values: List.filled(7, true),
            // Overwrites the theme.
            selectedFillColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

/// Demo how to change the first day of week.
class FirstDayOfWeekExample extends StatelessWidget {
  const FirstDayOfWeekExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ExampleTitle('First day of week'),
        const Text(
            'The first day of the week changes from country to country. You can use the "first day of week" parameter to configure this value.'),
        const Text('If firstDayOfWeek is omitted, Monday is used.'),
        WeekdaySelector(
          onChanged: printIntAsDay,
          values: valuesSundayTuesdayThursday,
        ),
        const Text('First day is Sunday:'),
        WeekdaySelector(
          onChanged: printIntAsDay,
          values: valuesSundayTuesdayThursday,
          firstDayOfWeek: DateTime.sunday,
        ),
        const Text('First day is Thursday:'),
        WeekdaySelector(
          onChanged: printIntAsDay,
          values: valuesSundayTuesdayThursday,
          firstDayOfWeek: DateTime.thursday,
        ),
      ],
    );
  }
}

const monday = DateTime.monday;
