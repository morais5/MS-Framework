$(document).ready(function() {

    $(".container").hide();
    $("#submit-spawn").hide()

    window.addEventListener('message', function(event) {
        var data = event.data;
        if (data.type === "ui") {
            if (data.status == true) {
                $(".container").fadeIn(250);
            } else {
                $(".container").fadeOut(250);
            }
        }

        if (data.action == "setupLocations") {
            setupLocations(data.locations, data.houses)
        }

        if (data.action == "setupAppartements") {
            setupApps(data.locations)
        }
    })
})

var currentLocation = null

$(document).on('click', '.location', function(evt){
    evt.preventDefault(); //dont do default anchor stuff
    var location = $(this).data('location'); //get the text
    var type = $(this).data('type'); //get the text
    var label = $(this).data('label'); //get the text
    if (type !== "lab") {
        $("#spawn-label").html("Confirmar")
        $("#submit-spawn").attr("data-location", location);
        $("#submit-spawn").attr("data-type", type);
        $("#submit-spawn").fadeIn(100)
        $.post('http://qb-spawn/setCam', JSON.stringify({
            posname: location,
            type: type,
        }));
        if (currentLocation !== null) {
            $(currentLocation).removeClass('selected');
        }
        $(this).addClass('selected');
        currentLocation = this
    }
});

$(document).on('click', '#submit-spawn', function(evt){
    evt.preventDefault(); //dont do default anchor stuff
    var location = $(this).data('location');
    var spawnType = $(this).data('type');
    console.log(spawnType)
    $(".container").addClass("hideContainer").fadeOut("9000");
    setTimeout(function(){
        $(".hideContainer").removeClass("hideContainer");
    }, 900);
    if (spawnType !== "appartment") {
        $.post('http://qb-spawn/spawnplayer', JSON.stringify({
            spawnloc: location,
            typeLoc: spawnType
        }));
    } else {
        $.post('http://qb-spawn/chooseAppa', JSON.stringify({
            appType: location,
        }));
    }
});

function setupLocations(locations, myHouses) {
    var parent = $('.spawn-locations')
    $(parent).html("");

    $(parent).append('<div class="loclabel" id="location" data-location="null" data-type="lab" data-label="Onde você gostaria de começar?"><p><span id="null">Onde você gostaria de começar?</span></p></div>')
    
    setTimeout(function(){
        $(parent).append('<div class="location" id="location" data-location="current" data-type="current" data-label="Última localização"><p><span id="current-location">Última localização</span></p></div>');
        
        $.each(locations, function(index, location){
            $(parent).append('<div class="location" id="location" data-location="'+location.location+'" data-type="normal" data-label="'+location.label+'"><p><span id="'+location.location+'">'+location.label+'</span></p></div>')
        });

        if (myHouses != undefined) {
            $.each(myHouses, function(index, house){
                $(parent).append('<div class="location" id="location" data-location="'+house.house+'" data-type="house" data-label="'+house.label+'"><p><span id="'+house.house+'">'+house.label+'</span></p></div>')
            });
        }

        $(parent).append('<div class="submit-spawn" id="submit-spawn"><p><span id="spawn-label"></span></p></div>');
        $('.submit-spawn').hide();
    }, 100)
}

function setupApps(apps) {
    var parent = $('.spawn-locations')
    $(parent).html("");

    $(parent).append('<div class="loclabel" id="location" data-location="null" data-type="lab" data-label="Escolha um apartamento"><p><span id="null">Escolha um apartamento</span></p></div>')

    $.each(apps, function(index, app){
        $(parent).append('<div class="location" id="location" data-location="'+app.name+'" data-type="appartment" data-label="'+app.label+'"><p><span id="'+app.name+'">'+app.label+'</span></p></div>')
    });

    $(parent).append('<div class="submit-spawn" id="submit-spawn"><p><span id="spawn-label"></span></p></div>');
    $('.submit-spawn').hide();
}