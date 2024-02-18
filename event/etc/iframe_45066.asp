<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
Dim eCode, sqlstr, totalsum, cnt, mode, result

IF application("Svr_Info") = "Dev" THEN
	eCode   =  20941

Else
	eCode   =  45066

End If

	If Not(GetLoginUserID()="" or isNull(GetLoginUserID())) Then
		sqlstr = "Select count(sub_idx) as totcnt" &_
				"  ,count(case when convert(varchar(10),regdate,120) = '" & Left(now(),10) & "' then sub_idx end) as daycnt" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & GetLoginUserID() & "'"
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			totalsum = rsget(0)
			cnt = rsget(1)
		rsget.Close
	End if

%>
<!doctype html>
<html lang="ko">
<head>

	<title>생활감성채널, 텐바이텐 > 이벤트 > 우는 아이를 달래주세요~</title>
	<style type="text/css">
	.mEvt45067 {position:relative; width:100%;}
	.mEvt45067 * {padding:0; margin:0;}
	.mEvt45067 img {vertical-align:top;}
	.mEvt45067 .goGame {position:relative; text-align:center;}
	.mEvt45067 .goGame .strBtn {position:absolute; width:70%; left:50%; top:30%; margin-left:-35%;}
	.mEvt45067 .ladderGame li {position:relative; width:100%; margin-bottom:10px; background-size:100% auto; background-repeat:no-repeat; background-position:left top;}
	.mEvt45067 .ladderGame li .select {overflow:hidden; position:absolute; left:0; bottom:0; width:100%; height:40%;}
	.mEvt45067 .ladderGame li .select p {float:left; width:50%; height:100%; cursor:pointer; text-indent:-9999px;}
	.mEvt45067 .ladderGame li.step01On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step01_on.png'); }

	.mEvt45067 .ladderGame li.step02On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step02_on01.png');}
	.mEvt45067 .ladderGame li.step02On02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step02_on02.png');}

	.mEvt45067 .ladderGame li.step03On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step03_on01.png');}
	.mEvt45067 .ladderGame li.step03On02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step03_on02.png');}
	.mEvt45067 .ladderGame li.step03On03 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step03_on03.png');}
	.mEvt45067 .ladderGame li.step03On04 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step03_on04.png');}

	.mEvt45067 .ladderGame li.step04On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step04_on01.png');}
	.mEvt45067 .ladderGame li.step04On02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step04_on02.png');}
	.mEvt45067 .ladderGame li.step04On03 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step04_on03.png');}
	.mEvt45067 .ladderGame li.step04On04 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step04_on04.png');}
	.mEvt45067 .ladderGame li.step04On05 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step04_on05.png');}
	.mEvt45067 .ladderGame li.step04On06 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step04_on06.png');}
	.mEvt45067 .ladderGame li.step04On07 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step04_on07.png');}
	.mEvt45067 .ladderGame li.step04On08 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_game_step04_on08.png');}

	.mEvt45067 .ladderGame li.finishOn01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_finish01.png');}
	.mEvt45067 .ladderGame li.finishOn02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_finish02.png');}
	.mEvt45067 .ladderGame li.finishOn03 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_finish03.png');}
	.mEvt45067 .ladderGame li.finishOn04 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_finish04.png');}
	.mEvt45067 .ladderGame li.finish {position:relative; text-align:center;}
	.mEvt45067 .ladderGame li.finish p {position:absolute; left:50%; bottom:0; width:76%; margin-left:-38%;}

	.mEvt45067 .evtWin {position:relative; text-align:center;}
	.mEvt45067 .evtWin .okBtn {position:absolute; width:40%; left:50%; bottom:10%; margin-left:-20%;}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript">
