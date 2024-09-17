# heatmap_d3 should show a heatmap with all the components when correct input is passed (continuous Z) (snapshot)

    Code
      app$get_js(SVG_JS_QUERY)
    Output
      [1] "<svg width=\"947\" height=\"400\" style=\"background: rgb(255, 255, 255); fill: rgb(0, 0, 0); color: rgb(0, 0, 0);\"><style type=\"text/css\"></style><g id=\"mod-svg\" transform=\"translate(45,10)\"><g id=\"mod-tile\"><rect x=\"41.52380952380952\" y=\"1\" width=\"364.7142857142857\" height=\"167\" style=\"fill: rgb(255, 0, 0);\"></rect><rect x=\"446.76190476190476\" y=\"1\" width=\"364.7142857142857\" height=\"167\" style=\"fill: rgb(170, 0, 85);\"></rect><rect x=\"41.52380952380952\" y=\"168\" width=\"364.7142857142857\" height=\"167\" style=\"fill: rgb(85, 0, 170);\"></rect><rect x=\"446.76190476190476\" y=\"168\" width=\"364.7142857142857\" height=\"167\" style=\"fill: rgb(0, 0, 255);\"></rect></g><g id=\"mod-label\"><text text-anchor=\"start\" font-size=\"20\" transform=\"translate(369.76666666666665,168)rotate(-90)\" style=\"\">1</text><text text-anchor=\"start\" font-size=\"20\" transform=\"translate(775.004761904762,168)rotate(-90)\" style=\"\">2</text><text text-anchor=\"start\" font-size=\"20\" transform=\"translate(369.76666666666665,335)rotate(-90)\" style=\"\">3</text><text text-anchor=\"start\" font-size=\"20\" transform=\"translate(775.004761904762,335)rotate(-90)\" style=\"\">4</text></g><g id=\"mod-x_axis\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"middle\" transform=\"translate(0, 335)\"><path class=\"domain\" stroke=\"currentColor\" d=\"M1.5,6V0.5H852.5V6\"></path><g class=\"tick\" opacity=\"1\" transform=\"translate(223.88095238095238,0)\"><line stroke=\"currentColor\" y2=\"6\"></line><text fill=\"currentColor\" y=\"0\" dy=\".35em\" x=\"9\" transform=\"rotate(90)\" style=\"text-anchor: start;\">x_A</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(629.1190476190476,0)\"><line stroke=\"currentColor\" y2=\"6\"></line><text fill=\"currentColor\" y=\"0\" dy=\".35em\" x=\"9\" transform=\"rotate(90)\" style=\"text-anchor: start;\">x_B</text></g><g id=\"mod-x_title\"><text fill=\"currentColor\" text-anchor=\"middle\" font-size=\"1.25em\" transform=\"translate(426.5, 42)\">x_title</text></g></g><g id=\"mod-y_axis\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"end\"><path class=\"domain\" stroke=\"currentColor\" d=\"M-6,1.5H0.5V335.5H-6\"></path><g class=\"tick\" opacity=\"1\" transform=\"translate(0,84.5)\"><line stroke=\"currentColor\" x2=\"-6\"></line><text fill=\"currentColor\" x=\"-9\" dy=\"0.32em\">y_A</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,251.5)\"><line stroke=\"currentColor\" x2=\"-6\"></line><text fill=\"currentColor\" x=\"-9\" dy=\"0.32em\">y_B</text></g><g id=\"mod-y_title\"><text fill=\"currentColor\" text-anchor=\"middle\" font-size=\"1.25em\" transform=\"translate(-37, 168)rotate(-90)\">y_title</text></g></g><g id=\"mod-z_axis\"><g transform=\"translate(847,0)\"><svg width=\"20\" height=\"335\" viewBox=\"0,0,20,335\" style=\"overflow: visible; display: block;\"><image x=\"5\" y=\"5\" width=\"10\" height=\"325\" preserveAspectRatio=\"none\" xlink:href=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAEACAYAAAByPhyYAAAAAXNSR0IArs4c6QAAAx9JREFUOE8FwQMAIAQAALFl27Zt99m2bdu2bdu2bdu2bV0bykD+y8D+zSD+yaD+zmD+yuD+zBD+yJB+z1B+y9B+zTB+ybB+znB+yvB+zAh+yIi+z0i+y8i+zSi+yai+zmi+yui+zBi+yJg+z1g+y9g+zTg+ybg+zng+yvg+zAQ+yITez0Tey8TezSTeyaTezmTeyuTezBTeyJRez1Rey9RezTReybReznReyvRezAxeyIyez0yey8yezSyeyayezmyeyuyezByeyJwez1wey9wezTweybweznweyvwezAAPZAH3Z0H3ZSH3ZmH3ZBF3Z1F3ZTF3ZnF3ZAm3Z0m3ZSm3Zmm3ZBk3Z1k3ZTk3Znk3ZAXXZ0XXZSXXZmXXZBVXZ1VXZTVXZnVXZA2XZ02XZS2XZm2XZB0XZ10XZT0XZn0XZAPnZ0PnZSPnZmPnZBNnZ1NnZTNnZnNnZAunZ0unZSunZmunZBsnZ1snZTsnZnsnZAfHZ0fHZSfHZmfHZBdHZ1dHZTdHZndHZA+HZ0+HZS+HZm+HZB8HZ18HZT8HZn8H5AD750D75SD75mD75BB751B75TB75nB75Ai750i75Si75mi75Bg751g75Tg75ng75ATb50Tb5STb5mTb5BRb51Rb5TRb5nRb5Ayb50yb5Syb5myb5Bwb51wb5Twb5nwb5ALr50Lr5SLr5mLr5BJr51Jr5TJr5nJr5Aqr50qr5Sqr5mqr5Bor51or5Tor5nor5AbL50bL5SbL5mbL5BZL51ZL5TZL5nZL5A6L506L5S6L5m6L5B4L514L5T4L5n4L5AED8qD585D58rB584h58qi585i58rg584Q58qTZ85TZ8rRZ84xZ8qyZ85yZ8rwZ84IZ8qLp85Lp8rJp84pp8qqp85qp8rop84Yp8qbJ85bJ8rZJ845J8q6J856J8r4J84EJ8qHx85Hx8rFx84lx8qmx85mx8rkx84Ux8qXR85XR8rVR841R8q2R852R8r0R84MR8qPh85Ph8rNh84th8quh85uh8rsh84ch8qfB85fB8rdB849B8q+B85+BEv0PUKb+ECPPl/UAAAAASUVORK5CYII=\"></image><g transform=\"translate(20,0)\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"start\"><g class=\"tick\" opacity=\"1\" transform=\"translate(0,330.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">1</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,222.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">2</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,113.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">3</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,5.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">4</text></g><text x=\"-331\" y=\"5\" fill=\"currentColor\" text-anchor=\"start\" font-weight=\"bold\" class=\"title\"></text></g></svg></g></g></g></svg>"

