import numpy as np

np.random.seed(42)

# Small example: W is 3x2, x is 2x1, b is 3x1
W = np.round(np.random.uniform(-1.5, 1.5, (3, 2)), 2)
x = np.round(np.random.uniform(-1.0, 1.0, (2,)), 2)
b = np.round(np.random.uniform(-0.5, 0.5, (3,)), 2)

z = np.round(W @ x + b, 2)
y = np.round(np.maximum(0, z), 2)

print("W =")
print(W)
print()
print("x =", x)
print("b =", b)
print()
print("z = W @ x + b =", z)
print("y = ReLU(z)   =", y)
print()


# Format for Typst mat()
def fmt(v):
    return "; ".join(str(val) for val in v)


def fmt_mat(M):
    return "; ".join(", ".join(str(val) for val in row) for row in M)


print("=== Typst snippets ===")
print()
print(f"mat({fmt_mat(W)}) dot mat({fmt(x)}) + mat({fmt(b)}) &= mat({fmt(z)})")
print()
print(f'"ReLU"(mat({fmt(z)})) &= mat({fmt(y)})')
