flex 3a.l
gcc lex.yy.c -o lexer -lfl
./lexer sum.c


flex 3b.l
cc lex.yy.c
./a.out number.txt