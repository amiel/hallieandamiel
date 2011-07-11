// var c = (function() {
//   if (console) {
//     return console;
//   } else {
//     var f = function(){};
//     return { log:f };
//   }
// })();


$(document).ready(function() {

    var map;

    var setup_map = function() {

        var center = [64.8551, -147.852];
        var places = {
            mushers_hall: [64.89883, -147.73017],
            pioneer_park: [64.83859, -147.7738],
            murphy_dome: [64.95390, -148.3637]
        };

        var icons = {
            pioneer_park: 'images/icons/circus.png',
            mushers_hall: 'images/icons/party-2.png',
            murphy_dome: 'images/icons/wedding.png'
        };

        var infos = {
            pioneer_park: "<h2>Pioneer Park</h2><p>Chautauqua Parade &amp; Show</p>",
            mushers_hall: "<h2>Mushers Hall</h2><p>Family Dinner and Reception</p>",
            murphy_dome: "<h2>Murphy Dome</h2><p>Wedding Ceremony</p>"
        };

        var lat_lng_for = function(place) {
            return new google.maps.LatLng(place[0], place[1])
        };

        var marker_for = function(name) {

        };


        var myOptions = {
           zoom: 10,
           center: lat_lng_for(center),
           mapTypeId: google.maps.MapTypeId.HYBRID
         };

         map = new google.maps.Map(document.getElementById("map"), myOptions);

         $.each(places, function(name) {
             var marker = new google.maps.Marker({
                 position: lat_lng_for(places[name]),
                 map: map,
                 title: name,
                 icon: icons[name]
             });

             if (infos[name]) {
                 var infowindow = new google.maps.InfoWindow({
                     content: infos[name]
                 });

                 google.maps.event.addListener(marker, 'click', function() {
                   infowindow.open(map, marker);
                 });
             }
         });
    };


    var api,
        nav_list_context = $('nav ul');

    nav_list_context.tabs('.body', {
        effect: 'fade',
        history: true,
        initialIndex: 0
    });
    api = nav_list_context.data('tabs');

    api.onClick(function(e, index) {
        if (index == 2 && typeof map === 'undefined')
            setup_map();
    });

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

