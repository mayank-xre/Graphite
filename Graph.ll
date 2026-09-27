
; Increasing the number of nodes after every new node is declared
define i32 @inc(){
entry:
    %n = load i32, ptr @n_node, align 4
    %n.next = add nsw i32 1,%n
    store i32 %n.next, ptr @n_node, align 4
    ret i32 1
}

; This is for the coordinate format graph, ease of computation in bellman ford
define i32 @U_COO(i32 %i, i32 %j, i32 %w){
entry:
    %ne = load i32, ptr @n_edges, align 4
    %src_ptr = getelementptr [200 x i32], ptr @src, i32 0, i32 %ne
    %dest_ptr = getelementptr [200 x i32], ptr @dest, i32 0, i32 %ne
    %w_ptr = getelementptr [200 x i32], ptr @weights, i32 0, i32 %ne
    store i32 %i, ptr %src_ptr, align 4
    store i32 %j, ptr %dest_ptr, align 4
    store i32 %w, ptr %w_ptr, align 4
    %ne.next = add nsw i32 %ne, 1
    store i32 %ne.next, ptr @n_edges, align 4
    ret i32 1
}

;Update edge weight in the graph(Adjacency Matrix)
define i32 @U_Edge(i32 %i, i32 %j, i32 %w){
entry:
    %ij = getelementptr [100 x [104 x i32]], ptr @graph, i32 0, i32 %i, i32 %j
    %ji = getelementptr [100 x [104 x i32]], ptr @graph, i32 0, i32 %j, i32 %i
    store i32 %w, ptr %ij , align 4
    store i32 %w, ptr %ji , align 4
    ret i32 1
}

;Printing the adjacency matrix representation of the graph
define i32 @Print_graph(){
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
    %ij = getelementptr [100 x [104 x i32]], ptr @graph, i32 0, i32 %i, i32 %j
    %ij_val = load i32, ptr %ij, align 4
    call i32 (ptr,...) @printf(ptr @.fmt2,i32 %ij_val)
    br label %loop_2.header
loop_2.exit:
    call i32(ptr,...) @printf(ptr @.fmt3)
    %i.next = add nsw i32 1,%i
    br label %loop_1.header
}

; Initialize the graph with infinite(1000000) distance
define i32 @Init_g(){
entry:
    %n=add i32 0, 100
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
    %ij = getelementptr [100 x [104 x i32]], ptr @graph, i32 0, i32 %i, i32 %j
    store i32 1000000, ptr %ij , align 4
    br label %loop_2.header
loop_2.exit:
    %ii = getelementptr [100 x [104 x i32]], ptr @graph, i32 0, i32 %i, i32 %i
    store i32 0, ptr %ii, align 4
    %i.next = add nsw i32 1,%i
    br label %loop_1.header
}