# charts are created__spec_ids{roc$composition;roc$outputs$info_panel}

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds
      # A tibble: 200 x 6
         subject_id predictor_parameter predictor_value response_parameter
         <fct>      <fct>                         <dbl> <fct>             
       1 1          A1                            1.57  BinA1             
       2 2          A1                            1.37  BinA1             
       3 3          A1                            0.575 BinA1             
       4 4          A1                            1.95  BinA1             
       5 5          A1                            0.611 BinA1             
       6 6          A1                            0.716 BinA1             
       7 7          A1                            1.86  BinA1             
       8 8          A1                            2.72  BinA1             
       9 9          A1                            1.27  BinA1             
      10 10         A1                            0.578 BinA1             
      # i 190 more rows
      # i 2 more variables: response_value <fct>, group <fct>
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds_list
      $ds_list$roc_curve
      # A tibble: 206 x 9
         predictor_parameter response_parameter group   sensitivity specificity
         <fct>               <fct>              <fct>         <dbl>       <dbl>
       1 A1                  BinA1              ARM A        0                1
       2 A1                  BinA1              ARM B        0                1
       3 A1                  BinA1              PLACEBO      0                1
       4 A2                  BinA1              ARM A        0                1
       5 A2                  BinA1              ARM B        0                1
       6 A2                  BinA1              PLACEBO      0                1
       7 A1                  BinA1              ARM B        0.0588           1
       8 A1                  BinA1              ARM A        0.0625           1
       9 A1                  BinA1              PLACEBO      0.0833           1
      10 A2                  BinA1              PLACEBO      0.0833           1
      # i 196 more rows
      # i 4 more variables: threshold <dbl>, auc <list>, levels <list>,
      #   direction <chr>
      
      $ds_list$roc_ci
      # A tibble: 12 x 10
         predictor_parameter response_parameter group   ci_specificity
         <fct>               <fct>              <fct>            <dbl>
       1 A1                  BinA1              ARM A            0.259
       2 A1                  BinA1              ARM A            0.519
       3 A1                  BinA1              ARM B            0.286
       4 A1                  BinA1              ARM B            0.5  
       5 A1                  BinA1              PLACEBO          0.286
       6 A1                  BinA1              PLACEBO          0.5  
       7 A2                  BinA1              ARM A            0.259
       8 A2                  BinA1              ARM A            0.519
       9 A2                  BinA1              ARM B            0.286
      10 A2                  BinA1              ARM B            0.5  
      11 A2                  BinA1              PLACEBO          0.286
      12 A2                  BinA1              PLACEBO          0.5  
      # i 6 more variables: ci_lower_specificity <dbl>, ci_upper_specificity <dbl>,
      #   ci_sensitivity <dbl>, ci_lower_sensitivity <dbl>,
      #   ci_upper_sensitivity <dbl>, threshold <dbl>
      
      $ds_list$roc_optimal_cut
      # A tibble: 6 x 11
        predictor_parameter response_parameter group   optimal_cut_title
        <fct>               <fct>              <fct>   <chr>            
      1 A1                  BinA1              ARM A   Youden Index     
      2 A1                  BinA1              ARM B   Youden Index     
      3 A1                  BinA1              PLACEBO Youden Index     
      4 A2                  BinA1              ARM A   Youden Index     
      5 A2                  BinA1              ARM B   Youden Index     
      6 A2                  BinA1              PLACEBO Youden Index     
      # i 7 more variables: optimal_cut_sensitivity <dbl>,
      #   optimal_cut_specificity <dbl>, optimal_cut_threshold <dbl>,
      #   optimal_cut_upper_specificity <dbl>, optimal_cut_lower_specificity <dbl>,
      #   optimal_cut_upper_sensitivity <dbl>, optimal_cut_lower_sensitivity <dbl>
      
      
      $param_as_cols
      [1] TRUE
      
      $fig_size
      [1] 200
      
      $is_sorted
      [1] TRUE
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds
      # A tibble: 200 x 6
         subject_id predictor_parameter predictor_value response_parameter
         <fct>      <fct>                         <dbl> <fct>             
       1 1          A1                            1.57  BinA1             
       2 2          A1                            1.37  BinA1             
       3 3          A1                            0.575 BinA1             
       4 4          A1                            1.95  BinA1             
       5 5          A1                            0.611 BinA1             
       6 6          A1                            0.716 BinA1             
       7 7          A1                            1.86  BinA1             
       8 8          A1                            2.72  BinA1             
       9 9          A1                            1.27  BinA1             
      10 10         A1                            0.578 BinA1             
      # i 190 more rows
      # i 2 more variables: response_value <fct>, group <fct>
      
      $param_as_cols
      [1] TRUE
      
      $fig_size
      [1] 200
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds
      # A tibble: 200 x 6
         subject_id predictor_parameter predictor_value response_parameter
         <fct>      <fct>                         <dbl> <fct>             
       1 1          A1                            1.57  BinA1             
       2 2          A1                            1.37  BinA1             
       3 3          A1                            0.575 BinA1             
       4 4          A1                            1.95  BinA1             
       5 5          A1                            0.611 BinA1             
       6 6          A1                            0.716 BinA1             
       7 7          A1                            1.86  BinA1             
       8 8          A1                            2.72  BinA1             
       9 9          A1                            1.27  BinA1             
      10 10         A1                            0.578 BinA1             
      # i 190 more rows
      # i 2 more variables: response_value <fct>, group <fct>
      
      $param_as_cols
      [1] TRUE
      
      $fig_size
      [1] 200
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds
      # A tibble: 200 x 6
         subject_id predictor_parameter predictor_value response_parameter
         <fct>      <fct>                         <dbl> <fct>             
       1 1          A1                            1.57  BinA1             
       2 2          A1                            1.37  BinA1             
       3 3          A1                            0.575 BinA1             
       4 4          A1                            1.95  BinA1             
       5 5          A1                            0.611 BinA1             
       6 6          A1                            0.716 BinA1             
       7 7          A1                            1.86  BinA1             
       8 8          A1                            2.72  BinA1             
       9 9          A1                            1.27  BinA1             
      10 10         A1                            0.578 BinA1             
      # i 190 more rows
      # i 2 more variables: response_value <fct>, group <fct>
      
      $quantile_type
      [1] 7
      
      $param_as_cols
      [1] TRUE
      
      $fig_size
      [1] 200
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds
      # A tibble: 200 x 6
         subject_id predictor_parameter predictor_value response_parameter
         <fct>      <fct>                         <dbl> <fct>             
       1 1          A1                            1.57  BinA1             
       2 2          A1                            1.37  BinA1             
       3 3          A1                            0.575 BinA1             
       4 4          A1                            1.95  BinA1             
       5 5          A1                            0.611 BinA1             
       6 6          A1                            0.716 BinA1             
       7 7          A1                            1.86  BinA1             
       8 8          A1                            2.72  BinA1             
       9 9          A1                            1.27  BinA1             
      10 10         A1                            0.578 BinA1             
      # i 190 more rows
      # i 2 more variables: response_value <fct>, group <fct>
      
      $param_as_cols
      [1] TRUE
      
      $fig_size
      [1] 200
      
      $x_metrics_col
      [1] "norm_rank"
      
      $compute_metric_fn
      function (predictor, response) 
      {
          cds <- dplyr::ungroup(tidyr::pivot_longer(dplyr::mutate(tidyr::pivot_wider(dplyr::rename(dplyr::select(as.data.frame(precrec::evalmod(scores = as.numeric(predictor), 
              labels = as.character(response), mode = "basic")), -.data[["dsid"]], 
              -.data[["modname"]]), norm_rank = .data[["x"]]), values_from = "y", 
              names_from = "type"), norm_score = {
              val <- .data[["score"]]
              min_val <- min(val, na.rm = TRUE)
              max_val <- max(val, na.rm = TRUE)
              (val - min_val)/(max_val - min_val)
          }), cols = -dplyr::all_of(c("norm_rank", "score", "norm_score")), 
              names_to = "type", values_to = "y"))
          limits <- list(accuracy = c(0, 1), label = c(-1, 1), error = c(0, 
              1), specificity = c(0, 1), sensitivity = c(0, 1), precision = c(0, 
              1), mcc = c(-1, 1), fscore = c(0, 1))
          structure(cds, limits = limits)
      }
      <bytecode: 0x558502d1aca8>
      <environment: namespace:dv.explorer.parameter>
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Message
      (Compute ROC): Setting direction: controls > cases
      (Compute ROC): Setting direction: controls > cases
      (Compute ROC): Setting direction: controls > cases
      (Compute ROC): Setting direction: controls > cases
      (Compute ROC): Setting direction: controls > cases
      (Compute ROC): Setting direction: controls > cases
      (Compute ROC): Setting direction: controls < cases
      (Compute ROC): Setting direction: controls > cases
      (Compute ROC): Setting direction: controls > cases
      (Compute ROC): Setting direction: controls < cases
      (Compute ROC): Setting direction: controls < cases
      (Compute ROC): Setting direction: controls < cases
    Output
      $ds
      # A tibble: 12 x 8
         predictor_parameter response_parameter group     auc levels    direction
         <fct>               <fct>              <fct>   <dbl> <list>    <chr>    
       1 A1                  BinA1              ARM A   0.549 <chr [2]> >        
       2 A1                  BinA1              ARM B   0.647 <chr [2]> >        
       3 A1                  BinA1              PLACEBO 0.577 <chr [2]> >        
       4 B1                  BinA1              ARM A   0.477 <chr [2]> >        
       5 B1                  BinA1              ARM B   0.542 <chr [2]> >        
       6 B1                  BinA1              PLACEBO 0.571 <chr [2]> >        
       7 A2                  BinA1              ARM A   0.678 <chr [2]> <        
       8 A2                  BinA1              ARM B   0.462 <chr [2]> >        
       9 A2                  BinA1              PLACEBO 0.661 <chr [2]> >        
      10 A3                  BinA1              ARM A   0.525 <chr [2]> <        
      11 A3                  BinA1              ARM B   0.424 <chr [2]> <        
      12 A3                  BinA1              PLACEBO 0.583 <chr [2]> <        
      # i 2 more variables: lower_CI_auc <dbl>, upper_CI_auc <dbl>
      
      $fig_size
      [1] 200
      
      $sort_alph
      [1] FALSE
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds_list
      $ds_list$roc_curve
      # A tibble: 206 x 9
         predictor_parameter response_parameter group   sensitivity specificity
         <fct>               <fct>              <fct>         <dbl>       <dbl>
       1 A1                  BinA1              ARM A        0                1
       2 A1                  BinA1              ARM B        0                1
       3 A1                  BinA1              PLACEBO      0                1
       4 A2                  BinA1              ARM A        0                1
       5 A2                  BinA1              ARM B        0                1
       6 A2                  BinA1              PLACEBO      0                1
       7 A1                  BinA1              ARM B        0.0588           1
       8 A1                  BinA1              ARM A        0.0625           1
       9 A1                  BinA1              PLACEBO      0.0833           1
      10 A2                  BinA1              PLACEBO      0.0833           1
      # i 196 more rows
      # i 4 more variables: threshold <dbl>, auc <list>, levels <list>,
      #   direction <chr>
      
      $ds_list$roc_ci
      # A tibble: 12 x 10
         predictor_parameter response_parameter group   ci_specificity
         <fct>               <fct>              <fct>            <dbl>
       1 A1                  BinA1              ARM A            0.259
       2 A1                  BinA1              ARM A            0.519
       3 A1                  BinA1              ARM B            0.286
       4 A1                  BinA1              ARM B            0.5  
       5 A1                  BinA1              PLACEBO          0.286
       6 A1                  BinA1              PLACEBO          0.5  
       7 A2                  BinA1              ARM A            0.259
       8 A2                  BinA1              ARM A            0.519
       9 A2                  BinA1              ARM B            0.286
      10 A2                  BinA1              ARM B            0.5  
      11 A2                  BinA1              PLACEBO          0.286
      12 A2                  BinA1              PLACEBO          0.5  
      # i 6 more variables: ci_lower_specificity <dbl>, ci_upper_specificity <dbl>,
      #   ci_sensitivity <dbl>, ci_lower_sensitivity <dbl>,
      #   ci_upper_sensitivity <dbl>, threshold <dbl>
      
      $ds_list$roc_optimal_cut
      # A tibble: 6 x 11
        predictor_parameter response_parameter group   optimal_cut_title
        <fct>               <fct>              <fct>   <chr>            
      1 A1                  BinA1              ARM A   Youden Index     
      2 A1                  BinA1              ARM B   Youden Index     
      3 A1                  BinA1              PLACEBO Youden Index     
      4 A2                  BinA1              ARM A   Youden Index     
      5 A2                  BinA1              ARM B   Youden Index     
      6 A2                  BinA1              PLACEBO Youden Index     
      # i 7 more variables: optimal_cut_sensitivity <dbl>,
      #   optimal_cut_specificity <dbl>, optimal_cut_threshold <dbl>,
      #   optimal_cut_upper_specificity <dbl>, optimal_cut_lower_specificity <dbl>,
      #   optimal_cut_upper_sensitivity <dbl>, optimal_cut_lower_sensitivity <dbl>
      
      
      $sort_alph
      [1] FALSE
      

