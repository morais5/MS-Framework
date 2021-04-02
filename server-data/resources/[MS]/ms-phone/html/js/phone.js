var ContactSearchActive = false;
var CurrentFooterTab = "contacts";
var CallData = {};
var ClearNumberTimer = null;
var SelectedSuggestion = null;
var AmountOfSuggestions = 0;

$(document).on('click', '.phone-app-footer-button', function(e){
    e.preventDefault();

    var PressedFooterTab = $(this).data('phonefootertab');

    if (PressedFooterTab !== CurrentFooterTab) {
        var PreviousTab = $(this).parent().find('[data-phonefootertab="'+CurrentFooterTab+'"');

        $('.phone-app-footer').find('[data-phonefootertab="'+CurrentFooterTab+'"').removeClass('phone-selected-footer-tab');
        $(this).addClass('phone-selected-footer-tab');

        $(".phone-"+CurrentFooterTab).hide();
        $(".phone-"+PressedFooterTab).show();

        if (PressedFooterTab == "recent") {
            $.post('http://ms-phone_new/ClearRecentAlerts');
        } else if (PressedFooterTab == "suggestedcontacts") {
            $.post('http://ms-phone_new/ClearRecentAlerts');
        }

        CurrentFooterTab = PressedFooterTab;
    }
});

$(document).on("click", "#phone-search-icon", function(e){
    e.preventDefault();

    if (!ContactSearchActive) {
        $("#phone-plus-icon").animate({
            opacity: "0.0",
            "display": "none"
        }, 150, function(){
            $("#contact-search").css({"display":"block"}).animate({
                opacity: "1.0",
            }, 150);
        });
    } else {
        $("#contact-search").animate({
            opacity: "0.0"
        }, 150, function(){
            $("#contact-search").css({"display":"none"});
            $("#phone-plus-icon").animate({
                opacity: "1.0",
                display: "block",
            }, 150);
        });
    }

    ContactSearchActive = !ContactSearchActive;
});

ms.Phone.Functions.SetupRecentCalls = function(recentcalls) {
    $(".phone-recent-calls").html("");

    recentcalls = recentcalls.reverse();

    $.each(recentcalls, function(i, recentCall){
        var FirstLetter = (recentCall.name).charAt(0);
        var TypeIcon = 'fas fa-phone-slash';
        var IconStyle = "color: #e74c3c;";
        if (recentCall.type === "outgoing") {
            TypeIcon = 'fas fa-phone-volume';
            var IconStyle = "color: #2ecc71; font-size: 1.4vh;";
        }
        if (recentCall.anonymous) {
            FirstLetter = "A";
            recentCall.name = "Anonymous";
        }
        var elem = '<div class="phone-recent-call" id="recent-'+i+'"><div class="phone-recent-call-image">'+FirstLetter+'</div> <div class="phone-recent-call-name">'+recentCall.name+'</div> <div class="phone-recent-call-type"><i class="'+TypeIcon+'" style="'+IconStyle+'"></i></div> <div class="phone-recent-call-time">'+recentCall.time+'</div> </div>'

        $(".phone-recent-calls").append(elem);
        $("#recent-"+i).data('recentData', recentCall);
    });
}

