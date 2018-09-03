%{
	 #include "y.tab.h"

	 int line=1;
	 int insert(char[]);
	 int func();
	 void put(char[],char[]);
	 void dispTble();

	 struct tp 		//Structure for storing datatypes
	 {
	 	char tpt[10];
	 }t1[50];

	 struct table           //Structure for symbol table
	 {
		  char n[20];
		  char val[15];
		  char typ[10];
	 }st[50]; 

	 char temp[100];
	 int t=0,c=0;
%}

%%
[\t]+ ;
[\n] { line++; }
\# { return HASH;}
\< { return LT;}
include { return INCLUDE;}
\/\*(.*|\n)*\*\/ 	{  return COMMENT;  }
\/\/.* {  return COMMENT; }
\"[_a-zA-Z0-9\-%= ]*\"     { return LITERAL;  }
\, 	{ return COMMA;  }
\{ 	{ return OC;  }
\} 	{ return CC;  }
\; 	{ return END;  }
main  	{ return MAIN; }
\> 	{ return GT; }
\( 	{ return OR;  }
\) 	{ return CR; }
define 	{ return DEFINE;  }
if { return IF; }
do { return DO; }
else { return ELSE; }
for { return FOR; }
while { return WHILE; }
scanf 	{ return SCANF;  }
printf	{ return PRINTF;  }
[0-9]* 	{ return NUMBER;  }
void|int|float|char|short|long { strcpy(t1[t].tpt,yytext);
                                 return DATATYPE;   
                               } 
[0-9]+\.+[0-9]* 	{ return NUMBER;  }
[a-zA-Z_]+[_a-zA-Z0-9]*	{ insert(yytext); 
                          t++;
                          strcpy(t1[t].tpt,"");
                          return IDENTIFIER; 
                        } 
\+|\-|\*|\/|\% { return OPERATOR; }
\= { return ASSIGNMENT; }
\>=|\<=|\==|\!= { return RELOP; }
[a-zA-Z0-9]*\.h  { return HEADER; }
%%

int yywrap()
{
	return 1;
}

void dispTable()
{
	 printf("\n\nSymbol Table:\n");
	 printf("\nVARIABLE\tVALUE\t\t\tDATATYPE");
	 printf("\n--------------------------------------------------------------");
	 int i;
	 for(i=0;i<c;i++)
	 {
		  if(!strcmp(t1[i].tpt,""))
		  {
			   int p=i-1;
			   strcpy(st[i].typ,st[p].typ);
		  }
		  else 
		  { 
			  strcpy(st[i].typ,t1[i].tpt);
		  }
	 }
	 for(i=0;i<c;i++)
	 {
		  printf("\n%s",st[i].n);
		  if(!strcmp(st[i].val,""))
		  	strcpy(st[i].val,"Uninitialized");
		  printf("\t\t%s",st[i].val);
		  printf("\t\t\t%s",st[i].typ);
	 }
	 printf("\n");
}

void put(char x[10],char v[10])
{
	 int k;
	 for(k=0;k<c;k++)
	 {
		  if(!strcmp(st[k].n,x))
			strcpy(st[k].val,v);
	 }
}

int insert(char a[10])
{
	 int i;
	 for(i=0;i<c;i++)
	 {
	  	if(strcmp(a,st[i].n)==0) return i;
	 }
	 strcpy(st[c].n,a);
	 return c++;
}
