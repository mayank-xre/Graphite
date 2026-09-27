
; APSP -> All pairs shortest path; Floyd-Warshall main loop
define i32 @APSP(){
entry:
    %n = load i32, ptr @n_node, align 4
    br label %loop_1.header
loop_1.header:
    %i = phi i32 [0, %entry], [%i.next, %loop_2.exit]
    %cmp_i = icmp slt i32 %i, %n
    br i1 %cmp_i, label %loop_1.body, label %loop_1.exit
loop_1.body:
    br label %loop_2.header
loop_1.exit:
    ret i32 1
loop_2.header:
    %j = phi i32 [0, %loop_1.body], [%j.next, %loop_3.exit]
    %cmp_j = icmp slt i32 %j, %n
    br i1 %cmp_j, label %loop_2.body, label %loop_2.exit
loop_2.body:
    br label %loop_3.header
loop_2.exit:
    %i.next = add nsw i32 1,%i
    br label %loop_1.header
loop_3.header:
    %k = phi i32 [0, %loop_2.body], [%k.next, %loop_3.k_inc]
    %cmp_k = icmp slt i32 %k, %n
    br i1 %cmp_k, label %loop_3.body, label %loop_3.exit
loop_3.body:
    %ki = getelementptr [100 x [104 x i32]], ptr @floyd, i32 0, i32 %k, i32 %i
    %ij = getelementptr [100 x [104 x i32]], ptr @floyd, i32 0, i32 %i, i32 %j
    %kj = getelementptr [100 x [104 x i32]], ptr @floyd, i32 0, i32 %k, i32 %j
    %ki.val = load i32, ptr %ki, align 4
    %ij.val = load i32, ptr %ij, align 4
    %kj.val = load i32, ptr %kj, align 4
    %sum.val = add nsw i32 %ki.val, %ij.val
    %cmp = icmp slt i32 %sum.val, %kj.val
    br i1 %cmp, label %lower, label %loop_3.k_inc
lower:
    store i32 %sum.val, ptr %kj, align 4
    br label %loop_3.k_inc
loop_3.k_inc:
    %k.next = add nsw i32 1,%k
    br label %loop_3.header
loop_3.exit:
    %j.next = add nsw i32 1,%j
    br label %loop_2.header
}



; Helper function to initiate the floyd matrix
define i32 @Init_f(){
entry:
    %n=load i32, ptr @n_node, align 4
    br label %loop_1.header
loop_1.header:
    %i = phi i32 [0, %entry], [%i.next, %loop_2.exit]
    %cmp_i = icmp slt i32 %i, %n
    br i1 %cmp_i, label %loop_1.body, label %loop_1.exit
loop_1.body:
    br label %loop_2.header
loop_1.exit:
    ret i32 1
loop_2.header:
    %j = phi i32 [0, %loop_1.body], [%j.next, %loop_2.body]
    %cmp_j = icmp slt i32 %j, %n
    br i1 %cmp_j, label %loop_2.body, label %loop_2.exit
loop_2.body:
    %j.next = add nsw i32 1,%j
    %ij = getelementptr [100 x [104 x i32]], ptr @floyd, i32 0, i32 %i, i32 %j
    %ij_g = getelementptr [100 x [104 x i32]], ptr @graph, i32 0, i32 %i, i32 %j
    %ij_g_v = load i32, ptr %ij_g, align 4
    store i32 %ij_g_v, ptr %ij, align 4
    br label %loop_2.header
loop_2.exit:
    %i.next = add nsw i32 1,%i
    br label %loop_1.header
}


; Helper function in printing the 2D floyd_warshall matrix
define i32 @Print_floyd(){
entry:
    %n=load i32, ptr @n_node, align 4
    br label %loop_1.header
loop_1.header:
    %i = phi i32 [0, %entry], [%i.next, %loop_2.exit]
    %cmp_i = icmp slt i32 %i, %n
    br i1 %cmp_i, label %loop_1.body, label %loop_1.exit
loop_1.body:
    br label %loop_2.header
loop_1.exit:
    ret i32 1
loop_2.header:
    %j = phi i32 [0, %loop_1.body], [%j.next, %loop_2.body]
    %cmp_j = icmp slt i32 %j, %n
    br i1 %cmp_j, label %loop_2.body, label %loop_2.exit
loop_2.body:
    %j.next = add nsw i32 1,%j
    %ij = getelementptr [100 x [104 x i32]], ptr @floyd, i32 0, i32 %i, i32 %j
    %ij_val = load i32, ptr %ij, align 4
    call i32 (ptr,...) @printf(ptr @.fmt2,i32 %ij_val)
    br label %loop_2.header
loop_2.exit:
    call i32(ptr,...) @printf(ptr @.fmt3)
    %i.next = add nsw i32 1,%i
    br label %loop_1.header
}