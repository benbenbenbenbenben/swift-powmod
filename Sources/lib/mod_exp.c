#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

// Helper function to perform modular multiplication of two numbers
void mod_multiply(uint8_t *a, size_t a_len,
                 uint8_t *b, size_t b_len,
                 uint8_t *mod, size_t mod_len,
                 uint8_t *result, size_t result_len) {
    uint16_t carry = 0;
    memset(result, 0, result_len);
    
    for (size_t i = 0; i < a_len; i++) {
        carry = 0;
        for (size_t j = 0; j < b_len; j++) {
            if (i + j < result_len) {
                uint16_t prod = result[i + j] + (uint16_t)a[i] * b[j] + carry;
                result[i + j] = prod & 0xFF;
                carry = prod >> 8;
            }
        }
        if (i + b_len < result_len && carry) {
            result[i + b_len] = carry;
        }
    }
    
    // Perform modulo operation
    for (size_t i = result_len - 1; i >= mod_len; i--) {
        while (result[i] > 0) {
            uint16_t factor = result[i];
            uint16_t borrow = 0;
            
            for (size_t j = 0; j < mod_len; j++) {
                uint16_t subtrahend = factor * mod[j] + borrow;
                if (result[i - mod_len + j] < (subtrahend & 0xFF)) {
                    result[i - mod_len + j] += 256 - (subtrahend & 0xFF);
                    borrow = (subtrahend >> 8) + 1;
                } else {
                    result[i - mod_len + j] -= (subtrahend & 0xFF);
                    borrow = subtrahend >> 8;
                }
            }
            result[i] = borrow;
        }
    }
}

// Main modular exponentiation function using square-and-multiply algorithm
void mod_exp(const uint8_t *base, size_t base_len,
             const uint8_t *exp, size_t exp_len,
             const uint8_t *mod, size_t mod_len,
             uint8_t *output, size_t output_len) {
    
    // Initialize result to 1
    memset(output, 0, output_len);
    output[0] = 1;
    
    uint8_t *temp = (uint8_t *)calloc(output_len, sizeof(uint8_t));
    uint8_t *square = (uint8_t *)calloc(output_len, sizeof(uint8_t));
    memcpy(square, base, base_len);
    
    // Process each bit of the exponent
    for (size_t i = 0; i < exp_len; i++) {
        uint8_t byte = exp[i];
        for (int bit = 7; bit >= 0; bit--) {
            // Square
            mod_multiply(output, output_len, output, output_len, 
                        (uint8_t *)mod, mod_len, temp, output_len);
            memcpy(output, temp, output_len);
            
            // Multiply if current bit is 1
            if (byte & (1 << bit)) {
                mod_multiply(output, output_len, square, output_len,
                           (uint8_t *)mod, mod_len, temp, output_len);
                memcpy(output, temp, output_len);
            }
        }
    }
    
    free(temp);
    free(square);
}