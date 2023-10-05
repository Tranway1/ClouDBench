import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import make_interp_spline

# Sample data points for three systems (replace with your own data)
dollar_cost_A = [10, 17, 27, 40, 50]  # Dollar cost values for System A
dollar_cost_B = [16, 21, 30, 42, 48]  # Dollar cost values for System B
dollar_cost_C = [11, 19, 29, 39, 46]  # Dollar cost values for System C
query_latency_A = [8, 5, 3, 2, 1.5]    # Query latency for System A
query_latency_B = [6, 3.5, 2.5, 2.3, 2.2]    # Query latency for System B
query_latency_C = [7, 3.8, 3, 2.8, 2.6]    # Query latency for System C

# Create a scatter plot for System A
plt.scatter(dollar_cost_A, query_latency_A, color="blue")

# Create a scatter plot for System B
plt.scatter(dollar_cost_B, query_latency_B, color="red")

# Create a scatter plot for System C
plt.scatter(dollar_cost_C, query_latency_C, color="green")

# Interpolate and plot smooth lines for System A
spline_A = make_interp_spline(dollar_cost_A, query_latency_A)
x_A = np.linspace(min(dollar_cost_A), max(dollar_cost_A), 1000)
y_A = spline_A(x_A)
plt.plot(x_A, y_A, label="System A", color="blue")

# Interpolate and plot smooth lines for System B
spline_B = make_interp_spline(dollar_cost_B, query_latency_B)
x_B = np.linspace(min(dollar_cost_B), max(dollar_cost_B), 1000)
y_B = spline_B(x_B)
plt.plot(x_B, y_B, label="System B", color="red")

# Interpolate and plot smooth lines for System C
spline_C = make_interp_spline(dollar_cost_C, query_latency_C)
x_C = np.linspace(min(dollar_cost_C), max(dollar_cost_C), 1000)
y_C = spline_C(x_C)
plt.plot(x_C, y_C, label="System C", color="green")

# Labeling axes and adding a title
plt.xlabel("$ Cost")
plt.ylabel("Query Latency")
plt.title("Query Latency vs. Dollar Cost (Dummy Data)")

# Add legend
plt.legend()

# Show the plot
plt.grid(True)
plt.savefig('cost-latency-cross-eval.pdf')
plt.show()