# heatmap_d3 should show a heatmap with all the components when correct input is passed (categorical Z) (snapshot)

    Code
      app$get_js(SVG_JS_QUERY)
    Output
      [1] "<svg width=\"947\" height=\"400\" style=\"background: rgb(255, 255, 255); fill: rgb(0, 0, 0); color: rgb(0, 0, 0);\"><style type=\"text/css\"></style><g id=\"mod-svg\" transform=\"translate(45,10)\"><g id=\"mod-tile\"><rect x=\"78.36363636363637\" y=\"1\" width=\"696.2727272727273\" height=\"167\" style=\"fill: red;\"></rect><rect x=\"78.36363636363637\" y=\"168\" width=\"696.2727272727273\" height=\"167\" style=\"fill: blue;\"></rect></g><g id=\"mod-label\"><text text-anchor=\"start\" font-size=\"20\" transform=\"translate(705.0090909090909,168)rotate(-90)\" style=\"\">l_A</text><text text-anchor=\"start\" font-size=\"20\" transform=\"translate(705.0090909090909,335)rotate(-90)\" style=\"\">l_B</text></g><g id=\"mod-x_axis\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"middle\" transform=\"translate(0, 335)\"><path class=\"domain\" stroke=\"currentColor\" d=\"M1.5,6V0.5H852.5V6\"></path><g class=\"tick\" opacity=\"1\" transform=\"translate(426.5,0)\"><line stroke=\"currentColor\" y2=\"6\"></line><text fill=\"currentColor\" y=\"0\" dy=\".35em\" x=\"9\" transform=\"rotate(90)\" style=\"text-anchor: start;\">x_AAA</text></g><g id=\"mod-x_title\"><text fill=\"currentColor\" text-anchor=\"middle\" font-size=\"1.25em\" transform=\"translate(426.5, 55)\">x_title</text></g></g><g id=\"mod-y_axis\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"end\"><path class=\"domain\" stroke=\"currentColor\" d=\"M-6,1.5H0.5V335.5H-6\"></path><g class=\"tick\" opacity=\"1\" transform=\"translate(0,84.5)\"><line stroke=\"currentColor\" x2=\"-6\"></line><text fill=\"currentColor\" x=\"-9\" dy=\"0.32em\">y_AAA</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,251.5)\"><line stroke=\"currentColor\" x2=\"-6\"></line><text fill=\"currentColor\" x=\"-9\" dy=\"0.32em\">y_BBB</text></g><g id=\"mod-y_title\"><text fill=\"currentColor\" text-anchor=\"middle\" font-size=\"1.25em\" transform=\"translate(-51, 168)rotate(-90)\">y_title</text></g></g><g id=\"mod-z_axis\"><g transform=\"translate(847,0)\"><svg width=\"20\" height=\"335\" viewBox=\"0,0,20,335\" style=\"overflow: visible; display: block;\"><g><rect x=\"5\" y=\"6\" height=\"161\" width=\"10\" fill=\"red\"></rect><rect x=\"5\" y=\"168\" height=\"161\" width=\"10\" fill=\"blue\"></rect></g><g transform=\"translate(20,0)\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"start\"><g class=\"tick\" opacity=\"1\" transform=\"translate(0,87.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">A</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,249.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">B</text></g><text x=\"-331\" y=\"5\" fill=\"currentColor\" text-anchor=\"start\" font-weight=\"bold\" class=\"title\"></text></g></svg></g></g></g></svg>"

