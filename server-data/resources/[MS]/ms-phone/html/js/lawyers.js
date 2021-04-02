SetupLawyers = function(data) {
    $(".lawyers-list").html("");

    if (data.length > 0) {
        $.each(data, function(i, lawyer){
            var element = '<div class="lawyer-list" id="lawyerid-'+i+'"> <div class="lawyer-list-firstletter">' + (lawyer.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer.name + '</div> <div class="lawyer-list-call"><i class="fas fa-phone"></i></div> </div>'
            $(".lawyers-list").append(element);
            $("#lawyerid-"+i).data('LawyerData', lawyer);
        });
    } else {
        var element = '<div class="lawyer-list"><div class="no-lawyers">There are no lawyers available at the moment.</div></div>'
        $(".lawyers-list").append(element);
    }
}

$(document).on('click', '.lawyer-list-call', function(e){
    e.preventDefault();

    var LawyerData = $(this).parent().data('LawyerData');
    
    var cData = {
        number: LawyerData.phone,
        name: LawyerData.name
    }

    $.post('http://ms-phone/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: ms.Phone.Data.AnonymousCall,
    }), function(status){
        if (cData.number !== ms.Phone.Data.PlayerData.charinfo.phone) {
            if (status.IsOnline) {
                if (status.CanCall) {
                    if (!status.InCall) {
                        if (ms.Phone.Data.AnonymousCall) {
                            ms.Phone.Notifications.Add("fas fa-phone", "Phone", "You initiated a call as Anonymous!");
                        }
                        $(".phone-call-outgoing").css({"display":"block"});
                        $(".phone-call-incoming").css({"display":"none"});
                        $(".phone-call-ongoing").css({"display":"none"});
                        $(".phone-call-outgoing-caller").html(cData.name);
                        ms.Phone.Functions.HeaderTextColor("white", 400);
                        ms.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                        setTimeout(function(){
                            $(".lawyers-app").css({"display":"none"});
                            ms.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                            ms.Phone.Functions.ToggleApp("phone-call", "block");
                        }, 450);
    
                        CallData.name = cData.name;
                        CallData.number = cData.number;
                    
                        ms.Phone.Data.currentApplication = "phone-call";
                    } else {
                        ms.Phone.Notifications.Add("fas fa-phone", "Phone", "Already in a call!");
                    }
                } else {
                    ms.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is busy on a call");
                }
            } else {
                ms.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is not available!");
            }
        } else {
            ms.Phone.Notifications.Add("fas fa-phone", "Phone", "You can not connect yourself!");
        }
    });
});