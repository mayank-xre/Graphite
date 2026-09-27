# Graphite

**Graphite** is a lightweight, high-performance Domain-Specific Language (DSL) compiler written in C. It transpiles declarative graph definitions and algorithmic queries written in custom `.my` scripts into optimized **LLVM Intermediate Representation (LLVM IR)**.

The generated LLVM IR links directly against embedded LLVM runtime modules (`Utils.ll`, `Graph.ll`, `BellMan.ll`, `Floyd.ll`), enabling graph construction and shortest-path algorithm execution at native machine speeds.

---

## Key Features

* **Declarative Graph DSL**: Intuitive syntax to define vertices, weighted undirected edges, and query algorithms.
* **Dual Graph Representation in LLVM IR**:
  * **Adjacency Matrix**: For $O(V^3)$ All-Pairs Shortest Path (Floyd-Warshall) queries.
  * **Coordinate Format (COO Edge List)**: For $O(VE)$ Single-Source Shortest Path (Bellman-Ford) queries.
* **Symbol Table Resolution**: In-memory identifier mapping with automatic index bounds checking and node validation.
* **LLVM Code Generation**: Outputs standalone `.ll` assembly files that can be directly executed via `lli` or compiled to native binaries using `clang`.

---

## Directory Structure

```text
.
├── main.c          # Graphite Compiler Front-End (Lexer, Parser, Symbol Table, IR Emitter)
├── Test1.my        # Sample script written in Graphite DSL
├── Utils.ll        # Global data structures, matrix allocations, and format strings
├── Graph.ll        # Graph mutation routines (Init_g, U_Edge, U_COO, inc)
├── BellMan.ll      # SSSP algorithm implementation in LLVM IR (Bellman-Ford)
└── Floyd.ll        # APSP algorithm implementation in LLVM IR (Floyd-Warshall)
```

---

## DSL Syntax Reference (`.gp`)

| Command | Syntax | Description | Generated LLVM IR Output |
| :--- | :--- | :--- | :--- |
| **Node** | `Node <name>` | Registers a new vertex in the symbol table. | `call i32 @inc()` |
| **Edge** | `Edge <u_name> <v_name> <weight>` | Creates a weighted, undirected edge between two nodes. | `call i32 @U_Edge(...)`, `call i32 @U_COO(...)` |
| **SSSP** | `SSSP <source_node>` | Computes single-source shortest paths using Bellman-Ford. | `call i32 @Init_b(...)`, `call i32 @BellMan()`, `call i32 @Print_bell()` |
| **APSP** | `APSP` | Computes all-pairs shortest paths using Floyd-Warshall. | `call i32 @Init_f()`, `call i32 @APSP()`, `call i32 @Print_floyd()` |

---

## Prerequisites

To build the compiler and execute the generated LLVM IR, you need:

* **C Compiler**: `gcc` or `clang` (C99 or later)
* **LLVM Toolchain**: `clang` (for native compilation) or `lli` (LLVM IR interpreter)

---

## Build & Execution Guide

### 1. Build the Graphite Compiler
Compile the C front-end generator into the `graphite` executable:

```bash
gcc -O2 main.c -o graphite
```

### 2. Transpile DSL Script to LLVM IR
Run the compiler executable against a `.my` source file. Graphite automatically bundles the runtime modules (`Utils.ll`, `Graph.ll`, `BellMan.ll`, `Floyd.ll`) and emits `out.ll`:

```bash
./graphite
```

### 3. Run the Target Code

You can run the emitted `out.ll` file using either of the following methods:

#### Option A: Direct Execution via LLVM Interpreter (`lli`)
```bash
lli out.ll
```

#### Option B: Native Machine Binary via Clang
```bash
clang out.ll -o graph_app
./graph_app
```

---

## Example Walkthrough

### Source Input (`Test1.my`)
```text
Node A
Node B
Node C
Node D
Edge A B 4
Edge A C 5
Edge B C 3
Edge C D 2
Edge B D 5
SSSP C
APSP
```

### Execution Output
```text
5 3 0 2 

0 4 5 7 
4 0 3 5 
5 3 0 2 
7 5 2 0 
```

* **Line 1:** SSSP shortest distances from source `Node C` to `[A, B, C, D]` (showing `5 3 0 2`).
* **Lines 3–6:** $4 \times 4$ APSP distance matrix representing shortest paths between all pair combinations.

---
