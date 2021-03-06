// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class _TypedArrayFactoryProvider {

  static Float32Array createFloat32Array(int length) => _F32(length);
  static Float32Array createFloat32Array_fromList(List<num> list) =>
      _F32(ensureNative(list));
  static Float32Array createFloat32Array_fromBuffer(ArrayBuffer buffer,
                                  [int byteOffset = 0, int length]) {
    if (length == null) return _F32_2(buffer, byteOffset);
    return _F32_3(buffer, byteOffset, length);
  }

  static Float64Array createFloat64Array(int length) => _F64(length);
  static Float64Array createFloat64Array_fromList(List<num> list) =>
      _F64(ensureNative(list));
  static Float64Array createFloat64Array_fromBuffer(ArrayBuffer buffer,
      [int byteOffset = 0, int length]) {
    if (length == null) return _F64_2(buffer, byteOffset);
    return _F64_3(buffer, byteOffset, length);
  }

  static Int8Array createInt8Array(int length) => _I8(length);
  static Int8Array createInt8Array_fromList(List<num> list) =>
      _I8(ensureNative(list));
  static Int8Array createInt8Array_fromBuffer(ArrayBuffer buffer,
      [int byteOffset = 0, int length]) {
    if (length == null) return _I8_2(buffer, byteOffset);
    return _I8_3(buffer, byteOffset, length);
  }

  static Int16Array createInt16Array(int length) => _I16(length);
  static Int16Array createInt16Array_fromList(List<num> list) =>
      _I16(ensureNative(list));
  static Int16Array createInt16Array_fromBuffer(ArrayBuffer buffer,
      [int byteOffset = 0, int length]) {
    if (length == null) return _I16_2(buffer, byteOffset);
    return _I16_3(buffer, byteOffset, length);
  }

  static Int32Array createInt32Array(int length) => _I32(length);
  static Int32Array createInt32Array_fromList(List<num> list) =>
      _I32(ensureNative(list));
  static Int32Array createInt32Array_fromBuffer(ArrayBuffer buffer,
      [int byteOffset = 0, int length]) {
    if (length == null) return _I32_2(buffer, byteOffset);
    return _I32_3(buffer, byteOffset, length);
  }

  static Uint8Array createUint8Array(int length) => _U8(length);
  static Uint8Array createUint8Array_fromList(List<num> list) =>
      _U8(ensureNative(list));
  static Uint8Array createUint8Array_fromBuffer(ArrayBuffer buffer,
      [int byteOffset = 0, int length]) {
    if (length == null) return _U8_2(buffer, byteOffset);
    return _U8_3(buffer, byteOffset, length);
  }

  static Uint16Array createUint16Array(int length) => _U16(length);
  static Uint16Array createUint16Array_fromList(List<num> list) =>
      _U16(ensureNative(list));
  static Uint16Array createUint16Array_fromBuffer(ArrayBuffer buffer,
      [int byteOffset = 0, int length]) {
    if (length == null) return _U16_2(buffer, byteOffset);
    return _U16_3(buffer, byteOffset, length);
  }

  static Uint32Array createUint32Array(int length) => _U32(length);
  static Uint32Array createUint32Array_fromList(List<num> list) =>
      _U32(ensureNative(list));
  static Uint32Array createUint32Array_fromBuffer(ArrayBuffer buffer,
      [int byteOffset = 0, int length]) {
    if (length == null) return _U32_2(buffer, byteOffset);
    return _U32_3(buffer, byteOffset, length);
  }

  static Uint8ClampedArray createUint8ClampedArray(int length) => _U8C(length);
  static Uint8ClampedArray createUint8ClampedArray_fromList(List<num> list) =>
      _U8C(ensureNative(list));
  static Uint8ClampedArray createUint8ClampedArray_fromBuffer(
        ArrayBuffer buffer, [int byteOffset = 0, int length]) {
    if (length == null) return _U8C_2(buffer, byteOffset);
    return _U8C_3(buffer, byteOffset, length);
  }

  static Float32Array _F32(arg) native 'return new Float32Array(arg);';
  static Float64Array _F64(arg) native 'return new Float64Array(arg);';
  static Int8Array _I8(arg) native 'return new Int8Array(arg);';
  static Int16Array _I16(arg) native 'return new Int16Array(arg);';
  static Int32Array _I32(arg) native 'return new Int32Array(arg);';
  static Uint8Array _U8(arg) native 'return new Uint8Array(arg);';
  static Uint16Array _U16(arg) native 'return new Uint16Array(arg);';
  static Uint32Array _U32(arg) native 'return new Uint32Array(arg);';
  static Uint8ClampedArray _U8C(arg) native 'return new Uint8ClampedArray(arg);';

  static Float32Array _F32_2(arg1, arg2) native 'return new Float32Array(arg1, arg2);';
  static Float64Array _F64_2(arg1, arg2) native 'return new Float64Array(arg1, arg2);';
  static Int8Array _I8_2(arg1, arg2) native 'return new Int8Array(arg1, arg2);';
  static Int16Array _I16_2(arg1, arg2) native 'return new Int16Array(arg1, arg2);';
  static Int32Array _I32_2(arg1, arg2) native 'return new Int32Array(arg1, arg2);';
  static Uint8Array _U8_2(arg1, arg2) native 'return new Uint8Array(arg1, arg2);';
  static Uint16Array _U16_2(arg1, arg2) native 'return new Uint16Array(arg1, arg2);';
  static Uint32Array _U32_2(arg1, arg2) native 'return new Uint32Array(arg1, arg2);';
  static Uint8ClampedArray _U8C_2(arg1, arg2) native 'return new Uint8ClampedArray(arg1, arg2);';

  static Float32Array _F32_3(arg1, arg2, arg3) native 'return new Float32Array(arg1, arg2, arg3);';
  static Float64Array _F64_3(arg1, arg2, arg3) native 'return new Float64Array(arg1, arg2, arg3);';
  static Int8Array _I8_3(arg1, arg2, arg3) native 'return new Int8Array(arg1, arg2, arg3);';
  static Int16Array _I16_3(arg1, arg2, arg3) native 'return new Int16Array(arg1, arg2, arg3);';
  static Int32Array _I32_3(arg1, arg2, arg3) native 'return new Int32Array(arg1, arg2, arg3);';
  static Uint8Array _U8_3(arg1, arg2, arg3) native 'return new Uint8Array(arg1, arg2, arg3);';
  static Uint16Array _U16_3(arg1, arg2, arg3) native 'return new Uint16Array(arg1, arg2, arg3);';
  static Uint32Array _U32_3(arg1, arg2, arg3) native 'return new Uint32Array(arg1, arg2, arg3);';
  static Uint8ClampedArray _U8C_3(arg1, arg2, arg3) native 'return new Uint8ClampedArray(arg1, arg2, arg3);';


  // Ensures that [list] is a JavaScript Array or a typed array.  If necessary,
  // copies the list.
  static ensureNative(List list) => list;  // TODO: make sure.
}