# charts are created. Ungrouped__spec_ids{roc$composition;roc$outputs$info_panel}

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds
      # A tibble: 200 x 6
         subject_id predictor_parameter predictor_value response_parameter
         <fct>      <fct>                         <dbl> <fct>             
       1 1          A1                            1.57  BinA1             
       2 2          A1                            1.37  BinA1             
       3 3          A1                            0.575 BinA1             
       4 4          A1                            1.95  BinA1             
       5 5          A1                            0.611 BinA1             
       6 6          A1                            0.716 BinA1             
       7 7          A1                            1.86  BinA1             
       8 8          A1                            2.72  BinA1             
       9 9          A1                            1.27  BinA1             
      10 10         A1                            0.578 BinA1             
      # i 190 more rows
      # i 2 more variables: response_value <fct>, group <fct>
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds_list
      $ds_list$roc_curve
      # A tibble: 206 x 9
         predictor_parameter response_parameter group   sensitivity specificity
         <fct>               <fct>              <fct>         <dbl>       <dbl>
       1 A1                  BinA1              ARM A        0                1
       2 A1                  BinA1              ARM B        0                1
       3 A1                  BinA1              PLACEBO      0                1
       4 A2                  BinA1              ARM A        0                1
       5 A2                  BinA1              ARM B        0                1
       6 A2                  BinA1              PLACEBO      0                1
       7 A1                  BinA1              ARM B        0.0588           1
       8 A1                  BinA1              ARM A        0.0625           1
       9 A1                  BinA1              PLACEBO      0.0833           1
      10 A2                  BinA1              PLACEBO      0.0833           1
      # i 196 more rows
      # i 4 more variables: threshold <dbl>, auc <list>, levels <list>,
      #   direction <chr>
      
      $ds_list$roc_ci
      # A tibble: 12 x 10
         predictor_parameter response_parameter group   ci_specificity
         <fct>               <fct>              <fct>            <dbl>
       1 A1                  BinA1              ARM A            0.259
       2 A1                  BinA1              ARM A            0.519
       3 A1                  BinA1              ARM B            0.286
       4 A1                  BinA1              ARM B            0.5  
       5 A1                  BinA1              PLACEBO          0.286
       6 A1                  BinA1              PLACEBO          0.5  
       7 A2                  BinA1              ARM A            0.259
       8 A2                  BinA1              ARM A            0.519
       9 A2                  BinA1              ARM B            0.286
      10 A2                  BinA1              ARM B            0.5  
      11 A2                  BinA1              PLACEBO          0.286
      12 A2                  BinA1              PLACEBO          0.5  
      # i 6 more variables: ci_lower_specificity <dbl>, ci_upper_specificity <dbl>,
      #   ci_sensitivity <dbl>, ci_lower_sensitivity <dbl>,
      #   ci_upper_sensitivity <dbl>, threshold <dbl>
      
      $ds_list$roc_optimal_cut
      # A tibble: 6 x 11
        predictor_parameter response_parameter group   optimal_cut_title
        <fct>               <fct>              <fct>   <chr>            
      1 A1                  BinA1              ARM A   Youden Index     
      2 A1                  BinA1              ARM B   Youden Index     
      3 A1                  BinA1              PLACEBO Youden Index     
      4 A2                  BinA1              ARM A   Youden Index     
      5 A2                  BinA1              ARM B   Youden Index     
      6 A2                  BinA1              PLACEBO Youden Index     
      # i 7 more variables: optimal_cut_sensitivity <dbl>,
      #   optimal_cut_specificity <dbl>, optimal_cut_threshold <dbl>,
      #   optimal_cut_upper_specificity <dbl>, optimal_cut_lower_specificity <dbl>,
      #   optimal_cut_upper_sensitivity <dbl>, optimal_cut_lower_sensitivity <dbl>
      
      
      $param_as_cols
      [1] TRUE
      
      $fig_size
      [1] 200
      
      $is_sorted
      [1] TRUE
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds
      # A tibble: 200 x 6
         subject_id predictor_parameter predictor_value response_parameter
         <fct>      <fct>                         <dbl> <fct>             
       1 1          A1                            1.57  BinA1             
       2 2          A1                            1.37  BinA1             
       3 3          A1                            0.575 BinA1             
       4 4          A1                            1.95  BinA1             
       5 5          A1                            0.611 BinA1             
       6 6          A1                            0.716 BinA1             
       7 7          A1                            1.86  BinA1             
       8 8          A1                            2.72  BinA1             
       9 9          A1                            1.27  BinA1             
      10 10         A1                            0.578 BinA1             
      # i 190 more rows
      # i 2 more variables: response_value <fct>, group <fct>
      
      $param_as_cols
      [1] TRUE
      
      $fig_size
      [1] 200
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds
      # A tibble: 200 x 6
         subject_id predictor_parameter predictor_value response_parameter
         <fct>      <fct>                         <dbl> <fct>             
       1 1          A1                            1.57  BinA1             
       2 2          A1                            1.37  BinA1             
       3 3          A1                            0.575 BinA1             
       4 4          A1                            1.95  BinA1             
       5 5          A1                            0.611 BinA1             
       6 6          A1                            0.716 BinA1             
       7 7          A1                            1.86  BinA1             
       8 8          A1                            2.72  BinA1             
       9 9          A1                            1.27  BinA1             
      10 10         A1                            0.578 BinA1             
      # i 190 more rows
      # i 2 more variables: response_value <fct>, group <fct>
      
      $param_as_cols
      [1] TRUE
      
      $fig_size
      [1] 200
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds
      # A tibble: 200 x 6
         subject_id predictor_parameter predictor_value response_parameter
         <fct>      <fct>                         <dbl> <fct>             
       1 1          A1                            1.57  BinA1             
       2 2          A1                            1.37  BinA1             
       3 3          A1                            0.575 BinA1             
       4 4          A1                            1.95  BinA1             
       5 5          A1                            0.611 BinA1             
       6 6          A1                            0.716 BinA1             
       7 7          A1                            1.86  BinA1             
       8 8          A1                            2.72  BinA1             
       9 9          A1                            1.27  BinA1             
      10 10         A1                            0.578 BinA1             
      # i 190 more rows
      # i 2 more variables: response_value <fct>, group <fct>
      
      $quantile_type
      [1] 7
      
      $param_as_cols
      [1] TRUE
      
      $fig_size
      [1] 200
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds
      # A tibble: 200 x 6
         subject_id predictor_parameter predictor_value response_parameter
         <fct>      <fct>                         <dbl> <fct>             
       1 1          A1                            1.57  BinA1             
       2 2          A1                            1.37  BinA1             
       3 3          A1                            0.575 BinA1             
       4 4          A1                            1.95  BinA1             
       5 5          A1                            0.611 BinA1             
       6 6          A1                            0.716 BinA1             
       7 7          A1                            1.86  BinA1             
       8 8          A1                            2.72  BinA1             
       9 9          A1                            1.27  BinA1             
      10 10         A1                            0.578 BinA1             
      # i 190 more rows
      # i 2 more variables: response_value <fct>, group <fct>
      
      $param_as_cols
      [1] TRUE
      
      $fig_size
      [1] 200
      
      $x_metrics_col
      [1] "norm_rank"
      
      $compute_metric_fn
      function (predictor, response) 
      {
          cds <- dplyr::ungroup(tidyr::pivot_longer(dplyr::mutate(tidyr::pivot_wider(dplyr::rename(dplyr::select(as.data.frame(precrec::evalmod(scores = as.numeric(predictor), 
              labels = as.character(response), mode = "basic")), -.data[["dsid"]], 
              -.data[["modname"]]), norm_rank = .data[["x"]]), values_from = "y", 
              names_from = "type"), norm_score = {
              val <- .data[["score"]]
              min_val <- min(val, na.rm = TRUE)
              max_val <- max(val, na.rm = TRUE)
              (val - min_val)/(max_val - min_val)
          }), cols = -dplyr::all_of(c("norm_rank", "score", "norm_score")), 
              names_to = "type", values_to = "y"))
          limits <- list(accuracy = c(0, 1), label = c(-1, 1), error = c(0, 
              1), specificity = c(0, 1), sensitivity = c(0, 1), precision = c(0, 
              1), mcc = c(-1, 1), fscore = c(0, 1))
          structure(cds, limits = limits)
      }
      <bytecode: 0x558502d1aca8>
      <environment: namespace:dv.explorer.parameter>
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds
      # A tibble: 12 x 8
         predictor_parameter response_parameter group     auc levels    direction
         <fct>               <fct>              <fct>   <dbl> <list>    <chr>    
       1 A1                  BinA1              ARM A   0.549 <chr [2]> >        
       2 A1                  BinA1              ARM B   0.647 <chr [2]> >        
       3 A1                  BinA1              PLACEBO 0.577 <chr [2]> >        
       4 B1                  BinA1              ARM A   0.477 <chr [2]> >        
       5 B1                  BinA1              ARM B   0.542 <chr [2]> >        
       6 B1                  BinA1              PLACEBO 0.571 <chr [2]> >        
       7 A2                  BinA1              ARM A   0.678 <chr [2]> <        
       8 A2                  BinA1              ARM B   0.462 <chr [2]> >        
       9 A2                  BinA1              PLACEBO 0.661 <chr [2]> >        
      10 A3                  BinA1              ARM A   0.525 <chr [2]> <        
      11 A3                  BinA1              ARM B   0.424 <chr [2]> <        
      12 A3                  BinA1              PLACEBO 0.583 <chr [2]> <        
      # i 2 more variables: lower_CI_auc <dbl>, upper_CI_auc <dbl>
      
      $fig_size
      [1] 200
      
      $sort_alph
      [1] FALSE
      

