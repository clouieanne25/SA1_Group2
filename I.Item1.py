
# Section I - Item 1
# Probability of Selecting a Defective Product

# Input production proportions
print("FACTORY PRODUCTION PROPORTIONS")

x1 = float(input("Enter x1 (Factory 1): "))
x2 = float(input("Enter x2 (Factory 2): "))
x3 = float(input("Enter x3 (Factory 3): "))

# Input defective rates
print("\nFACTORY DEFECTIVE RATES")

y1 = float(input("Enter y1 (Factory 1): "))
y2 = float(input("Enter y2 (Factory 2): "))
y3 = float(input("Enter y3 (Factory 3): "))

# Store inputs in lists
x = [x1, x2, x3]
y = [y1, y2, y3]

# Validate production proportions
if any(value < 0.10 or value > 0.40 for value in x):
    raise ValueError(
        "Each production proportion must be between 0.10 and 0.40."
    )

# Validate defective rates
if any(value < 0.01 or value > 0.05 for value in y):
    raise ValueError(
        "Each defective rate must be between 0.01 and 0.05."
    )

# Validate the sum of production proportions
if abs(sum(x) - 1.00) > 1e-8:
    raise ValueError(
        "The sum of x1, x2, and x3 must equal 1."
    )

# Validate the sum of defective rates
if abs(sum(y) - 0.12) > 1e-8:
    raise ValueError(
        "The sum of y1, y2, and y3 must equal 0.12."
    )

# Calculate the probability of selecting a defective product
contribution1 = x1 * y1
contribution2 = x2 * y2
contribution3 = x3 * y3

probability = contribution1 + contribution2 + contribution3

# Display results
print("\nRESULTS")
print(f"Factory 1 contribution: {contribution1:.6f}")
print(f"Factory 2 contribution: {contribution2:.6f}")
print(f"Factory 3 contribution: {contribution3:.6f}")

print(
    f"Probability of selecting a defective product: "
    f"{probability:.6f}"
)

print(f"Percentage of defective products: {probability * 100:.4f}%")
