/*
  Author: Lumberjacks
  Template: Safety First (Coming Soon)
  Version: 1.0
  URL: http://themeforest.net/user/Lumberjacks/
*/

(function($) {
  "use strict";

  $(document).ready(function (){

    // Countdown
    // To change date, simply edit: var endDate = "June 26, 2015 20:39:00";
    $(function() {
      var endDate = "June 26, 2015 20:39:00";
      $('.lj-countdown .row').countdown({
        date: endDate,
        render: function(data) {
          $(this.el).html('<div><div><span>' + (parseInt(this.leadingZeros(data.years, 2)*365) + parseInt(this.leadingZeros(data.days, 2))) + '</span><span>days</span></div><div><span>' + this.leadingZeros(data.hours, 2) + '</span><span>hours</span></div></div><div class="lj-countdown-ms"><div><span>' + this.leadingZeros(data.min, 2) + '</span><span>minutes</span></div><div><span>' + this.leadingZeros(data.sec, 2) + '</span><span>seconds</span></div></div>');
        }
      });
    });

    // Owl Carousel
    var owl = $('.lj-carousel');

    owl.owlCarousel({
      navigation : false,
      slideSpeed : 300,
      paginationSpeed : 400,
      responsiveRefreshRate : 0,
      rewindNav: false,
      singleItem: true,
      pagination : false,
      addClassActive: true,
      autoHeight : true,
      afterMove: selectMenuItem
    });

    // Owl Carousel - keyboard nav
    var owlkey = owl.data('owlCarousel');

    $(document.documentElement).keyup(function(event) {
        // handle cursor keys
        if (event.keyCode == 37) {
            owlkey.prev();
        } else if (event.keyCode == 39) {
            owlkey.next();
        }
    });

    // Owl Carousel - select active item in menu
    function selectMenuItem(){
      var currentItem = $('.owl-item.active').index();
      $('.activePage').removeClass('activePage');
      $('#slide-' + currentItem).addClass('activePage');
    }    

    // Owl Carousel - menu elements
    $('.lj-menu a').filter(function(){ return this.id.match(/slide-?/); }).click(function(e){
      var slide = parseInt(this.id.substr(this.id.length - 1));
      owl.trigger('owl.goTo',slide);
      e.preventDefault();
    })

    // Owl Carousel - disabling dragging element(s) while sliding
    $(".disable-owl-swipe").on("touchstart mousedown", function(e) {
        e.stopPropagation();
    })

    // E-mail validation via regular expression
    function isValidEmailAddress(emailAddress) {
      var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
      return pattern.test(emailAddress);
    };

    // Ajax mailchimp
    // Example MailChimp url: http://xxx.xxx.list-manage.com/subscribe/post?u=xxx&id=xxx
    $('#subscribe').ajaxChimp({
      language: 'lj',
      url: 'put_your_mailchimp_url_here'
    });

    // Mailchimp translation
    //
    // Defaults:
    //'submit': 'Submitting...',
    //  0: 'We have sent you a confirmation email',
    //  1: 'Please enter a value',
    //  2: 'An email address must contain a single @',
    //  3: 'The domain portion of the email address is invalid (the portion after the @: )',
    //  4: 'The username portion of the email address is invalid (the portion before the @: )',
    //  5: 'This email address looks fake or invalid. Please enter a real email address'

    $.ajaxChimp.translations.lj = {
      'submit': 'Submitting...',
      0: '<i class="fa fa-check"></i> We will be in touch soon!',
      1: '<i class="fa fa-warning"></i> You must enter a valid e-mail address.',
      2: '<i class="fa fa-warning"></i> E-mail address is not valid.',
      3: '<i class="fa fa-warning"></i> E-mail address is not valid.',
      4: '<i class="fa fa-warning"></i> E-mail address is not valid.',
      5: '<i class="fa fa-warning"></i> E-mail address is not valid.'
    }

    // Contact form functions
    $(function () {
      $("#contactform").submit(function (event) {
        var input = $('.lj-contact-message');
          if(!input.is(':empty')) {
            input.stop(true);
          }
          event.preventDefault();
          event.stopImmediatePropagation();

          var name = $("input#contact-name").val();
          var email = $("input#contact-email").val();
          var message = $("textarea#contact-message").val();

          if (name == "" || email == "" || message == "") {

            input.stop(true).html('<i class="fa fa-warning"></i> All fields are required.');
            //$("input#contact-email").focus();
          }
          else if (!isValidEmailAddress( email )) {
            input.stop(true).html('<i class="fa fa-warning"></i> E-mail address is not valid.');
            $("input#contact-email").focus();
          }
          else {
            $.ajax({
              type: "POST",
              url: "./php/send-contact.php",
              data: {contact_email:email,
                     contact_name:name,
                     contact_message:message},
              success: function () {
                input.html('<i class="fa fa-check"></i> Thank you for your message!');
                $('input#contact-name').val('');
                $('input#contact-email').val('');
                $('textarea#contact-message').val('');
              }
            });
          }
       });
    });

    // backstretch
    $("header").backstretch([
        "img/bg-2.jpg"
      , "img/bg-3.jpg"
      , "img/bg-1.jpg"
	  , "img/bg-4.jpg"
	  , "img/bg-5.jpg"
    ],{duration: 4400, fade: 1500});

    // Header's wrapper vertical centering
    function wrapperCentering(){
      var wrapper_height = $('.wrapper').height();
      var negative_margin = -(wrapper_height / 2);
      $('.wrapper').css({'marginTop':negative_margin+'px'});
    }

    wrapperCentering();

  });

  // Preloader
  // Change delay and fadeOut speed (in miliseconds)
  $(window).load(function() {
    $(".lj-preloader").delay(4000).fadeOut(6000);
  });

})(jQuery);