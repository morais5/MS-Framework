$(document).ready(function(){
    
    window.addEventListener('message', function(event){
        var Item = event.data;

        if (Item.action == "Task1Letter") {
            if (Item.toggle) {
                $(".container").fadeIn(150);
                ToggleLetter(true)
            } else {
                $(".container").fadeOut(150);
                ToggleLetter(false)
            }
        }
    });
});

function ToggleLetter(bool) {
    if (bool) {

    } else {

    }
}