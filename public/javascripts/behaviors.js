
// FormExamples = $.klass({
//   initialize: function() {
//     this.element.addClass('watermarked');
//     this.element.watermark(this.element.attr('title'));
//   }
// });
// $('input[title]:not(.watermark,.watermarked), textarea[title]:not(.watermark,.watermarked)').attach(FormExamples);

ProgressBar = $.klass({
  initialize: function() {
    this.element.progressBar();
  }
});
$('.progressBar').attach(ProgressBar);

Carousel3 = $.klass({
    initialize: function() {
        this.element.jcarousel({
            scroll: 3,
            visible: 3
        });
    }
});
$('.carousel3').attach(Carousel3);

UpdatesSwitcher = $.klass({
  onclick: function(e) {
      $('#signup .updates_switcher').removeClass('off').addClass('on');
      $('#signup .login_switcher').removeClass('on').addClass('off');
      $('#email_updates_form').removeClass('inactive').addClass('active');
      $('#login_form').removeClass('active').addClass('inactive');
      return false;
  }
});
$('#signup .updates_switcher').attach(UpdatesSwitcher);

LoginSwitcher = $.klass({
  onclick: function(e) {
      $('#signup .login_switcher').removeClass('off').addClass('on');
      $('#signup .updates_switcher').removeClass('on').addClass('off');
      $('#login_form').removeClass('inactive').addClass('active');
      $('#email_updates_form').removeClass('active').addClass('inactive');
      return false;
  }
});
$('#signup .login_switcher').attach(LoginSwitcher);


OtherDonationSwitcher = $.klass({
  hideOrShowOtherAmount: function(e) {
    if(this.element.val()=="Other")
      $("#other_amount_span").show();
    else
      $("#other_amount_span").hide();
  },
  onchange: function(e) { this.hideOrShowOtherAmount(e); },
  initialize: function(e) { this.hideOrShowOtherAmount(e); }
});
$('#donation_select_box_amount_in_dollars').attach(OtherDonationSwitcher);

TableSorter = $.klass({
    initialize: function() {
        var header_options = this.element.find('th').map(function(){
            return $(this).find('.sort-icon').size() > 0 ? {} : {sorter: false};
        });
        this.element.tablesorter({
            sortList: [[0, 0]],
            headers: header_options,
            textExtraction: "complex"
        });
    }
});
$('.sortable').attach(TableSorter);
