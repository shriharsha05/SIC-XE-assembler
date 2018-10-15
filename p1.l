%{
	#include <stdio.h>
	#include "y.tab.h"
	extern char op3id[20];
	extern int op3value,addr_;
	extern FILE *fp2;
%}
%%

"START" {fprintf(fp2,"%s",yytext);return assemble;}
"END"	{fprintf(fp2,"%s",yytext);return assemble;}
"BASE"	{fprintf(fp2,"%s",yytext);return assemble;}

"A"	|
"L"	|
"B"	|
"S"	|
"T"	|
"F"		{fprintf(fp2,"%s",yytext);return sicregister;}
"C"		{fprintf(fp2,"%s",yytext);return cdec;}
"X"		{fprintf(fp2,"%s",yytext);return special;}

"ADDR"	|
"COMPR"	|
"DIVR"	|
"MULR"	|
"RMO"	|
"SUBR"	{addr_+=2;fprintf(fp2,"%s",yytext);return opcode2;}

"CLEAR"	|
"TIXR"	{addr_+=2;fprintf(fp2,"%s",yytext);return opcode21;}

"TIO"	|
"SIO"	|
"NORM"	|
"FLOAT"	|
"FIX"	|
"HIO"	{addr_+=1;fprintf(fp2,"%s",yytext);return opcode1;}

"ADD"	|
"ADDF"	|
"AND"	|
"COMP"	|
"COMPF"	|
"DIV"	|
"DIVF"	|
"J"		|
"JEQ"	|
"JGT"	|
"JLT"	|
"JSUB"	|
"LDA"	|
"LDB"	|
"LDCH"	|
"LDF"	|
"LDL"	|
"LDS"	|
"LDT"	|
"LDX"	|
"LPS"	|
"MUL"	|
"MULF"	|
"OR"	|
"RD"	|
"RSUB"	|
"SSK"	|
"STA"	|
"STB"	|
"STCH"	|
"STF"	|
"STI"	|
"STL"	|
"STS"	|
"STSW"	|
"STT"	|
"STX"	|
"SUB"	|
"SUBF"	|
"TD"	|
"TIX"	|
"WD"	{addr_+=3;fprintf(fp2,"%s",yytext);return opcode3;}

"+ADD"	|
"+ADDF"	|
"+AND"	|
"+COMP"	|
"+COMPF"	|
"+DIV"	|
"+DIVF"	|
"+J"	|
"+JEQ"	|
"+JGT"	|
"+JLT"	|
"+JSUB"	|
"+LDA"	|
"+LDB"	|
"+LDCH"	|
"+LDF"	|
"+LDL"	|
"+LDS"	|
"+LDT"	|
"+LDX"	|
"+LPS"	|
"+MUL"	|
"+MLF"	|
"+OR"	|
"+RD"	|
"+RSUB"	|
"+SSK"	|
"+STA"	|
"+STB"	|
"+STCH"	|
"+STF"	|
"+STI"	|
"+STL"	|
"+STS"	|
"+STSW"	|
"+STT"	|
"+STX"	|
"+SUB"	|
"+SUBF"	|
"+TD"	|
"+TIX"	|
"+WD"	{addr_+=4;fprintf(fp2,"%s",yytext);return opcode4;}

"BYTE"	{yylval.decval=1;fprintf(fp2,"%s",yytext);return byte;}
"WORD"	{yylval.decval=3;fprintf(fp2,"%s",yytext);return word;}
"RESB"	{yylval.decval=1;fprintf(fp2,"%s",yytext);return resb;}
"RESW"	{yylval.decval=3;fprintf(fp2,"%s",yytext);return resw;}

[a-zA-Z][a-zA-Z0-9]*	{fprintf(fp2,"%s",yytext);strcpy(op3id,yytext);strcpy(yylval.dummy1,yytext);return identifier;}
[0-9]+					{fprintf(fp2,"%s",yytext);op3value=atoi(yytext);return value;}
[ \t]+					fprintf(fp2," ");
[,#@]					{fprintf(fp2,"%s",yytext);return yytext[0];}
[\n]					{fprintf(fp2,"\n");yylineno++;return yytext[0];}
[']					{fprintf(fp2,"%c",yytext[0]);return yytext[0];}
.						fprintf(fp2,"");
%%
int yywrap(void)
{
	return 1;
}

void yyerror(char *s)
{
	FILE *fp=fopen("Error.txt","w");
    fprintf(fp,"ERROR ON LINE %d : %s", yylineno-1,s);
    fclose(fp);
    fprintf(stderr,"\nERROR ON LINE %d : %s\n\n", yylineno-1,s);
	exit(0);
}
