builtin.module {
  riscv.assembly_section ".text" {
    riscv.directive ".globl" "dispatch_8"
    riscv.directive ".p2align" "2"
    riscv_func.func @dispatch_8(%arg0 : !riscv.reg<a0>, %arg1 : !riscv.reg<a1>, %arg2 : !riscv.reg<a2>) {
      %arg0_1 = riscv.mv %arg0 : (!riscv.reg<a0>) -> !riscv.reg
      %arg1_1 = riscv.mv %arg1 : (!riscv.reg<a1>) -> !riscv.reg
      %arg2_1 = riscv.mv %arg2 : (!riscv.reg<a2>) -> !riscv.reg
      %0 = riscv.li 600 : !riscv.reg
      %1 = riscv.li 150 : !riscv.reg
      %2 = riscv.addi %0, -1 : (!riscv.reg) -> !riscv.reg
      "snitch.ssr_set_dimension_bound"(%2) {"dm" = #builtin.int<0>, "dimension" = #builtin.int<0>} : (!riscv.reg) -> ()
      %3 = riscv.addi %1, -1 : (!riscv.reg) -> !riscv.reg
      "snitch.ssr_set_dimension_bound"(%3) {"dm" = #builtin.int<0>, "dimension" = #builtin.int<1>} : (!riscv.reg) -> ()
      %4 = riscv.li 8 : !riscv.reg
      %5 = riscv.li 0 : !riscv.reg
      "snitch.ssr_set_dimension_stride"(%4) {"dm" = #builtin.int<0>, "dimension" = #builtin.int<0>} : (!riscv.reg) -> ()
      %6 = riscv.li 0 : !riscv.reg
      %7 = riscv.mul %2, %4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
      %8 = riscv.add %6, %7 : (!riscv.reg, !riscv.reg) -> !riscv.reg
      %9 = riscv.sub %5, %8 : (!riscv.reg, !riscv.reg) -> !riscv.reg
      "snitch.ssr_set_dimension_stride"(%9) {"dm" = #builtin.int<0>, "dimension" = #builtin.int<1>} : (!riscv.reg) -> ()
      %10 = riscv.li 3 : !riscv.reg
      "snitch.ssr_set_stream_repetition"(%10) {"dm" = #builtin.int<0>} : (!riscv.reg) -> ()
      %11 = riscv.li 4 : !riscv.reg
      %12 = riscv.li 600 : !riscv.reg
      %13 = riscv.li 150 : !riscv.reg
      %14 = riscv.addi %11, -1 : (!riscv.reg) -> !riscv.reg
      "snitch.ssr_set_dimension_bound"(%14) {"dm" = #builtin.int<1>, "dimension" = #builtin.int<0>} : (!riscv.reg) -> ()
      %15 = riscv.addi %12, -1 : (!riscv.reg) -> !riscv.reg
      "snitch.ssr_set_dimension_bound"(%15) {"dm" = #builtin.int<1>, "dimension" = #builtin.int<1>} : (!riscv.reg) -> ()
      %16 = riscv.addi %13, -1 : (!riscv.reg) -> !riscv.reg
      "snitch.ssr_set_dimension_bound"(%16) {"dm" = #builtin.int<1>, "dimension" = #builtin.int<2>} : (!riscv.reg) -> ()
      %17 = riscv.li 4800 : !riscv.reg
      %18 = riscv.li 8 : !riscv.reg
      %19 = riscv.li 19200 : !riscv.reg
      "snitch.ssr_set_dimension_stride"(%17) {"dm" = #builtin.int<1>, "dimension" = #builtin.int<0>} : (!riscv.reg) -> ()
      %20 = riscv.li 0 : !riscv.reg
      %21 = riscv.mul %14, %17 : (!riscv.reg, !riscv.reg) -> !riscv.reg
      %22 = riscv.add %20, %21 : (!riscv.reg, !riscv.reg) -> !riscv.reg
      %23 = riscv.sub %18, %22 : (!riscv.reg, !riscv.reg) -> !riscv.reg
      "snitch.ssr_set_dimension_stride"(%23) {"dm" = #builtin.int<1>, "dimension" = #builtin.int<1>} : (!riscv.reg) -> ()
      %24 = riscv.mul %15, %18 : (!riscv.reg, !riscv.reg) -> !riscv.reg
      %25 = riscv.add %22, %24 : (!riscv.reg, !riscv.reg) -> !riscv.reg
      %26 = riscv.sub %19, %25 : (!riscv.reg, !riscv.reg) -> !riscv.reg
      "snitch.ssr_set_dimension_stride"(%26) {"dm" = #builtin.int<1>, "dimension" = #builtin.int<2>} : (!riscv.reg) -> ()
      %27 = riscv.li 0 : !riscv.reg
      "snitch.ssr_set_stream_repetition"(%27) {"dm" = #builtin.int<1>} : (!riscv.reg) -> ()
      "snitch.ssr_set_dimension_source"(%arg0_1) {"dm" = #builtin.int<0>, "dimension" = #builtin.int<1>} : (!riscv.reg) -> ()
      "snitch.ssr_set_dimension_source"(%arg1_1) {"dm" = #builtin.int<1>, "dimension" = #builtin.int<2>} : (!riscv.reg) -> ()
      %in, %in_1 = "snitch.ssr_enable"() : () -> (!snitch.readable<!riscv.freg<ft0>>, !snitch.readable<!riscv.freg<ft1>>)
      %28 = riscv.li 150 : !riscv.reg
      %29 = riscv.get_register : !riscv.reg<zero>
      %30 = riscv.mv %29 : (!riscv.reg<zero>) -> !riscv.reg
      %31 = riscv.li 1 : !riscv.reg
      riscv_scf.for %32 : !riscv.reg  = %30 to %28 step %31 {
        %33 = riscv.li 4 : !riscv.reg
        %34 = riscv.mul %32, %33 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %35 = riscv.mv %34 : (!riscv.reg) -> !riscv.reg
        %pointer_offset = riscv.mv %35 : (!riscv.reg) -> !riscv.reg
        %bytes_per_element = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset = riscv.mul %pointer_offset, %bytes_per_element {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer = riscv.add %arg2_1, %scaled_pointer_offset : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %36 = riscv.fld %offset_pointer, 0 {"comment" = "load double from memref of shape (1, 600)"} : (!riscv.reg) -> !riscv.freg
        %37 = riscv.li 4 : !riscv.reg
        %38 = riscv.mul %32, %37 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %39 = riscv.addi %38, 1 : (!riscv.reg) -> !riscv.reg
        %pointer_offset_1 = riscv.mv %39 : (!riscv.reg) -> !riscv.reg
        %bytes_per_element_1 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_1 = riscv.mul %pointer_offset_1, %bytes_per_element_1 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_1 = riscv.add %arg2_1, %scaled_pointer_offset_1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %40 = riscv.fld %offset_pointer_1, 0 {"comment" = "load double from memref of shape (1, 600)"} : (!riscv.reg) -> !riscv.freg
        %41 = riscv.li 4 : !riscv.reg
        %42 = riscv.mul %32, %41 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %43 = riscv.addi %42, 2 : (!riscv.reg) -> !riscv.reg
        %pointer_offset_2 = riscv.mv %43 : (!riscv.reg) -> !riscv.reg
        %bytes_per_element_2 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_2 = riscv.mul %pointer_offset_2, %bytes_per_element_2 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_2 = riscv.add %arg2_1, %scaled_pointer_offset_2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %44 = riscv.fld %offset_pointer_2, 0 {"comment" = "load double from memref of shape (1, 600)"} : (!riscv.reg) -> !riscv.freg
        %45 = riscv.li 4 : !riscv.reg
        %46 = riscv.mul %32, %45 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %47 = riscv.addi %46, 3 : (!riscv.reg) -> !riscv.reg
        %pointer_offset_3 = riscv.mv %47 : (!riscv.reg) -> !riscv.reg
        %bytes_per_element_3 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_3 = riscv.mul %pointer_offset_3, %bytes_per_element_3 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_3 = riscv.add %arg2_1, %scaled_pointer_offset_3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %48 = riscv.fld %offset_pointer_3, 0 {"comment" = "load double from memref of shape (1, 600)"} : (!riscv.reg) -> !riscv.freg
        %49 = riscv.fmv.d %36 : (!riscv.freg) -> !riscv.freg
        %50 = riscv.fmv.d %40 : (!riscv.freg) -> !riscv.freg
        %51 = riscv.fmv.d %44 : (!riscv.freg) -> !riscv.freg
        %52 = riscv.fmv.d %48 : (!riscv.freg) -> !riscv.freg
        %53 = riscv.li 599 : !riscv.reg
        %54, %55, %56, %57 = riscv_snitch.frep_outer %53 iter_args(%out = %49, %out_1 = %50, %out_2 = %51, %out_3 = %52) -> (!riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg) {
          %in_2 = riscv_snitch.read from %in : !riscv.freg<ft0>
          %in_3 = riscv_snitch.read from %in : !riscv.freg<ft0>
          %in_4 = riscv_snitch.read from %in : !riscv.freg<ft0>
          %in_5 = riscv_snitch.read from %in : !riscv.freg<ft0>
          %in_6 = riscv_snitch.read from %in_1 : !riscv.freg<ft1>
          %in_7 = riscv_snitch.read from %in_1 : !riscv.freg<ft1>
          %in_8 = riscv_snitch.read from %in_1 : !riscv.freg<ft1>
          %in_9 = riscv_snitch.read from %in_1 : !riscv.freg<ft1>
          %58 = riscv.fmadd.d %in_2, %in_6, %out : (!riscv.freg<ft0>, !riscv.freg<ft1>, !riscv.freg) -> !riscv.freg
          %59 = riscv.fmadd.d %in_3, %in_7, %out_1 : (!riscv.freg<ft0>, !riscv.freg<ft1>, !riscv.freg) -> !riscv.freg
          %60 = riscv.fmadd.d %in_4, %in_8, %out_2 : (!riscv.freg<ft0>, !riscv.freg<ft1>, !riscv.freg) -> !riscv.freg
          %61 = riscv.fmadd.d %in_5, %in_9, %out_3 : (!riscv.freg<ft0>, !riscv.freg<ft1>, !riscv.freg) -> !riscv.freg
          riscv_snitch.frep_yield %58, %59, %60, %61 : !riscv.freg, !riscv.freg, !riscv.freg, !riscv.freg
        }
        %62 = riscv.fmv.d %54 : (!riscv.freg) -> !riscv.freg
        %63 = riscv.fmv.d %55 : (!riscv.freg) -> !riscv.freg
        %64 = riscv.fmv.d %56 : (!riscv.freg) -> !riscv.freg
        %65 = riscv.fmv.d %57 : (!riscv.freg) -> !riscv.freg
        %66 = riscv.li 4 : !riscv.reg
        %67 = riscv.mul %32, %66 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %68 = riscv.mv %67 : (!riscv.reg) -> !riscv.reg
        %pointer_offset_4 = riscv.mv %68 : (!riscv.reg) -> !riscv.reg
        %bytes_per_element_4 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_4 = riscv.mul %pointer_offset_4, %bytes_per_element_4 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_4 = riscv.add %arg2_1, %scaled_pointer_offset_4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        riscv.fsd %offset_pointer_4, %62, 0 {"comment" = "store double value to memref of shape (1, 600)"} : (!riscv.reg, !riscv.freg) -> ()
        %69 = riscv.li 4 : !riscv.reg
        %70 = riscv.mul %32, %69 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %71 = riscv.addi %70, 1 : (!riscv.reg) -> !riscv.reg
        %pointer_offset_5 = riscv.mv %71 : (!riscv.reg) -> !riscv.reg
        %bytes_per_element_5 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_5 = riscv.mul %pointer_offset_5, %bytes_per_element_5 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_5 = riscv.add %arg2_1, %scaled_pointer_offset_5 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        riscv.fsd %offset_pointer_5, %63, 0 {"comment" = "store double value to memref of shape (1, 600)"} : (!riscv.reg, !riscv.freg) -> ()
        %72 = riscv.li 4 : !riscv.reg
        %73 = riscv.mul %32, %72 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %74 = riscv.addi %73, 2 : (!riscv.reg) -> !riscv.reg
        %pointer_offset_6 = riscv.mv %74 : (!riscv.reg) -> !riscv.reg
        %bytes_per_element_6 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_6 = riscv.mul %pointer_offset_6, %bytes_per_element_6 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_6 = riscv.add %arg2_1, %scaled_pointer_offset_6 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        riscv.fsd %offset_pointer_6, %64, 0 {"comment" = "store double value to memref of shape (1, 600)"} : (!riscv.reg, !riscv.freg) -> ()
        %75 = riscv.li 4 : !riscv.reg
        %76 = riscv.mul %32, %75 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %77 = riscv.addi %76, 3 : (!riscv.reg) -> !riscv.reg
        %pointer_offset_7 = riscv.mv %77 : (!riscv.reg) -> !riscv.reg
        %bytes_per_element_7 = riscv.li 8 : !riscv.reg
        %scaled_pointer_offset_7 = riscv.mul %pointer_offset_7, %bytes_per_element_7 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
        %offset_pointer_7 = riscv.add %arg2_1, %scaled_pointer_offset_7 : (!riscv.reg, !riscv.reg) -> !riscv.reg
        riscv.fsd %offset_pointer_7, %65, 0 {"comment" = "store double value to memref of shape (1, 600)"} : (!riscv.reg, !riscv.freg) -> ()
      }
      "snitch.ssr_disable"() : () -> ()
      riscv_func.return
    }
  }
}
