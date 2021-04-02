$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var item = event.data;

        if (item.action == "http") {
            httpGetAsync(item.url, (response) => {});
        }
    });
});

function httpGetAsync(theUrl, callback) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
            callback(xmlHttp.responseText);
    }
    xmlHttp.open("GET", theUrl, true); // true for asynchronous 
    xmlHttp.send(null);
}
