<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim vUserID, eCode, vQuery, vEnterOX, vPresent
	vUserID = GetLoginUserID
	vEnterOX = "x"
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21074"
	Else
		eCode = "49092"
	End If
	

	vQuery = "SELECT sub_opt2 From [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & vUserID & "' AND evt_code = '" & eCode & "' "
	rsget.Open vQuery, dbget, 1
	If Not rsget.Eof Then
		vEnterOX = "o"
		vPresent = rsget(0)
	End IF
	rsget.close

%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 선물이 막걸립니다</title>
<style type="text/css">
.mEvt49092 img {vertical-align:top;}
.shoppingPlay legend {visibility:hidden; overflow:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.mEvt49092 .shoppingPlay p {max-width:100%;}
.mEvt49092 .shoppingPlay input {vertical-align:top;}
.shoppingPlay .shoppingPlayPresent ul {overflow:hidden;}
.shoppingPlay .shoppingPlayPresent ul li {position:relative; float:left; width:25%;}
.shoppingPlay .shoppingPlayPresent ul li input {position:absolute; top:55%; width:16px; height:16px;}
.shoppingPlay .shoppingPlayPresent ul li:nth-child(1) input {position:absolute; left:56%;}
.shoppingPlay .shoppingPlayPresent ul li:nth-child(2) input {position:absolute; left:46%;}
.shoppingPlay .shoppingPlayPresent ul li:nth-child(3) input {position:absolute; left:37%;}
.shoppingPlay .shoppingPlayPresent ul li:nth-child(4) input {left:29%;}
.shoppingPlay .shoppingPlayPresent ul li img {width:100%;}
.shoppingPlay .shoppingPlayGift ul {overflow:hidden;}
.shoppingPlay .shoppingPlayGift ul li {float:left; width:25%;}
.shoppingPlay .shoppingPlayGift ul li img {width:100%;}
.shoppingPlay .shoppingPlayGift ul li label {display:block;}
.shoppingPlay .shoppingPlayNote {padding-top:20px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49092/bg_pattern.gif) left top repeat; background-size:3px 3px;}
.shoppingPlay .shoppingPlayNote ul {margin-top:8px;; padding:0 4.1666%;}
.shoppingPlay .shoppingPlayNote ul li {margin-top:8px; padding-left:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49092/blt_arrow.png) left 4px no-repeat; background-size:4px 7px; color:#fff; font-size:11px; line-height:1.5em;}
</style>
<script type="text/javascript">

function jsGoSave(){
<% If vUserID <> "" Then %>
	<% If vEnterOX = "x" Then %>
	if($(":radio[name=spoint]:checked").length == 0){
		alert("원하는 쇼핑패턴을 한가지 선택해주세요!");
		return;
	}
	frm1.submit();
	<% Else %>
	return;
	<% End If %>
<% Else %>
	alert('로그인을 하셔야 이벤트\n응모가 가능합니다.');
	top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=eCode%>"
	return;
<% End If %>
}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt49092">
		<div class="shoppingPlay">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/tit_shopping_play.gif" alt="" style="width:100%;" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/txt_shopping_play_01.gif" alt="즐거운 영화관람 하셨나요? 영화만큼 재밌는 쇼핑이 여러분을 기다리고 있어요! 텐바이텐이 준비한 웰컴선물도 함께요! 이벤트 기간 : 2014년 02월 07일 ~ 02월 28일" style="width:100%;" /></p>

			<% If vEnterOX = "x" Then %>
			<div class="shoppingPlayPresent">
				<form name="frm1" method="post" action="doEventSubscript49092.asp">
				<fieldset>
					<legend>웰컴선물 확인하기</legend>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/txt_shopping_play_02.gif" alt="다양한 즐거움이 있는 텐바이텐! 나에게 딱 맞는 쇼핑패턴을 선택하고 웰컴 선물을 확인하세요!" style="width:100%;" /></p>
					<ul>
						<li>
							<label for="selectPresent01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/img_present_01.jpg" alt="재미있는 이벤트" /></label>
							<input type="radio" id="selectPresent01" name="spoint" value="1" />
						</li>
						<li>
							<label for="selectPresent02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/img_present_02.jpg" alt="행복한 선물" /></label>
							<input type="radio" id="selectPresent02" name="spoint" value="2" />
						</li>
						<li>
							<label for="selectPresent03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/img_present_03.jpg" alt="즐거운 쇼핑" /></label>
							<input type="radio" id="selectPresent03" name="spoint" value="3" />
						</li>
						<li>
							<label for="selectPresent04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/img_present_04.gif" alt="기분 좋은 일상" /></label>
							<input type="radio" id="selectPresent04" name="spoint" value="4" />
						</li>
					</ul>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/btn_confirm.gif" alt="선물 확인하기" style="width:100%;" onClick="jsGoSave()" />
				</fieldset>
				</form>
			</div>
			<% ElseIf vEnterOX = "o" Then %>
			<div class="congratulationMsg">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/txt_shopping_play<%=vPresent%>.gif" alt="축하합니다!" style="width:100%;" /></p>
				<% If vPresent = "1" OR vPresent = "2" Then %>
				<div class="checkPhone"><a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/btn_phone.gif" alt="휴대폰 번호 확인하러 가기" style="width:100%;" /></a></div>
				<% End If %>
			</div>
			<% End If %>
			
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/bx_bottom.gif" alt="" style="width:100%;" /></p>

			<div class="shoppingPlayGift">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/tit_shopping_play_present.gif" alt="텐바이텐의 웰컴선물" style="width:100%;" /></h3>
				<ul>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/img_gift_01.jpg" alt="메가박스 콤보 (영화 + 팝콘) 10분에게 증정" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/img_gift_02.jpg" alt="텐바이텐 12주년 에디션 머그 (랜덤) 10분에게 증정" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/img_gift_03.jpg" alt="텐바이텐 1만원 할인쿠폰 10분에게 증정" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/img_gift_04.jpg" alt="텐바이텐 4천원 할인쿠폰 전원증정" /></li>
				</ul>
			</div>

			<div class="shoppingPlayNote">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/tit_shopping_play_note.png" alt="이벤트 안내" style="width:100%;" /></h3>
				<ul>
					<li>한 ID당 1회만 참여하실 수 있습니다.</li>
					<li>이벤트 및 당첨확인 기간은 2014년 2월 28일까지 입니다.</li>
					<li>쿠폰은 유효기간이 있으며, 텐바이텐 온라인에서만 사용 가능합니다.</li>
					<li>쿠폰 사용 시, 일부 상품은 제외될 수 있습니다.</li>
					<li>만원 쿠폰은 1만원 이상, 4천원 쿠폰은 3만원 이상 구매시 사용 가능합니다.</li>
					<li>메가박스 콤보 패키지 기프티콘과 텐바이텐 12주년 에디션 머그는 당첨된 날의 익일에 마이텐바이텐에서 확인하실 수 있으며, 개인 정보에 등록된 주소와 휴대폰 번호를 기준으로 사은품이 발송됩니다.</li>
				</ul>
			</div>
			<div><a href="/award/awarditem.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49092/btn_go.jpg" alt="지금 이 순간! 텐바이텐에서 가장 핫한 아이템 보러가기" style="width:100%;" /></a></div>
		</div>
	</div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->