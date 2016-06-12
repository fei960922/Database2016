$(window).resize(function(){
    var winh=(window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight);
    var winw=(window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth);
    $(".fullh").css({"min-height":winh});
    if (winh<700) winh = 700;
    var h = winh - 102;
    $(".minh").css({"min-height":h-20});
    $(".fixh").css({height:h});
    h = winh*2/3;
    if (winw<768) h = winw*3/5;
    $(".halfh").css({height:h});
})
$(document).ready(function(){
    var winh=(window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight);
    var winw=(window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth);
    $(".fullh").css({"min-height":winh});
    if (winh<700) winh = 700;
    var h = winh - 102;
    $(".minh").css({"min-height":h});
    $(".fixh").css({height:h});
    h = winh*2/3;
    if (winw<768) h = winw*3/5;
    $(".halfh").css({height:h});


    //fontmaking();
    console.log("Welcome to Eation~!\nYou can send advice to fei960922@gmail.com;\nDesigned by Jerry Xu;\nPowered By BootStrap;\nCopyright © 2016 ACM Class. All rights reserved.");

/*  ------------------------------------------
             JavaScript of Nav-bar 
    ------------------------------------------  */

    $(".dropdown").hover(            
        function() {
        	$('.dropdown-menu', this).stop(true,true);
            $('.dropdown-menu', this).fadeIn("fast");
            $(this).toggleClass('open');
            $('b', this).toggleClass("caret caret-up");                
            },
        function() {
            $('.dropdown-menu', this).fadeOut("fast");
            $(this).toggleClass('open');
            $('b', this).toggleClass("caret caret-up");                
        });
})   

/* affix the navbar after scroll below header */

$("#headingForIndex").affix({
     offset: {
        top: $(window).height()-$("#headingForIndex").height()
    }
});
$("#headingForPost").affix({
     offset: {
        top: $(".big_top").height()*0.5
    }
});
$(".signForNews img").addClass("img-responsive");


