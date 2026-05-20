inverse_4pl <- function(
  response,
  IC50,
  slope,
  min,
  max
) {

  response <- pmin(
    pmax(response, min + 1e-6),
    max - 1e-6
  )

  IC50 * (
    ((max - min) / (response - min) - 1) ^
      (1 / slope)
  )
}
