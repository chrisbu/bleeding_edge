// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * Tests the DateFormat library in dart. This file contains core tests that
 * are run regardless of where the locale data is found, so it doesn't expect to
 * be run on its own, but rather to be imported and run from another test file.
 */

#library('date_time_format_tests');

#import('../lib/date_format.dart');
#import('../../../pkg/unittest/unittest.dart');
#import('date_time_format_test_data.dart');
#import('../lib/intl.dart');
#import('../lib/src/date_format_internal.dart');

var formatsToTest = const [
  DateFormat.DAY,
  DateFormat.ABBR_WEEKDAY,
  DateFormat.WEEKDAY,
  DateFormat.ABBR_STANDALONE_MONTH,
  DateFormat.STANDALONE_MONTH,
  DateFormat.NUM_MONTH,
  DateFormat.NUM_MONTH_DAY,
  DateFormat.NUM_MONTH_WEEKDAY_DAY,
  DateFormat.ABBR_MONTH,
  DateFormat.ABBR_MONTH_DAY,
  DateFormat.ABBR_MONTH_WEEKDAY_DAY,
  DateFormat.MONTH,
  DateFormat.MONTH_DAY,
  DateFormat.MONTH_WEEKDAY_DAY,
  DateFormat.ABBR_QUARTER,
  DateFormat.QUARTER,
  DateFormat.YEAR,
  DateFormat.YEAR_NUM_MONTH,
  DateFormat.YEAR_NUM_MONTH_DAY,
  DateFormat.YEAR_NUM_MONTH_WEEKDAY_DAY,
  DateFormat.YEAR_ABBR_MONTH,
  DateFormat.YEAR_ABBR_MONTH_DAY,
  DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY,
  DateFormat.YEAR_MONTH,
  DateFormat.YEAR_MONTH_DAY,
  DateFormat.YEAR_MONTH_WEEKDAY_DAY,
  // TODO(alanknight): CLDR and ICU appear to disagree on these for Japanese
  //    DateFormat.YEAR_ABBR_QUARTER,
  //    DateFormat.YEAR_QUARTER,
  DateFormat.HOUR24,
  DateFormat.HOUR24_MINUTE,
  DateFormat.HOUR24_MINUTE_SECOND,
  DateFormat.HOUR,
  DateFormat.HOUR_MINUTE,
  DateFormat.HOUR_MINUTE_SECOND,
  // TODO(alanknight): Time zone support
  //    DateFormat.HOUR_MINUTE_GENERIC_TZ,
  //    DateFormat.HOUR_MINUTE_TZ,
  //    DateFormat.HOUR_GENERIC_TZ,
  //    DateFormat.HOUR_TZ,
  DateFormat.MINUTE,
  DateFormat.MINUTE_SECOND,
  DateFormat.SECOND
  // ABBR_GENERIC_TZ,
  // GENERIC_TZ,
  // ABBR_SPECIFIC_TZ,
  // SPECIFIC_TZ,
  // ABBR_UTC_TZ
  ];

var icuFormatNamesToTest = const [
  // It would be really nice to not have to duplicate this and just be able
  // to use the names to get reflective access.
  "DAY",
  "ABBR_WEEKDAY",
  "WEEKDAY",
  "ABBR_STANDALONE_MONTH",
  "STANDALONE_MONTH",
  "NUM_MONTH",
  "NUM_MONTH_DAY",
  "NUM_MONTH_WEEKDAY_DAY",
  "ABBR_MONTH",
  "ABBR_MONTH_DAY",
  "ABBR_MONTH_WEEKDAY_DAY",
  "MONTH",
  "MONTH_DAY",
  "MONTH_WEEKDAY_DAY",
  "ABBR_QUARTER",
  "QUARTER",
  "YEAR",
  "YEAR_NUM_MONTH",
  "YEAR_NUM_MONTH_DAY",
  "YEAR_NUM_MONTH_WEEKDAY_DAY",
  "YEAR_ABBR_MONTH",
  "YEAR_ABBR_MONTH_DAY",
  "YEAR_ABBR_MONTH_WEEKDAY_DAY",
  "YEAR_MONTH",
  "YEAR_MONTH_DAY",
  "YEAR_MONTH_WEEKDAY_DAY",
  // TODO(alanknight): CLDR and ICU appear to disagree on these for Japanese.
  // omit for the time being
  //    "YEAR_ABBR_QUARTER",
  //    "YEAR_QUARTER",
  "HOUR24",
  "HOUR24_MINUTE",
  "HOUR24_MINUTE_SECOND",
  "HOUR",
  "HOUR_MINUTE",
  "HOUR_MINUTE_SECOND",
  // TODO(alanknight): Time zone support
  //    "HOUR_MINUTE_GENERIC_TZ",
  //    "HOUR_MINUTE_TZ",
  //    "HOUR_GENERIC_TZ",
  //    "HOUR_TZ",
  "MINUTE",
  "MINUTE_SECOND",
  "SECOND"
  // ABBR_GENERIC_TZ,
  // GENERIC_TZ,
  // ABBR_SPECIFIC_TZ,
  // SPECIFIC_TZ,
  // ABBR_UTC_TZ
];