$(function () {
	$(".mEvt45067 .ladderGame li").append('<img src="http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_blank.png" alt="" style="width:100%;" />');
});

	function StartGame() {

		<% If Now() < #09/09/2013 00:00:00# Then %>
			<% If IsUserLoginOK Then %>
				<% if cnt >= 2 then %>
			alert('하루에 2번 응모 가능합니다.\n\n내일 다시 응모해주세요.');
				<% else %>

				document.getElementById('startgame').style.display="none";
				document.getElementById('selection').style.display="block";
				document.getElementById('step01').style.display="block";
				document.getElementById('evt_head').style.display="none";


				<% end if %>
			<% Else %>
			alert('로그인 후에 응모하실 수 있습니다.');
			<% End If %>
		<% else %>
			alert('이벤트가 종료되었습니다.');
		<% end if %>

}
	function step1_1() {
		document.getElementById('step01').style.display="none";

		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="block";
		document.getElementById('sel_step02_1').style.display="block";
}
	function step1_2() {
		document.getElementById('step01').style.display="none";

		document.getElementById('step02').className = "step02 step02On02";
		document.getElementById('step02').style.display="block";
		document.getElementById('sel_step02_2').style.display="block";
}

	function step2_1() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";

		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="block";
		document.getElementById('sel_step03_1').style.display="block";
}
	function step2_2() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";

		document.getElementById('step03').className = "step03 step03On02";
		document.getElementById('step03').style.display="block";
		document.getElementById('sel_step03_2').style.display="block";
}
	function step2_3() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On02";
		document.getElementById('step02').style.display="none";

		document.getElementById('step03').className = "step03 step03On03";
		document.getElementById('step03').style.display="block";
		document.getElementById('sel_step03_3').style.display="block";
}
	function step2_4() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On02";
		document.getElementById('step02').style.display="none";

		document.getElementById('step03').className = "step03 step03On04";
		document.getElementById('step03').style.display="block";
		document.getElementById('sel_step03_4').style.display="block";

}

	function step3_1() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";

		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="block";
		document.getElementById('sel_step04_1').style.display="block";
}
	function step3_2() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";

		document.getElementById('step04').className = "step04 step04On02";
		document.getElementById('step04').style.display="block";
		document.getElementById('sel_step04_2').style.display="block";
}
	function step3_3() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";

		document.getElementById('step04').className = "step04 step04On03";
		document.getElementById('step04').style.display="block";
		document.getElementById('sel_step04_3').style.display="block";
}
	function step3_4() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";

		document.getElementById('step04').className = "step04 step04On04";
		document.getElementById('step04').style.display="block";
		document.getElementById('sel_step04_4').style.display="block";
}
	function step3_5() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";

		document.getElementById('step04').className = "step04 step04On05";
		document.getElementById('step04').style.display="block";
		document.getElementById('sel_step04_5').style.display="block";
}
	function step3_6() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";

		document.getElementById('step04').className = "step04 step04On06";
		document.getElementById('step04').style.display="block";
		document.getElementById('sel_step04_6').style.display="block";
}
	function step3_7() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";

		document.getElementById('step04').className = "step04 step04On07";
		document.getElementById('step04').style.display="block";
		document.getElementById('sel_step04_7').style.display="block";
}
	function step3_8() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";

		document.getElementById('step04').className = "step04 step04On08";
		document.getElementById('step04').style.display="block";
		document.getElementById('sel_step04_8').style.display="block";
}

	function step4_1() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn01";
		document.getElementById('finish').style.display="block";

		document.getElementById('finish01').style.display="block";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="none";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_2() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn04";
		document.getElementById('finish').style.display="block";

		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="block";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_3() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn01";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="block";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="none";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_4() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn04";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="block";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_5() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn01";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="block";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="none";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_6() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn04";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="block";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_7() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn03";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="block";
		document.getElementById('finish04').style.display="none";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_8() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn04";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="block";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_9() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn03";
		document.getElementById('finish').style.display="block";
		document.getElementById(' ').style.display="none";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="block";
		document.getElementById('finish04').style.display="none";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_10() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn02";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="block";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="none";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_11() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn03";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="block";
		document.getElementById('finish04').style.display="none";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_12() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn02";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="block";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="none";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_13() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn03";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="block";
		document.getElementById('finish04').style.display="none";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_14() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn02";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="block";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="none";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_15() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn04";
		document.getElementById('finish').style.display="block";
		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="block";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function step4_16() {
		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02 step02On01";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03 step03On01";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04 step04On01";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";

		document.getElementById('finish').className = "finish finishOn02";
		document.getElementById('finish').style.display="block";

		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="block";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="none";

		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();
}
	function result_go(xx,yy) {

		document.getElementById('step01').style.display="none";
		document.getElementById('step02').className = "step02";
		document.getElementById('step02').style.display="none";
		document.getElementById('step03').className = "step03";
		document.getElementById('step03').style.display="none";
		document.getElementById('sel_step03_1').style.display="none";
		document.getElementById('step04').className = "step04";
		document.getElementById('step04').style.display="none";
		document.getElementById('sel_step04_1').style.display="none";
		document.getElementById('finish').className = "finish";
		document.getElementById('finish').style.display="none";
		document.getElementById('finish01').style.display="none";
		document.getElementById('finish02').style.display="none";
		document.getElementById('finish03').style.display="none";
		document.getElementById('finish04').style.display="none";
		document.getElementById('selection').style.display="none";

		document.getElementById('evt_head').style.display="none";
		document.getElementById('evt_body').style.display="none";
		document.getElementById('show_result').style.display="block";
		document.frm.result.value= xx;
		document.frm.upmode.value= yy;
		document.frm.action = "doEventSubscript45066.asp";
		document.frm.submit();

}
</script>
</head>
<body>

			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt45067">

					<!-- 인트로 페이지 -->
					<div id="evt_head">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_head.png" alt="화난 직장인을 달래주세요~" style="width:100%;" /></p>
						<div class="goGame"  id="startgame">
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_img01.png" alt="" style="width:100%;" />
							<p class="strBtn"><a href="javascript:StartGame()"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_btn01.png" alt="" style="width:100%;" /></a></p>
						</div>
					</div>
					<!--// 인트로 페이지 -->

					<div id="evt_body">
		<form name="frm" method="POST" style="margin:0px;" target="evtFrmProc">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<input type="hidden" name="upmode" value="<%=mode%>">
		<input type="hidden" name="result" value="<%=result%>">
						<p id="selection" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_img02.png" alt="화난 직장인을 달래주세요~" style="width:100%;" /></p>
						<ul class="ladderGame">
							<li class="step01 step01On01" id="step01" style="display:none;">
								<div class="select">
									<a href="javascript:step1_1()"><p>땀냄새 폴폴~ 만원 지하철 타고 출근하기</p></a>
									<a href="javascript:step1_2()"><p>에어컨 콸콸~ 승용차 타고 출근하기</p></a>
								</div>
							</li>
							<li class="step02 step02On01" id="step02" style="display:none;">
								<div class="select" id="sel_step02_1" style="display:none;">
									<a href="javascript:step2_1()"><p>출근하자마자, 컴퓨터 부팅하기</p></a>
									<a href="javascript:step2_2()"><p>출근 후, 아이스커피 한잔의 여유!</p></a>
								</div>
								<div class="select" id="sel_step02_2" style="display:none;">
									<a href="javascript:step2_3()"><p>출근 후, 입냄새 김부장님과 대화하기</p></a>
									<a href="javascript:step2_4()"><p>출근 후, 미모의 김대리와 커피 마시기</p></a>
								</div>
							</li>
							<li class="step03 step03On01" id="step03" style="display:none;">
								<div class="select" id="sel_step03_1" style="display:none;">
									<a href="javascript:step3_1()"><p>쌓여있는 메일 확인하기</p></a>
									<a href="javascript:step3_2()"><p>동료들과 가벼운 채팅 즐기기</p></a>
								</div>
								<div class="select" id="sel_step03_2" style="display:none;">
									<a href="javascript:step3_3()"><p>김부장에게 한 소리 듣고 업무 시작하기</p></a>
									<a href="javascript:step3_4()"><p>컴퓨터 켜고, 가볍게 뉴스 보기</p></a>
								</div>
								<div class="select" id="sel_step03_3" style="display:none;">
									<a href="javascript:step3_5()"><p>코 막고 김과장님 맞장구 쳐주기</p></a>
									<a href="javascript:step3_6()"><p>무시하고 자리로 와 업무 시작하기</p></a>
								</div>
								<div class="select" id="sel_step03_4" style="display:none;">
									<a href="javascript:step3_7()"><p>월급날 D+1 텅 빈 통장과 마주하기</p></a>
									<a href="javascript:step3_8()"><p>월급일 D-1 설렘 안고 업무 시작하기</p></a>
								</div>
							</li>
							<li class="step04 step04On01" id="step04" style="display:none;">
								<div class="select" id="sel_step04_1" style="display:none;">
									<a href="javascript:step4_1()"><p>입냄새 김부장님과 마라톤 회의하기</p></a>
									<a href="javascript:step4_2()"><p>미모의 김대리와 점심 먹기</p></a>
								</div>
								<div class="select" id="sel_step04_2" style="display:none;">
									<a href="javascript:step4_3()"><p>퇴근 5분전, 급 야근확정(with 김부장)</p></a>
									<a href="javascript:step4_4()"><p>채팅하며 김부장 뒷담화 즐기기</p></a>
								</div>
								<div class="select" id="sel_step04_3" style="display:none;">
									<a href="javascript:step4_5()"><p>한여름 땡볕에 외부미팅하러 나가기</p></a>
									<a href="javascript:step4_6()"><p>눈치보다 절묘한 타이밍에 칼퇴하기!</p></a>
								</div>
								<div class="select" id="sel_step04_4" style="display:none;">
									<a href="javascript:step4_7()"><p>입냄새 김부장님, 점심 1대1 마크</p></a>
									<a href="javascript:step4_8()"><p>동료들하고 점심내기 사다리타기</p></a>
								</div>
								<div class="select" id="sel_step04_5" style="display:none;">
									<a href="javascript:step4_9()"><p>김부장 동반 저녁회식 참석하기</p></a>
									<a href="javascript:step4_10()"><p>칼퇴 후, 시원한 맥주 한잔 하기</p></a>
								</div>
								<div class="select" id="sel_step04_6" style="display:none;">
									<a href="javascript:step4_11()"><p>야근을 밥 먹듯이! 오늘도 야근 확정</p></a>
									<a href="javascript:step4_12()"><p>절대반지! 법카로 저녁 회식하기</p></a>
								</div>
								<div class="select" id="sel_step04_7" style="display:none;">
									<a href="javascript:step4_13()"><p>퇴근불명! 마라톤 회의 참석하기</p></a>
									<a href="javascript:step4_14()"><p>메신저로 못다한 이야기 나누기(with 김대리)</p></a>
								</div>
								<div class="select" id="sel_step04_8" style="display:none;">
									<a href="javascript:step4_15()"><p>회식 때, 미모의 김대리 옆에 앉기</p></a>
									<a href="javascript:step4_16()"><p>회식 빠지고 소개팅가기</p></a>
								</div>
							</li>
							<li class="finish finishOn01"  id="finish" style="display:none;">
								<!-- 클래스 finishOn01일 경우 --><p id="finish01" style="display:block;"><a href="javascript:result_go('1','result_update')" ><img src="http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_btn03.png" alt="다시 도전하기" style="width:100%;" /></a></p>
								<!-- 클래스 finishOn02일 경우 --><p id="finish02" style="display:block;"><a href="javascript:result_go('4','result_update')"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_btn04.png" alt="무료배송 쿠폰 받기" style="width:100%;" /></a></p>
								<!-- 클래스 finishOn03일 경우 --><p id="finish03" style="display:block;"><a href="javascript:result_go('2','result_update')"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_btn05.png" alt="할인 쿠폰 받기" style="width:100%;" /></a></p>
								<!-- 클래스 finishOn04일 경우 --><p id="finish04" style="display:block;"><a href="javascript:result_go('2','result_update')"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_btn05.png" alt="할인 쿠폰 받기" style="width:100%;" /></a></p>
							</li>
						</ul>
					</form>
					</div>

					<!-- 당첨쿠폰확인 -->
					<div id="show_result" style="display:none;">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_img02.png" alt="화난 직장인을 달래주세요~" style="width:100%;" /></p>
						<div class="evtWin" id="result_win"></div>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45067/45067_notice.png" alt="이벤트안내" style="width:100%;" /></p>
					</div>
					<!--// 당첨쿠폰확인 -->

				</div>
			</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
			<!-- //content area -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
</body>
</html>