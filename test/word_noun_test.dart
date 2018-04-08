import 'package:random_words/random_words.dart';
import 'package:random_words/src/words/unsafe.dart';
import 'package:test/test.dart';

void main() {
  test('WordNoun has sane equality', () {
    final a = new WordNoun("cut");
    final b = new WordNoun("cut");
    final c = new WordNoun("Cut");
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(c));
    expect(a.hashCode, isNot(c.hashCode));
  });

  test('WordNoun provides lowercase', () {
    final a = new WordNoun("tApe");
    final b = new WordNoun("footBall");
    final c = new WordNoun("coLLeague");
    final d = new WordNoun("Plate");
    expect(a.asLowerCase, "tape");
    expect(b.asLowerCase, "football");
    expect(c.asLowerCase, "colleague");
    expect(d.asLowerCase, "plate");
  });

  test('WordNoun provides UPPERCASE', () {
    final a = new WordNoun("tApe");
    final b = new WordNoun("footBall");
    final c = new WordNoun("coLLeague");
    final d = new WordNoun("Plate");
    expect(a.asUpperCase, "TAPE");
    expect(b.asUpperCase, "FOOTBALL");
    expect(c.asUpperCase, "COLLEAGUE");
    expect(d.asUpperCase, "PLATE");
  });

  test('WordNoun.random returns normally', () {
    expect(() => new WordNoun.random(), returnsNormally);
  });

  test('WordNoun throws on null members', () {
    expect(() => new WordNoun(null), throwsArgumentError);
  });

  test('WordNoun throws on empty members', () {
    expect(() => new WordNoun(""), throwsArgumentError);
  });

  test('generateNoun avoids unsafe words by default', () {
    // Since this is running a random generator, the test is inherently fuzzy.
    // It won't give you false positives, but it might give you false negatives
    // (i.e. test passes despite problem with the filtering mechanism).
    // There's a 'flaky' tag so that you can skip this test.
    final words = generateNoun().take(10000);
    for (final word in words) {
      expect(unsafe, isNot(contains(word.word)));
    }
  }, tags: ['flaky']);
}
