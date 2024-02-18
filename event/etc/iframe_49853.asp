<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim vUserID, eCode, vQuery, vLinkCode, vIsEventE, vIsEventK, vHp, vEmail, vTmp1, vTmp2, vTmp3
	vUserID = GetLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21104"
		vLinkCode = "21105"
	Else
		eCode = "49853"
		vLinkCode = "49854"
	End If
	

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
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 회사에서 쇼핑하기</title>
<style type="text/css">
.mEvt49854 {position:relative;}
.mEvt49854 img {vertical-align:top; }
.mEvt49854 p {max-width:100%;}
.mEvt49854 .gift {padding:0 7% 6%;}
.mEvt49854 .shoppingCompany {background:url(http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_bg_cont.png) left top repeat-y; background-size:100% auto;}
.mEvt49854 .applyEvt li {padding-bottom:5%;}
.mEvt49854 .applyEvt li .getMileage {position:relative; width:45%; margin-left:27%; display:inline-block; text-align:center; background-position:left top; background-repeat:no-repeat; background-size:100% 100%;}
.mEvt49854 .applyEvt li .getMileage a {position:absolute; left:0; top:0; display:inline-block; width:100%; height:100%; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49854/blank.png) left top no-repeat; background-size:100% 100%; z-index:50;}
.mEvt49854 .applyEvt li.mailing .getMileage {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_btn_mailing.png)}
.mEvt49854 .applyEvt li.kakao .getMileage {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_btn_kakao.png)}
.mEvt49854 .applyEvt li.finish.mailing .getMileage {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_btn_mailing_finish.png)}
.mEvt49854 .applyEvt li.finish.kakao .getMileage {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_btn_mailing_finish.png)}
.mEvt49854 .applyEvt li.finish .getMileage a {display:none;}
.mEvt49854 .secretShopping {border:2px solid #000; margin:5% 4% 0;}
.mEvt49854 .certPopup {display:none; text-align:center;}
.mEvt49854 .certPopup .hd { padding:2.5% 3% 2%; background:#cc0d0d;}
.mEvt49854 .certInner {padding:7% 0; background:#fff;}
.mEvt49854 .certInner p {padding-bottom:8px;}
.mEvt49854 .certInner .btn {margin-top:10px;}
.mEvt49854 .certInner .user {color:#cc0d0d; font-size:16px; line-height:17px;}
</style>
<script type="text/javascript">
function jsSubmitComment(g){
	var frm = document.frmGubun;

	<% If vUserID = "" Then %>
		alert('로그인을 하셔야 이벤트\n응모가 가능합니다.');
		top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=vLinkCode%>"
		return;
	<% End If %>

	<% If vUserID <> "" Then %>
		frm.gubun.value = g;
		frm.submit();
	<% End If %>

}

function pageReload(){
	top.location.href = "/event/eventmain.asp?eventid=<%=eCode%>";
}

</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt49854">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_head.png" alt="회사에서 쇼핑하기" style="width:100%" /></p>
		<div class="shoppingCompany">
			<div class="applyEvt">
				<ol>
					<li class="mailing<%=CHKIIF(vIsEventE="o"," finish","")%>">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_apply_mailing.png" alt="하나, 업무 메일 확인하는 척 하면서 텐바이텐 메일링으로 세일소식 받기" style="width:100%" /></p>
						<span class="getMileage"><a href="javascript:jsSubmitComment('e');">이메일 수신동의 100마일리지 지급</a><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/blank.png" alt="" style="width:100%" /></span>
						<div class="secretShopping" style="display:none;">
							<div class="certPopup" id="e1">
								<p class="hd"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_pop_mail_head.png" alt="이메일 수신 동의"  style="width:80px" /></p>
								<div class="certInner">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_mail_cert.png" alt="이메일 인증이 필요해요!" style="width:161px" /></p>
									<p><a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_go_mypage.png" alt="마이텐바이텐 페이지로 이동합니다" style="width:196px" /></a></p>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_benefit.png" alt="수신동의를 하시면 신상품 소식과 시크릿 할인 등 다양한 이벤트 소식을 받아 보실 수 있어요" style="width:219px" /></p>
									<span class="btn btn1 gryB w90B"><a href="/my10x10/userinfo/confirmuser.asp" target="_top">확인</a></span>
								</div>
							</div>

							<div class="certPopup" id="e2">
								<p class="hd"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_pop_mail_head.png" alt="이메일 수신 동의"  style="width:80px" /></p>
								<div class="certInner">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_finish.png" alt="이미 수신동의 하셨네요, 응모완료!" style="width:230px;" /></p>
									<p class="user"><%=vEmail%></p>
									<p><a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_modify.png" alt="정보수정은 마이텐바이텐을 이용해주세요." style="width:204px;" /></a></p>
									<span class="btn btn1 gryB w90B"><a href="javascript:pageReload();">확인</a></span>
								</div>
							</div>
						</div>
					</li>
					<li class="kakao<%=CHKIIF(vIsEventK="o"," finish","")%>">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_apply_kakao.png" alt="둘, 친구랑 메시지 보내는 척 하면서 카카오톡으로 쇼핑정보 받기!" style="width:100%" /></p>
						<span class="getMileage"><a href="javascript:jsSubmitComment('k');">카카오톡 인증 100마일리지 지급</a><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/blank.png" alt="" style="width:100%" /></span>

						<div class="secretShopping" style="display:none;">
							<div class="certPopup" id="k1">
								<p class="hd"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_pop_kakao_head.png" alt="카카오톡 수신 동의" style="width:104px" /></p>
								<div class="certInner">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_kakao_cert.png" alt="카카오톡 인증이 필요해요!" style="width:176px" /></p>
									<p><a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_go_mypage.png" alt="마이텐바이텐 페이지로 이동합니다" style="width:196px" /></a></p>
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_benefit.png" alt="수신동의를 하시면 신상품 소식과 시크릿 할인 등 다양한 이벤트 소식을 받아 보실 수 있어요" style="width:219px" /></p>
									<span class="btn btn1 gryB w90B"><a href="/my10x10/userinfo/confirmuser.asp" target="_top">확인</a></span>
								</div>
							</div>

							<div class="certPopup" id="k2">
								<p class="hd"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_pop_kakao_head.png" alt="카카오톡 수신 동의" style="width:104px" /></p>
								<div class="certInner">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_finish.png" alt="이미 수신동의 하셨네요, 응모완료!" style="width:230px;" /></p>
									<p class="user"><%=vHp%></p>
									<p><a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_txt_modify.png" alt="정보수정은 마이텐바이텐을 이용해주세요." style="width:204px;" /></a></p>
									<span class="btn btn1 gryB w90B"><a href="javascript:pageReload();">확인</a></span>
								</div>
							</div>
						</div>
					</li>
				</ol>
			</div>
			<p class="gift"><a href="/category/category_itemPrd.asp?itemid=830847" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_gift.png" alt="눈치 안 보는 쇼핑 방법 2가지를 모두 참여하신 고객님 중 20분을 추첨하여 필기는 누구보다 프로처럼 할 수 있는 라미 만년필을 선물로 드립니다." style="width:100%" /></a></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49854/49854_notice.png" alt="이벤트 유의사항" style="width:100%" /></p>
		</div>
		<form name="frmGubun" method="post" action="doEventSubscript49853.asp" style="margin:0px;" target="prociframe">
		<input type="hidden" name="gubun" value="">
		</form>
	</div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->