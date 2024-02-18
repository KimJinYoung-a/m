<%
'#########################################
' Description : 앱 다운로드 레이어
' History : 2016-01-14 이종화 생성
'#########################################
Dim vCurrUrl, vGnbNum, vCurrPar
Dim retUrl , vGtype
dim currenttime
currenttime = now()

vCurrUrl = Request.ServerVariables("url")
vCurrUrl = left(vCurrUrl,inStrRev(vCurrUrl,"/"))
vCurrPar = Request.ServerVariables("QUERY_STRING")

'// 앱호출 URL
IF inStr(vCurrUrl,"/today/")>0 or vCurrUrl="/" Then '//메인
	retUrl = ""
	vGtype = "today"
ElseIf inStr(vCurrUrl,"/category/")>0 Then '//상품상세
	retUrl = "http//m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?"&vCurrPar
	vGtype = "itemid"
End If

If request.Cookies("appdown")("mode") = "" Then
%>
<style type="text/css">
img {vertical-align:top;}
.window {display:none;}
#mask {display:none; position:absolute; left:0; top:0; z-index:9000; background:url(http://webimage.10x10.co.kr/eventIMG/2016/shop/bg_mask.png) repeat 0 0; background-size:100% 100%;}
.lyShopBnr {position:absolute; left:50%; top:150px; z-index:100000; width:84%; margin-left:-42%;}
.lyShopBnr .lyrClose {display:block; position:absolute; right:19%; top:19%; width:7.5%; border:0; cursor:pointer; background:transparent;}
.lyShopBnr .goApp {display:block; position:absolute; left:50%; top:59%; width:62%; margin-left:-31%; background:transparent;}
</style>
<script>
	$(function(){
		var maskHeight = $(document).height();
		var maskWidth =	$(window).width();

		$('#mask').css({'width':maskWidth,'height':maskHeight});
		$('#boxes').show();
		$('#mask').show();
		$('.window').show();

		$('.lyrClose').click(function(e) {
			e.preventDefault();
			$('#boxes').hide();
			$('.window').hide();
			hideLyr('applyr','c','<%=vGtype%>');
			return false;
		});

		$('#mask').click(function () {
			$('#boxes').hide();
			$('.window').hide();
			hideLyr('applyr','c','<%=vGtype%>');
			return false;
		});

		$('#goAppLink').click(function(){
			hideLyr('applyr','o','<%=vGtype%>');
			setTimeout( function() {
				openAppLink();
			}, 1000);
			return false;
		});

		$(window).resize(function () {
			var box = $('#boxes .window');
			var maskHeight = $(document).height();
			var maskWidth = $(window).width();
			$('#mask').css({'width':maskWidth,'height':maskHeight});

			var winH = $(window).height();
			var winW = $(window).width();
			box.css('top', winH/2 - box.height()/2);
			box.css('left', winW/2 - box.width()/2);
		});
	});

	function hideLyr(due,octype,gtype){
		document.getElementById('boxes').style.display = "none";
		document.getElementById('due').value = due;
		document.getElementById('octype').value = octype;
		document.getElementById('gtype').value = gtype;
		document.frmlyr.action = '/common/Cookie_process.asp';
		document.frmlyr.target = 'view';
		document.frmlyr.submit();
	}
	
	<% '앱 점핑 %>
	function openAppLink(){
		var openAt = new Date,
			uagentLow = navigator.userAgent.toLocaleLowerCase(),
			chrome25,
			kitkatWebview;

			$("body").append("<iframe id='wishapplink'></iframe>");

			$("#wishapplink").hide();
			
			setTimeout( function() {
				<% If Date() < "2016-01-25" Then %>
				if (new Date - openAt < 4000) {
					if (uagentLow.search("android") > -1) {
						$("#wishapplink").attr("src","market://details?id=kr.tenbyten.shopping&hl=ko");
					} else if (uagentLow.search("iphone") > -1) {
						location.replace("https://itunes.apple.com/kr/app/id864817011");
					}
				}
				<% End If %>
				<% If Date() >= "2016-01-25" Then %>
				location.replace("/event/appdown/");
				<% End If %>
			}, 1000);
			 
			if(uagentLow.search("android") > -1){
				chrome25 = uagentLow.search("chrome") > -1 && navigator.appVersion.match(/Chrome\/\d+.\d+/)[0].split("/")[1] > 25;
				kitkatWebview = uagentLow.indexOf("naver") != -1 || uagentLow.indexOf("daum") != -1;

				if (chrome25 && !kitkatWebview){
					document.location.href = "intent://<%=Server.UrlEncode(retUrl)%>#Intent;scheme=tenwishapp;package=kr.tenbyten.shopping;end";
				} else{
					$("#wishapplink").attr("src", 'tenwishapp://<%=Server.UrlEncode(retUrl)%>');
				}
			}
			else if(uagentLow.search("iphone") > -1 || uagentLow.search("ipad") > -1){
				//$("#wishapplink").attr("src", 'tenwishapp://<%=retUrl%>');
				window.open('tenwishapp://<%=retUrl%>','iospop','');
			} else {
				<% If Date() < "2016-01-25" Then %>
				alert("안드로이드 또는 IOS 기기만 지원합니다.");
				<% End If %>
			}
	}
</script>
<%' !-- 앱 다운로드 레이어 -- %>
<div id="boxes">
	<div id="mask"></div>
	<div class="window">
		<div class="lyShopBnr">
			<% If Date() < "2016-01-25" Then %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/shop/txt_more.png" alt="더 다양한 이벤트와 상품을 보고 싶으시다면!" /></p>
			<% End If %>
			<% If Date() >= "2016-01-25" Then %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/shop/txt_more_v2.png" alt="신규 앱 설치 시 3천원 쿠폰 즉시 지급!" /></p>
			<% End If %>
			<a href="#" class="goApp" id="goAppLink"><img src="http://webimage.10x10.co.kr/eventIMG/2016/shop/btn_go_app.png" alt="텐바이텐 앱으로 가기" /></a>
			<button type="button" class="lyrClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/shop/btn_close.png" alt="닫기" /></button>
		</div>
	</div>
</div>
<%' !-- // 앱 다운로드 레이어 --%>
<iframe name="view" id="view" frameborder="0" width="0" height="0" style="display:block;"></iframe>
<form name="frmlyr" method="get" style="margin:0px; display:inline;">
	<input type="hidden" id="due" name="due">
	<input type="hidden" id="octype" name="octype">
	<input type="hidden" id="gtype" name="gtype">
</form>
<% End If %>