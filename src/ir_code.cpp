//
// Created by gyb on 2021/12/13.
//

#include "ir_code.hpp"

IrCodeList IrCodeList::operator+(const IrCodeList &ots) const {
    IrCodeList res;
    if (this->head == nullptr) {
        res = ots;
    } else if (ots.head == nullptr) {
        res = *this;
    } else {
        this->tail->next = ots.head;
        ots.head->prev = this->tail;
        res.head = this->head;
        res.tail = ots.tail;
    }
    return res;
}

IrCodeList::IrCodeList(IrCode *single) {
    this->head = single;
    this->tail = single;
}

void IrCodeList::operator+=(const IrCodeList &ots) {
    if (this->head == nullptr) {
        this->head = ots.head;
        this->tail = ots.tail;
    } else if (ots.head == nullptr) {

    } else {
        this->tail->next = ots.head;
        ots.head->prev = this->tail;
        this->tail = ots.tail;
    }
}

void IrCodeList::operator+=(IrCode *ots) {
    if (this->head == nullptr) {
        this->head = ots;
        this->tail = ots;
    } else {
        this->tail->next = ots;
        ots->prev = this->tail;
        this->tail = ots;
    }
}

IrCode::IrCode(const std::string &code) : code(code) {}

IrCode::IrCode(const std::string &code, IrCode *prev, IrCode *next) : code(code), prev(prev), next(next) {}
