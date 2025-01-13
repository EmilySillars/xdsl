import marimo

__generated_with = "0.10.9"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    return (mo,)


@app.cell
def _():
    import xdsl.utils.marimo as xmo
    return (xmo,)


@app.cell
def _(mo):
    mo.md(
        """
        \
        # Compiling `linalg` to Snitch

        This notebook walks through compiling micro-kernels defined in `linalg` to RISC-V and RISC-V with extensions for [Snitch](https://pulp-platform.github.io/snitch/), a neural network accelerator.

        _Toggle app view with `⌘` + `.` or `ctrl` + `.`_
        """
    )
    return


@app.cell
def _():
    # Import all the necessary functionality from xDSL for this notebook
    # If you see an error about xdsl not being defined run this cell manually

    from xdsl.backend.riscv.lowering import (
        convert_arith_to_riscv,
        convert_func_to_riscv_func,
        convert_memref_to_riscv,
        convert_scf_to_riscv_scf,
    )
    from xdsl.backend.riscv.lowering.convert_riscv_scf_to_riscv_cf import (
        ConvertRiscvScfToRiscvCfPass,
    )
    from xdsl.backend.riscv.lowering.convert_snitch_stream_to_snitch import (
        ConvertSnitchStreamToSnitch,
    )
    from xdsl.builder import ImplicitBuilder
    from xdsl.context import MLContext
    from xdsl.dialects import arith, func, linalg
    from xdsl.dialects.builtin import AffineMap, AffineMapAttr, MemRefType, ModuleOp, f64
    from xdsl.dialects.riscv import riscv_code
    from xdsl.interpreters.utils.ptr import TypedPtr
    from xdsl.ir import Attribute, Block, Region, SSAValue
    from xdsl.passes import PipelinePass
    from xdsl.tools.command_line_tool import get_all_dialects
    from xdsl.transforms import (
        arith_add_fastmath,
        convert_linalg_to_loops,
        convert_linalg_to_memref_stream,
        convert_memref_stream_to_loops,
        convert_memref_stream_to_snitch_stream,
        convert_riscv_scf_for_to_frep,
        dead_code_elimination,
        loop_hoist_memref,
        lower_affine,
        memref_streamify,
        reconcile_unrealized_casts,
    )
    from xdsl.transforms.canonicalize import CanonicalizePass
    from xdsl.transforms.lower_snitch import LowerSnitchPass
    from xdsl.transforms.mlir_opt import MLIROptPass
    from xdsl.transforms.riscv_register_allocation import RISCVRegisterAllocation
    from xdsl.transforms.riscv_scf_loop_range_folding import (
        RiscvScfLoopRangeFoldingPass,
    )
    from xdsl.transforms.snitch_register_allocation import SnitchRegisterAllocation
    return (
        AffineMap,
        AffineMapAttr,
        Attribute,
        Block,
        CanonicalizePass,
        ConvertRiscvScfToRiscvCfPass,
        ConvertSnitchStreamToSnitch,
        ImplicitBuilder,
        LowerSnitchPass,
        MLContext,
        MLIROptPass,
        MemRefType,
        ModuleOp,
        PipelinePass,
        RISCVRegisterAllocation,
        Region,
        RiscvScfLoopRangeFoldingPass,
        SSAValue,
        SnitchRegisterAllocation,
        TypedPtr,
        arith,
        arith_add_fastmath,
        convert_arith_to_riscv,
        convert_func_to_riscv_func,
        convert_linalg_to_loops,
        convert_linalg_to_memref_stream,
        convert_memref_stream_to_loops,
        convert_memref_stream_to_snitch_stream,
        convert_memref_to_riscv,
        convert_riscv_scf_for_to_frep,
        convert_scf_to_riscv_scf,
        dead_code_elimination,
        f64,
        func,
        get_all_dialects,
        linalg,
        loop_hoist_memref,
        lower_affine,
        memref_streamify,
        reconcile_unrealized_casts,
        riscv_code,
    )


@app.cell
def _(mo):
    mo.md("""### Cost Model Experiments""")
    return


