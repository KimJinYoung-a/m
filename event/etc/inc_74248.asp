<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 사행시 M
' History : 2016-11-09 김진영
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	Dim retUrl ' for app
	retUrl = "http//m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=74249"
%>
<style type="text/css">
img {vertical-align:top;}

.happiness4000 {background-color:#5fca8a;}
.happiness4000 button {background-color:transparent;}

.happiness4000 .topic {overflow:hidden; position:relative;}
.happiness4000 .topic h2 {position:absolute; top:6.65%; left:4.68%; z-index:5; width:83.9%;}
.happiness4000 .topic .welcome {position:absolute; top:34.98%; right:2.03%; width:34.375%;}

.happiness4000 .topic h2 {
	animation-name:lightSpeedIn; animation-timing-function:ease-out; animation-duration:1.5s; animation-fill-mode:both; animation-iteration-count:1;
	-webkit-animation-name:lightSpeedIn; -webkit-animation-timing-function:ease-out; -webkit-animation-duration:1.5s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:1;
}
@keyframes lightSpeedIn {
	0% {transform:translateY(-50%);}
	60% {transform:translateY(-20%);}
	80% {transform:translateY(10%);}
	100% {transform:translateY(0%);}
}
@-webkit-keyframes lightSpeedIn {
	0% {-webkit-transform:translateY(-50%);}
	60% {-webkit-transform:translateY(-20%);}
	80% {-webkit-transform:translateY(10%);}
	100% {-webkit-transform:translateY(0%);}
}

.wobble {
	animation-name:wobble; animation-duration:1.2s; animation-fill-mode:both; animation-iteration-count:1; animation-delay:1.5s;
	-webkit-animation-name:wobble; -webkit-animation-duration:1.2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:1; -webkit-animation-delay:1.5s;
}
@keyframes wobble {
	0% {transform:translateX(0%);}
	15% {transform:translateX(-25%) rotate(-5deg);}
	30% {transform:translateX(20%) rotate(3deg);}
	45% {transform:translateX(-15%) rotate(-3deg);}
	60% {transform:translateX(10%) rotate(2deg);}
	75% {transform:translateX(-5%) rotate(-1deg);}
	100% {transform:translateX(0%);}
}
@-webkit-keyframes wobble {
	0% {-webkit-transform:translateX(0%);}
	15% {-webkit-transform:translateX(-25%) rotate(-5deg);}
	30% {-webkit-transform:translateX(20%) rotate(3deg);}
	45% {-webkit-transform:translateX(-15%) rotate(-3deg);}
	60% {-webkit-transform:translateX(10%) rotate(2deg);}
	75% {-webkit-transform:translateX(-5%) rotate(-1deg);}
	100% {-webkit-transform:translateX(0%);}
}

.happiness4000 .item {padding-bottom:10%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74248/m/bg_green.png) no-repeat 50% 100%; background-size:100% auto;}
.happiness4000 .item ul {overflow:hidden;}
.happiness4000 .item ul li {float:left; width:50%;}
.happiness4000 .item .btnApp {display:block; width:88.125%; margin:2% auto 0;}
.happiness4000 .item p {margin-top:3%;}

