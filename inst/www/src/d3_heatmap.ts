// !preview r2d3 data=data
/// <reference path = "dv_d3_helpers.ts">
// Helper

// Here we define the function and the call is done at the end of the file
let hm_chart = function (
  Shiny: any,
  //@ts-ignore
  d3: typeof _d3,
  r2d3: any,
  data: any,
  svg: any,
  width: number,
  height: number,
  options: any,
  _theme: any,
  _console: any
) {
  // INTERFACES
  /**
   * Describes one entry of the data variable
   */
  interface data_entry {
    //TODO: Generalize to other types for now this is enough
    x: string; // Categorical
    y: string; // Numerical
    z: string | number; // Numerical
    color: string;
    label: string;
  }

  interface options_array {
    parent: string;
    x_axis: boolean;
    y_axis: boolean;
    z_axis: boolean;
    ns_str: string;
    sorted_x: string[];
    sorted_y: string[];
    margin: { top: number; bottom: number; right: number; left: number };
    palette: palette;
    quiet: boolean;
    x_title: string;
    y_title: string;
    msg_func: string;
  }
  [];

  // CONSTANTS ===========================================================

  const ns = dvd3h.NS(options.ns_str);
  const deb_log = dvd3h.deb_log_factory(options.quiet);
  const send_input_value = dvd3h.send_input_value_factory(Shiny);
  const is_categorical = function (x: any[]) {
    return typeof x[0] === "string";
  };

  const C = {
    SVG: { ID: "svg" },
    TITLE: { ID: "title" },
    AXIS: {
      X: {
        ID: "x_axis",
        LAB: {
          ROTATION: 90,
          ANCHOR: "start",
          HEIGHT: ".35em",
          X: 9,
          Y: 0,
        },
        TITLE: {
          ID: "x_title",
          ANCHOR: "middle",
          FILL: "currentColor",
          VPADDING: 15,
          FONTSIZE: "1.25em",
        },
      },
      Y: {
        ID: "y_axis",
        TITLE: {
          ID: "y_title",
          ROTATION: -90,
          ANCHOR: "middle",
          FILL: "currentColor",
          HPADDING: 10,
          FONTSIZE: "1.25em",
        },
      },
      Z: {
        ID: "z_axis",
        MARGIN: { TOP: 5, BOTTOM: 5, RIGHT: 5, LEFT: 5 },
        WIDTH: 20,
        TICKS: 4,
      },
    },
    TOOLT: { ID: "tooltip" },
    TILE: {
      ID: "tile",
      PADDING: {
        X: 0.1,
        Y: 0,
      },
      LABEL: {
        ID: "label",
        MAX_SIZE: 20,
        PADDING_PERC: 0.9,
      },
    },
  };

  // INIT =================================================================

  // Scale
  let x_scale = d3.scaleBand();
  let y_scale = d3.scaleBand();
  let z_scale: typeof d3.scaleOrdinal | typeof d3.scaleSequential;

  // VISIBLE CHART
  // SVG
  let mySvg = svg.append("g").attr("id", ns(C.SVG.ID));

  // Chart
  let tiles = mySvg.append("g").attr("id", ns(C.TILE.ID));
  let labels = mySvg.append("g").attr("id", ns(C.TILE.LABEL.ID));

  // Axis
  let x_axis_el = mySvg.append("g").attr("id", ns(C.AXIS.X.ID));
  let y_axis_el = mySvg.append("g").attr("id", ns(C.AXIS.Y.ID));
  let z_axis_el = mySvg.append("g").attr("id", ns(C.AXIS.Z.ID));

  // OnRender Callback =====================================================

  const onRenderCallback = function (
    data: data_entry[],
    _svg: any,
    t_width: number,
    t_height: number,
    options: options_array
  ) {
    let requested_margin: margin_object = {
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
    };

    const x_title = options.y_title !== undefined ? options.x_title : null;
    const y_title = options.y_title !== undefined ? options.y_title : null;

    let is_z_categorical = is_categorical(data.map((e) => e.z));

    z_scale = is_z_categorical ? d3.scaleOrdinal() : d3.scaleLinear();

    let height = t_height - options.margin.top - options.margin.bottom;
    let width = t_width - options.margin.left - options.margin.right;

    let domain_x = dvd3h.is_null_undef(options.sorted_x)
      ? dvd3h.unique_array(data.map((e) => e.x))
      : options.sorted_x;

    let domain_y = dvd3h.is_null_undef(options.sorted_y)
      ? dvd3h.unique_array(data.map((e) => e.y))
      : options.sorted_y;

    let domain_z = options.palette.values;

    mySvg.attr(
      "transform",
      "translate(" + options.margin.left + "," + options.margin.top + ")"
    );

    x_axis_el.selectAll("*").remove();
    x_scale.range([1, width]).domain(domain_x).padding(C.TILE.PADDING.X);
    if (options.x_axis !== null) {
      deb_log("Plotting X");
      x_axis_el
        .call(d3.axisBottom(x_scale))
        .attr("transform", `translate(0, ${height})`)
        .selectAll("text")
        .attr("x", C.AXIS.X.LAB.X)
        .attr("y", C.AXIS.X.LAB.Y)
        .attr("dy", C.AXIS.X.LAB.HEIGHT)
        .attr("transform", `rotate(${C.AXIS.X.LAB.ROTATION})`)
        .style("text-anchor", C.AXIS.X.LAB.ANCHOR);

      if (x_title !== null) {
        x_axis_el
          .append("g")
          .attr("id", ns(C.AXIS.X.TITLE.ID))
          .append("text")
          .attr("fill", C.AXIS.X.TITLE.FILL)
          .attr("text-anchor", C.AXIS.X.TITLE.ANCHOR)
          .attr("font-size", C.AXIS.X.TITLE.FONTSIZE)
          // Translate to the width of the element plus padding
          .attr(
            "transform",
            `translate(${dvd3h.mid_point(
              x_scale.range()[0],
              x_scale.range()[1]
            )}, ${dvd3h.calc_el_height(x_axis_el) + C.AXIS.X.TITLE.VPADDING})`
          )
          .text(x_title);
      }

      requested_margin.bottom = dvd3h.calc_el_height(x_axis_el);
    }

    y_axis_el.selectAll("*").remove();
    y_scale.range([1, height]).domain(domain_y).padding(C.TILE.PADDING.Y);
    if (options.y_axis !== null) {
      deb_log("Plotting Y");
      y_axis_el.call(d3.axisLeft(y_scale));
      if (y_title !== null) {
        y_axis_el
          .append("g")
          .attr("id", ns(C.AXIS.Y.TITLE.ID))
          .append("text")
          .attr("fill", C.AXIS.Y.TITLE.FILL)
          .attr("text-anchor", C.AXIS.Y.TITLE.ANCHOR)
          .attr("font-size", C.AXIS.Y.TITLE.FONTSIZE)
          // Translate to the width of the element plus padding
          .attr(
            "transform",
            `translate(${
              -dvd3h.calc_el_width(y_axis_el) - C.AXIS.Y.TITLE.HPADDING
            }, ${dvd3h.mid_point(
              y_scale.range()[0],
              y_scale.range()[1]
            )})rotate(${C.AXIS.Y.TITLE.ROTATION})`
          )
          .text(y_title);
      }
      requested_margin.left = dvd3h.calc_el_width(y_axis_el);
    }

    z_axis_el.selectAll("*").remove();
    z_scale.domain(domain_z).range(options.palette.colors);
    if (options.z_axis !== null) {
      deb_log("Plotting Z");
      z_axis_el
        .append("g")
        .attr("transform", "translate(" + (width - 5) + "," + 0 + ")")
        .append(() =>
          dvd3h.get_legend(d3, z_scale, {
            height: height,
            marginTop: 5,
            marginBottom: 5,
            marginLeft: 5,
            marginRight: 5,
            width: 20,
            ticks: 4,
          })
        );
      requested_margin.right = dvd3h.calc_el_width(z_axis_el);
    }

    // Send requested margins ====
    send_input_value(ns("margin"), requested_margin);
    deb_log(requested_margin);

    // TOOLTIP ================================================================

    // If a previous tooltip exists remove it
    // It does not get removed by default as it does not exist in the svg but as an absolute HTML element in the parent div
    let prev_tooltip = document.getElementById(ns(C.TOOLT.ID));
    if (prev_tooltip !== null) prev_tooltip.remove();

    // create a tooltip
    let tooltip = dvd3h.def_tooltip.append(
      d3.select("#" + ns(options.parent)),
      ns(C.TOOLT.ID)
    );

    const mouseover = dvd3h.def_tooltip.mouseover_factory(tooltip);
    const mousemove = dvd3h.def_tooltip.mousemove_factory(
      tooltip,
      eval(options.msg_func)
    );
    const mouseleave = dvd3h.def_tooltip.mouseleave_factory(tooltip);
    //============================== CHART

    tiles
      .selectAll("rect")
      .data(data, function (d: data_entry) {
        return d.x + ":" + d.y + ":" + d.z;
      })
      .join("rect")
      .attr("x", function (d: data_entry) {
        return x_scale(d.x);
      })
      .attr("y", function (d: data_entry) {
        return y_scale(d.y);
      })
      .attr("width", x_scale.bandwidth())
      .attr("height", y_scale.bandwidth())
      .style("fill", function (d: data_entry) {
        if (dvd3h.is_null_undef(d.color)) {
          return d.z === null ? "grey" : z_scale(d.z);          
        } else {
          return d.color;          
        }
      })
      .on("mouseover", function (e: any, d: data_entry) {
        mouseover(e, d);
      })
      .on("mousemove", function (e: any, d: data_entry) {
        mousemove(e, d);
      })
      .on("mouseleave", function (e: any, d: data_entry) {
        mouseleave(e, d);
      });

    // Labels
    labels
      .selectAll("text")
      .data(data, function (d: data_entry) {
        return d.x + ":" + d.y + ":" + d.z;
      })
      .join("text")
      .attr("text-anchor", "start")
      .attr(
        "font-size",
        Math.min(
          C.TILE.LABEL.MAX_SIZE,
          x_scale.bandwidth() * C.TILE.LABEL.PADDING_PERC
        )
      )
      .attr("transform", function (d: any) {
        let x_trans =
          x_scale(d.x) +
          x_scale.bandwidth() -
          x_scale.bandwidth() * (1 - C.TILE.LABEL.PADDING_PERC);

        let y_trans = y_scale(d.y) + y_scale.bandwidth();

        return `translate(${x_trans},${y_trans})rotate(-90)`;
      })
      .text(function (d: data_entry) {
        if (Array.isArray(d.label)) {
          return d.label[0];
        } else {
          return d.label;
        }
      })
      .attr("style", function (d: data_entry) {
        if (Array.isArray(d.label)) {
          return d.label[1];
        } else {
          return "";
        }
      })
      .on("mouseover", function (e: any, d: data_entry) {
        mouseover(e, d);
      })
      .on("mousemove", function (e: any, d: data_entry) {
        mousemove(e, d);
      })
      .on("mouseleave", function (e: any, d: data_entry) {
        mouseleave(e, d);
      });
  };

  r2d3.onRender(onRenderCallback);
};

//@ts-ignore
hm_chart(Shiny, d3, r2d3, data, svg, width, height, options, theme, console);
