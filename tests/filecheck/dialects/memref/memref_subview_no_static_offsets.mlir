// RUN: xdsl-opt %s --parsing-diagnostics --verify-diagnostics --split-input-file | filecheck %s

module {
  func.func @simple_matmul(%arg0: memref<16x16xi8>, %arg1: memref<16x16xi8, strided<[1, 16]>>, %arg2: memref<16x16xi32, strided<[16, 1]>>) {
    %c0_i32 = arith.constant 0 : i32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c16 = arith.constant 16 : index
    %c2 = arith.constant 2 : index
    scf.for %arg3 = %c0 to %c16 step %c2 {
      scf.for %arg4 = %c0 to %c1 step %c1 {
        scf.for %arg5 = %c0 to %c16 step %c2 {
          %subview = memref.subview %arg0[%arg5, %arg4] [2, 16] [1, 1] : memref<16x16xi8> to memref<2x16xi8, strided<[16, 1], offset: ?>>
          %subview_0 = memref.subview %arg1[%arg4, %arg3] [16, 2] [1, 1] : memref<16x16xi8, strided<[1, 16]>> to memref<16x2xi8, strided<[1, 16], offset: ?>>
          %subview_1 = memref.subview %arg2[%arg5, %arg3] [2, 2] [1, 1] : memref<16x16xi32, strided<[16, 1]>> to memref<2x2xi32, strided<[16, 1], offset: ?>>
          linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d2, d1)>, affine_map<(d0, d1, d2) -> ()>, affine_map<(d0, d1, d2) -> ()>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%subview, %subview_0, %c0_i32, %c0_i32 : memref<2x16xi8, strided<[16, 1], offset: ?>>, memref<16x2xi8, strided<[1, 16], offset: ?>>, i32, i32) outs(%subview_1 : memref<2x2xi32, strided<[16, 1], offset: ?>>) {
          ^bb0(%in: i8, %in_2: i8, %in_3: i32, %in_4: i32, %out: i32):
            %0 = arith.extsi %in : i8 to i32
            %1 = arith.subi %0, %in_3 : i32
            %2 = arith.extsi %in_2 : i8 to i32
            %3 = arith.subi %2, %in_4 : i32
            %4 = arith.muli %1, %3 : i32
            %5 = arith.addi %out, %4 : i32
            linalg.yield %5 : i32
          }
        }
      }
    }
    return
  }
}

// CHECK: module {
// CHECK-NEXT:   func.func @simple_matmul(%arg0: memref<16x16xi8>, %arg1: memref<16x16xi8, strided<[1, 16]>>, %arg2: memref<16x16xi32, strided<[16, 1]>>) {
// CHECK-NEXT:     %c0_i32 = arith.constant 0 : i32
// CHECK-NEXT:     %c0 = arith.constant 0 : index
// CHECK-NEXT:     %c1 = arith.constant 1 : index
// CHECK-NEXT:     %c16 = arith.constant 16 : index
// CHECK-NEXT:     %c2 = arith.constant 2 : index
// CHECK-NEXT:     scf.for %arg3 = %c0 to %c16 step %c2 {
// CHECK-NEXT:       scf.for %arg4 = %c0 to %c1 step %c1 {
// CHECK-NEXT:         scf.for %arg5 = %c0 to %c16 step %c2 {
// CHECK-NEXT:           %subview = memref.subview %arg0[%arg5, %arg4] [2, 16] [1, 1] : memref<16x16xi8> to memref<2x16xi8, strided<[16, 1], offset: ?>>
// CHECK-NEXT:           %subview_0 = memref.subview %arg1[%arg4, %arg3] [16, 2] [1, 1] : memref<16x16xi8, strided<[1, 16]>> to memref<16x2xi8, strided<[1, 16], offset: ?>>
// CHECK-NEXT:           %subview_1 = memref.subview %arg2[%arg5, %arg3] [2, 2] [1, 1] : memref<16x16xi32, strided<[16, 1]>> to memref<2x2xi32, strided<[16, 1], offset: ?>>
// CHECK-NEXT:           linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d2, d1)>, affine_map<(d0, d1, d2) -> ()>, affine_map<(d0, d1, d2) -> ()>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%subview, %subview_0, %c0_i32, %c0_i32 : memref<2x16xi8, strided<[16, 1], offset: ?>>, memref<16x2xi8, strided<[1, 16], offset: ?>>, i32, i32) outs(%subview_1 : memref<2x2xi32, strided<[16, 1], offset: ?>>) {
// CHECK-NEXT:           ^bb0(%in: i8, %in_2: i8, %in_3: i32, %in_4: i32, %out: i32):
// CHECK-NEXT:             %0 = arith.extsi %in : i8 to i32
// CHECK-NEXT:             %1 = arith.subi %0, %in_3 : i32
// CHECK-NEXT:             %2 = arith.extsi %in_2 : i8 to i32
// CHECK-NEXT:             %3 = arith.subi %2, %in_4 : i32
// CHECK-NEXT:             %4 = arith.muli %1, %3 : i32
// CHECK-NEXT:             %5 = arith.addi %out, %4 : i32
// CHECK-NEXT:             linalg.yield %5 : i32
// CHECK-NEXT:           }
// CHECK-NEXT:         }
// CHECK-NEXT:       }
// CHECK-NEXT:     }
// CHECK-NEXT:     return
// CHECK-NEXT:   }
// CHECK-NEXT: }