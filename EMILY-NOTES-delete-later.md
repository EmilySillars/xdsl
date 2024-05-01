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
%0 = "memref.subview"(%arg0) <{"operandSegmentSizes" = array<i32: 1, 0, 0, 0>}> 
: (memref<16x16xi8>) -> memref<2x16xi8, strided<[16, 1], offset: ?>>
```

Things to fix:

1. offset list OPERAND holding SSA variables missing
2. strides OPERAND missing

## hoodle

```
operands: 
OpOperands(
_op=Subview(_operands=(<OpResult[memref<10x2xindex>] index: 0, operation: memref.alloc, uses: 2>,), 
results=[<OpResult[memref<1x1xindex>] index: 0, operation: memref.subview, uses: 0>], successors=[], properties={'static_offsets': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=0), IntAttr(data=0)))), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=0), IntAttr(data=0)))), 'static_sizes': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), 'static_strides': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), elt_type=IntegerType(parameters=(IntAttr(data=64), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=64), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=1)))), 'operandSegmentSizes': DenseArrayBase(parameters=(IntegerType(parameters=(IntAttr(data=32), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=32), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), ArrayAttr(data=(IntAttr(data=1), IntAttr(data=0), IntAttr(data=0), IntAttr(data=0)))), elt_type=IntegerType(parameters=(IntAttr(data=32), SignednessAttr(data=<Signedness.SIGNLESS: 0>)), width=IntAttr(data=32), signedness=SignednessAttr(data=<Signedness.SIGNLESS: 0>)), data=ArrayAttr(data=(IntAttr(data=1), IntAttr(data=0), IntAttr(data=0), IntAttr(data=0))))}, attributes={}, regions=[]))
```

