%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    void AddQuadruple(char op[5], char arg1[10], char arg2[10], char result[10]);
    int pop();
    void push(int data);

    int Index = 0, tIndex = 0, StNo, Ind, tInd;
    extern int yylineno;

    struct quad {
        char op[5];
        char arg1[10];
        char arg2[10];
        char result[10];
    } QUAD[30];

    struct stack {
        int items[100];
        int top;
    } stk;
%}

%union {
    char var[10];
}

%token <var> NUM VAR RELOP
%token MAIN IF ELSE WHILE TYPE
%type <var> EXPR ASSIGNMENT CONDITION IFST ELSEST WHILELOOP

%left '-' '+'
%left '*' '/'

%%

PROGRAM : MAIN BLOCK { printf(""); }
;

BLOCK: '{' CODE '}'
;

CODE: BLOCK
    | STATEMENT CODE
    | STATEMENT
;

STATEMENT: DESCT ';'
    | ASSIGNMENT ';'
    | CONDST
    | WHILEST
;

DESCT: TYPE VARLIST
;

VARLIST: VAR ',' VARLIST
    | VAR
;

ASSIGNMENT: VAR '=' EXPR {
        strcpy(QUAD[Index].op, "=");
        strcpy(QUAD[Index].arg1, $3);
        strcpy(QUAD[Index].arg2, "");
        strcpy(QUAD[Index].result, $1);
        strcpy($$, QUAD[Index++].result);
    }
;

EXPR: EXPR '+' EXPR { AddQuadruple("+", $1, $3, $$); }
    | EXPR '-' EXPR { AddQuadruple("-", $1, $3, $$); }
    | EXPR '*' EXPR { AddQuadruple("*", $1, $3, $$); }
    | EXPR '/' EXPR { AddQuadruple("/", $1, $3, $$); }
    | '-' EXPR { AddQuadruple("UMIN", $2, "", $$); }
    | '(' EXPR ')' { strcpy($$, $2); }
    | VAR
    | NUM
;

CONDST: IFST {
        Ind = pop();
        sprintf(QUAD[Ind].result, "%d", Index);
        Ind = pop();
        sprintf(QUAD[Ind].result, "%d", Index);
    }
    | IFST ELSEST
;

IFST: IF '(' CONDITION ')' {
        strcpy(QUAD[Index].op, "==");
        strcpy(QUAD[Index].arg1, $3);
        strcpy(QUAD[Index].arg2, "FALSE");
        strcpy(QUAD[Index].result, "-1");
        push(Index);
        Index++;
    }
    BLOCK {
        strcpy(QUAD[Index].op, "GOTO");
        strcpy(QUAD[Index].arg1, "");
        strcpy(QUAD[Index].arg2, "");
        strcpy(QUAD[Index].result, "-1");
        push(Index);
        Index++;
    }
;

ELSEST: ELSE {
        tInd = pop();
        Ind = pop();
        push(tInd);
        sprintf(QUAD[Ind].result, "%d", Index);
    }
    BLOCK {
        Ind = pop();
        sprintf(QUAD[Ind].result, "%d", Index);
    }
;

CONDITION: VAR RELOP VAR { AddQuadruple($2, $1, $3, $$); StNo = Index - 1; }
    | VAR
    | NUM
;

WHILEST: WHILELOOP {
        Ind = pop();
        sprintf(QUAD[Ind].result, "%d", StNo);
        Ind = pop();
        sprintf(QUAD[Ind].result, "%d", Index);
    }
;

WHILELOOP: WHILE '(' CONDITION ')' {
        strcpy(QUAD[Index].op, "==");
        strcpy(QUAD[Index].arg1, $3);
        strcpy(QUAD[Index].arg2, "FALSE");
        strcpy(QUAD[Index].result, "-1");
        push(Index);
        Index++;
    }
    BLOCK {
        strcpy(QUAD[Index].op, "GOTO");
        strcpy(QUAD[Index].arg1, "");
        strcpy(QUAD[Index].arg2, "");
        strcpy(QUAD[Index].result, "-1");
        push(Index);
        Index++;
    }
;

%%

extern FILE *yyin;

int main(int argc, char *argv[]) {
    FILE *fp;
    int i;

    if (argc > 1) {
        fp = fopen(argv[1], "r");
        if (!fp) {
            printf("\n File not found\n");
            exit(0);
        }
        yyin = fp;
    }

    yyparse();

    printf("\n----------------------------");
    printf("\nPos Operator Arg1 Arg2 Result");
    printf("\n----------------------------");
    for (i = 0; i < Index; i++) {
        printf("\n%d\t%s\t%s\t%s\t%s", i, QUAD[i].op, QUAD[i].arg1, QUAD[i].arg2, QUAD[i].result);
    }
    printf("\n----------------------------\n\n");

    return 0;
}

void push(int data) {
    stk.top++;
    if (stk.top == 100) {
        printf("\n Stack overflow\n");
        exit(0);
    }
    stk.items[stk.top] = data;
}

int pop() {
    int data;
    if (stk.top == -1) {
        printf("\n Stack underflow\n");
        exit(0);
    }
    data = stk.items[stk.top--];
    return data;
}

void AddQuadruple(char op[5], char arg1[10], char arg2[10], char result[10]) {
    strcpy(QUAD[Index].op, op);
    strcpy(QUAD[Index].arg1, arg1);
    strcpy(QUAD[Index].arg2, arg2);
    sprintf(QUAD[Index].result, "t%d", tIndex++);
    strcpy(result, QUAD[Index++].result);
}

void yyerror(char const *s) {
    fprintf(stderr, "Syntax error at line %d: %s\n", yylineno, s);
}
