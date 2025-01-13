<eval_with_key>.0 from /home/hoppip/Quidditch/venv/lib/python3.11/site-packages/torch/fx/experimental/proxy_tensor.py:551 in wrapped:105:0: warning: SLICEDCUCUMBER tiling level Thread This is the rewritten kernel!!!!!

/home/hoppip/Quidditch/runtime/samples/nsnet2/NsNet2.py:90:0: note: called from
<eval_with_key>.0 from /home/hoppip/Quidditch/venv/lib/python3.11/site-packages/torch/fx/experimental/proxy_tensor.py:551 in wrapped:105:0: note: see current operation: 
func.func @main$async_dispatch_8_matmul_transpose_b_1x600x600_f64() attributes {translation_info = #iree_codegen.translation_info<None>} {
  %c5 = arith.constant 5 : index
  %c200 = arith.constant 200 : index
  %c600 = arith.constant 600 : index
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
  %result, %token = dma.start_tensor_copy of %8 to #quidditch_snitch.l1_encoding  -> tensor<1x600xf64>
  %9 = dma.wait_for_tensor_copy of %8 : tensor<1x600xf64> to %result using %token -> tensor<1x600xf64>
  %10 = scf.forall (%arg0) = (0) to (600) step (75) shared_outs(%arg1 = %9) -> (tensor<1x600xf64>) {
    %extracted_slice = tensor.extract_slice %arg1[0, %arg0] [1, 75] [1, 1] : tensor<1x600xf64> to tensor<1x75xf64>
    %16 = linalg.fill ins(%cst : f64) outs(%extracted_slice : tensor<1x75xf64>) -> tensor<1x75xf64>
    scf.forall.in_parallel {
      tensor.parallel_insert_slice %16 into %arg1[0, %arg0] [1, 75] [1, 1] : tensor<1x75xf64> into tensor<1x600xf64>
    }
  }
  %11 = scf.for %arg0 = %c0 to %c600 step %c200 iter_args(%arg1 = %10) -> (tensor<1x600xf64>) {
    %16 = quidditch_snitch.pipeline %c0 to %c600 step %c5 inits(%arg1) -> tensor<1x600xf64> {
    ^bb0(%arg2: index, %arg3: tensor<1x600xf64>):
      %extracted_slice = tensor.extract_slice %5[0, %arg2] [1, 5] [1, 1] : tensor<1x600xf64> to tensor<1x5xf64>
      %result_6, %token_7 = dma.start_tensor_copy of %extracted_slice to #quidditch_snitch.l1_encoding  -> tensor<1x5xf64>
      %extracted_slice_8 = tensor.extract_slice %6[%arg0, %arg2] [200, 5] [1, 1] : tensor<600x600xf64> to tensor<200x5xf64>
      %result_9, %token_10 = dma.start_tensor_copy of %extracted_slice_8 to #quidditch_snitch.l1_encoding  -> tensor<200x5xf64>
      %extracted_slice_11 = tensor.extract_slice %arg3[0, %arg0] [1, 200] [1, 1] : tensor<1x600xf64> to tensor<1x200xf64>
      %result_12, %token_13 = dma.start_tensor_copy of %extracted_slice_11 to #quidditch_snitch.l1_encoding  -> tensor<1x200xf64>
      quidditch_snitch.pipeline_yield %arg3, %extracted_slice, %result_6, %token_7, %extracted_slice_8, %result_9, %token_10, %extracted_slice_11, %result_12, %token_13 : tensor<1x600xf64>, tensor<1x5xf64>, tensor<1x5xf64>, !dma.token, tensor<200x5xf64>, tensor<200x5xf64>, !dma.token, tensor<1x200xf64>, tensor<1x200xf64>, !dma.token
    }, {
    ^bb0(%arg2: index, %arg3: tensor<1x600xf64>, %arg4: tensor<1x5xf64>, %arg5: tensor<1x5xf64>, %arg6: !dma.token, %arg7: tensor<200x5xf64>, %arg8: tensor<200x5xf64>, %arg9: !dma.token, %arg10: tensor<1x200xf64>, %arg11: tensor<1x200xf64>, %arg12: !dma.token):
      %17 = dma.wait_for_tensor_copy of %arg4 : tensor<1x5xf64> to %arg5 using %arg6 -> tensor<1x5xf64>
      %18 = dma.wait_for_tensor_copy of %arg7 : tensor<200x5xf64> to %arg8 using %arg9 -> tensor<200x5xf64>
      %19 = dma.wait_for_tensor_copy of %arg10 : tensor<1x200xf64> to %arg11 using %arg12 -> tensor<1x200xf64>
      %20 = scf.forall (%arg13) = (0) to (200) step (25) shared_outs(%arg14 = %19) -> (tensor<1x200xf64>) {
        %extracted_slice = tensor.extract_slice %17[0, 0] [1, 5] [1, 1] : tensor<1x5xf64> to tensor<1x5xf64>
        %extracted_slice_6 = tensor.extract_slice %18[%arg13, 0] [25, 5] [1, 1] : tensor<200x5xf64> to tensor<25x5xf64>
        %extracted_slice_7 = tensor.extract_slice %arg14[0, %arg13] [1, 25] [1, 1] : tensor<1x200xf64> to tensor<1x25xf64>
        %21 = linalg.matmul_transpose_b {lowering_config = #quidditch_snitch.lowering_config<l1_tiles = [0, 200, 5], l1_tiles_interchange = [0, 1, 2], dual_buffer = true>} ins(%extracted_slice, %extracted_slice_6 : tensor<1x5xf64>, tensor<25x5xf64>) outs(%extracted_slice_7 : tensor<1x25xf64>) -> tensor<1x25xf64>
        scf.forall.in_parallel {
          tensor.parallel_insert_slice %21 into %arg14[0, %arg13] [1, 25] [1, 1] : tensor<1x25xf64> into tensor<1x200xf64>
        }
      }
      %inserted_slice = tensor.insert_slice %20 into %arg3[0, %arg0] [1, 200] [1, 1] : tensor<1x200xf64> into tensor<1x600xf64>
      quidditch_snitch.pipeline_yield %inserted_slice : tensor<1x600xf64>
    }
    scf.yield %16 : tensor<1x600xf64>
  }
  %result_0, %token_1 = dma.start_tensor_copy of %11 to #quidditch_snitch.l1_encoding  -> tensor<1x600xf64>
  %12 = dma.wait_for_tensor_copy of %11 : tensor<1x600xf64> to %result_0 using %token_1 -> tensor<1x600xf64>
  %result_2, %token_3 = dma.start_tensor_copy of %7 to #quidditch_snitch.l1_encoding  -> tensor<1x600xf64>
  %13 = dma.wait_for_tensor_copy of %7 : tensor<1x600xf64> to %result_2 using %token_3 -> tensor<1x600xf64>
  %result_4, %token_5 = dma.start_tensor_copy of %4 to #quidditch_snitch.l1_encoding  -> tensor<1x600xf64>
  %14 = dma.wait_for_tensor_copy of %4 : tensor<1x600xf64> to %result_4 using %token_5 -> tensor<1x600xf64>
  %15 = scf.forall (%arg0) = (0) to (600) step (75) shared_outs(%arg1 = %14) -> (tensor<1x600xf64>) {
    %extracted_slice = tensor.extract_slice %12[0, %arg0] [1, 75] [1, 1] : tensor<1x600xf64> to tensor<1x75xf64>
    %extracted_slice_6 = tensor.extract_slice %13[0, %arg0] [1, 75] [1, 1] : tensor<1x600xf64> to tensor<1x75xf64>
    %extracted_slice_7 = tensor.extract_slice %arg1[0, %arg0] [1, 75] [1, 1] : tensor<1x600xf64> to tensor<1x75xf64>
    %16 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice, %extracted_slice_6 : tensor<1x75xf64>, tensor<1x75xf64>) outs(%extracted_slice_7 : tensor<1x75xf64>) {
    ^bb0(%in: f64, %in_8: f64, %out: f64):
      %17 = arith.addf %in, %in_8 : f64
      %18 = arith.cmpf ugt, %17, %cst : f64
      %19 = arith.select %18, %17, %cst : f64
      linalg.yield %19 : f64
    } -> tensor<1x75xf64>
    scf.forall.in_parallel {
      tensor.parallel_insert_slice %16 into %arg1[0, %arg0] [1, 75] [1, 1] : tensor<1x75xf64> into tensor<1x600xf64>
    }
  }
  flow.dispatch.tensor.store %15, %3, offsets = [0, 0], sizes = [1, 600], strides = [1, 1] : tensor<1x600xf64> -> !flow.dispatch.tensor<writeonly:tensor<1x600xf64>>
  return
}
