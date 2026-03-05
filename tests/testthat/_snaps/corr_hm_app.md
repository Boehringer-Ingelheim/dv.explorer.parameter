# correlation chart is included according to selection__spec_ids{corr_hm_module$correlation_chart;corr_hm_module$composition}

    Code
      chart_args
    Output
      $ds
                       x                y         z p-value (2-sided) 95% CI (min)
      1 PARAM22 - VISIT2 PARAM22 - VISIT2 1.0000000                NA           NA
      2 PARAM22 - VISIT2 PARAM23 - VISIT2 0.4204741        0.06489441  -0.02708664
      3 PARAM23 - VISIT2 PARAM22 - VISIT2 0.4204741        0.06489441  -0.02708664
      4 PARAM23 - VISIT2 PARAM23 - VISIT2 1.0000000                NA           NA
        95% CI (max)  N label
      1           NA NA      
      2    0.7276096 20  0.42
      3    0.7276096 20      
      4           NA NA      
      
      $x_desc
      [1] "S"
      
      $y_desc
      [1] "W"
      
      $palette
      #053061 #2166AC #4393C3 #92C5DE #D1E5F0 #F7F7F7 #FDDBC7 #F4A582 #D6604D #B2182B 
         -1.0    -0.8    -0.6    -0.4    -0.2     0.0     0.2     0.4     0.6     0.8 
      #67001F 
          1.0 
      

# table is included according to selection__spec_ids{corr_hm_module$correlation_chart;corr_hm_module$composition}

    Code
      listing_args
    Output
      $ds
          subject_id category        parameter  visit     value
      321          1  PARCAT2 PARAM22 - VISIT2 VISIT2 49.549953
      322          2  PARCAT2 PARAM22 - VISIT2 VISIT2 85.824596
      323          3  PARCAT2 PARAM22 - VISIT2 VISIT2 73.226485
      324          4  PARCAT2 PARAM22 - VISIT2 VISIT2 97.442849
      325          5  PARCAT2 PARAM22 - VISIT2 VISIT2 10.005491
      326          6  PARCAT2 PARAM22 - VISIT2 VISIT2 83.259084
      327          7  PARCAT2 PARAM22 - VISIT2 VISIT2 45.055418
      328          8  PARCAT2 PARAM22 - VISIT2 VISIT2 85.045914
      329          9  PARCAT2 PARAM22 - VISIT2 VISIT2 56.975154
      330         10  PARCAT2 PARAM22 - VISIT2 VISIT2 96.154251
      331         11  PARCAT2 PARAM22 - VISIT2 VISIT2 95.475073
      332         12  PARCAT2 PARAM22 - VISIT2 VISIT2 28.377951
      333         13  PARCAT2 PARAM22 - VISIT2 VISIT2 73.960650
      334         14  PARCAT2 PARAM22 - VISIT2 VISIT2  7.074258
      335         15  PARCAT2 PARAM22 - VISIT2 VISIT2 90.011955
      336         16  PARCAT2 PARAM22 - VISIT2 VISIT2 13.342057
      337         17  PARCAT2 PARAM22 - VISIT2 VISIT2 55.588608
      338         18  PARCAT2 PARAM22 - VISIT2 VISIT2 60.040803
      339         19  PARCAT2 PARAM22 - VISIT2 VISIT2 13.296104
      340         20  PARCAT2 PARAM22 - VISIT2 VISIT2 50.931234
      561          1  PARCAT2 PARAM23 - VISIT2 VISIT2 17.345205
      562          2  PARCAT2 PARAM23 - VISIT2 VISIT2 49.320897
      563          3  PARCAT2 PARAM23 - VISIT2 VISIT2 73.718891
      564          4  PARCAT2 PARAM23 - VISIT2 VISIT2 51.100102
      565          5  PARCAT2 PARAM23 - VISIT2 VISIT2 47.508692
      566          6  PARCAT2 PARAM23 - VISIT2 VISIT2 58.789994
      567          7  PARCAT2 PARAM23 - VISIT2 VISIT2 57.253738
      568          8  PARCAT2 PARAM23 - VISIT2 VISIT2 65.491774
      569          9  PARCAT2 PARAM23 - VISIT2 VISIT2 86.512556
      570         10  PARCAT2 PARAM23 - VISIT2 VISIT2 39.684638
      571         11  PARCAT2 PARAM23 - VISIT2 VISIT2 96.011616
      572         12  PARCAT2 PARAM23 - VISIT2 VISIT2 38.087726
      573         13  PARCAT2 PARAM23 - VISIT2 VISIT2 17.008828
      574         14  PARCAT2 PARAM23 - VISIT2 VISIT2 23.160488
      575         15  PARCAT2 PARAM23 - VISIT2 VISIT2 94.992021
      576         16  PARCAT2 PARAM23 - VISIT2 VISIT2  8.350816
      577         17  PARCAT2 PARAM23 - VISIT2 VISIT2 19.304402
      578         18  PARCAT2 PARAM23 - VISIT2 VISIT2  7.469530
      579         19  PARCAT2 PARAM23 - VISIT2 VISIT2 60.501601
      580         20  PARCAT2 PARAM23 - VISIT2 VISIT2 21.584290
      
      $corr_data
                       x                y         z p-value (2-sided) 95% CI (min)
      1 PARAM22 - VISIT2 PARAM22 - VISIT2 1.0000000                NA           NA
      2 PARAM22 - VISIT2 PARAM23 - VISIT2 0.4204741        0.06489441  -0.02708664
      3 PARAM23 - VISIT2 PARAM22 - VISIT2 0.4204741        0.06489441  -0.02708664
      4 PARAM23 - VISIT2 PARAM23 - VISIT2 1.0000000                NA           NA
        95% CI (max)  N label
      1           NA NA      
      2    0.7276096 20  0.42
      3    0.7276096 20      
      4           NA NA      
      
      $method
      [1] "pearson"
      

