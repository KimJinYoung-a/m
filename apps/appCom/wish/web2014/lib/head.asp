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
	CGLBAppName = "app_wish2"	''/web2014 폴더 app_wish2
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
	end If

	'// 사이트 공사중 리뉴얼용
	'Call Underconstruction()

	Dim strPageTitle
	if strPageTitle="" then strPageTitle = "10X10"

	'###### 제휴사 flag 관련 - 주문 저장시/회원가입시 제휴사 Flag 저장 ######
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
<meta name="viewport" content="viewport-fit=cover, width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="format-detection" content="telephone=no" />
<title><%= strPageTitle %></title>
<% If InStr(Request.ServerVariables("url"),"/diarystory2021/") > 0 Then %>
<link rel="stylesheet" type="text/css" href="/lib/css/diary2021.css?v=1.19" />
<% elseIf InStr(Request.ServerVariables("url"),"/diarystory2022") > 0 Then %>
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=3.13">
<link rel="stylesheet" type="text/css" href="/lib/css/diary2021.css?v=1.20" />
<link rel="stylesheet" type="text/css" href="/lib/css/appV20.css?v=1.06" />
<% elseIf (InStr(Request.ServerVariables("url"),"/category/") > 0 AND InStr(Request.ServerVariables("url"),"category_itemPrd.asp") > 0) OR (InStr(Request.ServerVariables("url"),"/deal/") > 0 AND InStr(Request.ServerVariables("url"),"deal.asp") > 0) Then %>
<link rel="stylesheet" type="text/css" href="/lib/css/common_t.css?v=1.04">
<link rel="stylesheet" type="text/css" href="/lib/css/content.css?v=6.90">
<link rel="stylesheet" type="text/css" href="/lib/css/section.css?v=4.86">
<link rel="stylesheet" type="text/css" href="/lib/css/app.css?v=2.03">
<% elseIf (InStr(Request.ServerVariables("url"),"/list/") > 0 or InStr(Request.ServerVariables("url"),"/biz/") > 0) AND InStr(Request.ServerVariables("url"),"2020.asp") > 0 Then %>
<link rel="stylesheet" type="text/css" href="/lib/css/commonV20_t.css?v=1.03" />
<link rel="stylesheet" type="text/css" href="/lib/css/contentV20_t.css?v=1.06" />
<link rel="stylesheet" type="text/css" href="/lib/css/appV20.css?v=1.06" />
<% elseIf fnIsRenewalPage2020 or InStr(LCase(Request.ServerVariables("URL")), "/biz/summary.asp") > 0 or InStr(Request.ServerVariables("url"),"/linker/") > 0 or (InStr(Request.ServerVariables("url"),"/tenten_exclusive/") > 0 and 1 >InStr(Request.ServerVariables("url"),"/comment.asp")) Then %>
<%' 2020 리뉴얼에서 사용하는 css %>
<%' 2020 리뉴얼, BizMoall에서 사용하는 css(상품상세 제외) %>
<link rel="stylesheet" type="text/css" href="/lib/css/commonV20.css?v=1.43" />
<link rel="stylesheet" type="text/css" href="/lib/css/contentV20.css?v=1.85" />
<link rel="stylesheet" type="text/css" href="/lib/css/appV20.css?v=1.06" />
<%'// 2020 리뉴얼에서 사용하는 css %>
<% ELSE %>
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=3.12">
<link rel="stylesheet" type="text/css" href="/lib/css/content.css?v=6.90">
<link rel="stylesheet" type="text/css" href="/lib/css/section.css?v=4.86">
<link rel="stylesheet" type="text/css" href="/lib/css/app.css?v=1.98">
<% End If %>
<% If InStr(Request.ServerVariables("url"),"/piece/") > 0 Then %>
<link rel="stylesheet" type="text/css" href="/lib/css/piece.css?v=1.24">
<% End If %>
<link rel="stylesheet" type="text/css" href="/lib/css/contentBiz.css?v=1.00" />
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/common.js?v=4.812"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.533"></script>
<% If InStr(Request.ServerVariables("url"),"/diarystory2021/") > 0 or InStr(Request.ServerVariables("url"),"/diarystory2022/") > 0 or InStr(Request.ServerVariables("url"),"/itemlist/") > 0 Then %>
<script type="text/javascript" src="/lib/js/swiper6.0.4-bundle.min.js"></script>
<% elseIf (InStr(Request.ServerVariables("url"),"/search/search_") > 0 OR InStr(Request.ServerVariables("url"),"/category/category_") > 0 OR InStr(Request.ServerVariables("url"),"/list/") > 0) AND InStr(Request.ServerVariables("url"),"2020.asp") > 0 Then %>
<script type="text/javascript" src="/lib/js/swiper6.0.4-bundle.min.js"></script>
<% elseIf InStr(Request.ServerVariables("url"),"/tenten_exclusive/") > 0  Then %>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.0.7/js/swiper.min.js"></script>
<% else %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/jquery.swiper-3.1.2.min.js"></script>
<% end if %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/slick.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie_svg.min.js"></script>
<script type="text/javascript" src="/lib/js/errorhandler.js?v=3"></script>
<script type="text/javascript" src="/lib/js/js.cookie.min.js"></script>
<script src="/data-pipeline/pipeline.min.js"></script>
<!--<script src="/data-pipeline/pipeline-origin.js"></script>-->
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
if (getCookie('WKWebView') == "Y") {
	//fnUpdateCookieForWKWebView();
}
</script>