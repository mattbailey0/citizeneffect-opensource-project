var WOOT = null;

	$(document).ready(function() {

    // this gets close, turning off floating of the form fields helps, still looks messed up though.  can have Sartori take a look
//       $.updnWatermark.attachAll();
	
		if (jQuery.browser.version != '6.0') {
			$('#grayBox,#grayBox2').selectbox( {
				'inputClass' : 'selectbox selectBoxGray'
			});
			$('#grayBox3,#grayBox4,#grayBox5').selectbox( {
				'inputClass' : 'selectbox selectBoxGrayLarge'
			});
			$('#blueBox2').selectbox( {
				'inputClass' : 'selectbox selectBoxBlue'
			});
		}

    $('#featured_projects ul#carousel_container ul.thumbs li:first > a').addClass('active');
     
    function mycarousel_initCallback(carousel) {
    	 jQuery("#featured_projects #featured-thumbnail-next").bind('click', function() {
    			 carousel.next();
    			 return false;
    	 });
     
    	 jQuery("#featured_projects #featured-thumbnail-prev").bind('click', function() {
    			 carousel.prev();
    			 return false;
    	 });
    };
    	 
    function mycarousel_initCallback2(carousel) {
        carousel.container.parent().find(".next a, .slideshow_next a, .contact_next, a.next").bind('click', function() {
    			 carousel.next();
    			 return false;
    	 });
     
        carousel.container.parent().find(".prev a, .slideshow_prev a, .contact_prev, a.prev").bind('click', function() {
    			 carousel.prev();
    			 return false;
    	 });
    };
    	 
    function mycarousel_initCallback_album_lightbox(carousel) {
        carousel.container.parent().parent().find(".album_next a").bind('click', function() {
    			 carousel.next();
    			 return false;
    	 });
     
        carousel.container.parent().parent().find(".album_prev a").bind('click', function() {
    			 carousel.prev();
    			 return false;
    	 });
    };

    function mycarousel_cpitemLoadCallback(carousel, state)
    {
      if(!carousel.has(1, 1))
      { carousel.add(1, $("#item1needingacp").html()); }

      var indexToFill = carousel.first+1
      if (carousel.has(indexToFill, indexToFill)) { return; }
     
      jQuery.get('projects/carousel', { index: indexToFill, type: "cp"},
                 function(html) { carousel.add(indexToFill, html); }, 'html');
    };

    function mycarousel_donationitemLoadCallback(carousel, state)
    {
      if(!carousel.has(1, 1))
      { carousel.add(1, $("#item1needingadonation").html()); }

      var indexToFill = carousel.first+1
      if (carousel.has(indexToFill, indexToFill)) { return; }
     
      jQuery.get('projects/carousel', { index: indexToFill, type: "donation"},
                 function(html) { carousel.add(indexToFill, html); }, 'html');
    };
    	 
   	// Ride the carousel...
		jQuery(document).ready(function() {
			 jQuery("#featured_projects ul#carousel_container ul#carousel_inner").jcarousel({
	         scroll: 5,
					 visible: 5,
					 initCallback: mycarousel_initCallback,
					 // This tells jCarousel NOT to autobuild prev/next buttons
					 buttonNextHTML: null,
					 buttonPrevHTML: null
			 });

        var common_new_carousel_options = {
// 	         scroll: 1,
// 					 visible: 1,
					 initCallback: mycarousel_initCallback2,
					 // This tells jCarousel NOT to autobuild prev/next buttons
					 buttonNextHTML: null,
					 buttonPrevHTML: null
        };

	      function setNeedingCPCounter(carousel, item, idx, state) {
            $("#needing-a-cp-counter").html(idx);
	      }

	      function setNeedingDonationCounter(carousel, item, idx, state) {
            $("#needing-donations-counter").html(idx);
	      }

        var new_carousel_1_options = {scroll: 1, visible: 1};
        jQuery(".external_control_carousel_1").jcarousel($.extend({}, common_new_carousel_options, new_carousel_1_options));


        jQuery(".internal_control_carousel_1").jcarousel(new_carousel_1_options);
      
      var ncpc = jQuery(".external_control_carousel.needing_a_cp_carousel");
      var needing_a_cp_options = {scroll: 1, visible: 1, size: parseInt(ncpc.attr("data-size")), itemVisibleInCallback: { onBeforeAnimation: setNeedingCPCounter }, itemLoadCallback: mycarousel_cpitemLoadCallback};
      ncpc.jcarousel($.extend({}, common_new_carousel_options, needing_a_cp_options));

      var ndpc = jQuery(".external_control_carousel.needing_donations_carousel");
      var needing_donations_options = {scroll: 1, visible: 1, size: parseInt(ndpc.attr("data-size")), itemVisibleInCallback: { onBeforeAnimation: setNeedingDonationCounter}, itemLoadCallback: mycarousel_donationitemLoadCallback};
      ndpc.jcarousel($.extend({}, common_new_carousel_options, needing_donations_options));

        var new_carousel_4_options = {scroll: 4, visible: 4};
        jQuery(".external_control_carousel_4").jcarousel($.extend({}, common_new_carousel_options, new_carousel_4_options));

        var new_carousel_3_options = {scroll: 3, visible: 3};
        jQuery(".external_control_carousel_3").jcarousel($.extend({}, common_new_carousel_options, new_carousel_3_options));

        var new_carousel_7_options = {scroll: 7, visible: 7};
        jQuery(".external_control_carousel_7").jcarousel($.extend({}, common_new_carousel_options, new_carousel_7_options));
                             
	      function set_album_lightbox_counter(carousel, item, idx, state) {
            carousel.container.parent().find('.album_lightbox_counter').html(idx);
	      }

        var album_lightbox_large_carousel = null;
        var album_lightbox_small_carousel = null;

        function mycarousel_initCallback_album_lightbox_large(carousel) {
            album_lightbox_large_carousel = carousel;
            carousel.container.parent().parent().find(".album_next a").bind('click', function() {
              carousel.next();
              album_lightbox_small_carousel.scroll(carousel.first);
              album_lightbox_small_carousel.get(carousel.first).parent().find('.current').removeClass('current');
              album_lightbox_small_carousel.get(carousel.first).find('.small_item').addClass('current');
    			    return false;
    	      });
            
            carousel.container.parent().parent().find(".album_prev a").bind('click', function() {
              carousel.prev();
              album_lightbox_small_carousel.scroll(carousel.first);
              album_lightbox_small_carousel.get(carousel.first).parent().find('.current').removeClass('current');
              album_lightbox_small_carousel.get(carousel.first).find('.small_item').addClass('current');
    			    return false;
    	      });
        };

        function mycarousel_initCallback_album_lightbox_small(carousel) {
            album_lightbox_small_carousel = carousel;
            
            carousel.container.find('a').bind('click', function() {
                var classes = carousel.list.children('li').map(function(){return $(this).attr('class');});
                var idx = $.inArray($(this).closest('li').attr('class'), classes) + 1;

                $(this).closest('ul').find('.current').removeClass('current');
                $(this).closest('.small_item').addClass('current');

                album_lightbox_large_carousel.scroll(idx);
                return false;
            });

            carousel.container.parent().find(".next a, .slideshow_next a, .contact_next, a.next").bind('click', function() {
    			      carousel.next();
    			      return false;
    	      });
            
            carousel.container.parent().find(".prev a, .slideshow_prev a, .contact_prev, a.prev").bind('click', function() {
    			      carousel.prev();
    			      return false;
    	      });
        };

        $(document).bind('afterReveal.facebox', function() { 
            var album_carousel_large_options = {
                initCallback: mycarousel_initCallback_album_lightbox_large,
                itemVisibleInCallback: { onBeforeAnimation: set_album_lightbox_counter }
            };
            jQuery("#facebox .external_control_carousel_delayed").jcarousel($.extend({}, common_new_carousel_options, new_carousel_1_options, album_carousel_large_options));

            var album_carousel_small_options = {
                initCallback: mycarousel_initCallback_album_lightbox_small
            };
            jQuery("#facebox .external_control_carousel_7_delayed").jcarousel($.extend({}, common_new_carousel_options, new_carousel_7_options, album_carousel_small_options));
        });

  
        $(".global_email_signup").focus(function()
        {
          if(this.value == "email")
          {
            this.value = "";
            $(this).removeClass("watermark");
          }
        });
        $(".global_email_signup").blur(function()
        {
          if(this.value == "")
          {
            this.value = "email";
           $(this).addClass("watermark");
          }
        });

        $(".global_email_signup_zip").focus(function()
        {
          if(this.value == "zip")
          {
            this.value = "";
            $(this).removeClass("watermark");
          }
        });
        $(".global_email_signup_zip").blur(function()
        {
          if(this.value == "")
          {
            this.value = "zip";
           $(this).addClass("watermark");
          }
        });

        $(".global_login_email").focus(function()
        {
          if(this.value == "email")
          {
            this.value = "";
            $(this).removeClass("watermark");
          }
        });
        $(".global_login_email").blur(function()
        {
          if(this.value == "")
          {
            this.value = "email";
           $(this).addClass("watermark");
          }
        });

        $(".global_login_password").focus(function()
        { $("#password_watermark").hide(); });

        $(".global_login_password").blur(function()
        {
          if(this.value == "")
            $("#password_watermark").show();
        });

        $("#password_watermark").click(function()
        { $(".global_login_password").focus(); });
  


		});
      
	    $('a[rel*=facebox]').facebox();
                      
        $(".success").animate({opacity:1.0},1000).animate({backgroundColor: "#def5cb"}, 1000);
				$(".error").animate({opacity:1.0},1000).animate({backgroundColor: "#fbe5e7"}, 1000);
        $(".errorExplanation").animate({opacity:1.0},1000).animate({backgroundColor: "#fbe5e7"}, 1000);
				$(".general").animate({opacity:1.0},1000).animate({backgroundColor: "#fdfadb"}, 1000);

	});

$(function() {
    $('#datetimeStart').datepicker({
    	duration: '',
        showTime: true,
        constrainInput: false,
		stepMinutes: 15,  
		stepHours: 1,  
		altTimeField: '',  
		time24h: false
     });
    $('#datetimeEnd').datepicker({
    	duration: '',
        showTime: true,
        constrainInput: false,
		stepMinutes: 15,  
		stepHours: 1,  
		altTimeField: '',  
		time24h: false
     });
});


function showHideDivs(showId, hideId) {
  $('#'+hideId).addClass('hidden');
  $('#'+showId).removeClass('hidden');
}
