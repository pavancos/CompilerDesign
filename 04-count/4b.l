%{
#include <stdio.h>

int c = 0, w = 0, s = 0, l = 0;
%}

/* Regular Expressions */
WORD   [^ \t\n,.]+
EOL    \n
BLANK  [ \t]+

%%

{WORD}  { w++; c += yyleng; }  /* Count words and characters */
{BLANK} { s += yyleng; }       /* Count spaces and tabs */
{EOL}   { l++; c++; }          /* Count new lines and characters */
.       { c++; }               /* Count punctuation/symbols */

%%

int yywrap(void) { return 1; }

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <sourcefile>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Error: Could not open file %s\n", argv[1]);
        return 1;
    }

    yylex();

    printf("No of characters = %d\n", c);
    printf("No of words = %d\n", w);
    printf("No of spaces = %d\n", s);
    printf("No of lines = %d\n", l);

    fclose(yyin);
    return 0;
}