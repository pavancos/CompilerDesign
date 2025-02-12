%{
#include<stdio.h>
int result = 0;
%}
%%
[\n] {
    if (result == 1) printf("Valid string\n");
    else printf("Invalid string\n");
}
^a[ab]*$ { result = 1; }
. { result = 0; }
%%
int main() {
    printf("Enter string: ");
    yylex();
    return 0;
}
int yywrap() {
    return 1;
}
