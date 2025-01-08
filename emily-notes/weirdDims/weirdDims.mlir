// module {
//   func.func @dispatch_8(%V : memref<1x600xf64>, %M : memref<600x600xf64>, %O : memref<1x600xf64>) {  
//    linalg.matmul_transpose_b ins(%V, W :  memref<1x600xf64>, memref<600x600xf64>) outs(O : memref<1x600xf64>) -> ()
//    func.return
//   }
// }

#map = affine_map<(d0, d1, d2) -> (d0, d2)>
#map1 = affine_map<(d0, d1, d2) -> (d1, d2)>
#map2 = affine_map<(d0, d1, d2) -> (d0, d1)>
module {
  func.func @dispatch_8(%arg0: memref<1x600xf64>, %arg1: memref<600x600xf64>, %arg2: memref<1x600xf64>) {
    linalg.generic {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "reduction"]} ins(%arg0, %arg1 : memref<1x600xf64>, memref<600x600xf64>) outs(%arg2 : memref<1x600xf64>) {
    ^bb0(%in: f64, %in_0: f64, %out: f64):
      %0 = arith.mulf %in, %in_0 : f64
      %1 = arith.addf %out, %0 : f64
      linalg.yield %1 : f64
    }
    return
  }
}
