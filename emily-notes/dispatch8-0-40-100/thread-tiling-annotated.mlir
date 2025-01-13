func.func @main$async_dispatch_8_matmul_transpose_b_1x600x600_f64() attributes {translation_info = #iree_codegen.translation_info<None>} {
  %c40 = arith.constant 40 : index
  %c100 = arith.constant 100 : index
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
  
  // The following chunk of code is done in preparation for the vector addition operation vvvvvv
  // Copy an empty vector 1x600 into L1.
  %8 = tensor.empty() : tensor<1x600xf64>
  %result, %token = dma.start_tensor_copy of %8 to #quidditch_snitch.l1_encoding  -> tensor<1x600xf64>
  %9 = dma.wait_for_tensor_copy of %8 : tensor<1x600xf64> to %result using %token -> tensor<1x600xf64>
  // Break the 1x600 vector into 15 tiles of size <1x75>,
  // Fill each of these 15 <1x75> subtiles with the value 0
  %10 = scf.forall (%arg0) = (0) to (600) step (75) shared_outs(%arg1 = %9) -> (tensor<1x600xf64>) {
    %extracted_slice = tensor.extract_slice %arg1[0, %arg0] [1, 75] [1, 1] : tensor<1x600xf64> to tensor<1x75xf64>
    %16 = linalg.fill ins(%cst : f64) outs(%extracted_slice : tensor<1x75xf64>) -> tensor<1x75xf64>
    scf.forall.in_parallel {
      tensor.parallel_insert_slice %16 into %arg1[0, %arg0] [1, 75] [1, 1] : tensor<1x75xf64> into tensor<1x600xf64>
    }
  }
  // Done in preparation for vector addition  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  // break the input vector <1x600> into 6 tiles of size <1x100>,
  // and copy each <1x100> tile to L1
  %11 = scf.for %arg0 = %c0 to %c600 step %c100 iter_args(%arg1 = %10) -> (tensor<1x600xf64>) {
    %extracted_slice = tensor.extract_slice %5[0, %arg0] [1, 100] [1, 1] : tensor<1x600xf64> to tensor<1x100xf64>
    %result_6, %token_7 = dma.start_tensor_copy of %extracted_slice to #quidditch_snitch.l1_encoding  -> tensor<1x100xf64>
    %16 = dma.wait_for_tensor_copy of %extracted_slice : tensor<1x100xf64> to %result_6 using %token_7 -> tensor<1x100xf64>

    // break the weight matrix <600x600> into 90 tiles of size <40x100>, and copy them each to L1.
    // note: how do we know it's 90 tiles? Because 600 / 40 = 15, and 600 / 100 = 6, and 6 * 15 = 90.
    %17 = quidditch_snitch.pipeline %c0 to %c600 step %c40 inits(%arg1) -> tensor<1x600xf64> {
    ^bb0(%arg2: index, %arg3: tensor<1x600xf64>):
      %extracted_slice_8 = tensor.extract_slice %6[%arg2, %arg0] [40, 100] [1, 1] : tensor<600x600xf64> to tensor<40x100xf64>
      %result_9, %token_10 = dma.start_tensor_copy of %extracted_slice_8 to #quidditch_snitch.l1_encoding  -> tensor<40x100xf64>
     
     // break the zeroed-out vector of size <1x600> that is already in L1 into 15 slices of size <1x40> and copy into L1 (?)
     // NOTE: this <1x600> vector is only set to zero the VERY FIRST TIME this loop executes!
     // the NEXT time the loop executes, the <1x600> vector will hold intermediate results, and a new weight matrix subtile will be used!
      %extracted_slice_11 = tensor.extract_slice %arg3[0, %arg2] [1, 40] [1, 1] : tensor<1x600xf64> to tensor<1x40xf64>
      %result_12, %token_13 = dma.start_tensor_copy of %extracted_slice_11 to #quidditch_snitch.l1_encoding  -> tensor<1x40xf64>
      quidditch_snitch.pipeline_yield %arg3, %extracted_slice_8, %result_9, %token_10, %extracted_slice_11, %result_12, %token_13 : tensor<1x600xf64>, tensor<40x100xf64>, tensor<40x100xf64>, !dma.token, tensor<1x40xf64>, tensor<1x40xf64>, !dma.token
    }, {
      
    ^bb0(%arg2: index, %arg3: tensor<1x600xf64>, %arg4: tensor<40x100xf64>, %arg5: tensor<40x100xf64>, %arg6: !dma.token, %arg7: tensor<1x40xf64>, %arg8: tensor<1x40xf64>, %arg9: !dma.token):
      %18 = dma.wait_for_tensor_copy of %arg4 : tensor<40x100xf64> to %arg5 using %arg6 -> tensor<40x100xf64>
      %19 = dma.wait_for_tensor_copy of %arg7 : tensor<1x40xf64> to %arg8 using %arg9 -> tensor<1x40xf64>
      
      // compute core work vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
      // give each compute core 
      //     - a weight matrix subtile of size <5x100> (different subtile of weight matrix sent to each core)
      //     - an input vector subtile of size <1x100> (same input vector sent to all cores, because selected in outer loop)
      //     - a zeroed-out output vector subtile of size <1x5> (different output vector subtile sent to each core)
      %20 = scf.forall (%arg10) = (0) to (40) step (5) shared_outs(%arg11 = %19) -> (tensor<1x40xf64>) {
        // seems to select an input vector tile of size <1x100>??
        %extracted_slice_8 = tensor.extract_slice %16[0, 0] [1, 100] [1, 1] : tensor<1x100xf64> to tensor<1x100xf64>
        // break weight matrix subtile size <40x100> into 8 tiles of <5x100>
        %extracted_slice_9 = tensor.extract_slice %18[%arg10, 0] [5, 100] [1, 1] : tensor<40x100xf64> to tensor<5x100xf64>
        // select a zeroed-out subtile of size <1x40> and break into smaller subtiles of 1x5
        // NOTE: the subtile <1x40> is ONLY SET TO ZERO the FIRST TIME THIS LOOP EXECUTES
        %extracted_slice_10 = tensor.extract_slice %arg11[0, %arg10] [1, 5] [1, 1] : tensor<1x40xf64> to tensor<1x5xf64>
        // perform the computation that yields a result subtile of <1x5>
        %21 = linalg.matmul_transpose_b {lowering_config = #quidditch_snitch.lowering_config<l1_tiles = [0, 40, 100], l1_tiles_interchange = [2, 0, 1], dual_buffer = true>} 
        ins(%extracted_slice_8, %extracted_slice_9 : tensor<1x100xf64>, tensor<5x100xf64>) outs(%extracted_slice_10 : tensor<1x5xf64>) -> tensor<1x5xf64>
        // copy <1x5> result from compute core into the output vector subtile of size <1x40>
        scf.forall.in_parallel {
          tensor.parallel_insert_slice %21 into %arg11[0, %arg10] [1, 5] [1, 1] : tensor<1x5xf64> into tensor<1x40xf64>
        }
      }
      // compute core work ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

      // copy accumulated 1x40 size result subtile into the <1x600> result
      %inserted_slice = tensor.insert_slice %20 into %arg3[0, %arg2] [1, 40] [1, 1] : tensor<1x40xf64> into tensor<1x600xf64>
      quidditch_snitch.pipeline_yield %inserted_slice : tensor<1x600xf64>
    }
    scf.yield %17 : tensor<1x600xf64>
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