/**
 * Exercise all of the formats we have explicitly defined on a particular
 * locale. [expectedResults] is a map from ICU format names to the
 * expected result of formatting [date] according to that format in
 * [locale].
 */
testLocale(String localeName, Map expectedResults, Date date) {
  var intl = new Intl(localeName);
  for(int i=0; i<formatsToTest.length; i++) {
    var skeleton = formatsToTest[i];
    var format = intl.date(skeleton);
    var icuName = icuFormatNamesToTest[i];
    var actualResult = format.format(date);
    expect(expectedResults[icuName], equals(actualResult));
  }
}

testRoundTripParsing(String localeName, Date date) {
  // In order to test parsing, we can't just read back the date, because
  // printing in most formats loses information. But we can test that
  // what we parsed back prints the same as what we originally printed.
  // At least in most cases. In some cases, we can't even do that. e.g.
  // the skeleton WEEKDAY can't be reconstructed at all, and YEAR_MONTH
  // formats don't give us enough information to construct a valid date.
  var badSkeletons = [
      DateFormat.ABBR_WEEKDAY,
      DateFormat.WEEKDAY,
      DateFormat.QUARTER,
      DateFormat.ABBR_QUARTER,
      DateFormat.YEAR,
      DateFormat.YEAR_NUM_MONTH,
      DateFormat.YEAR_ABBR_MONTH,
      DateFormat.YEAR_MONTH,
      DateFormat.MONTH_WEEKDAY_DAY,
      DateFormat.NUM_MONTH_WEEKDAY_DAY,
      DateFormat.ABBR_MONTH_WEEKDAY_DAY];
  for(int i = 0; i < formatsToTest.length; i++) {
    var skeleton = formatsToTest[i];
    if (!badSkeletons.some((x) => x == skeleton)) {
      var format = new DateFormat(skeleton, localeName);
      var actualResult = format.format(date);
      var parsed = format.parse(actualResult);
      var thenPrintAgain = format.format(parsed);
      expect(thenPrintAgain, equals(actualResult));
    }
  }
}

/** A shortcut for returning all the locales we have available.*/
List<String> allLocales() => DateFormat.allLocalesWithSymbols();

/**
 * Return only the odd-numbered locales. A simple way to divide the list into
 * two roughly equal parts.
 */
List oddLocales() {
  int i = 1;
  return allLocales().filter((x) => (i++).isOdd());
}

/**
 * Return only the even-numbered locales. A simple way to divide the list into
 * two roughly equal parts.
 */
List evenLocales() {
  int i = 1;
  return allLocales().filter((x) => !((i++).isOdd()));
}

