%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "y.tab.h"

void yyerror(char *s);
int yylex();
int sym[26];                    /* symbol table */
%}

%union semrec {
    int iValue;
    double dValue;
    char *sValue;
    char *sconsValue;
    int  boolValue;
}

%token <iValue> intConst
%token <sValue> VARIABLE
%token <boolValue> boolConst
%token <dValue> doubleConst
%token <boolValue> stringConst
%token WHILE IF PRINT FOR BOOLEAN BREAK CLASS DOUBLE EXTENDS INT INTERFACE IMPL ISNULL RETURN STRING
%token OSQ CSQ THIS VOID NEW NEWARRAY READINTERGER READLINE
%nonassoc IFX
%nonassoc ELSE

%left AND OR
%left '!' GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS


%%

program:
        function           
        ;

function:
          function stmt                  {  printf("statement is valid\n");  }   
        | /* NULL */
        ;



/* statement declarations */
stmt:
          ';'                                         {  }
        | expr ';'                                    {  }
        | print_decl                                  {  }
        | VARIABLE '=' expr ';'                       {  }
        | decl                                        {  }
        | for_stmt                                    {  }
        | WHILE '(' expr ')'  stmt                    {  }
        | if_stmt                                     {  }
        | '{' stmt_list '}'                           {  }
        | return_stmt                                 {  }
        | BREAK ';'                                   {  }
        ;

stmt_list:
          stmt                          {  }
        | stmt_list stmt                {  }
        |
        ;
/* statement Declarations End */




/* declarations type */
decl : 
          variableDecl               {  }
        | functionDecl               {  }
        | classDecl                  {  }
        | interfaceDecl
        ;
/* declarations type end */




/* Variable Declarations */
variableDecl : 
          type VARIABLE ';'                 {  }
        | type VARIABLE '=' constant ';'    {  }
        ;
/* Variable Declarations End */



/* function declarations */
functionDecl : 
        type VARIABLE '(' formal ')' stmt               { } 
        | VOID VARIABLE '(' formal ')' stmt             { } 
        ;
/* function declarations end */



/* Class Declarations */
classDecl :
        CLASS VARIABLE '{' field '}' { }
        | CLASS VARIABLE EXTENDS VARIABLE '{' field '}' { }
        | CLASS VARIABLE IMPL impl_decl '{' field '}' { }
        ;

impl_decl :
        VARIABLE  { }
        | impl_decl ',' VARIABLE { }
        ;
/* Class Declarations End */




/* Interface Declarations */
interfaceDecl :
        INTERFACE VARIABLE '{' prototype '}'    { } 
        ;
/* Class Interface Declarations End */



/* prototype Declarations */
prototype :
        type VARIABLE '('formal ')' ';'                 { }
        | VOID VARIABLE '('formal ')' ';'               { }
        | prototype type VARIABLE '('formal ')' ';'     { }
        | prototype VOID VARIABLE '('formal ')' ';'     { }
        |
        ;
/* prototype declarations end */




/* for statement declarations */
for_stmt : 
        FOR '(' for_decl ';' expr ';' for_decl ')' stmt { }
        ;

for_decl : 
        expr   { }
        |
        ;
/* for statement declarations end */




/* print statements declarations */
print_decl :
        PRINT '(' print_stmt ')' ';' { }
        ;

print_stmt :
        expr  { }
        | print_stmt ',' expr { }
        ;
/* print statements declarations end */




/* if statements declarations */
if_stmt :
        IF '(' expr ')' stmt ELSE stmt 
        ;
/* if statements declarations end */




/* return statements declarations */
return_stmt :
        RETURN ';'              { }
        | RETURN expr ';'       { }
        ;
/* return statements declarations end */




/* field declarations */
field : 
        variableDecl            { }
        | functionDecl          { }
        | field variableDecl    { }
        | field functionDecl    { }
        |
        ;
/* field declarations end */




/* formal declarations */
formal :
        type VARIABLE                   { }
        | formal ',' type VARIABLE      { }
        | 
        ;
/* formal declarations end */




/* type declarations */
type : 
        BOOLEAN                     {  } 
        | INT                       {  } 
        | STRING                    {  } 
        | DOUBLE                    {  } 
        | VARIABLE                  {  } 
        | type OSQ CSQ              {  } 
        ;
/* type declarations end */




/* expression declarations */
expr:
        constant                                {  }
        | VARIABLE                              {  }
        | THIS                                  {  }
        | '-' expr %prec UMINUS                 {  }
        | expr '+' expr                         {  }
        | expr '-' expr                         {  }
        | expr '*' expr                         {  }
        | expr '/' expr                         {  }
        | expr '<' expr                         {  }
        | expr '>' expr                         {  }
        | expr GE expr                          {  }
        | expr LE expr                          {  }
        | expr NE expr                          {  }
        | expr EQ expr                          {  }
        | '(' expr ')'                          {  }
        | call                                  {  }
        | lvalue '=' expr                       {  }
        | expr AND expr                         {  }
        | expr OR expr                          {  }
        | '!' expr                              {  }
        | READINTERGER '(' ')'                  {  }
        | READLINE '(' ')'                      {  }
        | NEW '(' VARIABLE ')'                  {  }
        | NEWARRAY '(' expr ',' type ')'        {  }
        ;
/* expression declarations end */




/* constant declarations */
constant :
        intConst        { } 
        | boolConst     { } 
        | stringConst   { } 
        | doubleConst   { } 
        | ISNULL        { }
        ;
/* constant declarations end */




/* call declarations */
call : 
        VARIABLE '('actuals ')'                 { }
        | expr '.' VARIABLE '('actuals ')'      { }
        ;
/* call declarations end */



/* actuals declarations */
actuals :
          expr           { }
        | actuals ',' expr { }
        |
        ;
/* actuals declarations end */




/* lvalue declarations */
lvalue :
        VARIABLE   { }
        | expr '.' VARIABLE  { }
        | expr '[' expr ']'  { }
        ;
/* lvalue declarations end */

%%
int yywrap(){
    return 1;
}

void yyerror(char *s) {
    fprintf(stdout, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
