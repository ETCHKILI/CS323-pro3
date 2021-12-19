//
// Created by gyb on 2021/11/15.
//

#include "splc_log.hpp"

void LogLSErrorTL(int type, int line, const char *msg) {
    ls_error_occur = true;
    if (type == 0) {
        printf("Error type A at Line %d: %s\n", line, msg);
    }
    if (type == 1) {
        printf("Error type B at Line %d: %s\n", line, msg);
    }
    // FILE *fp = fopen(log_file_name, "a+");
    // if (type == 0) {
    //     fprintf(fp, "Error type A at Line %d: %s\n", line, msg);
    // }
    // if (type == 1) {
    //     fprintf(fp, "Error type B at Line %d: %s\n", line, msg);
    // }
    // fclose(fp);
}

void LogSemanticErrorTL(int type, int line, const char *msg) {
    semantic_error_occur = true;
    FILE *fp = fopen(log_file_name, "a+");
    fprintf(fp, "Error type %d at Line %d: %s\n", type, line, msg);
    fclose(fp);
}