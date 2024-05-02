# Notes to delete later
When you enter repo, do:
```
source venv/bin/activate
```
When you wanna leave, do:
```
deactivate
```
To run failing test case:
```
xdsl-opt tests/filecheck/dialects/memref/memref_subview_no_static_offsets.mlir
```

To run non-failing test case:
```
xdsl-opt tests/filecheck/dialects/memref/memref_ops.mlir
```
## Need to parse a memref.subview
Its type is similar to a cast, right? 

What does that look like in xDSL? 

Can I print the IR before it becomes MLIR?

## hoo hoo!
```
%0 = "memref.subview"(%1) <{"static_offsets" = array<i64: 0, 0>, "static_sizes" = array<i64: 1, 1>, "static_strides" = array<i64: 1, 1>, "operandSegmentSizes" = array<i32: 1, 0, 0, 0>}> : (memref<10x2xindex>) -> memref<1x1xindex>


name: memref.subview


operands: OpOperands(_op=Subview(_operands=(<OpResult[memref<10x2xindex>] index: 0, operation: memref.alloc, uses: 2>,), results=[<OpResult[memref<1x1xindex>] index: 0, operation: memref.subview, uses: 0>], successors=[], properties={'static_offsets': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=0), IntAttr(data=0)))), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=0), IntAttr(data=0)))), 'static_sizes': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), 'static_strides': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), 'operandSegmentSizes': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=32), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=32), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=0), IntAttr(data=0), IntAttr(data=0)))), elt_type=IntegerType(parameters=(IntAttr(data=32), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=32), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=0), IntAttr(data=0), IntAttr(data=0))))}, attributes={}, regions=[]))

type of operands: <class 'xdsl.ir.core.OpOperands'>

v----------------------v

type: <class 'xdsl.ir.core.OpResult'> op: <OpResult[memref<10x2xindex>] index: 0, operation: memref.alloc, uses: 2>

^----------------------^


results: [<OpResult[memref<1x1xindex>] index: 0, operation: memref.subview, uses: 0>]

type of results: <class 'list'>

v----------------------v

type: <class 'xdsl.ir.core.OpResult'> res: <OpResult[memref<1x1xindex>] index: 0, operation: memref.subview, uses: 0>

^----------------------^

```

## What I *want* to generate vs. What I *do*

Want:

```
%subview = memref.subview %arg0[%arg5, %arg4] [2, 16] [1, 1] 
: memref<16x16xi8> to memref<2x16xi8, strided<[16, 1], offset: ?>>         
```

Do:
```
%subview = "memref.subview"(%arg0, %arg5, %arg4) <{"static_offsets" = array<i64>, "static_sizes" = array<i64>, "static_strides" = array<i64>, "sizes" = array<i64: 2, 16>, "strides" = array<i64: 1, 1>, "operandSegmentSizes" = array<i32: 1, 2, 0, 0>}> : (memref<16x16xi8>, index, index) -> memref<2x16xi8, strided<[16, 1], offset: ?>>
```

~~%0 = "memref.subview"(%arg0) <{"operandSegmentSizes" = array<i32: 1, 0, 0, 0>}>~~ 
~~: (memref<16x16xi8>) -> memref<2x16xi8, strided<[16, 1], offset: ?>>~~

Things to fix:

1. offset list OPERAND holding SSA variables missing

   OpResult

   how are operations BUILT? how do they take in a block arg?

   ```
   i32_ssa_var = Constant(IntegerAttr.from_int_and_width(62, 32), i32)
   my_addi32 = Addi32.build(
       operands=[i32_ssa_var.result, i32_ssa_var.result], result_types=[i32]
   )
   printer.print_op(i32_ssa_var)
   print()
   printer.print_op(my_addi32)
   ---------------------------------
   %0 = arith.constant 62 : i32
   %1 = "arith.addi32"(%0, %0) : (i32, i32) -> i32
   ```

   maybe this is helpful too:

   ```
   def test_var_operand_builder():
       op1 = ResultOp.build(result_types=[StringAttr("0")])
       op2 = VarOperandOp.build(operands=[[op1, op1]])
       op2.verify()
       assert tuple(op2.operands) == (op1.res, op1.res)
   ```

   

