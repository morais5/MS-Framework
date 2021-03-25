$(document).ready(function(){
    window.addEventListener('message', function(event){
        var action = event.data.action;

        switch(action) {
            case "add":
                AddPoliceAlert(event.data.data);
                break;
            default:
                console.log('DUDE??')
                break;
        }
    });
});

function AddPoliceAlert(data) {
    data.alertTitle != null ? data.alertTitle : "Geen title :(";
    if (data.callSign === "NO CALLSIGN") {
        data.callSign = "xx-xx";
    } else if (data.callSign === "UITDIENST") {
        data.callSign = "xx-xx";
    } else {
        var temp = data.callSign.split("|");
        data.callSign = temp[0];
    } 
    var $alert = $(".template-container").clone();
    $alert.hide().addClass('transReset');
    if (data.alertTitle == "Assistance collegue" || data.alertTitle == "Assistance ambulance" || data.alertTitle == "Assistance Doctor") {
        $alert.css({
            "border-right-color": "#cc2c2c"
        });
    } else if (data.alertTitle == "Attempted bank robbery") {
        $alert.css({
            "border-right-color": "#cc2c2c"
        });
    } else if (data.alertTitle == "Prison break") {
        $alert.css({
            "border-right-color": "#cc2c2c"
        });
    }
    $alert.removeClass('template-container');
    $alert.addClass('alert-' + data.alertId);
    $alert.find('.alert-prefix').html(data.callSign);
    $alert.find('.alert-title').html(data.alertTitle);

    if (data.coords !== undefined && data.coords !== null) {
        $alert.append('<div class="alert-location"><i class="fas fa-map-marker-alt"></i></div>')
        $alert.data('coords', data.coords);
    }

    $.each(data.details, function(i, detail){
        $alert.find('.alert-details').append('<div class="alert-detail">' + detail.icon + ' <span> ' + detail.detail + ' </span></div>');
    });

    $(".alerts-container").prepend($alert);
    $alert.show(300, function() { 
        $(this).removeClass('transReset')
    });

    animateCSS('.alert-' + data.alertId, 'zoomInRight', function(){
        $alert.removeClass('animated zoomInRight');
        if (data.alertTitle == "Assistance colleague" || data.alertTitle == "Assistance Ambulance" || data.alertTitle == "Assistance Doctor") {
            $alert.addClass('emergency');
        } else if (data.alertTitle == "Attempted bank robbery") {
            $alert.addClass('emergency');
        } else if (data.alertTitle == "Prison break") {
            $alert.addClass('emergency');
        }
    });
    
    setTimeout(function(){
        if (data.alertTitle == "Assistance colleague" || data.alertTitle == "Assistance Ambulance" || data.alertTitle == "Assistance Doctor") {
            $('.alert-' + data.alertId).removeClass('emergency');
        } else if (data.alertTitle == "Attempted bank robbery") {
            $('.alert-' + data.alertId).removeClass('emergency');
        } else if (data.alertTitle == "Prison break") {
            $('.alert-' + data.alertId).removeClass('emergency');
        }
        animateCSS('.alert-' + data.alertId, 'zoomOutRight', function(){
            $('.alert-' + data.alertId).remove();
        });
    }, data.timeOut != null ? data.timeOut : 3500);
}

function animateCSS(element, animationName, callback) {
    const node = document.querySelector(element)
    node.classList.add('animated', animationName)

    function handleAnimationEnd() {
        node.classList.remove('animated', animationName)
        node.removeEventListener('animationend', handleAnimationEnd)

        if (typeof callback === 'function') callback()
    }

    node.addEventListener('animationend', handleAnimationEnd)
}

$(document).on('click', '.alert-location', function(e){
    e.preventDefault();

    var LocationData = $(this).parent().data('coords');

    $.post('http://qb-policealerts/SetWaypoint', JSON.stringify({
        coords: LocationData,
    }))
});