// TODO(alanknight): Run specific tests for the en_ISO locale which isn't
// included in CLDR, and check that our patterns for it are correct (they
// very likely aren't).
runDateTests([List<String> subset]) {
  test('Multiple patterns', () {
    var date = new Date.now();
    var multiple1 = new DateFormat.yMd().add_jms();
    var multiple2 = new DateFormat("yMd").add_jms();
    var separate1 = new DateFormat.yMd();
    var separate2 = new DateFormat.jms();
    var separateFormat = "${separate1.format(date)} ${separate2.format(date)}";
    expect(multiple1.format(date), equals(multiple2.format(date)));
    expect(multiple1.format(date), equals(separateFormat));
    var customPunctuation = new DateFormat("yMd").addPattern("jms",":::");
    var custom = "${separate1.format(date)}:::${separate2.format(date)}";
    expect(customPunctuation.format(date), equals(custom));
  });

  test('Basic date format parsing', () {
    var date_format = new DateFormat("d");
    expect(
        date_format.parsePattern("hh:mm:ss").map((x) => x.pattern),
        orderedEquals(["hh",":", "mm",":","ss"]));
    expect(
        date_format.parsePattern("hh:mm:ss").map((x) => x.pattern),
        orderedEquals(["hh",":", "mm",":","ss"]));
  });

  test('Test ALL the supported formats on representative locales', () {
    var aDate = new Date(2012, 1, 27, 20, 58, 59, 0, false);
    testLocale("en_US", English, aDate);
    testLocale("de_DE", German, aDate);
    testLocale("fr_FR", French, aDate);
    testLocale("ja_JP", Japanese, aDate);
    testLocale("el_GR", Greek, aDate);
    testLocale("de_AT", Austrian, aDate);
  });

  test('Test round-trip parsing of dates', () {
    var hours = [0, 1, 11, 12, 13, 23];
    var months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    var locales = subset == null ? allLocales() : subset;
    for (var locale in locales) {
      for (var month in months) {
        var aDate = new Date(2012, month, 27, 13, 58, 59, 012, false);
        testRoundTripParsing(locale, aDate);
      }
      for (var hour in hours) {
        var aDate = new Date(2012, 1, 27, hour, 58, 59, 123, false);
        testRoundTripParsing(locale, aDate);
      }
    }
  });

  test('Patterns and symbols have the same coverage',() {
    var patterns = new List.from(dateTimePatterns.getKeys());
    var compare = (a, b) => a.compareTo(b);
    patterns.sort(compare);
    var symbols = allLocales();
    // Workaround for a dartj2 issue that treats the keys as immutable
    symbols = new List.from(symbols);
    symbols.sort(compare);
    for (var i = 0; i < patterns.length; i++)
      expect(patterns[i], equals(symbols[i]));
    expect(patterns.length, equals(symbols.length));
  });

  test('Test malformed locales', () {
    var aDate = new Date(2012, 1, 27, 20, 58, 59, 0, false);
    // Austrian is a useful test locale here because it differs slightly
    // from the generic "de" locale so we can tell the difference between
    // correcting to "de_AT" and falling back to just "de".
    testLocale('de-AT', Austrian, aDate);
    testLocale('de_at', Austrian, aDate);
    testLocale('de-at', Austrian, aDate);
  });

  test('Test format creation via Intl', () {
    var intl = new Intl('ja_JP');
    var instanceJP = intl.date('jms');
    var instanceUS = intl.date('jms', 'en_US');
    var blank = intl.date('jms');
    var date = new Date(2012, 1, 27, 20, 58, 59, 0, false);
    expect(instanceJP.format(date), equals("20:58:59"));
    expect(instanceUS.format(date), equals("8:58:59 PM"));
    expect(blank.format(date), equals("20:58:59"));
  });

  test('Test explicit format string', () {
    var aDate = new Date(2012, 1, 27, 20, 58, 59, 0, false);
    // An explicit format that doesn't conform to any skeleton
    var us = new DateFormat(r'yy //// :D \\\\ dd:ss ^&@ M');
    expect(us.format(aDate), equals(r"12 //// :D \\\\ 27:59 ^&@ 1"));
    // The result won't change with locale unless we use fields that are words.
    var greek = new DateFormat(r'yy //// :D \\\\ dd:ss ^&@ M', 'el_GR');
    expect(greek.format(aDate), equals(r"12 //// :D \\\\ 27:59 ^&@ 1"));
    var usWithWords = new DateFormat('yy / :D \\ dd:ss ^&@ MMM', 'en_US');
    var greekWithWords = new DateFormat('yy / :D \\ dd:ss ^&@ MMM', 'el_GR');
    expect(
        usWithWords.format(aDate),
        equals(r"12 / :D \ 27:59 ^&@ Jan"));
    expect(
        greekWithWords.format(aDate),
        equals(r"12 / :D \ 27:59 ^&@ Ιαν"));
    var escaped = new DateFormat(r"hh 'o''clock'");
    expect(escaped.format(aDate), equals(r"08 o'clock"));
    var reParsed = escaped.parse(escaped.format(aDate));
    expect(escaped.format(reParsed), equals(escaped.format(aDate)));
    var noSeparators = new DateFormat('HHmmss');
    expect(noSeparators.format(aDate), equals("205859"));
    });

  test('Test fractional seconds padding', () {
    var one = new Date(2012, 1, 27, 20, 58, 59, 1, false);
    var oneHundred = new Date(2012, 1, 27, 20, 58, 59, 100, false);
    var fractional = new DateFormat('hh:mm:ss.SSS', 'en_US');
    expect(fractional.format(one), equals('08:58:59.001'));
    expect(fractional.format(oneHundred), equals('08:58:59.100'));
    var long = new DateFormat('ss.SSSSSSSS', 'en_US');
    expect(long.format(oneHundred), equals('59.10000000'));
    expect(long.format(one), equals('59.00100000'));
  });

  test('Test parseUTC', () {
    var local = new Date(2012, 1, 27, 20, 58, 59, 1, false);
    var utc = new Date(2012, 1, 27, 20, 58, 59, 1, true);
    // Getting the offset as a duration via difference() would be simpler,
    // but doesn't work on dart2js in checked mode. See issue 4437.
    var offset = utc.millisecondsSinceEpoch - local.millisecondsSinceEpoch;
    var format = new DateFormat('yyyy-MM-dd HH:mm:ss');
    var localPrinted = format.format(local);
    var parsed = format.parse(localPrinted);
    var parsedUTC = format.parseUTC(format.format(utc));
    var parsedOffset = parsedUTC.millisecondsSinceEpoch
        - parsed.millisecondsSinceEpoch;
    expect(parsedOffset, equals(offset));
    expect(utc.hour, equals(parsedUTC.hour));
    expect(local.hour, equals(parsed.hour));
    });
}
