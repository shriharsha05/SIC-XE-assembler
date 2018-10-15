%{
	void yyerror(char *s);
	extern char *yytext;
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	char *feild1,*feild2,*feild3,*feild4,op3id[20],add_f[5],add_disp[4];
	int addr_;
	int loop1=0;
	char reg[3];
	int regcount=-1;
	char OBJ[1000][20];
	int objadd[1000];
	extern FILE * yyin;
	int counter=0,add_flag;
	extern int yylineno;
	int op3code,op3value,op4code;
	int i,k;
	char a_v[10];
	struct symtab
	{
		int add;
		char variable[20];
	};
	struct symtab SYMTAB[1000];
	int scount=0,displacement=0,calc_disp,BASE_R=0;
	int SEARCH_SYMTAB(char op3id[20]);
	int start_address=0,end_address=0;
	char pgm_name[7];
%}

%union
{
	char *format1,*format2;
	int addr_;
	char dummy1[20],dummy2[20];
	int decval;
}

%start INSTRUCTIONS
%token opcode1 opcode2 address declare opcode21 special opcode3 cdec opcode4 sicregister assemble value byte word resb resw start end base_register

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
	|address
	;

DECLARATION:address identifier byte cdec'\''identifier'\'''\n'
															{
																objadd[counter]=addr_;
																sprintf(OBJ[counter],"%0X",$6[0]);
																for(loop1=1;loop1<strlen($6);loop1++)
																{
																	sprintf(a_v,"%0X",$6[loop1]);
																	strcat(OBJ[counter],a_v);
																}
																counter++;
															}
			|address identifier word value	'\n'			{
																objadd[counter]=addr_;
																sprintf(OBJ[counter++],"%0X",op3value);
															}
			|address identifier resw value	'\n'
			|address identifier resb value	'\n'
			;

ASSEMBLER:address identifier assemble '\n'
		|address identifier assemble '#'value '\n'

		|address identifier start '#'value '\n'						{
																		strncpy(pgm_name,$2,6);
																		pgm_name[7]='\0';
																		start_address=op3value;
																	}

		|address identifier start '\n'								{
																		strncpy(pgm_name,$2,6);
																		pgm_name[7]='\0';
																	}
		|address base_register identifier '\n'                               {
																		BASE_R=SEARCH_SYMTAB($3);
																	}
		|address assemble identifier '\n'

		|address end '\n'	{end_address=addr_;}

		|address assemble '\n'
		;

FORMAT1:address identifier opcode1 '\n'	{
											//printf("%s\n",yylval.format1);
											strcpy(OBJ[counter],yylval.format1);
											objadd[counter++]=addr_;
										}
		|address opcode1 '\n'			{
											//printf("%s\n",yylval.format1);
											strcpy(OBJ[counter],yylval.format1);
											objadd[counter++]=addr_;
										}
		;

FORMAT2:address identifier opcode2 sicregister ',' sicregister '\n'
															{
																//printf("%s%c%c\n",yylval.format2,reg[0],reg[1]);
																objadd[counter]=addr_;
																strcpy(OBJ[counter],yylval.format2);
																strcat(OBJ[counter++],reg);
																regcount=-1;
															}
		|address opcode2 sicregister ',' sicregister '\n'	{
																//printf("%s%c%c\n",yylval.format2,reg[0],reg[1]);
																objadd[counter]=addr_;
																strcpy(OBJ[counter],yylval.format2);
																strcat(OBJ[counter++],reg);
																regcount=-1;
															}
		|address identifier opcode21 sicregister '\n'		{
																//printf("%s%c0\n",yylval.format2,reg[0]);
																reg[1]='0';
																objadd[counter]=addr_;
																strcpy(OBJ[counter],yylval.format2);
																strcat(OBJ[counter++],reg);
																regcount=-1;
															}
		|address opcode21 sicregister '\n'					{
																//printf("%s%c0\n",yylval.format2,reg[0]);
																objadd[counter]=addr_;
																strcpy(OBJ[counter],yylval.format2);
																strcat(OBJ[counter++],reg);
																regcount=-1;
															}
		;

FORMAT3:address identifier opcode3 operand3 '\n'
		|address opcode3 operand3 '\n'
		;

