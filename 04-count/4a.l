%{
#include <stdio.h>

int vowel_count = 0;
int consonant_count = 0;
%}

%%

[aAeEiIoOuU] { vowel_count++; }              /* Count vowels */
[b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z] { consonant_count++; }  /* Count consonants */
[ \t\n] ;                                    /* Ignore whitespace */
. ;                                          /* Ignore all other characters */

%%

int yywrap(void) { return 1; }

int main() {
    printf("Enter a string: ");
    yylex();
    
    printf("Number of vowels: %d\n", vowel_count);
    printf("Number of consonants: %d\n", consonant_count);

    return 0;
}