#!/usr/bin/env python3
"""
gen_bram_data.py
----------------
Generates a memory initialization file for Verilog BRAM ($readmemb or $readmemh).

Usage examples:
    python gen_bram_data.py --depth 64 --width 32 --format bin --outfile rams_init_file.data
    python gen_bram_data.py --depth 256 --width 16 --format hex --outfile mem_init.hex
"""

import argparse
import random

def generate_data(depth, width, fmt):
    """Generate random data in the chosen format."""
    data = []
    max_val = (1 << width) - 1
    for _ in range(depth):
        val = random.randint(0, max_val)
        if fmt == "bin":
            data.append(f"{val:0{width}b}")
        elif fmt == "hex":
            # Round width up to a multiple of 4 bits for hex output
            hex_digits = (width + 3) // 4
            data.append(f"{val:0{hex_digits}X}")
    return data

def main():
    parser = argparse.ArgumentParser(description="Generate a Verilog memory init file.")
    parser.add_argument("--depth", type=int, default=64, help="Number of memory words (default: 64)")
    parser.add_argument("--width", type=int, default=32, help="Bits per word (default: 32)")
    parser.add_argument("--format", choices=["bin", "hex"], default="bin", help="Output format (bin or hex)")
    parser.add_argument("--outfile", default="rams_init_file.data", help="Output file name")
    parser.add_argument("--seed", type=int, help="Optional RNG seed for reproducibility")
    args = parser.parse_args()

    if args.seed is not None:
        random.seed(args.seed)

    data = generate_data(args.depth, args.width, args.format)
    with open(args.outfile, "w") as f:
        f.write("\n".join(data))
        f.write("\n")

    print(f"Generated {args.outfile}")
    print(f"Depth: {args.depth}, Width: {args.width} bits, Format: {args.format}")

if __name__ == "__main__":
    main()
