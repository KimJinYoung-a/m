<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=9">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0">
<link rel="stylesheet" type="text/css" href="/lib/css/default.css">
<link rel="stylesheet" type="text/css" href="/lib/css/common.css">
<link rel="stylesheet" type="text/css" href="/lib/css/content.css">
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/lib/js/common.js?dm=<%=date%>"></script>
<%
dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, vNowDate, vNowHour, vNowTime, vCount, vTime(4), q, tmp
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "20954"
	Else
		eCode 		= "45262"
	End If

vNowDate = date
vNowHour = hour(now)

If 0 <= vNowHour AND vNowHour <= 5 Then
	vNowTime = "1"
	q = " and convert(varchar(13),regdate,120) between  '" & date & " 00' and '" & date & " 05' "
ElseIf 6 <= vNowHour AND vNowHour <= 11 Then
	vNowTime = "2"
	q = " and convert(varchar(13),regdate,120) between  '" & date & " 06' and '" & date & " 11' "
ElseIf 12 <= vNowHour AND vNowHour <= 17 Then
	vNowTime = "3"
	q = " and convert(varchar(13),regdate,120) between  '" & date & " 12' and '" & date & " 17' "
ElseIf 18 <= vNowHour AND vNowHour <= 23 Then
	vNowTime = "4"
	q = " and convert(varchar(13),regdate,120) between  '" & date & " 18' and '" & date & " 23' "
End IF

If IsUserLoginOK Then
	'### 4개 타임을 담아둠. 4개의 타임이 다 입력될때 db_event.dbo.tbl_event_subscript 1번 입력.
	sqlstr = "Select nowtime, value From db_temp.dbo.tbl_event_45262 WHERE userid='" & GetLoginUserID() & "' and isClear = 'x' "
	rsget.Open sqlStr,dbget,1
	vCount = rsget.RecordCount

	i = 1
	Do Until rsget.Eof
		vTime(rsget("nowtime")) = rsget("nowtime")
		If rsget("nowtime") = "3" Then
			tmp = Replace(rsget("value"),"7-","")
		End If
	i = i + 1
	rsget.MoveNext
	Loop
	rsget.Close
End If

If vCount = 0 Then
	sqlstr = "Select top 1 nowtime From db_temp.dbo.tbl_event_45262 WHERE userid='" & GetLoginUserID() & "' and isClear = 'o' " & q & " order by idx desc "
	rsget.Open sqlStr,dbget,1
	If not rsget.Eof Then
		vTime(vNowTime) = rsget("nowtime")
	End IF
	rsget.Close
End IF

If GetLoginUserID() = "okkang77" Then
	response.write vTime(vNowTime) & "!"
End If
%>
<style type="text/css">
.mEvt45263 {}
.mEvt45263 img {vertical-align:top; display:inline;}
.mEvt45263 .timeWrap {position:relative;}
.mEvt45263 .timeWrap .point {position:absolute; left:50%; top:50%; width:10%; height:10%; margin:-5% 0 0 -5%; z-index:500;}
.mEvt45263 .timetable { width:100%; position:absolute; left:0; top:0; width:100%; height:100%;}
.mEvt45263 .timetable ol {overflow:hidden; position:relative;  width:100%; height:100%;}
.mEvt45263 .timetable ol li {position:absolute; width:50%; height:50%;}
.mEvt45263 .timetable ol li a {display:block; width:100%; height:100%;}
.mEvt45263 .timetable ol li.t01 {left:0; top:0;}
.mEvt45263 .timetable ol li.t02 {right:0; top:0;}
.mEvt45263 .timetable ol li.t03 {right:0; top:50%;}
.mEvt45263 .timetable ol li.t04 {left:0; top:50%;}
.mEvt45263 .myDinner .ladder {position:relative; width:100%;}
.mEvt45263 .myDinner .ladder ul {position:absolute; left:10%; top:2%; width:80%; height:10%; overflow:hidden; }
.mEvt45263 .myDinner .ladder li {float:left; width:25%; height:100%;}
.mEvt45263 .myDinner .ladder li a {display:block; height:100%; margin:0 10%; text-indent:-9999px; background:url('http://webimage.10x10.co.kr/eventIMG/2013/45263/45263_blank.png') left top no-repeat; background-size:100% auto;}
</style>
<script type="text/javascript">
function goTimeCheck(v){
<% If Now() < #09/16/2013 00:00:00# Then %>
	<% If IsUserLoginOK Then %>
		<% If vTime(vNowTime) = "" Then		'### 참여 안했을때. %>
			<% If vNowTime = "1" OR vNowTime = "3" Then %>
				frm.selectvalue.value = v;
				frm.action = "doEventSubscript45262.asp";
				frm.submit();
			<% Else		'### 참여 했을때. %>
				alert('지금은 텐바이텐 PC버전에서만 미션에 도전할 수 있어요!\n텐바이텐  PC버전에서 만나요!');
				return;
			<% End If %>
		<% else %>
			alert('이미 미션을 완료하였습니다.\n다음 미션 타임도 잊지마세요!');
			return;
		<% end if %>
	<% Else %>
    jsChklogin('<%=IsUserLoginOK%>');
    return false;
	<% End If %>
<% else %>
		alert('이벤트가 종료되었습니다.');
		return;
<% end if %>
}

