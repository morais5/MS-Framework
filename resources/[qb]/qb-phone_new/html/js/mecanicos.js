SetupMecanicos = function(data) {
    $(".mecanicos-list").html("");

    if (data.length > 0) {
        $.each(data, function(i, lawyer){
            var element = '<div class="mecanico-list" id="lawyerid-'+i+'"> <div class="mecanico-list-firstletter">' + (lawyer.name).charAt(0).toUpperCase() + '</div> <div class="mecanico-list-fullname">' + lawyer.name + '</div> <div class="mecanico-list-call"><i class="fas fa-phone"></i></div> </div>'
            $(".mecanicos-list").append(element);
            $("#lawyerid-"+i).data('LawyerData', lawyer);
        });
    } else {
        var element = '<div class="mecanico-list"><div class="no-mecanicos">Não existe mecanicos disponiveis de momento.</div></div>'
        $(".mecanicos-list").append(element);
    }
}

$(document).on('click', '.mecanico-list-call', function(e){
    e.preventDefault();

    var LawyerData = $(this).parent().data('LawyerData');
    
    var cData = {
        number: LawyerData.phone,
        name: LawyerData.name
    }

    $.post('http://qb-phone_new/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: QB.Phone.Data.AnonymousCall,
    }), function(status){
        if (cData.number !== QB.Phone.Data.PlayerData.charinfo.phone) {
            if (status.IsOnline) {
                if (status.CanCall) {
                    if (!status.InCall) {
                        if (QB.Phone.Data.AnonymousCall) {
                            QB.Phone.Notifications.Add("fas fa-phone", "Telemovel", "Iniciaste uma chamada em Anonimo!");
                        }
                        $(".phone-call-outgoing").css({"display":"block"});
                        $(".phone-call-incoming").css({"display":"none"});
                        $(".phone-call-ongoing").css({"display":"none"});
                        $(".phone-call-outgoing-caller").html(cData.name);
                        QB.Phone.Functions.HeaderTextColor("white", 400);
                        QB.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                        setTimeout(function(){
                            $(".mecanicos-app").css({"display":"none"});
                            QB.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                            QB.Phone.Functions.ToggleApp("phone-call", "block");
                        }, 450);
    
                        CallData.name = cData.name;
                        CallData.number = cData.number;
                    
                        QB.Phone.Data.currentApplication = "phone-call";
                    } else {
                        QB.Phone.Notifications.Add("fas fa-phone", "Telemovel", "Ja estas numa chamada!");
                    }
                } else {
                    QB.Phone.Notifications.Add("fas fa-phone", "Telemovel", "Essa pessoa esta ocupada numa chamada");
                }
            } else {
                QB.Phone.Notifications.Add("fas fa-phone", "Telemovel", "Essa pessoa não esta disponivel!");
            }
        } else {
            QB.Phone.Notifications.Add("fas fa-phone", "Telemovel", "Não podes ligar a ti proprio!");
        }
    });
});