# scatter chart appears according to click__spec_ids{corr_hm_module$scatter_chart;corr_hm_module$composition}

    Code
      scatter_args
    Output
      $ds
          subject_id category        parameter  visit     value
      321          1  PARCAT2 PARAM22 - VISIT2 VISIT2 49.549953
      322          2  PARCAT2 PARAM22 - VISIT2 VISIT2 85.824596
      323          3  PARCAT2 PARAM22 - VISIT2 VISIT2 73.226485
      324          4  PARCAT2 PARAM22 - VISIT2 VISIT2 97.442849
      325          5  PARCAT2 PARAM22 - VISIT2 VISIT2 10.005491
      326          6  PARCAT2 PARAM22 - VISIT2 VISIT2 83.259084
      327          7  PARCAT2 PARAM22 - VISIT2 VISIT2 45.055418
      328          8  PARCAT2 PARAM22 - VISIT2 VISIT2 85.045914
      329          9  PARCAT2 PARAM22 - VISIT2 VISIT2 56.975154
      330         10  PARCAT2 PARAM22 - VISIT2 VISIT2 96.154251
      331         11  PARCAT2 PARAM22 - VISIT2 VISIT2 95.475073
      332         12  PARCAT2 PARAM22 - VISIT2 VISIT2 28.377951
      333         13  PARCAT2 PARAM22 - VISIT2 VISIT2 73.960650
      334         14  PARCAT2 PARAM22 - VISIT2 VISIT2  7.074258
      335         15  PARCAT2 PARAM22 - VISIT2 VISIT2 90.011955
      336         16  PARCAT2 PARAM22 - VISIT2 VISIT2 13.342057
      337         17  PARCAT2 PARAM22 - VISIT2 VISIT2 55.588608
      338         18  PARCAT2 PARAM22 - VISIT2 VISIT2 60.040803
      339         19  PARCAT2 PARAM22 - VISIT2 VISIT2 13.296104
      340         20  PARCAT2 PARAM22 - VISIT2 VISIT2 50.931234
      561          1  PARCAT2 PARAM23 - VISIT2 VISIT2 17.345205
      562          2  PARCAT2 PARAM23 - VISIT2 VISIT2 49.320897
      563          3  PARCAT2 PARAM23 - VISIT2 VISIT2 73.718891
      564          4  PARCAT2 PARAM23 - VISIT2 VISIT2 51.100102
      565          5  PARCAT2 PARAM23 - VISIT2 VISIT2 47.508692
      566          6  PARCAT2 PARAM23 - VISIT2 VISIT2 58.789994
      567          7  PARCAT2 PARAM23 - VISIT2 VISIT2 57.253738
      568          8  PARCAT2 PARAM23 - VISIT2 VISIT2 65.491774
      569          9  PARCAT2 PARAM23 - VISIT2 VISIT2 86.512556
      570         10  PARCAT2 PARAM23 - VISIT2 VISIT2 39.684638
      571         11  PARCAT2 PARAM23 - VISIT2 VISIT2 96.011616
      572         12  PARCAT2 PARAM23 - VISIT2 VISIT2 38.087726
      573         13  PARCAT2 PARAM23 - VISIT2 VISIT2 17.008828
      574         14  PARCAT2 PARAM23 - VISIT2 VISIT2 23.160488
      575         15  PARCAT2 PARAM23 - VISIT2 VISIT2 94.992021
      576         16  PARCAT2 PARAM23 - VISIT2 VISIT2  8.350816
      577         17  PARCAT2 PARAM23 - VISIT2 VISIT2 19.304402
      578         18  PARCAT2 PARAM23 - VISIT2 VISIT2  7.469530
      579         19  PARCAT2 PARAM23 - VISIT2 VISIT2 60.501601
      580         20  PARCAT2 PARAM23 - VISIT2 VISIT2 21.584290
      
      $click
      $click$x
      [1] "PARAM22 - VISIT2"
      
      $click$y
      [1] "PARAM23 - VISIT2"
      
      

