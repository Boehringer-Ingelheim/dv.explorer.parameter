Shiny.addCustomMessageHandler("dv_bm_toggle_warning_mark", (message) => {
    const { id, add_mark } = message;
    const element = document.getElementById(id);

    console.log(message)

    if (element) {
      if (add_mark) {
        console.log("add")
        element.classList.add('dv-bm-warning-text');
      } else {
        console.log("remove")
        element.classList.remove('dv-bm-warning-text');
      }
    } else {
      console.error(`Element with ID '${id}' not found.`);
    }
  });