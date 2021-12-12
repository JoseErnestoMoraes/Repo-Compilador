%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
 
/*O node type serve para indicar o tipo de nó que está na árvore. Isso serve para a função eval() entender o que realizar naquele nó*/
 
typedef struct ast { /*Estrutura de um nó*/
	int nodetype;
	struct ast *l; /*Esquerda*/
	struct ast *r; /*Direita*/
}Ast; 


typedef struct numval { /*Estrutura de um número*/
	int nodetype;
	double number;
}Numval;

typedef struct varval { /*Estrutura de um nome de variável, nesse exemplo uma variável é um número no vetor var[26]*/
	int nodetype;
	char var[51];
}Varval;

typedef struct flow { /*Estrutura de um desvio (if/else/while)*/
	int nodetype;
	Ast *cond;		/*condição*/
	Ast *tl;		/*then, ou seja, verdade*/
	Ast *el;		/*else*/
}Flow;

typedef struct symasgn { /*Estrutura para um nó de atribuição. Para atrubior o valor de v em s*/
	int nodetype;
	char s[51];
	Ast *v;
}Symasgn;

typedef struct var {
	// char id[1001];
	int nodetype;
	char nome[51];
	float valor;
	// float valor;
	struct var *next;
} Var;

Var *variaveis = NULL;
//double var[26]; /*Variáveis*/
// int aux;

Var *buscaVar(Var *vars, char nome[]) {
	Var *list;
	for(list = vars; list != NULL; list=list->next)
		if(!strcmp(list->nome, nome))
			return list;
	return NULL;
}

Var *insereVar(Var *vars, char nome[]) {
	Var *nova = (Var*)malloc(sizeof(Var));
	strcpy(nova->nome, nome);
	nova->valor = 0;
	nova->next = vars;
	return nova;
}

Ast * newast(int nodetype, Ast *l, Ast *r){ /*Função para criar um nó*/
	Ast *a = (Ast*) malloc(sizeof(Ast));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	a->l = l;
	a->r = r;
	return a;
}
 