# heatmap_d3 should accept colors and NAs in the color column

    Code
      app$get_js(SVG_JS_QUERY)
    Output
      [1] "<svg width=\"947\" height=\"400\" style=\"background: rgb(255, 255, 255); fill: rgb(0, 0, 0); color: rgb(0, 0, 0);\"><style type=\"text/css\"></style><g id=\"mod-svg\" transform=\"translate(45,10)\"><g id=\"mod-tile\"><rect x=\"78.36363636363637\" y=\"1\" width=\"696.2727272727273\" height=\"167\" style=\"fill: orange;\"></rect><rect x=\"78.36363636363637\" y=\"168\" width=\"696.2727272727273\" height=\"167\" style=\"fill: rgb(0, 0, 255);\"></rect></g><g id=\"mod-label\"><text text-anchor=\"start\" font-size=\"20\" transform=\"translate(705.0090909090909,168)rotate(-90)\" style=\"\">1000</text><text text-anchor=\"start\" font-size=\"20\" transform=\"translate(705.0090909090909,335)rotate(-90)\" style=\"\">2000</text></g><g id=\"mod-x_axis\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"middle\" transform=\"translate(0, 335)\"><path class=\"domain\" stroke=\"currentColor\" d=\"M1.5,6V0.5H852.5V6\"></path><g class=\"tick\" opacity=\"1\" transform=\"translate(426.5,0)\"><line stroke=\"currentColor\" y2=\"6\"></line><text fill=\"currentColor\" y=\"0\" dy=\".35em\" x=\"9\" transform=\"rotate(90)\" style=\"text-anchor: start;\">x_AAA</text></g><g id=\"mod-x_title\"><text fill=\"currentColor\" text-anchor=\"middle\" font-size=\"1.25em\" transform=\"translate(426.5, 55)\">x_title</text></g></g><g id=\"mod-y_axis\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"end\"><path class=\"domain\" stroke=\"currentColor\" d=\"M-6,1.5H0.5V335.5H-6\"></path><g class=\"tick\" opacity=\"1\" transform=\"translate(0,84.5)\"><line stroke=\"currentColor\" x2=\"-6\"></line><text fill=\"currentColor\" x=\"-9\" dy=\"0.32em\">y_AAA</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,251.5)\"><line stroke=\"currentColor\" x2=\"-6\"></line><text fill=\"currentColor\" x=\"-9\" dy=\"0.32em\">y_BBB</text></g><g id=\"mod-y_title\"><text fill=\"currentColor\" text-anchor=\"middle\" font-size=\"1.25em\" transform=\"translate(-51, 168)rotate(-90)\">y_title</text></g></g><g id=\"mod-z_axis\"><g transform=\"translate(847,0)\"><svg width=\"20\" height=\"335\" viewBox=\"0,0,20,335\" style=\"overflow: visible; display: block;\"><image x=\"5\" y=\"5\" width=\"10\" height=\"325\" preserveAspectRatio=\"none\" xlink:href=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAEACAYAAAByPhyYAAAAAXNSR0IArs4c6QAAAx9JREFUOE8FwQMAIAQAALFl27Zt99m2bdu2bdu2bdu2bV0bykD+y8D+zSD+yaD+zmD+yuD+zBD+yJB+z1B+y9B+zTB+ybB+znB+yvB+zAh+yIi+z0i+y8i+zSi+yai+zmi+yui+zBi+yJg+z1g+y9g+zTg+ybg+zng+yvg+zAQ+yITez0Tey8TezSTeyaTezmTeyuTezBTeyJRez1Rey9RezTReybReznReyvRezAxeyIyez0yey8yezSyeyayezmyeyuyezByeyJwez1wey9wezTweybweznweyvwezAAPZAH3Z0H3ZSH3ZmH3ZBF3Z1F3ZTF3ZnF3ZAm3Z0m3ZSm3Zmm3ZBk3Z1k3ZTk3Znk3ZAXXZ0XXZSXXZmXXZBVXZ1VXZTVXZnVXZA2XZ02XZS2XZm2XZB0XZ10XZT0XZn0XZAPnZ0PnZSPnZmPnZBNnZ1NnZTNnZnNnZAunZ0unZSunZmunZBsnZ1snZTsnZnsnZAfHZ0fHZSfHZmfHZBdHZ1dHZTdHZndHZA+HZ0+HZS+HZm+HZB8HZ18HZT8HZn8H5AD750D75SD75mD75BB751B75TB75nB75Ai750i75Si75mi75Bg751g75Tg75ng75ATb50Tb5STb5mTb5BRb51Rb5TRb5nRb5Ayb50yb5Syb5myb5Bwb51wb5Twb5nwb5ALr50Lr5SLr5mLr5BJr51Jr5TJr5nJr5Aqr50qr5Sqr5mqr5Bor51or5Tor5nor5AbL50bL5SbL5mbL5BZL51ZL5TZL5nZL5A6L506L5S6L5m6L5B4L514L5T4L5n4L5AED8qD585D58rB584h58qi585i58rg584Q58qTZ85TZ8rRZ84xZ8qyZ85yZ8rwZ84IZ8qLp85Lp8rJp84pp8qqp85qp8rop84Yp8qbJ85bJ8rZJ845J8q6J856J8r4J84EJ8qHx85Hx8rFx84lx8qmx85mx8rkx84Ux8qXR85XR8rVR841R8q2R852R8r0R84MR8qPh85Ph8rNh84th8quh85uh8rsh84ch8qfB85fB8rdB849B8q+B85+BEv0PUKb+ECPPl/UAAAAASUVORK5CYII=\"></image><g transform=\"translate(20,0)\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"start\"><g class=\"tick\" opacity=\"1\" transform=\"translate(0,330.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">1</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,222.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">2</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,113.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">3</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,5.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">4</text></g><text x=\"-331\" y=\"5\" fill=\"currentColor\" text-anchor=\"start\" font-weight=\"bold\" class=\"title\"></text></g></svg></g></g></g></svg>"

