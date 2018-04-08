import 'dart:math';

import 'package:random_words/src/syllables.dart';
import 'package:random_words/src/words/nouns.dart';
import 'package:random_words/src/words/nouns_monosyllabic_safe.dart';
import 'package:random_words/src/words/unsafe.dart';

/// The default value of the `maxSyllables` parameter of the [generateNoun]
/// function.
const int nounMaxSyllablesDefault = 2;

/// The default value of the `safeOnly` parameter of the [generateNoun]
/// function.
const bool nounSafeOnlyDefault = true;

/// The default value of the `top` parameter of the [generateNoun]
/// function.
const int nounTopDefault = 10000;

final _random = new Random();

/// Randomly generates nice-sounding combinations of words (compounds).
///
/// Will only return nouns that are [maxSyllables] long.
///
/// By default, this function will generate combinations from all the top
/// words in the database ([nouns]). You can tighten it by
/// providing [top]. For example, when [top] is `10`, then only the top ten
/// nouns will be used for generating the words.
///
/// By default, the generator will not output possibly offensive words,
/// such as 'ballsack' or anything containing 'Jew'. You can turn this behavior
/// off by setting [safeOnly] to `false`.
///
/// You can inject [Random] using the [random] parameter.
Iterable<WordNoun> generateNoun(
    {int maxSyllables: nounMaxSyllablesDefault,
    int top: nounTopDefault,
    bool safeOnly: nounSafeOnlyDefault,
    Random random}) sync* {
  random ??= _random;

  bool filterWord(String word) {
    if (safeOnly && unsafe.contains(word)) return false;
    return syllables(word) <= maxSyllables - 1;
  }

  List<String> shortNouns;
  if (maxSyllables == nounMaxSyllablesDefault &&
      top == nounTopDefault &&
      safeOnly == nounSafeOnlyDefault) {
    // The most common, precomputed case.
    shortNouns = nounsMonosyllabicSafe;
  } else {
    shortNouns =
        nouns.where(filterWord).take(top).toList(growable: false);
  }

  String pickRandom(List<String> list) => list[random.nextInt(list.length)];

  // We're in a sync* function, so `while (true)` is okay.
  // ignore: literal_only_boolean_expressions
  while (true) {
    String word;
    if (random.nextBool()) {
      word = pickRandom(shortNouns);
    }

    // Confirm word is not null
    if (word == null) continue;

    // Skip word that is unsafe.
    if (safeOnly && unsafe.contains("$word")) continue;

    final noun = new WordNoun(word);
    // Skip words that don't make a nicely pronounced 2-syllable word
    // when combined together.
    if (syllables(noun.toString()) > maxSyllables) continue;
    yield noun;
  }
}

/// A given [word] that is an noun.
class WordNoun {
  /// The noun word.
  final String word;

  String _asLowerCase;

  String _asUpperCase;

  String _asString;

  /// Create a [WordNoun] from the strings [word].
  WordNoun(this.word) {
    if (word == null) {
      throw new ArgumentError("Word cannot be null. "
          "Received: '$word'");
    }
    if (word.isEmpty) {
      throw new ArgumentError("Wordcannot be empty. "
          "Received: '$word'");
    }
  }

  /// Creates a single [WordNoun] randomly. Takes the same parameters as
  /// [generateNoun].
  ///
  /// If you need more than one noun, this constructor will be inefficient.
  /// Get an iterable of random noun instead by calling
  /// [generateNoun].
  factory WordNoun.random(
      {int maxSyllables: nounMaxSyllablesDefault,
      int top: nounTopDefault,
      bool safeOnly: nounSafeOnlyDefault,
      Random random}) {
    random ??= _random;
    final nounIterable = generateNoun(
        maxSyllables: maxSyllables,
        top: top,
        safeOnly: safeOnly,
        random: random);
    return nounIterable.first;
  }

  /// Returns the noun as a simple string, in lower case,
  /// like `"football"` or `"chicken"`.
  String get asLowerCase => _asLowerCase ??= asString.toLowerCase();

  /// Returns the noun as a simple string, in upper case,
  /// like `"FOOTBALL"` or `"CHICKEN"`.
  String get asUpperCase => _asUpperCase ??= asString.toUpperCase();

  /// Returns the noun as a simple string, like `"football"`
  /// or `"chicken"`.
  String get asString => _asString ??= '$word';

  @override
  int get hashCode => asString.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is WordNoun) {
      return word == other.word;
    } else {
      return false;
    }
  }

  @override
  String toString() => asString;
}