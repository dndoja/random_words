# random_words

[![Build status](https://travis-ci.org/t04glovern/random_words.svg)](https://travis-ci.org/t04glovern/random_words)
[![pub package](https://img.shields.io/pub/v/random_words.svg)](https://pub.dartlang.org/packages/random_words)

Utilities for generating random English words. It gives the option to
retrieve random Nouns and Adjectives along with WordPairs. It is based
off of Filip Hracek's english_words plugin

## Usage

Printing the top 50 most used nouns in the English language:

    import 'package:random_words/random_words.dart';

    main() {
      nouns.take(50).forEach(print);
    }

Computing number of syllables in a word:

    syllables('beautiful');  // 3
    syllables('abatement');  // 3
    syllables('zoology');  // 4

Generating 5 interesting 2-syllable word combinations:

    generateWordPairs().take(5).forEach(print);

Generate 10 random adjectives:

    generateAdjective().take(10).forEach(print);

Generate 10 random nouns:

    generateNoun().take(10).forEach(print);

## Running Tests

If you want to run the tests for this project under Flutter Dart

    flutter pub pub run test

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/t04glovern/random_words/issues
