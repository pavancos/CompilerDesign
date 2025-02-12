%{
#include <stdio.h>
#include <stdlib.h>

char* word[] = {
    "keyword", "identifier", "operator", "preprocessor", 
    "comment", "invalid literal", "reserved", "number", "string"
};

void display(int);
%}

%%

"int"|"char"|"short"|"void"|"long"|"if"|"else"|"case"|"for"|"do"|"while"|"break"|"auto"|"static"|"const"|"enum"|"struct" { display(0); }

"main"|"FILE"|"printf"|"scanf"|"puts"|"putc"|"getc"|"pow" { display(6); }

"//".*|"/\\*".*"\\*/" { display(4); }

"#".* { display(3); }

"\\{|\\}|\\(|\\)|\\[|\\]|->|\\+|-|\\*|/|%|&|!|=|&&|\\|\\||-=|\\+=|/=|\\*=|%=|>>|<<" { display(2); }

"\"[^\"]*\"" { display(8); }

[a-zA-Z_][a-zA-Z0-9_]* { display(1); }

[0-9]+(\\.[0-9]*)? { display(7); }

[ \t\n] { /* Ignore whitespace */ }

. { display(5); }

%%

void display(int n) {
    printf("%s --> %s\n", yytext, word[n]);
}

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("Could not open %s\n", argv[1]);
            exit(0);
        }
    }
    yylex();
    return 0;
}
