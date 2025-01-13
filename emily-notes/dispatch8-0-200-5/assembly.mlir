.text
.globl dispatch_8
.p2align 2
    # Regalloc stats: {"preallocated_float": ["ft0", "ft1", "ft2"], "preallocated_int": ["a0", "a1", "a2", "zero"], "allocated_float": ["ft0", "ft1", "ft3", "ft4", "ft5", "ft6", "ft7"], "allocated_int": ["a0", "a1", "a2", "t0", "t1", "t2", "t3", "t4", "t5", "zero"]}
dispatch_8:
    mv t3, a0
    mv t2, a1
    mv t0, a2
    li t1, 4
    scfgwi t1, 64                                # dm 0 dim 0 bound
    li t1, 4
    scfgwi t1, 96                                # dm 0 dim 1 bound
    li t1, 8
    scfgwi t1, 192                               # dm 0 dim 0 stride
    li t1, -32
    scfgwi t1, 224                               # dm 0 dim 1 stride
    li t1, 4
    scfgwi t1, 32                                # dm 0 repeat
    li t1, 4
    scfgwi t1, 65                                # dm 1 dim 0 bound
    li t1, 4
    scfgwi t1, 97                                # dm 1 dim 1 bound
    li t1, 4
    scfgwi t1, 129                               # dm 1 dim 2 bound
    li t1, 40
    scfgwi t1, 193                               # dm 1 dim 0 stride
    li t1, -152
    scfgwi t1, 225                               # dm 1 dim 1 stride
    li t1, 8
    scfgwi t1, 257                               # dm 1 dim 2 stride
    scfgwi zero, 33                              # dm 1 repeat
    scfgwi t3, 800                               # dm 0 dim 1 source
    scfgwi t2, 833                               # dm 1 dim 2 source
    csrrsi zero, 1984, 1                         # SSR enable
    li t2, 5
    mv t1, zero
    # Constant folded riscv_cf.bge
scf_body_0_for:
    li t4, 5
    mul t4, t1, t4
    li t5, 8
    mul t4, t4, t5                               # multiply by element size
    add t4, t0, t4
    fld ft7, 0(t4)                               # load double from memref of shape (1, 25)
    li t4, 5
    mul t4, t1, t4
    addi t4, t4, 1
    li t5, 8
    mul t4, t4, t5                               # multiply by element size
    add t4, t0, t4
    fld ft6, 0(t4)                               # load double from memref of shape (1, 25)
    li t4, 5
    mul t4, t1, t4
    addi t4, t4, 2
    li t5, 8
    mul t4, t4, t5                               # multiply by element size
    add t4, t0, t4
    fld ft5, 0(t4)                               # load double from memref of shape (1, 25)
    li t4, 5
    mul t4, t1, t4
    addi t4, t4, 3
    li t5, 8
    mul t4, t4, t5                               # multiply by element size
    add t4, t0, t4
    fld ft4, 0(t4)                               # load double from memref of shape (1, 25)
    li t4, 5
    mul t4, t1, t4
    addi t4, t4, 4
    li t5, 8
    mul t4, t4, t5                               # multiply by element size
    add t4, t0, t4
    fld ft3, 0(t4)                               # load double from memref of shape (1, 25)
    li t4, 4
    frep.o t4, 5, 0, 0
    fmadd.d ft7, ft0, ft1, ft7
    fmadd.d ft6, ft0, ft1, ft6
    fmadd.d ft5, ft0, ft1, ft5
    fmadd.d ft4, ft0, ft1, ft4
    fmadd.d ft3, ft0, ft1, ft3
    li t4, 5
    mul t4, t1, t4
    li t5, 8
    mul t4, t4, t5                               # multiply by element size
    add t4, t0, t4
    fsd ft7, 0(t4)                               # store double value to memref of shape (1, 25)
    li t4, 5
    mul t4, t1, t4
    addi t4, t4, 1
    li t5, 8
    mul t4, t4, t5                               # multiply by element size
    add t4, t0, t4
    fsd ft6, 0(t4)                               # store double value to memref of shape (1, 25)
    li t4, 5
    mul t4, t1, t4
    addi t4, t4, 2
    li t5, 8
    mul t4, t4, t5                               # multiply by element size
    add t4, t0, t4
    fsd ft5, 0(t4)                               # store double value to memref of shape (1, 25)
    li t4, 5
    mul t4, t1, t4
    addi t4, t4, 3
    li t5, 8
    mul t4, t4, t5                               # multiply by element size
    add t4, t0, t4
    fsd ft4, 0(t4)                               # store double value to memref of shape (1, 25)
    li t4, 5
    mul t4, t1, t4
    addi t4, t4, 4
    li t5, 8
    mul t4, t4, t5                               # multiply by element size
    add t4, t0, t4
    fsd ft3, 0(t4)                               # store double value to memref of shape (1, 25)
    addi t1, t1, 1
    blt t1, t2, scf_body_0_for
scf_body_end_0_for:
    csrrci zero, 1984, 1                         # SSR disable
    ret