$(document).on('click', '.phone-recent-call', function(e){
    e.preventDefault();

    var RecendId = $(this).attr('id');
    var RecentData = $("#"+RecendId).data('recentData');

    cData = {
        number: RecentData.number,
        name: RecentData.name
    }

    console.log(ms.Phone.Data.AnonymousCall)

    $.post('http://ms-phone_new/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: ms.Phone.Data.AnonymousCall,
    }), function(status){
        if (cData.number !== ms.Phone.Data.PlayerData.charinfo.phone) {
            if (status.IsOnline) {
                if (status.CanCall) {
                    if (!status.InCall) {
                        if (ms.Phone.Data.AnonymousCall) {
                            ms.Phone.Notifications.Add("fas fa-phone", "Phone", "You started an anonymous call!");
                        }
                        $(".phone-call-outgoing").css({"display":"block"});
                        $(".phone-call-incoming").css({"display":"none"});
                        $(".phone-call-ongoing").css({"display":"none"});
                        $(".phone-call-outgoing-caller").html(cData.name);
                        ms.Phone.Functions.HeaderTextColor("white", 400);
                        ms.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                        setTimeout(function(){
                            $(".phone-app").css({"display":"none"});
                            ms.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                            ms.Phone.Functions.ToggleApp("phone-call", "block");
                        }, 450);
    
                        CallData.name = cData.name;
                        CallData.number = cData.number;
                    
                        ms.Phone.Data.currentApplication = "phone-call";
                    } else {
                        ms.Phone.Notifications.Add("fas fa-phone", "Phone", "Youre already in a call!");
                    }
                } else {
                    ms.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is in a call!");
                }
            } else {
                ms.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is not available!");
            }
        } else {
            ms.Phone.Notifications.Add("fas fa-phone", "Phone", "You can not call yourself!");
        }
    });
});

$(document).on('click', ".phone-keypad-key-call", function(e){
    e.preventDefault();

    var InputNum = toString($(".phone-keypad-input").text());

    cData = {
        number: InputNum,
        name: InputNum,
    }

    $.post('http://ms-phone_new/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: ms.Phone.Data.AnonymousCall,
    }), function(status){
        if (cData.number !== ms.Phone.Data.PlayerData.charinfo.phone) {
            if (status.IsOnline) {
                if (status.CanCall) {
                    if (!status.InCall) {
                        $(".phone-call-outgoing").css({"display":"block"});
                        $(".phone-call-incoming").css({"display":"none"});
                        $(".phone-call-ongoing").css({"display":"none"});
                        $(".phone-call-outgoing-caller").html(cData.name);
                        ms.Phone.Functions.HeaderTextColor("white", 400);
                        ms.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                        setTimeout(function(){
                            $(".phone-app").css({"display":"none"});
                            ms.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                            ms.Phone.Functions.ToggleApp("phone-call", "block");
                        }, 450);
    
                        CallData.name = cData.name;
                        CallData.number = cData.number;
                    
                        ms.Phone.Data.currentApplication = "phone-call";
                    } else {
                        ms.Phone.Notifications.Add("fas fa-phone", "Phone", "Ja estas numa chamada!");
                    }
                } else {
                    ms.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is in a call!");
                }
            } else {
                ms.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is not available!");
            }
        } else {
            ms.Phone.Notifications.Add("fas fa-phone", "Phone", "You can not call yourself!");
        }
    });
});

