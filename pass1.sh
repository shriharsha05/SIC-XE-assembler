yacc p1.y -d
lex p1.l
gcc lex.yy.c y.tab.c -ll -ly -o pass1