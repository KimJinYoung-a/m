<%
    Dim C_WEBVIEWURL, C_WEBVIEWURL_SSL
    IF application("Svr_Info")="Dev" THEN
	    C_WEBVIEWURL = "http://testm.10x10.co.kr/apps/appcom/wish/web2014"
	    C_WEBVIEWURL_SSL = "http://testm.10x10.co.kr/apps/appcom/wish/web2014"
	Else
	    C_WEBVIEWURL = "http://m.10x10.co.kr/apps/appcom/wish/web2014"
	    C_WEBVIEWURL_SSL = "https://m.10x10.co.kr/apps/appcom/wish/web2014"
	End if
    
    '' 앱 구분 //2014/02/17
    Dim CGLBAppName
    CGLBAppName = "app_wish2"  ''/web2014 폴더 app_wish2
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

	'###### 제휴사 flag 관련 - 주문 저장시/회원가입시  제휴사 Flag 저장 ######
	dim irdsite20, arrRdSite, irdData
	irdsite20 = request("rdsite")
	irdData = request("rddata")	'기타 전송 데이터 (회원ID,이벤트 번호 등)
	'//파라메터가 겹쳐있는 경우 중복 제거
	if irdsite20<>"" then
		arrRdSite = split(irdsite20,",")
		irdsite20 = arrRdSite(0)
	end if

	if (irdsite20<>"") then
		if (request.cookies("rdsite")<>irdsite20) then
			response.cookies("rdsite").domain = "10x10.co.kr"
			response.cookies("rdsite") = Left("mobile_"&trim(irdsite20),32)
		end if
		if (request.cookies("rddata")<>irdData) then
			response.cookies("rddata") = irdData
		end if
	end if
	'#########################################################################
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0">
<meta name="format-detection" content="telephone=no" />
<title><%= strPageTitle %></title>
<% if (TRUE) or (Request.ServerVariables("SERVER_PORT")<>"80") then %>
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/common.css?v=2.14">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/content.css?v=4.16">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/section.css?v=3.65">
<!-- <link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css?v=1.0"> -->
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/jquery.swiper-3.1.2.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/common.js?v=2.05"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.43"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/iscroll.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/brand.js?v=2.0"></script>
<!--
<link rel="stylesheet" type="text/css" href="/fiximage/static/2015/app/lib/css/default.css?v=0">
<link rel="stylesheet" type="text/css" href="/fiximage/static/2015/app/lib/css/common.css?v=0">
<link rel="stylesheet" type="text/css" href="/fiximage/static/2015/app/lib/css/content.css?v=0">
<link rel="stylesheet" type="text/css" href="/fiximage/static/2015/app/lib/css/section.css?v=0">
<script type="text/javascript" src="/fiximage/static/2015/app/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/fiximage/static/2015/app/lib/js/jquery.swiper-3.1.2.min.js"></script>
<script type="text/javascript" src="/fiximage/static/2015/app/lib/js/common.js?v=2.05"></script>
<script type="text/javascript" src="/fiximage/static/2015/app/lib/js/customapp.js?v=2.43"></script>
<script type="text/javascript" src="/fiximage/static/2015/app/lib/js/iscroll.js"></script>
<script type="text/javascript" src="/fiximage/static/2015/app/lib/js/brand.js?v=2.0"></script>
-->
<% else %>
<link rel="stylesheet" type="text/css" href="http://fiximage.10x10.co.kr/static/2015/app/lib/css/default.css?v=0">
<link rel="stylesheet" type="text/css" href="http://fiximage.10x10.co.kr/static/2015/app/lib/css/common.css?v=0">
<link rel="stylesheet" type="text/css" href="http://fiximage.10x10.co.kr/static/2015/app/lib/css/content.css?v=0">
<link rel="stylesheet" type="text/css" href="http://fiximage.10x10.co.kr/static/2015/app/lib/css/section.css?v=0">
<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/app/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/app/lib/js/jquery.swiper-3.1.2.min.js"></script>
<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/app/lib/js/common.js?v=2.05"></script>
<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/app/lib/js/customapp.js?v=2.43"></script>
<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/app/lib/js/iscroll.js"></script>
<script type="text/javascript" src="http://fiximage.10x10.co.kr/static/2015/app/lib/js/brand.js?v=2.0"></script>
<% end if %>

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