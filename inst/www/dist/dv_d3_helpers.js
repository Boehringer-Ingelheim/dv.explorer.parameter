"use strict";
///<reference path = "_interfaces.ts">
/**
 * DaVinci helpers for d3
 * @namespace dvd3h
 */
let dvd3h = {
    /**
     * Add a namespace to the object id
     * @param {string} id A name to be namespaced
     * @return {Function}
     */
    NS: function (namespace) {
        return function (id) {
            return namespace + "-" + id;
        };
    },
    /**
     * Returns a logging function
     * @param {boolean} quiet If quiet then loggin will be silenced
     * @return {Function}
     */
    deb_log_factory: function (quiet) {
        if (!quiet) {
            return function (msg) {
                console.log(msg);
            };
        }
        else {
            return function (msg) { };
        }
    },
    /**
     * Checks the palette consists of values and colors
     * @param {Object} palette
     * @return {boolean}
     */
    is_palette: function (palette) {
        return (palette.colors !== undefined &&
            palette.colors !== null &&
            palette.values !== undefined &&
            palette.values !== null);
    },
    /**
     * Returns the height of an element
     * @param {any} el The element to be measured
     * @returns {number}
     */
    calc_el_height: function (el) {
        return Math.ceil(el.node().getBBox().height);
    },
    /**
     * Returns the width of an element
     * @param {any} el The element to be measured
     * @returns {number}
     */
    calc_el_width: function (el) {
        return Math.ceil(el.node().getBBox().width);
    },
    /**
     * Returns a prebacked function with the set properties
     * @param {any} Shiny The Shiny javascript object
     * @returns {Function}
     */
    send_input_value_factory: function (Shiny, priority = null) {
        // Happens when the visualization is running outside of Shiny and in a normal viewer
        if (dvd3h.is_null_undef(Shiny)) {
            return function (id, msg) {
                // We do nothing in this case
            };
        }
        if (priority === null) {
            return function (id, msg) {
                Shiny.setInputValue(id, msg);
            };
        }
        else {
            return function (id, msg) {
                Shiny.setInputValue(id, msg, {
                    priority: priority,
                });
            };
        }
    },
    /**
     * Returns true if an object is null or undef
     * @param {any} x The object to be tested
     * @returns {boolean}
     */
    is_null_undef: function (x) {
        return x === null || x === undefined;
    },
    /**
     * Returns the unique values of the array x
     * @param {any[]} x An array
     * @returns {any[]}
     */
    unique_array: function (a) {
        function onlyUnique(value, index, self) {
            return self.indexOf(value) === index;
        }
        return a.filter(onlyUnique);
    },
    mid_point: function (x, y) {
        if (x === y)
            return x;
        let max = Math.max(x, y);
        let min = Math.min(x, y);
        return min + (max - min) / 2;
    },
    def_tooltip: {
        append: function (el, id) {
            return el
                .append("div")
                .style("position", "absolute")
                .attr("id", id)
                .style("background-color", "white")
                .style("border", "solid")
                .style("border-width", "2px")
                .style("border-radius", "5px")
                .style("padding", "5px")
                .style("top", "0px")
                .style("opacity", 0)
                .style("visibility", "hidden");
        },
        mouseover_factory: function (tooltip) {
            return function (_event, _d) {
                tooltip.style("opacity", 1).style("visibility", "visible");
            };
        },
        mousemove_factory: function (tooltip, msg_func = null) {
            let solved_get_msg = dvd3h.is_null_undef(msg_func)
                ? (d) => `${d.x}<br>${d.y}<br>${d.z}<br>`
                : msg_func;
            return function (event, d) {
                let findFirstDivUpstream = function (element) {
                    let currentElement = element.parentElement;
                    while (currentElement !== null) {
                        if (currentElement.tagName.toLowerCase() === 'div') {
                            return currentElement;
                        }
                        currentElement = currentElement.parentElement;
                    }
                    throw new Error('No parent div element found');
                };
                let container = findFirstDivUpstream(event.srcElement);
                let x_root = container.getBoundingClientRect().x;
                let y_root = container.getBoundingClientRect().y;
                let width_root = container.getBoundingClientRect().width;
                let height_root = container.getBoundingClientRect().height;
                let x_coord = event.pageX - x_root;
                let y_coord = event.pageY - y_root;
                let is_left_half = x_coord < width_root / 2;
                let is_upper_half = y_coord < height_root / 2;
                let x_trans = is_left_half ? "0%" : "-100%";
                let y_trans = is_upper_half ? "0%" : "-100%";
                tooltip
                    .html(solved_get_msg(d))
                    .style("left", x_coord + "px")
                    .style("top", y_coord + "px")
                    .style("display", null)
                    .style(
                /* Change the tooltip position with respect to the mouse
               depending on the position in the chart to avoid overflowing*/
                "transform", `translate(${x_trans}, ${y_trans})`);
            };
        },
        mouseleave_factory: function (tooltip) {
            return function (_event, _d) {
                tooltip.style("visibility", "hidden").style("opacity", 0);
            };
        },
    },
    // Copyright 2021, Observable Inc.
    // Released under the ISC license.
    // https://observablehq.com/@d3/color-legend
    get_legend: function (d3, color, { title, tickSize = 0, width = 40, height = 10, marginTop = 0, marginRight = 0 + tickSize, marginBottom = 0, marginLeft = 0 + tickSize, ticks = height / 64, tickFormat, tickValues, } = {}) {
        function ramp(color, n = 256) {
            const canvas = document.createElement("canvas");
            canvas.width = 1;
            canvas.height = n;
            const context = canvas.getContext("2d");
            for (let i = 0; i < n; ++i) {
                // @ts-ignore
                context.fillStyle = color(i / (n - 1));
                // @ts-ignore
                context.fillRect(0, n - 1 - i, 1, 1);
            }
            return canvas;
        }
        const svg = d3
            .create("svg")
            .attr("width", width)
            .attr("height", height)
            .attr("viewBox", [0, 0, width, height])
            .style("overflow", "visible")
            .style("display", "block");
        let tickAdjust = (g) => g.selectAll(".tick line").attr("y1", marginTop + marginBottom - height);
        let x;
        // Continuous
        if (color.interpolate) {
            const n = Math.min(color.domain().length, color.range().length);
            x = color
                .copy()
                .rangeRound(d3.quantize(d3.interpolate(height - marginBottom, marginTop), n));
            svg
                .append("image")
                .attr("x", marginLeft)
                .attr("y", marginTop)
                .attr("width", width - marginLeft - marginRight)
                .attr("height", height - marginTop - marginBottom)
                .attr("preserveAspectRatio", "none")
                .attr("xlink:href", ramp(color.copy().domain(d3.quantize(d3.interpolate(0, 1), n))).toDataURL());
        }
        // Sequential
        else if (color.interpolator) {
            x = Object.assign(color
                .copy()
                .interpolator(d3.interpolateRound(height - marginBottom, marginTop)), {
                range() {
                    return [height - marginBottom, marginTop];
                },
            });
            svg
                .append("image")
                .attr("x", marginLeft)
                .attr("y", marginTop)
                .attr("width", width - marginLeft - marginRight)
                .attr("height", height - marginTop - marginBottom)
                .attr("preserveAspectRatio", "none")
                .attr("xlink:href", ramp(color.interpolator()).toDataURL());
            // scaleSequentialQuantile doesn’t implement ticks or tickFormat.
            if (!x.ticks) {
                if (tickValues === undefined) {
                    const n = Math.round(ticks + 1);
                    tickValues = d3
                        .range(n)
                        .map((i) => d3.quantile(color.domain(), i / (n - 1)));
                }
                if (typeof tickFormat !== "function") {
                    tickFormat = d3.format(tickFormat === undefined ? ",f" : tickFormat);
                }
            }
        }
        // Threshold
        else if (color.invertExtent) {
            const thresholds = color.thresholds
                ? color.thresholds() // scaleQuantize
                : color.quantiles
                    ? color.quantiles() // scaleQuantile
                    : color.domain(); // scaleThreshold
            const thresholdFormat = tickFormat === undefined
                ? (d) => d
                : typeof tickFormat === "string"
                    ? d3.format(tickFormat)
                    : tickFormat;
            x = d3
                .scaleLinear()
                .domain([-1, color.range().length - 1])
                .rangeRound([marginLeft, width - marginRight]);
            svg
                .append("g")
                .selectAll("rect")
                .data(color.range())
                .join("rect")
                .attr("x", (d, i) => x(i - 1))
                .attr("y", marginTop)
                .attr("width", (d, i) => x(i) - x(i - 1))
                .attr("height", height - marginTop - marginBottom)
                .attr("fill", (d) => d);
            tickValues = d3.range(thresholds.length);
            tickFormat = (i) => thresholdFormat(thresholds[i], i);
        }
        // Ordinal
        else {
            x = d3
                .scaleBand()
                .domain(color.domain())
                .rangeRound([marginTop, height - marginBottom]);
            svg
                .append("g")
                .selectAll("rect")
                .data(color.domain())
                .join("rect")
                .attr("x", marginTop)
                .attr("y", x)
                .attr("height", Math.max(0, x.bandwidth() - 1))
                .attr("width", width - marginLeft - marginRight)
                .attr("fill", color);
            tickAdjust = () => { };
        }
        svg
            .append("g")
            .attr("transform", `translate(${width},0)`)
            .call(d3
            .axisRight(x)
            .ticks(ticks, typeof tickFormat === "string" ? tickFormat : undefined)
            .tickFormat(typeof tickFormat === "function" ? tickFormat : undefined)
            .tickSize(tickSize)
            .tickValues(tickValues))
            // .call(tickAdjust)
            .call((g) => g.select(".domain").remove())
            .call((g) => g
            .append("text")
            .attr("x", marginTop + marginBottom - height - 6)
            .attr("y", marginLeft)
            .attr("fill", "currentColor")
            .attr("text-anchor", "start")
            .attr("font-weight", "bold")
            .attr("class", "title")
            .text(title));
        return svg.node();
    },
};