## Python Object for Custom vs. Generic Subview

parsing custom subview and adding sizes to the properties dicitonary:

```
Subview(_operands=(<BlockArgument[memref<16x16xi8>] index: 0, uses: 1>, <BlockArgument[index] index: 0, uses: 1>, <BlockArgument[index] index: 0, uses: 1>), results=[<OpResult[memref<2x16xi8, strided<[16, 1], offset: ?>>] index: 0, operation: memref.subview, uses: 0>], successors=[], properties={'sizes': [2, 16], 'operandSegmentSizes': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=32), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=32), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=2), IntAttr(data=0), IntAttr(data=0)))), elt_type=IntegerType(parameters=(IntAttr(data=32), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=32), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=2), IntAttr(data=0), IntAttr(data=0))))}, attributes={}, regions=[])
```

parsing generic subview and looking at its python representation:

```
Subview(_operands=(<OpResult[memref<10x2xindex>] index: 0, operation: memref.alloc, uses: 2>,), results=[<OpResult[memref<1x1xindex>] index: 0, operation: memref.subview, uses: 0>], successors=[], properties={'static_offsets': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=0), IntAttr(data=0)))), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=0), IntAttr(data=0)))), 'static_sizes': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), 'static_strides': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), 'operandSegmentSizes': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=32), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=32), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=0), IntAttr(data=0), IntAttr(data=0)))), elt_type=IntegerType(parameters=(IntAttr(data=32), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=32), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=0), IntAttr(data=0), IntAttr(data=0))))}, attributes={}, regions=[])
```

## Next Steps:

- modify printer.py so that it prints memref.subviews in a custom format-y way.

- handle case where we have operands as sizes: e.g. `[%arg0, %arg5, %arg5]`

- handle the case where we have property sizes: e.g. [6, 5]

- make sure sizes_operand and sizes cannot both be empty at same time

- *don't* print empty properties when printing for custom format

- Can we have a mix of SSA values and integers in the same list for any of the arguments?? e.g. `[%arg0, 85, 9]`

- Figure out how to call my forked xDSL repo from my forked snax-mlir repo.

  I need to enter the ELSE block of this for loop to do custom printing!!!

```
  elif self.print_generic_format or Operation.print is type(op).print:
            self.print(f'"{op.name}"')
        else:
            self.print(f"{op.name}")
            use_custom_format = True
```

Maybe I need to override this function inside of the subview class that inherits from Operation's function here?

```
def print(self, printer: Printer):
        return printer.print_op_with_default_format(self)
```

For reference:

```
    def print_op_with_default_format(self, op: Operation) -> None:
        self.print_operands(op.operands)
        self.print_successors(op.successors)
        if not self.print_properties_as_attributes:
            self._print_op_properties(op.properties)
        self.print_regions(op.regions)
        if self.print_properties_as_attributes:
            clashing_names = op.properties.keys() & op.attributes.keys()
            if clashing_names:
                raise ValueError(
                    f"Properties {', '.join(clashing_names)} would overwrite the attributes of the same names."
                )

            self.print_op_attributes(op.attributes | op.properties)
        else:
            self.print_op_attributes(op.attributes)
        self.print(" : ")
        self.print_operation_type(op)
```

# why am i getting an error where operands is not iterable??

```
Subview(_operands=(<BlockArgument[memref<16x16xi8>] index: 0, uses: 1>, <BlockArgument[index] index: 0, uses: 1>, <BlockArgument[index] index: 0, uses: 1>), results=[<OpResult[memref<2x16xi8, strided<[16, 1], offset: ?>>] index: 0, operation: memref.subview, uses: 0>], successors=[], properties={'static_offsets': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=())), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=())), 'static_sizes': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=())), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=())), 'static_strides': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=())), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=())), 'sizes': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=2), IntAttr(data=16)))), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=2), IntAttr(data=16)))), 'strides': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), 'operandSegmentSizes': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=32), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=32), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=2), IntAttr(data=0), IntAttr(data=0)))), elt_type=IntegerType(parameters=(IntAttr(data=32), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=32), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=2), IntAttr(data=0), IntAttr(data=0))))}, attributes={}, regions=[])
```

