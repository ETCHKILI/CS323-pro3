%{
    #include "lex.cpp"
    void yyerror(const char *s);
    #include "stdio.h"
    #include "stdlib.h"
    #include "string.h"
    #include <unordered_map>
    #include <memory>

    Ast *root = nullptr;
%}

%union 
{
    Ast *ast;
}


%nonassoc <ast> ILLEGAL_TOKEN
%nonassoc <ast> LOWER_ELSE
%nonassoc <ast> ELSE
%token <ast> TYPE STRUCT
%token <ast> IF WHILE RETURN
%token <ast> INT
%token <ast> FLOAT
%token <ast> CHAR
%token <ast> ID
%right <ast> ASSIGN
%left <ast> OR
%left <ast> AND
%left <ast> LT LE GT GE NE EQ

%left <ast> PLUS MINUS
%left <ast> MUL DIV
%right <ast> NOT
%left <ast> LP RP LB RB DOT
%token <ast> SEMI COMMA
%token <ast> LC RC

%type <ast> Program ExtDefList
%type <ast> ExtDef ExtDecList Specifier StructSpecifier VarDec
%type <ast> FunDec VarList ParamDec CompSt StmtList Stmt DefList
%type <ast> Def DecList Dec Args Exp

%%
/* high-level definition */


Program:
    ExtDefList {
    	$$ = new Ast("Program");
    	$$->AddSub(1, $1);
    	root = $$;
    }
    ;

ExtDefList:
    {
    	$$ = new Ast("ExtDefList");
    }
    | ExtDef ExtDefList {
    	$2->AddSubFront($1);
    	$$ = $2;
    } 
    ;
ExtDef:
    Specifier ExtDecList SEMI {
		$$ = new Ast("ExtDef");
		$$->AddSub(3, $1, $2, $3);
    }
    | Specifier SEMI {
        $$ = new Ast("ExtDef");
		$$->AddSub(2, $1, $2);
    }
    | Specifier FunDec CompSt {
		$$ = new Ast("ExtDef");
        $$->AddSub(3, $1, $2, $3);
    }
    ;

/* provide right-side-type and name */
ExtDecList:
    VarDec {
        $$ = new Ast("ExtDecList");
        $$->AddSub(1, $1);
    }
    | VarDec COMMA ExtDecList {
		$3->AddSubFront($1);
		$$ = $3;
    }

    ;


/* specifier */
/* provide type */
Specifier: 
    TYPE {
    	$$ = new Ast("Specifier");
        $$->AddSub(1, $1);
    }
    | StructSpecifier {
    	$$ = new Ast("Specifier");
        $$->AddSub(1, $1);
    }
    ;

/* provide struc */
StructSpecifier: 
    STRUCT ID LC DefList RC {
    	$$ = new Ast("StructSpecifier", $2->name);
		$$->AddSub(1, $4);
    }
    | STRUCT ID {
        $$ = new Ast("StructSpecifier", $2->name);
    }

    ;

/* declarator */
/* provide the text of id */
/* provide the array without base if needed */
VarDec: 
    ID {
    	$$ = new Ast("VarDec", $1->name);
    }
    | VarDec LB INT RB {
    	$$ = $1;
    	$1->AddSub(1, $3);
    }

    ;

/* provide func without return type */
FunDec: 
    ID LP VarList RP {
        $$ = new Ast("FunDec", $1->name);
        $$->AddSub(1, $3);
    }
    | ID LP RP {
        $$ = new Ast("FunDec", $1->name);
    }

    ;
/* provide field (list)*/
VarList: 
    ParamDec COMMA VarList {
    	$$ = $3;
        $$->AddSubFront($1);
    }

    | ParamDec {
        $$ = new Ast("VarList");
        $$->AddSub(1, $1);
    }
    ;
/* provide field and name */
ParamDec: 
    Specifier VarDec {
    	$$ = new Ast("ParamDec", $2->name);
    	$$->AddSub(2, $1, $2);
    }
    ;  

/* statement */
/* provide func if has return stmt */
CompSt: 
    LC DefList StmtList RC {
        $$ = new Ast("CompSt");
        $$->AddSub(2, $2, $3);
    }
    ;
StmtList: 
    { $$ = new Ast("StmtList"); }
    | Stmt StmtList {
    	$$ = $2;
    	$$->AddSubFront($1);
    }
    ;
