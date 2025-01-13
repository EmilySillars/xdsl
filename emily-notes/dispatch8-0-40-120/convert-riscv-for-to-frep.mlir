builtin.module {
  riscv.assembly_section ".text" {
    riscv.directive ".globl" "dispatch8_0_40_120"
    riscv.directive ".p2align" "2"
    riscv_func.func @dispatch8_0_40_120(%arg0 : !riscv.reg<a0>, %arg1 : !riscv.reg<a1>, %arg2 : !riscv.reg<a2>) {
      %arg0_1 = riscv.mv %arg0 : (!riscv.reg<a0>) -> !riscv.reg
      %arg1_1 = riscv.mv %arg1 : (!riscv.reg<a1>) -> !riscv.reg
      %arg2_1 = riscv.mv %arg2 : (!riscv.reg<a2>) -> !riscv.reg
      snitch_stream.streaming_region {
        patterns = [
          #snitch_stream.stride_pattern<ub = [120], strides = [8], repeat = 5>,
          #snitch_stream.stride_pattern<ub = [120, 5], strides = [8, 960]>
        ]
      } ins(%arg0_1, %arg1_1 : !riscv.reg, !riscv.reg) {
      ^0(%in : !snitch.readable<!riscv.freg>, %in_1 : !snitch.readable<!riscv.freg>):
        %0 = riscv.li 0 : !riscv.reg
        %1 = riscv.li 1 : !riscv.reg
        %2 = riscv.li 2 : !riscv.reg
        %3 = riscv.li 3 : !riscv.reg
        %4 = riscv.li 4 : !riscv.reg
        %5 = riscv.li 120 : !riscv.reg
        %6 = riscv.li 0 : !riscv.reg
        %7 = riscv.li 1 : !riscv.reg
        %8 = riscv.li 5 : !riscv.reg
        %9 = riscv.mul %6, %8 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %10 = riscv.add %9, %0 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_dim_stride = riscv.li 5 : !riscv.reg
        %pointer_dim_offset = riscv.mul %6, %pointer_dim_stride : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_offset = riscv.add %pointer_dim_offset, %10 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %bytes_per_element = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset = riscv.mul %pointer_offset, %bytes_per_element {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer = riscv.add %arg2_1, %scaled_pointer_offset : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %11 = riscv.fld %offset_pointer, 0 {"comment" = "load double from memref of shape (1, 5)"} : (!riscv.reg) -> !riscv.freg
        %12 = riscv.li 5 : !riscv.reg
        %13 = riscv.mul %6, %12 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %14 = riscv.add %13, %1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_dim_stride_1 = riscv.li 5 : !riscv.reg
        %pointer_dim_offset_1 = riscv.mul %6, %pointer_dim_stride_1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_offset_1 = riscv.add %pointer_dim_offset_1, %14 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %bytes_per_element_1 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_1 = riscv.mul %pointer_offset_1, %bytes_per_element_1 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_1 = riscv.add %arg2_1, %scaled_pointer_offset_1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %15 = riscv.fld %offset_pointer_1, 0 {"comment" = "load double from memref of shape (1, 5)"} : (!riscv.reg) -> !riscv.freg
        %16 = riscv.li 5 : !riscv.reg
        %17 = riscv.mul %6, %16 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %18 = riscv.add %17, %2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_dim_stride_2 = riscv.li 5 : !riscv.reg
        %pointer_dim_offset_2 = riscv.mul %6, %pointer_dim_stride_2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_offset_2 = riscv.add %pointer_dim_offset_2, %18 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %bytes_per_element_2 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_2 = riscv.mul %pointer_offset_2, %bytes_per_element_2 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_2 = riscv.add %arg2_1, %scaled_pointer_offset_2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %19 = riscv.fld %offset_pointer_2, 0 {"comment" = "load double from memref of shape (1, 5)"} : (!riscv.reg) -> !riscv.freg
        %20 = riscv.li 5 : !riscv.reg
        %21 = riscv.mul %6, %20 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %22 = riscv.add %21, %3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_dim_stride_3 = riscv.li 5 : !riscv.reg
        %pointer_dim_offset_3 = riscv.mul %6, %pointer_dim_stride_3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_offset_3 = riscv.add %pointer_dim_offset_3, %22 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %bytes_per_element_3 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_3 = riscv.mul %pointer_offset_3, %bytes_per_element_3 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_3 = riscv.add %arg2_1, %scaled_pointer_offset_3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %23 = riscv.fld %offset_pointer_3, 0 {"comment" = "load double from memref of shape (1, 5)"} : (!riscv.reg) -> !riscv.freg
        %24 = riscv.li 5 : !riscv.reg
        %25 = riscv.mul %6, %24 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %26 = riscv.add %25, %4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_dim_stride_4 = riscv.li 5 : !riscv.reg
        %pointer_dim_offset_4 = riscv.mul %6, %pointer_dim_stride_4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_offset_4 = riscv.add %pointer_dim_offset_4, %26 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %bytes_per_element_4 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_4 = riscv.mul %pointer_offset_4, %bytes_per_element_4 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_4 = riscv.add %arg2_1, %scaled_pointer_offset_4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %27 = riscv.fld %offset_pointer_4, 0 {"comment" = "load double from memref of shape (1, 5)"} : (!riscv.reg) -> !riscv.freg
        %28 = riscv.fmv.d %11 : (!riscv.freg) -> !riscv.freg
        %29 = riscv.fmv.d %15 : (!riscv.freg) -> !riscv.freg
        %30 = riscv.fmv.d %19 : (!riscv.freg) -> !riscv.freg
        %31 = riscv.fmv.d %23 : (!riscv.freg) -> !riscv.freg
        %32 = riscv.fmv.d %27 : (!riscv.freg) -> !riscv.freg
        %33 = riscv.sub %5, %6 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %34 = riscv.addi %33, -1 : (!riscv.reg) -> !riscv.reg
        %35, %36, %37, %38, %39 = riscv_snitch.frep_outer %34 iter_args(%out = %28, %out_1 = %29, %out_2 = %30, %out_3 = %31, %out_4 = %32) -> (!riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg) {
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
          %40 = riscv.fmul.d %in_2, %in_7 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
          %41 = riscv.fmul.d %in_3, %in_8 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
          %42 = riscv.fmul.d %in_4, %in_9 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
          %43 = riscv.fmul.d %in_5, %in_10 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
          %44 = riscv.fmul.d %in_6, %in_11 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
          %45 = riscv.fadd.d %out, %40 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
          %46 = riscv.fadd.d %out_1, %41 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
          %47 = riscv.fadd.d %out_2, %42 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
          %48 = riscv.fadd.d %out_3, %43 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
          %49 = riscv.fadd.d %out_4, %44 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
          riscv_snitch.frep_yield %45, %46, %47, %48, %49 : !riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg
        }
        %50 = riscv.fmv.d %35 : (!riscv.freg) -> !riscv.freg
        %51 = riscv.fmv.d %36 : (!riscv.freg) -> !riscv.freg
        %52 = riscv.fmv.d %37 : (!riscv.freg) -> !riscv.freg
        %53 = riscv.fmv.d %38 : (!riscv.freg) -> !riscv.freg
        %54 = riscv.fmv.d %39 : (!riscv.freg) -> !riscv.freg
        %55 = riscv.li 5 : !riscv.reg
        %56 = riscv.mul %6, %55 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %57 = riscv.add %56, %0 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_dim_stride_5 = riscv.li 5 : !riscv.reg
        %pointer_dim_offset_5 = riscv.mul %6, %pointer_dim_stride_5 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_offset_5 = riscv.add %pointer_dim_offset_5, %57 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %bytes_per_element_5 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_5 = riscv.mul %pointer_offset_5, %bytes_per_element_5 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_5 = riscv.add %arg2_1, %scaled_pointer_offset_5 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        riscv.fsd %offset_pointer_5, %50, 0 {"comment" = "store double value to memref of shape (1, 5)"} : (!riscv.reg, !riscv.freg) -> ()
        %58 = riscv.li 5 : !riscv.reg
        %59 = riscv.mul %6, %58 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %60 = riscv.add %59, %1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_dim_stride_6 = riscv.li 5 : !riscv.reg
        %pointer_dim_offset_6 = riscv.mul %6, %pointer_dim_stride_6 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_offset_6 = riscv.add %pointer_dim_offset_6, %60 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %bytes_per_element_6 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_6 = riscv.mul %pointer_offset_6, %bytes_per_element_6 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_6 = riscv.add %arg2_1, %scaled_pointer_offset_6 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        riscv.fsd %offset_pointer_6, %51, 0 {"comment" = "store double value to memref of shape (1, 5)"} : (!riscv.reg, !riscv.freg) -> ()
        %61 = riscv.li 5 : !riscv.reg
        %62 = riscv.mul %6, %61 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %63 = riscv.add %62, %2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_dim_stride_7 = riscv.li 5 : !riscv.reg
        %pointer_dim_offset_7 = riscv.mul %6, %pointer_dim_stride_7 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_offset_7 = riscv.add %pointer_dim_offset_7, %63 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %bytes_per_element_7 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_7 = riscv.mul %pointer_offset_7, %bytes_per_element_7 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_7 = riscv.add %arg2_1, %scaled_pointer_offset_7 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        riscv.fsd %offset_pointer_7, %52, 0 {"comment" = "store double value to memref of shape (1, 5)"} : (!riscv.reg, !riscv.freg) -> ()
        %64 = riscv.li 5 : !riscv.reg
        %65 = riscv.mul %6, %64 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %66 = riscv.add %65, %3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_dim_stride_8 = riscv.li 5 : !riscv.reg
        %pointer_dim_offset_8 = riscv.mul %6, %pointer_dim_stride_8 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_offset_8 = riscv.add %pointer_dim_offset_8, %66 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %bytes_per_element_8 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_8 = riscv.mul %pointer_offset_8, %bytes_per_element_8 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_8 = riscv.add %arg2_1, %scaled_pointer_offset_8 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        riscv.fsd %offset_pointer_8, %53, 0 {"comment" = "store double value to memref of shape (1, 5)"} : (!riscv.reg, !riscv.freg) -> ()
        %67 = riscv.li 5 : !riscv.reg
        %68 = riscv.mul %6, %67 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %69 = riscv.add %68, %4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_dim_stride_9 = riscv.li 5 : !riscv.reg
        %pointer_dim_offset_9 = riscv.mul %6, %pointer_dim_stride_9 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %pointer_offset_9 = riscv.add %pointer_dim_offset_9, %69 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %bytes_per_element_9 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_9 = riscv.mul %pointer_offset_9, %bytes_per_element_9 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_9 = riscv.add %arg2_1, %scaled_pointer_offset_9 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        riscv.fsd %offset_pointer_9, %54, 0 {"comment" = "store double value to memref of shape (1, 5)"} : (!riscv.reg, !riscv.freg) -> ()
      }
      riscv_func.return
    }
  }
}
