# function is applied per parameter and group__spec_ids{roc$outputs$histogram$facets;roc$outputs$histogram$axis;roc$outputs$histogram$plot}

    Code
      tibble::tibble(!!CNT_ROC$SBJ := factor(c("S1", "S1", "S1", "S1", "S1", "S1",
        "S1", "S1", "S1", "S1", "S1", "S1")), !!CNT_ROC$PPAR := factor(c("P1", "P1",
        "P1", "P1", "P1", "P1", "P1", "P1", "P3", "P3", "P3", "P3")), !!CNT_ROC$GRP :=
        factor(c("G1", "G1", "G1", "G1", "G2", "G2", "G2", "G2", "G1", "G1", "G1",
          "G1")), !!CNT_ROC$PVAL := c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
      !!CNT_ROC$RVAL := factor(c("A", "B", "A", "B", "A", "B", "A", "B", "A", "B",
        "A", "B")), !!CNT_ROC$RPAR := factor("R1")) %>% get_histo_data()
    Output
      # A tibble: 22 x 6
         predictor_parameter group response_value bin_start bin_end bin_count
         <fct>               <fct> <fct>              <dbl>   <dbl>     <int>
       1 P1                  G1    A                      0       2         1
       2 P1                  G1    A                      2       4         1
       3 P1                  G1    A                      4       6         0
       4 P1                  G1    A                      6       8         0
       5 P1                  G1    B                      0       2         1
       6 P1                  G1    B                      2       4         1
       7 P1                  G1    B                      4       6         0
       8 P1                  G1    B                      6       8         0
       9 P1                  G2    A                      0       2         0
      10 P1                  G2    A                      2       4         0
      # i 12 more rows

# function is applied per parameter. No grouping__spec_ids{roc$outputs$histogram$facets;roc$outputs$histogram$axis;roc$outputs$histogram$plot}

    Code
      tibble::tibble(!!CNT_ROC$SBJ := factor(c("S1", "S1", "S1", "S1", "S1", "S1",
        "S1", "S1", "S1", "S1", "S1", "S1")), !!CNT_ROC$PPAR := factor(c("P1", "P1",
        "P1", "P1", "P1", "P1", "P1", "P1", "P3", "P3", "P3", "P3")), !!CNT_ROC$
      PVAL := c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), !!CNT_ROC$RVAL := factor(c(
        "A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B")), !!CNT_ROC$
      RPAR := factor("R1")) %>% get_histo_data()
    Output
      # A tibble: 14 x 5
         predictor_parameter response_value bin_start bin_end bin_count
         <fct>               <fct>              <dbl>   <dbl>     <int>
       1 P1                  A                      0       2         1
       2 P1                  A                      2       4         1
       3 P1                  A                      4       6         1
       4 P1                  A                      6       8         1
       5 P1                  B                      0       2         1
       6 P1                  B                      2       4         1
       7 P1                  B                      4       6         1
       8 P1                  B                      6       8         1
       9 P3                  A                      9      10         1
      10 P3                  A                     10      11         1
      11 P3                  A                     11      12         0
      12 P3                  B                      9      10         1
      13 P3                  B                     10      11         0
      14 P3                  B                     11      12         1

