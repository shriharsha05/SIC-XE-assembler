%{
	#include <stdio.h>
	#include "y.tab.h"
	extern char reg[3];
	extern int regcount;
	extern int addr_;
	extern int op3code,op4code,op3value;
	extern char op3id[20];
%}

%%

"START" {return start;}
"END" {return end;}
"BASE" {return base_register;}

"A"		{reg[(regcount+1)%2]='0';regcount=(regcount+1)%2;return sicregister;}
"X"		{reg[(regcount+1)%2]='1';regcount=(regcount+1)%2;return sicregister;}
"L"		{reg[(regcount+1)%2]='2';regcount=(regcount+1)%2;return sicregister;}
"B"		{reg[(regcount+1)%2]='3';regcount=(regcount+1)%2;return sicregister;}
"S"		{reg[(regcount+1)%2]='4';regcount=(regcount+1)%2;return sicregister;}
"T"		{reg[(regcount+1)%2]='5';regcount=(regcount+1)%2;return sicregister;}
"F"		{reg[(regcount+1)%2]='6';regcount=(regcount+1)%2;return sicregister;}
"C"		{return cdec;}

"ADDR"	{yylval.format2="90";return opcode2;}
"CLEAR"	{yylval.format2="B4";return opcode21;}
"COMPR"	{yylval.format2="A0";return opcode2;}
"DIVR"	{yylval.format2="9C";return opcode2;}
"MULR"	{yylval.format2="98";return opcode2;}
"RMO"	{yylval.format2="AC";return opcode2;}
"SUBR"	{yylval.format2="94";return opcode2;}
"TIXR"	{yylval.format2="B8";return opcode21;}

"TIO"	{yylval.format1="F8";return opcode1;}
"SIO"	{yylval.format1="F0";return opcode1;}
"NORM"	{yylval.format1="C8";return opcode1;}
"FLOAT"	{yylval.format1="C0";return opcode1;}
"FIX"	{yylval.format1="C4";return opcode1;}
"HIO"	{yylval.format1="F4";return opcode1;}

"ADD"	{op3code=24;return opcode3;}
"ADDF"	{op3code=88;return opcode3;}
"AND"	{op3code=64;return opcode3;}
"COMP"	{op3code=40;return opcode3;}
"COMPF"	{op3code=136;return opcode3;}
"DIV"	{op3code=36;return opcode3;}
"DIVF"	{op3code=100;return opcode3;}
"J"		{op3code=60;return opcode3;}
"JEQ"	{op3code=48;return opcode3;}
"JGT"	{op3code=52;return opcode3;}
"JLT"	{op3code=56;return opcode3;}
"JSUB"	{op3code=72;return opcode3;}
"LDA"	{op3code=0;return opcode3;}
"LDB"	{op3code=104;return opcode3;}
"LDCH"	{op3code=80;return opcode3;}
"LDF"	{op3code=112;return opcode3;}
"LDL"	{op3code=8;return opcode3;}
"LDS"	{op3code=108;return opcode3;}
"LDT"	{op3code=116;return opcode3;}
"LDX"	{op3code=4;return opcode3;}
"LPS"	{op3code=208;return opcode3;}
"MUL"	{op3code=32;return opcode3;}
"MULF"	{op3code=96;return opcode3;}
"OR"	{op3code=68;return opcode3;}
"RD"	{op3code=216;return opcode3;}
"RSUB"	{op3code=76;return opcode3;}
"SSK"	{op3code=236;return opcode3;}
"STA"	{op3code=12;return opcode3;}
"STB"	{op3code=120;return opcode3;}
"STCH"	{op3code=84;return opcode3;}
"STF"	{op3code=128;return opcode3;}
"STI"	{op3code=212;return opcode3;}
"STL"	{op3code=20;return opcode3;}
"STS"	{op3code=124;return opcode3;}
"STSW"	{op3code=232;return opcode3;}
"STT"	{op3code=132;return opcode3;}
"STX"	{op3code=16;return opcode3;}
"SUB"	{op3code=28;return opcode3;}
"SUBF"	{op3code=92;return opcode3;}
"TD"	{op3code=224;return opcode3;}
"TIX"	{op3code=44;return opcode3;}
"WD"	{op3code=220;return opcode3;}

"+ADD"	{op4code=24;return opcode4;}
"+ADDF"	{op4code=88;return opcode4;}
"+AND"	{op4code=64;return opcode4;}
"+COMP"	{op4code=40;return opcode4;}
"+COMPF"	{op4code=136;return opcode4;}
"+DIV"	{op4code=36;return opcode4;}
"+DIVF"	{op4code=100;return opcode4;}
"+J"	{op4code=60;return opcode4;}
"+JEQ"	{op4code=48;return opcode4;}
"+JGT"	{op4code=52;return opcode4;}
"+JLT"	{op4code=56;return opcode4;}
"+JSUB"	{op4code=72;return opcode4;}
"+LDA"	{op4code=0;return opcode4;}
"+LDB"	{op4code=104;return opcode4;}
"+LDCH"	{op4code=80;return opcode4;}
"+LDF"	{op4code=112;return opcode4;}
"+LDL"	{op4code=8;return opcode4;}
"+LDS"	{op4code=108;return opcode4;}
"+LDT"	{op4code=116;return opcode4;}
"+LDX"	{op4code=4;return opcode4;}
"+LPS"	{op4code=208;return opcode4;}
"+MUL"	{op4code=32;return opcode4;}
"+MULF"	{op4code=96;return opcode4;}
"+OR"	{op4code=68;return opcode4;}
"+RD"	{op4code=216;return opcode4;}
"+RSUB"	{op4code=76;return opcode4;}
"+SSK"	{op4code=236;return opcode4;}
"+STA"	{op4code=12;return opcode4;}
"+STB"	{op4code=120;return opcode4;}
"+STCH"	{op4code=84;return opcode4;}
"+STF"	{op4code=128;return opcode4;}
"+STI"	{op4code=212;return opcode4;}
"+STL"	{op4code=20;return opcode4;}
"+STS"	{op4code=124;return opcode4;}
"+STSW"	{op4code=232;return opcode4;}
"+STT"	{op4code=132;return opcode4;}
"+STX"	{op4code=16;return opcode4;}
"+SUB"	{op4code=28;return opcode4;}
"+SUBF"	{op4code=92;return opcode4;}
"+TD"	{op4code=224;return opcode4;}
"+TIX"	{op4code=44;return opcode4;}
"+WD"	{op4code=220;return opcode4;}

"BYTE"	{return byte;}
"WORD"	{return word;}
"RESB"	{return resb;}
"RESW"	{return resw;}


[a-zA-Z][a-zA-Z0-9]*	{strcpy(op3id,yytext);strcpy(yylval.dummy1,yytext);return identifier;}
[0-9]+"H"	{addr_=atoi(yytext);return address;}
[0-9]+	{op3value=atoi(yytext);return value;}
[ \t]+	;
[,#@']	return yytext[0];
[\n]	{yylineno++;return yytext[0];}
.	printf("invalid character at line %d\n",yylineno);
%%
int yywrap(void)
{
	return 1;
}
