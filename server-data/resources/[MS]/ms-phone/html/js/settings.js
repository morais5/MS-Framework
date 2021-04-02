ms.Phone.Settings = {};
ms.Phone.Settings.Background = "default-msus";
ms.Phone.Settings.OpenedTab = null;
ms.Phone.Settings.Backgrounds = {
    'default-msus': {
        label: "Original OFSS"
    }
};

var PressedBackground = null;
var PressedBackgroundObject = null;
var OldBackground = null;
var IsChecked = null;

$(document).on('click', '.settings-app-tab', function(e){
    e.preventDefault();
    var PressedTab = $(this).data("settingstab");

    if (PressedTab == "background") {
        ms.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        ms.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "profilepicture") {
        ms.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        ms.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "numberrecognition") {
        var checkBoxes = $(".numberrec-box");
        ms.Phone.Data.AnonymousCall = !checkBoxes.prop("checked");
        checkBoxes.prop("checked", ms.Phone.Data.AnonymousCall);

        if (!ms.Phone.Data.AnonymousCall) {
            $("#numberrecognition > p").html('Off');
        } else {
            $("#numberrecognition > p").html('On');
        }
    }
});

$(document).on('click', '#accept-background', function(e){
    e.preventDefault();
    var hasCustomBackground = ms.Phone.Functions.IsBackgroundCustom();

    if (hasCustomBackground === false) {
        ms.Phone.Notifications.Add("fas fa-paint-brush", "Custom", ms.Phone.Settings.Backgrounds[ms.Phone.Settings.Background].label+" was set!")
        ms.Phone.Animations.TopSlideUp(".settings-"+ms.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+ms.Phone.Settings.Background+".png')"})
    } else {
        ms.Phone.Notifications.Add("fas fa-paint-brush", "Custom", "You have set a custom wallpaper!")
        ms.Phone.Animations.TopSlideUp(".settings-"+ms.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('"+ms.Phone.Settings.Background+"')"});
    }

    $.post('http://ms-phone/SetBackground', JSON.stringify({
        background: ms.Phone.Settings.Background,
    }))
});

ms.Phone.Functions.LoadMetaData = function(MetaData) {
    if (MetaData.background !== null && MetaData.background !== undefined) {
        ms.Phone.Settings.Background = MetaData.background;
    } else {
        ms.Phone.Settings.Background = "default-msus";
    }

    var hasCustomBackground = ms.Phone.Functions.IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+ms.Phone.Settings.Background+".png')"})
    } else {
        $(".phone-background").css({"background-image":"url('"+ms.Phone.Settings.Background+"')"});
    }

    if (MetaData.profilepicture == "default") {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+MetaData.profilepicture+'">');
    }
}

$(document).on('click', '#cancel-background', function(e){
    e.preventDefault();
    ms.Phone.Animations.TopSlideUp(".settings-"+ms.Phone.Settings.OpenedTab+"-tab", 200, -100);
});

ms.Phone.Functions.IsBackgroundCustom = function() {
    var retval = true;
    $.each(ms.Phone.Settings.Backgrounds, function(i, background){
        if (ms.Phone.Settings.Background == i) {
            retval = false;
        }
    });
    return retval
}

$(document).on('click', '.background-option', function(e){
    e.preventDefault();
    PressedBackground = $(this).data('background');
    PressedBackgroundObject = this;
    OldBackground = $(this).parent().find('.background-option-current');
    IsChecked = $(this).find('.background-option-current');

    if (IsChecked.length === 0) {
        if (PressedBackground != "custom-background") {
            ms.Phone.Settings.Background = PressedBackground;
            $(OldBackground).fadeOut(50, function(){
                $(OldBackground).remove();
            });
            $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            ms.Phone.Animations.TopSlideDown(".background-custom", 200, 13);
        }
    }
});

$(document).on('click', '#accept-custom-background', function(e){
    e.preventDefault();

    ms.Phone.Settings.Background = $(".custom-background-input").val();
    $(OldBackground).fadeOut(50, function(){
        $(OldBackground).remove();
    });
    $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
    ms.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

$(document).on('click', '#cancel-custom-background', function(e){
    e.preventDefault();

    ms.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

// Profile Picture

var PressedProfilePicture = null;
var PressedProfilePictureObject = null;
var OldProfilePicture = null;
var ProfilePictureIsChecked = null;

$(document).on('click', '#accept-profilepicture', function(e){
    e.preventDefault();
    var ProfilePicture = ms.Phone.Data.MetaData.profilepicture;
    if (ProfilePicture === "default") {
        ms.Phone.Notifications.Add("fas fa-paint-brush", "Custom", "Default avatar set!")
        ms.Phone.Animations.TopSlideUp(".settings-"+ms.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        ms.Phone.Notifications.Add("fas fa-paint-brush", "Custom", "Custom avatar defined!")
        ms.Phone.Animations.TopSlideUp(".settings-"+ms.Phone.Settings.OpenedTab+"-tab", 200, -100);
        console.log(ProfilePicture)
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+ProfilePicture+'">');
    }
    $.post('http://ms-phone/UpdateProfilePicture', JSON.stringify({
        profilepicture: ProfilePicture,
    }));
});

$(document).on('click', '#accept-custom-profilepicture', function(e){
    e.preventDefault();
    ms.Phone.Data.MetaData.profilepicture = $(".custom-profilepicture-input").val();
    $(OldProfilePicture).fadeOut(50, function(){
        $(OldProfilePicture).remove();
    });
    $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
    ms.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});

$(document).on('click', '.profilepicture-option', function(e){
    e.preventDefault();
    PressedProfilePicture = $(this).data('profilepicture');
    PressedProfilePictureObject = this;
    OldProfilePicture = $(this).parent().find('.profilepicture-option-current');
    ProfilePictureIsChecked = $(this).find('.profilepicture-option-current');
    if (ProfilePictureIsChecked.length === 0) {
        if (PressedProfilePicture != "custom-profilepicture") {
            ms.Phone.Data.MetaData.profilepicture = PressedProfilePicture
            $(OldProfilePicture).fadeOut(50, function(){
                $(OldProfilePicture).remove();
            });
            $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            ms.Phone.Animations.TopSlideDown(".profilepicture-custom", 200, 13);
        }
    }
});

$(document).on('click', '#cancel-profilepicture', function(e){
    e.preventDefault();
    ms.Phone.Animations.TopSlideUp(".settings-"+ms.Phone.Settings.OpenedTab+"-tab", 200, -100);
});


$(document).on('click', '#cancel-custom-profilepicture', function(e){
    e.preventDefault();
    ms.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});