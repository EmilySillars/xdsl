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
          #snitch_stream.stride_pattern<ub = [150, 600], strides = [0, 8], repeat = 4>,
          #snitch_stream.stride_pattern<ub = [150, 600, 4], strides = [19200, 8, 4800]>
        ]
      } ins(%arg0_1, %arg1_1 : !riscv.reg, !riscv.reg) {
      ^0(%in : !snitch.readable<!riscv.freg>, %in_1 : !snitch.readable<!riscv.freg>):
        %0 = riscv.li 0 : !riscv.reg
        %1 = riscv.li 1 : !riscv.reg
        %2 = riscv.li 2 : !riscv.reg
        %3 = riscv.li 3 : !riscv.reg
        %4 = riscv.li 150 : !riscv.reg
        %5 = riscv.li 600 : !riscv.reg
        %6 = riscv.li 0 : !riscv.reg
        %7 = riscv.li 1 : !riscv.reg
        riscv_scf.for %8 : !riscv.reg  = %6 to %4 step %7 {
          %9 = riscv.li 4 : !riscv.reg
          %10 = riscv.mul %8, %9 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %11 = riscv.add %10, %0 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride = riscv.li 600 : !riscv.reg
          %pointer_dim_offset = riscv.mul %6, %pointer_dim_stride : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset = riscv.add %pointer_dim_offset, %11 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset = riscv.mul %pointer_offset, %bytes_per_element {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer = riscv.add %arg2_1, %scaled_pointer_offset : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %12 = riscv.fld %offset_pointer, 0 {"comment" = "load double from memref of shape (1, 600)"} : (!riscv.reg) -> !riscv.freg
          %13 = riscv.li 4 : !riscv.reg
          %14 = riscv.mul %8, %13 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %15 = riscv.add %14, %1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_1 = riscv.li 600 : !riscv.reg
          %pointer_dim_offset_1 = riscv.mul %6, %pointer_dim_stride_1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_1 = riscv.add %pointer_dim_offset_1, %15 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_1 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_1 = riscv.mul %pointer_offset_1, %bytes_per_element_1 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_1 = riscv.add %arg2_1, %scaled_pointer_offset_1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %16 = riscv.fld %offset_pointer_1, 0 {"comment" = "load double from memref of shape (1, 600)"} : (!riscv.reg) -> !riscv.freg
          %17 = riscv.li 4 : !riscv.reg
          %18 = riscv.mul %8, %17 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %19 = riscv.add %18, %2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_2 = riscv.li 600 : !riscv.reg
          %pointer_dim_offset_2 = riscv.mul %6, %pointer_dim_stride_2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_2 = riscv.add %pointer_dim_offset_2, %19 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_2 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_2 = riscv.mul %pointer_offset_2, %bytes_per_element_2 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_2 = riscv.add %arg2_1, %scaled_pointer_offset_2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %20 = riscv.fld %offset_pointer_2, 0 {"comment" = "load double from memref of shape (1, 600)"} : (!riscv.reg) -> !riscv.freg
          %21 = riscv.li 4 : !riscv.reg
          %22 = riscv.mul %8, %21 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %23 = riscv.add %22, %3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_3 = riscv.li 600 : !riscv.reg
          %pointer_dim_offset_3 = riscv.mul %6, %pointer_dim_stride_3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_3 = riscv.add %pointer_dim_offset_3, %23 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_3 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_3 = riscv.mul %pointer_offset_3, %bytes_per_element_3 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_3 = riscv.add %arg2_1, %scaled_pointer_offset_3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %24 = riscv.fld %offset_pointer_3, 0 {"comment" = "load double from memref of shape (1, 600)"} : (!riscv.reg) -> !riscv.freg
          %25 = riscv.fmv.d %12 : (!riscv.freg) -> !riscv.freg
          %26 = riscv.fmv.d %16 : (!riscv.freg) -> !riscv.freg
          %27 = riscv.fmv.d %20 : (!riscv.freg) -> !riscv.freg
          %28 = riscv.fmv.d %24 : (!riscv.freg) -> !riscv.freg
          %29 = riscv.sub %5, %6 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %30 = riscv.addi %29, -1 : (!riscv.reg) -> !riscv.reg
          %31, %32, %33, %34 = riscv_snitch.frep_outer %30 iter_args(%out = %25, %out_1 = %26, %out_2 = %27, %out_3 = %28) -> (!riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg) {
            %in_2 = riscv_snitch.read from %in : !riscv.freg
            %in_3 = riscv_snitch.read from %in : !riscv.freg
            %in_4 = riscv_snitch.read from %in : !riscv.freg
            %in_5 = riscv_snitch.read from %in : !riscv.freg
            %in_6 = riscv_snitch.read from %in_1 : !riscv.freg
            %in_7 = riscv_snitch.read from %in_1 : !riscv.freg
            %in_8 = riscv_snitch.read from %in_1 : !riscv.freg
            %in_9 = riscv_snitch.read from %in_1 : !riscv.freg
            %35 = riscv.fmul.d %in_2, %in_6 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %36 = riscv.fmul.d %in_3, %in_7 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %37 = riscv.fmul.d %in_4, %in_8 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %38 = riscv.fmul.d %in_5, %in_9 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %39 = riscv.fadd.d %out, %35 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %40 = riscv.fadd.d %out_1, %36 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %41 = riscv.fadd.d %out_2, %37 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %42 = riscv.fadd.d %out_3, %38 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            riscv_snitch.frep_yield %39, %40, %41, %42 : !riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg
          }
          %43 = riscv.fmv.d %31 : (!riscv.freg) -> !riscv.freg
          %44 = riscv.fmv.d %32 : (!riscv.freg) -> !riscv.freg
          %45 = riscv.fmv.d %33 : (!riscv.freg) -> !riscv.freg
          %46 = riscv.fmv.d %34 : (!riscv.freg) -> !riscv.freg
          %47 = riscv.li 4 : !riscv.reg
          %48 = riscv.mul %8, %47 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %49 = riscv.add %48, %0 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_4 = riscv.li 600 : !riscv.reg
          %pointer_dim_offset_4 = riscv.mul %6, %pointer_dim_stride_4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_4 = riscv.add %pointer_dim_offset_4, %49 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_4 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_4 = riscv.mul %pointer_offset_4, %bytes_per_element_4 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_4 = riscv.add %arg2_1, %scaled_pointer_offset_4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          riscv.fsd %offset_pointer_4, %43, 0 {"comment" = "store double value to memref of shape (1, 600)"} : (!riscv.reg, !riscv.freg) -> ()
          %50 = riscv.li 4 : !riscv.reg
          %51 = riscv.mul %8, %50 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %52 = riscv.add %51, %1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_5 = riscv.li 600 : !riscv.reg
          %pointer_dim_offset_5 = riscv.mul %6, %pointer_dim_stride_5 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_5 = riscv.add %pointer_dim_offset_5, %52 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_5 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_5 = riscv.mul %pointer_offset_5, %bytes_per_element_5 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_5 = riscv.add %arg2_1, %scaled_pointer_offset_5 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          riscv.fsd %offset_pointer_5, %44, 0 {"comment" = "store double value to memref of shape (1, 600)"} : (!riscv.reg, !riscv.freg) -> ()
          %53 = riscv.li 4 : !riscv.reg
          %54 = riscv.mul %8, %53 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %55 = riscv.add %54, %2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_6 = riscv.li 600 : !riscv.reg
          %pointer_dim_offset_6 = riscv.mul %6, %pointer_dim_stride_6 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_6 = riscv.add %pointer_dim_offset_6, %55 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_6 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_6 = riscv.mul %pointer_offset_6, %bytes_per_element_6 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_6 = riscv.add %arg2_1, %scaled_pointer_offset_6 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          riscv.fsd %offset_pointer_6, %45, 0 {"comment" = "store double value to memref of shape (1, 600)"} : (!riscv.reg, !riscv.freg) -> ()
          %56 = riscv.li 4 : !riscv.reg
          %57 = riscv.mul %8, %56 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %58 = riscv.add %57, %3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_7 = riscv.li 600 : !riscv.reg
          %pointer_dim_offset_7 = riscv.mul %6, %pointer_dim_stride_7 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_7 = riscv.add %pointer_dim_offset_7, %58 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_7 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_7 = riscv.mul %pointer_offset_7, %bytes_per_element_7 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_7 = riscv.add %arg2_1, %scaled_pointer_offset_7 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          riscv.fsd %offset_pointer_7, %46, 0 {"comment" = "store double value to memref of shape (1, 600)"} : (!riscv.reg, !riscv.freg) -> ()
        }
      }
      riscv_func.return
    }
  }
}
