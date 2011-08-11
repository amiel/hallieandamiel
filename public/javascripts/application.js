$(document).ready(function() {

    $('a[rel=external]').each(function(index) {
        $(this).attr('target', '_blank');
    });

   $("select").chosen();
});

