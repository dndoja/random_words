import 'dart:math';

import 'package:random_words/src/syllables.dart';
import 'package:random_words/src/words/adjectives.dart';
import 'package:random_words/src/words/adjectives_monosyllabic_safe.dart';
import 'package:random_words/src/words/unsafe.dart';

/// The default value of the `maxSyllables` parameter of the [generateAdjective]
/// function.
const int adjectiveMaxSyllablesDefault = 2;

/// The default value of the `safeOnly` parameter of the [generateAdjective]
/// function.
const bool adjectiveSafeOnlyDefault = true;

/// The default value of the `top` parameter of the [generateAdjective]
/// function.
const int adjectiveTopDefault = 10000;

final _random = new Random();

/// Randomly generates nice-sounding combinations of words (compounds).
///
/// Will only return adjectives that are [maxSyllables] long.
///
/// By default, this function will generate combinations from all the top
/// words in the database ([adjectives]). You can tighten it by
/// providing [top]. For example, when [top] is `10`, then only the top ten
/// adjectives will be used for generating the words.
///
/// By default, the generator will not output possibly offensive words,
/// such as 'ballsack' or anything containing 'Jew'. You can turn this behavior
/// off by setting [safeOnly] to `false`.
///
/// You can inject [Random] using the [random] parameter.
Iterable<WordAdjective> generateAdjective(
    {int wordLength: -1,
    int maxSyllables: adjectiveMaxSyllablesDefault,
    int top: adjectiveTopDefault,
    bool safeOnly: adjectiveSafeOnlyDefault,
    Random random}) sync* {
  random ??= _random;

  bool filterWord(String word) {
    if (safeOnly && unsafe.contains(word)) return false;
    return (wordLength == -1 || wordLength == word.length) &&
        syllables(word) <= maxSyllables - 1;
  }

  List<String> shortAdjectives;
  if (maxSyllables == adjectiveMaxSyllablesDefault &&
      top == adjectiveTopDefault &&
      safeOnly == adjectiveSafeOnlyDefault &&
      wordLength == -1) {
    // The most common, precomputed case.
    shortAdjectives = adjectivesMonosyllabicSafe;
  } else {
    shortAdjectives =
        adjectives.where(filterWord).take(top).toList(growable: false);
  }

  String pickRandom(List<String> list) => list[random.nextInt(list.length)];

  // We're in a sync* function, so `while (true)` is okay.
  // ignore: literal_only_boolean_expressions
  while (true) {
    String word;
    if (random.nextBool()) {
      word = pickRandom(shortAdjectives);
    }

    // Confirm word is not null
    if (word == null) continue;

    // Skip word that is unsafe.
    if (safeOnly && unsafe.contains("$word")) continue;

    final adjective = new WordAdjective(word);
    // Skip words that don't make a nicely pronounced 2-syllable word
    // when combined together.
    if (syllables(adjective.toString()) > maxSyllables) continue;
    yield adjective;
  }
}

/// A given [word] that is an adjective.
class WordAdjective {
  /// The adjective word.
  final String word;

  String _asLowerCase;

  String _asUpperCase;

  String _asString;

  String _asCapitalized;

  /// Create a [WordAdjective] from the strings [word].
  WordAdjective(this.word) {
    if (word == null) {
      throw new ArgumentError("Word cannot be null. "
          "Received: '$word'");
    }
    if (word.isEmpty) {
      throw new ArgumentError("Wordcannot be empty. "
          "Received: '$word'");
    }
  }

  /// Creates a single [WordAdjective] randomly. Takes the same parameters as
  /// [generateAdjective].
  ///
  /// If you need more than one adjective, this constructor will be inefficient.
  /// Get an iterable of random adjective instead by calling
  /// [generateAdjective].
  factory WordAdjective.random(
      {int maxSyllables: adjectiveMaxSyllablesDefault,
      int top: adjectiveTopDefault,
      bool safeOnly: adjectiveSafeOnlyDefault,
      Random random}) {
    random ??= _random;
    final adjectiveIterable = generateAdjective(
        maxSyllables: maxSyllables,
        top: top,
        safeOnly: safeOnly,
        random: random);
    return adjectiveIterable.first;
  }

  /// Returns the adjective as a simple string, in lower case,
  /// like `"political"` or `"military"`.
  String get asLowerCase => _asLowerCase ??= asString.toLowerCase();

  /// Returns the adjective as a simple string, in upper case,
  /// like `"POLITICAL"` or `"MILITARY"`.
  String get asUpperCase => _asUpperCase ??= asString.toUpperCase();

  /// Returns the adjective as a simple string, like `"political"`
  /// or `"military"`.
  String get asString => _asString ??= '$word';

  /// Returns the noun as a capitalized string, like `"Political"`
  /// or `"Military"`.
  String get asCapitalized => _asCapitalized ??= _capitalize(word);

  @override
  int get hashCode => asString.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is WordAdjective) {
      return word == other.word;
    } else {
      return false;
    }
  }

  @override
  String toString() => asString;

  String _capitalize(String word) {
    return "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
  }
}
