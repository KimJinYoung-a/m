<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>

<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->

<%
function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-04-07"
	
	getnowdate = nowdate
end function

dim eCode, vQuery, vUserID, vIsEventE, vIsEventK, vHp, vEmail, vTmp1, vTmp2, vTmp3
	vUserID = GetLoginUserID()
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21123"
	Else
		eCode = "50804"
	End If

	vIsEventE = "x"
	vIsEventK = "x"
	
	'####### 이메일 수신동의 sub_opt2 = 1, 카카오톡 인증 sub_opt2 = 2
	If vUserID <> "" Then
		vQuery = "SELECT "
		vQuery = vQuery & "(SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & vUserID & "' AND sub_opt2 = 1) as e,"
		vQuery = vQuery & "(SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & vUserID & "' AND sub_opt2 = 2) as k"
		rsget.Open vQuery, dbget, 1
		If Not rsget.Eof Then
			vIsEventE = CHKIIF(rsget("e")>0,"o","x")
			vIsEventK = CHKIIF(rsget("k")>0,"o","x")
		End If
		rsget.close()
		
		If vIsEventE = "x" Then
			vQuery = "SELECT TOP 1 usermail FROM [db_user].[dbo].[tbl_user_n] WHERE userid = '" & vUserID & "' AND email_10x10 = 'Y'"
			rsget.Open vQuery, dbget, 1
			If Not rsget.Eof Then
				vEmail = rsget("usermail")
			End If
			rsget.close()
		End If
		
		If vIsEventK = "x" Then
			vQuery = "SELECT TOP 1 phoneNum FROM [db_sms].[dbo].[tbl_kakaoUser] WHERE userid = '" & vUserID & "'"
			rsget.Open vQuery, dbget, 1
			If Not rsget.Eof Then
				vTmp3 = Trim(Right(rsget("phoneNum"),4))
				vTmp2 = Trim(Replace(Right(rsget("phoneNum"),8),vTmp3,""))
				vTmp1 = Replace(Replace(rsget("phoneNum"),vTmp2&vTmp3,""),"82","0")
				
				vHp = vTmp1 & "-" & vTmp2 & "-" & vTmp3
			End If
			rsget.close()
		End If
	End If
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 구매 금액별 사은이벤트</title>
<style type="text/css">
.mEvt50805 {}
.mEvt50805 p {max-width:100%;}
.mEvt50805 img {vertical-align:top; width:100%;}
.getCloseTenbyten {background-color:#fdeded;}
.layerPopup {margin:0 8%; background-color:#fff;}
#layerEmail {border:2px solid #ff7fa3;}
#layerKakao {border:2px solid #62dbdc;}
.layerGetClose {position:relative; text-align:center;}
.layerGetClose p {color:#888;font-size:12px; line-height:1.25em;}
.layerGetClose .emailAddress {padding-bottom:10px;}
.layerGetClose .emailAddress span {border-bottom:2px solid #ff7fa3; color:#ff7fa3; font-size:11px;}
.layerGetClose .mobileNumber {padding-bottom:10px;}
.layerGetClose .mobileNumber span {border-bottom:2px solid #62dbdc; color:#62dbdc; font-size:11px;}
.layerGetClose em {color:#888; text-decoration:underline;}
.layerGetClose .btnConfirm {padding:15px 0;}
.layerGetClose .btnConfirm img {width:75px;}
.layerGetClose .btnClose {position:absolute; left:0; top:7%; width:100%; height:30px;}
.layerGetClose .btnClose button {position:absolute; right:5%; top:0; width:16px; height:17px; margin:0; padding:0; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_close.png) left top no-repeat; background-size:16px 17px; text-indent:-999em; cursor:pointer;}
@media screen and (max-width:480px) {
	.layerGetClose p {font-size:9px; line-height:1.375em;}
	.layerGetClose .btnClose button {width:10px; height:11px; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_close.png) left top no-repeat; background-size:10px 11px;}
}
</style>
<script type="text/javascript">
$(function(){
	$(".layerPopup").hide();
	$(".takePart .eventEmail .btnAgree a").click(function(){
		//$("#layerEmail").show();
		//return false;
	});
	$("#layerEmail .btnClose").click(function(){
		$("#layerEmail").hide();
	});
	$(".takePart .eventKakao .btnAgree a").click(function(){
		//$("#layerKakao").show();
		//return false;
	});
	$("#layerKakao .btnClose").click(function(){
		$("#layerKakao").hide();
	});
});

function jsSubmitComment(g){
	var frm = document.frmGubun;
		<% If Now() > #04/13/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2014-04-07" and getnowdate<"2014-04-14" Then %>
				<% If vUserID = "" Then %>
					alert('로그인을 하셔야 참여가 가능 합니다');
					return;
				<% else %>
					frm.gubun.value = g;
					frm.submit();
				<% End If %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				parent.top.location.href="/event/eventmain.asp?eventid=<%=eCode%>"
				return;
			<% end if %>				
		<% End If %>
}

function pageReload(){
	top.location.href = "/event/eventmain.asp?eventid=<%=eCode%>";
}
</script>
</head>

<body>

<!-- 텐바이텐과 조금 더 가까워지기 -->
<div class="mEvt50805">
	<div class="getCloseTenbyten">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/tit_get_close_tenbyten.jpg" alt="부담 없는 수신동의 봄맞이 이벤트 텐바이텐과 조금 더 가까워지기" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_get_close_tenbyten.jpg" alt="봄바람이 살랑 살랑 불어오는 요즘 누군가를 알아가고 싶은 계절이에요~ 부담 없이 담백하게 상대를 알아가는 방법! 텐바이텐과 조금 더 가까워 질 수 있는 방법을 알려드릴게요! 이벤트기간 : 4월 7일 ~ 13일 ㅣ 당첨자발표 : 4월 15일" /></p>

		<% '이메일 수신동의 및 카카오톡 TMS 수신동의 %>
		<div class="takePart">
			<div class="eventEmail">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/tit_email.gif" alt="이메일 수신동의" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_email.gif" alt="매일 매일 보고 싶어도 매일 보내지 않는 텐바이텐 E-mail이에요. 절대 귀찮게 하지 않아요. 밀땅의 고수랍니다." /></p>
				<div class="btnAgree">
					<% ' for dev msg : 수신동의 후에 아래 주석처리된 부분으로 교체해주세요. %>
					
					<% if vIsEventE = "x" then %>
						<a href="" onclick="jsSubmitComment('e'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_email.gif" alt="이메일 수신동의 (100마일리지 지급)" /></a>
					<% else %>					
						<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_email_end.gif" alt="수신동의 완료" /></span>
					<% end if %>
					
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_mileage_email.gif" alt="4월 15일 마일리지 일괄 지급" /></p>
				</div>
			</div>
			<% 'Layer Popup : 이메일 수신동의 %>
			<div  id="layerEmail" class="layerPopup">
				<div class="layerGetClose">
					<p class="heading"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/tit_email_agree.gif" alt="이메일 수신동의" /></p>
					<% ' for dev msg : 수신동의를 하지 않은 경우 %>

					<%
					if vIsEventE = "x" then
						if vEmail = "" then
					%>
							<div class="before">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_email_agree.gif" alt="이메일 인증이 필요해요! 마이텐바이텐 페이지로 이동합니다" /></p>
								<p>수신동의를 하시면 신상품 소식과 시크릿 할인 등<br /> 다양한 이벤트 소식을 받아 보실 수 있어요.</p>
								<div class="btnConfirm"><a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_confirm.gif" alt="확인" /></a></div>
							</div>
						<% else %>
							<div class="after">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_email_agree_done.gif" alt="이미 수신동의 하셨네요, 응모완료!" /></p>
								<p class="emailAddress"><span><%=vEmail%></span></p>
								<p>정보 수정은 <em>마이텐바이텐</em>을 이용해주세요</p>
								<div class="btnConfirm"><a href="javascript:pageReload();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_confirm.gif" alt="확인" /></a></div>
							</div>
						<% end if %>
					<% else %>
						<div class="after">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_email_agree_done.gif" alt="이미 수신동의 하셨네요, 응모완료!" /></p>
							<p class="emailAddress"><span><%=vEmail%></span></p>
							<p>정보 수정은 <em>마이텐바이텐</em>을 이용해주세요</p>
							<div class="btnConfirm"><a href="javascript:pageReload();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_confirm.gif" alt="확인" /></a></div>
						</div>
					<% end if %>

					<div class="btnClose"><button type="button" onclick="javascript:pageReload();">레이어 닫기</button></div>
				</div>
			</div>
			<% ' //Layer Popup : 이메일 수신동의%>

			<% ' 카카오톡 TMS 수신동의 %>
			<div class="eventKakao">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/tit_kakao.gif" alt="카카오톡 TMS 수신동의" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_kakao.gif" alt="'자니?' 이런 구남친 같은 메시지는 보내지 않아요. 항상 신선한 이벤트 소식만 빠르게 전달할게요." /></p>
				<div class="btnAgree">
					<% ' for dev msg : 수신동의 후에 아래 주석처리된 부분으로 교체해주세요. %>
					
					<% if vIsEventK = "x" then %>
						<a href="" onclick="jsSubmitComment('k'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_kakao.gif" alt="카카오톡 수신동의 (100마일리지 지급)" /></a>
					<% else %>
						<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_kakao_end.gif" alt="수신동의 완료" /></span>
					<% end if %>
					
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_mileage_kakao.gif" alt="4월 15일 마일리지 일괄 지급" /></p>
				</div>
			</div>

			<% ' Layer Popup : 카카오톡 TMS 수신동의 %>
			<div id="layerKakao" class="layerPopup">
				<div class="layerGetClose">
					<p class="heading"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/tit_kakao_agree.gif" alt="카카오톡 수신 동의" /></p>
					<%' for dev msg : 수신동의를 하지 않은 경우 %>
					<% 
					if vIsEventK = "x" then
						if vHp = "" then 
					%>
							<div class="before">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_kakao_agree.gif" alt="카카오톡 인증이 필요해요! 마이텐바이텐 페이지로 이동합니다" /></p>
								<p>수신동의를 하시면 신상품 소식과 시크릿 할인 등<br /> 다양한 이벤트 소식을 받아 보실 수 있어요.</p>
								<div class="btnConfirm"><a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_confirm.gif" alt="확인" /></a></div>
							</div>
						<% else %>
							<div class="after">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_kakao_agree_done.gif" alt="이미 수신동의 하셨네요, 응모완료!" /></p>
								<p class="mobileNumber"><span><%=vHp%></span></p>
								<p>정보 수정은 <em>마이텐바이텐</em>을 이용해주세요</p>
								<div class="btnConfirm"><a href="javascript:pageReload();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_confirm.gif" alt="확인" /></a></div>
							</div>
							<% ' //for dev msg : 수신동의를 한 경우 %>
						<% end if %>
					<% else %>
						<div class="after">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_kakao_agree_done.gif" alt="이미 수신동의 하셨네요, 응모완료!" /></p>
							<p class="mobileNumber"><span><%=vHp%></span></p>
							<p>정보 수정은 <em>마이텐바이텐</em>을 이용해주세요</p>
							<div class="btnConfirm"><a href="javascript:pageReload();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/btn_confirm.gif" alt="확인" /></a></div>
						</div>
					<% end if %>

					<div class="btnClose"><button type="button" onclick="javascript:pageReload();">레이어 닫기</button></div>
				</div>
			</div>
			<% ' //Layer Popup : 카카오톡 TMS 수신동의 끝 %>
		</div>
		<% ' //카카오톡 TMS 수신동의 끝 %>

		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_gift.gif" alt="텐바이텐과 조금 더 가까워지셨나요? 모든 수신동의를 해주신 고객님 중 20분을 추첨하여 텐바이텐 기프트카드 3만원을 선물로 드립니다." /></p>

		<div class="note">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/tit_note.gif" alt="이벤트 유의사항" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50805/txt_note.gif" alt="한 개의 아이디 당 1회 참여 가능하며, 이벤트 특성상 조기 종료될 수 있습니다. 마일리지는 4월 15일 일괄지급 됩니다. (당첨사은품은 주소 확인 후 배송 됩니다) 이미 메일 수신동의 / 카카오톡 인증을 하신 분은 클릭만 하셔도 이벤트 응모가 인정됩니다. 메일 수신동의 / 카카오톡 인증은 개인정보변경 사항으로 마이텐바이텐 페이지에서 변경 가능합니다. 이벤트 응모 후 기간 내 고의적으로 변경하는 경우 응모취소가 될 수 있습니다." /></p>
		</div>

	</div>
	<form name="frmGubun" method="post" action="doEventSubscript50804.asp" style="margin:0px;" target="prociframe">
	<input type="hidden" name="gubun" value="">
	</form>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0" height="0"></iframe>	
</div>
<!-- //텐바이텐과 조금 더 가까워지기 -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->