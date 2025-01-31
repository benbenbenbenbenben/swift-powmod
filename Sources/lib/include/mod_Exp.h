#ifndef modexp_h
#define modexp_h

#include <stdint.h>
#include <stdlib.h>

void mod_exp(const uint8_t *base, size_t base_len,
             const uint8_t *exp, size_t exp_len,
             const uint8_t *mod, size_t mod_len,
             uint8_t *output, size_t output_len);

#endif
