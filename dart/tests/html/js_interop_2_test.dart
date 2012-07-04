// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file

#library('JsInterop2Test');
#import('../../lib/unittest/unittest.dart');
#import('../../lib/unittest/html_config.dart');
#import('dart:html');
#import('dart:isolate');

injectSource(code) {
  final script = new ScriptElement();
  script.type = 'text/javascript';
  script.innerHTML = code;
  document.body.nodes.add(script);
}

var isolateTest = """
  function test(data) {
    if (data == 'sent')
      return 'received';
  }

  var port = new ReceivePortSync();
  port.receive(test);
  window.registerPort('test', port.toSendPort());
""";

main() {
  useHtmlConfiguration();

  test('isolateTest', () {
    injectSource(isolateTest);

    SendPortSync port = window.lookupPort('test');
    var result = port.callSync('sent');
    Expect.equals('received', result);

    result = port.callSync('ignore');
    Expect.isNull(result);
  });
}