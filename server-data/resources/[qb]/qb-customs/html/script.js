let MenuData = {
    SelectedIndex: 1,
    LastIndex: 0,
    MaxOptions: 10,
    TotalOptions: null,
    MainMenu: [],
    SubMenu: [],
    CurrentMenu: 0,
    LastMainIndex: 0,
    CurrentButtons: [],
    CurrentModId: null,
}

$(document).ready(function(){
    console.log("qb-customs: Succesfully loaded!");

    window.addEventListener('message', function(event){
        switch(event.data.action) {
            case "open":
                $(".qbus-customs").css({
                    "display":"block"
                });
                if (event.data.costs !== undefined && event.data.costs !== null) {
                    SetupMods(event.data.mods, event.data.costs);
                } else {
                    SetupMods(event.data.mods, null);
                }
                OpenCustoms();
                break;
            case "close":
                $(".menu-container").animate({
                    left: -45+"vh",
                }, 300, function(){
                    $(".qbus-customs").css({"display":"none"});
                });
                MenuData.SubMenu = [];
                MenuData.CurrentMenu = 0;
                MenuData.SelectedIndex = 1;
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
                break;
        }
    });
});

$(document).keydown(function(objEvent) {
    if (objEvent.keyCode == 9) {  //tab pressed
        objEvent.preventDefault(); // stops its action
    }
})

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 38:
            ChangeOption("up")
            break;
        case 40:
            ChangeOption("down")
            break;
        case 13:
            SubmitOption();
            break;
        case 8:
            Back()
            break;
    }
});

function ChangeOption(type) {
    if (MenuData.TotalOptions > 1) {
        if (type == "up") {
            if (MenuData.SelectedIndex - 1 < 1) {
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").removeClass('menu-option-selected');
                MenuData.SelectedIndex = MenuData.TotalOptions;
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
            } else {
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").removeClass('menu-option-selected');
                MenuData.SelectedIndex = MenuData.SelectedIndex - 1;
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
            }
        } else if (type == "down") {
            if (MenuData.SelectedIndex + 1 > MenuData.TotalOptions) {
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").removeClass('menu-option-selected');
                MenuData.SelectedIndex = 1;
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
            } else {
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").removeClass('menu-option-selected');
                MenuData.SelectedIndex = MenuData.SelectedIndex + 1;
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
            }
        }
        if (MenuData.TotalOptions >= MenuData.MaxOptions) {
            // if (MenuData.SelectedIndex !== MenuData.TotalOptions) {
                $("[data-menuindex='" + MenuData.SelectedIndex + "']")[0].scrollIntoView();
            // }
        }
        $("#menu-index").html(MenuData.SelectedIndex + " / " + MenuData.TotalOptions);
    }
    if (MenuData.CurrentModId !== "shoppingcart") {
        $.post('http://qb-customs/OnIndexChange', JSON.stringify({
            id: MenuData.CurrentModId,
            data: $("[data-menuindex='" + MenuData.SelectedIndex + "']").data('OptionData')
        }));
    }
}

function OpenCustoms() {
    $(".menu-container").animate({
        left: 0+"vh",
    }, 300, function(){
        // if (MenuData.SelectedIndex !== MenuData.TotalOptions) {
            // $("[data-menuindex='" + MenuData.SelectedIndex + "']")[0].scrollIntoView();
        // }
    });
}

