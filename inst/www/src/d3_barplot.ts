// !preview r2d3 data=data
/// <reference path = "dv_d3_helpers.ts">

// Here we define the function and the call is done at the end of the file
let chart = function (
  Shiny: any,
  //@ts-ignore
  d3: typeof d3,
  r2d3: any,
  data: any,
  svg: any,
  t_width: number,
  t_height: number,
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
    y: number;
    z: string;
    color: string;
    label: string;
  }

  /**
   * Describes the set of options received by the script
   */
  interface options_array {
    parent: string;
    x_axis: boolean;
    y_axis: boolean;
    z_axis: boolean;
    ns_str: string;
    sorted_x: string[];
    margin: margin_object;
    palette: palette;
    quiet: boolean;
    y_baseline: number;
    x_title: string;
    y_title: string;
    msg_func: string;
  }
  [];

  // CONSTANTS ===========================================================

  const ns = dvd3h.NS(options.ns_str);
  const deb_log = dvd3h.deb_log_factory(options.quiet);
  const send_input_value = dvd3h.send_input_value_factory(Shiny);

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
          VPADDING: 10,
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
    BAR: {
      ID: "bar",
      PADDING: {
        X: 0.1,
      },
      LABEL: {
        ID: "label",
        MAX_SIZE: 20,
        PADDING_PERC: 0.9,
        ROTATION: 90,
      },
    },
  };

  // INIT =================================================================

  // Scale
  let x_scale = d3.scaleBand();
  let y_scale = d3.scaleLinear();
  let z_scale = d3.scaleOrdinal();

  // ELEMENTS ==============================================================
  // SVG
  let mySvg = svg.append("g").attr("id", ns(C.SVG.ID));

  // Chart
  let myBars = mySvg.append("g").attr("id", ns(C.BAR.ID));
  let myLabels = mySvg.append("g").attr("id", ns(C.BAR.LABEL.ID));

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

    const y_baseline =
      options.y_baseline !== undefined ? options.y_baseline : 0;

    const x_title = options.y_title !== undefined ? options.x_title : null;
    const y_title = options.y_title !== undefined ? options.y_title : null;

    let height = t_height - options.margin.top - options.margin.bottom;
    let width = t_width - options.margin.left - options.margin.right;

    let domain_x = dvd3h.is_null_undef(options.sorted_x)
      ? dvd3h.unique_array(data.map((e) => e.x))
      : options.sorted_x;
    let domain_y = [
      Math.min(y_baseline, ...data.map((e) => e.y)),
      Math.max(y_baseline, ...data.map((e) => e.y)),
    ];
    let domain_z = options.palette.values;

    // Draw, calculate and return margins ==================

    deb_log("translating initial svg");
    mySvg.attr(
      "transform",
      "translate(" + options.margin.left + "," + options.margin.top + ")"
    );

    // X ====
    x_scale.range([1, width]).domain(domain_x).padding(C.BAR.PADDING.X);
    x_axis_el.selectAll("*").remove(); // Delete axis before adding a new one
    if (options.x_axis !== null) {
      deb_log("Plotting X(S)");
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
      deb_log("Plotting X (E)");
    }

    // Y ====
    y_axis_el.selectAll("*").remove(); // Delete title before adding a new one
    y_scale.range([height, 1]).domain(domain_y);
    if (options.y_axis !== null) {
      deb_log("Plotting Y(S)");
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
      deb_log("Plotting Y(E)");
    }

    // Z ====
    z_axis_el.selectAll("*").remove();
    z_scale.domain(domain_z).range(options.palette.colors);
    if (options.z_axis !== null) {
      deb_log("Plotting Z(S)");
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
      deb_log("Plotting Z(E)");
    }

    // Send requested margins ====
    send_input_value(ns("margin"), requested_margin);
    deb_log(requested_margin);

    // TOOLTIP ================================================================

    deb_log("tooltip");
    // If a previous tooltip exists remove it
    // It does not get removed by redraw as it does not exist in the svg but as an absolute HTML element in the parent div
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

    deb_log("bars");
    myBars
      .selectAll("rect")
      .data(data, function (d: data_entry) {
        return d.x + ":" + d.y + ":" + d.z;
      })
      .join("rect")
      .attr("x", function (d: data_entry) {
        return x_scale(d.x);
      })
      .attr("y", function (d: data_entry) {
        return d.y < 0 ? y_scale(0) : y_scale(d.y);
      })
      .attr("width", x_scale.bandwidth())
      .attr("height", (d: data_entry) => {
        let h;
        if (d.y >= 0) {
          h = y_scale(0) - y_scale(d.y);
          return Math.max(h, 1);
        } else {
          h = y_scale(d.y) - y_scale(0);
          return Math.max(h, 1);
        }
      })
      .style("fill", (d: data_entry) => {
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

    deb_log("labels");
    // Labels
    myLabels
      .selectAll("text")
      .data(data, function (d: data_entry) {
        return d.x + ":" + d.y + ":" + d.z;
      })
      .join("text")
      .attr("text-anchor", "start")
      .attr(
        "font-size",
        Math.min(
          C.BAR.LABEL.MAX_SIZE,
          x_scale.bandwidth() * C.BAR.LABEL.PADDING_PERC
        )
      )
      .attr("transform", function (d: any) {
        let y_trans = y_scale(0);
        let x_trans;
        let rotation;
        if (d.y >= 0) {
          x_trans =
            x_scale(d.x) +
            x_scale.bandwidth() -
            x_scale.bandwidth() * (1 - C.BAR.LABEL.PADDING_PERC);
          rotation = -C.BAR.LABEL.ROTATION;
        } else {
          x_trans =
            x_scale(d.x) + x_scale.bandwidth() * (1 - C.BAR.LABEL.PADDING_PERC);
          rotation = C.BAR.LABEL.ROTATION;
        }

        return `translate(${x_trans},${y_trans}
        )rotate(${rotation})`;
      })
      .text(function (d: data_entry) {
        return d.label;
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
    deb_log("end");
  };

  r2d3.onRender(onRenderCallback);
};

// All these parameters come from an r2d3 call
//@ts-ignore
chart(
  //@ts-ignore
  typeof Shiny !== "undefined" ? Shiny : null,
  //@ts-ignore
  d3,
  //@ts-ignore
  r2d3,
  //@ts-ignore
  data,
  //@ts-ignore
  svg,
  //@ts-ignore
  width,
  //@ts-ignore
  height,
  //@ts-ignore
  options,
  //@ts-ignore
  theme,
  //@ts-ignore
  console
);
