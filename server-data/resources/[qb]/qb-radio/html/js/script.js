$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "open") {
            QBRadio.SlideUp()
        }

        if (event.data.type == "close") {
            QBRadio.SlideDown()
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://qb-radio/escape', JSON.stringify({}));
            QBRadio.SlideDown()
        } else if (data.which == 13) { // Escape key
            $.post('http://qb-radio/joinRadio', JSON.stringify({
                channel: $("#channel").val()
            }));
        }
    };
});

QBRadio = {}

$(document).on('click', '#submit', function(e){
    e.preventDefault();

    $.post('http://qb-radio/joinRadio', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#disconnect', function(e){
    e.preventDefault();

    $.post('http://qb-radio/leaveRadio');
});

QBRadio.SlideUp = function() {
    $(".container").css("display", "block");
    $(".radio-container").animate({bottom: "6vh",}, 250);
}

QBRadio.SlideDown = function() {
    $(".radio-container").animate({bottom: "-110vh",}, 400, function(){
        $(".container").css("display", "none");
    });
}