function SetupMods(mods, price) {
    $(".menu-options").html("");
    $("#menu-name").html("Welcome to Benny's Motorsports");
    $("#menu-help").html("Choose a menu");
    MenuData.TotalOptions = 0;
    if (mods.length > 0) {
        MenuData.CurrentButtons = mods;
        MenuData.MainMenu = mods;
        $.each(mods, function(i, mod){
            var ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.label + ' (' + mod.buttons.length + ')</div></div>';
            $(".menu-options").append(ModElement);
            MenuData.TotalOptions = MenuData.TotalOptions + 1;
            $("[data-menuindex='" + (i + 1) + "']").data('OptionData', mod);
            MenuData.SelectedIndex = 1;
        });
        if (price !== null) {
            MenuData.TotalOptions = MenuData.TotalOptions + 1;
            var ModElement = '<div class="menu-option" data-menuindex="' + (MenuData.TotalOptions) + '"><div class="menu-option-name">Repair vehicle <div class="menu-option-price">$ ' + price + '</div></div></div>';
            $(".menu-options").prepend(ModElement);
            $("[data-menuindex='" + (MenuData.TotalOptions) + "']").data('OptionData', {
                price: price,
                id: "repairvehicle",
            });
            MenuData.SelectedIndex = MenuData.TotalOptions;
        }
    }
    $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
    $("#menu-index").html(MenuData.SelectedIndex + " / " + MenuData.TotalOptions);
    // if (MenuData.SelectedIndex !== MenuData.TotalOptions) {
        $("[data-menuindex='" + MenuData.SelectedIndex + "']")[0].scrollIntoView();
    // }
}

