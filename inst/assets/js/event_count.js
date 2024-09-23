var ec_collapse = function (element) {
    let parent_tr = element.closest("tr");
    let indent = parent_tr.getAttribute("indent");
    let child_hidden = parent_tr.hasAttribute("child-hidden");

    if (!child_hidden) { parent_tr.setAttribute("child-hidden", "") } else { parent_tr.removeAttribute("child-hidden") }

    let curr_sibling = parent_tr.nextElementSibling;
    while (curr_sibling !== null && curr_sibling.getAttribute("indent") > indent) {
        if (child_hidden) {
            curr_sibling.classList.remove('hidden')
            curr_sibling.removeAttribute("child-hidden")
        } else {
            curr_sibling.classList.add('hidden')
            curr_sibling.setAttribute("child-hidden", "")
        }
        curr_sibling = curr_sibling.nextElementSibling;
    }
};
