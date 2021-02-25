$(document).ready(function(){
    var video = document.getElementById("sample_video");
    video.pause();
    video.currentTime = 0;
    video.volume = 0.2;
    $(".container").hide();
    $('#sample_video').css({"opacity":"0.0"});
    
    window.addEventListener('message', function(event){
        var data = event.data;
        if (data.action == "enable") {
            $(".container").fadeIn(1000);
            PlayVideo();
        }
    });

    document.getElementById('sample_video').addEventListener('ended',function(){
        $.post('http://qb-event/CloseEvent');
        StopVideo()
    }, false);
});

function PlayVideo() {
    var video = document.getElementById("sample_video");
    video.pause();
    video.currentTime = 0;
    video.load();
    video.volume = 0.2;
    $('#sample_video').animate({
        opacity: 1.0
    }, 5000, function(){
        video.play();
    })
}

function StopVideo() {
    $(".container").fadeOut(1000);
    $('#sample_video').animate({opacity: 0.0});
    var video = document.getElementById("sample_video");
    video.pause();
    video.volume = 0.0;
}