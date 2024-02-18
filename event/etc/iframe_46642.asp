<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	dim eCode, cnt, sqlStr, regdate, gubun,  i, totalsum, mode, result ,opt , opt1 , opt2, opt3, opt4, emailok, smsok, usermail, usercell
	Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21002"
	Else
		eCode 		= "46611"
	End If

	If Not(GetLoginUserID()="" or isNull(GetLoginUserID())) Then
		sqlstr = "Select " &_
				" sub_opt3" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & GetLoginUserID() & "' "
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			opt = rsget(0)
		End If
		rsget.Close

		opt1 = SplitValue(opt,"//",0)
		opt2 = SplitValue(opt,"//",1)
		opt3 = SplitValue(opt,"//",2)
		opt4 = SplitValue(opt,"//",3)

		If opt1="" then opt1=0
		If opt2="" then opt2=0
		If opt3="" then opt3=0
		If opt4="" then opt4=0

		sqlstr = "select email_10x10, smsok, usermail, usercell from db_user.dbo.tbl_user_n where userid='" & GetLoginUserID() & "'"
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			emailok = rsget(0)
			smsok	= rsget(1)
			usermail = rsget(2)
			usercell = rsget(3)
		end if
		rsget.Close
	End If


%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 신입사원이 실수로 만든 이벤트! 누르지 마</title>
<style type="text/css">
.mEvt46642 {}
.mEvt46642 img {vertical-align:top;}
.mEvt46642 .tPad12 {padding-top:12px;}
.mEvt46642 .tPad20 {padding-top:20px;}
.mEvt46642 .receiveAgree ul {overflow:hidden; width:100%;}
.mEvt46642 .receiveAgree li { float:left; width:50%;}
.mEvt46642 .receiveAgree li .agrCont {position:relative;}
.mEvt46642 .receiveAgree li .clickBtn {position:absolute; left:27%; bottom:8%; display:block; width:46%; height:13%; cursor:pointer; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/46611/46611_btn_blank.png) left top no-repeat; background-size:100% 100%;}
.mEvt46642 .clickLyr {display:none;}
.mEvt46642 .clickLyrCont {padding:25px 0 20px; text-align:center; background:url(http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_bg_layer.png) left bottom no-repeat; background-size:100% auto;}
.mEvt46642 .clickLyrCont .agrInfo {padding-top:12px; font-size:18px; line-height:1; font-weight:bold; color:#cc0d0d;}
.mEvt46642 .clickLyrCont .btn {margin-top:13px;}
</style>
<script type="text/javascript">
$(function(){
	$('.openEmail').click(function(){
		$('.certEmail').show();
		$('.certSms').hide();
	});
	$('.openSms').click(function(){
		$('.certSms').show();
		$('.certEmail').hide();
	});
	$('.closeClickLyr').click(function(){
		$(this).parents('.clickLyr').hide();
		return false
	});
});


function result_go(xx) {
<% If IsUserLoginOK Then %>
	if (xx == 1){
		if (navigator.appName == "Microsoft Internet Explorer")
		{window.external.AddFavorite('http://www.10x10.co.kr','텐바이텐');}
		if (navigator.appName == "Netscape")
		{alert("Ctrl + D 키를 눌러서 즐겨찾기를 해주세요.");}

		document.getElementById('evt1').style.display="none";
		document.getElementById('evt1_click').style.display="none";
		document.getElementById('evt11').style.display="block";

		document.frm.result.value= xx;
		document.frm.action = "doEventSubscript46642.asp";
		document.frm.submit();
	}
	if (xx == 2){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','','');
		document.getElementById('evt2').style.display="none";
		document.getElementById('evt2_click').style.display="none";
		document.getElementById('evt22').style.display="block";

		document.frm.result.value= xx;
		document.frm.action = "doEventSubscript46642.asp";
		document.frm.submit();
	}
	<% If emailok="Y" then %>
	if (xx == 3){
		document.getElementById('evt3').style.display="none";
		document.getElementById('evt3_click').style.display="none";
		document.getElementById('evt33').style.display="block";
		jsGo46642();

		document.frm.result.value= xx;
		document.frm.action = "doEventSubscript46642.asp";
		document.frm.submit();
	}
	<% Else %>
	if (xx == 3){
		jsGo46642();
	}
	<% End If %>

	<% If smsok="Y" then %>
	if (xx == 4){
		document.getElementById('evt4').style.display="none";
		document.getElementById('evt4_click').style.display="none";
		document.getElementById('evt44').style.display="block";
		jsGo46642();

		document.frm.result.value= xx;
		document.frm.action = "doEventSubscript46642.asp";
		document.frm.submit();
	}
	<% Else %>
	if (xx == 4){
		jsGo46642();
	}
	<% End If %>
<% Else %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
<% End If %>
}

function jsGo46642(){
	//location.href = "#46642link";
	location.href = "#46642link2";
}
</script>
</head>
<body>

			<!-- content area -->
			<div class="content" id="contentArea">

				<div class="mEvt46642">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_head.png" alt="신입사원이 실수로 만든 이벤트! 누르지 마" style="width:100%;" /></div>
					<div class="receiveAgree">
		<form name="frm" method="POST" style="margin:0px;" target="evtFrmProc">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<input type="hidden" name="result" value="<%=result%>">
						<ul>
							<li class="c01">
								<div class="agrCont">

									<% If opt1 <> "3" and opt2 <> "3" and opt3 <> "3" and opt4 <> "3" then %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_evt_cont01.png" id="evt3" style="display:block;width:100%;" alt="1. 메일 수신 동의" />
									<span class="clickBtn openEmail" id="evt3_click" onclick="result_go('3');">CLICK</span>

									<img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_evt_cont01_click.png" style="display:none;width:100%;" id="evt33" alt="헉, 또 누르다니ㅜㅜ" />
									<% elseif opt1 = "3" or opt2 = "3" or opt3 = "3" or opt4 = "3" then %>
										<img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_evt_cont01_click.png" alt="헉, 또 누르다니ㅜㅜ" style="width:100%;" />
									<% End If %>
								</div>
							</li>
							<li class="c02">
								<div class="agrCont">
									<% If opt1 <> "4" and opt2 <> "4" and opt3 <> "4" and opt4 <> "4" then %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_evt_cont02.png" id="evt4" alt="2. SMS 수신 동의" style="width:100%;" />
									<span class="clickBtn openSms" id="evt4_click" onclick="result_go('4');">CLICK</span>

									<img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_evt_cont02_click.png" style="display:none;width:100%;" id="evt44" alt="아이고 난 망했다" />
									<% elseif opt1 = "4" or opt2 = "4" or opt3 = "4" or opt4 = "4" then %>
										<img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_evt_cont02_click.png" alt="아이고 난 망했다" style="width:100%;" />
									<% End If %>
								</div>
							</li>
						</ul>
	</form>
						<!-- 이메일 수신 동의 레이어 -->
						<% If IsUserLoginOK Then %>
						<a name="46642link" />
						<div class="clickLyr certEmail">
							<p class="tit"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_tit_email.png" alt="이메일 수신 동의" style="width:100%;" /></p>

							<!-- 인증 전 -->
							<% If emailok="N" then %>
							<div class="clickLyrCont">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_txt_email01.png" alt="이메일 인증이 필요해요!" style="width:100%;" /></p>
								<p class="tPad12"><a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_txt_go_tenten01.png" alt="마이텐바이텐 페이지로 이동합니다" style="width:100%;" /></a></p>
								<p class="tPad20"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_txt_email02.png" alt="이메일 수신동의를 하시면 신상품 소식과 시크릿 할인 등 다양한 이벤트 소식을 받아 보실 수 있어요" style="width:100%;" /></p>
								<span class="btn btn1 gryB w100B closeClickLyr1"><a href="/my10x10/userinfo/confirmuser.asp" target="_top">확인</a></span>
							</div>
							<% elseif emailok="Y" then %>
							<!-- 이미 인증되어 있을 경우 -->
							<div class="clickLyrCont">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_txt_already.png" alt="이미 수신동의 하셨네요, 응모완료!" style="width:100%;" /></p>
								<p class="agrInfo"><%= usermail %></p>
								<p class="tPad20"><a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_txt_go_tentne02.png" alt="정보 수정은 마이텐바이텐을 이용해 주세요." style="width:100%;" /></a></p>
								<span class="btn btn1 gryB w100B closeClickLyr"><a href="#">확인</a></span>
							</div>
							<% End If %>
						</div>
						<!--// 이메일 수신 동의 레이어 -->

						<!-- SMS 수신 동의 레이어 -->
						<a name="46642link2" />
						<div class="clickLyr certSms">
							<p class="tit"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_tit_sms.png" alt="SMS 수신 동의" style="width:100%;" /></p>

							<!-- 인증 전 -->
							<% If smsok="N" then %>
							<div class="clickLyrCont">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_txt_sms01.png" alt="SMS 인증이 필요해요!" style="width:100%;" /></p>
								<p class="tPad12"><a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_txt_go_tenten01.png" alt="마이텐바이텐 페이지로 이동합니다" style="width:100%;" /></a></p>
								<p class="tPad20"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_txt_sms02.png" alt="SMS 수신동의를 하시면 신상품 소식과 시크릿 할인 등 다양한 이벤트 소식을 받아 보실 수 있어요" style="width:100%;" /></p>
								<span class="btn btn1 gryB w100B closeClickLyr1"><a href="/my10x10/userinfo/confirmuser.asp" target="_top">확인</a></span>
							</div>

							<!-- 이미 인증되어 있을 경우 -->
							<% elseif smsok="Y" then %>
							<div class="clickLyrCont">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_txt_already.png" alt="이미 수신동의 하셨네요, 응모완료!" style="width:100%;" /></p>
								<p class="agrInfo"><%= usercell  %></p>
								<p class="tPad20"><a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_txt_go_tentne02.png" alt="정보 수정은 마이텐바이텐을 이용해 주세요." style="width:100%;" /></a></p>
								<span class="btn btn1 gryB w100B closeClickLyr"><a href="#">확인</a></span>
							</div>
							<% End If %>
						</div>
						<% End If %>
						<!--// SMS 수신 동의 레이어 -->
					</div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_go_pc.png" alt="지금 PC에서는 즐겨찾기 추가, 페이스북 링크 이벤트도 함께 진행되고 있습니다." style="width:100%;" /></div>
					<div>
						<% If int(opt1)+int(opt2)+int(opt3)+int(opt4) <> 10 then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_gift_finish.png" id="resultok" style="display:none;width:100%;" alt="응모완료! 이왕 이렇게 된 거 4단계 모두 누르신 분들 중 추첨을 통해 총 100분께 피스메이커 카드지갑을 보내드립니다!" />
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_gift.png" id="resultno" style="display:block;width:100%;" alt="이왕 이렇게 된 거 4단계 모두 누르신 분들 중 추첨을 통해 총 100분께 피스메이커 카드지갑을 보내드립니다!" />
						<% else %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_gift_finish.png" style="width:100%;" alt="응모완료! 이왕 이렇게 된 거 4단계 모두 누르신 분들 중 추첨을 통해 총 100분께 피스메이커 카드지갑을 보내드립니다!" />
						<% End If %>
					</div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/46642/46642_notice.png" alt="이벤트 유의사항" style="width:100%;" /></div>
				</div>
			</div>
			<!-- //content area -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->