lex bnf.l
yacc -d bnf.y
gcc lex.yy.c y.tab.c -ll -lm -w
./a.out tex=st.c