operand3:identifier							{
												op3code+=3;
												//printf("%d\t3:%02X",yylineno,op3code);
												displacement=SEARCH_SYMTAB(op3id);
												calc_disp=displacement-addr_-3;
												objadd[counter]=addr_;
												if(calc_disp>=-2048 && calc_disp<2048)
													add_flag=2;
												else
												{
													calc_disp=displacement-BASE_R;
													if(calc_disp>=0 && calc_disp<4096)
														add_flag=4;
												}
												sprintf(OBJ[counter],"%02X",op3code);
												sprintf(add_f,"%X",add_flag);
												strcat(OBJ[counter],add_f);
												sprintf(add_disp,"%03X",calc_disp);
												//printf("a:%s\n",add_disp);
												if(calc_disp<0)
													strcat(OBJ[counter++],add_disp+5);
												else
													strcat(OBJ[counter++],add_disp);
											}
		|identifier ',' sicregister
											{
												op3code+=3;
												//printf("%d\t3:%02X",yylineno,op3code);
												displacement=SEARCH_SYMTAB(op3id);
												calc_disp=displacement-addr_-3;
												objadd[counter]=addr_;
												if(calc_disp>=-2048 && calc_disp<2048)
													add_flag=10;
												else
												{
													calc_disp=displacement-BASE_R;
													if(calc_disp>=0 && calc_disp<4096)
														add_flag=12;
												}
												sprintf(OBJ[counter],"%02X",op3code);
												sprintf(add_f,"%X",add_flag);
												strcat(OBJ[counter],add_f);
												sprintf(add_disp,"%03X",calc_disp);
												//printf("a:%s\n",add_disp);
												if(calc_disp<0)
													strcat(OBJ[counter++],add_disp+5);
												else
													strcat(OBJ[counter++],add_disp);
											}
		|'#' identifier
											{
												op3code+=1;
												//printf("%d\t3:%02X",yylineno,op3code);
												displacement=SEARCH_SYMTAB(op3id);
												calc_disp=displacement-addr_-3;
												objadd[counter]=addr_;
												if(calc_disp>=-2048 && calc_disp<2048)
													add_flag=2;
												else
												{
													calc_disp=displacement-BASE_R;
													if(calc_disp>=0 && calc_disp<4096)
														add_flag=4;
												}
												sprintf(OBJ[counter],"%02X",op3code);
												sprintf(add_f,"%X",add_flag);
												strcat(OBJ[counter],add_f);
												sprintf(add_disp,"%03X",calc_disp);
												//printf("a:%s\n",add_disp);
												if(calc_disp<0)
													strcat(OBJ[counter++],add_disp+5);
												else
													strcat(OBJ[counter++],add_disp);
											}
		|'@' identifier
											{
												op3code+=2;
												//printf("%d\t3:%02X",yylineno,op3code);
												displacement=SEARCH_SYMTAB(op3id);
												calc_disp=displacement-addr_-3;
												objadd[counter]=addr_;
												if(calc_disp>=-2048 && calc_disp<2048)
													add_flag=2;
												else
												{
													calc_disp=displacement-BASE_R;
													if(calc_disp>=0 && calc_disp<4096)
														add_flag=4;
												}
												sprintf(OBJ[counter],"%02X",op3code);
												sprintf(add_f,"%X",add_flag);
												strcat(OBJ[counter],add_f);
												sprintf(add_disp,"%03X",calc_disp);
												//printf("a:%s\n",add_disp);
												if(calc_disp<0)
													strcat(OBJ[counter++],add_disp+5);
												else
													strcat(OBJ[counter++],add_disp);
											}
		|'#' value							{
												op3code+=1;
												//printf("%d\t3:%02X",yylineno,op3code);
												displacement=SEARCH_SYMTAB(op3id);
												objadd[counter]=addr_;
												add_flag=0;
												sprintf(OBJ[counter],"%02X",op3code);
												sprintf(add_f,"%X",add_flag);
												strcat(OBJ[counter],add_f);
												sprintf(add_disp,"%03X",op3value);
												//printf("a:%s\n",add_disp);
												strcat(OBJ[counter++],add_disp);
											}
		|'@' value							{
												op3code+=2;
												//printf("%d\t3:%02X",yylineno,op3code);
												displacement=SEARCH_SYMTAB(op3id);
												objadd[counter]=addr_;
												add_flag=0;
												sprintf(OBJ[counter],"%02X",op3code);
												sprintf(add_f,"%X",add_flag);
												strcat(OBJ[counter],add_f);
												sprintf(add_disp,"%03X",op3value);
												//printf("a:%s\n",add_disp);
												strcat(OBJ[counter++],add_disp);
											}
		;

