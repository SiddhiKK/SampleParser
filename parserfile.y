%{
	 #include<stdio.h>
	 #include<string.h>

	 int err=0;
	 extern void put(char[],char[]);
	 extern char *yytext;
	 char id[10];
%}

%token HASH INCLUDE LT GT OPERATOR HEADER DEFINE NUMBER OC CC OR CR COMMA VOID END MAIN COMMENT LITERAL PRINTF SCANF DATATYPE RELOP DO IF ELSE FOR WHILE ASSIGNMENT IDENTIFIER

%%
 P:H C { printf("\nProgram is Syntactically correct!!");}	 
 H:HASH INCLUDE LT HEADER GT H
  |HASH DEFINE IDENTIFIER NUMBER H
  |;
 C:F part C|;
 F:D OR param CR
 param:D|;
 part:block|END	
 block:OC S CC
 S:PF S
  |block S
  |SF S
  |D S
  |NUMBER X S
  |IDENTIFIER { strcpy(id,yytext); } X S
  |COMMENT S
  |Condition S
  |Whileloop S 
  |Forloop S
  |END
  |;
 X:END 
  |OPERATOR S
  |ASSIGNMENT IDENTIFIER X
  |ASSIGNMENT NUMBER { put(id,yytext); } S
 PF:PRINTF OR LITERAL COMMA IDENTIFIER CR END|PRINTF OR LITERAL CR END
 SF:SCANF OR LITERAL COMMA '&' IDENTIFIER CR END
 Condition:Ifstmt
          |Elsestmt
 Ifstmt:IF OR Cond CR block
 Cond:IDENTIFIER RELOP IDENTIFIER
     |IDENTIFIER RELOP NUMBER
     |IDENTIFIER LT IDENTIFIER
     |IDENTIFIER LT NUMBER
     |IDENTIFIER GT IDENTIFIER
     |IDENTIFIER GT NUMBER
     |NUMBER
     |IDENTIFIER
 Elsestmt:ELSE block
         |ELSE Ifstmt
 Whileloop:WHILE OR Cond CR block
          |DO block WHILE OR Cond CR END
 Forloop:FOR OR IDENTIFIER { strcpy(id,yytext); } Init END Cond END Step CR block
 Init:ASSIGNMENT NUMBER { put(id,yytext); }
     |;
 Step:IDENTIFIER OPERATOR OPERATOR
 T:COMMA IDENTIFIER { strcpy(id,yytext); } N
  |END
 D:DATATYPE IDENTIFIER { strcpy(id,yytext); } N
  |DATATYPE D
  |MAIN
 O:OPERATOR NUMBER T
  |ASSIGNMENT NUMBER { put(id,yytext); } T
  |ASSIGNMENT IDENTIFIER
 N:T 
  |O
%%

extern FILE *yyin;

int main(int argc,char* argv[])
{
	 yyin=fopen(argv[1],"r");
	 yyparse();
	 if(!err)
	 { 
		 printf("\nParsed successfully\n");
		 dispTable();
	 } 
	 else
	 	printf("\n Cannot parse\n");
	return 1;
}

yyerror(char *s)
{
	 extern int line;
	 printf("ERROR: %s : %s  at line number %d\n",s,yytext,line);
	 err=1;
}
