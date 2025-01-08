builtin.module {
  riscv.assembly_section ".text" {
    riscv.directive ".globl" "matmul"
    riscv.directive ".p2align" "2"
    riscv_func.func @matmul(%A : !riscv.reg<a0>, %B : !riscv.reg<a1>, %C : !riscv.reg<a2>) {
      %A_1 = riscv.mv %A : (!riscv.reg<a0>) -> !riscv.reg
      %B_1 = riscv.mv %B : (!riscv.reg<a1>) -> !riscv.reg
      %C_1 = riscv.mv %C : (!riscv.reg<a2>) -> !riscv.reg
      snitch_stream.streaming_region {
        patterns = [
          #snitch_stream.stride_pattern<ub = [4], strides = [8], repeat = 2>,
          #snitch_stream.stride_pattern<ub = [2, 2, 2], strides = [0, 16, 8]>
        ]
      } ins(%A_1, %B_1 : !riscv.reg, !riscv.reg) {
      ^0(%a : !snitch.readable<!riscv.freg>, %b : !snitch.readable<!riscv.freg>):
        %0 = riscv.li 0 : !riscv.reg
        %1 = riscv.li 1 : !riscv.reg
        %2 = riscv.li 2 : !riscv.reg
        %3 = riscv.li 2 : !riscv.reg
        %4 = riscv.li 0 : !riscv.reg
        %5 = riscv.li 1 : !riscv.reg
        riscv_scf.for %6 : !riscv.reg  = %4 to %2 step %5 {
          %7 = riscv.li 2 : !riscv.reg
          %8 = riscv.mul %4, %7 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %9 = riscv.add %8, %0 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride = riscv.li 2 : !riscv.reg
          %pointer_dim_offset = riscv.mul %6, %pointer_dim_stride : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset = riscv.add %pointer_dim_offset, %9 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset = riscv.mul %pointer_offset, %bytes_per_element {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer = riscv.add %C_1, %scaled_pointer_offset : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %10 = riscv.fld %offset_pointer, 0 {"comment" = "load double from memref of shape (2, 2)"} : (!riscv.reg) -> !riscv.freg
          %11 = riscv.li 2 : !riscv.reg
          %12 = riscv.mul %4, %11 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %13 = riscv.add %12, %1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_1 = riscv.li 2 : !riscv.reg
          %pointer_dim_offset_1 = riscv.mul %6, %pointer_dim_stride_1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_1 = riscv.add %pointer_dim_offset_1, %13 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_1 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_1 = riscv.mul %pointer_offset_1, %bytes_per_element_1 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_1 = riscv.add %C_1, %scaled_pointer_offset_1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %14 = riscv.fld %offset_pointer_1, 0 {"comment" = "load double from memref of shape (2, 2)"} : (!riscv.reg) -> !riscv.freg
          %15 = riscv.fmv.d %10 : (!riscv.freg) -> !riscv.freg
          %16 = riscv.fmv.d %14 : (!riscv.freg) -> !riscv.freg
          %17 = riscv.sub %3, %4 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %18 = riscv.addi %17, -1 : (!riscv.reg) -> !riscv.reg
          %19, %20 = riscv_snitch.frep_outer %18 iter_args(%acc_old = %15, %acc_old_1 = %16) -> (!riscv.freg, !riscv.freg) {
            %a_1 = riscv_snitch.read from %a : !riscv.freg
            %a_2 = riscv_snitch.read from %a : !riscv.freg
            %b_1 = riscv_snitch.read from %b : !riscv.freg
            %b_2 = riscv_snitch.read from %b : !riscv.freg
            %prod = riscv.fmul.d %a_1, %b_1 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %prod_1 = riscv.fmul.d %a_2, %b_2 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %acc_new = riscv.fadd.d %acc_old, %prod fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            %acc_new_1 = riscv.fadd.d %acc_old_1, %prod_1 fastmath<fast> : (!riscv.freg, !riscv.freg) -> !riscv.freg
            riscv_snitch.frep_yield %acc_new, %acc_new_1 : !riscv.freg, !riscv.freg
          }
          %21 = riscv.fmv.d %19 : (!riscv.freg) -> !riscv.freg
          %22 = riscv.fmv.d %20 : (!riscv.freg) -> !riscv.freg
          %23 = riscv.li 2 : !riscv.reg
          %24 = riscv.mul %4, %23 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %25 = riscv.add %24, %0 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_2 = riscv.li 2 : !riscv.reg
          %pointer_dim_offset_2 = riscv.mul %6, %pointer_dim_stride_2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_2 = riscv.add %pointer_dim_offset_2, %25 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_2 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_2 = riscv.mul %pointer_offset_2, %bytes_per_element_2 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_2 = riscv.add %C_1, %scaled_pointer_offset_2 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          riscv.fsd %offset_pointer_2, %21, 0 {"comment" = "store double value to memref of shape (2, 2)"} : (!riscv.reg, !riscv.freg) -> ()
          %26 = riscv.li 2 : !riscv.reg
          %27 = riscv.mul %4, %26 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %28 = riscv.add %27, %1 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_dim_stride_3 = riscv.li 2 : !riscv.reg
          %pointer_dim_offset_3 = riscv.mul %6, %pointer_dim_stride_3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %pointer_offset_3 = riscv.add %pointer_dim_offset_3, %28 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %bytes_per_element_3 = riscv.li 8 : !riscv.reg
          %scaled_pointer_offset_3 = riscv.mul %pointer_offset_3, %bytes_per_element_3 {"comment" = "multiply by element size"} : (!riscv.reg, !riscv.reg) -> !riscv.reg
          %offset_pointer_3 = riscv.add %C_1, %scaled_pointer_offset_3 : (!riscv.reg, !riscv.reg) -> !riscv.reg
          riscv.fsd %offset_pointer_3, %22, 0 {"comment" = "store double value to memref of shape (2, 2)"} : (!riscv.reg, !riscv.freg) -> ()
        }
      }
      riscv_func.return
    }
  }
}