# heatmap_d3 should show a heatmap with all the components when two values have the same color in the palette (categorical Z) (snapshot)

    Code
      app$get_js(SVG_JS_QUERY)
    Output
      [1] "<svg width=\"947\" height=\"400\" style=\"background: rgb(255, 255, 255); fill: rgb(0, 0, 0); color: rgb(0, 0, 0);\"><style type=\"text/css\"></style><g id=\"mod-svg\" transform=\"translate(45,10)\"><g id=\"mod-tile\"><rect x=\"78.36363636363637\" y=\"1\" width=\"696.2727272727273\" height=\"167\" style=\"fill: red;\"></rect><rect x=\"78.36363636363637\" y=\"168\" width=\"696.2727272727273\" height=\"167\" style=\"fill: red;\"></rect></g><g id=\"mod-label\"><text text-anchor=\"start\" font-size=\"20\" transform=\"translate(705.0090909090909,168)rotate(-90)\" style=\"\">l_A</text><text text-anchor=\"start\" font-size=\"20\" transform=\"translate(705.0090909090909,335)rotate(-90)\" style=\"\">l_B</text></g><g id=\"mod-x_axis\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"middle\" transform=\"translate(0, 335)\"><path class=\"domain\" stroke=\"currentColor\" d=\"M1.5,6V0.5H852.5V6\"></path><g class=\"tick\" opacity=\"1\" transform=\"translate(426.5,0)\"><line stroke=\"currentColor\" y2=\"6\"></line><text fill=\"currentColor\" y=\"0\" dy=\".35em\" x=\"9\" transform=\"rotate(90)\" style=\"text-anchor: start;\">x_AAA</text></g><g id=\"mod-x_title\"><text fill=\"currentColor\" text-anchor=\"middle\" font-size=\"1.25em\" transform=\"translate(426.5, 55)\">x_title</text></g></g><g id=\"mod-y_axis\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"end\"><path class=\"domain\" stroke=\"currentColor\" d=\"M-6,1.5H0.5V335.5H-6\"></path><g class=\"tick\" opacity=\"1\" transform=\"translate(0,84.5)\"><line stroke=\"currentColor\" x2=\"-6\"></line><text fill=\"currentColor\" x=\"-9\" dy=\"0.32em\">y_AAA</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,251.5)\"><line stroke=\"currentColor\" x2=\"-6\"></line><text fill=\"currentColor\" x=\"-9\" dy=\"0.32em\">y_BBB</text></g><g id=\"mod-y_title\"><text fill=\"currentColor\" text-anchor=\"middle\" font-size=\"1.25em\" transform=\"translate(-51, 168)rotate(-90)\">y_title</text></g></g><g id=\"mod-z_axis\"><g transform=\"translate(847,0)\"><svg width=\"20\" height=\"335\" viewBox=\"0,0,20,335\" style=\"overflow: visible; display: block;\"><g><rect x=\"5\" y=\"6\" height=\"161\" width=\"10\" fill=\"red\"></rect><rect x=\"5\" y=\"168\" height=\"161\" width=\"10\" fill=\"red\"></rect></g><g transform=\"translate(20,0)\" fill=\"none\" font-size=\"10\" font-family=\"sans-serif\" text-anchor=\"start\"><g class=\"tick\" opacity=\"1\" transform=\"translate(0,87.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">A</text></g><g class=\"tick\" opacity=\"1\" transform=\"translate(0,249.5)\"><line stroke=\"currentColor\" x2=\"0\"></line><text fill=\"currentColor\" x=\"3\" dy=\"0.32em\">B</text></g><text x=\"-331\" y=\"5\" fill=\"currentColor\" text-anchor=\"start\" font-weight=\"bold\" class=\"title\"></text></g></svg></g></g></g></svg>"
