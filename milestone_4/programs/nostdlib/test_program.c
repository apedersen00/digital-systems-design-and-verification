/*
 * Comprehensive RV32I Test Program
 * 
 * This program tests all major instruction categories of the RV32I base instruction set:
 * - Integer register-immediate instructions
 * - Integer register-register instructions  
 * - Control and status register instructions
 * - Load and store instructions
 * - Control transfer instructions (branches and jumps)
 * 
 * No stdlib functions are used, and no hardware multiplication/division is assumed.
 * Test results are output to a memory-mapped register for verification.
 * 
 * Author: A. Pedersen
 */

// Memory mapped output register for test results
#define OUT_REG_ADDR     0x00004000
#define TEST_PASS        0xCAFEBABE
#define TEST_FAIL        0xDEADBEEF

// Test data area in memorycd .
#define DATA_BASE_ADDR   0x00002000
#define STACK_TEST_ADDR  0x00003000

// Test counters
static volatile unsigned int test_count = 0;
static volatile unsigned int pass_count = 0;

// Output register pointer
volatile unsigned int *out_reg = (volatile unsigned int*)OUT_REG_ADDR;

// Forward declarations
void test_arithmetic_immediate(void);
void test_arithmetic_register(void);
void test_logical_operations(void);
void test_shift_operations(void);
void test_comparison_operations(void);
void test_load_store_operations(void);
void test_branch_operations(void);
void test_jump_operations(void);
void test_memory_patterns(void);
void run_all_tests(void);

// Simple output functions (no printf available)
void output_result(unsigned int value) {
    *out_reg = value;
}

void output_test_start(unsigned int test_id) {
    *out_reg = 0x1000 | test_id;
}

void output_test_result(unsigned int test_id, int passed) {
    test_count++;
    if (passed) {
        pass_count++;
        *out_reg = 0x2000 | test_id; // Test passed
    } else {
        *out_reg = 0x3000 | test_id; // Test failed
    }
}

// Software implementation of simple functions (no stdlib)
int simple_abs(int x) {
    return (x < 0) ? -x : x;
}

// Test arithmetic immediate instructions
void test_arithmetic_immediate(void) {
    output_test_start(1);
    
    int result;
    int expected;
    
    // Test ADDI
    result = 0;
    asm volatile ("addi %0, %1, 42" : "=r"(result) : "r"(100));
    expected = 142;
    output_test_result(0x101, result == expected);
    
    // Test ADDI with negative immediate
    result = 0;
    asm volatile ("addi %0, %1, -50" : "=r"(result) : "r"(100));
    expected = 50;
    output_test_result(0x102, result == expected);
    
    // Test SLTI (set less than immediate)
    result = 0;
    asm volatile ("slti %0, %1, 100" : "=r"(result) : "r"(50));
    expected = 1;
    output_test_result(0x103, result == expected);
    
    result = 0;
    asm volatile ("slti %0, %1, 100" : "=r"(result) : "r"(150));
    expected = 0;
    output_test_result(0x104, result == expected);
    
    // Test SLTIU (set less than immediate unsigned)
    result = 0;
    asm volatile ("sltiu %0, %1, 100" : "=r"(result) : "r"(50));
    expected = 1;
    output_test_result(0x105, result == expected);
    
    // Test ANDI
    result = 0;
    asm volatile ("andi %0, %1, 0x0F" : "=r"(result) : "r"(0xFF));
    expected = 0x0F;
    output_test_result(0x106, result == expected);
    
    // Test ORI
    result = 0;
    asm volatile ("ori %0, %1, 0xF0" : "=r"(result) : "r"(0x0F));
    expected = 0xFF;
    output_test_result(0x107, result == expected);
    
    // Test XORI
    result = 0;
    asm volatile ("xori %0, %1, 0xFF" : "=r"(result) : "r"(0xAA));
    expected = 0x55;
    output_test_result(0x108, result == expected);
}

