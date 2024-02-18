<%
    '' 앱 구분 //2014/02/17
    Dim CGLBAppName
    CGLBAppName = "app_wish"
    uAgent = Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    if InStr(uAgent,"tencolorapp")>0 then
        CGLBAppName = "app_cal"
    end if

	'' iScroll Click옵션 여부 //2014.03.27
	dim vIsClick: vIsClick = false
	if instr(uAgent,"ipod")>0 or instr(uAgent,"iphone")>0 or instr(uAgent,"ipad")>0 then
		vIsClick = true
	elseif instr(uAgent,"android")>0 then
		dim vAdrVer: vAdrVer = mid(uAgent,instr(uAgent,"android")+8,3)
		if vAdrVer>="4.4" then
			vIsClick = true
		end if
	end if

	Dim strPageTitle
	if strPageTitle="" then strPageTitle = "10X10"
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title><%= strPageTitle %></title>
<link rel="shortcut icon" href="/apps/appCom/wish/webview/favicon.ico" type="image/x-icon">
<link rel="icon" href="/apps/appCom/wish/webview/favicon.ico" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/webview/test/style.css?v=1.4">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/webview/css/jquery.bxslider.css">
<% if flgDevice="I" then %><link rel="stylesheet" type="text/css" href="/apps/appCom/wish/webview/css/ios.css?v=1.1"><% end if %>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/jquery-latest.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/jquery.bxslider.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/common.js?v=1.5"></script>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/tencommon.js?v=1.0"></script>
<script type="application/x-javascript" src="/apps/appCom/wish/webview/js/itemPrdDetail.js?v=1.0"></script>
<script language="javascript" src="/apps/appCom/wish/webview/js/shoppingbag_script.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/iscroll.js?v=1.0"></script>
<script type="text/javascript" src="/lib/js/base64.js"></script>
<script type="text/javascript">
// 모달창
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
			$(".modal").css({"height":mh});
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
