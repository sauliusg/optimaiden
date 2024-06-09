#ifndef __CIF_FROM_FILE_H
#define __CIF_FROM_FILE_H

#include <cif.h>
#include <cif_options.h>

typedef struct error_code_s {
    int error_code;
    const void *subsystem_tag;
    const char *message;
    const char *syserror; /* System error message as returned by
                             strerror(errno), or analogous. */
    const char *source_file;
    int line;
} error_code_t;

void parse_cif_from_file_with_error_code( char *filename, cif_option_t co, error_code_t *ec );

#endif
