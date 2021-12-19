%{
    int lineno = 1;
    char log_file_name[80]; // output-file name
    int htoi(const char* hex_int);


    #include "splc_log.hpp"
    #include "ir_code.hpp"
    #include "ast.hpp"
    #include "syntax.hpp"
    #include "string.h"
    #include "stdio.h"
    #include <string>
    #include <iostream>



%}
%option noyywrap
%option yylineno noinput nounput
digit       [0-9]
hex_digit   [0-9a-fA-F]
letter      [a-zA-Z]
letter_     {letter}|_
next_line   \n
empty       [ \n\r\t]

dec_int     0|([1-9]{digit}*)    
hex_int     0[xX](0|[1-9a-fA-F]{hex_digit}*)  
float       {dec_int}\.{digit}+
char        '.'
hex_char    '\\x{hex_digit}{hex_digit}'|'\\x(0|[1-9a-fA-F]{hex_digit})'
id          {letter_}({digit}|{letter_})*

dec_int_err0    0{digit}+             
hex_int_err0    0[xX]0{hex_digit}+  
hex_int_err1    0[xX]([g-zG-Z]+{hex_digit}*)* 

float_err0  {digit}*\.{digit}*

char_err0   '\\x{hex_digit}{3,}'
char_err1   ['][\x21-\x26\x28-\xff]*[']

bad_id      {digit}({digit}|{letter_})+

%%
"//".*      { }
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]   { } 
"int"|"float"|"char"    { yylval.ast = new Ast("TYPE", yytext); return TYPE; }
"struct"    {  return STRUCT; }
"if"        {  return IF; }
"else"      {  return ELSE; }
"while"     {  return WHILE; }
"return"    {  return RETURN; }
"."         {  return DOT; }
";"         {  return SEMI; }
","         {  return COMMA; }
"="         {  return ASSIGN; }
"<"         {  return LT; }
"<="        {  return LE; }
">"         {  return GT; }
">="        {  return GE; }
"!="        {  return NE; }
"=="        {  return EQ; }
"+"         {  return PLUS; }
"-"         {  return MINUS; }
"*"         {  return MUL; }
"/"         {  return DIV; }
"&&"        {  return AND; }
"||"        {  return OR; }
"!"         {  return NOT; }
"("         {  return LP; }
")"         {  return RP; }
"["         {  return LB; }
"]"         {  return RB; }
"{"         {  return LC; }
"}"         {  return RC; }

{dec_int}   { yylval.ast = new Ast("INT", atoi(yytext)); return INT; }
{hex_int}   { yylval.ast = new Ast("INT", htoi(yytext)); return INT; }
{float}         { yylval.ast = new Ast("FLOAT", 0); return FLOAT; }
{char}|{hex_char}   { yylval.ast = new Ast("CHAR", 0); return CHAR; }
{id}        { yylval.ast = new Ast("ID", yytext); return ID; }


{dec_int_err0}   { LogLSErrorTL(0, yylineno, yytext);  return ILLEGAL_TOKEN; /* 0 leading int */}
{hex_int_err0}   { LogLSErrorTL(0, yylineno, yytext);  return ILLEGAL_TOKEN; /* 0 leading int */}
{hex_int_err1}   { LogLSErrorTL(0, yylineno, yytext);  return ILLEGAL_TOKEN; /* not hex digit */}
{float_err0}    { LogLSErrorTL(0, yylineno, yytext);  return ILLEGAL_TOKEN;}
{char_err0}         { LogLSErrorTL(0, yylineno, yytext);  return ILLEGAL_TOKEN;}
{char_err1}         { LogLSErrorTL(0, yylineno, yytext);  return ILLEGAL_TOKEN;}
{bad_id}    { LogLSErrorTL(0, yylineno, yytext);  return ID; }


{next_line} { }
{empty}     { }

.           { LogLSErrorTL(0, yylineno, yytext); return ILLEGAL_TOKEN; }

%%

int htoi(const char* hex_int) 
{
    int size = (int) strlen(hex_int);
    // if (size > 10)
    // {
    //     LogLSErrorTL(0, lineno, "too large integer");
    // }

    int res = 0;
    int hexdigit;
    for (int i = 2; i < size; ++i)
    {
        if (hex_int[i] >= '0' && hex_int[i] <= '9') {
            hexdigit = hex_int[i] - '0';
            res = 16 * res + hexdigit;
        }
        if (hex_int[i] >= 'A' && hex_int[i] <= 'F') {
            hexdigit = hex_int[i] - 'A' + 10;
            res = 16 * res + hexdigit;
        }
        if (hex_int[i] >= 'a' && hex_int[i] <= 'f') {
            hexdigit = hex_int[i] - 'a' + 10;
            res = 16 * res + hexdigit;
        }
    }

    return res;
}
