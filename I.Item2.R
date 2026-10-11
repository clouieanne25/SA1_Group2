
# ITEM 2: DISCRETE RANDOM VARIABLES
# Univariate and Bivariate Distributions
# RStudio - Base R only

# -------------------------------
# INPUT AND VALIDATION FUNCTIONS
# -------------------------------

read_vector <- function(prompt) {
  repeat {
    input <- readline(prompt)
    values <- suppressWarnings(
      as.numeric(trimws(strsplit(input, ",", fixed = TRUE)[[1]]))
    )
    
    if (length(values) > 0 && all(is.finite(values))) {
      return(values)
    }
    
    cat("Invalid input. Enter numbers separated by commas.\n")
  }
}

read_positive_vector <- function(prompt) {
  repeat {
    values <- read_vector(prompt)
    
    if (all(values > 0) && !anyDuplicated(values)) {
      return(values)
    }
    
    cat("Values must be positive and unique.\n")
  }
}

read_probabilities <- function(prompt, n) {
  repeat {
    p <- read_vector(prompt)
    
    if (length(p) != n) {
      cat("Invalid input: enter exactly", n, "probabilities.\n")
    } else if (any(p < 0 | p > 1)) {
      cat("Invalid input: probabilities must be between 0 and 1.\n")
    } else if (abs(sum(p) - 1) > 1e-8) {
      cat("Invalid input: probabilities must sum to 1.\n")
    } else {
      return(p)
    }
  }
}

# -------------------------------
# MEAN AND VARIANCE
# -------------------------------

distribution_stats <- function(values, probabilities) {
  mean_value <- sum(values * probabilities)
  
  variance_value <- sum(
    probabilities * (values - mean_value)^2
  )
  
  c(Mean = mean_value, Variance = variance_value)
}

# -------------------------------
# UNIVARIATE DISTRIBUTION
# -------------------------------

univariate <- function() {
  cat("\n--- UNIVARIATE DISCRETE DISTRIBUTION ---\n")
  cat("Enter values and probabilities separated by commas.\n")
  
  repeat {
    x <- read_vector("Enter values of X: ")
    
    if (!anyDuplicated(x)) {
      break
    }
    
    cat("X values must be unique. Try again.\n")
  }
  
  p <- read_probabilities(
    "Enter corresponding probabilities: ", length(x)
  )
  
  # Sort values in ascending order
  ord <- order(x)
  x <- x[ord]
  p <- p[ord]
  
  # Calculate statistics
  stats <- distribution_stats(x, p)
  
  cat("\nProbability Distribution:\n")
  print(data.frame(X = x, Probability = p, CDF = cumsum(p)))
  
  cat("\nMean =", stats["Mean"], "\n")
  cat("Variance =", stats["Variance"], "\n")
  
  # Plot PMF
  plot(
    x, p,
    type = "h",
    lwd = 3,
    col = "blue",
    main = "Univariate PMF",
    xlab = "X",
    ylab = "P(X = x)"
  )
  points(x, p, pch = 19, col = "blue")
  
  # Plot CDF
  plot(
    x, cumsum(p),
    type = "s",
    lwd = 2,
    col = "red",
    ylim = c(0, 1.05),
    main = "Univariate CDF",
    xlab = "X",
    ylab = "F(X)"
  )
  points(x, cumsum(p), pch = 19, col = "red")
  
  invisible(list(X = x, P = p, Statistics = stats))
}

# -------------------------------
# BIVARIATE DISTRIBUTION
# -------------------------------