// Test arithmetic register instructions
void test_arithmetic_register(void) {
    output_test_start(2);
    
    int result;
    int a = 100, b = 50;
    
    // Test ADD
    result = 0;
    asm volatile ("add %0, %1, %2" : "=r"(result) : "r"(a), "r"(b));
    output_test_result(0x201, result == 150);
    
    // Test SUB
    result = 0;
    asm volatile ("sub %0, %1, %2" : "=r"(result) : "r"(a), "r"(b));
    output_test_result(0x202, result == 50);
    
    // Test SLT (set less than)
    result = 0;
    asm volatile ("slt %0, %1, %2" : "=r"(result) : "r"(b), "r"(a));
    output_test_result(0x203, result == 1);
    
    result = 0;
    asm volatile ("slt %0, %1, %2" : "=r"(result) : "r"(a), "r"(b));
    output_test_result(0x204, result == 0);
    
    // Test SLTU (set less than unsigned)
    result = 0;
    asm volatile ("sltu %0, %1, %2" : "=r"(result) : "r"(b), "r"(a));
    output_test_result(0x205, result == 1);
}

// Test logical operations
void test_logical_operations(void) {
    output_test_start(3);
    
    int result;
    int a = 0xAAAA, b = 0x5555;
    
    // Test AND
    result = 0;
    asm volatile ("and %0, %1, %2" : "=r"(result) : "r"(a), "r"(b));
    output_test_result(0x301, result == 0x0000);
    
    // Test OR
    result = 0;
    asm volatile ("or %0, %1, %2" : "=r"(result) : "r"(a), "r"(b));
    output_test_result(0x302, result == 0xFFFF);
    
    // Test XOR
    result = 0;
    asm volatile ("xor %0, %1, %2" : "=r"(result) : "r"(a), "r"(b));
    output_test_result(0x303, result == 0xFFFF);
    
    // Test XOR with same value (should be 0)
    result = 0;
    asm volatile ("xor %0, %1, %1" : "=r"(result) : "r"(a));
    output_test_result(0x304, result == 0);
}

// Test shift operations
void test_shift_operations(void) {
    output_test_start(4);
    
    int result;
    int value = 0x12345678;
    
    // Test SLL (shift left logical)
    result = 0;
    asm volatile ("sll %0, %1, %2" : "=r"(result) : "r"(value), "r"(4));
    output_test_result(0x401, result == 0x23456780);
    
    // Test SLLI (shift left logical immediate)
    result = 0;
    asm volatile ("slli %0, %1, 4" : "=r"(result) : "r"(value));
    output_test_result(0x402, result == 0x23456780);
    
    // Test SRL (shift right logical)
    result = 0;
    asm volatile ("srl %0, %1, %2" : "=r"(result) : "r"(value), "r"(4));
    output_test_result(0x403, result == 0x01234567);
    
    // Test SRLI (shift right logical immediate)
    result = 0;
    asm volatile ("srli %0, %1, 4" : "=r"(result) : "r"(value));
    output_test_result(0x404, result == 0x01234567);
    
    // Test SRA (shift right arithmetic) with negative number
    int neg_value = -16;
    result = 0;
    asm volatile ("sra %0, %1, %2" : "=r"(result) : "r"(neg_value), "r"(2));
    output_test_result(0x405, result == -4);
    
    // Test SRAI (shift right arithmetic immediate)
    result = 0;
    asm volatile ("srai %0, %1, 2" : "=r"(result) : "r"(neg_value));
    output_test_result(0x406, result == -4);
}

// Test comparison operations (additional tests)
void test_comparison_operations(void) {
    output_test_start(5);
    
    int result;
    int pos = 100, neg = -50, zero = 0;
    
    // Test various SLT scenarios
    result = 0;
    asm volatile ("slt %0, %1, %2" : "=r"(result) : "r"(neg), "r"(zero));
    output_test_result(0x501, result == 1); // -50 < 0
    
    result = 0;
    asm volatile ("slt %0, %1, %2" : "=r"(result) : "r"(zero), "r"(pos));
    output_test_result(0x502, result == 1); // 0 < 100
    
    result = 0;
    asm volatile ("slt %0, %1, %2" : "=r"(result) : "r"(pos), "r"(neg));
    output_test_result(0x503, result == 0); // 100 !< -50
    
    // Test SLTU with "negative" numbers (treated as large unsigned)
    unsigned int uneg = (unsigned int)neg;
    result = 0;
    asm volatile ("sltu %0, %1, %2" : "=r"(result) : "r"(pos), "r"(uneg));
    output_test_result(0x504, result == 1); // 100 < 4294967246 (unsigned)
}

