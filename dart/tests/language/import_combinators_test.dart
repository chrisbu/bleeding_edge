// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Dart test program importing with show/hide combinators.

import "import1_lib.dart" show hide, show hide ugly;

part "import_combinators_part.dart";

main() {
  print(hide);
  print(show);
  print(lookBehindCurtain());
}