@app.cell
def _(MLContext, Sequence, mo, module_html):
    import argparse
    from xdsl.xdsl_opt_main import xDSLOptMain
    import sys

    # data_file = mo.notebook_dir() / "../" / "../" / "emily-notes" / "original" / "tester.mlir"
    # # Use the directory to read a file
    # if data_file.exists():
    #     print(f"Found data file: {data_file}")
    # else:
    #     print("No data file found")

    inputFileName = "/home/hoppip/xdsl/docs/marimo/../../emily-notes/original/tester.mlir"
    inputFileName = "/home/hoppip/xdsl/docs/marimo/../../emily-notes/weirdDims/weirdDims.mlir"
    inputFileName = "/home/hoppip/xdsl/docs/marimo/../../emily-notes/dispatch8/dispatch8.mlir"
    inputFileName = "/home/hoppip/xdsl/docs/marimo/../../emily-notes/dispatch8-flat-zigzag/dispatch8-flat-zz.mlir"
    inputFileName = "/home/hoppip/xdsl/docs/marimo/../../emily-notes/dispatch8-0-40-120/dispatch8-0-40-120.mlir"

    class xDSLOptMainWrapper(xDSLOptMain):

         def __init__(
            self,
            description: str = "xDSL modular optimizer driver",
            args: Sequence[str] | None = None,
        ):
            self.available_frontends = {}
            self.available_passes = {}
            self.available_targets = {}

            self.ctx = MLContext()
            super().register_all_dialects()
            super().register_all_frontends()
            super().register_all_passes()
            super().register_all_targets()

            ## Add custom dialects & passes here

            # arg handling
            arg_parser = argparse.ArgumentParser(description=description)
            super().register_all_arguments(arg_parser)
            self.args = arg_parser.parse_args(args=args)
            self.ctx.allow_unregistered = self.args.allow_unregistered_dialect

            super().setup_pipeline()

         def get_module(self):
            """
            Executes the different steps.
            """
            chunks, file_extension = self.prepare_input()
            output_stream = self.prepare_output()
            try:
                for i, (chunk, offset) in enumerate(chunks):
                    try:
                        if i > 0:
                            output_stream.write("// -----\n")
                        module = self.parse_chunk(chunk, file_extension, offset)

                        if module is not None:
                            chunk.close()
                            if output_stream is not sys.stdout:
                                output_stream.close()
                            return module
                            # if self.apply_passes(module):
                            #     output_stream.write(self.output_resulting_program(module))
                        output_stream.flush()
                    finally:
                        chunk.close()
            finally:
                if output_stream is not sys.stdout:
                    output_stream.close()

    theParser = xDSLOptMainWrapper("Read one simplified NsNet Kernel",[inputFileName])
    theModule = theParser.get_module()

    mo.md(f"""

    Starter MLIR: {module_html(theModule)}

    """)
    return (
        argparse,
        inputFileName,
        sys,
        theModule,
        theParser,
        xDSLOptMain,
        xDSLOptMainWrapper,
    )


@app.cell
def _(mo):
    mo.md("""#### Convert to Snitch""")
    return


@app.cell
def _(
    LOWER_MEMREF_STREAM_TO_SNITCH_STREAM_PASSES,
    OPTIMISE_MEMREF_STREAM_PASSES,
    PipelinePass,
    arith_add_fastmath,
    convert_linalg_to_memref_stream,
    convert_riscv_scf_for_to_frep,
    pipeline_accordion,
    theModule,
):
    linalg_module2 = theModule
    convert_linalg_to_snitch2 = PipelinePass(
        [
            convert_linalg_to_memref_stream.ConvertLinalgToMemrefStreamPass(),
            arith_add_fastmath.AddArithFastMathFlagsPass(),
            *OPTIMISE_MEMREF_STREAM_PASSES,
            *LOWER_MEMREF_STREAM_TO_SNITCH_STREAM_PASSES,
            convert_riscv_scf_for_to_frep.ConvertRiscvScfForToFrepPass(),
        ]
    )

    snitch_stream_module2, snitch_stream_accordion2 = pipeline_accordion(
        tuple(("", p) for p in convert_linalg_to_snitch2.passes), linalg_module2
    )

    snitch_stream_accordion2
    return (
        convert_linalg_to_snitch2,
        linalg_module2,
        snitch_stream_accordion2,
        snitch_stream_module2,
    )


@app.cell
def _(mo):
    mo.md("""#### Actual Assembly""")
    return


