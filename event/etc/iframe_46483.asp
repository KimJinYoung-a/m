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
		eCode 		= "20994"
	Else
		eCode 		= "46482"
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
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 뿔난 애인을 달래주세요~</title>
	<style type="text/css">
		.mEvt46483 {position:relative; width:100%;}
		.mEvt46483 img {vertical-align:top;}
		.mEvt46483 .goGame {position:relative; text-align:center;}
		.mEvt46483 .goGame .strBtn {position:absolute; width:70%; left:50%; top:30%; margin-left:-35%;}
		.mEvt46483 .ladderGame li {position:relative; width:100%; margin-bottom:10px; background-size:100% auto; background-repeat:no-repeat; background-position:left top;}
		.mEvt46483 .ladderGame li .situation {overflow:hidden; position:absolute; left:5%; bottom:0; width:90%; height:40%;}
		.mEvt46483 .ladderGame li .situation p {float:left; width:50%; height:100%; cursor:pointer; text-indent:-9999px;}
		.mEvt46483 .ladderGame li.step01On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step01_on.png'); }

		.mEvt46483 .ladderGame li.step02On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step02_on01.png');}
		.mEvt46483 .ladderGame li.step02On02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step02_on02.png');}

		.mEvt46483 .ladderGame li.step03On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step03_on01.png');}
		.mEvt46483 .ladderGame li.step03On02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step03_on02.png');}
		.mEvt46483 .ladderGame li.step03On03 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step03_on03.png');}
		.mEvt46483 .ladderGame li.step03On04 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step03_on04.png');}

		.mEvt46483 .ladderGame li.step04On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step04_on01.png');}
		.mEvt46483 .ladderGame li.step04On02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step04_on02.png');}
		.mEvt46483 .ladderGame li.step04On03 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step04_on03.png');}
		.mEvt46483 .ladderGame li.step04On04 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step04_on04.png');}
		.mEvt46483 .ladderGame li.step04On05 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step04_on05.png');}
		.mEvt46483 .ladderGame li.step04On06 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step04_on06.png');}
		.mEvt46483 .ladderGame li.step04On07 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step04_on07.png');}
		.mEvt46483 .ladderGame li.step04On08 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_game_step04_on08.png');}

		.mEvt46483 .ladderGame li.finishOn01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_finish01.png');}
		.mEvt46483 .ladderGame li.finishOn02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_finish02.png');}
		.mEvt46483 .ladderGame li.finishOn03 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_finish03.png');}
		.mEvt46483 .ladderGame li.finishOn04 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_finish04.png');}
		.mEvt46483 .ladderGame li.finish {position:relative; text-align:center;}
		.mEvt46483 .ladderGame li.finish p {position:absolute; left:50%; bottom:0; width:76%; margin-left:-38%;}

		.mEvt46483 .evtWin {position:relative; text-align:center;}
		.mEvt46483 .evtWin .okBtn {position:absolute; width:40%; left:50%; bottom:10%; margin-left:-20%;}
	</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript">
