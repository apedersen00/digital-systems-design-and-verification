/*
 * Simple C test program for RV32I processor
 * This program performs basic arithmetic operations to test the processor
 */

#define n 30
#define OUT_REG_ADDR 0x00004000

int main(void) {
    volatile unsigned int *out_reg = (volatile unsigned int*)OUT_REG_ADDR;

    int a = 0;
    int b = 1;
    int c;
    int i;

    for (i = 1; i <= n; i++) {
        c = a + b;
        a = b;
        b = c;
        *out_reg = b; 
    }

    while (1) {
        asm volatile ("nop");
    }
}