FORMAT4:address identifier opcode4 operand4 '\n'
		|address opcode4 operand4 '\n'
		;

operand4:identifier							{
												op4code+=3;
												objadd[counter]=addr_;
												displacement=SEARCH_SYMTAB(op3id);
												add_flag=1;
												sprintf(OBJ[counter],"%02X",op4code);
												sprintf(add_f,"%X",add_flag);
												strcat(OBJ[counter],add_f);
												sprintf(add_disp,"%05X",displacement);
												strcat(OBJ[counter++],add_disp);
											}
		|identifier ',' sicregister			{
												op4code+=3;
												objadd[counter]=addr_;
												displacement=SEARCH_SYMTAB(op3id);
												add_flag=9;
												sprintf(OBJ[counter],"%02X",op4code);
												sprintf(add_f,"%X",add_flag);
												strcat(OBJ[counter],add_f);
												sprintf(add_disp,"%05X",displacement);
												strcat(OBJ[counter++],add_disp);
											}
		|'#' identifier						{
												op4code+=1;
												objadd[counter]=addr_;
												displacement=SEARCH_SYMTAB(op3id);
												add_flag=1;
												sprintf(OBJ[counter],"%02X",op4code);
												sprintf(add_f,"%X",add_flag);
												strcat(OBJ[counter],add_f);
												sprintf(add_disp,"%05X",displacement);
												strcat(OBJ[counter++],add_disp);
											}
		|'@' identifier						{
												op4code+=2;
												objadd[counter]=addr_;
												displacement=SEARCH_SYMTAB(op3id);
												add_flag=1;
												sprintf(OBJ[counter],"%02X",op4code);
												sprintf(add_f,"%X",add_flag);
												strcat(OBJ[counter],add_f);
												sprintf(add_disp,"%05X",displacement);
												strcat(OBJ[counter++],add_disp);
											}
		;

%%

void yyerror(char *s)
{
	FILE *fp4=fopen("Error.txt","w");
    fprintf(fp4,"ERROR ON LINE %d : %s", yylineno-1,s);
    fclose(fp4);
    printf("\nERROR ON LINE %d : at %s\n", yylineno,yytext);
    exit(0);
}

int SEARCH_SYMTAB(char op3id[20])
{
	for(i=0;i<scount;i++)
		if(strcmp(SYMTAB[i].variable,op3id)==0)
			return SYMTAB[i].add;

	printf("\n\nERROR in line %d\n%s not defined.\n",yylineno,op3id);
	exit(0);
	return -1;
}

int main()
{
	int k=0,k1=0,j,temp1=0,flag1=0;
	FILE *fp3 = fopen("objectProgram.txt","w");
	FILE *fp=fopen("symbol.txt","r");
	fscanf(fp,"%d",&scount);
	for(k=0;k<scount;k++)
		fscanf(fp,"%d%s",&SYMTAB[k].add,SYMTAB[k].variable);
	fclose(fp);
	yyin=fopen("INTERMEDIATE.txt","r");
	yyparse();
	for(i=0;i<counter;i++)
		fprintf(fp3,"%0X\t%s\t%ld\n",objadd[i],OBJ[i],strlen(OBJ[i]));
	fprintf(fp3,"Start address: %d\n",start_address);
	fprintf(fp3,"End address: %d\n",end_address);
	fprintf(fp3,"Name: %s\n\n\n",pgm_name);
	fprintf(fp3,"H^%-6s^%06X^%06X\n",pgm_name,start_address,end_address);
	k=0;i=0;j=0;
	while(j<counter)
	{
		k=j;
		i=0;
		while(i<60)
		{
			if(j>=counter)
			{
				fprintf(fp3,"T^%06X^%0X",objadd[k],objadd[counter-1]-objadd[k]);
				flag1=1;
				break;
			}
			j++;
			i+=strlen(OBJ[j]);
		}
		if(flag1==0)
			fprintf(fp3,"T^%06X^%0X",objadd[k],objadd[j]-objadd[k]);
		for(k1=k;k1<j;k1++)
			fprintf(fp3,"^%s",OBJ[k1]);
		fprintf(fp3,"\n");
	}
	fprintf(fp3,"E^%06X\n",start_address);
}
