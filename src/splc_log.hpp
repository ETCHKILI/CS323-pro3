//
// Created by gyb on 2021/11/15.
//

#ifndef CS323_2021F_PROJECT2_SPLC_LOG_HPP
#define CS323_2021F_PROJECT2_SPLC_LOG_HPP

#include <string>
#include <cstdio>

extern char log_file_name[80];
static bool ls_error_occur = false;
static bool semantic_error_occur = false;

/// Log lexical and syntax error with type and line no.
void LogLSErrorTL(int type, int line, const char *msg);

/// Log semantic error with type and line no.
void LogSemanticErrorTL(int type, int line, const char *msg);

#endif //CS323_2021F_PROJECT2_SPLC_LOG_HPP
