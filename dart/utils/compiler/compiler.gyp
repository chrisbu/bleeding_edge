# Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

{
  'variables': {
    'dart_dir': '../..',
  },
  'targets': [
    {
      'target_name': 'dart2js',
      'type': 'none',
      'dependencies': [
        '../../runtime/dart-runtime.gyp:dart',
        '../../third_party/v8/src/d8.gyp:d8',
      ],
      'actions': [
        {
          'action_name': 'build_dart2js',
          'inputs': [
            '<(PRODUCT_DIR)/<(EXECUTABLE_PREFIX)dart<(EXECUTABLE_SUFFIX)',
            'build_helper.dart',
          ],
          'outputs': [
            '<(PRODUCT_DIR)/dart2js',
            '<(PRODUCT_DIR)/dart2js.bat',
            '<(PRODUCT_DIR)/dart2js_developer',
            '<(PRODUCT_DIR)/dart2js_developer.bat',
            '<(PRODUCT_DIR)/dartdoc',
            '<(PRODUCT_DIR)/dartdoc.bat',
          ],
          'action': [
            '<(PRODUCT_DIR)/<(EXECUTABLE_PREFIX)dart<(EXECUTABLE_SUFFIX)',
            '--enable-checked-mode',
            'build_helper.dart',
            # Note: it would seem more straight-forward to pass in
            # '<(PRODUCT_DIR)/<(EXECUTABLE_PREFIX)dart<(EXECUTABLE_SUFFIX)'.
            # Unfortunately, there is some strange interaction with
            # GYP so it doesn't work.
            '<(PRODUCT_DIR)',
            '<(EXECUTABLE_PREFIX)dart<(EXECUTABLE_SUFFIX)',
            'dart2js',
            'dart2js_developer',
            'dartdoc',
            '<(dart_dir)',
          ],
        },
      ],
    },
  ],
}
