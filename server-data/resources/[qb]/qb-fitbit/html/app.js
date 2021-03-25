var openedApp = ".main-screen"

qbFitbit = {}

$(document).ready(function(){
    console.log('Fitbit deu start..')

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "openWatch") {
            qbFitbit.Open();
        }
    });
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            qbFitbit.Close();
            break;
    }
});

qbFitbit.Open = function() {
    $(".container").fadeIn(150);
}

qbFitbit.Close = function() {
    $(".container").fadeOut(150);
    $.post('http://qb-fitbit/close')
}

$(document).on('click', '.fitbit-app', function(e){
    e.preventDefault();

    var pressedApp = $(this).data('app');

    $(openedApp).css({"display":"none"});
    $("."+pressedApp+"-app").css({"display":"block"});

    openedApp = pressedApp;
});

$(document).on('click', '.back-food-settings', function(e){
    e.preventDefault();

    $(".food-app").css({"display":"none"});
    $(".main-screen").css({"display":"block"});

    openedApp = ".main-screen";
});

$(document).on('click', '.back-thirst-settings', function(e){
    e.preventDefault();

    $(".thirst-app").css({"display":"none"});
    $(".main-screen").css({"display":"block"});

    openedApp = ".main-screen";
});

$(document).on('click', '.save-food-settings', function(e){
    e.preventDefault();

    var foodValue = $(this).parent().parent().find('input');

    if (parseInt(foodValue.val()) <= 100) {
        $.post('http://qb-fitbit/setFoodWarning', JSON.stringify({
            value: foodValue.val()
        }));
    }
});

$(document).on('click', '.save-thirst-settings', function(e){
    e.preventDefault();

    var thirstValue = $(this).parent().parent().find('input');

    if (parseInt(thirstValue.val()) <= 100) {
        $.post('http://qb-fitbit/setThirstWarning', JSON.stringify({
            value: thirstValue.val()
        }));
    }
});