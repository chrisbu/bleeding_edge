// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// The class 'AssemblerMacros' contains assembler instruction groups that
// are used in Dart.

#ifndef VM_ASSEMBLER_MACROS_X64_H_
#define VM_ASSEMBLER_MACROS_X64_H_

#ifndef VM_ASSEMBLER_MACROS_H_
#error Do not include assembler_macros_x64.h directly; use assembler_macros.h.
#endif

#include "vm/allocation.h"
#include "vm/constants_x64.h"

namespace dart {

// Forward declarations.
class Assembler;
class Class;
class Label;

class AssemblerMacros : public AllStatic {
 public:
  // Inlined allocation of an instance of class 'cls', code has no runtime
  // calls. Jump to 'failure' if the instance cannot be allocated here.
  // Allocated instance is returned in 'instance_reg'.
  // Only the tags field of the object is initialized.
  static void TryAllocate(Assembler* assembler,
                          const Class& cls,
                          Label* failure,
                          bool near_jump,
                          Register instance_reg);

  // Set up a dart frame on entry with a frame pointer and PC information to
  // enable easy access to the RawInstruction object of code corresponding
  // to this frame.
  // The dart frame layout is as follows:
  //   ....
  //   ret PC
  //   saved RBP     <=== RBP
  //   pc (used to derive the RawInstruction Object of the dart code)
  //   locals space  <=== RSP
  //   .....
  // This code sets this up with the sequence:
  //   pushq rbp
  //   movq rbp, rsp
  //   call L
  //   L: <code to adjust saved pc if there is any intrinsification code>
  //   .....
  static void EnterDartFrame(Assembler* assembler, intptr_t frame_size);
  // Populates pc local slot lazily.
  static void EnterDartLeafFrame(Assembler* assembler, intptr_t frame_size);

  // Set up a stub frame so that the stack traversal code can easily identify
  // a stub frame.
  // The stub frame layout is as follows:
  //   ....
  //   ret PC
  //   saved RBP
  //   pc (used to derive the RawInstruction Object of the stub)
  //   .....
  // This code sets this up with the sequence:
  //   pushq rbp
  //   movq rbp, rsp
  //   pushq immediate(0)
  //   .....
  static void EnterStubFrame(Assembler* assembler);

  // Instruction pattern from entrypoint is used in dart frame prologs
  // to set up the frame and save a PC which can be used to figure out the
  // RawInstruction object corresponding to the code running in the frame.
  // entrypoint:
  //   pushq rbp          (size is 1 byte)
  //   movq rbp, rsp      (size is 3 bytes)
  //   call L             (size is 5 bytes)
  //   L:
  static const intptr_t kOffsetOfSavedPCfromEntrypoint = 9;
};

}  // namespace dart.

#endif  // VM_ASSEMBLER_MACROS_X64_H_
