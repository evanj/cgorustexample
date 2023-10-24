#include <assert.h>
#include <stdint.h>
#include <stdio.h>

extern int32_t copy_rust_message(char *buffer, size_t buffer_len);

int main()
{
    static const size_t BUF_LEN = 1024;
    char buffer[BUF_LEN];

    printf("crustexe: Demonstrating calling Rust from C\n");
    int32_t result = copy_rust_message(buffer, BUF_LEN);
    printf("copy_rust_message(...) result=%d\n", result);
    assert(result > 0);
    printf("  buffer=%s\n", buffer);

    printf("\nCalling with buffer too short:\n");
    static const size_t TOO_SHORT = 10;
    result = copy_rust_message(buffer, TOO_SHORT);
    printf("  copy_rust_message(..., %zu)=%d\n", TOO_SHORT, result);
}
