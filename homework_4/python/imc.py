# import numpy as np

def main():
    a = 15
    b = 15
    c = 15
    d = 13

    mat = {
        "a": a,
        "b": b,
        "c": c,
        "d": d
    }

    prod_1 = a * d
    prod_2 = b * c
    print(f"prod_1: {prod_1}")
    print(f"prod_2: {prod_2}")

    det = prod_1 - prod_2
    print(f"det: {det}")

    rec = 1 / det
    print(f"rec: {rec}")

    print(f"a: {d * rec}")
    print(f"b: {-b * rec}")
    print(f"c: {-c * rec}")
    print(f"d: {a * rec}")

    mat = [
        [1, 2],
        [2, 1]
    ]
    # mat_inv = np.linalg.inv(mat)
    # print(mat_inv)

if __name__ == "__main__":
    main()