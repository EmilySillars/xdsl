
0      956        M 0x8000029c li      t4, 15                 #; (wrb) t4  <-- 15
// this instruction reads from ft7, ft0, and ft1; also, ft6 happens to get written to? A write to ft7 is requested at cycle # 956.
                  M 0x800002a4 fmadd.d ft7, ft0, ft1, ft7     #; [02a0 4:0], ft0  = -15.2690401, ft1  = 32.0347075, ft7  = -1445.4134521, (f:fpu) ft6  <-- -3330.5887756

// this instruction reads from ft6, ft0, and ft1; also, ft5 happens to get written to? A write to ft6 is requested.
0      957        M 0x800002a8 fmadd.d ft6, ft0, ft1, ft6     #; [02a0 4:1], ft0  = -15.2690401, ft1  = -41.9844786, ft6  = -3330.5887756, (f:fpu) ft5  <-- -1209.3914765

// this instruction reads from ft5, ft0, and ft1; also, ft4 happens to get written to? A write to ft5 is requested.
0      958        M 0x800002ac fmadd.d ft5, ft0, ft1, ft5     #; [02a0 4:2], ft0  = -15.2690401, ft1  = 23.6030858, ft5  = -1209.3914765, (f:fpu) ft4  <-- -1351.7304747
// this instruction says we should repeat the next 4 instructions 16 times.
                  M 0x800002a0 frep    16, 4                  #; outer, 64 issues
// this instruction reads from ft4, ft0, and ft1; also, ft7 FINALLY gets written to at cycle # 959.
0      959        M 0x800002b0 fmadd.d ft4, ft0, ft1, ft4     #; [02a0 4:3], ft0  = -15.2690401, ft1  = -14.2462598, ft4  = -1351.7304747, (f:fpu) ft7  <-- -1934.5526865
// this instruction reads from ft7, ft0, and ft1. also, ft6 finally gets written to at cycle # 960.
0      960        M 0x800002a4 fmadd.d ft7, ft0, ft1, ft7     #; [02a0 5:0], ft0  = 29.1788226, ft1  = 61.2387978, ft7  = -1934.5526865, (f:fpu) ft6  <-- -2689.5260876

// Therefore, it takes 
// fmadd.d ft7, ft0, ft1, ft7 (line 4)
// 3 cycles to complete (959 - 956)
