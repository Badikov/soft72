$(document).ready(function() {
    $('.taxons-list').treeview({
        animated: "fast",
        collapsed: true,
        unique: true,
        persist: "cookie",
        cookieId: "treeview-black"
    });
});