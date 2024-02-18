<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
'####################################################
' Description : 스타워즈 텐바이텐 참여 이벤트
' History : 2014.12.08 원승현 생성
'####################################################

dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, vLinkECode, prevEventJoinChk, EventJoinChk, usrSelectItemid, preveCode, sqlStr
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID
	
	IF application("Svr_Info") = "Dev" Then
		eCode = "21396"
		vLinkECode = "21392"
	Else
		eCode = "57275"
		vLinkECode = "57474"
	End If

	If IsUserLoginOK Then
		sqlStr = ""
		sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
		sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
		sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' " &VBCRLF
		sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "' And  convert(varchar(10), regdate, 120) = '"&Left(Now(), 10)&"' "
		rsget.Open sqlStr, dbget, 1
			EventJoinChk = rsget(0) '// 현재 이벤트 참여여부
		rsget.Close
	End If

%>
<style type="text/css">

.mEvt57474 img {width:100%; vertical-align:top;}
.mEvt57474 .swMenu {position:relative;}
.mEvt57474 .swMenu ul {position:absolute; left:0; bottom:0; overflow:hidden; width:100%; height:100%; z-index:30;}
.mEvt57474 .swMenu li {float:left; width:25%; height:63%; margin-top:11%;}
.mEvt57474 .swMenu li a {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.mEvt57474 .swMenu li.on {height:100%; margin-top:0;}
.mEvt57474 .selectGift {background:url(http://webimage.10x10.co.kr/eventIMG/2014/57474/bg_select_area.jpg) left top repeat; background-size:100% 100%;}
.mEvt57474 .selectGift ul {overflow:hidden; padding:20px 10px 10px;}
.mEvt57474 .selectGift li {float:left; width:50%; padding:0 5px 18px; text-align:center;}
.mEvt57474 .selectGift li input {margin-top:8px}
.mEvt57474 .selectGift .apply {display:block; width:65%; margin:0 auto;}
.mEvt57474 .benefit {position:relative;}
.mEvt57474 .benefit .apply {display:block; position:absolute; right:4%; bottom:15%; width:23%;}
@media all and (min-width:480px){
	.mEvt57474 .selectGift li {padding:0 8px 27px;}
	.mEvt57474 .selectGift li input {margin-top:12px}
}

</style>
<script type="text/javascript">

function jsSubmitComment(){
	var frm = document.frmcom;
	
	<% If vUserID = "" Then %>
		alert('로그인을 하셔야 응모할 수가 있습니다.');
		top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=vLinkECode%>"
	<% End If %>

	<% If vUserID <> "" Then %>
		<% if EventJoinChk > 0 then %>
			alert("이미 이벤트 응모가 완료되었습니다.\n내일 다시 응모하여 주세요.");
			return false;
		<% end if %>

		if ($("input:[name='stargift']").is(":checked")==false)
		{
			alert("받고 싶은 선물을 선택하고 응모하여 주세요.");
			return false;
		}
		else
		{
		   frm.submit();
		}
	<% End If %>
}

</script>
</head>
<body>




<div class="evtCont">
	<!-- 스타워즈 크리스마스 선물(M) -->
	<div class="mEvt57474">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/57474/tit_starwars.jpg" alt="스타워즈 크리스마스 에피소드" /></h2>
		<div class="swMenu">
			<ul>
				<li><a href="/event/eventmain.asp?eventid=57473" target="_top">아이템</a></li>
				<li class="on"><a href="/event/eventmain.asp?eventid=57474" target="_top">크리스마스 선물</a></li>
				<li><a href="/event/eventmain.asp?eventid=57475" target="_top">에피소드7 미리보기</a></li>
				<li><a href="/event/eventmain.asp?eventid=57476" target="_top">모바일카드 보내기</a></li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57473/tab_starwars02.jpg" alt="" /></p>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57474/txt_select_gift.jpg" alt="텐바이텐 또는 GS SHOP에서 스타워즈 캐릭터 제품을 구매하셨나요? 스타워즈 캐릭터 제품을 구매하신 후 응모하시면 총 150분에게 원하는 상품을 선물로 드립니다." /></p>
		<!-- 선물 선택 -->
		<form name="frmcom" method="post" action="doEventSubscript57474.asp" style="margin:0px;" target="prociframe">
		<div class="selectGift">
			<ul>
				<li>
					<label for="gift01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57474/img_gift01.png" alt="요다 손목시계" /></label>
					<input type="radio" id="gift01" name="stargift" value="932428" />
				</li>
				<li>
					<label for="gift02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57474/img_gift02.png" alt="다스베이더 키체인" /></label>
					<input type="radio" id="gift02" name="stargift" value="926688" />
				</li>
				<li>
					<label for="gift03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57474/img_gift03.png" alt="스톰트루퍼 플래시" /></label>
					<input type="radio" id="gift03" name="stargift" value="104109111"/>
				</li>
				<li>
					<label for="gift04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57474/img_gift04.png" alt="R2D2 키체인" /></label>
					<input type="radio" id="gift04" name="stargift" value="1060364"/>
				</li>
			</ul>
			<a class="apply" href="" onclick="jsSubmitComment();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57474/btn_apply.png" alt="응모하기" /></a>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57474/txt_tip.png" alt="상품을 선택하고 응모하면 해당 상품이 당신의 WISH LIST에도 쏙! 담겨요!(기본폴더를 확인하세요)" /></p>
		</div>
		<!--// 선물 선택 -->
		</form>
		
		<% If Left(Now(), 10) >= "2014-12-15" Then %>
			<!--div class="benefit">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57474/txt_benefit_plus.jpg" alt="특별한 혜택 PLUS!" /></p>
				<a class="apply" href="http://m.gsshop.com/event/2014_12/apply_starwarsmovie.jsp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57474/btn_apply02.png" alt="참여하기" /></a>
			</div-->
		<% End If %>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57474/txt_event_noti.jpg" alt="이벤트 유의사항" /></p>
	</div>
	<!--// 스타워즈 크리스마스 선물(M) -->

</div>
<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px" frameborder="0" marginheight="0" marginwidth="0"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->