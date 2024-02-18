<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 사행시 2
' History : 2016-11-21 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode, userid , strSql
Dim lastusercnt '신규 가입여부
'Dim logusercnt '로그인내역 카운트
Dim evt_pass : evt_pass = False '이벤트 응모 여부 chkflag

IF application("Svr_Info") = "Dev" THEN
	eCode = "66240"
Else
	eCode = "74477"
End If

userid = getEncLoginUserID

If IsUserLoginOK() Then
	'이벤트 기간 신규 회원가입인지 확인
	strSql = "SELECT COUNT(*) as cnt FROM db_user.dbo.tbl_user_n WHERE userid= '"&userid&"' and regdate between '2016-11-23 00:00:00' and '2016-11-30 23:59:59' "
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		lastusercnt = rsget(0)
	Else
		lastusercnt = 0
	End IF
	rsget.close

	If lastusercnt > 0 Then '// 기준 충족시
		evt_pass = true
	Else
		evt_pass = false
	End If 
End If 

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 사행시")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=74477")
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐 사행시")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[사]천원으로[행]복한[시]간\n\n텐바이텐 신규 가입 고객님께\n드리는 기회!\n\n4천원으로 행복한 시간을\n보내세요~"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/74249/m/img_kakao.png"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
if isapp then
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
end if

'if userid="baboytw" or userid="ksy92630"  or userid="10x10vip" Then
'	evt_pass = true
'end if
''	http://www.10x10.co.kr/event/etc/management/inc_74477_manage.asp
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

.happiness4000 .item {padding-bottom:10%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74249/m/bg_green.png) no-repeat 50% 100%; background-size:100% auto;}
.happiness4000 .item ul {overflow:hidden;}
.happiness4000 .item ul li {float:left; width:50%;}
.happiness4000 .item .btnGet {display:block; width:88.125%; margin:2% auto 0;}

/* layer popup */
.lyWin {display:none; position:absolute; top:45%; left:50%; z-index:20; width:83.75%; margin-left:-41.875%;}
.lyWin p {padding-top:10%;}
.lyWin .btnClose {display:block; position:absolute; z-index:20; top:8.5%; right:2.5%; padding:2% 4%;width:14.6%; height:10.6%;}
.lyWin .btnNow {display:block; position:absolute; bottom:12%; left:50%; z-index:20; width:76.86%; margin-left:-38.43%;}
#dimmed {display:none; position:absolute; top:0; left:0; z-index:15; width:100%; height:100%; background:rgba(0,0,0, 0.66);}

.happiness4000 .sns {position:relative;}
.happiness4000 .sns ul {overflow:hidden; position:absolute; top:26.08%; right:4%; width:38.43%;}
.happiness4000 .sns ul li {float:left; width:50%; padding-right:7.7%;}