bivariate <- function() {
  cat("\n--- BIVARIATE DISCRETE DISTRIBUTION ---\n")
  
  cat("Enter the distinct values of X and Y.\n")
  x <- read_positive_vector("Enter X values: ")
  y <- read_positive_vector("Enter Y values: ")
  
  # Allow zero and negative values too.
  # Correct invalid positive-only inputs if needed:
  # The function above is replaced below with general validation.
  
  # Sort values
  x <- sort(x)
  y <- sort(y)
  
  nx <- length(x)
  ny <- length(y)
  
  cat("\nEnter the joint probabilities row by row.\n")
  cat("Each row corresponds to an X value.\n")
  cat("Columns correspond to Y values in this order:\n")
  print(y)
  
  repeat {
    joint <- matrix(NA_real_, nrow = nx, ncol = ny)
    
    for (i in seq_len(nx)) {
      repeat {
        row_p <- read_vector(
          paste0("Probabilities for X = ", x[i], ": ")
        )
        
        if (length(row_p) != ny) {
          cat("Enter exactly", ny, "probabilities.\n")
        } else if (any(row_p < 0 | row_p > 1)) {
          cat("Probabilities must be between 0 and 1.\n")
        } else {
          joint[i, ] <- row_p
          break
        }
      }
    }
    
    if (abs(sum(joint) - 1) <= 1e-8) {
      break
    }
    
    cat(
      "Invalid joint distribution: all joint probabilities",
      "must sum to 1. Please enter the matrix again.\n"
    )
  }
  
  rownames(joint) <- paste0("X=", x)
  colnames(joint) <- paste0("Y=", y)
  
  cat("\nJoint Probability Distribution:\n")
  print(joint)
  
  # Marginal distributions
  px <- rowSums(joint)
  py <- colSums(joint)
  
  cat("\nMarginal Distribution of X:\n")
  print(data.frame(X = x, Probability = px))
  
  cat("\nMarginal Distribution of Y:\n")
  print(data.frame(Y = y, Probability = py))
  
  # Mean and variance of each marginal distribution
  stats_x <- distribution_stats(x, px)
  stats_y <- distribution_stats(y, py)
  
  cat("\nStatistics of X:\n")
  print(stats_x)
  
  cat("\nStatistics of Y:\n")
  print(stats_y)
  
  # Conditional distribution of Y given X
  cat("\n--- Conditional Distribution: Y given X ---\n")
  
  for (i in seq_along(x)) {
    cat("\nGiven X =", x[i], "\n")
    
    if (px[i] > 0) {
      cond <- joint[i, ] / px[i]
      print(data.frame(Y = y, ConditionalProbability = cond))
      print(distribution_stats(y, cond))
    } else {
      cat("Undefined because P(X =", x[i], ") = 0.\n")
    }
  }
  
  # Conditional distribution of X given Y
  cat("\n--- Conditional Distribution: X given Y ---\n")
  
  for (j in seq_along(y)) {
    cat("\nGiven Y =", y[j], "\n")
    
    if (py[j] > 0) {
      cond <- joint[, j] / py[j]
      print(data.frame(X = x, ConditionalProbability = cond))
      print(distribution_stats(x, cond))
    } else {
      cat("Undefined because P(Y =", y[j], ") = 0.\n")
    }
  }
  
  # Plot joint PMF
  image(
    x, y, joint,
    col = heat.colors(20),
    main = "Bivariate Joint PMF",
    xlab = "X",
    ylab = "Y"
  )
  
  # Calculate joint CDF:
  # F(x,y) = P(X <= x, Y <= y)
  joint_cdf <- matrix(0, nrow = nx, ncol = ny)
  
  for (i in seq_len(nx)) {
    for (j in seq_len(ny)) {
      joint_cdf[i, j] <- sum(joint[1:i, 1:j, drop = FALSE])
    }
  }
  
  cat("\nJoint CDF:\n")
  print(joint_cdf)
  
  # Plot joint CDF
  image(
    x, y, joint_cdf,
    col = heat.colors(20),
    zlim = c(0, 1),
    main = "Bivariate Joint CDF",
    xlab = "X",
    ylab = "Y"
  )
  
  invisible(list(
    X = x,
    Y = y,
    Joint = joint,
    MarginalX = px,
    MarginalY = py,
    JointCDF = joint_cdf,
    StatisticsX = stats_x,
    StatisticsY = stats_y
  ))
}

# -------------------------------
# MAIN MENU
# -------------------------------

repeat {
  cat("\n====================================\n")
  cat(" DISCRETE PROBABILITY DISTRIBUTIONS\n")
  cat("====================================\n")
  cat("1. Univariate Distribution\n")
  cat("2. Bivariate Distribution\n")
  cat("3. Exit\n")
  
  choice <- readline("Choose an option (1-3): ")
  
  if (choice == "1") {
    univariate()
  } else if (choice == "2") {
    bivariate()
  } else if (choice == "3") {
    cat("Program ended.\n")
    break
  } else {
    cat("Invalid choice. Please enter 1, 2, or 3.\n")
  }
}
