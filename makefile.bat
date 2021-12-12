cls
flex -i ernesto.l
bison ernesto.y
gcc ernesto.tab.c -o main -lfl -lm
.\main