.noti {padding:8% 6.5%; background-color:#f5f5f5;}
.noti h3 {position:relative; padding:0.2rem 0 0.4rem 2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74249/m/blt_exclamation_mark.png) no-repeat 0 0; background-size:1.9rem 1.85rem; color:#265f91; font-size:1.4rem; font-weight:bold;}
.noti ul {margin-top:1rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#6d6d6d; font-size:1.1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.6rem; left:0; width:0.4rem; height:0.1rem; background-color:#6d6d6d;}
</style>
<script type="text/javascript">

function btnClose(){
	$("#lyWin").hide();
	$("#dimmed").hide();
}

function failbtnClose(){
	alert('쿠폰을 다운로드 하였습니다.');
	$("#lyWin").hide();
	$("#dimmed").hide();
}

function getcoupon(){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #11/23/2016 00:00:00# and Now() < #11/30/2016 23:59:59# Then %>
			<% if evt_pass = TRUE then %>
				var result;
					$.ajax({
						type:"GET",
						url:"/event/etc/doeventsubscript/doEventSubscript74477.asp",
						data: "mode=I",
						dataType: "text",
						async:false,
						success : function(Data){
							result = jQuery.parseJSON(Data);
							if (result.resultcode=="11"){
								$("#lyWin").empty().html(result.lypop);
								$("#lyWin").show();
								$("#dimmed").show();
								window.$('html,body').animate({scrollTop:600}, 500);
							}
							else if (result.resultcode=="00"){
								alert('이벤트 응모 대상자가 아닙니다.');
								return;
							}
							else if (result.resultcode=="99"){
								alert('이미 응모 하셨습니다.');
								return;
							}
							else if (result.resultcode=="33"){
								alert('이벤트 응모 기간이 아닙니다.');
								return;
							}
							else if (result.resultcode=="44"){
								alert('로그인후 이용하실 수 있습니다.');
								return;
							}
							else if (result.resultcode=="88"){
								alert('잘못된 접근 입니다.');
								return;
							}
							else if (result.resultcode=="E0"){
								alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오.');
								return;
							}
							else if (result.resultcode=="E2"){
								alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
								return;
							}
							else if (result.resultcode=="E3"){
								alert('이미 쿠폰을 받으셨습니다.');
								return;
							}
							else if (result.resultcode=="ER"){
								alert('데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오.');
								return;
							}
							else if (result.resultcode=="999"){
								alert('오류가 발생했습니다.');
								return false;
							}
						}
					});
			<% else %>
				alert('이벤트 응모 대상자가 아닙니다.');
				return;
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return false;
		<% end if %>
	<% End IF %>
}

function getsnscnt(snsno) {
	<% If IsUserLoginOK() Then %>
		var str = $.ajax({
			type: "GET",
			url: "/event/etc/doeventsubscript/doEventSubscript74477.asp",
			data: "mode=S&snsno="+snsno,
			dataType: "text",
			async: false
		}).responseText;
		if(str=="tw") {
			popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
		}else if(str=="fb"){
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
		}else if(str=="ka"){
			parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
		}else if(str=="ln"){
			popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% Else %>
		<% If isApp = "1" Then %>
			calllogin();
			return false;
		<% Else %>
			jsevtlogin();
			return false;
		<% End If %>
	<% End If %>
}

function addshoppingBag(v){
	var frm = document.sbagfrm;
	var optCode = "0000";

	if (!frm.itemea.value){
		alert('장바구니에 넣을 수량을 입력해주세요.');
		return;
	}

	switch(v){
		case 1:
		<% IF application("Svr_Info") = "Dev" THEN %>
			frm.itemid.value = "1239061";
		<% Else %>
			frm.itemid.value = "1596277";
		<% End If %>
			break;
		case 2:
		<% IF application("Svr_Info") = "Dev" THEN %>
			frm.itemid.value = "1239060";
		<% Else %>
			frm.itemid.value = "1597606";
		<% End If %>
			break;
		case 3:
		<% IF application("Svr_Info") = "Dev" THEN %>
			frm.itemid.value = "1239059";
		<% Else %>
			frm.itemid.value = "1596842";			
		<% End If %>
			break;
		case 4:
		<% IF application("Svr_Info") = "Dev" THEN %>
			frm.itemid.value = "1239058";
		<% Else %>
			frm.itemid.value = "1596115";			
		<% End If %>
			break;
		default:
			frm.itemid.value = "";
	}
    <% if isapp then %>
		frm.mode.value = "DO3";  //2014 분기
	<% else %>
		frm.mode.value = "DO1";  //2014 분기
	<% end if %>
    //frm.target = "_self";
    //frm.target = "evtFrmProc"; //2015 변경
    <% if isapp then %>
		frm.action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp";
	<% else %>
		frm.action="/inipay/shoppingbag_process.asp";
	<% end if %>
	frm.submit();
	return;
}
</script>
<%
	if GetEncLoginUserID="greenteenz" or GetEncLoginUserID="kjy8517" Or GetEncLoginUserID ="ksy92630" Or GetEncLoginUserID ="baboytw" then
	Dim wincnt1 , wincnt2 , wincnt3 , wincnt4 , wincnt5
	strSql = "SELECT " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '1' then 1 else 0 end),0) as item1, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '2' then 1 else 0 end),0) as item2, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '3' then 1 else 0 end),0) as item3, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '4' then 1 else 0 end),0) as item4, " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = '5' then 1 else 0 end),0) as item5 " + vbcrlf
	strSql = strSql & " from db_event.dbo.tbl_event_subscript where evt_code = "&ecode&""
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
	<p>리플렉트 에코 히터 쿠폰 : <font color="BLUE"><%=wincnt1%></font> / 남은수량 : <font color="RED"><% response.write 1 - wincnt1 %></font> </p>
	<p>인스탁스 미니 : <font color="BLUE"><%=wincnt2%></font> / 남은수량 : <font color="RED"><% response.write 1 - wincnt2 %></font> </p>
	<p>히트템 레이디 : <font color="BLUE"><%=wincnt3%></font> / 남은수량 : <font color="RED"><% response.write 791 - wincnt3 %></font> </p>
	<p>눈꽃 전구 : <font color="BLUE"><%=wincnt4%></font> / 남은수량 : <font color="RED"><% response.write 674 - wincnt4 %></font> </p>
	<p>꽝 쿠폰 : <font color="BLUE"><%=wincnt5%></font></p>
