<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 사대천왕 for Mobile
' History : 2016-02-11 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	Dim retUrl ' for app
	retUrl = "http//m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=69086"
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt69086 {position:relative;}
.mEvt69086 button {background:transparent;}
.item {overflow:hidden;}
.item li {float:left; width:50%;}
.btnArea {position:relative;}
.btnArea .btnApply {display:block; position:absolute; left:0; top:0; width:100%; background:transparent; vertical-align:top;}
.shareSns {position:relative;}
.shareSns ul {position:absolute; left:7%; top:52%; width:86%; height:38%;}
.shareSns ul li {float:left; width:25%; height:100%; padding:0 2%;}
.shareSns ul li a {display:block; width:100%; height:100%; text-indent:-9999px;}
.evtNoti {color:#fff; padding:2rem 4.2%; background:#262626;}
.evtNoti h3 {padding-bottom:1.2rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; line-height:2rem; padding-left:2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69086/ico_mark.png) no-repeat 0 0; background-size:1.9rem 1.9rem;}
.evtNoti li {position:relative; padding-left:1rem; font-size:1.1rem; line-height:1.4;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.4rem; height:1px; background:#fff;}
</style>
<script>
<%'//dev 66024 | 69119  %>
function evt_goApp(){
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doeventsubscript/doeventsubscript69119.asp",
		data: "ecode=69119",
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
				$("#wishapplink").attr("src", 'tenwishapp://<%=retUrl%>');
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
	if GetEncLoginUserID="greenteenz" or GetEncLoginUserID="motions" Or GetEncLoginUserID ="cogusdk" then
	Dim strSql 
	Dim wincnt1 , wincnt2 , wincnt3 , wincnt4 , wincnt5
	strSql = "SELECT " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '1' then 1 else 0 end),0) as item1, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '2' then 1 else 0 end),0) as item2, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '3' then 1 else 0 end),0) as item3, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '4' then 1 else 0 end),0) as item4, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '5' then 1 else 0 end),0) as item5 " + vbcrlf
	strSql = strSql & " from db_event.dbo.tbl_event_subscript where evt_code = '69086' " 
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
<div><p>인스탁스 : <%=wincnt1%></p><p>스티키몬스터 : <%=wincnt2%></p><p>토끼 : <%=wincnt3%></p><p>앨리스 : <%=wincnt4%></p><p>무료배송 쿠폰 : <%=wincnt5%></p></div>
<%
	End If 
%>
<div class="mEvt69086">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69119/tit_4000.png" alt="특별한 당신에게 보이는 사대천왕 - 앱에서 처음 로그인한 분에게 드리는 4천원의 행복 지금 응로하고 확인해보세요!" /></h2>
	<ul class="item">
		<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/69119/img_item_01.jpg" alt="인스탁스 카메라" /></li>
		<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/69119/img_item_02.jpg" alt="미니토끼 램프" /></li>
		<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/69119/img_item_03.jpg" alt="디즈니 앨리스카드" /></li>
		<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/69119/img_item_04.jpg" alt="스티키몬스터랩 배터리" /></li>
	</ul>

	<a href="" onclick="evt_goApp();return false;">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69119/btn_app.png" alt="APP에서 확인하기(사대천왕은 앱에서만 구매할 수 있습니다)" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69119/txt_app_benefit.png" alt="텐바이텐을 앱으로 만나면? 편리한쇼핑+다양한 이벤트+보너스 할인쿠폰" /></p>
	</a>

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트는 앱에서 로그인 이력이 한번도 없는 고객님을 위한 이벤트입니다.</li>
			<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
			<li>ID당 1회만 구매가 가능합니다.</li>
			<li>이벤트는 상품 품절 시 조기 마감 될 수 있습니다.</li>
			<li>상품은 즉시결제로만 구매가 가능하며 배송 후 반품/교환/취소가 불가능합니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->