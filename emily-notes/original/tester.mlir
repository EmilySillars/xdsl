builtin.module {
  func.func @matmul(%A : memref<2x2xf64>, %B : memref<2x2xf64>, %C : memref<2x2xf64>) {
    linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d2, d1)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%A, %B : memref<2x2xf64>, memref<2x2xf64>) outs(%C : memref<2x2xf64>) {
    ^0(%a : f64, %b : f64, %acc_old : f64):
      %prod = arith.mulf %a, %b : f64
      %acc_new = arith.addf %acc_old, %prod : f64
      linalg.yield %acc_new : f64
    }
    func.return
  }
}
