// var c = (function() {
//   if (console) {
//     return console;
//   } else {
//     var f = function(){};
//     return { log:f };
//   }
// })();


$(document).ready(function() {

    var map, openers = {}, current_infowindow;

    var setup_map = function() {

        var center = [64.8551, -147.852];
        var places = {
            mushers_hall: [64.89883, -147.73017],
            pioneer_park: [64.83859, -147.7738],
            murphy_dome_parking: [64.95390, -148.3637],
            marriage_site: [64.96003, -148.38291],
            mcgee_house: [64.92066, -147.88576],
            chena_hot_springs: [65.0533, -146.0572],
            notc_camp: [64.83971, -148.1333]
        };

        var icons = {
            pioneer_park: 'images/icons/circus.png',
            mushers_hall: 'images/icons/dancinghall.png',
            marriage_site: 'images/icons/wedding.png',
            murphy_dome_parking: 'images/icons/parking.png',
            mcgee_house: 'images/icons/house_tree.png',
            chena_hot_springs: 'images/icons/geyser-2.png',
            notc_camp: 'images/icons/summercamp.png'
        };

        var infos = {
            pioneer_park: "<div class='infos'><h2>Pioneer Park</h2><p>Chautauqua Parade &amp; Show</p></div>",
            mushers_hall: "<div class='infos'><h2>Mushers Hall</h2><p>Family Dinner and Reception</p></div>",
            murphy_dome_parking: "<div class='infos'><h2>Murphy Dome</h2><p>Wedding Ceremony Parking</p></div>",
            marriage_site: "<div class='infos'><h2>Murphy Dome</h2><p>Wedding Ceremony</p></div>",
            mcgee_house: "<div class='infos'><h2>Hallie's Parents House</h2></div>",
            chena_hot_springs: "<div class='infos'><h2>Chena Hot Springs</h2></div>",
            notc_camp: "<div class='infos'><h2>Calipso Farm</h2><p>Chautauqua Camp</p></div>"
        };

        var lat_lng_for = function(place) {
            return new google.maps.LatLng(place[0], place[1]);
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

                 infowindow.do_close = function() {
                     infowindow.close();
                     infowindow.show = false;
                 };

                 openers[name] = function() {
                     if (infowindow.show) {
                         current_infowindow = null;
                         infowindow.do_close();
                     } else {
                         if (current_infowindow) current_infowindow.do_close();
                         infowindow.open(map, marker);
                         infowindow.show = true;
                         current_infowindow = infowindow;
                     }
                 };

                 google.maps.event.addListener(marker, 'click', openers[name]);

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

        if (index < 0) {
            // Try showing a map icon window thing.
            opener = openers[href.replace(/^#/, '')];
            if (opener) opener();
        } else {
            api.click(index);
        }
        return false;
    });

});

