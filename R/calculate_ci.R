calculate_loewe_ci <- function(df, A_fit, B_fit) {

  A_params <- extract_4pl_params(A_fit)
  B_params <- extract_4pl_params(B_fit)

  combo <- df %>%
    dplyr::filter(DrugA > 0, DrugB > 0)

  combo %>%
    dplyr::rowwise() %>%
    dplyr::mutate(

      Dx_A = inverse_4pl(
        Response,
        A_params$IC50,
        A_params$slope,
        A_params$min,
        A_params$max
      ),

      Dx_B = inverse_4pl(
        Response,
        B_params$IC50,
        B_params$slope,
        B_params$min,
        B_params$max
      ),

      CI = DrugA / Dx_A + DrugB / Dx_B
    ) %>%
    dplyr::ungroup()
}