function SubmitOption() {
    var OptionData = $("[data-menuindex='" + MenuData.SelectedIndex + "']").data('OptionData');
    if (OptionData.id !== "repairvehicle") {
        if (OptionData.id !== "close-menu" && OptionData.id !== "shoppingcart" && OptionData.id !== "main-menu" && OptionData.id !== "buy-upgrades") {
            if (OptionData.id === null || OptionData.id === undefined) {
                if (MenuData.CurrentModId !== null) {
                    OptionData.id = MenuData.CurrentModId;
                }
            }
            $.post('http://qb-customs/GetCurrentMod', JSON.stringify({
                data: OptionData
            }), function(installedmod){
                var checkdata = null;
                if (OptionData.buttons !== null || OptionData.buttons !== undefined) {
                    checkdata = OptionData.buttons;
                }
                $.post('http://qb-customs/GetCartItem', JSON.stringify({
                    data: checkdata,
                }), function(marketitem){
                    if (OptionData.id !== null && OptionData.id !== undefined) {
                        MenuData.CurrentModId = OptionData.id;
                    }
                    if (MenuData.CurrentMenu === 0) {
                        MenuData.LastMainIndex = MenuData.SelectedIndex;
                    }
                    if (OptionData.buttons !== null && OptionData.buttons !== undefined) {
                        $.post('http://qb-customs/SelectSound');
                        if (OptionData.buttons.length > 0) {
                            $(".menu-options").html("");
                            $("[data-menuindex='" + MenuData.SelectedIndex + "']").removeClass('menu-option-selected');
                            $("#menu-name").html(OptionData.label);
                            $("#menu-help").html("Choose your mod");
                            MenuData.TotalOptions = 0;
                            MenuData.SubMenu[MenuData.CurrentMenu] = {
                                buttons: MenuData.CurrentButtons,
                                lastindex: MenuData.SelectedIndex,
                                label: OptionData.label,
                            }
                            MenuData.CurrentMenu = MenuData.CurrentMenu + 1;
                            MenuData.CurrentButtons = OptionData.buttons;
                            var ModPrice = 0;
                            $.each(OptionData.buttons, function(i, mod){
                                var ModElement;
                                if (mod.price !== null && mod.price !== undefined) {
                                    if (mod.increaseby === undefined) {
                                        mod.increaseby = 0;
                                    }
                                    if (i == 1) {
                                        ModPrice = mod.price;
                                    }
                                    if (mod.increaseby !== 0) {
                                        ModPrice = ModPrice + mod.increaseby;
                                    } else {
                                        ModPrice = mod.price;
                                    }
                                    mod.originalprice = ModPrice;
                                    if (MenuData.CurrentModId == "respray" || MenuData.CurrentModId == "wheels" || MenuData.CurrentModId == "wheelaccessories" || installedmod > -1) {
                                        if (installedmod > -1 && i == installedmod + 1) {
                                            mod.bought = true;
                                            ModElement = '<div class="menu-option equiped-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.name + ' <div class="menu-option-price"><i class="fas fa-check equiped-check"></i></div></div></div>';
                                        } else if (marketitem > -1 && i == marketitem + 1) {
                                            mod.cart = true;
                                            ModElement = '<div class="menu-option cart-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.name + ' <div class="menu-option-price"><i class="fas fa-shopping-cart equiped-check"></i></div></div></div>';
                                            $.post('http://qb-customs/ToggleCartedItem', JSON.stringify({toggle: true}));
                                        } else if (mod.price == 0) {
                                            mod.bought = false;
                                            ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.name + ' <div class="menu-option-price">FREE</div></div></div>';
                                        } else {
                                            mod.bought = false;
                                            ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.name + ' <div class="menu-option-price">$' + ModPrice + '</div></div></div>';
                                        }
                                    }
    
                                    if (MenuData.CurrentModId == "respray" || MenuData.CurrentModId == "wheels" || MenuData.CurrentModId == "wheelaccessories" || marketitem > -1) {
                                        if (marketitem > -1 && i == marketitem + 1) {
                                            mod.cart = true;
                                            ModElement = '<div class="menu-option cart-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.name + ' <div class="menu-option-price"><i class="fas fa-shopping-cart equiped-check"></i></div></div></div>';
                                            $.post('http://qb-customs/ToggleCartedItem', JSON.stringify({toggle: true}));
                                        } else if (installedmod > -1 && i == installedmod + 1) {
                                            mod.bought = true;
                                            ModElement = '<div class="menu-option equiped-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.name + ' <div class="menu-option-price"><i class="fas fa-check equiped-check"></i></div></div></div>';
                                        } else if (mod.price == 0) {
                                            mod.cart = false;
                                            ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.name + ' <div class="menu-option-price">FREE</div></div></div>';
                                        } else {
                                            mod.cart = false;
                                            ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.name + ' <div class="menu-option-price">$' + ModPrice + '</div></div></div>';
                                        }
                                    } 
                                    
                                    if (marketitem == -1 && installedmod == -1) {
                                        if (mod.price == 0) {
                                            mod.bought = true;
                                            ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.name + ' <div class="menu-option-price"><i class="fas fa-check equiped-check"></i></div></div></div>';
                                        } else {
                                            mod.bought = false;
                                            ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.name + ' <div class="menu-option-price">$' + ModPrice + '</div></div></div>';
                                        }
                                    }
                                } else {
                                    var Name;
                                    if (mod.label !== undefined) {
                                        Name = mod.label;
                                    } else {
                                        Name = mod.name;
                                    }
                                    ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + Name + ' (' + mod.buttons.length + ')</div></div>';
                                }
                                $(".menu-options").append(ModElement);
                                MenuData.TotalOptions = MenuData.TotalOptions + 1;
                                if (i == installedmod + 1) {
                                    $("[data-menuindex='" + (i + 1) + "']").data('OptionData', mod);
                                } else {
                                    $("[data-menuindex='" + (i + 1) + "']").data('OptionData', mod);
                                }
                            })
                            MenuData.SelectedIndex = 1;
                            $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
                        } 
                    } else {
                        $.post('http://qb-customs/SelectSound');
                        if (!OptionData.bought) {
                            if (!OptionData.cart || OptionData.cart === undefined){
                                var CurrentEquiped = $(".cart-option");
                                if (CurrentEquiped.length > 0) {
                                    var PreviousData = $(".cart-option").data('OptionData');
                                    var pricelabel
                                    if (PreviousData.originalprice === 0) {
                                        pricelabel = "FREE";
                                    } else {
                                        pricelabel = "$" + PreviousData.originalprice;
                                    }
                                    if (!$("[data-menuindex='" + MenuData.SelectedIndex + "']").hasClass('cart-option')){
                                        $(".cart-option").find('.menu-option-price').html(pricelabel);
                                        $(".cart-option").removeClass('cart-option');
                                        PreviousData.cart = false;
        
                                        $.post('http://qb-customs/RemoveCartItem', JSON.stringify({
                                            ItemData: PreviousData,
                                        }));
        
                                        $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('cart-option');
                                        $(".cart-option").find('.menu-option-price').html('<i class="fas fa-shopping-cart equiped-check"></i>');
                                        OptionData.cart = true;
        
                                        $.post('http://qb-customs/AddItemToCart', JSON.stringify({
                                            ItemData: OptionData,
                                        }));
                                    } else {
                                        $(".cart-option").find('.menu-option-price').html(pricelabel);
                                        $(".cart-option").removeClass('cart-option');
                                        PreviousData.cart = false;
        
                                        $.post('http://qb-customs/RemoveCartItem', JSON.stringify({
                                            ItemData: OptionData,
                                        }));
                                    }
                                } else {
                                    $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('cart-option');
                                    $(".cart-option").find('.menu-option-price').html('<i class="fas fa-shopping-cart equiped-check"></i>');
                                    OptionData.cart = true;
        
                                    $.post('http://qb-customs/AddItemToCart', JSON.stringify({
                                        ItemData: OptionData,
                                    }));
                                }
                            } else {
                                $.post('http://qb-customs/SelectSound');
                                if (MenuData.CurrentMenu === "shoppingcart") {
                                    console.log('Delete cart item');
                                } else {
                                    var pricelabel
                                    if (OptionData.originalprice === 0) {
                                        pricelabel = "FREE";
                                    } else {
                                        pricelabel = "$" + OptionData.originalprice;
                                    }
    
                                    $(".cart-option").find('.menu-option-price').html(pricelabel);
                                    $(".cart-option").removeClass('cart-option');
                                    OptionData.cart = false;
            
                                    $.post('http://qb-customs/RemoveCartItem', JSON.stringify({
                                        ItemData: OptionData,
                                    }));
                                }
                            } 
                        }
                    }
                    $("#menu-index").html(MenuData.SelectedIndex + " / " + MenuData.TotalOptions);
                    // if (MenuData.SelectedIndex !== MenuData.TotalOptions) {
                        $("[data-menuindex='" + MenuData.SelectedIndex + "']")[0].scrollIntoView();
                    // }
                    $.post('http://qb-customs/OnIndexChange', JSON.stringify({
                        id: MenuData.CurrentModId,
                        data: $("[data-menuindex='" + MenuData.SelectedIndex + "']").data('OptionData')
                    }));
                });
            });
        } else if (OptionData.id == "buy-upgrades") {
            $.post('http://qb-customs/SelectSound');
            $.post('http://qb-customs/PurchaseUpgrades');
        } else if (OptionData.id == "shoppingcart") {
            $.post('http://qb-customs/SelectSound');
            $(".menu-options").html("");
            $("[data-menuindex='" + MenuData.SelectedIndex + "']").removeClass('menu-option-selected');
            MenuData.TotalOptions = 0;
            var TotalCartPrice = 0;
            if (OptionData.buttons.length > 0) {
                $.each(OptionData.buttons, function(i, mod){
                    var label = mod.label;
                    if (label === undefined || label === null) {
                        label = mod.name;
                    }
                    var pricelabel;
                    if (mod.originalprice === 0) {
                        pricelabel = "FREE";
                    } else {
                        pricelabel = "$" + mod.originalprice;
                    }
                    var ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + label + ' <div class="menu-option-price">' + pricelabel + '</div></div></div>';
                    $(".menu-options").append(ModElement);
                    mod.cart = true;
                    $("[data-menuindex='" + (i + 1) + "']").data('OptionData', mod);
                    MenuData.TotalOptions = MenuData.TotalOptions + 1;
                    TotalCartPrice = TotalCartPrice + mod.originalprice;
                });
            }
    
            $("#menu-name").html("Shopping Cart");
            $("#menu-help").html("Total price: $" + TotalCartPrice);
    
            MenuData.TotalOptions = MenuData.TotalOptions + 1;
            $(".menu-options").append('<div class="menu-option" data-menuindex="' + MenuData.TotalOptions + '"><div class="menu-option-name">Confirm Setup<div class="menu-option-price">$' + TotalCartPrice + '</div></div></div>');
            $("[data-menuindex='" + MenuData.TotalOptions + "']").data('OptionData', {
                id: "buy-upgrades",
            });
    
            MenuData.SubMenu = [];
            MenuData.CurrentMenu = "shoppingcart";
            MenuData.SelectedIndex = 1;
            $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
            $("#menu-index").html(MenuData.SelectedIndex + " / " + MenuData.TotalOptions);
            // if (MenuData.SelectedIndex !== MenuData.TotalOptions) {
                $("[data-menuindex='" + MenuData.SelectedIndex + "']")[0].scrollIntoView();
            // }
        } else if (OptionData.id === "main-menu") {
            $.post('http://qb-customs/SelectSound');
            $(".menu-options").html("");
            $("#menu-name").html("Welcome to Benny's Motorsports");
            $("#menu-help").html("Choose a menu");
            MenuData.TotalOptions = 0;
            if (MenuData.MainMenu.length > 0) {
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").removeClass('menu-option-selected');
                MenuData.CurrentButtons = MenuData.MainMenu;
                $.each(MenuData.MainMenu, function(i, mod){
                    var ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.label + ' (' + mod.buttons.length + ')</div></div>';
                    $(".menu-options").append(ModElement);
                    MenuData.TotalOptions = MenuData.TotalOptions + 1;
                    $("[data-menuindex='" + (i + 1) + "']").data('OptionData', mod);
                });
                MenuData.SelectedIndex = 1;
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
                // if (MenuData.SelectedIndex !== MenuData.TotalOptions) {
                    $("[data-menuindex='" + MenuData.SelectedIndex + "']")[0].scrollIntoView();
                // }
            }
            $("#menu-index").html(MenuData.SelectedIndex + " / " + MenuData.TotalOptions);
            MenuData.SubMenu = [];
            MenuData.CurrentMenu = 0;
        } else {
            $.post('http://qb-customs/QuitSound');
            $(".menu-container").animate({
                left: -45+"vh",
            }, 300, function(){
                $(".qbus-customs").css({"display":"none"});
            });
            MenuData.SubMenu = [];
            MenuData.CurrentMenu = 0;
            $.post('http://qb-customs/CloseMenu');
        }
    } else {
        $.post('http://qb-customs/CanRepairVehicle', JSON.stringify({
            price: OptionData.price
        }), function(CanRepair){
            if (CanRepair) {
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").removeClass('menu-option-selected');
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").remove();
                MenuData.SelectedIndex = 1;
                $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
                // if (MenuData.SelectedIndex !== MenuData.TotalOptions) {
                    $("[data-menuindex='" + MenuData.SelectedIndex + "']")[0].scrollIntoView();
                // }
            }
        });
    }
}

