%{
    #include <string.h>
%}

COMMENT "&&".*
TIPO {SPACE}?("float")
START "inicio"
END "fim"
INT [0-9]+
CHAR [a-zA-Z]+
NUM {INT}+\.?{INT}*
INPUT "scan"
OUTPUT "print"
VAR "E_"({CHAR}|{INT})*","?

IF "se"
ELSE "ise"
WHILE "enquanto"
SPACE [\ ]
INVALID (.)

%%

{NUM} {
    yylval.flo = atof(yytext);
    return NUM;
    }
{OUTPUT} {return OUTPUT;}
{INPUT}  {return INPUT;}
{IF}     {return IF;}
{ELSE}   {return ELSE;}
{WHILE}  {return WHILE;}

[-+()=/*^#{}] {
    return *yytext;
    }
    
{START} {
    return START;
}
{END} {
    return END;
    }
{VAR} {
    strcpy(yylval.str, yytext); 
	return VAR;
}

">" {yylval.fn = 1; return CMP; }
"<" {yylval.fn = 2; return CMP; }
"!=" {yylval.fn = 3; return CMP; }
"==" {yylval.fn = 4; return CMP; }
">=" {yylval.fn = 5; return CMP; }
"<=" {yylval.fn = 6; return CMP; }

{COMMENT} {;}
"\n" {;}
{INVALID} {;}
%%

