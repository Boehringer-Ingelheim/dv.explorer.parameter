# produce roc spec (Snapshot)__spec_ids{roc$outputs$roc_curve$facets;roc$outputs$roc_curve$axis;roc$outputs$roc_curve$plot;roc$outputs$roc_curve$optimal_cut;roc$outputs$roc_curve$CI}

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
              "group": "G1",
              "specificity": 0.1,
              "sensitivity": 0.2,
              "auc": [0, 0.1, 0.2],
              "threshold": 1,
              "direction": "1",
              "levels": ["a", "b"],
              "dir_str": "a1b",
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "group": "G1",
              "specificity": 0.3,
              "sensitivity": 0.4,
              "auc": [0.1, 0.2, 0.3],
              "threshold": 2,
              "direction": "2",
              "levels": ["c", "d"],
              "dir_str": "c2d",
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "group": "G2",
              "specificity": 0.11,
              "sensitivity": 0.22,
              "auc": [0.2, 0.3, 0.4],
              "threshold": 3,
              "direction": "3",
              "levels": ["e", "f"],
              "dir_str": "e3f",
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "group": "G2",
              "specificity": 0.33,
              "sensitivity": 0.44,
              "auc": [0.5, 0.6, 0.7],
              "threshold": 4,
              "direction": "4",
              "levels": ["g", "h"],
              "dir_str": "g4h",
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "group": "G1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": 0,
              "ci_sensitivity": 0.1,
              "ci_lower_specificity": 0.2,
              "ci_lower_sensitivity": 0.3,
              "ci_upper_specificity": 0.4,
              "ci_upper_sensitivity": 0.5,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "group": "G1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": 0.01,
              "ci_sensitivity": 0.11,
              "ci_lower_specificity": 0.21,
              "ci_lower_sensitivity": 0.31,
              "ci_upper_specificity": 0.41,
              "ci_upper_sensitivity": 0.51,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "group": "G2",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": 0.02,
              "ci_sensitivity": 0.12,
              "ci_lower_specificity": 0.22,
              "ci_lower_sensitivity": 0.32,
              "ci_upper_specificity": 0.42,
              "ci_upper_sensitivity": 0.52,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "group": "G2",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": 0.03,
              "ci_sensitivity": 0.13,
              "ci_lower_specificity": 0.23,
              "ci_lower_sensitivity": 0.33,
              "ci_upper_specificity": 0.43,
              "ci_upper_sensitivity": 0.53,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "group": "G1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P1_G1",
              "optimal_cut_specificity": 0.1,
              "optimal_cut_sensitivity": 0.5,
              "optimal_cut_lower_specificity": 0.2,
              "optimal_cut_lower_sensitivity": 0.3,
              "optimal_cut_upper_specificity": 0.4,
              "optimal_cut_upper_sensitivity": 0.5,
              "optimal_cut_threshold": 1
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "group": "G1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P2_G1",
              "optimal_cut_specificity": 0.2,
              "optimal_cut_sensitivity": 0.6,
              "optimal_cut_lower_specificity": 0.21,
              "optimal_cut_lower_sensitivity": 0.31,
              "optimal_cut_upper_specificity": 0.41,
              "optimal_cut_upper_sensitivity": 0.51,
              "optimal_cut_threshold": 2
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "group": "G2",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P1_G2",
              "optimal_cut_specificity": 0.3,
              "optimal_cut_sensitivity": 0.7,
              "optimal_cut_lower_specificity": 0.22,
              "optimal_cut_lower_sensitivity": 0.32,
              "optimal_cut_upper_specificity": 0.42,
              "optimal_cut_upper_sensitivity": 0.52,
              "optimal_cut_threshold": 3
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "group": "G2",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P2_G2",
              "optimal_cut_specificity": 0.4,
              "optimal_cut_sensitivity": 0.8,
              "optimal_cut_lower_specificity": 0.23,
              "optimal_cut_lower_sensitivity": 0.33,
              "optimal_cut_upper_specificity": 0.43,
              "optimal_cut_upper_sensitivity": 0.53,
              "optimal_cut_threshold": 4
            }
          ]
        },
        "spec": {
          "layer": [
            {
              "data": {
                "values": [
                  {
                    "x": 0,
                    "y": 0
                  },
                  {
                    "x": 1,
                    "y": 1
                  }
                ]
              },
              "mark": {
                "type": "line",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "x": {
                  "field": "x",
                  "type": "quantitative"
                },
                "y": {
                  "field": "y",
                  "type": "quantitative"
                },
                "color": {
                  "value": "black"
                }
              }
            },
            {
              "mark": {
                "type": "rule",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "y": {
                  "field": "ci_lower_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_upper_sensitivity"
                },
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_specificity"
                  }
                }
              }
            },
            {
              "mark": {
                "type": "rule",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "y": {
                  "field": "ci_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_sensitivity"
                },
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_lower_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_upper_specificity"
                  }
                }
              }
            },
            {
              "transform": [
                {
                  "calculate": "'95% CI'",
                  "as": "title"
                },
                {
                  "calculate": "'('+format(datum.ci_lower_sensitivity, '.2f')+'-'+format(datum.ci_upper_sensitivity, '.2f')+')'",
                  "as": "ci_se_str"
                },
                {
                  "calculate": "'('+format(datum.ci_lower_specificity, '.2f')+'-'+format(datum.ci_upper_specificity, '.2f')+')'",
                  "as": "ci_sp_str"
                }
              ],
              "mark": {
                "type": "rect"
              },
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_lower_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_upper_specificity"
                  }
                },
                "y": {
                  "field": "ci_lower_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_upper_sensitivity"
                },
                "opacity": {
                  "value": 0.2
                },
                "tooltip": [
                  {
                    "field": "title",
                    "type": "nominal"
                  },
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  {
                    "field": "group",
                    "type": "nominal",
                    "title": "group"
                  },
                  {
                    "field": "ci_se_str",
                    "type": "nominal",
                    "title": "Sensitivity"
                  },
                  {
                    "field": "ci_sp_str",
                    "type": "nominal",
                    "title": "Specificity"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  }
                ]
              }
            },
            {
              "mark": "line",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.specificity"
                  },
                  "type": "quantitative",
                  "axis": {
                    "title": "1 - Specificity"
                  }
                },
                "y": {
                  "field": "sensitivity",
                  "type": "quantitative",
                  "axis": {
                    "title": "Sensitivity"
                  }
                },
                "tooltip": [
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  {
                    "field": "group",
                    "type": "nominal",
                    "title": "group"
                  },
                  {
                    "field": "auc_str_frt",
                    "type": "nominal",
                    "title": "AUC"
                  },
                  {
                    "field": "sensitivity",
                    "type": "quantitative",
                    "title": "Sensitivity",
                    "format": ".2f"
                  },
                  {
                    "field": "specificity",
                    "type": "quantitative",
                    "title": "Specificity",
                    "format": ".2f"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  },
                  {
                    "field": "dir_str",
                    "type": "nominal",
                    "title": "Direction"
                  }
                ]
              }
            },
            {
              "transform": [
                {
                  "as": "auc_str_frt",
                  "calculate": "if(isArray(datum.auc), ''+format(datum.auc[1], '.2f')+' ('+format(datum.auc[0], '.2f')+'-'+format(datum.auc[2], '.2f')+')', 0)"
                }
              ],
              "mark": "point",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.specificity"
                  },
                  "type": "quantitative",
                  "axis": {
                    "title": "1 - Specificity"
                  }
                },
                "y": {
                  "field": "sensitivity",
                  "type": "quantitative",
                  "axis": {
                    "title": "Sensitivity"
                  }
                },
                "tooltip": [
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  {
                    "field": "group",
                    "type": "nominal",
                    "title": "group"
                  },
                  {
                    "field": "auc_str_frt",
                    "type": "nominal",
                    "title": "AUC"
                  },
                  {
                    "field": "sensitivity",
                    "type": "quantitative",
                    "title": "Sensitivity",
                    "format": ".2f"
                  },
                  {
                    "field": "specificity",
                    "type": "quantitative",
                    "title": "Specificity",
                    "format": ".2f"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  },
                  {
                    "field": "dir_str",
                    "type": "nominal",
                    "title": "Direction"
                  }
                ]
              }
            },
            {
              "transform": [
                {
                  "calculate": "datum.optimal_cut_title",
                  "as": "title"
                },
                {
                  "as": "oc_str_sp",
                  "calculate": "''+format(datum.optimal_cut_specificity, '.2f')+' ('+format(datum.optimal_cut_lower_specificity, '.2f')+'-'+format(datum.optimal_cut_upper_specificity, '.2f')+')'"
                },
                {
                  "as": "oc_str_se",
                  "calculate": "''+format(datum.optimal_cut_sensitivity, '.2f')+' ('+format(datum.optimal_cut_upper_sensitivity, '.2f')+'-'+format(datum.optimal_cut_lower_sensitivity, '.2f')+')'"
                }
              ],
              "mark": "point",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.optimal_cut_specificity"
                  },
                  "type": "quantitative"
                },
                "y": {
                  "field": "optimal_cut_sensitivity",
                  "type": "quantitative"
                },
                "color": {
                  "field": "optimal_cut_title",
                  "scale": {
                    "scheme": "magma"
                  },
                  "title": "Optimal Cut"
                },
                "tooltip": [
                  {
                    "field": "title",
                    "type": "nominal"
                  },
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  {
                    "field": "group",
                    "type": "nominal",
                    "title": "group"
                  },
                  {
                    "field": "oc_str_sp",
                    "type": "nominal",
                    "title": "Sensitivity"
                  },
                  {
                    "field": "oc_str_se",
                    "type": "nominal",
                    "title": "Specificity"
                  },
                  {
                    "field": "optimal_cut_threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  }
                ]
              }
            }
          ],
          "width": 50,
          "height": 50
        },
        "facet": {
          "column": {
            "field": "group",
            "title": "group"
          },
          "row": {
            "field": "predictor_parameter",
            "title": "Group"
          }
        }
      } 

