# lineplot chart is included according to selection__spec_ids{lineplot_module$composition;lineplot_module$lineplot_chart;lineplot_module$grouping;lineplot_module$summarizing}

    Code
      chart_arguments
    Output
      $ds
      # A tibble: 16 x 5
      # Groups:   visit, main_group, sub_group [8]
         visit main_group sub_group parameter value
         <fct> <chr>      <chr>     <fct>     <dbl>
       1 1     A          A         PARAM22    317.
       2 1     A          A         PARAM23    557.
       3 1     B          B         PARAM22    323.
       4 1     B          B         PARAM23    563.
       5 1     C          C         PARAM22    322.
       6 1     C          C         PARAM23    562.
       7 1     D          D         PARAM22    326.
       8 1     D          D         PARAM23    566.
       9 9     A          A         PARAM22    357.
      10 9     A          A         PARAM23    597.
      11 9     B          B         PARAM22    363.
      12 9     B          B         PARAM23    603.
      13 9     C          C         PARAM22    362.
      14 9     C          C         PARAM23    602.
      15 9     D          D         PARAM22    366.
      16 9     D          D         PARAM23    606.
      
      $ref_line_data
      list()
      
      $last_selection
      $last_selection$points
      data frame with 0 columns and 0 rows
      
      $last_selection$visit_col
      NULL
      
      
      $alpha
      [1] 0.5
      
      $visit_col
      [1] "VISIT2"
      
      $y_axis_projection
      [1] "Linear"
      

# listing/count tables appears according to click__spec_ids{lineplot_module$composition;lineplot_module$subject_level_listing;lineplot_module$summary_listing;lineplot_module$data_count}

    Code
      subject_listing_contents
    Output
      $col_names
      [1] "Label of VISIT2" "Label of CAT2"   "Label of CAT2.1" "Label of PARAM" 
      [5] "Label of SUBJID" "Label of PARCAT" "Label of VALUE2"
      
      $contents
           [,1] [,2] [,3] [,4]      [,5] [,6]      [,7] 
      [1,] "9"  "B"  "B"  "PARAM23" "7"  "PARCAT2" "597"
      [2,] "9"  "B"  "B"  "PARAM23" "10" "PARCAT2" "600"
      [3,] "9"  "B"  "B"  "PARAM23" "11" "PARCAT2" "601"
      [4,] "9"  "B"  "B"  "PARAM23" "12" "PARCAT2" "602"
      [5,] "9"  "B"  "B"  "PARAM23" "19" "PARCAT2" "609"
      [6,] "9"  "B"  "B"  "PARAM23" "20" "PARCAT2" "610"
      

---

    Code
      summary_listing_contents
    Output
      $col_names
      [1] "visit"          "main_group"     "sub_group"      "parameter"     
      [5] "value"          "whisker_bottom" "whisker_top"   
      
      $contents
           [,1] [,2] [,3] [,4]      [,5]       [,6]       [,7]      
      [1,] "9"  "B"  "B"  "PARAM23" "603.1667" "597.9737" "608.3596"
      

---

    Code
      count_listing_contents
    Output
      $col_names
      [1] "Label of PARCAT" "Label of PARAM"  "Label of CAT2"   "Label of CAT2.1"
      [5] "1"               "9"              
      
      $contents
           [,1]      [,2]      [,3] [,4] [,5] [,6]
      [1,] "PARCAT2" "PARAM22" "A"  "A"  "9"  "9" 
      [2,] "PARCAT2" "PARAM22" "B"  "B"  "6"  "6" 
      [3,] "PARCAT2" "PARAM22" "C"  "C"  "3"  "3" 
      [4,] "PARCAT2" "PARAM22" "D"  "D"  "2"  "2" 
      [5,] "PARCAT2" "PARAM23" "A"  "A"  "9"  "9" 
      [6,] "PARCAT2" "PARAM23" "B"  "B"  "6"  "6" 
      [7,] "PARCAT2" "PARAM23" "C"  "C"  "3"  "3" 
      [8,] "PARCAT2" "PARAM23" "D"  "D"  "2"  "2" 
      

# listing/count table appears according to brush__spec_ids{lineplot_module$composition;lineplot_module$subject_level_listing;lineplot_module$summary_listing;lineplot_module$data_count}

    Code
      subject_listing_contents
    Output
      $col_names
      [1] "Label of VISIT2" "Label of CAT2"   "Label of CAT2.1" "Label of PARAM" 
      [5] "Label of SUBJID" "Label of PARCAT" "Label of VALUE2"
      
      $contents
            [,1] [,2] [,3] [,4]      [,5] [,6]      [,7] 
       [1,] "9"  "B"  "B"  "PARAM22" "7"  "PARCAT2" "357"
       [2,] "9"  "B"  "B"  "PARAM22" "10" "PARCAT2" "360"
       [3,] "9"  "B"  "B"  "PARAM22" "11" "PARCAT2" "361"
       [4,] "9"  "B"  "B"  "PARAM22" "12" "PARCAT2" "362"
       [5,] "9"  "B"  "B"  "PARAM22" "19" "PARCAT2" "369"
       [6,] "9"  "B"  "B"  "PARAM22" "20" "PARCAT2" "370"
       [7,] "9"  "C"  "C"  "PARAM22" "2"  "PARCAT2" "352"
       [8,] "9"  "C"  "C"  "PARAM22" "15" "PARCAT2" "365"
       [9,] "9"  "C"  "C"  "PARAM22" "18" "PARCAT2" "368"
      

---

    Code
      summary_listing_contents
    Output
      $col_names
      [1] "visit"          "main_group"     "sub_group"      "parameter"     
      [5] "value"          "whisker_bottom" "whisker_top"   
      
      $contents
           [,1] [,2] [,3] [,4]      [,5]       [,6]       [,7]      
      [1,] "9"  "B"  "B"  "PARAM22" "363.1667" "357.9737" "368.3596"
      [2,] "9"  "C"  "C"  "PARAM22" "361.6667" "353.1618" "370.1716"
      

---

    Code
      count_listing_contents
    Output
      $col_names
      [1] "Label of PARCAT" "Label of PARAM"  "Label of CAT2"   "Label of CAT2.1"
      [5] "1"               "9"              
      
      $contents
           [,1]      [,2]      [,3] [,4] [,5] [,6]
      [1,] "PARCAT2" "PARAM22" "A"  "A"  "9"  "9" 
      [2,] "PARCAT2" "PARAM22" "B"  "B"  "6"  "6" 
      [3,] "PARCAT2" "PARAM22" "C"  "C"  "3"  "3" 
      [4,] "PARCAT2" "PARAM22" "D"  "D"  "2"  "2" 
      [5,] "PARCAT2" "PARAM23" "A"  "A"  "9"  "9" 
      [6,] "PARCAT2" "PARAM23" "B"  "B"  "6"  "6" 
      [7,] "PARCAT2" "PARAM23" "C"  "C"  "3"  "3" 
      [8,] "PARCAT2" "PARAM23" "D"  "D"  "2"  "2" 
      

