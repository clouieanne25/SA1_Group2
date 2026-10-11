
folder <- "C:/Users/User/Downloads/Ethereum_Data"

# Find the extracted CSV file
csv_file <- list.files(
  folder,
  pattern = "\\.csv$",
  full.names = TRUE
)

print(csv_file)

# Read the first CSV file
eth_test <- read.csv(
  csv_file[1],
  header = FALSE
)

# Display the first rows and column names
head(eth_test)
dim(eth_test)

# Name the columns based on Binance's CSV format
names(eth_test) <- c(
  "open_time", "open", "high", "low", "close", "volume",
  "close_time", "quote_volume", "trades",
  "taker_buy_base", "taker_buy_quote", "ignore"
)

# Sort by opening time
eth_test <- eth_test[order(eth_test$open_time), ]

# Calculate logarithmic returns
eth_test$return <- c(
  NA,
  diff(log(eth_test$close))
)

# Keep only finite returns
eth_returns <- eth_test$return[
  is.finite(eth_test$return)
]

# Descriptive statistics
cat("Number of returns:", length(eth_returns), "\n")
cat("Mean return:", mean(eth_returns), "\n")
cat("Standard deviation:", sd(eth_returns), "\n")

# Shapiro-Wilk test using 5,000 observations
set.seed(123)
sample_returns <- sample(eth_returns, 5000)

shapiro_result <- shapiro.test(sample_returns)
print(shapiro_result)


# Convert timestamps to dates

# Convert Binance timestamps from milliseconds to dates
eth_test$date <- as.POSIXct(
  as.numeric(eth_test$open_time) / 1000,
  origin = "1970-01-01",
  tz = "UTC"
)

# Check the date range
cat("First date:",
    format(min(eth_test$date, na.rm = TRUE), tz = "UTC"), "\n")

cat("Last date:",
    format(max(eth_test$date, na.rm = TRUE), tz = "UTC"), "\n")


# Check available date range
cat("First date:", format(min(eth_test$date)), "\n")
cat("Last date:", format(max(eth_test$date)), "\n")

# Display the first timestamp without scientific notation
options(scipen = 999)
print(eth_test$open_time[1], digits = 22)

# Check the approximate size of the timestamp
print(log10(eth_test$open_time[1]))