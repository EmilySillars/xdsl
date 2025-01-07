# Thread Tiling Notes

The outermost loop breaks the input into 8 pieces...

```
  %10 = scf.forall (%arg0) = (0) to (600) step (75) shared_outs(%arg1 = %9) -> (tensor<1x600xf64>) {
    %extracted_slice = tensor.extract_slice %arg1[0, %arg0] [1, 75] [1, 1] : tensor<1x600xf64> to tensor<1x75xf64>
    %16 = linalg.fill ins(%cst : f64) outs(%extracted_slice : tensor<1x75xf64>) -> tensor<1x75xf64>
    scf.forall.in_parallel {
      tensor.parallel_insert_slice %16 into %arg1[0, %arg0] [1, 75] [1, 1] : tensor<1x75xf64> into tensor<1x600xf64>
    }
  }
  %11 = scf.for %arg0 = %c0 to %c600 step %c100 iter_args(%arg1 = %10) -> (tensor<1x600xf64>) {
    %extracted_slice = tensor.extract_slice %5[0, %arg0] [1, 100] [1, 1] : tensor<1x600xf64> to tensor<1x100xf64>
    %result_6, %token_7 = dma.start_tensor_copy of %extracted_slice to #quidditch_snitch.l1_encoding  -> tensor<1x100xf64>
    %16 = dma.wait_for_tensor_copy of %extracted_slice : tensor<1x100xf64> to %result_6 using %token_7 -> tensor<1x100xf64>
    %17 = quidditch_snitch.pipeline %c0 to %c600 step %c40 inits(%arg1) -> tensor<1x600xf64> {
    ^bb0(%arg2: index, %arg3: tensor<1x600xf64>):
      %extracted_slice_8 = tensor.extract_slice %6[%arg2, %arg0] [40, 100] [1, 1] : tensor<600x600xf64> to tensor<40x100xf64>
      %result_9, %token_10 = dma.start_tensor_copy of %extracted_slice_8 to #quidditch_snitch.l1_encoding  -> tensor<40x100xf64>
      %extracted_slice_11 = tensor.extract_slice %arg3[0, %arg2] [1, 40] [1, 1] : tensor<1x600xf64> to tensor<1x40xf64>
      %result_12, %token_13 = dma.start_tensor_copy of %extracted_slice_11 to #quidditch_snitch.l1_encoding  -> tensor<1x40xf64>
      quidditch_snitch.pipeline_yield %arg3, %extracted_slice_8, %result_9, %token_10, %extracted_slice_11, %result_12, %token_13 : tensor<1x600xf64>, tensor<40x100xf64>, tensor<40x100xf64>, !dma.token, tensor<1x40xf64>, tensor<1x40xf64>, !dma.token
    }, {
    ^bb0(%arg2: index, %arg3: tensor<1x600xf64>, %arg4: tensor<40x100xf64>, %arg5: tensor<40x100xf64>, %arg6: !dma.token, %arg7: tensor<1x40xf64>, %arg8: tensor<1x40xf64>, %arg9: !dma.token):
      %18 = dma.wait_for_tensor_copy of %arg4 : tensor<40x100xf64> to %arg5 using %arg6 -> tensor<40x100xf64>
      %19 = dma.wait_for_tensor_copy of %arg7 : tensor<1x40xf64> to %arg8 using %arg9 -> tensor<1x40xf64>
      %20 = scf.forall (%arg10) = (0) to (40) step (5) shared_outs(%arg11 = %19) -> (tensor<1x40xf64>) {
        %extracted_slice_8 = tensor.extract_slice %16[0, 0] [1, 100] [1, 1] : tensor<1x100xf64> to tensor<1x100xf64>
        %extracted_slice_9 = tensor.extract_slice %18[%arg10, 0] [5, 100] [1, 1] : tensor<40x100xf64> to tensor<5x100xf64>
        %extracted_slice_10 = tensor.extract_slice %arg11[0, %arg10] [1, 5] [1, 1] : tensor<1x40xf64> to tensor<1x5xf64>
        %21 = linalg.matmul_transpose_b {lowering_config = #quidditch_snitch.lowering_config<l1_tiles = [0, 40, 100], l1_tiles_interchange = [2, 0, 1], dual_buffer = true>} ins(%extracted_slice_8, %extracted_slice_9 : tensor<1x100xf64>, tensor<5x100xf64>) outs(%extracted_slice_10 : tensor<1x5xf64>) -> tensor<1x5xf64>
        scf.forall.in_parallel {
          tensor.parallel_insert_slice %21 into %arg11[0, %arg10] [1, 5] [1, 1] : tensor<1x5xf64> into tensor<1x40xf64>
        }
      }
      %inserted_slice = tensor.insert_slice %20 into %arg3[0, %arg2] [1, 40] [1, 1] : tensor<1x40xf64> into tensor<1x600xf64>
      quidditch_snitch.pipeline_yield %inserted_slice : tensor<1x600xf64>
    }
    scf.yield %17 : tensor<1x600xf64>
  }
```

