// var c = (function() {
//   if (console) {
//     return console;
//   } else {
//     var f = function(){};
//     return { log:f };
//   }
// })();


$(document).ready(function() {


    var api,
    nav_list_context = $('nav ul');

    nav_list_context.tabs('.body', { effect: 'fade', history: true, initialIndex: 0 });
    api = nav_list_context.data('tabs');

    // api.onClick(function(index) {
    //   // z7x4a3.resizeForm({"height":"620px", "rules" : "", "protocol" : "", "method":"memcache"});
    //   // z7x4a3.addResizeScript();
    // });


    $('a[rel=external]').each(function(index) {
        $(this).attr('target', '_blank');
    });

    $('a[href^=#]').click(function() {
        var t = $(this),
        href = t.attr("href"),
        index = $('li a', nav_list_context).index($('a[href^=' + href + ']', nav_list_context));
        api.click(index);
        return false;
    });
});