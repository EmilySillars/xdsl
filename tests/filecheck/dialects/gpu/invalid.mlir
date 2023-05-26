// RUN: xdsl-opt %s --verify-diagnostics --split-input-file | filecheck %s

"builtin.module"()({
    "gpu.module"()({
        %init = "arith.constant"() {"value" = 42 : index} : () -> index
        %sum = "gpu.all_reduce"(%init) ({
        ^bb(%lhs : index, %rhs : index):
            %sum = "arith.addi"(%lhs, %rhs) : (index, index) -> index
            "gpu.yield"(%sum) : (index) -> ()
        }) {"op" = #gpu<all_reduce_op add>} : (index) -> index
        "gpu.module_end"() : () -> ()
    }) {"sym_name" = "all_reduce_both"} : () -> ()
}) {} : () -> ()

// CHECK: gpu.all_reduce can't have both a non-empty region and an op attribute.

// -----

"builtin.module"()({
    "gpu.module"()({
        %init = "arith.constant"() {"value" = 42 : index} : () -> index
        %sum = "gpu.all_reduce"(%init) ({
        ^bb(%lhs : index):
            %c = "arith.constant"() {"value" = 42 : index} : () -> index
            %sum = "arith.addi"(%lhs, %c) : (index, index) -> index
            "gpu.yield"(%sum) : (index) -> ()
        }) : (index) -> index
        "gpu.module_end"() : () -> ()
    }) {"sym_name" = "all_reduce_body_types"} : () -> ()
}) {} : () -> ()

// CHECK: Expected ['index', 'index'], got ['index']. A gpu.all_reduce's body must have two arguments matching the result type.