@app.cell
def _(
    LOWER_SNITCH_STREAM_TO_ASM_PASSES,
    mo,
    pipeline_accordion,
    riscv_code,
    snitch_stream_module2,
    xmo,
):
    snitch_asm_module3, snitch_asm_accordion3 = pipeline_accordion(
        tuple(("", p) for p in LOWER_SNITCH_STREAM_TO_ASM_PASSES), snitch_stream_module2
    )

    snitch_asm_accordion3

    snitch_asm3 = riscv_code(snitch_asm_module3)

    mo.md(f"""\
    **Snitch Assembly:**

    {xmo.asm_html(snitch_asm3)}
    """
    )
    return snitch_asm3, snitch_asm_accordion3, snitch_asm_module3


@app.cell
def _(
    AffineMap,
    AffineMapAttr,
    Block,
    ImplicitBuilder,
    MemRefType,
    ModuleOp,
    Region,
    a_shape,
    arith,
    b_shape,
    c_shape,
    f64,
    func,
    linalg,
    mo,
    module_html,
):
    a_type = MemRefType(f64, a_shape)
    b_type = MemRefType(f64, b_shape)
    c_type = MemRefType(f64, c_shape)

    kernel_op = func.FuncOp("matmul", ((a_type, b_type, c_type), ()))
    with ImplicitBuilder(kernel_op.body) as (a, b, c):
        # Add name hints to make it easier to track how values are lowered
        a.name_hint = "A"
        b.name_hint = "B"
        c.name_hint = "C"
        body = Region(Block(arg_types = (f64, f64, f64)))
        linalg.GenericOp(
            inputs=(a, b),
            outputs=(c,),
            body=body,
            indexing_maps=(
                AffineMapAttr(AffineMap.from_callable(lambda m, n, k: (m, k))),
                AffineMapAttr(AffineMap.from_callable(lambda m, n, k: (k, n))),
                AffineMapAttr(AffineMap.from_callable(lambda m, n, k: (m, n))),
            ),
            iterator_types=(
                linalg.IteratorTypeAttr.parallel(),
                linalg.IteratorTypeAttr.parallel(),
                linalg.IteratorTypeAttr.reduction(),
            )
        )
        with ImplicitBuilder(body) as (a_val, b_val, acc_old_val):
            prod_val = arith.MulfOp(a_val, b_val).result
            acc_new_val = arith.AddfOp(acc_old_val, prod_val).result
            linalg.YieldOp(acc_new_val)
            # Add more name hints to make it easier to track how values are lowered
            a_val.name_hint = "a"
            b_val.name_hint = "b"
            acc_old_val.name_hint = "acc_old"
            prod_val.name_hint = "prod"
            acc_new_val.name_hint = "acc_new"
        func.ReturnOp()

    linalg_module = ModuleOp((kernel_op,))

    mo.md(f"""

    Here is matrix multiplication defined in the `linalg` dialect, with the iteration space decoupled from the computation:

    {module_html(linalg_module)}
    """)
    return (
        a,
        a_type,
        a_val,
        acc_new_val,
        acc_old_val,
        b,
        b_type,
        b_val,
        body,
        c,
        c_type,
        kernel_op,
        linalg_module,
        prod_val,
    )


@app.cell
def _(mo):
    min_val = 1
    max_val = 10
    m = mo.ui.slider(min_val, max_val, value=2, label="M")
    n = mo.ui.slider(min_val, max_val, value=2, label="N")
    k = mo.ui.slider(min_val, max_val, value=2, label="K")
    return k, m, max_val, min_val, n


@app.cell
def _(k, m, mo, n):
    mo.md(
        f"""
        We can parametrize the shapes of the matrices operated on:

        {m}{m.value}

        {n}{n.value}

        {k}{k.value}
        """
    )
    return


@app.cell
def _(k, m, mo, n):
    a_shape = (m.value, k.value)
    b_shape = (k.value, n.value)
    c_shape = (m.value, n.value)

    mo.md(
        f"""

        ```
        A: {'x'.join(str(dim) for dim in a_shape)}xf64 B: {'x'.join(str(dim) for dim in b_shape)}xf64 C: {'x'.join(str(dim) for dim in c_shape)}xf64
        ```
        """
    )
    return a_shape, b_shape, c_shape


@app.cell
def _(mo):
    mo.md("""### Compiling to RISC-V""")
    return


@app.cell
def _(MLContext, get_all_dialects):
    ctx = MLContext()

    for dialect_name, dialect_factory in get_all_dialects().items():
        ctx.register_dialect(dialect_name, dialect_factory)
    return ctx, dialect_factory, dialect_name


@app.cell
def _(mo):
    mo.md("""We can take this representation, and lower to RISC-V-specific dialects:""")
    return


