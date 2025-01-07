# emily-notes

## Current Task: Simple Function

Inputs: an nsnet kernel, tile width, tile height

Outputs: number of hardware loop iterations, # of memory transfers from L1 to compute core's registers

### Manual Example: dispatch_8_matmul_transpose_b_1x600x600_f64

```
%9 = linalg.matmul_transpose_b 
ins(%4, %5 : tensor<1x600xf64>, tensor<600x600xf64>) 
outs(%8 : tensor<1x600xf64>) -> tensor<1x600xf64>
```

- Root Operation [here](https://github.com/EmilySillars/zigzag/blob/manual-examples/tiling-nsnet/dispatch_8_matmul_transpose_b_1x600x600_f64.md)

Markus recommends tiling it like so:

```
l1Tiles[0] = 0;
l1Tiles[1] = 40;
l1Tiles[2] = 100;
SmallVector<int64_t> l1Interchange = {2, 0, 1};
```

"Flat-ZigZag" recommends tiling it like so:

```
l1Tiles[0] = 0;
l1Tiles[1] = 200;
l1Tiles[2] = 5;
l1Interchange = {0, 1, 2};
```

#### Markus-tiled version in MLIR w/o IREE-specific stuff?

Maybe adapt the following to represent the matmul transpose first?

```
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
```