# produce ungrouped roc spec (Snapshot)__spec_ids{roc$outputs$roc_curve$facets;roc$outputs$roc_curve$axis;roc$outputs$roc_curve$plot;roc$outputs$roc_curve$optimal_cut;roc$outputs$roc_curve$CI}

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
              "specificity": 0.1,
              "sensitivity": 0.2,
              "auc": [0, 0.1, 0.2],
              "threshold": 1,
              "direction": "1",
              "levels": ["a", "b"],
              "dir_str": "a1b",
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": 0.3,
              "sensitivity": 0.4,
              "auc": [0.1, 0.2, 0.3],
              "threshold": 2,
              "direction": "2",
              "levels": ["c", "d"],
              "dir_str": "c2d",
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "specificity": 0.11,
              "sensitivity": 0.22,
              "auc": [0.2, 0.3, 0.4],
              "threshold": 3,
              "direction": "3",
              "levels": ["e", "f"],
              "dir_str": "e3f",
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": 0.33,
              "sensitivity": 0.44,
              "auc": [0.5, 0.6, 0.7],
              "threshold": 4,
              "direction": "4",
              "levels": ["g", "h"],
              "dir_str": "g4h",
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": 0,
              "ci_sensitivity": 0.1,
              "ci_lower_specificity": 0.2,
              "ci_lower_sensitivity": 0.3,
              "ci_upper_specificity": 0.4,
              "ci_upper_sensitivity": 0.5,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": 0.01,
              "ci_sensitivity": 0.11,
              "ci_lower_specificity": 0.21,
              "ci_lower_sensitivity": 0.31,
              "ci_upper_specificity": 0.41,
              "ci_upper_sensitivity": 0.51,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": 0.02,
              "ci_sensitivity": 0.12,
              "ci_lower_specificity": 0.22,
              "ci_lower_sensitivity": 0.32,
              "ci_upper_specificity": 0.42,
              "ci_upper_sensitivity": 0.52,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": 0.03,
              "ci_sensitivity": 0.13,
              "ci_lower_specificity": 0.23,
              "ci_lower_sensitivity": 0.33,
              "ci_upper_specificity": 0.43,
              "ci_upper_sensitivity": 0.53,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P1",
              "optimal_cut_specificity": 0.1,
              "optimal_cut_sensitivity": 0.5,
              "optimal_cut_lower_specificity": 0.2,
              "optimal_cut_lower_sensitivity": 0.3,
              "optimal_cut_upper_specificity": 0.4,
              "optimal_cut_upper_sensitivity": 0.5,
              "optimal_cut_threshold": 1
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P2",
              "optimal_cut_specificity": 0.2,
              "optimal_cut_sensitivity": 0.6,
              "optimal_cut_lower_specificity": 0.21,
              "optimal_cut_lower_sensitivity": 0.31,
              "optimal_cut_upper_specificity": 0.41,
              "optimal_cut_upper_sensitivity": 0.51,
              "optimal_cut_threshold": 2
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P1",
              "optimal_cut_specificity": 0.3,
              "optimal_cut_sensitivity": 0.7,
              "optimal_cut_lower_specificity": 0.22,
              "optimal_cut_lower_sensitivity": 0.32,
              "optimal_cut_upper_specificity": 0.42,
              "optimal_cut_upper_sensitivity": 0.52,
              "optimal_cut_threshold": 3
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P2",
              "optimal_cut_specificity": 0.4,
              "optimal_cut_sensitivity": 0.8,
              "optimal_cut_lower_specificity": 0.23,
              "optimal_cut_lower_sensitivity": 0.33,
              "optimal_cut_upper_specificity": 0.43,
              "optimal_cut_upper_sensitivity": 0.53,
              "optimal_cut_threshold": 4
            }
          ]
        },
        "spec": {
          "layer": [
            {
              "data": {
                "values": [
                  {
                    "x": 0,
                    "y": 0
                  },
                  {
                    "x": 1,
                    "y": 1
                  }
                ]
              },
              "mark": {
                "type": "line",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "x": {
                  "field": "x",
                  "type": "quantitative"
                },
                "y": {
                  "field": "y",
                  "type": "quantitative"
                },
                "color": {
                  "value": "black"
                }
              }
            },
            {
              "mark": {
                "type": "rule",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "y": {
                  "field": "ci_lower_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_upper_sensitivity"
                },
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_specificity"
                  }
                }
              }
            },
            {
              "mark": {
                "type": "rule",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "y": {
                  "field": "ci_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_sensitivity"
                },
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_lower_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_upper_specificity"
                  }
                }
              }
            },
            {
              "transform": [
                {
                  "calculate": "'95% CI'",
                  "as": "title"
                },
                {
                  "calculate": "'('+format(datum.ci_lower_sensitivity, '.2f')+'-'+format(datum.ci_upper_sensitivity, '.2f')+')'",
                  "as": "ci_se_str"
                },
                {
                  "calculate": "'('+format(datum.ci_lower_specificity, '.2f')+'-'+format(datum.ci_upper_specificity, '.2f')+')'",
                  "as": "ci_sp_str"
                }
              ],
              "mark": {
                "type": "rect"
              },
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_lower_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_upper_specificity"
                  }
                },
                "y": {
                  "field": "ci_lower_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_upper_sensitivity"
                },
                "opacity": {
                  "value": 0.2
                },
                "tooltip": [
                  {
                    "field": "title",
                    "type": "nominal"
                  },
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "ci_se_str",
                    "type": "nominal",
                    "title": "Sensitivity"
                  },
                  {
                    "field": "ci_sp_str",
                    "type": "nominal",
                    "title": "Specificity"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  }
                ]
              }
            },
            {
              "mark": "line",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.specificity"
                  },
                  "type": "quantitative",
                  "axis": {
                    "title": "1 - Specificity"
                  }
                },
                "y": {
                  "field": "sensitivity",
                  "type": "quantitative",
                  "axis": {
                    "title": "Sensitivity"
                  }
                },
                "tooltip": [
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "auc_str_frt",
                    "type": "nominal",
                    "title": "AUC"
                  },
                  {
                    "field": "sensitivity",
                    "type": "quantitative",
                    "title": "Sensitivity",
                    "format": ".2f"
                  },
                  {
                    "field": "specificity",
                    "type": "quantitative",
                    "title": "Specificity",
                    "format": ".2f"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  },
                  {
                    "field": "dir_str",
                    "type": "nominal",
                    "title": "Direction"
                  }
                ]
              }
            },
            {
              "transform": [
                {
                  "as": "auc_str_frt",
                  "calculate": "if(isArray(datum.auc), ''+format(datum.auc[1], '.2f')+' ('+format(datum.auc[0], '.2f')+'-'+format(datum.auc[2], '.2f')+')', 0)"
                }
              ],
              "mark": "point",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.specificity"
                  },
                  "type": "quantitative",
                  "axis": {
                    "title": "1 - Specificity"
                  }
                },
                "y": {
                  "field": "sensitivity",
                  "type": "quantitative",
                  "axis": {
                    "title": "Sensitivity"
                  }
                },
                "tooltip": [
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "auc_str_frt",
                    "type": "nominal",
                    "title": "AUC"
                  },
                  {
                    "field": "sensitivity",
                    "type": "quantitative",
                    "title": "Sensitivity",
                    "format": ".2f"
                  },
                  {
                    "field": "specificity",
                    "type": "quantitative",
                    "title": "Specificity",
                    "format": ".2f"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  },
                  {
                    "field": "dir_str",
                    "type": "nominal",
                    "title": "Direction"
                  }
                ]
              }
            },
            {
              "transform": [
                {
                  "calculate": "datum.optimal_cut_title",
                  "as": "title"
                },
                {
                  "as": "oc_str_sp",
                  "calculate": "''+format(datum.optimal_cut_specificity, '.2f')+' ('+format(datum.optimal_cut_lower_specificity, '.2f')+'-'+format(datum.optimal_cut_upper_specificity, '.2f')+')'"
                },
                {
                  "as": "oc_str_se",
                  "calculate": "''+format(datum.optimal_cut_sensitivity, '.2f')+' ('+format(datum.optimal_cut_upper_sensitivity, '.2f')+'-'+format(datum.optimal_cut_lower_sensitivity, '.2f')+')'"
                }
              ],
              "mark": "point",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.optimal_cut_specificity"
                  },
                  "type": "quantitative"
                },
                "y": {
                  "field": "optimal_cut_sensitivity",
                  "type": "quantitative"
                },
                "color": {
                  "field": "optimal_cut_title",
                  "scale": {
                    "scheme": "magma"
                  },
                  "title": "Optimal Cut"
                },
                "tooltip": [
                  {
                    "field": "title",
                    "type": "nominal"
                  },
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "oc_str_sp",
                    "type": "nominal",
                    "title": "Sensitivity"
                  },
                  {
                    "field": "oc_str_se",
                    "type": "nominal",
                    "title": "Specificity"
                  },
                  {
                    "field": "optimal_cut_threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  }
                ]
              }
            }
          ],
          "width": 50,
          "height": 50
        },
        "facet": {
          "column": {
            "field": "predictor_parameter",
            "title": "Group"
          }
        }
      } 