@app.cell
def _(
    PipelinePass,
    convert_arith_to_riscv,
    convert_func_to_riscv_func,
    convert_linalg_to_loops,
    convert_memref_to_riscv,
    convert_scf_to_riscv_scf,
    linalg_module,
    pipeline_accordion,
    reconcile_unrealized_casts,
):
    lower_to_riscv = PipelinePass(
        [
            convert_linalg_to_loops.ConvertLinalgToLoopsPass(),
            convert_func_to_riscv_func.ConvertFuncToRiscvFuncPass(),
            convert_memref_to_riscv.ConvertMemrefToRiscvPass(),
            convert_arith_to_riscv.ConvertArithToRiscvPass(),
            convert_scf_to_riscv_scf.ConvertScfToRiscvPass(),
            reconcile_unrealized_casts.ReconcileUnrealizedCastsPass(),
        ]
    )

    riscv_module, riscv_accordion = pipeline_accordion(
        tuple(("", p) for p in lower_to_riscv.passes), linalg_module
    )

    riscv_accordion
    return lower_to_riscv, riscv_accordion, riscv_module


@app.cell
def _(mo):
    mo.md(
        """
        #### Register allocation

        xDSL provides a register allocator for our RISC-V representation, that works on functions with structured control flow:
        """
    )
    return


@app.cell
def _(
    CanonicalizePass,
    PipelinePass,
    RISCVRegisterAllocation,
    pipeline_accordion,
    riscv_module,
):
    allocate_registers = PipelinePass(
        [
            RISCVRegisterAllocation(),
            CanonicalizePass(),
        ]
    )

    regalloc_module, regalloc_accordion = pipeline_accordion(
        tuple(("", p) for p in allocate_registers.passes), riscv_module
    )

    regalloc_accordion
    return allocate_registers, regalloc_accordion, regalloc_module


@app.cell
def _(
    CanonicalizePass,
    ConvertRiscvScfToRiscvCfPass,
    PipelinePass,
    pipeline_accordion,
    regalloc_module,
):
    lower_to_asm = PipelinePass(
        [
            ConvertRiscvScfToRiscvCfPass(),
            CanonicalizePass(),
        ]
    )

    riscv_asm_module, assembly_accordion = pipeline_accordion(
        (("", lower_to_asm),), regalloc_module
    )

    assembly_accordion
    return assembly_accordion, lower_to_asm, riscv_asm_module


@app.cell
def _(mo):
    mo.md("""This representation of the program in xDSL corresponds ~1:1 to RISC-V assembly, and we can use a helper function to print that out.""")
    return


@app.cell
def _(mo, riscv_asm_module, riscv_code, xmo):
    riscv_asm = riscv_code(riscv_asm_module)

    mo.md(f"""\
    **RISC-V Assembly:**

    {xmo.asm_html(riscv_asm)}
    """
    )
    return (riscv_asm,)


@app.cell
def _(mo):
    mo.md(
        """
        ### Compiling to Snitch

        xDSL is also capable of targeting Snitch, and making use of its streaming registers and fixed-repetition loop. We use a different lowering flow from the linalg.generic representation to represent a high-level, structured, but Snitch-specific representation of the code:
        """
    )
    return


@app.cell
def _(
    PipelinePass,
    arith_add_fastmath,
    convert_linalg_to_memref_stream,
    convert_riscv_scf_for_to_frep,
    linalg_module,
    pipeline_accordion,
):
    from xdsl.transforms.test_lower_linalg_to_snitch import LOWER_MEMREF_STREAM_TO_SNITCH_STREAM_PASSES, OPTIMISE_MEMREF_STREAM_PASSES

    convert_linalg_to_snitch = PipelinePass(
        [
            convert_linalg_to_memref_stream.ConvertLinalgToMemrefStreamPass(),
            arith_add_fastmath.AddArithFastMathFlagsPass(),
            *OPTIMISE_MEMREF_STREAM_PASSES,
            *LOWER_MEMREF_STREAM_TO_SNITCH_STREAM_PASSES,
            convert_riscv_scf_for_to_frep.ConvertRiscvScfForToFrepPass(),
        ]
    )

    snitch_stream_module, snitch_stream_accordion = pipeline_accordion(
        tuple(("", p) for p in convert_linalg_to_snitch.passes), linalg_module
    )

    snitch_stream_accordion
    return (
        LOWER_MEMREF_STREAM_TO_SNITCH_STREAM_PASSES,
        OPTIMISE_MEMREF_STREAM_PASSES,
        convert_linalg_to_snitch,
        snitch_stream_accordion,
        snitch_stream_module,
    )


