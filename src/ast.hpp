//
// Created by gyb on 2021/12/13.
//

#ifndef PRO3_AST_HPP
#define PRO3_AST_HPP

#include <string>
#include <vector>
#include <cstdarg>
#include <unordered_map>

#include "ir_code.hpp"

static int tmp_cnt = 0;
static int lab_cnt = 0;

class Ast {
public:


    std::string type;
    std::string name;
    int val = 0;
    std::vector<Ast*> subs;

    explicit Ast(const std::string &type);

    Ast(const std::string &type, const std::string &name);

    Ast(const std::string &type, int val);

    Ast(const std::string &type, const std::string &name, int val);

    static void init();
    static int GetTmp();
    static int GetLab();
    static std::string NumToTemp(int tmp);
    static std::string NumToLab(int lb);
    static std::string DecideExpTemp(IrCodeList &list, Ast *sub_exp);

    void AddSub(int n, ...);
    void AddSubFront(Ast *);
    IrCodeList Parse();
    IrCodeList TransSub();
    IrCodeList TransStmt();
    IrCodeList TransExp(int tmp);
    IrCodeList TransFunDec();
    IrCodeList TransCondExp(int l1, int l2);
    IrCodeList TransArgs();
    IrCodeList TransDec();
};



#endif //PRO3_AST_HPP
