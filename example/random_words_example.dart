// Copyright (c) 2017, filiph. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:random_words/random_words.dart';

void main() {
  generateWordPairs().take(10).forEach(print);
  generateAdjective().take(10).forEach(print);
  generateNoun().take(10).forEach(print);
}
