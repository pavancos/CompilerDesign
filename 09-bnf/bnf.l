%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"

    extern int yylineno;
    int yywrap() { return 1; }
%}

%%

[ \t\r]+           ;  // Ignore spaces and tabs
\n                 { yylineno++; }
"main"             { return MAIN; }
"if"               { return IF; }
"else"             { return ELSE; }
"while"            { return WHILE; }
"int"|"float"|"char" { return TYPE; }
[a-zA-Z_][a-zA-Z0-9_]* { strcpy(yylval.var, yytext); return VAR; }
[0-9]+            { strcpy(yylval.var, yytext); return NUM; }
"<"|"<="|">"|">="|"=="|"!=" { return RELOP; }
"="               { return '='; }
"+"               { return '+'; }
"-"               { return '-'; }
"*"               { return '*'; }
"/"               { return '/'; }
"{"               { return '{'; }
"}"               { return '}'; }
"("               { return '('; }
")"               { return ')'; }
";"               { return ';'; }
","               { return ','; }

.                 { printf("Unrecognized character: %s\n", yytext); exit(1); }

%%