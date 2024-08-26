non_gxp_tag <- function(id) {
  shiny::div(
    shiny::tags[["p"]]("\u26A0 This is a NonGxP module", style = "display: inline-block"),
    class = "alert alert-warning dv-nongxp-info-box",
    id = id
  )
}
