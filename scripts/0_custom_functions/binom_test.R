gbinom <- function(n, p, low=0, high=n,scale = F) {

  sd <- sqrt(n * p * (1 - p))
  if(scale && (n > 10)) {
    low <- max(0, round(n * p - 4 * sd))
    high <- min(n, round(n * p + 4 * sd))
  }
  values <- low:high
  probs <- dbinom(values, n, p)

  max_chance_performance <- max(values[which(probs > 0.025)])



  return((max_chance_performance/n)*100)
}
