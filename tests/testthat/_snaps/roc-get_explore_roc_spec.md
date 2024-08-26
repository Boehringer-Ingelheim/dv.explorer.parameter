# produce explore roc spec (Snapshot)__spec_ids{roc$outputs$explore_auc$axis;roc$outputs$explore_auc$plot}

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
              "predictor_parameter": "P2 - G2",
              "response_parameter": "R1",
              "group": "G2",
              "auc": 0.4,
              "lower_CI_auc": 0.3,
              "upper_CI_auc": 0.5,
              "_sort": 1
            },
            {
              "predictor_parameter": "P1 - G2",
              "response_parameter": "R1",
              "group": "G2",
              "auc": 0.3,
              "lower_CI_auc": 0.2,
              "upper_CI_auc": 0.4,
              "_sort": 2
            },
            {
              "predictor_parameter": "P2 - G1",
              "response_parameter": "R1",
              "group": "G1",
              "auc": 0.2,
              "lower_CI_auc": 0.1,
              "upper_CI_auc": 0.3,
              "_sort": 3
            },
            {
              "predictor_parameter": "P1 - G1",
              "response_parameter": "R1",
              "group": "G1",
              "auc": 0.1,
              "lower_CI_auc": 0,
              "upper_CI_auc": 0.2,
              "_sort": 4
            }
          ]
        },
        "width": 50,
        "encoding": {
          "x": {
            "field": "auc",
            "type": "quantitative",
            "axis": {
              "title": "AUC"
            },
            "scale": {
              "domain": [0, 1]
            }
          },
          "y": {
            "field": "predictor_parameter",
            "type": "nominal",
            "axis": {
              "title": "Parameter"
            },
            "sort": {
              "field": "_sort",
              "order": "ascending"
            }
          }
        },
        "layer": [
          {
            "encoding": {
              "color": {
                "field": "group",
                "type": "nominal",
                "scale": {
                  "scheme": "magma"
                },
                "legend": {
                  "title": "Group",
                  "values": [
                    "G2",
                    "G1"
                  ]
                }
              }
            },
            "mark": "point"
          },
          {
            "mark": "rule",
            "encoding": {
              "color": {
                "field": "group",
                "type": "nominal",
                "scale": {
                  "scheme": "magma"
                },
                "legend": {
                  "title": "Group",
                  "values": [
                    "G2",
                    "G1"
                  ]
                }
              },
              "x": {
                "field": "lower_CI_auc",
                "type": "quantitative",
                "axis": {
                  "title": "AUC"
                }
              },
              "x2": {
                "field": "upper_CI_auc"
              }
            }
          }
        ]
      } 

# produce explore roc spec. Ungrouped (Snapshot)__spec_ids{roc$outputs$explore_auc$axis;roc$outputs$explore_auc$plot}

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
              "predictor_parameter": "P2",
              "response_parameter": "R1",
              "auc": 0.2,
              "lower_CI_auc": 0.1,
              "upper_CI_auc": 0.3,
              "_sort": 1
            },
            {
              "predictor_parameter": "P1",
              "response_parameter": "R1",
              "auc": 0.1,
              "lower_CI_auc": 0,
              "upper_CI_auc": 0.2,
              "_sort": 2
            }
          ]
        },
        "width": 50,
        "encoding": {
          "x": {
            "field": "auc",
            "type": "quantitative",
            "axis": {
              "title": "AUC"
            },
            "scale": {
              "domain": [0, 1]
            }
          },
          "y": {
            "field": "predictor_parameter",
            "type": "nominal",
            "axis": {
              "title": "Parameter"
            },
            "sort": {
              "field": "_sort",
              "order": "ascending"
            }
          }
        },
        "layer": [
          {
            "encoding": {
              "color": {
                "field": "predictor_parameter",
                "type": "nominal",
                "scale": {
                  "scheme": "magma"
                },
                "legend": {
                  "title": "Parameter",
                  "values": [
                    "P2",
                    "P1"
                  ]
                }
              }
            },
            "mark": "point"
          },
          {
            "mark": "rule",
            "encoding": {
              "color": {
                "field": "predictor_parameter",
                "type": "nominal",
                "scale": {
                  "scheme": "magma"
                },
                "legend": {
                  "title": "Parameter",
                  "values": [
                    "P2",
                    "P1"
                  ]
                }
              },
              "x": {
                "field": "lower_CI_auc",
                "type": "quantitative",
                "axis": {
                  "title": "AUC"
                }
              },
              "x2": {
                "field": "upper_CI_auc"
              }
            }
          }
        ]
      } 

# produce explore roc spec. Alphabetical order (Snapshot)

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
              "predictor_parameter": "P1 - G2",
              "response_parameter": "R1",
              "group": "G2",
              "auc": 0.3,
              "lower_CI_auc": 0.2,
              "upper_CI_auc": 0.4,
              "_sort": 1
            },
            {
              "predictor_parameter": "P1 - G1",
              "response_parameter": "R1",
              "group": "G1",
              "auc": 0.1,
              "lower_CI_auc": 0,
              "upper_CI_auc": 0.2,
              "_sort": 2
            },
            {
              "predictor_parameter": "P2 - G2",
              "response_parameter": "R1",
              "group": "G2",
              "auc": 0.4,
              "lower_CI_auc": 0.3,
              "upper_CI_auc": 0.5,
              "_sort": 3
            },
            {
              "predictor_parameter": "P2 - G1",
              "response_parameter": "R1",
              "group": "G1",
              "auc": 0.2,
              "lower_CI_auc": 0.1,
              "upper_CI_auc": 0.3,
              "_sort": 4
            }
          ]
        },
        "width": 50,
        "encoding": {
          "x": {
            "field": "auc",
            "type": "quantitative",
            "axis": {
              "title": "AUC"
            },
            "scale": {
              "domain": [0, 1]
            }
          },
          "y": {
            "field": "predictor_parameter",
            "type": "nominal",
            "axis": {
              "title": "Parameter"
            },
            "sort": {
              "field": "_sort",
              "order": "ascending"
            }
          }
        },
        "layer": [
          {
            "encoding": {
              "color": {
                "field": "group",
                "type": "nominal",
                "scale": {
                  "scheme": "magma"
                },
                "legend": {
                  "title": "Group",
                  "values": [
                    "G2",
                    "G1"
                  ]
                }
              }
            },
            "mark": "point"
          },
          {
            "mark": "rule",
            "encoding": {
              "color": {
                "field": "group",
                "type": "nominal",
                "scale": {
                  "scheme": "magma"
                },
                "legend": {
                  "title": "Group",
                  "values": [
                    "G2",
                    "G1"
                  ]
                }
              },
              "x": {
                "field": "lower_CI_auc",
                "type": "quantitative",
                "axis": {
                  "title": "AUC"
                }
              },
              "x2": {
                "field": "upper_CI_auc"
              }
            }
          }
        ]
      } 

