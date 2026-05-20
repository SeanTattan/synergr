extract_4pl_params <- function(fit) {

  p <- stats::coef(fit)

  list(
    slope = unname(p[grep("^b:", names(p))]),
    min   = unname(p[grep("^c:", names(p))]),
    max   = unname(p[grep("^d:", names(p))]),
    IC50  = unname(p[grep("^e:", names(p))])
  )
}