# produce roc sorted spec (Snapshot)__spec_ids{roc$outputs$roc_curve$facets;roc$outputs$roc_curve$axis;roc$outputs$roc_curve$plot;roc$outputs$roc_curve$optimal_cut;roc$outputs$roc_curve$CI}

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
              "predictor_parameter": "P1  -  G1",
              "response_parameter": "R1",
              "specificity": 0.1,
              "sensitivity": 0.2,
              "auc": [0, 0.1, 0.2],
              "threshold": 1,
              "direction": "1",
              "levels": ["a", "b"],
              "dir_str": "a1b",
              "auc_sort": 0.1,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2  -  G1",
              "response_parameter": "R1",
              "specificity": 0.3,
              "sensitivity": 0.4,
              "auc": [0.1, 0.2, 0.3],
              "threshold": 2,
              "direction": "2",
              "levels": ["c", "d"],
              "dir_str": "c2d",
              "auc_sort": 0.2,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1  -  G2",
              "response_parameter": "R1",
              "specificity": 0.11,
              "sensitivity": 0.22,
              "auc": [0.2, 0.3, 0.4],
              "threshold": 3,
              "direction": "3",
              "levels": ["e", "f"],
              "dir_str": "e3f",
              "auc_sort": 0.3,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2  -  G2",
              "response_parameter": "R1",
              "specificity": 0.33,
              "sensitivity": 0.44,
              "auc": [0.5, 0.6, 0.7],
              "threshold": 4,
              "direction": "4",
              "levels": ["g", "h"],
              "dir_str": "g4h",
              "auc_sort": 0.6,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1  -  G1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": 0,
              "ci_sensitivity": 0.1,
              "ci_lower_specificity": 0.2,
              "ci_lower_sensitivity": 0.3,
              "ci_upper_specificity": 0.4,
              "ci_upper_sensitivity": 0.5,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2  -  G1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": 0.01,
              "ci_sensitivity": 0.11,
              "ci_lower_specificity": 0.21,
              "ci_lower_sensitivity": 0.31,
              "ci_upper_specificity": 0.41,
              "ci_upper_sensitivity": 0.51,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1  -  G2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": 0.02,
              "ci_sensitivity": 0.12,
              "ci_lower_specificity": 0.22,
              "ci_lower_sensitivity": 0.32,
              "ci_upper_specificity": 0.42,
              "ci_upper_sensitivity": 0.52,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2  -  G2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": 0.03,
              "ci_sensitivity": 0.13,
              "ci_lower_specificity": 0.23,
              "ci_lower_sensitivity": 0.33,
              "ci_upper_specificity": 0.43,
              "ci_upper_sensitivity": 0.53,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1  -  G1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P1_G1",
              "optimal_cut_specificity": 0.1,
              "optimal_cut_sensitivity": 0.5,
              "optimal_cut_lower_specificity": 0.2,
              "optimal_cut_lower_sensitivity": 0.3,
              "optimal_cut_upper_specificity": 0.4,
              "optimal_cut_upper_sensitivity": 0.5,
              "optimal_cut_threshold": 1
            },
            {
              "predictor_parameter": "P2  -  G1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P2_G1",
              "optimal_cut_specificity": 0.2,
              "optimal_cut_sensitivity": 0.6,
              "optimal_cut_lower_specificity": 0.21,
              "optimal_cut_lower_sensitivity": 0.31,
              "optimal_cut_upper_specificity": 0.41,
              "optimal_cut_upper_sensitivity": 0.51,
              "optimal_cut_threshold": 2
            },
            {
              "predictor_parameter": "P1  -  G2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P1_G2",
              "optimal_cut_specificity": 0.3,
              "optimal_cut_sensitivity": 0.7,
              "optimal_cut_lower_specificity": 0.22,
              "optimal_cut_lower_sensitivity": 0.32,
              "optimal_cut_upper_specificity": 0.42,
              "optimal_cut_upper_sensitivity": 0.52,
              "optimal_cut_threshold": 3
            },
            {
              "predictor_parameter": "P2  -  G2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P2_G2",
              "optimal_cut_specificity": 0.4,
              "optimal_cut_sensitivity": 0.8,
              "optimal_cut_lower_specificity": 0.23,
              "optimal_cut_lower_sensitivity": 0.33,
              "optimal_cut_upper_specificity": 0.43,
              "optimal_cut_upper_sensitivity": 0.53,
              "optimal_cut_threshold": 4
            }
          ]
        },
        "spec": {
          "layer": [
            {
              "data": {
                "values": [
                  {
                    "x": 0,
                    "y": 0
                  },
                  {
                    "x": 1,
                    "y": 1
                  }
                ]
              },
              "mark": {
                "type": "line",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "x": {
                  "field": "x",
                  "type": "quantitative"
                },
                "y": {
                  "field": "y",
                  "type": "quantitative"
                },
                "color": {
                  "value": "black"
                }
              }
            },
            {
              "mark": {
                "type": "rule",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "y": {
                  "field": "ci_lower_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_upper_sensitivity"
                },
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_specificity"
                  }
                }
              }
            },
            {
              "mark": {
                "type": "rule",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "y": {
                  "field": "ci_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_sensitivity"
                },
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_lower_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_upper_specificity"
                  }
                }
              }
            },
            {
              "transform": [
                {
                  "calculate": "'95% CI'",
                  "as": "title"
                },
                {
                  "calculate": "'('+format(datum.ci_lower_sensitivity, '.2f')+'-'+format(datum.ci_upper_sensitivity, '.2f')+')'",
                  "as": "ci_se_str"
                },
                {
                  "calculate": "'('+format(datum.ci_lower_specificity, '.2f')+'-'+format(datum.ci_upper_specificity, '.2f')+')'",
                  "as": "ci_sp_str"
                }
              ],
              "mark": {
                "type": "rect"
              },
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_lower_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_upper_specificity"
                  }
                },
                "y": {
                  "field": "ci_lower_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_upper_sensitivity"
                },
                "opacity": {
                  "value": 0.2
                },
                "tooltip": [
                  {
                    "field": "title",
                    "type": "nominal"
                  },
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "ci_se_str",
                    "type": "nominal",
                    "title": "Sensitivity"
                  },
                  {
                    "field": "ci_sp_str",
                    "type": "nominal",
                    "title": "Specificity"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  }
                ]
              }
            },
            {
              "mark": "line",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.specificity"
                  },
                  "type": "quantitative",
                  "axis": {
                    "title": "1 - Specificity"
                  }
                },
                "y": {
                  "field": "sensitivity",
                  "type": "quantitative",
                  "axis": {
                    "title": "Sensitivity"
                  }
                },
                "tooltip": [
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "auc_str_frt",
                    "type": "nominal",
                    "title": "AUC"
                  },
                  {
                    "field": "sensitivity",
                    "type": "quantitative",
                    "title": "Sensitivity",
                    "format": ".2f"
                  },
                  {
                    "field": "specificity",
                    "type": "quantitative",
                    "title": "Specificity",
                    "format": ".2f"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  },
                  {
                    "field": "dir_str",
                    "type": "nominal",
                    "title": "Direction"
                  }
                ]
              }
            },
            {
              "transform": [
                {
                  "as": "auc_str_frt",
                  "calculate": "if(isArray(datum.auc), ''+format(datum.auc[1], '.2f')+' ('+format(datum.auc[0], '.2f')+'-'+format(datum.auc[2], '.2f')+')', 0)"
                }
              ],
              "mark": "point",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.specificity"
                  },
                  "type": "quantitative",
                  "axis": {
                    "title": "1 - Specificity"
                  }
                },
                "y": {
                  "field": "sensitivity",
                  "type": "quantitative",
                  "axis": {
                    "title": "Sensitivity"
                  }
                },
                "tooltip": [
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "auc_str_frt",
                    "type": "nominal",
                    "title": "AUC"
                  },
                  {
                    "field": "sensitivity",
                    "type": "quantitative",
                    "title": "Sensitivity",
                    "format": ".2f"
                  },
                  {
                    "field": "specificity",
                    "type": "quantitative",
                    "title": "Specificity",
                    "format": ".2f"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  },
                  {
                    "field": "dir_str",
                    "type": "nominal",
                    "title": "Direction"
                  }
                ]
              }
            },
            {
              "transform": [
                {
                  "calculate": "datum.optimal_cut_title",
                  "as": "title"
                },
                {
                  "as": "oc_str_sp",
                  "calculate": "''+format(datum.optimal_cut_specificity, '.2f')+' ('+format(datum.optimal_cut_lower_specificity, '.2f')+'-'+format(datum.optimal_cut_upper_specificity, '.2f')+')'"
                },
                {
                  "as": "oc_str_se",
                  "calculate": "''+format(datum.optimal_cut_sensitivity, '.2f')+' ('+format(datum.optimal_cut_upper_sensitivity, '.2f')+'-'+format(datum.optimal_cut_lower_sensitivity, '.2f')+')'"
                }
              ],
              "mark": "point",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.optimal_cut_specificity"
                  },
                  "type": "quantitative"
                },
                "y": {
                  "field": "optimal_cut_sensitivity",
                  "type": "quantitative"
                },
                "color": {
                  "field": "optimal_cut_title",
                  "scale": {
                    "scheme": "magma"
                  },
                  "title": "Optimal Cut"
                },
                "tooltip": [
                  {
                    "field": "title",
                    "type": "nominal"
                  },
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "oc_str_sp",
                    "type": "nominal",
                    "title": "Sensitivity"
                  },
                  {
                    "field": "oc_str_se",
                    "type": "nominal",
                    "title": "Specificity"
                  },
                  {
                    "field": "optimal_cut_threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  }
                ]
              }
            }
          ],
          "width": 50,
          "height": 50
        },
        "facet": {
          "field": "predictor_parameter",
          "sort": {
            "op": "mean",
            "field": "auc_sort",
            "order": "descending"
          },
          "title": "Group - group"
        },
        "columns": 4
      } 

