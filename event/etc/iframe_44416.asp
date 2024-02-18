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
	eCode   =  44415

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
	.mEvt44416 {position:relative; width:100%;}
	.mEvt44416 * {padding:0; margin:0;}
	.mEvt44416 img {vertical-align:top;}
	.mEvt44416 .goGame {position:relative; text-align:center;}
	.mEvt44416 .goGame .strBtn {position:absolute; width:70%; left:50%; top:30%; margin-left:-35%;}
	.mEvt44416 .ladderGame {padding:0 25px;}
	.mEvt44416 .ladderGame li {position:relative; width:100%; margin-bottom:10px; background-size:100% auto; background-repeat:no-repeat; background-position:left top;}
	.mEvt44416 .ladderGame li .select {overflow:hidden; position:absolute; left:0; bottom:0; width:100%; height:40%;}
	.mEvt44416 .ladderGame li .select p {float:left; width:50%; height:100%; cursor:pointer; text-indent:-9999px;}
	.mEvt44416 .ladderGame li.step01On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step01_on.png'); }

	.mEvt44416 .ladderGame li.step02On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step02_on01.png');}
	.mEvt44416 .ladderGame li.step02On02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step02_on02.png');}

	.mEvt44416 .ladderGame li.step03On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step03_on01.png');}
	.mEvt44416 .ladderGame li.step03On02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step03_on02.png');}
	.mEvt44416 .ladderGame li.step03On03 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step03_on03.png');}
	.mEvt44416 .ladderGame li.step03On04 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step03_on04.png');}

	.mEvt44416 .ladderGame li.step04On01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step04_on01.png');}
	.mEvt44416 .ladderGame li.step04On02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step04_on02.png');}
	.mEvt44416 .ladderGame li.step04On03 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step04_on03.png');}
	.mEvt44416 .ladderGame li.step04On04 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step04_on04.png');}
	.mEvt44416 .ladderGame li.step04On05 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step04_on05.png');}
	.mEvt44416 .ladderGame li.step04On06 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step04_on06.png');}
	.mEvt44416 .ladderGame li.step04On07 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step04_on07.png');}
	.mEvt44416 .ladderGame li.step04On08 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_game_step04_on08.png');}

	.mEvt44416 .ladderGame li.finishOn01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_finish01.png');}
	.mEvt44416 .ladderGame li.finishOn02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_finish02.png');}
	.mEvt44416 .ladderGame li.finishOn03 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_finish03.png');}
	.mEvt44416 .ladderGame li.finishOn04 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_finish04.png');}
	.mEvt44416 .ladderGame li.finish {position:relative; text-align:center;}
	.mEvt44416 .ladderGame li.finish p {position:absolute; left:50%; bottom:0; width:76%; margin-left:-38%;}

	.mEvt44416 .evtWin {position:relative; text-align:center;}
	.mEvt44416 .evtWin .okBtn {position:absolute; width:40%; left:50%; bottom:10%; margin-left:-20%;}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript">
