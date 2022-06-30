lex sample.l
yacc -d sample.y
gcc y.tab.c lex.yy.c
echo "Opeing File"
# ./a.out

# ./a.out < test.case.text