</div>
<%
	End If 
%>
	<div class="mEvt74249 happiness4000">
		<div class="topic">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/tit_happiness_4000.png" alt="사천원으로 행복한 시간" /></h2>
			<p class="welcome wobble"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/txt_welcome.png" alt="Welcome!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74477/m/txt_four_thousand.png" alt="텐바이텐 신규 고객님께 드리는 4천원의 행복! 지금 응모하고 확인해보세요!" /></p>
		</div>

		<div class="item">
			<ul>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1164622&pEtr=74249" onclick="fnAPPpopupProduct('1164622&pEtr=74249');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/img_item_01.jpg" alt="리플렉트 에코히터" /></a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=770217&pEtr=74249" onclick="fnAPPpopupProduct('770217&pEtr=74249');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/img_item_02.jpg" alt="인스탁스 미니 카메라" /></a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1378976&pEtr=74249" onclick="fnAPPpopupProduct('1378976&pEtr=74249');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/img_item_03.jpg" alt="히트템 레이디" /></a>
				</li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1278817&pEtr=74249" onclick="fnAPPpopupProduct('1278817&pEtr=74249');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/img_item_04.jpg" alt="눈꽃전구" /></a>
				</li>
			</ul>

			<%' for dev msg : 응모하기 %>
			<a href="#lyWin" id="btnGet" onclick="getcoupon();return false;" class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/btn_get.png" alt="응모하기" /></a>
		</div>

		<%' for dev msg : layer %>
		<div id="lyWin" class="lyWin"  style="display:none"></div>

		<%' for dev msg : sns %>
		<div class="sns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/txt_sns.png" alt="친구와 함께 4천원의 행복을!" /></p>
			<ul>
				<li><a href="" onclick="getsnscnt('fb');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/ico_sns_facebook.png" alt="페이스북에 공유" /></a></li>
				<li><a href="" onclick="getsnscnt('ka');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/ico_sns_kakao.png" alt="카카오톡으로 공유" /></a></li>
			</ul>
		</div>

		<div class="noti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>본 이벤트는 이벤트 기간 내 신규 가입한 고객 대상입니다.</li>
				<li>당첨된 상품에 한하여 할인된 가격으로 구매하실 수 있습니다.</li>
				<li>ID 당 1회만 참여할 수 있습니다. </li>
				<li>이벤트는 상품 품절 시 조기 마감될 수 있습니다.</li>
				<li>이벤트는 즉시결제로만 구매가 가능하며,배송 후 반품/교환/구매취소가 불가능합니다.</li>
			</ul>
		</div>
		<div id="dimmed"></div>
	</div>
<form name="sbagfrm" method="post" action="" style="margin:0px;">
<input type="hidden" name="mode" value="add" />
<input type="hidden" name="itemid" value="" />
<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
<input type="hidden" name="itemoption" value="0000" />
<input type="hidden" name="userid" value="<%= getloginuserid() %>" />
<input type="hidden" name="isPresentItem" value="" />
<input type="hidden" name="itemea" readonly value="1" />
</form>	
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->