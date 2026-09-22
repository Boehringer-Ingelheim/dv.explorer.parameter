# apply_correlation_function labels errors as NA__spec_ids{corr_hm_module$show_errors_as_NA;corr_hm_module$show_missing_data_as_NA}

    Code
      res
    Output
                    x             y  z p-value (2-sided) 95% CI (min) 95% CI (max)  N
      1 par_1 - vis_1 par_1 - vis_1  1                NA           NA           NA NA
      2 par_1 - vis_1 par_2 - vis_1 NA                NA           NA           NA NA
      3 par_2 - vis_1 par_1 - vis_1 NA                NA           NA           NA NA
      4 par_2 - vis_1 par_2 - vis_1  1                NA           NA           NA NA
                                 error label
      1                           <NA>      
      2 not enough finite observations    NA
      3 not enough finite observations    NA
      4                           <NA>      

---

    Code
      res
    Output
                    x             y  z p-value (2-sided) 95% CI (min) 95% CI (max)  N
      1 par_1 - vis_1 par_1 - vis_1  1                NA           NA           NA NA
      2 par_1 - vis_1 par_2 - vis_1 NA                NA           NA           NA NA
      3 par_1 - vis_1 par_3 - vis_1 NA                NA           NA           NA  0
      4 par_2 - vis_1 par_1 - vis_1 NA                NA           NA           NA NA
      5 par_2 - vis_1 par_2 - vis_1  1                NA           NA           NA NA
      6 par_2 - vis_1 par_3 - vis_1 NA                NA           NA           NA  0
      7 par_3 - vis_1 par_1 - vis_1 NA                NA           NA           NA  0
      8 par_3 - vis_1 par_2 - vis_1 NA                NA           NA           NA  0
      9 par_3 - vis_1 par_3 - vis_1  1                NA           NA           NA  0
                                 error label
      1                           <NA>      
      2 not enough finite observations    NA
      3        not enough observations    NA
      4 not enough finite observations    NA
      5                           <NA>      
      6        not enough observations    NA
      7        not enough observations    NA
      8        not enough observations    NA
      9        not enough observations      

