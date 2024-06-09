/* exports: */
#include <cif_from_file.h>

/* uses: */
#include <cif_compiler.h>
#include <stdio.h>
#include <string.h>

void parse_cif_from_file_with_error_code(char *filename, cif_option_t co,
                                        error_code_t *ec) {
  cexception_t inner;

  memset(ec, 0, sizeof(*ec));
  ec->error_code = 0;
  ec->message = "OK";
  ec->message = "no system error";

  memset(&inner, 0, sizeof(inner));

  cexception_try(inner) { 
    CIF *cif = new_cif_from_cif_file(strcmp(filename, "-") != 0 ? filename : NULL, co, &inner);

    delete_cif(cif);
  }

  cexception_catch {
    ec->error_code = inner.error_code;
    ec->subsystem_tag = inner.subsystem_tag;
    ec->message = inner.message;
    ec->syserror = inner.syserror;
    ec->source_file = inner.source_file;
    ec->line = inner.line;
  }
}