ms.Phone.Functions.LoadContacts = function(myContacts) {
    var ContactsObject = $(".phone-contact-list");
    $(ContactsObject).html("");
    var TotalContacts = 0;

    $(".phone-contacts").hide();
    $(".phone-recent").hide();
    $(".phone-keypad").hide();

    $(".phone-"+CurrentFooterTab).show();

    $("#contact-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $(".phone-contact-list .phone-contact").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });

    if (myContacts !== null) {
        $.each(myContacts, function(i, contact){
            var ContactElement = '<div class="phone-contact" data-contactid="'+i+'"><div class="phone-contact-firstletter" style="background-color: #e74c3c;">'+((contact.name).charAt(0)).toUpperCase()+'</div><div class="phone-contact-name">'+contact.name+'</div><div class="phone-contact-actions"><i class="fas fa-sort-down"></i></div><div class="phone-contact-action-buttons"> <i class="fas fa-phone-volume" id="phone-start-call"></i> <i class="fab fa-whatsapp" id="new-chat-phone" style="font-size: 2.5vh;"></i> <i class="fas fa-user-edit" id="edit-contact"></i> </div></div>'
            if (contact.status) {
                ContactElement = '<div class="phone-contact" data-contactid="'+i+'"><div class="phone-contact-firstletter" style="background-color: #2ecc71;">'+((contact.name).charAt(0)).toUpperCase()+'</div><div class="phone-contact-name">'+contact.name+'</div><div class="phone-contact-actions"><i class="fas fa-sort-down"></i></div><div class="phone-contact-action-buttons"> <i class="fas fa-phone-volume" id="phone-start-call"></i> <i class="fab fa-whatsapp" id="new-chat-phone" style="font-size: 2.5vh;"></i> <i class="fas fa-user-edit" id="edit-contact"></i> </div></div>'
            }
            TotalContacts = TotalContacts + 1
            $(ContactsObject).append(ContactElement);
            $("[data-contactid='"+i+"']").data('contactData', contact);
        });
        $("#total-contacts").text(TotalContacts+ " contacts");
    } else {
        $("#total-contacts").text("0 contacts #SAD");
    }
};

$(document).on('click', '#new-chat-phone', function(e){
    var ContactId = $(this).parent().parent().data('contactid');
    var ContactData = $("[data-contactid='"+ContactId+"']").data('contactData');

    if (ContactData.number !== ms.Phone.Data.PlayerData.charinfo.phone) {
        $.post('http://ms-phone_new/GetWhatsappChats', JSON.stringify({}), function(chats){
            ms.Phone.Functions.LoadWhatsappChats(chats);
        });
    
        $('.phone-application-container').animate({
            top: -160+"%"
        });
        ms.Phone.Functions.HeaderTextColor("white", 400);
        setTimeout(function(){
            $('.phone-application-container').animate({
                top: 0+"%"
            });
    
            ms.Phone.Functions.ToggleApp("phone", "none");
            ms.Phone.Functions.ToggleApp("whatsapp", "block");
            ms.Phone.Data.currentApplication = "whatsapp";
        
            $.post('http://ms-phone_new/GetWhatsappChat', JSON.stringify({phone: ContactData.number}), function(chat){
                ms.Phone.Functions.SetupChatMessages(chat, {
                    name: ContactData.name,
                    number: ContactData.number
                });
            });
        
            $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 150);
            $(".whatsapp-openedchat").css({"display":"block"});
            $(".whatsapp-openedchat").css({left: 0+"vh"});
            $(".whatsapp-chats").animate({left: 30+"vh"},100, function(){
                $(".whatsapp-chats").css({"display":"none"});
            });
        }, 400)
    } else {
        ms.Phone.Notifications.Add("fa fa-phone-alt", "Phone", "Can not send a message to yourself..", "default", 3500);
    }
});

var CurrentEditContactData = {}

$(document).on('click', '#edit-contact', function(e){
    e.preventDefault();
    var ContactId = $(this).parent().parent().data('contactid');
    var ContactData = $("[data-contactid='"+ContactId+"']").data('contactData');

    CurrentEditContactData.name = ContactData.name
    CurrentEditContactData.number = ContactData.number

    $(".phone-edit-contact-header").text(ContactData.name+" - Edit")
    $(".phone-edit-contact-name").val(ContactData.name);
    $(".phone-edit-contact-number").val(ContactData.number);
    if (ContactData.iban != null && ContactData.iban != undefined) {
        $(".phone-edit-contact-iban").val(ContactData.iban);
        CurrentEditContactData.iban = ContactData.iban
    } else {
        $(".phone-edit-contact-iban").val("");
        CurrentEditContactData.iban = "";
    }

    ms.Phone.Animations.TopSlideDown(".phone-edit-contact", 200, 0);
});

$(document).on('click', '#edit-contact-save', function(e){
    e.preventDefault();

    var ContactName = $(".phone-edit-contact-name").val();
    var ContactNumber = $(".phone-edit-contact-number").val();
    var ContactIban = $(".phone-edit-contact-iban").val();

    if (ContactName != "" && ContactNumber != "") {
        $.post('http://ms-phone_new/EditContact', JSON.stringify({
            CurrentContactName: ContactName,
            CurrentContactNumber: ContactNumber,
            CurrentContactIban: ContactIban,
            OldContactName: CurrentEditContactData.name,
            OldContactNumber: CurrentEditContactData.number,
            OldContactIban: CurrentEditContactData.iban,
        }), function(PhoneContacts){
            ms.Phone.Functions.LoadContacts(PhoneContacts);
        });
        ms.Phone.Animations.TopSlideUp(".phone-edit-contact", 250, -100);
        setTimeout(function(){
            $(".phone-edit-contact-number").val("");
            $(".phone-edit-contact-name").val("");
        }, 250)
    } else {
        ms.Phone.Notifications.Add("fas fa-exclamation-circle", "Contact Editior", "Fill in all fields!");
    }
});