For each of the 8 pieces, do the following:

```
  %11 = scf.for %arg0 = %c0 to %c600 step %c100 iter_args(%arg1 = %10) -> (tensor<1x600xf64>) {
    %extracted_slice = tensor.extract_slice %5[0, %arg0] [1, 100] [1, 1] : tensor<1x600xf64> to tensor<1x100xf64>
    %result_6, %token_7 = dma.start_tensor_copy of %extracted_slice to #quidditch_snitch.l1_encoding  -> tensor<1x100xf64>
    %16 = dma.wait_for_tensor_copy of %extracted_slice : tensor<1x100xf64> to %result_6 using %token_7 -> tensor<1x100xf64>
    %17 = quidditch_snitch.pipeline %c0 to %c600 step %c40 inits(%arg1) -> tensor<1x600xf64> {
    ^bb0(%arg2: index, %arg3: tensor<1x600xf64>):
      %extracted_slice_8 = tensor.extract_slice %6[%arg2, %arg0] [40, 100] [1, 1] : tensor<600x600xf64> to tensor<40x100xf64>
      %result_9, %token_10 = dma.start_tensor_copy of %extracted_slice_8 to #quidditch_snitch.l1_encoding  -> tensor<40x100xf64>
      %extracted_slice_11 = tensor.extract_slice %arg3[0, %arg2] [1, 40] [1, 1] : tensor<1x600xf64> to tensor<1x40xf64>
      %result_12, %token_13 = dma.start_tensor_copy of %extracted_slice_11 to #quidditch_snitch.l1_encoding  -> tensor<1x40xf64>
      quidditch_snitch.pipeline_yield %arg3, %extracted_slice_8, %result_9, %token_10, %extracted_slice_11, %result_12, %token_13 : tensor<1x600xf64>, tensor<40x100xf64>, tensor<40x100xf64>, !dma.token, tensor<1x40xf64>, tensor<1x40xf64>, !dma.token
    }, {
    ^bb0(%arg2: index, %arg3: tensor<1x600xf64>, %arg4: tensor<40x100xf64>, %arg5: tensor<40x100xf64>, %arg6: !dma.token, %arg7: tensor<1x40xf64>, %arg8: tensor<1x40xf64>, %arg9: !dma.token):
      %18 = dma.wait_for_tensor_copy of %arg4 : tensor<40x100xf64> to %arg5 using %arg6 -> tensor<40x100xf64>
      %19 = dma.wait_for_tensor_copy of %arg7 : tensor<1x40xf64> to %arg8 using %arg9 -> tensor<1x40xf64>
      %20 = scf.forall (%arg10) = (0) to (40) step (5) shared_outs(%arg11 = %19) -> (tensor<1x40xf64>) {
        %extracted_slice_8 = tensor.extract_slice %16[0, 0] [1, 100] [1, 1] : tensor<1x100xf64> to tensor<1x100xf64>
        %extracted_slice_9 = tensor.extract_slice %18[%arg10, 0] [5, 100] [1, 1] : tensor<40x100xf64> to tensor<5x100xf64>
        %extracted_slice_10 = tensor.extract_slice %arg11[0, %arg10] [1, 5] [1, 1] : tensor<1x40xf64> to tensor<1x5xf64>
        %21 = linalg.matmul_transpose_b {lowering_config = #quidditch_snitch.lowering_config<l1_tiles = [0, 40, 100], l1_tiles_interchange = [2, 0, 1], dual_buffer = true>} ins(%extracted_slice_8, %extracted_slice_9 : tensor<1x100xf64>, tensor<5x100xf64>) outs(%extracted_slice_10 : tensor<1x5xf64>) -> tensor<1x5xf64>
        scf.forall.in_parallel {
          tensor.parallel_insert_slice %21 into %arg11[0, %arg10] [1, 5] [1, 1] : tensor<1x5xf64> into tensor<1x40xf64>
        }
      }
      %inserted_slice = tensor.insert_slice %20 into %arg3[0, %arg2] [1, 40] [1, 1] : tensor<1x40xf64> into tensor<1x600xf64>
      quidditch_snitch.pipeline_yield %inserted_slice : tensor<1x600xf64>
    }
    scf.yield %17 : tensor<1x600xf64>
  }
```

#### How can I cut and splice this together s.t. the xDSL interpreter can handle it?

Let's create a dummy function signature and try feeding it in...

If that works out okay, feed in with a more interesting body.

Tiling without the DMA calls and without the 