Stmt: 
    Exp SEMI {
    	$$ = new Ast("Stmt", "ExpSt");
    	$$->AddSub(1, $1);
    }
    | CompSt {
    	$$ = new Ast("Stmt", "CmpSt");
    	$$->AddSub(1, $1);
    }
    | RETURN Exp SEMI {
    	$$ = new Ast("Stmt", "ReturnSt");
    	$$->AddSub(1, $2);
    }
    | IF LP Exp RP Stmt %prec LOWER_ELSE {
    	$$ = new Ast("Stmt", "IfSt");
    	$$->AddSub(2, $3, $5);
    }
    | IF LP Exp RP Stmt ELSE Stmt {
    	$$ = new Ast("Stmt", "IfElseSt");
		$$->AddSub(3, $3, $5, $7);
    }
    | WHILE LP Exp RP Stmt {
    	$$ = new Ast("Stmt", "WhileSt");
    	$$->AddSub(2, $3, $5);
    }

    ;


/// @1
/* local definition */
/* provide field */
DefList: 
    {
    	$$ = new Ast("DefList");
    }
    | Def DefList {
    	$$ = $2;
    	$$->AddSubFront($1);
    }
    ;
/* provide field for struct definition */
Def: 
    Specifier DecList SEMI {
    	$$ = new Ast("Def");
    	$$->AddSub(2, $1, $2);
    }

    ;
DecList: 
    Dec {
    	$$ = new Ast("DecList");
    	$$->AddSub(1, $1);
    }
    | Dec COMMA DecList {
    	$$ = $3;
		$$->AddSubFront($1);
    }

    ;
/* provide type and var name */
Dec:
    VarDec {
    	$$ = new Ast("Dec");
		$$->AddSub(1, $1);
    }
    | VarDec ASSIGN Exp {
    	$$ = new Ast("Dec");
		$$->AddSub(2, $1, $3);
    }
    ;


/* Expression */
/* provide type */
Exp: 
    Exp ASSIGN Exp {
        $$ = new Ast("Exp", "=");
        $$->AddSub(2, $1, $3);
    }
    | Exp AND Exp {
        $$ = new Ast("Exp", "&&");
		$$->AddSub(2, $1, $3);
    }
    | Exp OR Exp {
        $$ = new Ast("Exp", "||");
		$$->AddSub(2, $1, $3);
    }
    | Exp LT Exp {
        $$ = new Ast("Exp", "<");
		$$->AddSub(2, $1, $3);
    }
    | Exp LE Exp {
        $$ = new Ast("Exp", "<=");
		$$->AddSub(2, $1, $3);
    }
    | Exp GT Exp {
        $$ = new Ast("Exp", ">");
		$$->AddSub(2, $1, $3);
    }
    | Exp GE Exp {
        $$ = new Ast("Exp", ">=");
		$$->AddSub(2, $1, $3);
    }
    | Exp NE Exp {
        $$ = new Ast("Exp", "!=");
		$$->AddSub(2, $1, $3);
    }
    | Exp EQ Exp {
        $$ = new Ast("Exp", "==");
		$$->AddSub(2, $1, $3);
    }
    | Exp PLUS Exp {
        $$ = new Ast("Exp", "+");
		$$->AddSub(2, $1, $3);
    }
    | Exp MINUS Exp {
        $$ = new Ast("Exp", "-");
		$$->AddSub(2, $1, $3);
    }
    | Exp MUL Exp {
        $$ = new Ast("Exp", "*");
		$$->AddSub(2, $1, $3);
    }
    | Exp DIV Exp {
        $$ = new Ast("Exp", "/");
		$$->AddSub(2, $1, $3);
    }
    | LP Exp RP {
		$$ = $2;
    }

    | MINUS Exp {
        $$ = new Ast("Exp", "-");
		$$->AddSub(1, $2);
    }
    | NOT Exp {
        $$ = new Ast("Exp", "!");
		$$->AddSub(1, $2);
    }
    | ID LP Args RP {
        $$ = new Ast("Exp", "CALL");
		$$->AddSub(2, $1, $3);
    }

    | ID LP RP {
		$$ = new Ast("Exp", "CALL");
		$$->AddSub(1, $1);
    }

    | Exp LB Exp RB {
    	$$ = new Ast("Exp", "Arr");
    }

    | Exp DOT ID {
        $$ = new Ast("Exp", "StructField");
    }
    | ID {
        $$ = new Ast("Exp", "ID");
        $$->AddSub(1, $1);
    }
    | INT {
    	$$ = new Ast("Exp", "INT", $1->val);
	}
    | FLOAT {
    	$$ = new Ast("Exp", "INT", $1->val);
    }
    | CHAR {
    	$$ = new Ast("Exp", "INT", $1->val);
    }

    ;
Args: 
    Exp COMMA Args {
    	$$ = $3;
    	$$->AddSub(1, $1);
    }
    | Exp {
    	$$ = new Ast("Args");
    	$$->AddSub(1, $1);
    }

	;

%%

void yyerror(const char *s){
}