$(document).on('click', '#edit-contact-delete', function(e){
    e.preventDefault();

    var ContactName = $(".phone-edit-contact-name").val();
    var ContactNumber = $(".phone-edit-contact-number").val();
    var ContactIban = $(".phone-edit-contact-iban").val();

    $.post('http://ms-phone_new/DeleteContact', JSON.stringify({
        CurrentContactName: ContactName,
        CurrentContactNumber: ContactNumber,
        CurrentContactIban: ContactIban,
    }), function(PhoneContacts){
        ms.Phone.Functions.LoadContacts(PhoneContacts);
    });
    ms.Phone.Animations.TopSlideUp(".phone-edit-contact", 250, -100);
    setTimeout(function(){
        $(".phone-edit-contact-number").val("");
        $(".phone-edit-contact-name").val("");
    }, 250);
});

$(document).on('click', '#edit-contact-cancel', function(e){
    e.preventDefault();

    ms.Phone.Animations.TopSlideUp(".phone-edit-contact", 250, -100);
    setTimeout(function(){
        $(".phone-edit-contact-number").val("");
        $(".phone-edit-contact-name").val("");
    }, 250)
});

$(document).on('click', '.phone-keypad-key', function(e){
    e.preventDefault();

    var PressedButton = $(this).data('keypadvalue');

    if (!isNaN(PressedButton)) {
        var keyPadHTML = $("#phone-keypad-input").text();
        $("#phone-keypad-input").text(keyPadHTML + PressedButton)
    } else if (PressedButton == "#") {
        var keyPadHTML = $("#phone-keypad-input").text();
        $("#phone-keypad-input").text(keyPadHTML + PressedButton)
    } else if (PressedButton == "*") {
        if (ClearNumberTimer == null) {
            $("#phone-keypad-input").text("Cleared")
            ClearNumberTimer = setTimeout(function(){
                $("#phone-keypad-input").text("");
                ClearNumberTimer = null;
            }, 750);
        }
    }
})

var OpenedContact = null;

$(document).on('click', '.phone-contact-actions', function(e){
    e.preventDefault();

    var FocussedContact = $(this).parent();
    var ContactId = $(FocussedContact).data('contactid');

    if (OpenedContact === null) {
        $(FocussedContact).animate({
            "height":"12vh"
        }, 150, function(){
            $(FocussedContact).find('.phone-contact-action-buttons').fadeIn(100);
        });
        OpenedContact = ContactId;
    } else if (OpenedContact == ContactId) {
        $(FocussedContact).find('.phone-contact-action-buttons').fadeOut(100, function(){
            $(FocussedContact).animate({
                "height":"4.5vh"
            }, 150);
        });
        OpenedContact = null;
    } else if (OpenedContact != ContactId) {
        var PreviousContact = $(".phone-contact-list").find('[data-contactid="'+OpenedContact+'"]');
        $(PreviousContact).find('.phone-contact-action-buttons').fadeOut(100, function(){
            $(PreviousContact).animate({
                "height":"4.5vh"
            }, 150);
            OpenedContact = ContactId;
        });
        $(FocussedContact).animate({
            "height":"12vh"
        }, 150, function(){
            $(FocussedContact).find('.phone-contact-action-buttons').fadeIn(100);
        });
    }
});


$(document).on('click', '#phone-plus-icon', function(e){
    e.preventDefault();

    ms.Phone.Animations.TopSlideDown(".phone-add-contact", 200, 0);
});

