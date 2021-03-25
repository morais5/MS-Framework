var noteId = null
$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Notepad.Close();
            break;
    }
});

$(document).on('click', '#drop', function(){
    Notepad.Close();
    $.post("http://notes/DropNote", JSON.stringify({
        text: $("#notetext").val(),
        noteid: noteId,
    }));
});

(() => {
    Notepad = {};

    Notepad.Open = function(data) {
        $(".notepad-container").css("display", "block");
        noteId = data.noteid;
        if (data.text != null) {
            $("#notetext").val(data.text);
        }
    };

    Notepad.Close = function() {
        $(".notepad-container").css("display", "none");
        $.post("http://notes/CloseNotepad", JSON.stringify({
            noteid: noteId,
        }));
    };

    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case "open":
                    Notepad.Open(event.data);
                    break;
                case "close":
                    Notepad.Close();
                    break;
            }
        })
    }

})();