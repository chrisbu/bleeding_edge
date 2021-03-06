// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// Class for intrinsifying functions.

#include "vm/intrinsifier.h"
#include "vm/flags.h"
#include "vm/object.h"

namespace dart {

DEFINE_FLAG(bool, intrinsify, true, "Instrinsify when possible");


static bool CompareNames(const char* test_name, const char* name) {
  if (strcmp(test_name, name) == 0) {
    return true;
  }
  if ((name[0] == '_') && (test_name[0] == '_')) {
    // Check if the private class is member of core, coreimpl or
    // scalarlist and matches the test_class_name.
    const Library& core_lib = Library::Handle(Library::CoreLibrary());
    const Library& core_impl_lib = Library::Handle(Library::CoreImplLibrary());
    const Library& scalarlist_lib =
        Library::Handle(Library::ScalarlistLibrary());
    String& test_str = String::Handle(String::New(test_name));
    String& test_str_with_key = String::Handle();
    test_str_with_key =
        String::Concat(test_str, String::Handle(core_lib.private_key()));
    if (strcmp(test_str_with_key.ToCString(), name) == 0) {
      return true;
    }
    test_str_with_key =
        String::Concat(test_str, String::Handle(core_impl_lib.private_key()));
    if (strcmp(test_str_with_key.ToCString(), name) == 0) {
      return true;
    }
    test_str_with_key =
        String::Concat(test_str, String::Handle(scalarlist_lib.private_key()));
    if (strcmp(test_str_with_key.ToCString(), name) == 0) {
      return true;
    }
  }
  return false;
}


// Returns true if the function matches function_name and class_name, with
// special recognition of corelib private classes.
static bool TestFunction(const Function& function,
                         const char* function_class_name,
                         const char* function_name,
                         const char* test_class_name,
                         const char* test_function_name) {
  // If test_function_name starts with a '.' we use that to indicate
  // that it is a named constructor in the class. Therefore, if
  // the class matches and the rest of the method name starting with
  // the dot matches, we have found a match.
  if (test_function_name[0] == '.') {
    function_name = strstr(function_name, ".");
    if (function_name == NULL) {
      return false;
    }
  }
  return CompareNames(test_class_name, function_class_name) &&
         CompareNames(test_function_name, function_name);
}


bool Intrinsifier::CanIntrinsify(const Function& function) {
  if (!FLAG_intrinsify) return false;
  // Closure functions may have different arguments.
  if (function.IsClosureFunction()) return false;
  const char* function_name = String::Handle(function.name()).ToCString();
  const Class& function_class = Class::Handle(function.Owner());
  const char* class_name = String::Handle(function_class.Name()).ToCString();
  // Only core, math and scalarlist library methods can be intrinsified.
  const Library& core_lib = Library::Handle(Library::CoreLibrary());
  const Library& core_impl_lib = Library::Handle(Library::CoreImplLibrary());
  const Library& math_lib = Library::Handle(Library::MathLibrary());
  const Library& scalarlist_lib = Library::Handle(Library::ScalarlistLibrary());
  if ((function_class.library() != core_lib.raw()) &&
      (function_class.library() != core_impl_lib.raw()) &&
      (function_class.library() != math_lib.raw()) &&
      (function_class.library() != scalarlist_lib.raw())) {
    return false;
  }
#define FIND_INTRINSICS(test_class_name, test_function_name, destination)      \
  if (TestFunction(function,                                                   \
                   class_name, function_name,                                  \
                   #test_class_name, #test_function_name)) {                   \
    return true;                                                               \
  }                                                                            \

INTRINSIC_LIST(FIND_INTRINSICS);
#undef FIND_INTRINSICS
  return false;
}

bool Intrinsifier::Intrinsify(const Function& function, Assembler* assembler) {
  if (!CanIntrinsify(function)) return false;
  const char* function_name = String::Handle(function.name()).ToCString();
  const Class& function_class = Class::Handle(function.Owner());
  const char* class_name = String::Handle(function_class.Name()).ToCString();
#define FIND_INTRINSICS(test_class_name, test_function_name, destination)      \
  if (TestFunction(function,                                                   \
                   class_name, function_name,                                  \
                   #test_class_name, #test_function_name)) {                   \
    return destination(assembler);                                             \
  }                                                                            \

INTRINSIC_LIST(FIND_INTRINSICS);
#undef FIND_INTRINSICS
  return false;
}

}  // namespace dart
