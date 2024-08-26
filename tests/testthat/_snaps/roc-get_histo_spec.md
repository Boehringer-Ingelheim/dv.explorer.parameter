# produce histo spec (Snapshot)__spec_ids{roc$outputs$histogram$facets;roc$outputs$histogram$axis;roc$outputs$histogram$plot}

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
              "response_value": "A",
              "bin_start": 0,
              "bin_end": 2,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "A",
              "bin_start": 2,
              "bin_end": 4,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "A",
              "bin_start": 4,
              "bin_end": 6,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "A",
              "bin_start": 6,
              "bin_end": 8,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "B",
              "bin_start": 0,
              "bin_end": 2,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "B",
              "bin_start": 2,
              "bin_end": 4,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "B",
              "bin_start": 4,
              "bin_end": 6,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "B",
              "bin_start": 6,
              "bin_end": 8,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "A",
              "bin_start": 0,
              "bin_end": 2,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "A",
              "bin_start": 2,
              "bin_end": 4,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "A",
              "bin_start": 4,
              "bin_end": 6,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "A",
              "bin_start": 6,
              "bin_end": 8,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "B",
              "bin_start": 0,
              "bin_end": 2,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "B",
              "bin_start": 2,
              "bin_end": 4,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "B",
              "bin_start": 4,
              "bin_end": 6,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "B",
              "bin_start": 6,
              "bin_end": 8,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P3",
              "group": "G1",
              "response_value": "A",
              "bin_start": 9,
              "bin_end": 10,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P3",
              "group": "G1",
              "response_value": "A",
              "bin_start": 10,
              "bin_end": 11,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P3",
              "group": "G1",
              "response_value": "A",
              "bin_start": 11,
              "bin_end": 12,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P3",
              "group": "G1",
              "response_value": "B",
              "bin_start": 9,
              "bin_end": 10,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P3",
              "group": "G1",
              "response_value": "B",
              "bin_start": 10,
              "bin_end": 11,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P3",
              "group": "G1",
              "response_value": "B",
              "bin_start": 11,
              "bin_end": 12,
              "bin_count": 1
            }
          ]
        },
        "spec": {
          "layer": [
            {
              "mark": {
                "type": "rect"
              },
              "encoding": {
                "x": {
                  "field": "bin_start",
                  "type": "quantitative",
                  "axis": {
                    "title": "Value"
                  },
                  "scale": {
                    "zero": false
                  }
                },
                "x2": {
                  "field": "bin_end"
                },
                "y": {
                  "field": "bin_count",
                  "type": "quantitative",
                  "axis": {
                    "title": "Count"
                  }
                },
                "y2": {
                  "datum": 0
                },
                "color": {
                  "field": "response_value",
                  "type": "nominal",
                  "scale": {
                    "scheme": "magma"
                  },
                  "legend": {
                    "title": "Response"
                  }
                },
                "opacity": {
                  "value": 0.7
                }
              }
            }
          ],
          "width": 50,
          "height": 50
        },
        "resolve": {
          "scale": {
            "x": "independent",
            "y": "independent"
          }
        },
        "facet": {
          "column": {
            "field": "group",
            "title": "Group"
          },
          "row": {
            "field": "predictor_parameter",
            "title": "Parameter"
          }
        }
      } 

# produce histo spec. Ungrouped. (Snapshot)__spec_ids{roc$outputs$histogram$facets;roc$outputs$histogram$axis;roc$outputs$histogram$plot}

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
              "response_value": "A",
              "bin_start": 0,
              "bin_end": 2,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "response_value": "A",
              "bin_start": 2,
              "bin_end": 4,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "response_value": "A",
              "bin_start": 4,
              "bin_end": 6,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "response_value": "A",
              "bin_start": 6,
              "bin_end": 8,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "response_value": "B",
              "bin_start": 0,
              "bin_end": 2,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "response_value": "B",
              "bin_start": 2,
              "bin_end": 4,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "response_value": "B",
              "bin_start": 4,
              "bin_end": 6,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P1",
              "response_value": "B",
              "bin_start": 6,
              "bin_end": 8,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P3",
              "response_value": "A",
              "bin_start": 91,
              "bin_end": 92,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P3",
              "response_value": "A",
              "bin_start": 92,
              "bin_end": 93,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P3",
              "response_value": "A",
              "bin_start": 93,
              "bin_end": 94,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P3",
              "response_value": "B",
              "bin_start": 91,
              "bin_end": 92,
              "bin_count": 1
            },
            {
              "predictor_parameter": "P3",
              "response_value": "B",
              "bin_start": 92,
              "bin_end": 93,
              "bin_count": 0
            },
            {
              "predictor_parameter": "P3",
              "response_value": "B",
              "bin_start": 93,
              "bin_end": 94,
              "bin_count": 1
            }
          ]
        },
        "spec": {
          "layer": [
            {
              "mark": {
                "type": "rect"
              },
              "encoding": {
                "x": {
                  "field": "bin_start",
                  "type": "quantitative",
                  "axis": {
                    "title": "Value"
                  },
                  "scale": {
                    "zero": false
                  }
                },
                "x2": {
                  "field": "bin_end"
                },
                "y": {
                  "field": "bin_count",
                  "type": "quantitative",
                  "axis": {
                    "title": "Count"
                  }
                },
                "y2": {
                  "datum": 0
                },
                "color": {
                  "field": "response_value",
                  "type": "nominal",
                  "scale": {
                    "scheme": "magma"
                  },
                  "legend": {
                    "title": "Response"
                  }
                },
                "opacity": {
                  "value": 0.7
                }
              }
            }
          ],
          "width": 50,
          "height": 50
        },
        "resolve": {
          "scale": {
            "x": "independent",
            "y": "independent"
          }
        },
        "facet": {
          "column": {
            "field": "predictor_parameter",
            "title": "Parameter"
          }
        }
      } 