$(function () {
	$(".mEvt46483 .ladderGame li").append('<img src="http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_blank.png" alt="" style="width:100%;" />');
});

	function StartGame() {

		<% If Now() < #11/22/2013 00:00:00# Then %>
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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

		document.frm.action = "doEventSubscript46483.asp";
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
		document.frm.action = "doEventSubscript46483.asp";
		document.frm.submit();

}
</script>
</head>
<body>
<!-- content area -->
<div class="content" id="contentArea">
	<div class="mEvt46483">
		<!-- 인트로 페이지 -->
		<div id="evt_head">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_head.png" alt="뿔난 애인을 달래주세요~" style="width:100%;" /></p>
			<div class="goGame"  id="startgame">
				<img src="http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_img01.png" alt="" style="width:100%;" />
				<p class="strBtn"><a href="javascript:StartGame()"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_btn01.png" alt="" style="width:100%;" /></a></p>
			</div>
		</div>
		<!--// 인트로 페이지 -->
		<form name="frm" method="POST" style="margin:0px;" target="evtFrmProc">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<input type="hidden" name="upmode" value="<%=mode%>">
		<input type="hidden" name="result" value="<%=result%>">
		</form>
		<div id="evt_body">
			<p id="selection" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_img02.png" alt="뿔난 애인을 달래주세요~" style="width:100%;" /></p>
			<ul class="ladderGame">
				<li class="step01 step01On01" id="step01" style="display:none;">
					<div class="situation">
						<a href="javascript:step1_1()"><p>상황파악~! 카톡으로 안부묻기</p></a>
						<a href="javascript:step1_2()"><p>롸잇나우! 전화로 안부묻기</p></a>
					</div>
				</li>
				<li class="step02 step02On01" id="step02" style="display:none;">
					<div class="situation" id="sel_step02_1" style="display:none;">
						<a href="javascript:step2_1()"><p>카톡답장 느리다면 재촉하기!</p></a>
						<a href="javascript:step2_2()"><p>애교 이모티콘 가득 담아 기분 풀어주기</p></a>
					</div>
					<div class="situation" id="sel_step02_2" style="display:none;">
						<a href="javascript:step2_3()"><p>일단 먹자! 걷고 걸어 홍대 맛집 탐방하기</p></a>
						<a href="javascript:step2_4()"><p>스트레스 해소! SF블록버스터 영화 보러가기</p></a>
					</div>
				</li>
				<li class="step03 step03On01" id="step03" style="display:none;">
					<div class="situation" id="sel_step03_1" style="display:none;">
						<a href="javascript:step3_1()"><p>오늘 내가 더 힘든 날이라고 투덜대기</p></a>
						<a href="javascript:step3_2()"><p>맛있는거 쏘겠다며 약속 시간 잡기</p></a>
					</div>
					<div class="situation" id="sel_step03_2" style="display:none;">
						<a href="javascript:step3_3()"><p>대기업에 취업한 친구 남친 이야기 하기</p></a>
						<a href="javascript:step3_4()"><p>서프라이즈~! 저녁 데이트 하러가기</p></a>
					</div>
					<div class="situation" id="sel_step03_3" style="display:none;">
						<a href="javascript:step3_5()"><p>메뉴는 내가 좋아하는 떡볶이 먹기</p></a>
						<a href="javascript:step3_6()"><p>오늘 만큼은 메뉴 선택권 넘기기</p></a>
					</div>
					<div class="situation" id="sel_step03_4" style="display:none;">
						<a href="javascript:step3_7()"><p>영화에 완전 몰입! 영화만 보기!</p></a>
						<a href="javascript:step3_8()"><p>팝콘과 콜라까지 팍팍 쏘기!</p></a>
					</div>
				</li>
				<li class="step04 step04On01" id="step04" style="display:none;">
					<div class="situation" id="sel_step04_1" style="display:none;">
						<a href="javascript:step4_1()"><p>갖고 싶은 신상품 URL 보내기</p></a>
						<a href="javascript:step4_2()"><p>자기야 힘내! 서프라이즈 선물 사주기</p></a>
					</div>
					<div class="situation" id="sel_step04_2" style="display:none;">
						<a href="javascript:step4_3()"><p>만나서 잘생긴 친구 애인 이야기 하기</p></a>
						<a href="javascript:step4_4()"><p>원기회복! 삼계탕으로 몸보신 시키기</p></a>
					</div>
					<div class="situation" id="sel_step04_3" style="display:none;">
						<a href="javascript:step4_5()"><p>이번 달 토익 성적 물어보기</p></a>
						<a href="javascript:step4_6()"><p>너느 체력은 좋다며 칭찬하기</p></a>
					</div>
					<div class="situation" id="sel_step04_4" style="display:none;">
						<a href="javascript:step4_7()"><p>에잇! 기분이다! 심야영화까지 쏘기!</p></a>
						<a href="javascript:step4_8()"><p>식사값은 애인에게 양보하기</p></a>
					</div>
					<div class="situation" id="sel_step04_5" style="display:none;">
						<a href="javascript:step4_9()"><p>소화도 시킬 겸 쇼핑하러 가기</p></a>
						<a href="javascript:step4_10()"><p>기분 풀라며 시원한 맥주 마시러 가기</p></a>
					</div>
					<div class="situation" id="sel_step04_6" style="display:none;">
						<a href="javascript:step4_11()"><p>커피숍에서 달달한 케익, 커피마시기</p></a>
						<a href="javascript:step4_12()"><p>피로회복! 커플마사지 받으러 가기</p></a>
					</div>
					<div class="situation" id="sel_step04_7" style="display:none;">
						<a href="javascript:step4_13()"><p>영화만 보고 9시 칼귀가 하기</p></a>
						<a href="javascript:step4_14()"><p>커피숍에서 어깨 주물러주기</p></a>
					</div>
					<div class="situation" id="sel_step04_8" style="display:none;">
						<a href="javascript:step4_15()"><p>집에 가기 전에 백허그 해주기</p></a>
						<a href="javascript:step4_16()"><p>기분 풀라며 애정표현 만땅 해주기</p></a>
					</div>
				</li>
				<li class="finish finishOn01"  id="finish" style="display:none;">
					<!-- 클래스 finishOn01일 경우 --><p id="finish01" style="display:block;"><a href="javascript:result_go('1','result_update')" ><img src="http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_btn03.png" alt="다시 도전하기" style="width:100%;" /></a></p>
					<!-- 클래스 finishOn02일 경우 --><p id="finish02" style="display:block;"><a href="javascript:result_go('2','result_update')"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_btn05.png" alt="할인 쿠폰 받기" style="width:100%;" /></a></p>
					<!-- 클래스 finishOn03일 경우 --><p id="finish03" style="display:block;"><a href="javascript:result_go('3','result_update')"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_btn04.png" alt="할인 쿠폰 받기" style="width:100%;" /></a></p>
					<!-- 클래스 finishOn04일 경우 --><p id="finish04" style="display:block;"><a href="javascript:result_go('4','result_update')"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_btn04.png" alt="무료배송 쿠폰 받기" style="width:100%;" /></a></p>
				</li>
			</ul>
		</div>
		<!-- 당첨쿠폰확인 -->
		<div id="show_result" style="display:none;">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_img02.png" alt="뿔난 애인을 달래주세요~" style="width:100%;" /></p>
			<div class="evtWin" id="result_win"></div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46483/46483_notice.png" alt="이벤트안내" style="width:100%;" /></p>
		</div>
		<!--// 당첨쿠폰확인 -->
		<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->