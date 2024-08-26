Shiny.addCustomMessageHandler("get-screenshot", async function(event){
    
    const PADDING = 5;
    
    // Containers
    let container_svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    let cont_width = 0;
    let cont_height = 0;

    // Search for each of the svg's
    let wf_svg = document.getElementById(event.container);
    let svg_charts = wf_svg.getElementsByTagName('svg');

    let isVisible = function(el) {
        return(window.getComputedStyle(el).getPropertyValue('visibility')==='visible');
    };
    
    [...svg_charts]
        .filter((el)=>isVisible(el))
        .forEach(function(el){            
            let this_svg = el.cloneNode(true);
            // Conserve font family css the only applied
            //svg_font = window.getComputedStyle( this_svg, null ).getPropertyValue( 'font-family' );        

            // Append new svg
            let this_group = document.createElementNS("http://www.w3.org/2000/svg", "g")
            this_group.appendChild(this_svg);
            // Transform group
            this_group.setAttribute("transform", `translate(0, ${cont_height+PADDING})`);

            container_svg.appendChild(this_group);

            // Resize container
            cont_width = Math.max(cont_width, this_svg.width.baseVal.value);
            cont_height += this_svg.height.baseVal.value + PADDING;
        })
        console.log("Stacked svgs")

    // Force font family
    container_svg.style.fontFamily = "Arial, sans-serif";    

    let svgXML = new XMLSerializer().serializeToString( container_svg );    

    if(event.as_png === true){
        let canvas = document.createElement( "canvas" );
        let scaleFactor = event.chart_width/cont_width;
        canvas.width = event.chart_width;
        canvas.height = cont_height*scaleFactor;
                              
        let ctx = canvas.getContext( "2d" );
        ctx.scale(scaleFactor, scaleFactor);

        const img = document.createElement('img');
                
        let dataUri = '';
        dataUri = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(svgXML);        

        img.onload = function() {            

            // SVG and PNG approach can very likely be unified so they use the same download strategy
            
            ctx.drawImage( img, 0, 0 );                
            // Try to initiate a download of the image
            let downloadLink = document.createElement("a");
            downloadLink.download = event.filename;
            downloadLink.href = canvas.toDataURL("image/png");
            downloadLink.download = event.filename;
            downloadLink.click();
            downloadLink.remove();
        };
        img.src = dataUri;
    } else {
        const blob = new Blob([svgXML], { type: 'image/svg+xml' });

        // Create a URL for the Blob
        const url = URL.createObjectURL(blob);
        
        // Create a download link
        const downloadLink = document.createElement('a');
        downloadLink.href = url;
        downloadLink.download = event.filename; // Specify the filename
        
        // Trigger a click event on the download link
        downloadLink.click();
        
        // Clean up: Revoke the URL and remove the download link
        URL.revokeObjectURL(url);
    }
})