@app.cell
def _(mo):
    mo.md("""We can then lower this to assembly that includes assembly instructions from the Snitch-extended ISA:""")
    return


@app.cell
def _(pipeline_accordion, snitch_stream_module):
    from xdsl.transforms.test_lower_linalg_to_snitch import LOWER_SNITCH_STREAM_TO_ASM_PASSES

    snitch_asm_module, snitch_asm_accordion = pipeline_accordion(
        tuple(("", p) for p in LOWER_SNITCH_STREAM_TO_ASM_PASSES), snitch_stream_module
    )

    snitch_asm_accordion
    return (
        LOWER_SNITCH_STREAM_TO_ASM_PASSES,
        snitch_asm_accordion,
        snitch_asm_module,
    )


@app.cell
def _(k, m, mo, n):
    mo.md(
        f"""
        We can see how changing our input sizes affects the assembly produced:

        {m}{m.value}

        {n}{n.value}

        {k}{k.value}
        """
    )
    return


@app.cell
def _(mo, riscv_code, snitch_asm_module, xmo):
    snitch_asm = riscv_code(snitch_asm_module)

    mo.md(f"""\
    **Snitch Assembly:**

    {xmo.asm_html(snitch_asm)}
    """
    )
    return (snitch_asm,)


@app.cell
def _(mo):
    mo.md(
        """
        ### Interpreting the assembly using xDSL

        One of the useful features of xDSL is its interpreter. Here we've implemented all the necessary functions to interpret the code at a low level, to check that our compilation is correct. Here's the slider modifying the shape variable defined above, we can slide it to see the result of the code compiled with different input shapes, and interpreted at the RISC-V level.
        """
    )
    return


@app.cell
def _(TypedPtr, a_shape, b_shape, c_shape, ctx, mo, riscv_module):
    from math import prod

    from xdsl.interpreter import Interpreter, OpCounter
    from xdsl.interpreters import register_implementations
    from xdsl.interpreters.shaped_array import ShapedArray

    a_len = prod(a_shape)
    b_len = prod(b_shape)
    c_len = prod(c_shape)

    a_shaped = ShapedArray(TypedPtr.new_float64([i + 1 for i in range(a_len)]), a_shape)
    b_shaped = ShapedArray(TypedPtr.new_float64([(i + 1) / 100 for i in range(b_len)]), b_shape)
    riscv_c_shaped = ShapedArray(TypedPtr.new_float64([0.0] * c_len), c_shape)

    riscv_op_counter = OpCounter()
    riscv_interpreter = Interpreter(riscv_module, listeners=(riscv_op_counter,))

    register_implementations(riscv_interpreter, ctx, include_wgpu=False, include_onnx=False)

    riscv_interpreter.call_op("matmul", (a_shaped.data_ptr.raw, b_shaped.data_ptr.raw, riscv_c_shaped.data_ptr.raw))

    mo.md(f"""
    **RISC-V Results:**

    A: {a_shaped}

    B: {b_shaped}

    C: {riscv_c_shaped}
    """)
    return (
        Interpreter,
        OpCounter,
        ShapedArray,
        a_len,
        a_shaped,
        b_len,
        b_shaped,
        c_len,
        prod,
        register_implementations,
        riscv_c_shaped,
        riscv_interpreter,
        riscv_op_counter,
    )


@app.cell
def _(
    Interpreter,
    OpCounter,
    ShapedArray,
    TypedPtr,
    a_shaped,
    b_shaped,
    c_len,
    c_shape,
    ctx,
    mo,
    register_implementations,
    riscv_c_shaped,
    snitch_stream_module,
):
    snitch_op_counter = OpCounter()
    snitch_interpreter = Interpreter(
        snitch_stream_module, listeners=(snitch_op_counter,)
    )

    snitch_c_shaped = ShapedArray(TypedPtr.new_float64([0.0] * c_len), c_shape)

    register_implementations(snitch_interpreter, ctx, include_wgpu=False, include_onnx=False)

    snitch_interpreter.call_op(
        "matmul",
        (
            a_shaped.data_ptr.raw,
            b_shaped.data_ptr.raw,
            snitch_c_shaped.data_ptr.raw,
        ),
    )

    mo.md(f"""

    **Snitch Results:**

    A: {a_shaped}

    B: {b_shaped}

    C: {riscv_c_shaped}
    """)
    return snitch_c_shaped, snitch_interpreter, snitch_op_counter


