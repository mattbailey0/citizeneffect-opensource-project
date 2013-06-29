// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var switch_featured_project_picture = function(el, id) {
    el = $(el);
    var picture_el = $('#featured_project_' + id + '_picture');
    
    el.closest('ul').find('.active').removeClass('active');
    el.addClass('active');
    
    picture_el.closest('.slideshow').find('.featured_project_picture').not(picture_el).fadeOut('slow');
    picture_el.css({left: '0px', display: 'none'}).fadeIn('slow');
    
    return false;
};

    var switch_album = function(el, album_id) {
        el = $(el);
        $(el).closest('ul').find('li').hide().removeClass('first').removeClass('second').removeClass('third');
        $(el).closest('li').prev().andSelf().next().andSelf().show();
        $(el).closest('li').prev().addClass('first');
        $(el).closest('li').addClass('second');
        $(el).closest('li').next().addClass('third');
        $(el).closest('ul').find('a').removeClass('active');
        $(el).addClass('active');
        $(el).closest('li').prev().prepend($(el).closest('ul').find('.left_arrows').remove());
        $(el).closest('li').next().append($(el).closest('ul').find('.right_arrows').remove());
        $('.dialog_album').hide();
        $('.album_' + album_id).show();
    };