Ast * newnum(double d) {			/*Função de que cria um número (folha)*/
	Numval *a = (Numval*) malloc(sizeof(Numval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'K';
	a->number = d;
	return (Ast*)a;
}

Ast * newflow(int nodetype, Ast *cond, Ast *tl, Ast *el){ /*Função que cria um nó de if/else/while*/
	Flow *a = (Flow*)malloc(sizeof(Flow));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	a->cond = cond;
	a->tl = tl;
	a->el = el;
	return (Ast *)a;
}

Ast * newcmp(int cmptype, Ast *l, Ast *r){ /*Função que cria um nó para testes*/
	Ast *a = (Ast*)malloc(sizeof(Ast));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = '0' + cmptype; /*Para pegar o tipo de teste, definido no arquivo.l e utilizar na função eval()*/
	a->l = l;
	a->r = r;
	return a;
}

Ast * newasgn(char s[], Ast *v) { /*Função para um nó de atribuição*/
	Symasgn *a = (Symasgn*)malloc(sizeof(Symasgn));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	Var *aux = buscaVar(variaveis, s);
	if(aux == NULL)
		variaveis = insereVar(variaveis, s);
	a->nodetype = '=';
	strcpy(a->s, s); /*Símbolo/variável*/
	a->v = v; /*Valor*/
	return (Ast *)a;
}

Ast * inputVar(char s[]) { /*Função para um nó de atribuição*/
	Symasgn *a = (Symasgn*)malloc(sizeof(Symasgn));
	if(!a) {
		printf("out of space");
	exit(0);
	}
	a->nodetype = 's';
  	strcpy(a->s, s);
	a->v = 0;
	return (Ast *)a;
}

Ast * newValorVal(char s[]) { /*Função que recupera o nome/referência de uma variável, neste caso o número*/
	Varval *a = (Varval*) malloc(sizeof(Varval));
	// Var *a = buscaVar(variaveis, s);
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'N';
  	strcpy(a->var, s);
	return (Ast*)a;
}

double eval(Ast *a) { /*Função que executa operações a partir de um nó*/
	double v; 
	if(!a) {
		printf("internal error, null eval");
		return 0.0;
	}
	switch(a->nodetype) {
		case 'K': v = ((Numval *)a)->number; break; /*Recupera um número*/
		case 'N': 
		{
			Var *res = buscaVar(variaveis, ((Varval *)a)->var);
			v = res->valor;
			break;
		}
		case '+': v = eval(a->l) + eval(a->r); break;	/*Operações "árv esq   +   árv dir"*/
		case '-': v = eval(a->l) - eval(a->r); break;	/*Operações*/
		case '*': v = eval(a->l) * eval(a->r); break;	/*Operações*/
		case '/': v = eval(a->l) / eval(a->r); break; /*Operações*/
		case '^': v = pow(eval(a->l), eval(a->r)); break; /*Operações*/
		case '#': v = pow(eval(a->l), 1/eval(a->r)); break; /*Operações*/
		case 'M': v = -eval(a->l); break;				/*Operações, número negativo*/
	
		case '1': v = (eval(a->l) > eval(a->r))? 1 : 0; break;	/*Operações lógicas. "árv esq   >   árv dir"  Se verdade 1, falso 0*/
		case '2': v = (eval(a->l) < eval(a->r))? 1 : 0; break;
		case '3': v = (eval(a->l) != eval(a->r))? 1 : 0; break;
		case '4': v = (eval(a->l) == eval(a->r))? 1 : 0; break;
		case '5': v = (eval(a->l) >= eval(a->r))? 1 : 0; break;
		case '6': v = (eval(a->l) <= eval(a->r))? 1 : 0; break;
		
		case '=':
			v = eval(((Symasgn *)a)->v); /*Recupera o valor*/
			Var *resp = buscaVar(variaveis, ((Varval *)a)->var);
			resp->valor = v;
			break;

		case 's': 
		{
			Var *res = buscaVar(variaveis, ((Varval *)a)->var);
			scanf("%f", &res->valor);
			break;
		}
		case 'I':						/*CASO IF*/
			if (eval(((Flow *)a)->cond) != 0) {	/*executa a condição / teste*/
				if (((Flow *)a)->tl)		/*Se existir árvore*/
					v = eval(((Flow *)a)->tl); /*Verdade*/
				else
					v = 0.0;
			} else {
				if( ((Flow *)a)->el) {
					v = eval(((Flow *)a)->el); /*Falso*/
				} else
					v = 0.0;
				}
			break;
			
		case 'W':
			v = 0.0;
			if( ((Flow *)a)->tl) {
				while( eval(((Flow *)a)->cond) != 0){
					v = eval(((Flow *)a)->tl);
					}
			}
		break;
			
		case 'L': eval(a->l); v = eval(a->r); break; /*Lista de operções em um bloco IF/ELSE/WHILE. Assim o analisador não se perde entre os blocos*/
		
		case 'P': 	v = eval(a->l);		/*Recupera um valor*/
					printf ("%.2f\n",v); break;  /*Função que imprime um valor*/
		
		default: printf("internal error: bad node %c\n", a->nodetype);
				
	}
	return v;
}

int yylex();
void yyerror (char *s){
	printf("%s\n", s);
}

%}

%union{
	char str[51];
	float flo;
	int fn;
	int inte;
	Ast *a;
	}

%token <flo>NUM
%token <str>TIPO 
%token <str>VAR 
%token START END OUTPUT INPUT IF ELSE WHILE
%token <fn> CMP

%left '+' '-'
%left '*' '/'
%right '^' '#'
%right '=' 

%type <a> exp list stmt prog

%nonassoc IFX NEG

%%

val: START prog END
	;

prog: stmt 		{eval($1);}  
	| prog stmt {eval($2);}	 
	;

/*Funções para análise sintática e criação dos nós na AST*/	
/*Verifique q nenhuma operação é realizada na ação semântica, apenas são criados nós na árvore de derivação com suas respectivas operações*/
	
stmt: IF '(' exp ')' '{' list '}' %prec IFX {$$ = newflow('I', $3, $6, NULL);}
	| IF '(' exp ')' '{' list '}' ELSE '{' list '}' {$$ = newflow('I', $3, $6, $10);}
	| WHILE '(' exp ')' '{' list '}' {$$ = newflow('W', $3, $6, NULL);}
	| TIPO VAR '=' exp {$$ = newasgn($2,$4);}
	| VAR '=' exp {$$ = newasgn($1,$3);}
	| OUTPUT '(' exp ')' { $$ = newast('P',$3,NULL);}
	| INPUT  '(' VAR ')' { $$ = inputVar($3);}
	;

list:	  stmt{$$ = $1;}
		| list stmt { $$ = newast('L', $1, $2);	}
		;

exp: 
	 exp '+' exp {$$ = newast('+',$1,$3);}		
	|exp '-' exp {$$ = newast('-',$1,$3);}
	|exp '*' exp {$$ = newast('*',$1,$3);}
	|exp '/' exp {$$ = newast('/',$1,$3);}
	|exp '^' exp {$$ = newast('^',$1,$3);}
	|exp '#' exp {$$ = newast('#',$1,$3);}
	|exp CMP exp {$$ = newcmp($2,$1,$3);}		
	|'(' exp ')' {$$ = $2;}
	|'-' exp %prec NEG {$$ = newast('M',$2,NULL);}
	|NUM {$$ = newnum($1);}						
	|VAR {$$ = newValorVal($1);}				
	;

%%

#include "lex.yy.c"
int main(){
	yyin=fopen("cod3.txt", "r");
	yyparse();
    yylex();
    fclose(yyin);
    return 0;
}