<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20958
Else
	eCode   =  45566
End If

dim com_egCode, bidx
	Dim iCTotCnt, arrCList
	Dim timeTern, totComCnt

	com_egCode = requestCheckVar(Request("eGC"),1)	'그룹 번호(엣지1, 초식2, 연하3)

%>

<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 컨트롤비트 다운받았습니다</title>
	<style type="text/css">
	.mEvt45566 img {vertical-align:top;}
	.mEvt45566 .applyCont {padding:20px 0 25px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45566/45566_bg01.png) left bottom no-repeat; background-size:100% 100%;}
	.mEvt45566 .applyCont .applyBtn {width:50%; margin:0 auto;}
</style>
<script type="text/javascript">
	function jsSubmitComment(frm){
	<% if datediff("d",date(),"2013-09-25")>0 then %>
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   frm.action = "/event/etc/doEventSubscript45566.asp";
	   return true;

	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}
</script>
</head>
<body>
			<!-- content area -->
			<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="iCTot" value="">
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
			<div class="content" id="contentArea">
				<div class="mEvt45566">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45566/45566_head.png" alt="컨트롤비트 다운받았습니다" style="width:100%;" /></div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45566/45566_img01.png" alt="텐바이텐이 당신의 고민을 디스합니다! 응원해주세요! 추첨을 통해 총 50분에게 컨트롤비트 패키지를 선물로 드립니다." style="width:100%;" /></div>
					<div><a href="/shopping/category_prd.asp?itemid=485297"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45566/45566_img02.png" alt="참지 마! 참지 마! 맛있는 거 참지 마! 많이 먹고 운동해~" style="width:100%;" /></a></div>
					<div><a href="/shopping/category_prd.asp?itemid=928486"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45566/45566_img03.png" alt="늦지 마! 늦지마! 지각하면 눈치 보여! 벨소리 리듬에 몸을 맡겨! " style="width:100%;" /></a></div>
					<div><a href="/shopping/category_prd.asp?itemid=832657"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45566/45566_img04.png" alt="건조해~ 홍! 푸석해~ 홍! 물 먹지 말고 피부에게 양보해! 물광피부, 피부미녀 이젠 너의 스토리" style="width:100%;" /></a></div>
					<div class="applyCont">
						<p class="applyBtn"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/45566/45566_btn_apply.png" alt="응모하기" style="width:100%;" /></a></p>
					</div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45566/45566_notice.png" alt="이벤트 안내" style="width:100%;" /></div>
				</div>
			</div>
			</form>
			<!-- //content area -->

</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->