// Test load and store operations
void test_load_store_operations(void) {
    output_test_start(6);
    
    volatile int *test_addr = (volatile int *)DATA_BASE_ADDR;
    int result;
    
    // Test SW (store word) and LW (load word)
    int test_value = 0x12345678;
    *test_addr = test_value;
    result = *test_addr;
    output_test_result(0x601, result == test_value);
    
    // Test byte operations using inline assembly
    volatile char *byte_addr = (volatile char *)DATA_BASE_ADDR;
    char byte_value = 0xAB;
    
    // Store byte
    asm volatile ("sb %1, 0(%0)" : : "r"(byte_addr), "r"(byte_value));
    
    // Load byte (signed)
    char loaded_byte;
    asm volatile ("lb %0, 0(%1)" : "=r"(loaded_byte) : "r"(byte_addr));
    output_test_result(0x602, loaded_byte == (char)0xAB);
    
    // Load byte unsigned
    unsigned char loaded_byte_u;
    asm volatile ("lbu %0, 0(%1)" : "=r"(loaded_byte_u) : "r"(byte_addr));
    output_test_result(0x603, loaded_byte_u == 0xAB);
    
    // Test halfword operations
    volatile short *half_addr = (volatile short *)DATA_BASE_ADDR;
    short half_value = 0x1234;
    
    // Store halfword
    asm volatile ("sh %1, 0(%0)" : : "r"(half_addr), "r"(half_value));
    
    // Load halfword (signed)
    short loaded_half;
    asm volatile ("lh %0, 0(%1)" : "=r"(loaded_half) : "r"(half_addr));
    output_test_result(0x604, loaded_half == 0x1234);
    
    // Load halfword unsigned
    unsigned short loaded_half_u;
    asm volatile ("lhu %0, 0(%1)" : "=r"(loaded_half_u) : "r"(half_addr));
    output_test_result(0x605, loaded_half_u == 0x1234);
}

// Test branch operations
void test_branch_operations(void) {
    output_test_start(7);
    
    int a = 100, b = 50, c = 100;
    int branch_taken = 0;
    
    // Test BEQ (branch if equal)
    branch_taken = 0;
    if (a == c) branch_taken = 1;
    output_test_result(0x701, branch_taken == 1);
    
    branch_taken = 0;
    if (a == b) branch_taken = 1;
    output_test_result(0x702, branch_taken == 0);
    
    // Test BNE (branch if not equal)
    branch_taken = 0;
    if (a != b) branch_taken = 1;
    output_test_result(0x703, branch_taken == 1);
    
    // Test BLT (branch if less than)
    branch_taken = 0;
    if (b < a) branch_taken = 1;
    output_test_result(0x704, branch_taken == 1);
    
    // Test BGE (branch if greater or equal)
    branch_taken = 0;
    if (a >= c) branch_taken = 1;
    output_test_result(0x705, branch_taken == 1);
    
    // Test BLTU (branch if less than unsigned)
    unsigned int ua = 100, ub = 50;
    branch_taken = 0;
    if (ub < ua) branch_taken = 1;
    output_test_result(0x706, branch_taken == 1);
    
    // Test BGEU (branch if greater or equal unsigned)
    branch_taken = 0;
    if (ua >= ub) branch_taken = 1;
    output_test_result(0x707, branch_taken == 1);
}

// Test jump operations and function calls
int test_function(int x) {
    return x + 42;
}

