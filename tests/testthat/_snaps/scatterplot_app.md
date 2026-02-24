# tables are included__spec_ids{scatterplot_plot_module$composition;scatterplot_plot_module$data_listing;scatterplot_plot_module$cor_reg_table}

    Code
      shiny::isolate(exported_test_values[[SP$ID$TABLE_LISTING]]$render())[["x"]][[
        "data"]]
    Output
            subject_id x_value y_value main_group color_group
      7   7          7     337     507          B           F
      8   8          8     338     508          A           H
      9   9          9     339     509          A           E
      10 10         10     340     510          B           G
      11 11         11     341     511          B           F
      12 12         12     342     512          B           E

---

    Code
      shiny::isolate(exported_test_values[[SP$ID$TABLE_CORRELATION]]$render())[["x"]][[
        "data"]]
    Condition
      Warning in `summary.lm()`:
      essentially perfect fit: summary may be unreliable
    Output
                                        method estimate statistic      p.value
      1 1 Pearson's product-moment correlation        1       Inf 0.000000e+00
      2 2       Kendall's rank correlation tau        1  6.164414 7.074463e-10
      3 3      Spearman's rank correlation rho        1  0.000000 0.000000e+00
        parameter conf.low conf.high alternative
      1        18        1         1   two.sided
      2        NA       NA        NA   two.sided
      3        NA       NA        NA   two.sided

---

    Code
      shiny::isolate(exported_test_values[[SP$ID$TABLE_REGRESSION]]$render())[["x"]][[
        "data"]]
    Output
                 term estimate    std.error    statistic       p.value
      1 1 (Intercept)      170 9.306698e-13 1.826642e+14 7.177411e-247
      2 2     x_value        1 2.732853e-15 3.659180e+14 2.659619e-252