# produce ungrouped roc sorted spec (Snapshot)__spec_ids{roc$outputs$roc_curve$facets;roc$outputs$roc_curve$axis;roc$outputs$roc_curve$plot;roc$outputs$roc_curve$optimal_cut;roc$outputs$roc_curve$CI}

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
              "specificity": 0.1,
              "sensitivity": 0.2,
              "auc": [0, 0.1, 0.2],
              "threshold": 1,
              "direction": "1",
              "levels": ["a", "b"],
              "dir_str": "a1b",
              "auc_sort": 0.1,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": 0.3,
              "sensitivity": 0.4,
              "auc": [0.1, 0.2, 0.3],
              "threshold": 2,
              "direction": "2",
              "levels": ["c", "d"],
              "dir_str": "c2d",
              "auc_sort": 0.2,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "specificity": 0.11,
              "sensitivity": 0.22,
              "auc": [0.2, 0.3, 0.4],
              "threshold": 3,
              "direction": "3",
              "levels": ["e", "f"],
              "dir_str": "e3f",
              "auc_sort": 0.3,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": 0.33,
              "sensitivity": 0.44,
              "auc": [0.5, 0.6, 0.7],
              "threshold": 4,
              "direction": "4",
              "levels": ["g", "h"],
              "dir_str": "g4h",
              "auc_sort": 0.6,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": 0,
              "ci_sensitivity": 0.1,
              "ci_lower_specificity": 0.2,
              "ci_lower_sensitivity": 0.3,
              "ci_upper_specificity": 0.4,
              "ci_upper_sensitivity": 0.5,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": 0.01,
              "ci_sensitivity": 0.11,
              "ci_lower_specificity": 0.21,
              "ci_lower_sensitivity": 0.31,
              "ci_upper_specificity": 0.41,
              "ci_upper_sensitivity": 0.51,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": 0.02,
              "ci_sensitivity": 0.12,
              "ci_lower_specificity": 0.22,
              "ci_lower_sensitivity": 0.32,
              "ci_upper_specificity": 0.42,
              "ci_upper_sensitivity": 0.52,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": 0.03,
              "ci_sensitivity": 0.13,
              "ci_lower_specificity": 0.23,
              "ci_lower_sensitivity": 0.33,
              "ci_upper_specificity": 0.43,
              "ci_upper_sensitivity": 0.53,
              "optimal_cut_title": null,
              "optimal_cut_specificity": null,
              "optimal_cut_sensitivity": null,
              "optimal_cut_lower_specificity": null,
              "optimal_cut_lower_sensitivity": null,
              "optimal_cut_upper_specificity": null,
              "optimal_cut_upper_sensitivity": null,
              "optimal_cut_threshold": null
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P1",
              "optimal_cut_specificity": 0.1,
              "optimal_cut_sensitivity": 0.5,
              "optimal_cut_lower_specificity": 0.2,
              "optimal_cut_lower_sensitivity": 0.3,
              "optimal_cut_upper_specificity": 0.4,
              "optimal_cut_upper_sensitivity": 0.5,
              "optimal_cut_threshold": 1
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P2",
              "optimal_cut_specificity": 0.2,
              "optimal_cut_sensitivity": 0.6,
              "optimal_cut_lower_specificity": 0.21,
              "optimal_cut_lower_sensitivity": 0.31,
              "optimal_cut_upper_specificity": 0.41,
              "optimal_cut_upper_sensitivity": 0.51,
              "optimal_cut_threshold": 2
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P1",
              "optimal_cut_specificity": 0.3,
              "optimal_cut_sensitivity": 0.7,
              "optimal_cut_lower_specificity": 0.22,
              "optimal_cut_lower_sensitivity": 0.32,
              "optimal_cut_upper_specificity": 0.42,
              "optimal_cut_upper_sensitivity": 0.52,
              "optimal_cut_threshold": 3
            },
            {
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "specificity": null,
              "sensitivity": null,
              "auc": null,
              "threshold": null,
              "direction": null,
              "levels": null,
              "dir_str": null,
              "auc_sort": null,
              "ci_specificity": null,
              "ci_sensitivity": null,
              "ci_lower_specificity": null,
              "ci_lower_sensitivity": null,
              "ci_upper_specificity": null,
              "ci_upper_sensitivity": null,
              "optimal_cut_title": "OC_P2",
              "optimal_cut_specificity": 0.4,
              "optimal_cut_sensitivity": 0.8,
              "optimal_cut_lower_specificity": 0.23,
              "optimal_cut_lower_sensitivity": 0.33,
              "optimal_cut_upper_specificity": 0.43,
              "optimal_cut_upper_sensitivity": 0.53,
              "optimal_cut_threshold": 4
            }
          ]
        },
        "spec": {
          "layer": [
            {
              "data": {
                "values": [
                  {
                    "x": 0,
                    "y": 0
                  },
                  {
                    "x": 1,
                    "y": 1
                  }
                ]
              },
              "mark": {
                "type": "line",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "x": {
                  "field": "x",
                  "type": "quantitative"
                },
                "y": {
                  "field": "y",
                  "type": "quantitative"
                },
                "color": {
                  "value": "black"
                }
              }
            },
            {
              "mark": {
                "type": "rule",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "y": {
                  "field": "ci_lower_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_upper_sensitivity"
                },
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_specificity"
                  }
                }
              }
            },
            {
              "mark": {
                "type": "rule",
                "strokeDash": [3, 1]
              },
              "encoding": {
                "y": {
                  "field": "ci_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_sensitivity"
                },
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_lower_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_upper_specificity"
                  }
                }
              }
            },
            {
              "transform": [
                {
                  "calculate": "'95% CI'",
                  "as": "title"
                },
                {
                  "calculate": "'('+format(datum.ci_lower_sensitivity, '.2f')+'-'+format(datum.ci_upper_sensitivity, '.2f')+')'",
                  "as": "ci_se_str"
                },
                {
                  "calculate": "'('+format(datum.ci_lower_specificity, '.2f')+'-'+format(datum.ci_upper_specificity, '.2f')+')'",
                  "as": "ci_sp_str"
                }
              ],
              "mark": {
                "type": "rect"
              },
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.ci_lower_specificity"
                  },
                  "type": "quantitative"
                },
                "x2": {
                  "datum": {
                    "expr": "1-datum.ci_upper_specificity"
                  }
                },
                "y": {
                  "field": "ci_lower_sensitivity",
                  "type": "quantitative"
                },
                "y2": {
                  "field": "ci_upper_sensitivity"
                },
                "opacity": {
                  "value": 0.2
                },
                "tooltip": [
                  {
                    "field": "title",
                    "type": "nominal"
                  },
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "ci_se_str",
                    "type": "nominal",
                    "title": "Sensitivity"
                  },
                  {
                    "field": "ci_sp_str",
                    "type": "nominal",
                    "title": "Specificity"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  }
                ]
              }
            },
            {
              "mark": "line",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.specificity"
                  },
                  "type": "quantitative",
                  "axis": {
                    "title": "1 - Specificity"
                  }
                },
                "y": {
                  "field": "sensitivity",
                  "type": "quantitative",
                  "axis": {
                    "title": "Sensitivity"
                  }
                },
                "tooltip": [
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "auc_str_frt",
                    "type": "nominal",
                    "title": "AUC"
                  },
                  {
                    "field": "sensitivity",
                    "type": "quantitative",
                    "title": "Sensitivity",
                    "format": ".2f"
                  },
                  {
                    "field": "specificity",
                    "type": "quantitative",
                    "title": "Specificity",
                    "format": ".2f"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  },
                  {
                    "field": "dir_str",
                    "type": "nominal",
                    "title": "Direction"
                  }
                ]
              }
            },
            {
              "transform": [
                {
                  "as": "auc_str_frt",
                  "calculate": "if(isArray(datum.auc), ''+format(datum.auc[1], '.2f')+' ('+format(datum.auc[0], '.2f')+'-'+format(datum.auc[2], '.2f')+')', 0)"
                }
              ],
              "mark": "point",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.specificity"
                  },
                  "type": "quantitative",
                  "axis": {
                    "title": "1 - Specificity"
                  }
                },
                "y": {
                  "field": "sensitivity",
                  "type": "quantitative",
                  "axis": {
                    "title": "Sensitivity"
                  }
                },
                "tooltip": [
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "auc_str_frt",
                    "type": "nominal",
                    "title": "AUC"
                  },
                  {
                    "field": "sensitivity",
                    "type": "quantitative",
                    "title": "Sensitivity",
                    "format": ".2f"
                  },
                  {
                    "field": "specificity",
                    "type": "quantitative",
                    "title": "Specificity",
                    "format": ".2f"
                  },
                  {
                    "field": "threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  },
                  {
                    "field": "dir_str",
                    "type": "nominal",
                    "title": "Direction"
                  }
                ]
              }
            },
            {
              "transform": [
                {
                  "calculate": "datum.optimal_cut_title",
                  "as": "title"
                },
                {
                  "as": "oc_str_sp",
                  "calculate": "''+format(datum.optimal_cut_specificity, '.2f')+' ('+format(datum.optimal_cut_lower_specificity, '.2f')+'-'+format(datum.optimal_cut_upper_specificity, '.2f')+')'"
                },
                {
                  "as": "oc_str_se",
                  "calculate": "''+format(datum.optimal_cut_sensitivity, '.2f')+' ('+format(datum.optimal_cut_upper_sensitivity, '.2f')+'-'+format(datum.optimal_cut_lower_sensitivity, '.2f')+')'"
                }
              ],
              "mark": "point",
              "encoding": {
                "x": {
                  "datum": {
                    "expr": "1-datum.optimal_cut_specificity"
                  },
                  "type": "quantitative"
                },
                "y": {
                  "field": "optimal_cut_sensitivity",
                  "type": "quantitative"
                },
                "color": {
                  "field": "optimal_cut_title",
                  "scale": {
                    "scheme": "magma"
                  },
                  "title": "Optimal Cut"
                },
                "tooltip": [
                  {
                    "field": "title",
                    "type": "nominal"
                  },
                  {
                    "field": "predictor_parameter",
                    "type": "nominal",
                    "title": "Predictor"
                  },
                  {
                    "field": "response_parameter",
                    "type": "nominal",
                    "title": "Response"
                  },
                  null,
                  {
                    "field": "oc_str_sp",
                    "type": "nominal",
                    "title": "Sensitivity"
                  },
                  {
                    "field": "oc_str_se",
                    "type": "nominal",
                    "title": "Specificity"
                  },
                  {
                    "field": "optimal_cut_threshold",
                    "type": "quantitative",
                    "title": "Threshold",
                    "format": ".2f"
                  }
                ]
              }
            }
          ],
          "width": 50,
          "height": 50
        },
        "facet": {
          "field": "predictor_parameter",
          "sort": {
            "op": "mean",
            "field": "auc_sort",
            "order": "descending"
          },
          "title": "predictor_parameter"
        },
        "columns": 4
      } 

