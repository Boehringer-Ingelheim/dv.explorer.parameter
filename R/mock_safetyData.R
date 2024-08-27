safety_data <- function() {
  if (!requireNamespace("safetyData")) {
    stop("Install safetyData")
  }

  adsl <- safetyData::adam_adsl
  adlb <- safetyData::adam_adlbc

  avisitn_mask <- is.finite(adlb[["AVISITN"]]) & adlb[["AVISITN"]] < 99
  adlb <- adlb[avisitn_mask, ]

  adsl_labels <- dv.explorer.parameter::get_lbls_robust(adsl)
  adlb_labels <- dv.explorer.parameter::get_lbls_robust(adlb)

  adsl <- adsl |>
    dplyr::mutate(
      dplyr::across(dplyr::where(is.character), factor)
    ) |>
    dv.explorer.parameter::set_lbls(adsl_labels)

  visits_ <- unique(adlb[c("AVISITN", "VISIT")])
  visits <- visits_[order(visits_[["AVISITN"]]), ][["VISIT"]]
  adlb[["VISIT"]] <- factor(adlb[["VISIT"]], levels = visits)

  adlb <- adlb |>
    dplyr::mutate(
      dplyr::across(dplyr::where(is.character), factor)
    ) |>
    dv.explorer.parameter::set_lbls(adlb_labels)

  list(sl = adsl, bm = adlb)
}