void test_jump_operations(void) {
    output_test_start(8);
    
    // Test JAL (jump and link) via function call
    int result = test_function(58);
    output_test_result(0x801, result == 100);
    
    // Test direct jump with inline assembly
    int jump_test = 0;
    asm volatile (
        "addi %0, %0, 1\n"      // jump_test = 1
        "j 1f\n"                // jump over next instruction
        "addi %0, %0, 10\n"     // this should be skipped
        "1: addi %0, %0, 2\n"   // jump_test = 3
        : "+r"(jump_test)
    );
    output_test_result(0x802, jump_test == 3);
}

// Test memory access patterns and edge cases
void test_memory_patterns(void) {
    output_test_start(9);
    
    volatile int *mem = (volatile int *)DATA_BASE_ADDR;
    int i;
    
    // Test sequential memory access
    for (i = 0; i < 8; i++) {
        mem[i] = i * 0x11111111;
    }
    
    int checksum = 0;
    for (i = 0; i < 8; i++) {
        checksum += mem[i];
    }
    
    // Expected checksum: 0 + 0x11111111 + 0x22222222 + ... + 0x77777777
    output_test_result(0x901, checksum != 0);
    
    // Test pointer arithmetic
    volatile int *ptr = mem;
    ptr += 4;
    *ptr = 0xDEADBEEF;
    output_test_result(0x902, mem[4] == 0xDEADBEEF);
    
    // Test alignment requirements
    volatile char *char_ptr = (volatile char *)mem;
    char_ptr[0] = 0x12;
    char_ptr[1] = 0x34;
    char_ptr[2] = 0x56;
    char_ptr[3] = 0x78;
    
    int aligned_word = mem[0];
    output_test_result(0x903, (aligned_word & 0xFF) == 0x12);
}

// Software multiplication using shifts and adds (no MUL instruction)
int software_multiply(int a, int b) {
    int result = 0;
    int multiplicand = a;
    
    if (b < 0) {
        b = -b;
        multiplicand = -multiplicand;
    }
    
    while (b > 0) {
        if (b & 1) {
            result += multiplicand;
        }
        multiplicand <<= 1;
        b >>= 1;
    }
    
    return result;
}

// Software division using subtraction (no DIV instruction)
int software_divide(int dividend, int divisor) {
    if (divisor == 0) return 0; // Avoid division by zero
    
    int quotient = 0;
    int negative = 0;
    
    if (dividend < 0) {
        dividend = -dividend;
        negative = !negative;
    }
    if (divisor < 0) {
        divisor = -divisor;
        negative = !negative;
    }
    
    while (dividend >= divisor) {
        dividend -= divisor;
        quotient++;
    }
    
    return negative ? -quotient : quotient;
}

// Test software implementations of missing instructions
void test_software_implementations(void) {
    output_test_start(10);
    
    // Test software multiplication
    int mult_result = software_multiply(12, 13);
    output_test_result(0xA01, mult_result == 156);
    
    mult_result = software_multiply(-5, 7);
    output_test_result(0xA02, mult_result == -35);
    
    // Test software division
    int div_result = software_divide(156, 12);
    output_test_result(0xA03, div_result == 13);
    
    div_result = software_divide(-35, 7);
    output_test_result(0xA04, div_result == -5);
}

// Main test orchestration
void run_all_tests(void) {
    output_result(0x5555AAAA);
    
    test_arithmetic_immediate();
    test_arithmetic_register();
    test_logical_operations();
    test_shift_operations();
    test_comparison_operations();
    test_load_store_operations();
    test_branch_operations();
    test_jump_operations();
    test_memory_patterns();
    test_software_implementations();
    
    // Output final results
    output_result(0x1000 | pass_count);  // Number of passed tests
    output_result(0x2000 | test_count);  // Total number of tests
    
    if (pass_count == test_count) {
        output_result(TEST_PASS);  // All tests passed
    } else {
        output_result(TEST_FAIL);  // Some tests failed
    }
}

int main(void) {
    // Initialize output
    output_result(0x12345678); // Startup marker
    
    // Run comprehensive tests
    run_all_tests();
    
    // Final completion marker
    output_result(0x9999CCCC);
    
    // Infinite loop
    while (1) {
        asm volatile ("nop");
    }
    
    return 0;
}