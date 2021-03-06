// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#ifndef VM_FLOW_GRAPH_H_
#define VM_FLOW_GRAPH_H_

#include "vm/growable_array.h"
#include "vm/parser.h"

namespace dart {

class BlockEntryInstr;
class Definition;
class FlowGraphBuilder;
class GraphEntryInstr;
class PhiInstr;
class ReturnInstr;

class BlockIterator : public ValueObject {
 public:
  explicit BlockIterator(const GrowableArray<BlockEntryInstr*>& block_order)
      : block_order_(block_order), current_(0) { }

  void Advance() {
    ASSERT(!Done());
    current_++;
  }

  bool Done() const { return current_ >= block_order_.length(); }

  BlockEntryInstr* Current() const { return block_order_[current_]; }

 private:
  const GrowableArray<BlockEntryInstr*>& block_order_;
  intptr_t current_;
};


// Class to incapsulate the construction and manipulation of the flow graph.
class FlowGraph : public ZoneAllocated {
 public:
  FlowGraph(const FlowGraphBuilder& builder, GraphEntryInstr* graph_entry);

  // Function properties.
  const ParsedFunction& parsed_function() const {
    return parsed_function_;
  }
  intptr_t parameter_count() const {
    return num_copied_params_ + num_non_copied_params_;
  }
  intptr_t variable_count() const {
    return parameter_count() + num_stack_locals_;
  }
  intptr_t num_stack_locals() const {
    return num_stack_locals_;
  }
  intptr_t num_copied_params() const {
    return num_copied_params_;
  }
  intptr_t num_non_copied_params() const {
    return num_non_copied_params_;
  }

  // Flow graph orders.
  const GrowableArray<BlockEntryInstr*>& preorder() const {
    return preorder_;
  }
  const GrowableArray<BlockEntryInstr*>& postorder() const {
    return postorder_;
  }
  const GrowableArray<BlockEntryInstr*>& reverse_postorder() const {
    return reverse_postorder_;
  }

  // Iterators.
  BlockIterator reverse_postorder_iterator() const {
    return BlockIterator(reverse_postorder());
  }
  BlockIterator postorder_iterator() const {
    return BlockIterator(postorder());
  }

  intptr_t current_ssa_temp_index() const { return current_ssa_temp_index_; }

  intptr_t max_virtual_register_number() const {
    return current_ssa_temp_index();
  }

  GraphEntryInstr* graph_entry() const {
    return graph_entry_;
  }

  ZoneGrowableArray<ReturnInstr*>* exits() const { return exits_; }
  void set_exits(ZoneGrowableArray<ReturnInstr*>* exits) { exits_ = exits; }

  intptr_t alloc_ssa_temp_index() { return current_ssa_temp_index_++; }

  // Operations on the flow graph.
  void ComputeSSA(intptr_t next_virtual_register_number);
  void ComputeUseLists();

  // Finds natural loops in the flow graph and attaches a list of loop
  // body blocks for each loop header.
  void ComputeLoops(GrowableArray<BlockEntryInstr*>* loop_headers);

  void InlineCall(Definition* call, FlowGraph* callee_graph);

  // TODO(zerny): Once the SSA is feature complete this should be removed.
  void Bailout(const char* reason) const;

#ifdef DEBUG
  // Validation methods for debugging.
  bool ResetUseLists();
  bool ValidateUseLists();
#endif  // DEBUG

 private:
  friend class ConstantPropagator;

  void DiscoverBlocks();

  // SSA transformation methods and fields.
  void ComputeDominators(GrowableArray<BitVector*>* dominance_frontier);

  void CompressPath(
      intptr_t start_index,
      intptr_t current_index,
      GrowableArray<intptr_t>* parent,
      GrowableArray<intptr_t>* label);

  void Rename(GrowableArray<PhiInstr*>* live_phis);
  void RenameRecursive(
      BlockEntryInstr* block_entry,
      GrowableArray<Definition*>* env,
      GrowableArray<PhiInstr*>* live_phis);

  void InsertPhis(
      const GrowableArray<BlockEntryInstr*>& preorder,
      const GrowableArray<BitVector*>& assigned_vars,
      const GrowableArray<BitVector*>& dom_frontier);

  void MarkLivePhis(GrowableArray<PhiInstr*>* live_phis);

  // DiscoverBlocks computes parent_ and assigned_vars_ which are then used
  // if/when computing SSA.
  GrowableArray<intptr_t> parent_;
  GrowableArray<BitVector*> assigned_vars_;

  intptr_t current_ssa_temp_index_;

  // Flow graph fields.
  const ParsedFunction& parsed_function_;
  const intptr_t num_copied_params_;
  const intptr_t num_non_copied_params_;
  const intptr_t num_stack_locals_;
  GraphEntryInstr* graph_entry_;
  GrowableArray<BlockEntryInstr*> preorder_;
  GrowableArray<BlockEntryInstr*> postorder_;
  GrowableArray<BlockEntryInstr*> reverse_postorder_;
  ZoneGrowableArray<ReturnInstr*>* exits_;
};

}  // namespace dart

#endif  // VM_FLOW_GRAPH_H_
