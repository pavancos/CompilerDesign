%{
#include <stdio.h>
#include <stdlib.h>

int posint = 0;
int negint = 0;
int posfraction = 0;
int negfraction = 0;
%}

%%

[-][0-9]+ { negint++; }                    /* Negative Integers */
[+]?[0-9]+ { posint++; }                    /* Positive Integers */
[-][0-9]+(\.[0-9]+)? { negfraction++; }     /* Negative Fractions */
[+]?[0-9]+(\.[0-9]+)? { posfraction++; }    /* Positive Fractions */

[ \n\t] { /* Ignore whitespace */ }

%%

int yywrap(void) { return 1; }

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: ./lexer <sourcefile>\n");
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Error: Could not open file %s\n", argv[1]);
        return 1;
    }

    yyin = file;
    yylex();
    fclose(file);

    printf("No of +ve integers: %d\n", posint);
    printf("No of -ve integers: %d\n", negint);
    printf("No of +ve fractions: %d\n", posfraction);
    printf("No of -ve fractions: %d\n", negfraction);

    return 0;
}