.noti {padding:8% 6.5%; background-color:#f5f5f5;}
.noti h3 {position:relative; padding:0.2rem 0 0.4rem 2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74249/m/blt_exclamation_mark.png) no-repeat 0 0; background-size:1.9rem 1.85rem; color:#265f91; font-size:1.4rem; font-weight:bold;}
.noti ul {margin-top:1rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#6d6d6d; font-size:1.1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.6rem; left:0; width:0.4rem; height:0.1rem; background-color:#6d6d6d;}
</style>
<script>
<%'//dev 66024 | 69119  %>
function evt_goApp(){
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doeventsubscript/doeventsubscript74248.asp",
		data: "ecode=74248",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		var openAt = new Date,
			uagentLow = navigator.userAgent.toLocaleLowerCase(),
			chrome25,
			kitkatWebview;

			$("body").append("<iframe id='wishapplink'></iframe>");

			$("#wishapplink").hide();
			
			setTimeout( function() {
				if (new Date - openAt < 4000) {
					if (uagentLow.search("android") > -1) {
						$("#wishapplink").attr("src","market://details?id=kr.tenbyten.shopping&hl=ko");
					} else if (uagentLow.search("iphone") > -1) {
						location.replace("https://itunes.apple.com/kr/app/id864817011");
					}
				}
			}, 2000);
			 
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
				document.location.href = "tenwishapp://<%=retUrl%>";
			} else {
				alert("안드로이드 또는 IOS 기기만 지원합니다.");
			}
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
<%
	if GetEncLoginUserID="greenteenz" or GetEncLoginUserID="kjy8517" Or GetEncLoginUserID ="ksy92630" then
	Dim strSql 
	Dim wincnt1 , wincnt2 , wincnt3 , wincnt4 , wincnt5
	strSql = "SELECT " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '1' then 1 else 0 end),0) as item1, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '2' then 1 else 0 end),0) as item2, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '3' then 1 else 0 end),0) as item3, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '4' then 1 else 0 end),0) as item4, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '5' then 1 else 0 end),0) as item5 " + vbcrlf
	strSql = strSql & " from db_event.dbo.tbl_event_subscript where evt_code = '74249' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		wincnt1 = rsget("item1")
		wincnt2 = rsget("item2")
		wincnt3 = rsget("item3")
		wincnt4 = rsget("item4")
		wincnt5 = rsget("item5")
	End If
	rsget.close()
%>
<div>
	<p>리플렉트 에코 히터 쿠폰 : <%=wincnt1%> / 남은수량 : <% response.write 1 - wincnt1 %> </p>
	<p>인스탁스 미니 8 카메라 (그레이프) : <%=wincnt2%> / 남은수량 : <% response.write 1 - wincnt2 %> </p>
	<p>히트템 레이디 (12개) : <%=wincnt3%> / 남은수량 : <% response.write 800 - wincnt3 %> </p>
	<p>눈꽃 전구 : <%=wincnt4%> / 남은수량 : <% response.write 700 - wincnt4 %> </p>
	<p>꽝 쿠폰 : <%=wincnt5%></p>
</div>
<%
	End If 
%>
<div class="mEvt74248 happiness4000">
	<div class="topic">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/tit_happiness_4000.png" alt="사천원으로 행복한 시간" /></h2>
		<p class="welcome wobble"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/txt_welcome.png" alt="Welcome!" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74248/m/txt_four_thousand.png" alt="아직도 앱에서 로그인한 적이 없으시다구요? 지금 바로 확인하세요!" /></p>
	</div>
	<div class="item">
		<ul>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1164622&pEtr=74249"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74248/m/img_item_01.jpg" alt="리플렉트 에코히터" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=770217&pEtr=74249"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74248/m/img_item_02.jpg" alt="인스탁스 미니 카메라" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1378976&pEtr=74249"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74248/m/img_item_03.jpg" alt="히트템 레이디" /></a>
			</li>
			<li>
				<a href="/category/category_itemPrd.asp?itemid=1278817&pEtr=74249"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74248/m/img_item_04.jpg" alt="눈꽃전구" /></a>
			</li>
		</ul>
		<%' for dev msg : 앱에서 확인하기 / 텐바이텐 앱 미설치 시 앱 스토어(Google play Store)로 이동, 설치 시 텐바이텐 앱 이벤트 페이지로 이동 %>
		<a href="" onclick="evt_goApp();return false;" class="btnApp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74248/m/btn_app.png" alt="텐바이텐 앱에서 확인하기" /></a>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74248/m/txt_only_get_tenten_app.png" alt="사행시는 텐바이텐 앱에서만 구매하실 수 있습니다." /></p>
	</div>
	<div class="noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>본 이벤트는 앱에서 로그인한 이력이 한번도 없는 고객님을 위한 이벤트입니다.</li>
			<li>당첨된 상품에 한하여 할인된 가격으로 구매하실 수 있습니다.</li>
			<li>ID당 1회만 참여할 수 있습니다.</li>
			<li>이벤트는 상품 품절 시 조기 마감될 수 있습니다.</li>
			<li>이벤트는 즉시 결제로만 구매가 가능하며, 배송 후 반품/교환/취소가 불가능합니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->