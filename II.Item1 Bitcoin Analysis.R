
# ============================================================
# ITEM II.1: BITCOIN DISTRIBUTION ANALYSIS
# ============================================================

# 1. Set folder and load data

folder <- "C:/Users/User/Downloads/Bitcoin_Data"

file_path <- file.path(folder, "bitcoin.csv")

if (!file.exists(file_path)) {
  stop("bitcoin.csv was not found. Check the folder path.")
}

bitcoin <- read.csv(
  file_path,
  stringsAsFactors = FALSE
)

cat("Bitcoin dataset loaded successfully!\n")
cat("Number of rows:", nrow(bitcoin), "\n")
cat("Column names:", paste(names(bitcoin), collapse = ", "), "\n")

# Check required columns
if (!all(c("datetime_utc", "close") %in% names(bitcoin))) {
  stop("Required columns 'datetime_utc' and 'close' were not found.")
}

# 2. Install and load package

if (!requireNamespace("fitdistrplus", quietly = TRUE)) {
  install.packages("fitdistrplus")
}

library(fitdistrplus)


# 3. Parse timestamps directly from the original text

bitcoin$datetime_utc <- as.POSIXct(
  as.character(bitcoin$datetime_utc),
  format = "%Y-%m-%d %H:%M:%S",
  tz = "UTC"
)

bitcoin$close <- as.numeric(as.character(bitcoin$close))

# Remove invalid rows
bitcoin <- bitcoin[
  !is.na(bitcoin$datetime_utc) &
    is.finite(bitcoin$close) &
    bitcoin$close > 0,
]

# Sort by timestamp
bitcoin <- bitcoin[order(bitcoin$datetime_utc), ]

# Remove duplicate timestamps
bitcoin <- bitcoin[!duplicated(bitcoin$datetime_utc), ]

# 4. Keep the required date range

start_date <- as.POSIXct(
  "2012-01-01 00:00:00",
  format = "%Y-%m-%d %H:%M:%S",
  tz = "UTC"
)

end_date <- as.POSIXct(
  "2026-09-16 00:00:00",
  format = "%Y-%m-%d %H:%M:%S",
  tz = "UTC"
)

bitcoin <- bitcoin[
  bitcoin$datetime_utc >= start_date &
    bitcoin$datetime_utc < end_date,
]

# 5. Calculate time gaps and log-price changes

time_gap <- as.numeric(
  difftime(
    bitcoin$datetime_utc[-1],
    bitcoin$datetime_utc[-nrow(bitcoin)],
    units = "secs"
  )
)

price_change <- diff(log(bitcoin$close))

# Keep only observations exactly 60 seconds apart
valid_minute <- time_gap == 60

returns <- price_change[valid_minute]
returns <- returns[is.finite(returns)]

# 6. Check the results

cat("Valid Bitcoin records:", nrow(bitcoin), "\n")
cat("Gaps of exactly 60 seconds:", sum(valid_minute), "\n")
cat("Valid one-minute returns:", length(returns), "\n")

if (length(returns) < 100) {
  stop("Still too few returns. Please send me the output above.")
}

cat("Mean return:", mean(returns), "\n")
cat("Standard deviation:", sd(returns), "\n")



# 7. Prepare a clean sample for distribution fitting

set.seed(123)

# Remove non-finite values
clean_returns <- returns[is.finite(returns)]

# Use a random sample to make fitting faster
fit_data <- if (length(clean_returns) > 100000) {
  sample(clean_returns, 100000)
} else {
  clean_returns
}

# Check the sample
cat("\nFITTING SAMPLE CHECK\n")
cat("Sample size:", length(fit_data), "\n")
cat("Minimum:", min(fit_data), "\n")
cat("Maximum:", max(fit_data), "\n")
cat("Unique values:", length(unique(fit_data)), "\n")

if (length(fit_data) < 100 || length(unique(fit_data)) < 2) {
  stop("The fitting sample has insufficient variation.")
}

# Center and scale the returns to improve numerical stability
fit_mean <- mean(fit_data)
fit_sd <- sd(fit_data)

if (!is.finite(fit_sd) || fit_sd == 0) {
  stop("The fitting sample has an invalid standard deviation.")
}

fit_data <- (fit_data - fit_mean) / fit_sd

# 8. Fit candidate probability distributions

cat("\nFITTING DISTRIBUTIONS...\n")

fit_normal <- fitdist(fit_data, "norm")
fit_logistic <- fitdist(fit_data, "logis")
fit_cauchy <- fitdist(fit_data, "cauchy")

cat("All three distributions fitted successfully.\n")


# 9. Compare AIC and BIC
# Lower AIC/BIC generally indicates a better fit among candidates

comparison <- data.frame(
  Distribution = c("Normal", "Logistic", "Cauchy"),
  AIC = c(
    AIC(fit_normal),
    AIC(fit_logistic),
    AIC(fit_cauchy)
  ),
  BIC = c(
    BIC(fit_normal),
    BIC(fit_logistic),
    BIC(fit_cauchy)
  )
)

comparison <- comparison[order(comparison$AIC), ]

cat("\nDISTRIBUTION COMPARISON\n")
print(comparison)

write.csv(
  comparison,
  file.path(folder, "bitcoin_distribution_comparison.csv"),
  row.names = FALSE
)

# 10. Plot the fitted distributions

png(
  file.path(folder, "bitcoin_distribution_plot.png"),
  width = 1200,
  height = 800
)

denscomp(
  list(fit_normal, fit_logistic, fit_cauchy),
  legendtext = c("Normal", "Logistic", "Cauchy"),
  main = "Bitcoin One-Minute Return Distributions"
)

dev.off()

# 11. Plot the histogram and fitted normal curve

png(
  file.path(folder, "bitcoin_return_histogram.png"),
  width = 1200,
  height = 800
)

hist(
  fit_data,
  breaks = 100,
  probability = TRUE,
  main = "Bitcoin One-Minute Log Returns",
  xlab = "Log return"
)

curve(
  dnorm(
    x,
    mean = fit_normal$estimate["mean"],
    sd = fit_normal$estimate["sd"]
  ),
  add = TRUE,
  lwd = 2
)

dev.off()

# 12. Display the best candidate based on AIC

best_distribution <- comparison$Distribution[1]

cat("\nRESULT\n")
cat("Lowest-AIC candidate:", best_distribution, "\n")
cat(
  "Among the three distributions tested,",
  best_distribution,
  "has the lowest AIC.\n"
)

cat("\nFiles saved in:", folder, "\n")
cat("- bitcoin_distribution_comparison.csv\n")
cat("- bitcoin_distribution_plot.png\n")
cat("- bitcoin_return_histogram.png\n")
