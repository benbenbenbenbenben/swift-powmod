#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void mod_multiply(uint8_t *a, size_t a_len,
                 uint8_t *b, size_t b_len,
                 uint8_t *mod, size_t mod_len,
                 uint8_t *result, size_t result_len) {
    // Clear result buffer first
    memset(result, 0, result_len);
    
    // Check that output buffer is large enough
    if (result_len < a_len + b_len) {
        return;  // Error condition
    }
    
    // Perform multiplication with bounds checking
    for (size_t i = 0; i < a_len && i < result_len; i++) {
        uint16_t carry = 0;
        for (size_t j = 0; j < b_len && (i + j) < result_len; j++) {
            uint32_t current = result[i + j] + ((uint32_t)a[i] * b[j]) + carry;
            result[i + j] = current & 0xFF;
            carry = current >> 8;
        }
        if (i + b_len < result_len && carry) {
            result[i + b_len] = carry;
        }
    }
    
    // Modulo operation with bounds checking
    for (size_t i = result_len; i > 0; i--) {
        if (i - 1 < mod_len) break;
        
        uint16_t factor = result[i - 1];
        if (factor == 0) continue;
        
        int16_t borrow = 0;
        for (size_t j = 0; j < mod_len && (i - mod_len + j) < result_len; j++) {
            int32_t subtrahend = (int32_t)factor * mod[j] + borrow;
            int32_t minuend = result[i - mod_len + j];
            
            if (minuend < (subtrahend & 0xFF)) {
                result[i - mod_len + j] = (uint8_t)(minuend + 256 - (subtrahend & 0xFF));
                borrow = (subtrahend >> 8) + 1;
            } else {
                result[i - mod_len + j] = (uint8_t)(minuend - (subtrahend & 0xFF));
                borrow = subtrahend >> 8;
            }
        }
    }
}

void mod_exp(const uint8_t *base, size_t base_len,
             const uint8_t *exp, size_t exp_len,
             const uint8_t *mod, size_t mod_len,
             uint8_t *output, size_t output_len) {
    // Validate input parameters
    if (!base || !exp || !mod || !output || 
        base_len == 0 || exp_len == 0 || mod_len == 0 || output_len == 0) {
        return;
    }
    
    // Initialize result to 1
    memset(output, 0, output_len);
    output[0] = 1;
    
    // Allocate temporary buffers with size checks
    uint8_t *temp = (uint8_t *)calloc(output_len * 2, sizeof(uint8_t));  // Double size for safety
    if (!temp) return;
    
    uint8_t *square = (uint8_t *)calloc(output_len * 2, sizeof(uint8_t)); // Double size for safety
    if (!square) {
        free(temp);
        return;
    }
    
    // Copy base to square buffer
    memcpy(square, base, base_len < output_len ? base_len : output_len);
    
    // Process each bit of the exponent
    for (size_t i = 0; i < exp_len; i++) {
        uint8_t byte = exp[i];
        for (int bit = 7; bit >= 0; bit--) {
            // Square
            mod_multiply(output, output_len, output, output_len, 
                        (uint8_t *)mod, mod_len, temp, output_len * 2);
            memcpy(output, temp, output_len);
            
            // Multiply if current bit is 1
            if (byte & (1 << bit)) {
                mod_multiply(output, output_len, square, output_len,
                           (uint8_t *)mod, mod_len, temp, output_len * 2);
                memcpy(output, temp, output_len);
            }
        }
    }
    
    free(temp);
    free(square);
}