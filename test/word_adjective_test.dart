import 'package:random_words/random_words.dart';
import 'package:random_words/src/words/unsafe.dart';
import 'package:test/test.dart';

void main() {
  test('WordAdjective has sane equality', () {
    final a = new WordAdjective("key");
    final b = new WordAdjective("key");
    final c = new WordAdjective("Key");
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(c));
    expect(a.hashCode, isNot(c.hashCode));
  });

  test('WordAdjective provides lowercase', () {
    final a = new WordAdjective("clEar");
    final b = new WordAdjective("big");
    final c = new WordAdjective("France");
    final d = new WordAdjective("hugE");
    expect(a.asLowerCase, "clear");
    expect(b.asLowerCase, "big");
    expect(c.asLowerCase, "france");
    expect(d.asLowerCase, "huge");
  });

  test('WordAdjective provides UPPERCASE', () {
    final a = new WordAdjective("clEar");
    final b = new WordAdjective("big");
    final c = new WordAdjective("France");
    final d = new WordAdjective("hugE");
    expect(a.asUpperCase, "CLEAR");
    expect(b.asUpperCase, "BIG");
    expect(c.asUpperCase, "FRANCE");
    expect(d.asUpperCase, "HUGE");
  });

  test('WordAdjective.random returns normally', () {
    expect(() => new WordAdjective.random(), returnsNormally);
  });

  test('WordAdjective throws on null members', () {
    expect(() => new WordAdjective(null), throwsArgumentError);
  });

  test('WordAdjective throws on empty members', () {
    expect(() => new WordAdjective(""), throwsArgumentError);
  });

  test('generateAdjective avoids unsafe words by default', () {
    // Since this is running a random generator, the test is inherently fuzzy.
    // It won't give you false positives, but it might give you false negatives
    // (i.e. test passes despite problem with the filtering mechanism).
    // There's a 'flaky' tag so that you can skip this test.
    final words = generateAdjective().take(10000);
    for (final word in words) {
      expect(unsafe, isNot(contains(word.word)));
    }
  }, tags: ['flaky']);
}
