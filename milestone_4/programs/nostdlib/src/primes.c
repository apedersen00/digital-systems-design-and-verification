//-------------------------------------------------------------------------------------------------
//
//  File: primes.c
//  Description: Computes prime numbers..
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

#define OUT_REG_ADDR 0x00010000
#define MAX_NUM      100
#define DONE_MARKER  0xDEADBEEF

volatile unsigned int *out_reg = (volatile unsigned int*)OUT_REG_ADDR;

static unsigned int i, sum, k, rem;

static void output(unsigned int value) {
    *out_reg = value;
}

// Return 1 if n is prime, 0 otherwise
static unsigned int is_prime(unsigned int n) {
    if (n < 2) return 0;
    if (n == 2) return 1;

    i = 2;

    while (1) {
        sum = 0;
        k = 0;
        while (k < i) {
            sum += i;
            k++;
        }

        if (sum > n)
            break;

        rem = n;
        while (rem >= i)
            rem -= i;
        if (rem == 0)
            return 0;

        i++;
    }
    return 1;
}

int main(void) {
    unsigned int n;

    output(0x12345678);

    for (n = 2; n <= MAX_NUM; n++) {
        if (is_prime(n)) {
            output(n);
        }
    }

    output(DONE_MARKER);

    while (1)
        asm volatile ("nop");

    return 0;
}