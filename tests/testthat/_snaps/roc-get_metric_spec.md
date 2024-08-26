# produce metric spec (Snapshot)__spec_ids{roc$outputs$metrics$facets;roc$outputs$metrics$axis;roc$outputs$metrics$plot}

    Code
      spec %>% vegawidget::vw_as_json()
    Output
      {
        "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
        "usermeta": {
          "embedOptions": {
            "renderer": "svg",
            "actions": {
              "editor": false
            },
            "defaultStyle": true
          }
        },
        "data": {
          "values": [
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_parameter": "R1",
              "score": 11,
              "norm_score": 111,
              "norm_rank": 1111,
              "type": "A",
              "y": 1,
              "lim_y": null,
              "lim_x": null
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_parameter": "R1",
              "score": 22,
              "norm_score": 222,
              "norm_rank": 2222,
              "type": "B",
              "y": 2,
              "lim_y": null,
              "lim_x": null
            },
            {
              "predictor_parameter": "P3",
              "group": "G1",
              "response_parameter": "R1",
              "score": 11,
              "norm_score": 111,
              "norm_rank": 1111,
              "type": "A",
              "y": 1,
              "lim_y": null,
              "lim_x": null
            },
            {
              "predictor_parameter": "P3",
              "group": "G2",
              "response_parameter": "R1",
              "score": 22,
              "norm_score": 222,
              "norm_rank": 2222,
              "type": "B",
              "y": 2,
              "lim_y": null,
              "lim_x": null
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "A",
              "y": null,
              "lim_y": -2,
              "lim_x": 111
            },
            {
              "predictor_parameter": "P3",
              "group": "G1",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "A",
              "y": null,
              "lim_y": -2,
              "lim_x": 111
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "A",
              "y": null,
              "lim_y": 2,
              "lim_x": 111
            },
            {
              "predictor_parameter": "P3",
              "group": "G1",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "A",
              "y": null,
              "lim_y": 2,
              "lim_x": 111
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "B",
              "y": null,
              "lim_y": -10,
              "lim_x": 111
            },
            {
              "predictor_parameter": "P3",
              "group": "G2",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "B",
              "y": null,
              "lim_y": -10,
              "lim_x": 111
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "B",
              "y": null,
              "lim_y": 10,
              "lim_x": 111
            },
            {
              "predictor_parameter": "P3",
              "group": "G2",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "B",
              "y": null,
              "lim_y": 10,
              "lim_x": 111
            }
          ]
        },
        "spec": {
          "encoding": {
            "x": {
              "field": "norm_score",
              "type": "quantitative",
              "title": "Normalized Score"
            },
            "y": {
              "field": "y",
              "title": null,
              "type": "quantitative"
            },
            "color": {
              "field": "group",
              "type": "nominal",
              "scale": {
                "scheme": "magma"
              },
              "legend": {
                "title": "Group"
              }
            }
          },
          "layer": [
            {
              "mark": {
                "type": "line"
              }
            },
            {
              "mark": {
                "type": "point",
                "tooltip": {
                  "content": "data"
                }
              }
            },
            {
              "mark": {
                "type": "point"
              },
              "encoding": {
                "x": {
                  "field": "lim_x",
                  "type": "quantitative"
                },
                "y": {
                  "field": "lim_y",
                  "type": "quantitative"
                },
                "opacity": {
                  "value": 0
                }
              }
            }
          ],
          "width": 50,
          "height": 50
        },
        "facet": {
          "column": {
            "field": "type",
            "title": null
          },
          "row": {
            "field": "predictor_parameter",
            "title": null
          },
          "header": {
            "labelFontWeight": "bold"
          }
        },
        "resolve": {
          "scale": {
            "x": "shared",
            "y": "independent"
          }
        },
        "config": {
          "header": {
            "labelFontWeight": "bold"
          }
        }
      } 

# produce metric spec. Ungrouped. (Snapshot)__spec_ids{roc$outputs$metrics$facets;roc$outputs$metrics$axis;roc$outputs$metrics$plot}

    Code
      spec %>% vegawidget::vw_as_json()
    Output
      {
        "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
        "usermeta": {
          "embedOptions": {
            "renderer": "svg",
            "actions": {
              "editor": false
            },
            "defaultStyle": true
          }
        },
        "data": {
          "values": [
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "score": 11,
              "norm_score": 111,
              "norm_rank": 1111,
              "type": "A",
              "y": 1,
              "lim_y": null,
              "lim_x": null
            },
            {
              "predictor_parameter": "P3",
              "response_parameter": "R1",
              "score": 22,
              "norm_score": 222,
              "norm_rank": 2222,
              "type": "B",
              "y": 2,
              "lim_y": null,
              "lim_x": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "A",
              "y": null,
              "lim_y": -2,
              "lim_x": 111
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "A",
              "y": null,
              "lim_y": 2,
              "lim_x": 111
            },
            {
              "predictor_parameter": "P3",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "B",
              "y": null,
              "lim_y": -10,
              "lim_x": 111
            },
            {
              "predictor_parameter": "P3",
              "response_parameter": "R1",
              "score": null,
              "norm_score": null,
              "norm_rank": null,
              "type": "B",
              "y": null,
              "lim_y": 10,
              "lim_x": 111
            }
          ]
        },
        "spec": {
          "encoding": {
            "x": {
              "field": "norm_score",
              "type": "quantitative",
              "title": "Normalized Score"
            },
            "y": {
              "field": "y",
              "title": null,
              "type": "quantitative"
            },
            "color": {
              "field": "response_parameter",
              "type": "nominal",
              "scale": {
                "scheme": "magma"
              },
              "legend": {
                "title": "response_parameter"
              }
            }
          },
          "layer": [
            {
              "mark": {
                "type": "line"
              }
            },
            {
              "mark": {
                "type": "point",
                "tooltip": {
                  "content": "data"
                }
              }
            },
            {
              "mark": {
                "type": "point"
              },
              "encoding": {
                "x": {
                  "field": "lim_x",
                  "type": "quantitative"
                },
                "y": {
                  "field": "lim_y",
                  "type": "quantitative"
                },
                "opacity": {
                  "value": 0
                }
              }
            }
          ],
          "width": 50,
          "height": 50
        },
        "facet": {
          "column": {
            "field": "type",
            "title": null
          },
          "row": {
            "field": "predictor_parameter",
            "title": null
          },
          "header": {
            "labelFontWeight": "bold"
          }
        },
        "resolve": {
          "scale": {
            "x": "shared",
            "y": "independent"
          }
        },
        "config": {
          "header": {
            "labelFontWeight": "bold"
          }
        }
      } 