$(function () {
	$(".mEvt44416 .ladderGame li").append('<img src="http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_blank.png" alt="" style="width:100%;" />');
});

	function StartGame() {

		<% if datediff("d",date(),"2013-08-19")>=0 then %>
			<% If IsUserLoginOK Then %>
				<% if cnt >= 2222 then %>
			alert('하루에 2번 응모 가능합니다.\n\n내일 다시 응모해주세요.');
				<% else %>

				document.getElementById('startgame').style.display="none";
				document.getElementById('selection').style.display="block";
				document.getElementById('step01').style.display="block";


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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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

		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
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
		document.frm.action = "doEventSubscript44416.asp?evt_code=<%=eCode%>";
		document.frm.submit();

}
</script>
</head>
<body>
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt44416">

					<!-- 인트로 페이지 -->
					<div id="evt_head">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_head.png" alt="우는 아이를 달래주세요~" style="width:100%;" /></p>
						<div class="goGame"  id="startgame">
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_img01.png" alt="" style="width:100%;" />
							<p class="strBtn"><a href="javascript:StartGame()"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn01.png" alt="" style="width:100%;" /></a></p>
						</div>
					</div>
					<!--// 인트로 페이지 -->

					<!-- 울음 그치기 게임 -->
					<div id="evt_body">
		<form name="frm" method="POST" style="margin:0px;" target="evtFrmProc">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<input type="hidden" name="upmode" value="<%=mode%>">
		<input type="hidden" name="result" value="<%=result%>">
						<p id="selection" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_img02.png" alt="우는 아이를 달래주세요~" style="width:100%;" /></p>
						<ul class="ladderGame">
							<li class="step01 step01On01" id="step01" style="display:none;">
								<div class="select">
									<a href="javascript:step1_1()"><p>말로 토닥여주기</p></a>
									<a href="javascript:step1_2()"><p>과자주며 달래기</p></a>
								</div>
							</li>
							<li class="step02 step02On01" id="step02" style="display:none;">
								<div class="select" id="sel_step02_1" style="display:none;">
									<a href="javascript:step2_1()"><p>함께 운동하러 가기</p></a>
									<a href="javascript:step2_2()"><p>텐텐놀이터 놀러가기</p></a>
								</div>
								<div class="select" id="sel_step02_2" style="display:none;">
									<a href="javascript:step2_3()"><p>과자 함께 나눠먹기</p></a>
									<a href="javascript:step2_4()"><p>이왕 사주는 거 아이스크림까지 사주기</p></a>
								</div>
							</li>
							<li class="step03 step03On01" id="step03" style="display:none;">
								<div class="select" id="sel_step03_1" style="display:none;">
									<a href="javascript:step3_1()"><p>3kg 아령 선물하기</p></a>
									<a href="javascript:step3_2()"><p>힐링요가 배우기</p></a>
								</div>
								<div class="select" id="sel_step03_2" style="display:none;">
									<a href="javascript:step3_3()"><p>같이 3:3 피구하기</p></a>
									<a href="javascript:step3_4()"><p>친구들하고 소꿉놀이하기</p></a>
								</div>
								<div class="select" id="sel_step03_3" style="display:none;">
									<a href="javascript:step3_5()"><p>같이 공원 산책하기</p></a>
									<a href="javascript:step3_6()"><p>유치원 친구들 만나러 가기</p></a>
								</div>
								<div class="select" id="sel_step03_4" style="display:none;">
									<a href="javascript:step3_7()"><p>동물원 놀러가기</p></a>
									<a href="javascript:step3_8()"><p>시원한 워터파크 놀러가기</p></a>
								</div>
							</li>
							<li class="step04 step04On01" id="step04" style="display:none;">
								<div class="select" id="sel_step04_1" style="display:none;">
									<a href="javascript:step4_1()"><p>톡 쏘는 탄산음료 사주기</p></a>
									<a href="javascript:step4_2()"><p>시원한 아이스크림 사주기</p></a>
								</div>
								<div class="select" id="sel_step04_2" style="display:none;">
									<a href="javascript:step4_3()"><p>얼음 둥둥 냉수 마시기</p></a>
									<a href="javascript:step4_4()"><p>달콤한 팥빙수 먹으러 가기</p></a>
								</div>
								<div class="select" id="sel_step04_3" style="display:none;">
									<a href="javascript:step4_5()"><p>마지막까지 승부내기</p></a>
									<a href="javascript:step4_6()"><p>그만하고 시원한 수박 먹으러 가기</p></a>
								</div>
								<div class="select" id="sel_step04_4" style="display:none;">
									<a href="javascript:step4_7()"><p>진흙으로 음식 만들기</p></a>
									<a href="javascript:step4_8()"><p>진짜 맛있는 음식 먹으러 가기</p></a>
								</div>
								<div class="select" id="sel_step04_5" style="display:none;">
									<a href="javascript:step4_9()"><p>애완동물 산책시키기</p></a>
									<a href="javascript:step4_10()"><p>시원한 아이스크림 사주기</p></a>
								</div>
								<div class="select" id="sel_step04_6" style="display:none;">
									<a href="javascript:step4_11()"><p>개나리반 여자아이들 부르기</p></a>
									<a href="javascript:step4_12()"><p>코끼리반 남자아이들 부르기</p></a>
								</div>
								<div class="select" id="sel_step04_7" style="display:none;">
									<a href="javascript:step4_13()"><p>악어 양치질 도와주러 가기</p></a>
									<a href="javascript:step4_14()"><p>동물이랑 기념사진 찍기</p></a>
								</div>
								<div class="select" id="sel_step04_8" style="display:none;">
									<a href="javascript:step4_15()"><p>시원하기 미끄럼틀 타기</p></a>
									<a href="javascript:step4_16()"><p>몸짱 오빠랑 수영 즐기기</p></a>
								</div>
							</li>
							<li class="finish finishOn01"  id="finish" style="display:none;">
								<!-- 클래스 finishOn01일 경우 --><p id="finish01" style="display:block;"><a href="javascript:result_go('1','result_update')" ><img src="http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn03.png" alt="다시 도전하기" style="width:100%;" /></a></p>
								<!-- 클래스 finishOn02일 경우 --><p id="finish02" style="display:block;"><a href="javascript:result_go('4','result_update')"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn04.png" alt="무료배송 쿠폰 받기" style="width:100%;" /></a></p>
								<!-- 클래스 finishOn03일 경우 --><p id="finish03" style="display:block;"><a href="javascript:result_go('2','result_update')"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn05.png" alt="할인 쿠폰 받기" style="width:100%;" /></a></p>
								<!-- 클래스 finishOn04일 경우 --><p id="finish04" style="display:block;"><a href="javascript:result_go('2','result_update')"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_btn05.png" alt="할인 쿠폰 받기" style="width:100%;" /></a></p>
							</li>
						</ul>
					</form>
					</div>
					<!--// 울음 그치기 게임 -->

					<!-- 당첨쿠폰확인 -->
					<div id="show_result" style="display:none;">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_img02.png" alt="우는 아이를 달래주세요~" style="width:100%;" /></p>
						<div class="evtWin" id="result_win"></div>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44416/44416_notice.png" alt="이벤트안내" style="width:100%;" /></p>
					</div>
					<!--// 당첨쿠폰확인 -->

				</div>
			</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
			<!-- //content area -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
</body>
</html>