function moveOffset()
{ 
    var pos = $("#ladderRide").offset();
    top.$('html, body').animate({scrollTop : pos.top}, 1000); 
      
    //애니메이션을 주지않고 바로 이동을 시킬경우는 scrollTop 함수만 실행 
    //$('html, body').scrollTop(pos.top - extra_space);              
}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt45263">
	<form name="frm" method="POST" style="margin:0px;">
	<input type="hidden" name="selectvalue" value="">
	<input type="hidden" name="nowtime" value="<%=vNowTime%>">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/45263_head.png" alt="텐바이텐과 함께라면 24시간이 모자라" style="width:100%;" /></div>
		<div class="timeWrap">
			<p class="point"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/45263_img01.png" alt="" style="width:100%;" /></p>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_bg_time.png" alt="" style="width:100%;" /></div>
			<div class="timetable">
				<ol>
					<li class="t01">
						<span id="time4"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_time01_0<%=CHKIIF(vTime(4)<>"","2","1")%>.png" alt="본방사수하기" style="width:100%;" /></span>
					</li>
					<li class="t02">
						<% If vNowTime = "1" AND vTime(vNowTime) = "" Then %><a href="javascript:goTimeCheck('');"><% End If %>
						<span id="time1"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_time02_0<%=CHKIIF(vTime(1)<>"","2","1")%>.png" alt="꿈나라 여행하기" style="width:100%;" /></span>
						<% If vNowTime = "1" AND vTime(vNowTime) = "" Then %></a><% End If %>
					</li>
					<li class="t03">
						<span id="time2"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_time03_0<%=CHKIIF(vTime(2)<>"","2","1")%>.png" alt="졸음 참아보기" style="width:100%;" /></span>
					</li>
					<li class="t04">
						<% If vNowTime = "3" AND vTime(vNowTime) = "" Then %><a href="javascript:moveOffset();"><% End If %>
						<span id="time3"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_time04_0<%=CHKIIF(vTime(3)<>"","2","1")%>.png" alt="저녁메뉴 선택하기" style="width:100%;" /></span>
						<% If vNowTime = "3" AND vTime(vNowTime) = "" Then %></a><% End If %>
					</li>
				</ol>
			</div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/45263_homepage.png" alt="텐바이텐 온라인 홈페이지 (WWW.10x10.co.kr)/텐바이텐 모바일 홈페이지 (m.10x10.co.kr)" style="width:100%;" /></div>
		<% If vNowTime = "1" Then '꿈나라 여행하기 %>
			<div class="mission">
			<% If vTime(vNowTime) <> "" Then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_mission01_txt_clear.png" alt="이불은 잘 덮었죠? 잘자요~" style="width:100%;" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_stand_clear.png" alt="스탠드" style="width:100%;" /></p>
			<% Else %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_mission01_txt.png" alt="이제는 우리가 잠자리에 들 시간! 스탠드를 클릭해서 불을 꺼주세요" style="width:100%;" /></p>
				<p><a href="javascript:goTimeCheck('');"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_stand.png" alt="스탠드" style="width:100%;" /></a></p>
			<% End If %>
			</div>
		<% ElseIf vNowTime = "3" Then %>
			<div class="mission">
			<div class="myDinner">
			<% If vTime(vNowTime) <> "" Then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_mission02_txt.png" alt="사다리 중 한개를 클릭해서 저녁메뉴를 골라주세요!" style="width:100%;" /></p>
				<div class="ladder">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_ladder_clear_<%=tmp%>.png" alt="당첨" style="width:100%;" /></p>
				</div>
			<% Else %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_mission02_txt.png" alt="사다리 중 한개를 클릭해서 저녁메뉴를 골라주세요!" style="width:100%;" /></p>
				<div class="ladder" id="ladderRide">
					<ul>
						<li><a href="javascript:goTimeCheck('1');">A</a></li>
						<li><a href="javascript:goTimeCheck('2');">B</a></li>
						<li><a href="javascript:goTimeCheck('3');">C</a></li>
						<li><a href="javascript:goTimeCheck('4');">D</a></li>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/new/45263_ladder.png" alt="사다리" style="width:100%;" /></p>
				</div>
			<% End If %>
			</div>
			</div>
		<% Else %>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/45263_mission03.png" alt="지금은 텐바이텐 PC에서만 미션에 도전할 수 있어요!" style="width:100%;" /></div>
		<% End If %>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45263/45263_notice.png" alt="이벤트 유의사항" style="width:100%;" /></div>
	</form>
	</div>
</div>
<!--[time4]폭탄주말아보기<br><% If vNowTime = "4" Then %><font color="red" size="3">Now Show Time</font><br><% End If %>//-->
<!--[time1]꿈나라여행하기<br><% If vNowTime = "1" Then %><font color="red" size="3">Now Show Time</font><br><% End If %>//-->
<!--[time2]졸음참아보기<br><% If vNowTime = "2" Then %><font color="red" size="3">Now Show Time</font><br><% End If %>//-->
<!--[time3]저녁메뉴정해보기<br><% If vNowTime = "3" Then %><font color="red" size="3">Now Show Time</font><br><% End If %>//-->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->