$(document).on('click', '#add-contact-save', function(e){
    e.preventDefault();

    var ContactName = $(".phone-add-contact-name").val();
    var ContactNumber = $(".phone-add-contact-number").val();
    var ContactIban = $(".phone-add-contact-iban").val();

    if (ContactName != "" && ContactNumber != "") {
        $.post('http://ms-phone_new/AddNewContact', JSON.stringify({
            ContactName: ContactName,
            ContactNumber: ContactNumber,
            ContactIban: ContactIban,
        }), function(PhoneContacts){
            ms.Phone.Functions.LoadContacts(PhoneContacts);
        });
        ms.Phone.Animations.TopSlideUp(".phone-add-contact", 250, -100);
        setTimeout(function(){
            $(".phone-add-contact-number").val("");
            $(".phone-add-contact-name").val("");
        }, 250)

        if (SelectedSuggestion !== null) {
            $.post('http://ms-phone_new/RemoveSuggestion', JSON.stringify({
                data: $(SelectedSuggestion).data('SuggestionData')
            }));
            $(SelectedSuggestion).remove();
            SelectedSuggestion = null;
            var amount = parseInt(AmountOfSuggestions);
            if ((amount - 1) === 0) {
                amount = 0
            }
            $(".amount-of-suggested-contacts").html(amount + " Contacts");
        }
    } else {
        ms.Phone.Notifications.Add("fas fa-exclamation-circle", "Add contact", "Fill all the fields!");
    }
});

$(document).on('click', '#add-contact-cancel', function(e){
    e.preventDefault();

    ms.Phone.Animations.TopSlideUp(".phone-add-contact", 250, -100);
    setTimeout(function(){
        $(".phone-add-contact-number").val("");
        $(".phone-add-contact-name").val("");
    }, 250)
});

$(document).on('click', '#phone-start-call', function(e){
    e.preventDefault();   
    
    var ContactId = $(this).parent().parent().data('contactid');
    var ContactData = $("[data-contactid='"+ContactId+"']").data('contactData');
    
    SetupCall(ContactData);
});

