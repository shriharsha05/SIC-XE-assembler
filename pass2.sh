yacc p2.y -d
lex p2.l
gcc lex.yy.c y.tab.c -ll -ly -o pass2
