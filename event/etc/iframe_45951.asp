<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim ecode
	Dim sqlStr , cnt
		IF application("Svr_Info")="Dev" THEN
			eCode 		="20973"
		Else
			eCode 		="45884"
		End If

	If IsUserLoginOK Then
		'중복 응모 확인
		sqlStr="Select count(sub_idx) " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" WHERE evt_code='" & eCode & "'" &_
				" and userid='" & GetLoginUserID() & "' and convert(varchar(10),regdate,120) = '" &  Left(now(),10) & "'"
		rsget.Open sqlStr,dbget,1
		cnt=rsget(0)
		rsget.Close
	End If

%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 12th ANNIVERSARY 가을 운동회 그들만의 리그 홀 or 짝!</title>
	<style type="text/css">
	.mEvt45951 img {vertical-align:top;}
	.mEvt45951 .oddEven .game {position:relative;}
	.mEvt45951 .oddEven .game p {text-indent:-999em;}
	.mEvt45951 .oddEven .game .start {background:url(http://webimage.10x10.co.kr/eventIMG/2013/45951/bg_game_start.gif) left top no-repeat; background-size:100% 100%;}
	.mEvt45951 .oddEven .game .end {background:url(http://webimage.10x10.co.kr/eventIMG/2013/45951/bg_game_end.gif) left top no-repeat; background-size:100% 100%;}
	.mEvt45951 .oddEven .game .odd {background:url(http://webimage.10x10.co.kr/eventIMG/2013/45951/bg_game_odd.gif) left top no-repeat; background-size:100% 100%;}
	.mEvt45951 .oddEven .game .even {background:url(http://webimage.10x10.co.kr/eventIMG/2013/45951/bg_game_even.gif) left top no-repeat; background-size:100% 100%;}
	.mEvt45951 .oddEven .game button {width:21%; height:44%; margin:0; padding:0; border:0; background:none; text-indent:-999em;}
	.mEvt45951 .oddEven .game .btnOdd {position:absolute; left:4.5%; top:26%; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45951/btn_odd.png) left top no-repeat; background-size:100% 100%;}
	.mEvt45951 .oddEven .game .btnEven {position:absolute; right:4.5%; top:26%; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45951/btn_even.png) left top no-repeat; background-size:100% 100%;}
	.mEvt45951 .notice {position:relative; padding:20px 10px; background:#f0f0f0; text-align:left;}
	.mEvt45951 .notice ul {padding-top:5px;}
	.mEvt45951 .notice ul li {padding-left:8px; font-size:11px; line-height:16px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blt_arrow.png) left 6px no-repeat; color:#7d7d7d; background-size:4px auto;}
</style>
<script>
	function checkform(val) {
	<% if datediff("d",date(),"2013-10-21")>=0 then %>
		<% If IsUserLoginOK Then %>
		var frm = document.frm;
		var chk = val;
			if(chk == "") {
				alert("홀 또는 짝을 선택해주세요.");
			} else {
				<% if cnt >= 1 then %>
				alert('하루에 한 번 응모 가능합니다.\n\n내일 다시 응모해주세요.');
				return;
				<% else %>
					holjjak(chk);
				<% end if %>
			}
		<% Else %>
			alert('로그인 후에 응모하실 수 있습니다.');
			return;
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}
</script>
<script>
function holjjak(v){ // 응모처리
	var frm = document.frm;
	$.ajax({
		url: "doEventSubscript45951.asp?evt_code=<%=eCode%>&holjjak="+v, 
		cache: false,
		success: function(message) 
		{			            	
			$("#tempdiv").empty().append(message);
		
			var result = $("div#rtresult").attr("value");
			var result2 = $("div#rtresult2").attr("value");

			if (result == "1"){
				$("#result").attr("class","odd");
				$("#result").html("<img src='http://webimage.10x10.co.kr/eventIMG/2013/45951/bg_blank.png' alt='' style='width:100%;' />짜잔! 홀");
			}else if (result == "2"){
				$("#result").attr("class","even");
				$("#result").html("<img src='http://webimage.10x10.co.kr/eventIMG/2013/45951/bg_blank.png' alt='' style='width:100%;' />짜잔! 짝");
			}else{
				$("#result").attr("class","end");
				$("#result").html("<img src='http://webimage.10x10.co.kr/eventIMG/2013/45951/bg_blank.png' alt='' style='width:100%;' />내일 또 봐요!");
			}

			if (result2 == "1"){
				$("#result2").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/45951/txt_result_04.gif");
				$("#result2").attr("alt","와우! 축하합니다. 100 마일리지를 선물로 드립니다.");
			}else if (result2 == "3"){
				$("#result2").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/45951/txt_result_03.gif");
				$("#result2").attr("alt","와우! 축하합니다. 300 마일리지를 선물로 드립니다.");
			}else if (result2 == "5"){
				$("#result2").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/45951/txt_result_05.gif");
				$("#result2").attr("alt","하루에 한번씩만 가능합니다. 내일 도전하세요!");
			}else{
				$("#result2").attr("src","http://webimage.10x10.co.kr/eventIMG/2013/45951/txt_result_02.gif");
				$("#result2").attr("alt","에이~ 틀렸어요. 안타깝지만 내일 다시 도전하세요.");				
			}
		}
	});			        
}
</script>
</head>
<body>
<div class="mEvt45951">
	<form name="frm" method="POST" style="margin:0px;">
	<div class="oddEven">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45951/head.jpg" alt="너희들이 땀을 흘릴 때 난 눈물을 흘렸다! 그들만의 리그 홀, 짝" style="width:100%;" /></p>
		<div class="game">
			<div class="msg">
				<p class="start" id="result"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45951/bg_blank.png" alt="" style="width:100%;" />컵 속 동전의 홀, 짝을 맞추면 선물이 팡팡! 홀일지 짝일지 얼른 얼른 클릭!</p>
				<button type="button" class="btnOdd" onclick="checkform('1');">홀</button>
				<button type="button" class="btnEven" onclick="checkform('2');">짝</button>
			</div>
		</div>
		<div class="result">
			<p class="msg">
				<img src="http://webimage.10x10.co.kr/eventIMG/2013/45951/txt_result_01.gif" alt="컵속의 동전갯수는 홀수일까요? 짝수일까요? 홀,짝 중 하나를 골라보세요!" style="width:100%;" id="result2"/>
			</p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45951/txt_caution.gif" alt="※ 주의 : 엄청난 중독성으로 인해 하루에 한번씩만 참여할 수 있습니다." style="width:100%;" /></p>
		</div>
	</div>
	</form>
	<div class="notice">
		<div><strong><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_tit_notice.png" alt="이벤트 유의사항" style="width:67px;" /></strong></div>
		<ul>
			<li>본 이벤트는 각 ID당 하루 한 번만 참여할 수 있습니다.</li>
			<li>당첨 되신 분에게는 300마일리지 or 100마일리지를 선물로 드립니다.</li>
		</ul>
	</div>
	<!-- 12.10.08 -->
	<div><a href="/event/eventmain.asp?eventid=
45950" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45951/btn_go.gif" style="width:100%;" alt="홀~ 짝! 게임으로 몸을 풀었다면 매일 출석체크 하면서 1m씩 달려보세요. 달리기 하러 뛰어가기" /></a></div>
	<!-- //12.10.08 -->
</div>
<div id="tempdiv"></div>
</body>
</html>