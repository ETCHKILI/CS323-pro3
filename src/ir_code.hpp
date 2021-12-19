//
// Created by gyb on 2021/12/13.
//

#ifndef PRO3_IR_CODE_HPP
#define PRO3_IR_CODE_HPP

#include <string>

class IrCode {
public:
    std::string code;
    IrCode *prev = nullptr;
    IrCode *next = nullptr;

    IrCode()=default;
    explicit IrCode(const std::string &code);
    IrCode(const std::string &code, IrCode *prev, IrCode *next);
};

class IrCodeList {
public:
    IrCode *head = nullptr;
    IrCode *tail = nullptr;

    IrCodeList()=default;
    explicit IrCodeList(IrCode *single);

    void operator +=(const IrCodeList &ots);
    void operator +=(IrCode *ots);
    IrCodeList operator +(const IrCodeList &ots) const;
};

#endif //PRO3_IR_CODE_HPP