SetupCall = function(cData) {
    var retval = false;
    $.post('http://ms-phone_new/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: ms.Phone.Data.AnonymousCall,
    }), function(status){
        if (cData.number !== ms.Phone.Data.PlayerData.charinfo.phone) {
            if (status.IsOnline) {
                if (status.CanCall) {
                    if (!status.InCall) {
                        $(".phone-call-outgoing").css({"display":"block"});
                        $(".phone-call-incoming").css({"display":"none"});
                        $(".phone-call-ongoing").css({"display":"none"});
                        $(".phone-call-outgoing-caller").html(cData.name);
                        ms.Phone.Functions.HeaderTextColor("white", 400);
                        ms.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                        setTimeout(function(){
                            $(".phone-app").css({"display":"none"});
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
                    ms.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is busy on a call!");
                }
            } else {
                ms.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is not available!");
            }
        } else {
            ms.Phone.Notifications.Add("fas fa-phone", "Phone", "You can not call yourself!");
        }
    });
}

CancelOutgoingCall = function() {
    if (ms.Phone.Data.currentApplication == "phone-call") {
        ms.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
        ms.Phone.Animations.TopSlideUp('.'+ms.Phone.Data.currentApplication+"-app", 400, -160);
        setTimeout(function(){
            ms.Phone.Functions.ToggleApp(ms.Phone.Data.currentApplication, "none");
        }, 400)
        ms.Phone.Functions.HeaderTextColor("white", 300);
    
        ms.Phone.Data.CallActive = false;
        ms.Phone.Data.currentApplication = null;
    }
}

$(document).on('click', '#outgoing-cancel', function(e){
    e.preventDefault();

    $.post('http://ms-phone_new/CancelOutgoingCall');
});

$(document).on('click', '#incoming-deny', function(e){
    e.preventDefault();

    $.post('http://ms-phone_new/DenyIncomingCall');
});

$(document).on('click', '#ongoing-cancel', function(e){
    e.preventDefault();
    
    $.post('http://ms-phone_new/CancelOngoingCall');
});

IncomingCallAlert = function(CallData, Canceled, AnonymousCall) {
    if (!Canceled) {
        if (!ms.Phone.Data.CallActive) {
            ms.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
            ms.Phone.Animations.TopSlideUp('.'+ms.Phone.Data.currentApplication+"-app", 400, -160);
            setTimeout(function(){
                var Label = "Incoming call from "+CallData.name
                if (AnonymousCall) {
                    Label = "You are receiving an anonymous call"
                }
                $(".call-notifications-title").html("Incoming Call");
                $(".call-notifications-content").html(Label);
                $(".call-notifications").css({"display":"block"});
                $(".call-notifications").animate({
                    right: 5+"vh"
                }, 400);
                $(".phone-call-outgoing").css({"display":"none"});
                $(".phone-call-incoming").css({"display":"block"});
                $(".phone-call-ongoing").css({"display":"none"});
                $(".phone-call-incoming-caller").html(CallData.name);
                $(".phone-app").css({"display":"none"});
                ms.Phone.Functions.HeaderTextColor("white", 400);
                $("."+ms.Phone.Data.currentApplication+"-app").css({"display":"none"});
                $(".phone-call-app").css({"display":"block"});
                setTimeout(function(){
                    ms.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                }, 400);
            }, 400);
        
            ms.Phone.Data.currentApplication = "phone-call";
            ms.Phone.Data.CallActive = true;
        }
        setTimeout(function(){
            $(".call-notifications").addClass('call-notifications-shake');
            setTimeout(function(){
                $(".call-notifications").removeClass('call-notifications-shake');
            }, 1000);
        }, 400);
    } else {
        $(".call-notifications").animate({
            right: -35+"vh"
        }, 400);
        ms.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
        ms.Phone.Animations.TopSlideUp('.'+ms.Phone.Data.currentApplication+"-app", 400, -160);
        setTimeout(function(){
            $("."+ms.Phone.Data.currentApplication+"-app").css({"display":"none"});
            $(".phone-call-outgoing").css({"display":"none"});
            $(".phone-call-incoming").css({"display":"none"});
            $(".phone-call-ongoing").css({"display":"none"});
            $(".call-notifications").css({"display":"block"});
        }, 400)
        ms.Phone.Functions.HeaderTextColor("white", 300);
        ms.Phone.Data.CallActive = false;
        ms.Phone.Data.currentApplication = null;
    }
}

// IncomingCallAlert = function(CallData, Canceled) {
//     if (!Canceled) {
//         if (!ms.Phone.Data.CallActive) {
//             $(".call-notifications-title").html("Inkomende Oproep");
//             $(".call-notifications-content").html("Je hebt een inkomende oproep van "+CallData.name);
//             $(".call-notifications").css({"display":"block"});
//             $(".call-notifications").animate({
//                 right: 5+"vh"
//             }, 400);
//             $(".phone-call-outgoing").css({"display":"none"});
//             $(".phone-call-incoming").css({"display":"block"});
//             $(".phone-call-ongoing").css({"display":"none"});
//             $(".phone-call-incoming-caller").html(CallData.name);
//             $(".phone-app").css({"display":"none"});
//             ms.Phone.Functions.HeaderTextColor("white", 400);
//             ms.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
//             $(".phone-call-app").css({"display":"block"});
//             setTimeout(function(){
//                 ms.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
//             }, 450);
        
//             ms.Phone.Data.currentApplication = "phone-call";
//             ms.Phone.Data.CallActive = true;
//         }
//         setTimeout(function(){
//             $(".call-notifications").addClass('call-notifications-shake');
//             setTimeout(function(){
//                 $(".call-notifications").removeClass('call-notifications-shake');
//             }, 1000);
//         }, 400);
//     } else {
//         $(".call-notifications").animate({
//             right: -35+"vh"
//         }, 400);
//         ms.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
//         ms.Phone.Animations.TopSlideUp('.'+ms.Phone.Data.currentApplication+"-app", 400, -160);
//         setTimeout(function(){
//             ms.Phone.Functions.ToggleApp(ms.Phone.Data.currentApplication, "none");
//             $(".phone-call-outgoing").css({"display":"none"});
//             $(".phone-call-incoming").css({"display":"none"});
//             $(".phone-call-ongoing").css({"display":"none"});
//             $(".call-notifications").css({"display":"block"});
//         }, 400)
//         ms.Phone.Functions.HeaderTextColor("white", 300);
    
//         ms.Phone.Data.CallActive = false;
//         ms.Phone.Data.currentApplication = null;
//     }
// }

ms.Phone.Functions.SetupCurrentCall = function(cData) {
    if (cData.InCall) {
        CallData = cData;
        $(".phone-currentcall-container").css({"display":"block"});

        if (cData.CallType == "incoming") {
            $(".phone-currentcall-title").html("Incoming call");
        } else if (cData.CallType == "outgoing") {
            $(".phone-currentcall-title").html("Calling");
        } else if (cData.CallType == "ongoing") {
            $(".phone-currentcall-title").html("On Call ("+cData.CallTime+")");
        }

        $(".phone-currentcall-contact").html(""+cData.TargetData.name);//conaa tinha met naquelas aspas
    } else {
        $(".phone-currentcall-container").css({"display":"none"});
    }
}

$(document).on('click', '.phone-currentcall-container', function(e){
    e.preventDefault();

    if (CallData.CallType == "incoming") {
        $(".phone-call-incoming").css({"display":"block"});
        $(".phone-call-outgoing").css({"display":"none"});
        $(".phone-call-ongoing").css({"display":"none"});
    } else if (CallData.CallType == "outgoing") {
        $(".phone-call-incoming").css({"display":"none"});
        $(".phone-call-outgoing").css({"display":"block"});
        $(".phone-call-ongoing").css({"display":"none"});
    } else if (CallData.CallType == "ongoing") {
        $(".phone-call-incoming").css({"display":"none"});
        $(".phone-call-outgoing").css({"display":"none"});
        $(".phone-call-ongoing").css({"display":"block"});
    }
    $(".phone-call-ongoing-caller").html(CallData.name);

    ms.Phone.Functions.HeaderTextColor("white", 500);
    ms.Phone.Animations.TopSlideDown('.phone-application-container', 500, 0);
    ms.Phone.Animations.TopSlideDown('.phone-call-app', 500, 0);
    ms.Phone.Functions.ToggleApp("phone-call", "block");
                
    ms.Phone.Data.currentApplication = "phone-call";
});

$(document).on('click', '#incoming-answer', function(e){
    e.preventDefault();

    $.post('http://ms-phone_new/AnswerCall');
});

ms.Phone.Functions.AnswerCall = function(CallData) {
    $(".phone-call-incoming").css({"display":"none"});
    $(".phone-call-outgoing").css({"display":"none"});
    $(".phone-call-ongoing").css({"display":"block"});
    $(".phone-call-ongoing-caller").html(CallData.TargetData.name);

    ms.Phone.Functions.Close();
}

ms.Phone.Functions.SetupSuggestedContacts = function(Suggested) {
    $(".suggested-contacts").html("");
    AmountOfSuggestions = Suggested.length;
    if (AmountOfSuggestions > 0) {
        $(".amount-of-suggested-contacts").html(AmountOfSuggestions + " contacts");
        Suggested = Suggested.reverse();
        $.each(Suggested, function(index, suggest){
            var elem = '<div class="suggested-contact" id="suggest-'+index+'"> <i class="fas fa-exclamation-circle"></i> <span class="suggested-name">'+suggest.name[0]+' '+suggest.name[1]+' &middot; <span class="suggested-number">'+suggest.number+'</span></span> </div>';
            $(".suggested-contacts").append(elem);
            $("#suggest-"+index).data('SuggestionData', suggest);
        });
    } else {
        $(".amount-of-suggested-contacts").html("0 contacts");
    }
}

$(document).on('click', '.suggested-contact', function(e){
    e.preventDefault();

    var SuggestionData = $(this).data('SuggestionData');
    SelectedSuggestion = this;

    ms.Phone.Animations.TopSlideDown(".phone-add-contact", 200, 0);
    
    $(".phone-add-contact-name").val(SuggestionData.name[0] + " " + SuggestionData.name[1]);
    $(".phone-add-contact-number").val(SuggestionData.number);
    $(".phone-add-contact-iban").val(SuggestionData.bank);
});