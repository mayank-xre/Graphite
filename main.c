//
//  main.c
//  GraphCompiler
//
//  Created by Mayank Choudhary on 20/09/26.
//

#include <stdio.h>
#include <stdlib.h>
char sym_tab[100][100]={0}; //A maximum of 100 identifiers with max string size 100 of each identifier
int sym_sz[100]={0};
int n_ident=0;
int idx_f_ident(char ident[]){
    //Length of the ident:
    int id_sz=0;
    while(ident[id_sz]!='\0'){
        id_sz++;
    }
    id_sz++;
    //printf("%d ",id_sz);
    //Extracting index by checking size, and individual chars for potential candidates
    int idx=-1;
    for(int i=0;i<n_ident;i++){
        //printf("%d ",sym_sz[i]);
        if(sym_sz[i]==id_sz){
            //printf("%d",i);
            for(int j=0;j<id_sz;j++){
                if(sym_tab[i][j]!=ident[j]) break;
                if(j==id_sz-1) idx=i;
            }
        }
        if(idx!=-1) break;
    }
    return idx;
}

int eq_s(char token[],char cmp[]){
    int t_sz=0;
    int c_sz=0;
    while(token[t_sz]!='\0') t_sz++;
    while(cmp[c_sz]!='\0') c_sz++;
    if(t_sz!=c_sz) return 0;
    for(int i=0;i<t_sz;i++)
        if(token[i]!=cmp[i]) return 0;
    return 1;
}
int main(void){ 
    FILE * prog=fopen("Demo.gp","r");
    FILE * asm_w=fopen("out.ll","w");
    if(asm_w==NULL){
        printf("Writing ability has not been provided\n");
        return 0;
    }
    if(prog==NULL){
        printf("File handling error\n");
        return 0;
    }
    //Header file writing
    FILE * UtilsHead=fopen("Utils.ll","r");
    if(UtilsHead==NULL){
        printf("Unable to read the Utils.ll file\n");
        return 0;
    }
    char buffer[4000];
    while (fgets(buffer, sizeof(buffer), UtilsHead) != NULL) {
        fputs(buffer, asm_w);
    }
    FILE * GraphHead=fopen("Graph.ll","r");
    if(GraphHead==NULL){
        printf("Unable to read the Graph.ll file\n");
        return 0;
    }
    while (fgets(buffer, sizeof(buffer), GraphHead) != NULL) {
        fputs(buffer, asm_w);
    }
    FILE * BellHead=fopen("BellMan.ll","r");
    if(BellHead==NULL){
        printf("Unable to read the BellMan.ll file\n");
        return 0;
    }
    while (fgets(buffer, sizeof(buffer), BellHead) != NULL) {
        fputs(buffer, asm_w);
    }
    FILE * FloydHead=fopen("Floyd.ll","r");
    if(FloydHead==NULL){
        printf("Unable to read the Floyd.ll file\n");
        return 0;
    }
    while (fgets(buffer, sizeof(buffer), FloydHead) != NULL) {
        fputs(buffer, asm_w);
    }
    // Main parsing and writing the main loop for LLVM IR
    char token[50];
    fprintf(asm_w,"\ndefine i32 @main()\n{\nentry:\n");
    fprintf(asm_w,"\tcall i32 @Init_g()\n");
    while(fscanf(prog," %49s",token)!=EOF){
        if(eq_s(token,"Node")){
            char ident[50];
            fscanf(prog," %49s",ident);
            if(idx_f_ident(ident)!=-1){
                printf("Warning: %s has been already defined as a Node\n",ident);
            }
            else{
                int i;
                for(i=0;ident[i]!='\0';i++){
                    sym_tab[n_ident][i]=ident[i];
                }
                sym_sz[n_ident]=i+1;
                sym_tab[n_ident][i]='\0';
                n_ident++;
                fprintf(asm_w,"\tcall i32 @inc()\n");
            }
        }
        else if(eq_s(token,"Edge")){
            char ident1[50];
            char ident2[50];
            int w;
            fscanf(prog," %49s %49s %d",ident1,ident2,&w);
            int idx1=idx_f_ident(ident1);
            int idx2=idx_f_ident(ident2);
            if(idx1==-1){
                if(idx2==-1){
                    printf("Error: Both %s and %s have not been defined as Nodes\n",ident1,ident2);
                }
                else{
                    printf("Error: %s has not been defined as a Node\n",ident1);
                }
            }
            else if(idx2==-1){
                printf("Error: %s has not been defined as a Node\n",ident2);
            }
            else{
                fprintf(asm_w,"\tcall i32 @U_Edge(i32 %d,i32 %d,i32 %d)\n",idx1,idx2,w);
                fprintf(asm_w,"\tcall i32 @U_COO(i32 %d,i32 %d,i32 %d)\n",idx1,idx2,w);
                fprintf(asm_w,"\tcall i32 @U_COO(i32 %d,i32 %d,i32 %d)\n",idx2,idx1,w);
            }
        }
        else if(eq_s(token,"SSSP")){
            char ident[50];
            fscanf(prog," %49s",ident);
            int node=idx_f_ident(ident);
            if(node!=-1){
                fprintf(asm_w,"\tcall i32 @Init_b(i32 %d)\n\tcall i32 @BellMan()\n\tcall i32 @Print_bell()\ncall i32(ptr,...) @printf(ptr @.fmt3)\n",node);
            }
            else{
                printf("Error: Node doesnt Exist\n");
            }
        }
        else if(eq_s(token,"APSP")){
            fprintf(asm_w,"\tcall i32 @Init_f()\n\tcall i32 @APSP()\n\tcall i32 @Print_floyd()\ncall i32(ptr,...) @printf(ptr @.fmt3)\n");
        }
        else{
            printf("Error: Unidentifiable token\n");
        }
    }
    fprintf(asm_w,"\tret i32 0\n}\n");
}
