# produce dens spec (Snapshot)__spec_ids{roc$outputs$density$facets;roc$outputs$density$axis;roc$outputs$density$plot}

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
              "dens_x": 0,
              "dens_y": null
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "B",
              "dens_x": 0,
              "dens_y": null
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "A",
              "dens_x": 0,
              "dens_y": null
            },
            {
              "predictor_parameter": "P2",
              "group": "G2",
              "response_value": "A",
              "dens_x": 2,
              "dens_y": null
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "A",
              "dens_x": null,
              "dens_y": 0
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "B",
              "dens_x": null,
              "dens_y": 0
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "A",
              "dens_x": null,
              "dens_y": 0
            },
            {
              "predictor_parameter": "P2",
              "group": "G2",
              "response_value": "A",
              "dens_x": null,
              "dens_y": 2
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "A",
              "dens_x": 0,
              "dens_y": 0
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "A",
              "dens_x": 1,
              "dens_y": 1
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "B",
              "dens_x": 2,
              "dens_y": 2
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "B",
              "dens_x": 3,
              "dens_y": 3
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "A",
              "dens_x": 4,
              "dens_y": 4
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "A",
              "dens_x": 10,
              "dens_y": 5
            },
            {
              "predictor_parameter": "P2",
              "group": "G2",
              "response_value": "A",
              "dens_x": 2,
              "dens_y": 2
            },
            {
              "predictor_parameter": "P2",
              "group": "G2",
              "response_value": "A",
              "dens_x": 3,
              "dens_y": 3
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "A",
              "dens_x": 10,
              "dens_y": null
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "B",
              "dens_x": 10,
              "dens_y": null
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "A",
              "dens_x": 10,
              "dens_y": null
            },
            {
              "predictor_parameter": "P2",
              "group": "G2",
              "response_value": "A",
              "dens_x": 3,
              "dens_y": null
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "A",
              "dens_x": null,
              "dens_y": 5
            },
            {
              "predictor_parameter": "P1",
              "group": "G1",
              "response_value": "B",
              "dens_x": null,
              "dens_y": 5
            },
            {
              "predictor_parameter": "P1",
              "group": "G2",
              "response_value": "A",
              "dens_x": null,
              "dens_y": 5
            },
            {
              "predictor_parameter": "P2",
              "group": "G2",
              "response_value": "A",
              "dens_x": null,
              "dens_y": 3
            }
          ]
        },
        "spec": {
          "encoding": {
            "x": {
              "field": "dens_x",
              "type": "quantitative",
              "stack": false,
              "axis": {
                "title": "Value"
              }
            },
            "y": {
              "field": "dens_y",
              "type": "quantitative",
              "stack": false,
              "axis": {
                "title": "Density"
              }
            },
            "color": {
              "field": "response_value",
              "type": "nominal",
              "stack": false,
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
          },
          "layer": [
            {
              "mark": {
                "type": "area"
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

# produce dens spec ungrouped (Snapshot)__spec_ids{roc$outputs$density$facets;roc$outputs$density$axis;roc$outputs$density$plot}

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
              "dens_x": 0,
              "dens_y": 0
            },
            {
              "predictor_parameter": "P1",
              "response_value": "A",
              "dens_x": 1,
              "dens_y": 1
            },
            {
              "predictor_parameter": "P1",
              "response_value": "B",
              "dens_x": 2,
              "dens_y": 2
            },
            {
              "predictor_parameter": "P1",
              "response_value": "B",
              "dens_x": 3,
              "dens_y": 3
            },
            {
              "predictor_parameter": "P1",
              "response_value": "A",
              "dens_x": 4,
              "dens_y": 4
            },
            {
              "predictor_parameter": "P1",
              "response_value": "A",
              "dens_x": 10,
              "dens_y": 5
            },
            {
              "predictor_parameter": "P2",
              "response_value": "A",
              "dens_x": 2,
              "dens_y": 2
            },
            {
              "predictor_parameter": "P2",
              "response_value": "A",
              "dens_x": 3,
              "dens_y": 3
            }
          ]
        },
        "spec": {
          "encoding": {
            "x": {
              "field": "dens_x",
              "type": "quantitative",
              "stack": false,
              "axis": {
                "title": "Value"
              }
            },
            "y": {
              "field": "dens_y",
              "type": "quantitative",
              "stack": false,
              "axis": {
                "title": "Density"
              }
            },
            "color": {
              "field": "response_value",
              "type": "nominal",
              "stack": false,
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
          },
          "layer": [
            {
              "mark": {
                "type": "area"
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