function Back() {
    $.post('http://qb-customs/BackSound');
    if (MenuData.CurrentMenu !== "shoppingcart") {
        if (MenuData.SubMenu[0] !== null && MenuData.SubMenu[0] !== undefined) {
            if (MenuData.CurrentMenu - 1 !== 0) {
                var LastMenu = MenuData.CurrentMenu - 1
                if (MenuData.SubMenu[LastMenu] !== null && MenuData.SubMenu[LastMenu] !== undefined) {
                    $(".menu-options").html("");
                    MenuData.TotalOptions = 0;
                    if (MenuData.SubMenu[LastMenu].buttons.length > 0) {
                        $("[data-menuindex='" + MenuData.SelectedIndex + "']").removeClass('menu-option-selected');
                        var ModPrice = 0;
                        $.each(MenuData.SubMenu[LastMenu].buttons, function(i, button){
                            var ModElement;
                            if (button.price !== null && button.price !== undefined) {
                                if (button.increaseby === undefined) {
                                    button.increaseby = 0;
                                }
                                if (button.increaseby !== 0) {
                                    ModPrice = ModPrice + button.increaseby;
                                } else {
                                    ModPrice = button.price;
                                }
                                if (button.equiped === undefined && button.equiped === null) {
                                    button.equiped = false;
                                }
                                if (button.equiped) {
                                    ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + button.name + ' <div class="menu-option-price">INSTALLED</div></div></div>';
                                } else if (button.price == 0) {
                                    ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + button.name + ' <div class="menu-option-price">FREE</div></div></div>';
                                } else {
                                    ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + button.name + ' <div class="menu-option-price">$' + ModPrice + '</div></div></div>';
                                }
                            } else {
                                var Name;
                                if (button.label !== undefined) {
                                    Name = button.label;
                                } else {
                                    Name = button.name;
                                }
                                ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + Name + ' (' + button.buttons.length + ')</div></div>';
                            }
                            $(".menu-options").append(ModElement);
                            MenuData.TotalOptions = MenuData.TotalOptions + 1;
                            $("[data-menuindex='" + (i + 1) + "']").data('OptionData', button);
                        })
                        MenuData.SelectedIndex = MenuData.SubMenu[LastMenu].lastindex;
                        $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
                    }
                    MenuData.CurrentButtons = MenuData.SubMenu[LastMenu].buttons;
                    MenuData.SubMenu[LastMenu] = null;
                    if (MenuData.CurrentMenu - 1 > 0) {
                        MenuData.CurrentMenu = (MenuData.CurrentMenu - 1);
                    } else {
                        MenuData.CurrentMenu = 0;
                    }
                    $("#menu-index").html(MenuData.SelectedIndex + " / " + MenuData.TotalOptions);
                    // if (MenuData.SelectedIndex !== MenuData.TotalOptions) {
                        $("[data-menuindex='" + MenuData.SelectedIndex + "']")[0].scrollIntoView();
                    // }
                }
                $.post('http://qb-customs/OnIndexChange', JSON.stringify({
                    id: MenuData.CurrentModId,
                    data: $("[data-menuindex='" + MenuData.SelectedIndex + "']").data('OptionData')
                }));
            } else {
                $.post('http://qb-customs/CheckIfCartedItem');
                $(".menu-options").html("");
                $("#menu-name").html("Welcome to Benny's Motorsports");
                $("#menu-help").html("Choose a menu");
                MenuData.TotalOptions = 0;
                if (MenuData.MainMenu.length > 0) {
                    $("[data-menuindex='" + MenuData.SelectedIndex + "']").removeClass('menu-option-selected');
                    MenuData.CurrentButtons = MenuData.MainMenu;
                    $.each(MenuData.MainMenu, function(i, mod){
                        var ModElement = '<div class="menu-option" data-menuindex="' + (i + 1) + '"><div class="menu-option-name">' + mod.label + ' (' + mod.buttons.length + ')</div></div>';
                        $(".menu-options").append(ModElement);
                        MenuData.TotalOptions = MenuData.TotalOptions + 1;
                        $("[data-menuindex='" + (i + 1) + "']").data('OptionData', mod);
                    });
                    MenuData.SelectedIndex = MenuData.LastMainIndex;
                    $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
                    // if (MenuData.SelectedIndex !== MenuData.TotalOptions) {
                        $("[data-menuindex='" + MenuData.SelectedIndex + "']")[0].scrollIntoView();
                    // }
                }
                $("#menu-index").html(MenuData.SelectedIndex + " / " + MenuData.TotalOptions);
                MenuData.SubMenu = [];
                MenuData.CurrentMenu = 0;
            }
        } else {
            if (MenuData.CurrentMenu - 1 >= -1) {
                $.post('http://qb-customs/GetShoppingCart', JSON.stringify({}), function(ShoppingCart){
                    $(".menu-options").html("");
                    var ModElement;
                    if (ShoppingCart.buttons.length > 0) {
                        ModElement = '<div class="menu-option" data-menuindex="1"><div class="menu-option-name">Shopping Cart <div class="menu-option-price"><i class="fas fa-shopping-cart equiped-check"></i> ' + ShoppingCart.buttons.length + '</div></div></div>'+
                        '<div class="menu-option" data-menuindex="2"><div class="menu-option-name">Main menu</div></div>' +
                        '<div class="menu-option" data-menuindex="3"><div class="menu-option-name">Close menu</div></div>';
        
                        $(".menu-options").append(ModElement);
                        $("[data-menuindex='1']").data('OptionData', ShoppingCart)
                        $("[data-menuindex='2']").data('OptionData', {
                            id: "main-menu"
                        });
                        $("[data-menuindex='3']").data('OptionData', {
                            id: "close-menu"
                        });
                        MenuData.TotalOptions = 3;
                    } else {
                        ModElement = '<div class="menu-option" data-menuindex="1"><div class="menu-option-name">Main menu</div></div>'+
                        '<div class="menu-option" data-menuindex="2"><div class="menu-option-name">Close menu</div></div>';
                        $(".menu-options").append(ModElement);
                        $("[data-menuindex='1']").data('OptionData', {
                            id: "main-menu"
                        });
                        $("[data-menuindex='2']").data('OptionData', {
                            id: "close-menu"
                        });
                        MenuData.TotalOptions = 2;
                    }
        
                    MenuData.SubMenu = [];
                    MenuData.CurrentMenu = -1;
                    MenuData.SelectedIndex = 1;
                    $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
                    $("#menu-index").html(MenuData.SelectedIndex + " / " + MenuData.TotalOptions);
                    // if (MenuData.SelectedIndex !== MenuData.TotalOptions) {
                        $("[data-menuindex='" + MenuData.SelectedIndex + "']")[0].scrollIntoView();
                    // }
                });
            }
        }
    } else {
        $.post('http://qb-customs/GetShoppingCart', JSON.stringify({}), function(ShoppingCart){
            $(".menu-options").html("");
            var ModElement;
            if (ShoppingCart.buttons.length > 0) {
                ModElement = '<div class="menu-option" data-menuindex="1"><div class="menu-option-name">Shopping Cart <div class="menu-option-price"><i class="fas fa-shopping-cart equiped-check"></i> ' + ShoppingCart.buttons.length + '</div></div></div>'+
                '<div class="menu-option" data-menuindex="2"><div class="menu-option-name">Main menu</div></div>' +
                '<div class="menu-option" data-menuindex="3"><div class="menu-option-name">Close menu</div></div>';

                $(".menu-options").append(ModElement);
                $("[data-menuindex='1']").data('OptionData', ShoppingCart)
                $("[data-menuindex='2']").data('OptionData', {
                    id: "main-menu"
                });
                $("[data-menuindex='3']").data('OptionData', {
                    id: "close-menu"
                });
                MenuData.TotalOptions = 3;
            } else {
                ModElement = '<div class="menu-option" data-menuindex="1"><div class="menu-option-name">Main menu</div></div>'+
                '<div class="menu-option" data-menuindex="2"><div class="menu-option-name">Close menu</div></div>';
                $(".menu-options").append(ModElement);
                $("[data-menuindex='1']").data('OptionData', {
                    id: "main-menu"
                });
                $("[data-menuindex='2']").data('OptionData', {
                    id: "close-menu"
                });
                MenuData.TotalOptions = 2;
            }

            MenuData.SubMenu = [];
            MenuData.CurrentMenu = -1;
            MenuData.SelectedIndex = 1;
            $("[data-menuindex='" + MenuData.SelectedIndex + "']").addClass('menu-option-selected');
            $("#menu-index").html(MenuData.SelectedIndex + " / " + MenuData.TotalOptions);
            // if (MenuData.SelectedIndex !== MenuData.TotalOptions) {
                $("[data-menuindex='" + MenuData.SelectedIndex + "']")[0].scrollIntoView();
            // }
        });
    }
}