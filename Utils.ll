@graph = global [100 x [104 x i32]] zeroinitializer, align 32
@floyd = global [100 x [104 x i32]] zeroinitializer, align 32
@bellman = global [100 x i32] zeroinitializer, align 16
@dest = global [200 x i32] zeroinitializer, align 16
@weights = global [200 x i32] zeroinitializer, align 16
@src = global [200 x i32] zeroinitializer, align 16
@n_edges = global i32 zeroinitializer, align 4 
@n_node = global i32 zeroinitializer, align 4
@.fmt1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.fmt2 = private unnamed_addr constant [4 x i8] c"%d\20\00", align 1
@.fmt3 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
; using a std printf for console output
declare i32 @printf(ptr,...)
