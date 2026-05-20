fit_single_agents <- function(df) {

  A_data <- df %>%
    dplyr::filter(DrugB == 0)

  B_data <- df %>%
    dplyr::filter(DrugA == 0)

  A_fit <- drc::drm(
    Response ~ DrugA,
    data = A_data,
    fct = drc::LL.4()
  )

  B_fit <- drc::drm(
    Response ~ DrugB,
    data = B_data,
    fct = drc::LL.4()
  )

  list(
    A = A_fit,
    B = B_fit
  )
}
