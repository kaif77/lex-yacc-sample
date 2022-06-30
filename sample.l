%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
void yyerror(char *);
%}

%%

0           {
               yylval.iValue = atoi(yytext); return intConst;
            }

[1-9][0-9]* {
                 yylval.iValue = atoi(yytext); return intConst;
            }

[0][.][0-9]+ {
                 yylval.dValue = atoi(yytext); return doubleConst;
            }

[1-9][0-9]+[.][0-9]+ {
                 yylval.dValue = atoi(yytext); return doubleConst;
            }

[-()<>=+*/;{}.!%,]  {
                      return *yytext;
                    }

">="                    return GE;
"<="                    return LE;
"=="                    return EQ;
"!="                    return NE;
"&&"                    return AND;
"||"                    return OR;
"while"                 return WHILE;
"if"                    return IF;
"else"                  return ELSE;
"print"                 return PRINT;
"for"                   return FOR;
"bool"                  return BOOLEAN;
"break"                 return BREAK;
"class"                 return CLASS;
"double"                return DOUBLE;
"extends"               return EXTENDS;
"int"                   return INT;
"interface"             return INTERFACE;
"implements"            return IMPL;
"null"                  return ISNULL;
"return"                return RETURN;
"string"                return STRING;
"this"                  return THIS;
"void"                  return VOID;
"New"                   return NEW;
"NewArray"              return NEWARRAY;
"ReadInteger"           return READINTERGER;
"ReadLine"              return READLINE;
"["                     return OSQ;
"]"                     return CSQ;
"true"                      {yylval.boolValue = 1; return boolConst;}
"false"                   {yylval.boolValue = 0; return boolConst;}

[a-zA-Z]+[a-zA-Z0-9_]*    { 
                            yylval.sValue = (char *) strdup(yytext); return VARIABLE;
                          }
['][a-zA-Z]+[a-zA-Z0-9_]*[']    { 
                            yylval.sconsValue = (char *) strdup(yytext); return stringConst;
                          }

[ \t\n]+        ;       /* ignore whitespace */

.               yyerror("Unknown character");
%%
