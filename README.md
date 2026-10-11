# Probability and Statistical Analysis

## Overview

This project contains five programming and statistical analysis activities involving probability, discrete random variables, simulation, and cryptocurrency returns. Python and R are used to perform calculations, analyze data, and present results.

## Item I.1 – Probability of a Defective Product

### Objective

Calculate the probability of selecting a defective product using the proportions of different product types and their corresponding defect probabilities.

### Methodology

The law of total probability is used to calculate the overall probability of a defective product:

\[
P(D)=P(A)P(D\mid A)+P(B)P(D\mid B)+P(C)P(D\mid C)
\]

where \(P(A)\), \(P(B)\), and \(P(C)\) represent the proportions of the three product types, while the conditional probabilities represent their respective defect rates.

The program accepts the product proportions and defect probabilities as inputs and checks whether the values are valid.

### Results

Using the sample inputs:

- Product proportions: 0.40, 0.30, and 0.30
- Defect probabilities: 0.04, 0.03, and 0.05

The calculated probability is:

\[
P(D)=0.40(0.04)+0.30(0.03)+0.30(0.05)
\]

\[
P(D)=0.040=4\%
\]

### Interpretation

The probability of selecting a defective product is 4% based on the sample inputs. This means that, under the given probabilities, the expected proportion of defective products is 4%.

### Program File

`I.Item1.py`

---

## Item I.2 – Discrete Random Variables

### Objective

Develop an R program that calculates probability distributions and statistical measures for univariate and bivariate discrete random variables.

### Methodology

The program accepts values and their corresponding probabilities. It checks whether the probabilities are valid and whether their total is equal to 1.

For a univariate discrete random variable, the program calculates the probability mass function (PMF), cumulative distribution function (CDF), expected value, variance, and standard deviation.

For bivariate discrete random variables, the program works with a joint probability distribution and calculates marginal and conditional probabilities.

### Results

For the sample univariate distribution:

| Value of X | Probability |
|---:|---:|
| 1 | 0.20 |
| 2 | 0.50 |
| 3 | 0.30 |

The calculated expected value is:

\[
E(X)=2.10
\]

The variance is:

\[
\operatorname{Var}(X)=0.49
\]

The standard deviation is:

\[
\sigma_X=0.70
\]

For the sample bivariate distribution, the joint probabilities are 0.10, 0.20, 0.30, and 0.40. The marginal distributions are:

- \(P(X=0)=0.30\)
- \(P(X=1)=0.70\)
- \(P(Y=0)=0.40\)
- \(P(Y=1)=0.60\)

### Interpretation

The expected value represents the long-run average of the random variable. Variance and standard deviation measure how spread out its values are. The joint, marginal, and conditional distributions describe the probabilities associated with two discrete random variables.

### Program File

`I.Item2.R`

---

## Item I.3 – Simulation of 10,000 Searches

### Objective

Use computer simulation to perform 10,000 trials of the search-related probability problem specified in the assessment.

### Methodology

The program simulates the required search process repeatedly for 10,000 trials. The simulated outcomes are recorded and analyzed to estimate the probability of the event specified in the problem.

The estimated probability is obtained by dividing the number of successful outcomes by the total number of trials:

\[
\hat{P}(A)=\frac{\text{Number of successful outcomes}}{10,000}
\]

### Results

The final estimated probability and the number of successful outcomes should be reported using the actual output of the program.

**Actual simulation results:** To be added after running the final program.

### Interpretation

Simulation provides an estimate of a theoretical probability. Increasing the number of trials can help the estimated probability approach the theoretical value, although the simulated result may still vary.

### Program File

`I.Item3.py`

---

## Item II.1 – Distribution Fitting of Bitcoin Returns

### Objective

Analyze Bitcoin trading data and compare the fit of Normal, Logistic, and Cauchy distributions to Bitcoin returns.

### Data

The dataset contains Bitcoin trading records with the following columns: datetime, open, high, low, close, and volume.

The available dataset contains 7,727,039 rows. After checking the data and calculating returns, 7,716,308 valid one-minute returns were obtained.

### Methodology

The one-minute logarithmic return is calculated using consecutive closing prices:

\[
r_t=\ln\left(\frac{P_t}{P_{t-1}}\right)
\]

where \(P_t\) is the current closing price and \(P_{t-1}\) is the previous closing price.

A random sample of 100,000 returns was selected using a fixed random seed of 123. The sample was standardized before fitting the Normal, Logistic, and Cauchy distributions.

The Akaike Information Criterion (AIC) and Bayesian Information Criterion (BIC) were used to compare the fitted distributions. Lower AIC and BIC values indicate a better fit relative to the other distributions tested.

### Results

The calculated mean and standard deviation of the valid returns were:

- Mean: 0.000001282684
- Standard deviation: 0.001742602

The distribution comparison produced the following results:

| Distribution | AIC | BIC |
|---|---:|---:|
| Normal | 283790.7 | 283809.7 |
| Logistic | 188347.0 | 188366.0 |
| Cauchy | 111089.8 | 111108.9 |

The Cauchy distribution had the lowest AIC and BIC among the three distributions tested.

### Interpretation

Based on the selected sample and the AIC and BIC results, the Cauchy distribution provided the best fit among the Normal, Logistic, and Cauchy distributions tested. This comparison does not establish that the Cauchy distribution is the best possible model among all distributions.

### Output Files

- `II.Item1 Bitcoin Analysis.R` – analysis script
- `bitcoin_distribution_comparison.csv` – distribution comparison results
- `bitcoin_distribution_plot.png` – distribution comparison graph
- `bitcoin_return_histogram.png` – histogram of Bitcoin returns

---

## Item II.2 – Shapiro-Wilk Normality Test for Ethereum Returns

### Objective

Test whether Ethereum trading returns collected at five-minute intervals follow a normal distribution, covering the requested period from August 7, 2015, to September 15, 2026.

### Data

The currently processed Ethereum file contains five-minute trading records for September 2026, with 8,640 rows. This file covers only part of the requested period and is not yet a complete dataset for August 7, 2015, through September 15, 2026.

### Methodology

Logarithmic returns are calculated from consecutive closing prices:

\[
r_t=\ln\left(\frac{P_t}{P_{t-1}}\right)
\]

The Shapiro-Wilk normality test is then applied to a sample of returns. In R, the test accepts between 3 and 5,000 observations, so a sample of 5,000 returns is used when the available data contains enough valid observations.

The hypotheses are:

- **Null hypothesis (\(H_0\)):** The returns follow a normal distribution.
- **Alternative hypothesis (\(H_1\)):** The returns do not follow a normal distribution.

At a significance level of 0.05, the null hypothesis is rejected when the p-value is less than 0.05.

### Preliminary Results

Using the currently available September 2026 data, 8,639 logarithmic returns were calculated. A sample of 5,000 returns produced the following Shapiro-Wilk test results:

- W statistic: 0.88176
- p-value: less than 2.2 × 10⁻¹⁶

Since the p-value is below 0.05, the null hypothesis is rejected for this sample.

### Interpretation and Limitation

The preliminary result indicates that the sampled Ethereum returns from September 2026 do not follow a normal distribution according to the Shapiro-Wilk test.

However, these results do not represent the entire requested period from August 7, 2015, to September 15, 2026. The complete historical dataset must be obtained and processed before the final result can be reported as covering the full period.

### Program File

`II.Item2 ethereum shapiro wilk.R`

