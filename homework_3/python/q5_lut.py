import math

def quant_15(val):
    return int(round(val * (1 << 15))) & 0xFFFF

val = [1.0]
for i in range(7):
    denom = (2*(i) + 2) * (2*(i) + 3)
    val.append(1 / denom)

for v in val:
    q15 = quant_15(v)
    print(f"{v:.10f} -> 0x{q15:04X}")
