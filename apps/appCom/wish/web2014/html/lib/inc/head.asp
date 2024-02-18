<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<!-- meta http-equiv="X-UA-Compatible" content="IE=9" -->
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0">
<meta name="format-detection" content="telephone=no" />
<title>2014 10x10 APP</title><!-- for dev msg : �� ������ �� �־��ּ��� -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/default.css">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/common.css">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/content.css">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/section.css">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/ios.css">
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/jquery.swiper-2.1.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/slick.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/common.js"></script>
<script type="text/javascript">
// ���â
var loop;
function jsOpenModal(sUrl) {
	if(sUrl==""||sUrl=="undefind") return;

	$.ajax({
		url: sUrl,
		cache: false,
		success: function(message) {
			$("#modalCont").empty().html(message);
			$("#modalCont").fadeIn();
			$('body').css({'overflow':'hidden'});

			var mh = parseInt($(window).innerHeight());
			$(".modal").css({"min-height":mh});
			var myScroll = new IScroll('.modal .modal-body', {
	            scrollbars: true,
				mouseWheel: true,
				preventDefault: false
	        });

			clearInterval(loop);
			loop = null;
	        loop = setInterval(
	        	function(){
	        		console.log(loop);
	        		if ( $('.modal .modal-body').length > 0 ) {
	        			myScroll.refresh();
	        		} else {
	        			clearInterval(loop);
	        			loop = null;
	        		}
	        	},
	        	500
	        );

			//close
			$('#modalCont .modal .btn-close').one('click', function(){
				$("#modalCont").fadeOut(function(){
					$(this).empty();
				});
				$('body').css({'overflow':'auto'});
    			clearInterval(loop);
    			loop = null;
				return false;
			});
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}
</script>