analyse_synergy <- function(
  data,
  drug_a,
  drug_b,
  response
) {

  drug_a <- rlang::enquo(drug_a)
  drug_b <- rlang::enquo(drug_b)
  response <- rlang::enquo(response)

  df <- data %>%
    dplyr::transmute(
      DrugA = as.numeric(!!drug_a),
      DrugB = as.numeric(!!drug_b),
      Response = as.numeric(!!response)
    ) %>%
    dplyr::mutate(Response = pmax(Response, 0))

  validate_synergy_input(df)

  models <- fit_single_agents(df)

  ci_data <- calculate_loewe_ci(
    df,
    models$A,
    models$B
  )

  structure(
    list(
      data = df,
      ci_data = ci_data,
      models = models
    ),
    class = "synergy_result"
  )
}
