func.func @main$async_dispatch_8_matmul_transpose_b_1x600x600_f64() attributes {translation_info = #iree_codegen.translation_info<None>} {
  %cst = arith.constant 0.000000e+00 : f64
  %c0 = arith.constant 0 : index
  %c17841600 = arith.constant 17841600 : index
  %c20721600 = arith.constant 20721600 : index
  %c4800 = arith.constant 4800 : index
  %0 = hal.interface.binding.subspan set(0) binding(0) type(storage_buffer) alignment(64) offset(%c0) flags(ReadOnly) : !flow.dispatch.tensor<readonly:tensor<1x600xf64>>
  %1 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) alignment(64) offset(%c17841600) flags(ReadOnly) : !flow.dispatch.tensor<readonly:tensor<600x600xf64>>
  %2 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) alignment(64) offset(%c20721600) flags(ReadOnly) : !flow.dispatch.tensor<readonly:tensor<1x600xf64>>
  %3 = hal.interface.binding.subspan set(0) binding(2) type(storage_buffer) alignment(64) offset(%c4800) : !flow.dispatch.tensor<writeonly:tensor<1x600xf64>>
  %4 = flow.dispatch.tensor.load %3, offsets = [0, 0], sizes = [1, 600], strides = [1, 1] : !flow.dispatch.tensor<writeonly:tensor<1x600xf64>> -> tensor<1x600xf64>
  %5 = flow.dispatch.tensor.load %0, offsets = [0, 0], sizes = [1, 600], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<1x600xf64>> -> tensor<1x600xf64>
  %6 = flow.dispatch.tensor.load %1, offsets = [0, 0], sizes = [600, 600], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<600x600xf64>> -> tensor<600x600xf64>
  %7 = flow.dispatch.tensor.load %2, offsets = [0, 0], sizes = [1, 600], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<1x600xf64>> -> tensor<1x600xf64>
  %8 = tensor.empty() : tensor<1x600xf64>
  %9 = linalg.fill ins(%cst : f64) outs(%8 : tensor<1x600xf64>) -> tensor<1x600xf64>
  %c0_0 = arith.constant 0 : index
  %c600 = arith.constant 600 : index
  %c100 = arith.constant 100 : index
  %10 = scf.for %arg0 = %c0_0 to %c600 step %c100 iter_args(%arg1 = %9) -> (tensor<1x600xf64>) {
    %c0_1 = arith.constant 0 : index
    %c600_2 = arith.constant 600 : index
    %c40 = arith.constant 40 : index
    %12 = scf.for %arg2 = %c0_1 to %c600_2 step %c40 iter_args(%arg3 = %arg1) -> (tensor<1x600xf64>) {
      %extracted_slice = tensor.extract_slice %5[0, %arg0] [1, 100] [1, 1] : tensor<1x600xf64> to tensor<1x100xf64>
      %extracted_slice_3 = tensor.extract_slice %6[%arg2, %arg0] [40, 100] [1, 1] : tensor<600x600xf64> to tensor<40x100xf64>
      %extracted_slice_4 = tensor.extract_slice %arg3[0, %arg2] [1, 40] [1, 1] : tensor<1x600xf64> to tensor<1x40xf64>
      %13 = linalg.matmul_transpose_b {lowering_config = #quidditch_snitch.lowering_config<l1_tiles = [0, 40, 100], l1_tiles_interchange = [2, 0, 1], dual_buffer = true>} ins(%extracted_slice, %extracted_slice_3 : tensor<1x100xf64>, tensor<40x100xf64>) outs(%extracted_slice_4 : tensor<1x40xf64>) -> tensor<1x40xf64>
      %inserted_slice = tensor.insert_slice %13 into %arg3[0, %arg2] [1, 40] [1, 1] : tensor<1x40xf64> into tensor<1x600xf64>
      scf.yield %inserted_slice : tensor<1x600xf64>
    }
    scf.yield %12 : tensor<1x600xf64>
  }
  %11 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%10, %7 : tensor<1x600xf64>, tensor<1x600xf64>) outs(%4 : tensor<1x600xf64>) {
  ^bb0(%in: f64, %in_1: f64, %out: f64):
    %12 = arith.addf %in, %in_1 : f64
    %13 = arith.cmpf ugt, %12, %cst : f64
    %14 = arith.select %13, %12, %cst : f64
    linalg.yield %14 : f64
  } -> tensor<1x600xf64>
  flow.dispatch.tensor.store %11, %3, offsets = [0, 0], sizes = [1, 600], strides = [1, 1] : tensor<1x600xf64> -> !flow.dispatch.tensor<writeonly:tensor<1x600xf64>>
  return
}
