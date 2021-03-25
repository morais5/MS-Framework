Printer = {}

$(document).ready(function(){
    window.addEventListener('message', function(event){
        var action = event.data.action;

        switch(action) {
            case "open":
                Printer.Open(event.data);
                break;
            case "close":
                Printer.Close(event.data);
                break;
        }
    });
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Printer.Close();
            break;
        case 9: // ESC
            Printer.Close();
            break;
    }
});

Printer.Open = function(data) {
    if (data.url) {
        $(".document-container").fadeIn(150);
        $(".document-image").attr('src', data.url);
    } else {
        console.log('No document has been linked!!!!!')
    }
}

Printer.Close = function(data) {
    $(".document-container").fadeOut(150);
    $.post('http://qb-printer/CloseDocument');
}