builtin.module {
  riscv.assembly_section ".text" {
    riscv.directive ".globl" "dispatch_8"
    riscv.directive ".p2align" "2"
    riscv_func.func @dispatch_8(%arg0 : !riscv.reg<a0>, %arg1 : !riscv.reg<a1>, %arg2 : !riscv.reg<a2>) {
      %arg0_1 = riscv.mv %arg0 : (!riscv.reg<a0>) -> !riscv.reg
      %arg1_1 = riscv.mv %arg1 : (!riscv.reg<a1>) -> !riscv.reg
      %arg2_1 = riscv.mv %arg2 : (!riscv.reg<a2>) -> !riscv.reg
      snitch_stream.streaming_region {
        patterns = [
          #snitch_stream.stride_pattern<ub = [5, 5], strides = [0, 8], repeat = 5>,
          #snitch_stream.stride_pattern<ub = [5, 5, 5], strides = [200, 8, 40]>
        ]
      } ins(%arg0_1, %arg1_1 : !riscv.reg, !riscv.reg) {
      ^0(%in : !snitch.readable<!riscv.freg>, %in_1 : !snitch.readable<!riscv.freg>):
        %0 = riscv.li 0 : !riscv.reg
        %1 = riscv.li 1 : !riscv.reg
        %2 = riscv.li 2 : !riscv.reg
        %3 = riscv.li 3 : !riscv.reg
        %4 = riscv.li 4 : !riscv.reg
        %5 = riscv.li 5 : !riscv.reg
        %6 = riscv.li 5 : !riscv.reg
        %7 = riscv.li 0 : !riscv.reg
        %8 = riscv.li 1 : !riscv.reg
        riscv_scf.for %9 : !riscv.reg  = %7 to %5 step %8 {
          %10 = riscv.li 5 : !riscv.reg
          %11 = riscv.mul %9, %10 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %12 = riscv.add %11, %0 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride = riscv.li 25 : !riscv.reg
          %pointer_dim_offset = riscv.mul %7, %pointer_dim_stride : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset = riscv.add %pointer_dim_offset, %12 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset = riscv.mul %pointer_offset, %bytes_per_element {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer = riscv.add %arg2_1, %scaled_pointer_offset : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %13 = riscv.fld %offset_pointer, 0 {"comment" = "load double from memref of shape (1, 25)"} : (!riscv.reg) -> !riscv.freg
          %14 = riscv.li 5 : !riscv.reg
          %15 = riscv.mul %9, %14 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %16 = riscv.add %15, %1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_1 = riscv.li 25 : !riscv.reg
          %pointer_dim_offset_1 = riscv.mul %7, %pointer_dim_stride_1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_1 = riscv.add %pointer_dim_offset_1, %16 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_1 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_1 = riscv.mul %pointer_offset_1, %bytes_per_element_1 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_1 = riscv.add %arg2_1, %scaled_pointer_offset_1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %17 = riscv.fld %offset_pointer_1, 0 {"comment" = "load double from memref of shape (1, 25)"} : (!riscv.reg) -> !riscv.freg
          %18 = riscv.li 5 : !riscv.reg
          %19 = riscv.mul %9, %18 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %20 = riscv.add %19, %2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_2 = riscv.li 25 : !riscv.reg
          %pointer_dim_offset_2 = riscv.mul %7, %pointer_dim_stride_2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_2 = riscv.add %pointer_dim_offset_2, %20 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_2 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_2 = riscv.mul %pointer_offset_2, %bytes_per_element_2 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_2 = riscv.add %arg2_1, %scaled_pointer_offset_2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %21 = riscv.fld %offset_pointer_2, 0 {"comment" = "load double from memref of shape (1, 25)"} : (!riscv.reg) -> !riscv.freg
          %22 = riscv.li 5 : !riscv.reg
          %23 = riscv.mul %9, %22 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %24 = riscv.add %23, %3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_3 = riscv.li 25 : !riscv.reg
          %pointer_dim_offset_3 = riscv.mul %7, %pointer_dim_stride_3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_3 = riscv.add %pointer_dim_offset_3, %24 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_3 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_3 = riscv.mul %pointer_offset_3, %bytes_per_element_3 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_3 = riscv.add %arg2_1, %scaled_pointer_offset_3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %25 = riscv.fld %offset_pointer_3, 0 {"comment" = "load double from memref of shape (1, 25)"} : (!riscv.reg) -> !riscv.freg
          %26 = riscv.li 5 : !riscv.reg
          %27 = riscv.mul %9, %26 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %28 = riscv.add %27, %4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_4 = riscv.li 25 : !riscv.reg
          %pointer_dim_offset_4 = riscv.mul %7, %pointer_dim_stride_4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_4 = riscv.add %pointer_dim_offset_4, %28 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_4 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_4 = riscv.mul %pointer_offset_4, %bytes_per_element_4 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_4 = riscv.add %arg2_1, %scaled_pointer_offset_4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %29 = riscv.fld %offset_pointer_4, 0 {"comment" = "load double from memref of shape (1, 25)"} : (!riscv.reg) -> !riscv.freg
          %30 = riscv.fmv.d %13 : (!riscv.freg) -> !riscv.freg
          %31 = riscv.fmv.d %17 : (!riscv.freg) -> !riscv.freg
          %32 = riscv.fmv.d %21 : (!riscv.freg) -> !riscv.freg
          %33 = riscv.fmv.d %25 : (!riscv.freg) -> !riscv.freg
          %34 = riscv.fmv.d %29 : (!riscv.freg) -> !riscv.freg
          %35 = riscv.sub %6, %7 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %36 = riscv.addi %35, -1 : (!riscv.reg) -> !riscv.reg
          %37, %38, %39, %40, %41 = riscv_snitch.frep_outer %36 iter_args(%out = %30, %out_1 = %31, %out_2 = %32, %out_3 = %33, %out_4 = %34) -> (!riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg) {
            %in_2 = riscv_snitch.read from %in : !riscv.freg
            %in_3 = riscv_snitch.read from %in : !riscv.freg
            %in_4 = riscv_snitch.read from %in : !riscv.freg
            %in_5 = riscv_snitch.read from %in : !riscv.freg
            %in_6 = riscv_snitch.read from %in : !riscv.freg
            %in_7 = riscv_snitch.read from %in_1 : !riscv.freg
            %in_8 = riscv_snitch.read from %in_1 : !riscv.freg
            %in_9 = riscv_snitch.read from %in_1 : !riscv.freg
            %in_10 = riscv_snitch.read from %in_1 : !riscv.freg
            %in_11 = riscv_snitch.read from %in_1 : !riscv.freg
            %42 = riscv.fmul.d %in_2, %in_7 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %43 = riscv.fmul.d %in_3, %in_8 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %44 = riscv.fmul.d %in_4, %in_9 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %45 = riscv.fmul.d %in_5, %in_10 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %46 = riscv.fmul.d %in_6, %in_11 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %47 = riscv.fadd.d %out, %42 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %48 = riscv.fadd.d %out_1, %43 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %49 = riscv.fadd.d %out_2, %44 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %50 = riscv.fadd.d %out_3, %45 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %51 = riscv.fadd.d %out_4, %46 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            riscv_snitch.frep_yield %47, %48, %49, %50, %51 : !riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg
          }
          %52 = riscv.fmv.d %37 : (!riscv.freg) -> !riscv.freg
          %53 = riscv.fmv.d %38 : (!riscv.freg) -> !riscv.freg
          %54 = riscv.fmv.d %39 : (!riscv.freg) -> !riscv.freg
          %55 = riscv.fmv.d %40 : (!riscv.freg) -> !riscv.freg
          %56 = riscv.fmv.d %41 : (!riscv.freg) -> !riscv.freg
          %57 = riscv.li 5 : !riscv.reg
          %58 = riscv.mul %9, %57 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %59 = riscv.add %58, %0 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_5 = riscv.li 25 : !riscv.reg
          %pointer_dim_offset_5 = riscv.mul %7, %pointer_dim_stride_5 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_5 = riscv.add %pointer_dim_offset_5, %59 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_5 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_5 = riscv.mul %pointer_offset_5, %bytes_per_element_5 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_5 = riscv.add %arg2_1, %scaled_pointer_offset_5 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          riscv.fsd %offset_pointer_5, %52, 0 {"comment" = "store double value to memref of shape (1, 25)"} : (!riscv.reg, !riscv.freg) -> ()
          %60 = riscv.li 5 : !riscv.reg
          %61 = riscv.mul %9, %60 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %62 = riscv.add %61, %1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_6 = riscv.li 25 : !riscv.reg
          %pointer_dim_offset_6 = riscv.mul %7, %pointer_dim_stride_6 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_6 = riscv.add %pointer_dim_offset_6, %62 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_6 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_6 = riscv.mul %pointer_offset_6, %bytes_per_element_6 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_6 = riscv.add %arg2_1, %scaled_pointer_offset_6 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          riscv.fsd %offset_pointer_6, %53, 0 {"comment" = "store double value to memref of shape (1, 25)"} : (!riscv.reg, !riscv.freg) -> ()
          %63 = riscv.li 5 : !riscv.reg
          %64 = riscv.mul %9, %63 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %65 = riscv.add %64, %2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_7 = riscv.li 25 : !riscv.reg
          %pointer_dim_offset_7 = riscv.mul %7, %pointer_dim_stride_7 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_7 = riscv.add %pointer_dim_offset_7, %65 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_7 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_7 = riscv.mul %pointer_offset_7, %bytes_per_element_7 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_7 = riscv.add %arg2_1, %scaled_pointer_offset_7 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          riscv.fsd %offset_pointer_7, %54, 0 {"comment" = "store double value to memref of shape (1, 25)"} : (!riscv.reg, !riscv.freg) -> ()
          %66 = riscv.li 5 : !riscv.reg
          %67 = riscv.mul %9, %66 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %68 = riscv.add %67, %3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_8 = riscv.li 25 : !riscv.reg
          %pointer_dim_offset_8 = riscv.mul %7, %pointer_dim_stride_8 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_8 = riscv.add %pointer_dim_offset_8, %68 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_8 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_8 = riscv.mul %pointer_offset_8, %bytes_per_element_8 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_8 = riscv.add %arg2_1, %scaled_pointer_offset_8 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          riscv.fsd %offset_pointer_8, %55, 0 {"comment" = "store double value to memref of shape (1, 25)"} : (!riscv.reg, !riscv.freg) -> ()
          %69 = riscv.li 5 : !riscv.reg
          %70 = riscv.mul %9, %69 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %71 = riscv.add %70, %4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_9 = riscv.li 25 : !riscv.reg
          %pointer_dim_offset_9 = riscv.mul %7, %pointer_dim_stride_9 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_9 = riscv.add %pointer_dim_offset_9, %71 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_9 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_9 = riscv.mul %pointer_offset_9, %bytes_per_element_9 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_9 = riscv.add %arg2_1, %scaled_pointer_offset_9 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          riscv.fsd %offset_pointer_9, %56, 0 {"comment" = "store double value to memref of shape (1, 25)"} : (!riscv.reg, !riscv.freg) -> ()
        }
      }
      riscv_func.return
    }
  }
}
