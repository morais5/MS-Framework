SetupTaxis = function(data) {
    $(".taxis-list").html("");

    if (data.length > 0) {
        $.each(data, function(i, lawyer){
            var element = '<div class="taxi-list" id="lawyerid-'+i+'"> <div class="taxi-list-firstletter">' + (lawyer.name).charAt(0).toUpperCase() + '</div> <div class="taxi-list-fullname">' + lawyer.name + '</div> <div class="taxi-list-call"><i class="fas fa-phone"></i></div> </div>'
            $(".taxis-list").append(element);
            $("#lawyerid-"+i).data('LawyerData', lawyer);
        });
    } else {
        var element = '<div class="taxi-list"><div class="no-taxis">There is no taxi drivers available at the moment.</div></div>'
        $(".taxis-list").append(element);
    }
}

$(document).on('click', '.taxi-list-call', function(e){
    e.preventDefault();

    var LawyerData = $(this).parent().data('LawyerData');
    
    var cData = {
        number: LawyerData.phone,
        name: LawyerData.name
    }

    $.post('http://ms-phone_new/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: ms.Phone.Data.AnonymousCall,
    }), function(status){
        if (cData.number !== ms.Phone.Data.PlayerData.charinfo.phone) {
            if (status.IsOnline) {
                if (status.CanCall) {
                    if (!status.InCall) {
                        if (ms.Phone.Data.AnonymousCall) {
                            ms.Phone.Notifications.Add("fas fa-phone", "Phone", "Start a call anonymous!");
                        }
                        $(".phone-call-outgoing").css({"display":"block"});
                        $(".phone-call-incoming").css({"display":"none"});
                        $(".phone-call-ongoing").css({"display":"none"});
                        $(".phone-call-outgoing-caller").html(cData.name);
                        ms.Phone.Functions.HeaderTextColor("white", 400);
                        ms.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                        setTimeout(function(){
                            $(".taxis-app").css({"display":"none"});
                            ms.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                            ms.Phone.Functions.ToggleApp("phone-call", "block");
                        }, 450);
    
                        CallData.name = cData.name;
                        CallData.number = cData.number;
                    
                        ms.Phone.Data.currentApplication = "phone-call";
                    } else {
                        ms.Phone.Notifications.Add("fas fa-phone", "Phone", "You're already on a call!");
                    }
                } else {
                    ms.Phone.Notifications.Add("fas fa-phone", "Phone", "That person is busy on a call");
                }
            } else {
                ms.Phone.Notifications.Add("fas fa-phone", "Phone", "That person is not available!");
            }
        } else {
            ms.Phone.Notifications.Add("fas fa-phone", "Phone", "You can't call yourself!");
        }
    });
});