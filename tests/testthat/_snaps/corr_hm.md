# apply_correlation_function labels errors as NA__spec_ids{corr_hm_module$show_errors_as_NA;corr_hm_module$show_missing_data_as_NA}

    Code
      res
    Output
                    x             y  z p-value (2-sided) 95% CI (lower)
      1 par_1 - vis_1 par_1 - vis_1  1                NA             NA
      2 par_1 - vis_1 par_2 - vis_1 NA                NA             NA
      3 par_2 - vis_1 par_1 - vis_1 NA                NA             NA
      4 par_2 - vis_1 par_2 - vis_1  1                NA             NA
        95% CI (upper)  N                          error label
      1             NA NA                           <NA>      
      2             NA NA not enough finite observations    NA
      3             NA NA not enough finite observations    NA
      4             NA NA                           <NA>      

---

    Code
      res
    Output
                    x             y  z p-value (2-sided) 95% CI (lower)
      1 par_1 - vis_1 par_1 - vis_1  1                NA             NA
      2 par_1 - vis_1 par_2 - vis_1 NA                NA             NA
      3 par_1 - vis_1 par_3 - vis_1 NA                NA             NA
      4 par_2 - vis_1 par_1 - vis_1 NA                NA             NA
      5 par_2 - vis_1 par_2 - vis_1  1                NA             NA
      6 par_2 - vis_1 par_3 - vis_1 NA                NA             NA
      7 par_3 - vis_1 par_1 - vis_1 NA                NA             NA
      8 par_3 - vis_1 par_2 - vis_1 NA                NA             NA
      9 par_3 - vis_1 par_3 - vis_1  1                NA             NA
        95% CI (upper)  N                          error label
      1             NA NA                           <NA>      
      2             NA NA not enough finite observations    NA
      3             NA  0        not enough observations    NA
      4             NA NA not enough finite observations    NA
      5             NA NA                           <NA>      
      6             NA  0        not enough observations    NA
      7             NA  0        not enough observations    NA
      8             NA  0        not enough observations    NA
      9             NA  0        not enough observations      