@app.cell
def _(k, m, mo, n, riscv_op_counter, snitch_op_counter):
    rv_dict = dict(riscv_op_counter.ops)
    sn_dict = dict(snitch_op_counter.ops)

    all_keys = sorted(set(rv_dict) | set(sn_dict))
    max_len_key = max(len(k) for k in all_keys)
    max_len_value = max(len(str(val)) for val in (*rv_dict.values(), *sn_dict.values()))

    def format_row(key: str, *values: str):
        paddings = tuple(" " * (max_len_value - len(val)) for val in values)
        vals = "".join(f"\t{padding}{val}" for padding, val in zip(paddings, values))
        return f"{key}{' ' * (max_len_key - len(key))}{vals}\n"

    rows = " " * max_len_key + "\trv\tsn\tdiff\n"

    ZERO_VAL = "."

    for key in all_keys:
        rv_val = rv_dict.get(key, 0)
        sn_val = sn_dict.get(key, 0)
        diff_val = sn_val - rv_val

        rv_str = str(rv_val) if rv_val else ZERO_VAL
        sn_str = str(sn_val) if sn_val else ZERO_VAL
        diff_str = (
            (f"+{diff_val}" if diff_val > 0 else f"{diff_val}") if diff_val else "="
        )

        rows += key
        rows += " " * (max_len_key - len(key))
        rows += "\t"
        rows += " " * (max_len_value - len(rv_str))
        rows += rv_str
        rows += "\t"
        rows += " " * (max_len_value - len(sn_str))
        rows += sn_str
        rows += "\t"
        rows += " " * (max_len_value - len(diff_str))
        rows += diff_str
        rows += "\n"

    rv_sum = sum(rv_dict.values())
    sn_sum = sum(sn_dict.values())
    total_diff = sn_sum - rv_sum

    rows += format_row("total", str(rv_sum), str(sn_sum), str(total_diff))

    mo.md(
        f"""
    The interpreter kept track of the number of times an operation was executed, which we can use as a proxy for performance.

    For example, we can see that one version has many more instructions executed overall ({rv_sum} vs {sn_sum}), and that one version uses explicit load and store instructions, while the other uses the streaming equivalents:

    {m}{m.value}

    {n}{n.value}

    {k}{k.value}

    ```
    {rows}
    ```
    """
    )
    return (
        ZERO_VAL,
        all_keys,
        diff_str,
        diff_val,
        format_row,
        key,
        max_len_key,
        max_len_value,
        rows,
        rv_dict,
        rv_str,
        rv_sum,
        rv_val,
        sn_dict,
        sn_str,
        sn_sum,
        sn_val,
        total_diff,
    )


@app.cell
def _(ModuleOp):
    import html as htmllib

    def module_html(module: ModuleOp) -> str:
        return f"""\
        <div style="overflow-y: scroll; height:400px;"><small><code style="white-space: pre-wrap;">{htmllib.escape(str(module))}</code></small></div>
        """
    return htmllib, module_html


@app.cell
def _():
    from collections import Counter
    return (Counter,)


@app.cell
def _(Counter, ModuleOp, ModulePass, PipelinePass, ctx, mo, module_html):
    def spec_str(p: ModulePass) -> str:
        if isinstance(p, PipelinePass):
            return ",".join(str(c.pipeline_pass_spec()) for c in p.passes)
        else:
            return str(p.pipeline_pass_spec())

    def pipeline_accordion(
        passes: tuple[tuple[mo.Html, ModulePass], ...], module: ModuleOp
    ) -> tuple[ModuleOp, mo.Html]:
        res = module.clone()
        d = []
        total_key_count = Counter(spec_str(p) for _, p in passes)
        d_key_count = Counter()
        for text, p in passes:
            p.apply(ctx, res)
            spec = spec_str(p)
            d_key_count[spec] += 1
            if total_key_count[spec] != 1:
                header = f"{spec} ({d_key_count[spec]})"
            else:
                header = spec
            html_res = module_html(res)
            d.append(mo.vstack(
                (
                    header,
                    text,
                    mo.md(html_res),
                )
            ))
        return (res, mo.carousel(d))
    return pipeline_accordion, spec_str


if __name__ == "__main__":
    app.run()
