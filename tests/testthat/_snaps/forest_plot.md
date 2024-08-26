# Generates proper SVG

    Code
      svg
    Output
      <svg version="1.1" viewBox="-1 0 2 5.33333333333333" height="100%" width="100%" style="overflow: visible"> <line x1="0" y1="0" x2="0" y2="4" style="stroke:rgb(0,0,0);stroke-opacity:0.3;stroke-width:0.0266666666666667"/> <line x1="-1" y1="4" x2="1" y2="4" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.0533333333333333"/> <line x1="-1" y1="4" x2="-1" y2="4.22222222222222" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.0533333333333333" stroke-linecap="round"/>
             <text x="-1" y="4.22222222222222" dy=0.222222222222222 text-anchor="middle" dominant-baseline="hanging" font-size=0.444444444444444>-1</text>
      <line x1="-0.5" y1="4" x2="-0.5" y2="4.22222222222222" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.0533333333333333" stroke-linecap="round"/>
             <text x="-0.5" y="4.22222222222222" dy=0.222222222222222 text-anchor="middle" dominant-baseline="hanging" font-size=0.444444444444444>-0.5</text>
      <line x1="0" y1="4" x2="0" y2="4.22222222222222" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.0533333333333333" stroke-linecap="round"/>
             <text x="0" y="4.22222222222222" dy=0.222222222222222 text-anchor="middle" dominant-baseline="hanging" font-size=0.444444444444444>0</text>
      <line x1="0.5" y1="4" x2="0.5" y2="4.22222222222222" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.0533333333333333" stroke-linecap="round"/>
             <text x="0.5" y="4.22222222222222" dy=0.222222222222222 text-anchor="middle" dominant-baseline="hanging" font-size=0.444444444444444>0.5</text>
      <line x1="1" y1="4" x2="1" y2="4.22222222222222" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.0533333333333333" stroke-linecap="round"/>
             <text x="1" y="4.22222222222222" dy=0.222222222222222 text-anchor="middle" dominant-baseline="hanging" font-size=0.444444444444444>1</text> <line x1="0" y1="0.666666666666667" x2="1" y2="0.666666666666667" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <line x1="0" y1="0.533333333333333" x2="0" y2="0.8" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <!-- right marker -->
               <line x1="0.96" y1="0.533333333333333" x2="1" y2="0.666666666666667"  style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <line x1="1" y1="0.666666666666667" x2="0.96" y2="0.8" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <rect x="0.886666666666667" y="0.553333333333333" width="0.226666666666667" height="0.226666666666667" style="fill:rgb(65,105,225)" />
               
      <line x1="1" y1="2" x2="1" y2="2" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <line x1="1" y1="1.86666666666667" x2="1" y2="2.13333333333333" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <!-- right marker -->
               <line x1="0.96" y1="1.86666666666667" x2="1" y2="2"  style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <line x1="1" y1="2" x2="0.96" y2="2.13333333333333" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <rect x="1.88666666666667" y="1.88666666666667" width="0.226666666666667" height="0.226666666666667" style="fill:rgb(65,105,225)" />
               
      <line x1="2" y1="3.33333333333333" x2="1" y2="3.33333333333333" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <line x1="2" y1="3.2" x2="2" y2="3.46666666666667" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <!-- right marker -->
               <line x1="0.96" y1="3.2" x2="1" y2="3.33333333333333"  style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <line x1="1" y1="3.33333333333333" x2="0.96" y2="3.46666666666667" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:0.04"/>
               <rect x="2.88666666666667" y="3.22" width="0.226666666666667" height="0.226666666666667" style="fill:rgb(65,105,225)" />
                </svg>

# Generates proper result table

    Code
      table
    Output
        category parameter N result CI_lower_limit CI_upper_limit p_value warning
      1    cat_A   param_A 4      1              1              1       0      NA

---

    Code
      table
    Output
        category parameter N result CI_lower_limit CI_upper_limit p_value
      1    cat_A   param_A 3     NA             NA             NA      NA
                               warning
      1 the standard deviation is zero

