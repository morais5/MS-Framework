window.addEventListener('message', function (event) {

    // VEHICLE UPDATES
    if(event.data.showhud == true){
        // $('.huds').fadeIn();
        // setProgressSpeed(event.data.speed,'.progress-speed');
    }
    /* if(event.data.showcompass == true){
        $(".direction").find(".image").attr('style', 'transform: translate3d(' + event.data.direction + 'px, 0px, 0px)');
    } */
    if(event.data.showlocation == true){
        $('#showlocation').text(event.data.location);
    }
    if(event.data.clock == true){
        $('#clock').text(event.data.showclock);
    } else if (event.data.action == "toggleCar") {
        if (event.data.show){
            $('.carStats').fadeIn();
            $('.time').fadeIn();
            $('.location2').fadeIn();
            // $('.direction').fadeIn();
            $(".mapoutline").css('display', 'block')
            $("#time").removeClass("time-watch");
            $("#time").addClass("time");

            $("#time").css('left', '17.9%')
            //$("#direction").css('left', '12.9%')
            $("#location2").css('left', '14.9%')
        } else{
            $('.carStats').fadeOut();
            $('.time').fadeOut();
            $('.location2').fadeOut();
            //$('.direction').fadeOut();
            $(".mapoutline").css('display', 'none')
            $("#time").removeClass("time");
            $("#time").addClass("time-watch");
        }
    } else if (event.data.action == "seatbelt"){
        if(event.data.status){
            $('#seatbelt2').css('stroke','#ffffff');
        }else{
            $('#seatbelt2').css('stroke','#ce2d2d00');
        }
    } else if (event.data.action == "harness"){
        if(event.data.status == true) {
            $('#seatbelt').css('background-image','url(img/vehicle/harnesson.png)');
        }else{
            $('#seatbelt').css('background-image','url(img/vehicle/seatbelt.png)');
        }
    } else if (event.data.action == "lights"){
        if(event.data.status == "off") {
            $('#lights').css('background-image','url(img/vehicle/lowbeam.png)');
            $('#lights2').css('stroke','#98D4E000');
        }else if(event.data.status == "normal") {
            $('#lights').css('background-image','url(img/vehicle/lowbeam.png)');
            $('#lights2').css('stroke','#ffffff');
        }else if(event.data.status == "high") {
            $('#lights2').css('stroke','#ffffff');
            $('#lights').css('background-image','url(img/vehicle/highbeam.png)');
        }
    }else if (event.data.action == "updateGas"){
        setProgressFuel(event.data.value,'.progress-fuel');
        if (event.data.value < 15) {
            $('#fuel').css('stroke', '#f03232');
        } else if (event.data.value > 15) {
            $('#fuel').css('stroke', '#ffffff');
        }
    }else if (event.data.action == "updateSpeed"){
        setProgressSpeed(event.data.speed,'.progress-speed');
    }else if (event.data.action == "updateNitro"){
        setProgressNitro(event.data.value,'.progress-nitro');
        if (event.data.value < 15) {
            $('#nitro').css('stroke', '#f03232');
        } else if (event.data.value > 15) {
            $('#nitro').css('stroke', '#ffffff');
        }
    }else if (event.data.action == "toggleWatch"){
        if (event.data.show) {
            $("#time").fadeIn();
            $("#direction").fadeIn();
            $("#location2").fadeIn();
            $("#time").removeClass("time");
            $("#time").addClass("time-watch");
            if (event.data.hasArmor) {
                $("#time").css('left', '14.6%')
                //$("#direction").css('left', '14.6%')
                $("#location2").css('left', '17.6%')
            } else {
                $("#time").css('left', '12%')
                //$("#direction").css('left', '11.9%')
                $("#location2").css('left', '14.9%')
            }
        } else {
            $("#time").fadeOut();
            $("#direction").fadeOut();
            $("#location2").hide();
            $("#time").removeClass("time-watch");
            $("#time").addClass("time");
        }
    }else if (event.data.action == "updateWatchInfo"){
        //if ($('#direction').is(':hidden')) $('#direction').show();
        if ($('#location2').is(':hidden')) $('#location2').show();
        if ($('#clock').is(':hidden')) $('#clock').show();
        $('#clock').text(event.data.time);
        $('#location2').text(event.data.location);
        //$(".direction").find(".image").attr('style', 'transform: translate3d(' + event.data.direction + 'px, 0px, 0px)');
    }

     // PLAYER UPDATES

     switch (event.data.action) {
        case 'updateStatusHud':
            $("body").css("display", event.data.show ? "block" : "none");

            if (event.data.health) {
                $("#health.pie-wrapper").css("display", "block");

                if (event.data.health >= 100) {
                    $("health.pie-wrapper").fadeIn(2000).fadeOut(2000);
                }

                if (event.data.health > 50) {
                    $("#health.pie-wrapper .pie .half-circle").css("border-color", "#ffffff");
                } else {
                    $("#health.pie-wrapper .pie .half-circle").css("border-color", "#f03232");
                }

                $("#health.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.health * 3.6}deg)`);
                if (event.data.health <= 50) {
                    $("#health.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#health.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#health.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#health.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#health.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.health == false) {
                $("#health.pie-wrapper").css("display", "none");
            }

            if (event.data.armor) {
                $("#armor.pie-wrapper").css("display", "block");

                if (event.data.armor >= 100) {
                    $("armor.pie-wrapper").fadeIn(2000).fadeOut(2000);
                }
                
                if (event.data.armor > 50) {
                    $("#armor.pie-wrapper .pie .half-circle").css("border-color", "#ffffff");
                } else {
                    $("#armor.pie-wrapper .pie .half-circle").css("border-color", "#f03232");
                }

                $("#armor.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.armor * 3.6}deg)`);
                if (event.data.armor <= 50) {
                    $("#armor.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#armor.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#armor.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#armor.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#armor.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.armor == false) {
                $("#armor.pie-wrapper").css("display", "none");
            }

            if (event.data.hunger) {
                $("#hunger.pie-wrapper").css("display", "block");

                if (event.data.hunger > 50) {
                    $("#hunger.pie-wrapper .pie .half-circle").css("border-color", "#ffffff");
                } else {
                    $("#hunger.pie-wrapper .pie .half-circle").css("border-color", "#f03232");
                }

                $("#hunger.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.hunger * 3.6}deg)`);
                if (event.data.hunger <= 50) {
                    $("#hunger.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#hunger.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#hunger.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#hunger.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#hunger.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.hunger == false) {
                $("#hunger.pie-wrapper").css("display", "none");
            }

            if (event.data.thirst) {
                $("#thirst.pie-wrapper").css("display", "block");

                if (event.data.thirst > 50) {
                    $("#thirst.pie-wrapper .pie .half-circle").css("border-color", "#ffffff");
                } else {
                    $("#thirst.pie-wrapper .pie .half-circle").css("border-color", "#f03232");
                }

                $("#thirst.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.thirst * 3.6}deg)`);
                if (event.data.thirst <= 50) {
                    $("#thirst.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#thirst.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#thirst.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#thirst.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#thirst.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.thirst == false) {
                $("#thirst.pie-wrapper").css("display", "none");
            }

            if (event.data.stress) {
                $("#stress.pie-wrapper").css("display", "block");

                if (event.data.stress < 25) {
                    $("#stress.pie-wrapper .pie .half-circle").css("border-color", "#ffffff");
                } else {
                    $("#stress.pie-wrapper .pie .half-circle").css("border-color", "#f03232");
                }

                $("#stress.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.stress * 3.6}deg)`);
                if (event.data.stress >= 25) {
                    $("#stress.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#stress.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#stress.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#stress.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#stress.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.stress == false) {
                $("#stress.pie-wrapper").css("display", "none");
            }

            if (event.data.oxygen) {
                $("#oxygen.pie-wrapper").css("display", "block");

                if (event.data.oxygen >= 35) {
                    $("#oxygen.pie-wrapper .pie .half-circle").css("border-color", "#ffffff");
                } else {
                    $("#oxygen.pie-wrapper .pie .half-circle").css("border-color", "#f03232");
                }

                $("#oxygen.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.oxygen * 3.6}deg)`);
                if (event.data.oxygen < 35) {
                    $("#oxygen.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#oxygen.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                } else {
                    $("#oxygen.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#oxygen.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#oxygen.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.oxygen == false) {
                $("#oxygen.pie-wrapper").css("display", "none");
            }

            if (event.data.stamina) {
                $("#stamina.pie-wrapper").css("display", "block");

                if (event.data.stamina > 50) {
                    $("#stamina.pie-wrapper .pie .half-circle").css("border-color", "#ffffff");
                } else {
                    $("#stamina.pie-wrapper .pie .half-circle").css("border-color", "#f03232");
                }

                $("#stamina.pie-wrapper .pie .left-side").css("transform", `rotate(${event.data.stamina * 3.6}deg)`);
                if (event.data.stamina <= 50) {
                    $("#stamina.pie-wrapper .pie .right-side").css("display", `none`);
                    $("#stamina.pie-wrapper .pie").css("clip", `rect(0, 1em, 1em, 0.5em)`);
                    $("#stamina.pie-wrapper .pie .right-side").css("transform", ``);
                } else {
                    $("#stamina.pie-wrapper .pie .right-side").css("display", `block`);
                    $("#stamina.pie-wrapper .pie").css("clip", `rect(auto, auto, auto, auto)`);
                    $("#stamina.pie-wrapper .pie .right-side").css("transform", `rotate(180deg)`);
                }
            } else if (event.data.stamina == false) {
                $("#stamina.pie-wrapper").css("display", "none");
                
            }

            if (event.data.talking == 'normal') {
                $('.talkcircle1').css('border', '5px solid rgb(69, 192, 185)')
                $('.talkcircle2').css('border', '5px solid rgb(69, 192, 185, 0.5)')
                $('.talkcircle3').css('border', '5px solid rgb(69, 192, 185, 0.5)')
            } else if (event.data.talking == 'radio') {
                $('.talkcircle1').css('border', '5px solid rgb(200, 65, 90)')
                $('.talkcircle2').css('border', '5px solid rgb(200, 65, 90, 0.5)')
                $('.talkcircle3').css('border', '5px solid rgb(200, 65, 90, 0.5)')
            } else if (event.data.talking == false) {
                $('.talkcircle1').css('border', '5px solid rgb(255, 255, 255)')
                $('.talkcircle2').css('border', '5px solid rgb(255, 255, 255, 0.8)')
                $('.talkcircle3').css('border', '5px solid rgb(255, 255, 255, 0.5)')
            }

            if (event.data.mumble == 0) {
                $('.talkcircle1').css('visibility', 'hidden')
                $('.talkcircle2').css('visibility', 'hidden')
                $('.talkcircle3').css('visibility', 'hidden')
            } else if (event.data.mumble == 2){
                $('.talkcircle1').css('visibility', 'visible')
                $('.talkcircle2').css('visibility', 'visible')
                $('.talkcircle3').css('visibility', 'hidden')
            } else if (event.data.mumble == 4){
                $('.talkcircle1').css('visibility', 'visible')
                $('.talkcircle2').css('visibility', 'hidden')
                $('.talkcircle3').css('visibility', 'hidden')
            } else if (event.data.mumble == 3){
                $('.talkcircle1').css('visibility', 'visible')
                $('.talkcircle2').css('visibility', 'visible')
                $('.talkcircle3').css('visibility', 'visible')
            }
    }
});

function widthHeightSplit(value, ele) {
    let height = 25.5;
    let eleHeight = (value / 100) * height;
    let leftOverHeight = height - eleHeight;

    ele.css("height", eleHeight + "px");
    ele.css("top", leftOverHeight + "px");
};

function formatCurrency(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function setProgressSpeed(value, element){
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');
    var percent = value*100/220;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    var predkosc = Math.floor(value * 1.8)
    if (predkosc == 81 || predkosc == 131) {
      predkosc = predkosc - 1
    }

    html.text(predkosc);
  }

  function setProgressFuel(percent, element){
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(Math.round(percent));
  }

  function setProgressNitro(percent, element){
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(Math.round(percent));
  }