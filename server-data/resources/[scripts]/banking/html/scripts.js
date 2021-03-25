// Credit to Kanersps @ EssentialMode and Eraknelo @FiveM
function addGaps(nStr) {
  nStr += '';
  var x = nStr.split('.');
  var x1 = x[0];
  var x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + '<span style="margin-left: 3px; margin-right: 3px;"/>' + '$2');
  }
  return x1 + x2;
}
function addCommas(nStr) {
  nStr += '';
  var x = nStr.split('.');
  var x1 = x[0];
  var x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + ',<span style="margin-left: 0px; margin-right: 1px;"/>' + '$2');
  }
  return x1 + x2;
}

$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;


  function triggerClick(x, y) {
      var element = $(document.elementFromPoint(x, y));
      element.focus().click();
      return true;
  }

  // Partial Functions
  function closeMain() {
    $(".home").css("display", "none");
  }
  function openMain() {
    $(".home").css("display", "block");
  }
  function openMain() {
    $(".home").css("display", "block");
  }
  function closeAll() {
    $(".body").css("display", "none");
  }
  function openBalance() {
    $(".balance-container").css("display", "block");
  }
  function openWithdraw() {
    $(".withdraw-container").css("display", "block");
  }
  function openDeposit() {
    $(".deposit-container").css("display", "block");
  }
  function openTransfer() {
    $(".transfer-container").css("display", "block");
  }
  function openContainer() {
    $(".bank-container").fadeIn(400);
  }
  function closeContainer() {
    $(".bank-container").fadeOut(250);
  }

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Open & Close main bank window
    if(item.openBank == true) {
      $('.currentBalance').html('&euro;'+addCommas(item.PlayerData.money.bank));
      $('.username').html(item.PlayerData.charinfo.firstname + " " + item.PlayerData.charinfo.lastname);
      openContainer();
      openMain();
    }

    if(item.updateBalance) {
      $('.currentBalance').html('&euro;'+addCommas(item.PlayerData.money.bank));
      console.log(item.PlayerData.money.bank)
    }

    if(item.openBank == false) {
      closeContainer();
      closeMain();
    }
    // Open sub-windows / partials
    if(item.openSection == "balance") {
      closeAll();
      openBalance();
    }
    if(item.openSection == "withdraw") {
      closeAll();
      openWithdraw();
    }
    if(item.openSection == "deposit") {
      closeAll();
      openDeposit();
    }
  });
  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (data.which == 27 ) {
      $.post('http://banking/close', JSON.stringify({}));
    }
  };
  // Handle Button Presses
  $(".btnWithdraw").click(function(){
      $.post('http://banking/withdraw', JSON.stringify({}));
  });
  $(".btnDeposit").click(function(){
      $.post('http://banking/deposit', JSON.stringify({}));
  });
  $(".btnBalance").click(function(){
      $.post('http://banking/balance', JSON.stringify({}));
  });
  $(".btnClose").click(function(){
      $.post('http://banking/close', JSON.stringify({}));
  });

  $(".btnHome").click(function(){
      closeAll();
      openMain();
  });
  // Handle Form Submits
  $("#withdraw-form").submit(function(e) {
      e.preventDefault();
      var amount = parseInt($("#withdraw-form #amount").val());

      if (amount >= 0 ) {
        $.post('http://banking/withdrawSubmit', JSON.stringify({
            amount: $("#withdraw-form #amount").val()
        }));
      }

      closeAll();
      openMain();

      $("#withdraw-form #amount").val('')
  });
  $("#deposit-form").submit(function(e) {
      e.preventDefault();
      var amount = parseInt($("#deposit-form #amount").val());

      if (amount >= 0 ) {
        $.post('http://banking/depositSubmit', JSON.stringify({
            amount: $("#deposit-form #amount").val()
        }));
      }

      closeAll();
      openMain();
      
      $("#deposit-form #amount").val('')
  });
});