---

    Code
      shiny::isolate(exported[[uo]]())
    Output
      $ds_list
      $ds_list$roc_curve
      # A tibble: 206 x 9
         predictor_parameter response_parameter group   sensitivity specificity
         <fct>               <fct>              <fct>         <dbl>       <dbl>
       1 A1                  BinA1              ARM A        0                1
       2 A1                  BinA1              ARM B        0                1
       3 A1                  BinA1              PLACEBO      0                1
       4 A2                  BinA1              ARM A        0                1
       5 A2                  BinA1              ARM B        0                1
       6 A2                  BinA1              PLACEBO      0                1
       7 A1                  BinA1              ARM B        0.0588           1
       8 A1                  BinA1              ARM A        0.0625           1
       9 A1                  BinA1              PLACEBO      0.0833           1
      10 A2                  BinA1              PLACEBO      0.0833           1
      # i 196 more rows
      # i 4 more variables: threshold <dbl>, auc <list>, levels <list>,
      #   direction <chr>
      
      $ds_list$roc_ci
      # A tibble: 12 x 10
         predictor_parameter response_parameter group   ci_specificity
         <fct>               <fct>              <fct>            <dbl>
       1 A1                  BinA1              ARM A            0.259
       2 A1                  BinA1              ARM A            0.519
       3 A1                  BinA1              ARM B            0.286
       4 A1                  BinA1              ARM B            0.5  
       5 A1                  BinA1              PLACEBO          0.286
       6 A1                  BinA1              PLACEBO          0.5  
       7 A2                  BinA1              ARM A            0.259
       8 A2                  BinA1              ARM A            0.519
       9 A2                  BinA1              ARM B            0.286
      10 A2                  BinA1              ARM B            0.5  
      11 A2                  BinA1              PLACEBO          0.286
      12 A2                  BinA1              PLACEBO          0.5  
      # i 6 more variables: ci_lower_specificity <dbl>, ci_upper_specificity <dbl>,
      #   ci_sensitivity <dbl>, ci_lower_sensitivity <dbl>,
      #   ci_upper_sensitivity <dbl>, threshold <dbl>
      
      $ds_list$roc_optimal_cut
      # A tibble: 6 x 11
        predictor_parameter response_parameter group   optimal_cut_title
        <fct>               <fct>              <fct>   <chr>            
      1 A1                  BinA1              ARM A   Youden Index     
      2 A1                  BinA1              ARM B   Youden Index     
      3 A1                  BinA1              PLACEBO Youden Index     
      4 A2                  BinA1              ARM A   Youden Index     
      5 A2                  BinA1              ARM B   Youden Index     
      6 A2                  BinA1              PLACEBO Youden Index     
      # i 7 more variables: optimal_cut_sensitivity <dbl>,
      #   optimal_cut_specificity <dbl>, optimal_cut_threshold <dbl>,
      #   optimal_cut_upper_specificity <dbl>, optimal_cut_lower_specificity <dbl>,
      #   optimal_cut_upper_sensitivity <dbl>, optimal_cut_lower_sensitivity <dbl>
      
      
      $sort_alph
      [1] FALSE
      

