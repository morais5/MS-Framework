QBScoreboard = {}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                QBScoreboard.Open(event.data);
                break;
            case "close":
                QBScoreboard.Close();
                break;
        }
    })
});

QBScoreboard.Open = function(data) {
    $(".scoreboard-block").fadeIn(150);
    $("#total-players").html("<p>"+data.players+"/"+data.maxPlayers+"</p>");

    $.each(data.requiredCops, function(i, category){
        var beam = $(".scoreboard-info").find('[data-type="'+i+'"]');
        var status = $(beam).find(".info-beam-status");


        if (category.busy) {
            $(status).html('<i class="fas fa-clock"></i>');
        } else if (data.currentCops >= category.minimum) {
            $(status).html('<i class="fas fa-check"></i>');
        } else {
            $(status).html('<i class="fas fa-times"></i>');
        }


        // if (data.currentCops > 0) {
        //     var Abeam = $(".scoreboard-info").find('[data-type="police"]');
        //     var Astatus = $(Abeam).find(".info-beam-status");
        //     $(Astatus).html('<i class="fas fa-check"></i>');
        // } else {
        //     var Abeam = $(".scoreboard-info").find('[data-type="police"]');
        //     var Astatus = $(Abeam).find(".info-beam-status");
        //     $(Astatus).html('<i class="fas fa-times"></i>');
        // }

        if (data.currentAmbulance > 0) {
            var Abeam = $(".scoreboard-info").find('[data-type="ambulance"]');
            var Astatus = $(Abeam).find(".info-beam-status");
            $(Astatus).html('<i class="fas fa-check"></i>');
        } else {
            var Abeam = $(".scoreboard-info").find('[data-type="ambulance"]');
            var Astatus = $(Abeam).find(".info-beam-status");
            $(Astatus).html('<i class="fas fa-times"></i>');
        }
    });
}

QBScoreboard.Close = function() {
    $(".scoreboard-block").fadeOut(150);
}