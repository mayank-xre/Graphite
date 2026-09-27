
; Initializing the bellman array for bellman ford
define i32 @Init_b(i32 %node){
entry:
    %n = load i32, ptr @n_node, align 4
    br label %loop_1.header
loop_1.header:
    %i = phi i32 [0, %entry], [%i.next,%loop_1.body]
    %cmp = icmp slt i32 %i, %n
    br i1 %cmp, label %loop_1.body, label %loop_1.exit
loop_1.body:
    %bell_ptr = getelementptr [100 x i32], ptr @bellman, i32 0, i32 %i
    store i32 1000000, ptr %bell_ptr, align 4
    %i.next = add nsw i32 %i, 1
    br label %loop_1.header
loop_1.exit:
    %bell_n_ptr = getelementptr [100 x i32], ptr @bellman, i32 0, i32 %node
    store i32 0, ptr %bell_n_ptr, align 4
    ret i32 1
}



; Printing the result of the bellman algorithm
define i32 @Print_bell(){
entry:
    %n = load i32, ptr @n_node, align 4
    br label %loop.header
loop.header:
    %i = phi i32 [0, %entry], [%i.next, %loop.body]
    %cmp = icmp slt i32 %i, %n
    br i1 %cmp, label %loop.body, label %loop.exit
loop.body:
    %i.next = add nsw i32 %i, 1
    %bell_ptr = getelementptr [100 x i32], ptr @bellman, i32 0, i32 %i
    %bell_val = load i32, ptr %bell_ptr, align 4
    call i32 (ptr,...) @printf(ptr @.fmt2, i32 %bell_val)
    br label %loop.header
loop.exit:
    call i32 (ptr,...) @printf(ptr @.fmt3)
    ret i32 1
}


; Main loop of BellMan algorithm
define i32 @BellMan(){
entry:
    %n = load i32, ptr @n_node, align 4
    %n_e = load i32, ptr @n_edges, align 4
    br label %loop_1.header
loop_1.header:
    %i = phi i32 [0, %entry], [%i.next, %loop_2.exit]
    %cmp_i = icmp slt i32 %i, %n
    br i1 %cmp_i, label %loop_1.body, label %loop_1.exit
loop_1.body:
    br label %loop_2.header
loop_2.header:
    %j = phi i32 [0,%loop_1.body], [%j.next, %j_inc]
    %cmp_j = icmp slt i32 %j, %n_e
    br i1 %cmp_j, label %loop_2.body, label %loop_2.exit
loop_2.body:
    %src_ptr = getelementptr [200 x i32], ptr @src, i32 0, i32 %j
    %dest_ptr = getelementptr [200 x i32], ptr @dest, i32 0, i32 %j
    %w_ptr = getelementptr [200 x i32], ptr @weights, i32 0, i32 %j
    %src = load i32, ptr %src_ptr, align 4
    %dest = load i32, ptr %dest_ptr, align 4
    %w = load i32 ,ptr %w_ptr, align 4
    %bell_src_ptr = getelementptr [100 x i32], ptr @bellman, i32 0, i32 %src
    %bell_dest_ptr = getelementptr [100 x i32], ptr @bellman, i32 0, i32 %dest
    %bell_src = load i32, ptr %bell_src_ptr, align 4
    %bell_dest = load i32, ptr %bell_dest_ptr, align 4
    %relax = add nsw i32 %bell_src, %w
    %cmp_r = icmp slt i32 %relax, %bell_dest
    br i1 %cmp_r, label %relax_bell, label %j_inc
relax_bell:
    store i32 %relax, ptr %bell_dest_ptr, align 4
    br label %j_inc
j_inc:
    %j.next = add nsw i32 %j, 1
    br label %loop_2.header
loop_2.exit:
    %i.next = add nsw i32 %i, 1
    br label %loop_1.header
loop_1.exit:
    ret i32 1
}