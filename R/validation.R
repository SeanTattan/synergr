validate_synergy_input <- function(df) {

  required <- c("DrugA", "DrugB", "Response")

  missing <- setdiff(required, names(df))

  if (length(missing) > 0) {
    stop(
      "Missing columns: ",
      paste(missing, collapse = ", ")
    )
  }

  invisible(TRUE)
}
