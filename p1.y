%{
	extern char *yytext;
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	char op3id[20];
	extern FILE * yyin;
	extern int yylineno;
	int op3code,op3value,op4code;
	int i,k,addr_=0;
	FILE *fp2;
	struct symtab
	{
		int add;
		char variable[20];
	};
	struct symtab SYMTAB[1000];
	int BASE_R=0,scount=0;
	int SEARCH_SYMTAB(char op3id[20]);
%}

%define parse.lac full
%define parse.error verbose

%union
{
	char dummy1[20],dummy2[20];
	int decval;
}

%start INSTRUCTIONS
%token opcode1 opcode2 declare opcode21 special opcode3 cdec opcode4 sicregister assemble value byte word resb resw

%token <dummy1> identifier

%%

INSTRUCTIONS:LINE
			|LINE INSTRUCTIONS
			;

LINE:FORMAT1
	|FORMAT2
	|FORMAT3
	|FORMAT4
	|ASSEMBLER
	|DECLARATION
	|'\n'
	;

DECLARATION:identifier byte cdec'\''identifier'\'''\n'
															{
																INSERT($1,addr_);
																addr_+=strlen($5);
																fprintf(fp2,"%dH\t",addr_);
															}
			|identifier word value	'\n'					{
																INSERT($1,addr_);
																addr_+=3;
																fprintf(fp2,"%dH\t",addr_);
															}
			|identifier resw value	'\n'					{
																INSERT($1,addr_);
																addr_+=3*op3value;
																fprintf(fp2,"%dH\t",addr_);
															}
			|identifier resb value	'\n'						{
																INSERT($1,addr_);
																addr_+=op3value;
																fprintf(fp2,"%dH\t",addr_);
															}
			;

ASSEMBLER:identifier assemble '\n'							{INSERT($1,addr_);fprintf(fp2,"%dH\t",addr_);}
		
		|identifier assemble '#'value '\n'		{INSERT($1,addr_);addr_=op3value;fprintf(fp2,"%dH\t",addr_);}
		
		|assemble identifier '\n'							{fprintf(fp2,"%dH\t",addr_);}
		
		|assemble '\n'										{fprintf(fp2,"%dH\t",addr_);}
		;

FORMAT1:identifier opcode1 '\n'								{INSERT($1,addr_-1);fprintf(fp2,"%dH\t",addr_);}
		|opcode1 '\n'										{fprintf(fp2,"%dH\t",addr_);}
		;

FORMAT2:identifier opcode2 def_register ',' def_register '\n'	{INSERT($1,addr_-2);fprintf(fp2,"%dH\t",addr_);}
		
		|opcode2 def_register ',' def_register '\n'			{fprintf(fp2,"%dH\t",addr_);}
		
		|identifier opcode21 def_register '\n'				{INSERT($1,addr_-2);fprintf(fp2,"%dH\t",addr_);}
		
		|opcode21 def_register '\n'							{fprintf(fp2,"%dH\t",addr_);}
		;

def_register:sicregister
			|special
			;

FORMAT3:identifier opcode3 operand3 '\n'					{INSERT($1,addr_-3);fprintf(fp2,"%dH\t",addr_);}
		
		|opcode3 operand3 '\n'								{fprintf(fp2,"%dH\t",addr_);}
		;

operand3:identifier
		|identifier ',' special
		|'#' identifier
		|'@' identifier
		|'#' value
		|'@' value
		;

FORMAT4:identifier opcode4 operand4 '\n'					{INSERT($1,addr_-4);fprintf(fp2,"%dH\t",addr_);}
		
		|opcode4 operand4 '\n'								{fprintf(fp2,"%dH\t",addr_);}
		;

operand4:identifier
		|identifier ',' special
		|'#' identifier
		|'@' identifier
		;

%%

int SEARCH_SYMTAB(char op3id[20])
{
	for(i=0;i<scount;i++)
		if(strcmp(SYMTAB[i].variable,op3id)==0)
			return 1;
	return 0;
}

int INSERT(char op3id[20],int address)
{
	if(SEARCH_SYMTAB(op3id))
	{
		printf("\n\nERROR: Symbol %s redifined in line %d\n\n\n",op3id,yylineno-1);
		exit(0);
	}
	strcpy(SYMTAB[scount].variable,op3id);
	SYMTAB[scount].add=address;
	scount++;
	return 0;
}

int main()
{
	yyin=fopen("program.asm","r");
	fp2=fopen("INTERMEDIATE.txt","w");
	fprintf(fp2,"0H\t");
	yyparse();
	int i;
	FILE *fp1=fopen("symbol.txt","w");
	fprintf(fp1,"%d\n",scount);
	for(i=0;i<scount-1;i++)
		fprintf(fp1,"%d %s\n",SYMTAB[i].add,SYMTAB[i].variable);
	fprintf(fp1,"%d %s",SYMTAB[i].add,SYMTAB[i].variable);
	fclose(fp1);
}
