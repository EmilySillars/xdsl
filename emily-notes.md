# emily-notes

## 0. setup

#### First Time

```
cd xdsl
make venv
```

once: `curl -LsSf https://astral.sh/uv/install.sh | sh`

```
source venv/bin/activate
```

once: `uv pip install marimo`

Run tests:

```
# Executes pytests which are located in tests/
uv run pytest

# Executes filecheck tests
uv run lit tests/filecheck

# run all tests using makefile
make tests
```

#### Every Time

```
source venv/bin/activate
```

#### Start xDSL Interpreter Notebook

```
marimo edit docs/marimo
```



## Current Task: Simple Function

Inputs: an nsnet kernel, tile width, tile height

Outputs: number of hardware loop iterations, # of memory transfers from L1 to compute core's registers

### Manual Example: dispatch_8_matmul_transpose_b_1x600x600_f64

- Hardware Loops Comparison: [here](https://docs.google.com/document/d/1WRo3xdJL7tRrXpVkd54rUWn1l4XR6c-X96kkjvDs7Gw/edit?usp=sharing)

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

#### Untiled version in MLIR w/o IREE-specific stuff?

Let's use godbolt.org on the following w/ flag `--linalg-generalize-named-ops`:

```
module {
  func.func @dispatch_8(%V : memref<1x600xf64>, %M : memref<600x600xf64>, %O : memref<1x600xf64>) {  
   linalg.matmul_transpose_b ins(%V, %M :  memref<1x600xf64>, memref<600x600xf64>) outs(%O : memref<1x600xf64>) -> ()
   func.return
  }
}
```

Output from godbolt.org: 

```
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
```

#### Markus-Tiled version in MLIR w/o IREE-specific stuff?

Copied and Pasted from `dispatch8/thread-tiling.mlir`:

```
%21 = linalg.matmul_transpose_b {lowering_config = #quidditch_snitch.lowering_config<
l1_tiles = [0, 40, 100], l1_tiles_interchange = [2, 0, 1], dual_buffer = true>} 
ins(%extracted_slice_8, %extracted_slice_9 : tensor<1x100xf64>, tensor<5x100xf64>) 
outs(%extracted_slice_10 : tensor<1x5xf64>) -> tensor<1x5xf64>
```

Let's use godbolt.org on the following w/ flag `--linalg-generalize-named-ops`:

```
module {
  func.func @dispatch_8(%V : memref<1x100xf64>, %M : memref<5x100xf64>, %O : memref<1x5xf64>) {  
   linalg.matmul_transpose_b ins(%V, %M :  memref<1x100xf64>, memref<5x100xf64>) outs(%O : memref<1x5xf64>) -> ()
   func.return
  }
}
```

Output from godbolt.org: 

```
#map = affine_map<(d0, d1, d2) -> (d0, d2)>
#map1 = affine_map<(d0, d1, d2) -> (d1, d2)>
#map2 = affine_map<(d0, d1, d2) -> (d0, d1)>
module {
  func.func @dispatch_8(%arg0: memref<1x100xf64>, %arg1: memref<5x100xf64>, %arg2: memref<1x5xf64>) {
    linalg.generic {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "reduction"]} ins(%arg0, %arg1 : memref<1x100xf64>, memref<5x100xf64>) outs(%arg2 : memref<1x5xf64>) {
    ^bb0(%in: f64, %in_0: f64, %out: f64):
      %0 = arith.mulf %in, %in_0 : f64
      %1 = arith.addf %out, %0 : f64
      linalg.yield %1 : f64
    }
    return
  }
}
```

#### Flat ZigZag-Tiled version in MLIR w/o IREE-specific stuff?

Copied and Pasted from `dispatch8-flat-zigzag/thread-level-tiling.mlir`:

```
%21 = linalg.matmul_transpose_b {lowering_config = #quidditch_snitch.lowering_config<
l1_tiles = [0, 200, 5], l1_tiles_interchange = [0, 1, 2], dual_buffer = true>} 
ins(%extracted_slice, %extracted_slice_6 : tensor<1x5xf64>, tensor<25x5xf64>) 
outs(%extracted_slice_7 : tensor<1x25xf64>) -> tensor<1x25xf64>       
```

Let's use godbolt.org on the following w/ flag `--linalg-generalize-named-ops`:

```
module {
  func.func @dispatch_8(%V : memref<1x5xf64>, %M : memref<25x5xf64>, %O : memref<1x25xf64>) {  
   linalg.matmul_transpose_b ins(%V, %M :  memref<1x5xf64>, memref<25x5xf64>) outs(%O : memref<1x25xf64>) -> ()
   func.return
  }
}
```

Output from godbolt.org: 

```
#map = affine_map<(d0, d1, d2) -> (d0, d2)>
#map1 = affine_map<(d0, d1, d2) -> (d1, d2)>
#map2 = affine_map<(d0, d1, d2) -> (d0, d1)>
module {
  func.func @dispatch_8(%arg0: memref<1x5xf64>, %arg1: memref<25x5xf64>, %arg2: memref<1x25xf64>) {
    linalg.generic {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "reduction"]} ins(%arg0, %arg1 : memref<1x5xf64>, memref<25x5xf64>) outs(%arg2 : memref<1x25xf64>) {
    ^bb0(%in: f64, %in_0: f64, %out: f64):
      %0 = arith.mulf %in, %in_0 : f64
      %1 = arith.addf %out, %0 : f64
      linalg.yield %1 : f64
    }
    return
  }
}
```
