<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dbget.close()
response.end
%>
<-- #include virtual="/event/12th/02/function.asp" -->
<%
	Dim vEventID
	IF application("Svr_Info") = "Dev" THEN
		vEventID = "20971"
	Else
		vEventID = "45882"
	End If
	Dim clsDayCheck, arrList, vTotalCount, vLastDate, vGamblingBtn, vClick
	vTotalCount = 0
	vClick = "<p class=""click""><span><img src=""http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank_click.png"" alt=""click"" style=""width:100%;"" /></span></p>"
	SET clsDayCheck = New CDayCheck
	If IsUserLoginOK() Then
	arrList = clsDayCheck.fnGetDayCheckList
		IF isArray(arrList) THEN
		vTotalCount = UBound(arrList,2)+1
		vLastDate = arrList(3,UBound(arrList,2))
		End If
	End If
	SET clsDayCheck = Nothing

	'#############################################################################################
	'	sub_opt1 = 당첨여부(o:당첨, x:꽝).	sub_opt2 = 몇번째날].	sub_opt3 = 선물.	regdate
	'	배열 0 , 1, 2, 3
	'#############################################################################################
%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 뛰어! 뛰어! 달리기!</title>
	<style type="text/css">
	.mEvt45950 img {vertical-align:top;}
	.mEvt45950 .track {position:relative;}
	.mEvt45950 .track li {position:absolute; width:17%;}
	.mEvt45950 .track li div {position:relative; width:100%; background-repeat:no-repeat; background-position:left top; background-size:100% 100%;}
	.mEvt45950 .track li div .click {position:relative; position:absolute; right:4%; top:60%; width:40%;}
	.mEvt45950 .track li div .click span {display:block; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_click.png) left top no-repeat; background-size:100% 100%;}
	.mEvt45950 .track li .on .click {display:none;}
	.mEvt45950 .track li.start {left:3%; top:5%;}
	.mEvt45950 .track li.day01 {left:26%; top:5%;}
	.mEvt45950 .track li.day02 {left:52%; top:5%;}
	.mEvt45950 .track li.day03 {left:76%; top:5%;}
	.mEvt45950 .track li.day04 {left:72%; top:28%;}
	.mEvt45950 .track li.day06 {left:15%; top:28%;}
	.mEvt45950 .track li.day05 {left:44%; top:28%;}
	.mEvt45950 .track li.day07 {left:13%; top:52%;}
	.mEvt45950 .track li.day08 {left:42%; top:52%;}
	.mEvt45950 .track li.day09 {left:70%; top:52%;}
	.mEvt45950 .track li.day12 {left:15%; top:76%;}
	.mEvt45950 .track li.day11 {left:44%; top:76%;}
	.mEvt45950 .track li.day10 {left:72%; top:76%;}
	.mEvt45950 .track li.start div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_start.png)}
	.mEvt45950 .track li.day01 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_1m.png)}
	.mEvt45950 .track li.day02 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_2m.png)}
	.mEvt45950 .track li.day03 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_3m.png)}
	.mEvt45950 .track li.day04 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_4m.png)}
	.mEvt45950 .track li.day05 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_5m.png)}
	.mEvt45950 .track li.day06 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_6m.png)}
	.mEvt45950 .track li.day07 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_7m.png)}
	.mEvt45950 .track li.day08 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_8m.png)}
	.mEvt45950 .track li.day09 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_9m.png)}
	.mEvt45950 .track li.day10 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_10m.png)}
	.mEvt45950 .track li.day11 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_11m.png)}
	.mEvt45950 .track li.day12 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_12m.png)}
	.mEvt45950 .track li.start div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_start_on.png)}
	.mEvt45950 .track li.day01 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_1m_on.png)}
	.mEvt45950 .track li.day02 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_2m_on.png)}
	.mEvt45950 .track li.day03 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_3m_on.png)}
	.mEvt45950 .track li.day04 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_4m_on.png)}
	.mEvt45950 .track li.day05 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_5m_on.png)}
	.mEvt45950 .track li.day06 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_6m_on.png)}
	.mEvt45950 .track li.day07 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_7m_on.png)}
	.mEvt45950 .track li.day08 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_8m_on.png)}
	.mEvt45950 .track li.day09 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_9m_on.png)}
	.mEvt45950 .track li.day10 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_10m_on.png)}
	.mEvt45950 .track li.day11 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_11m_on.png)}
	.mEvt45950 .track li.day12 div.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_running_12m_on.png)}
	.mEvt45950 .track li .result {position:absolute; left:0; bottom:0; width:100%;}
	.mEvt45950 .track li .result span {display:block; width:66%; margin-left:13%;}
	//.mEvt45950 .track li .result span {display:block; width:100%;}
	.mEvt45950 .track li .result img {vertical-align:bottom;}
	.mEvt45950 .notice {position:relative; padding:20px 10px; background:#f0f0f0; text-align:left;}
	.mEvt45950 .notice ul {padding-top:5px;}
	.mEvt45950 .notice ul li {padding-left:8px; font-size:11px; line-height:16px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blt_arrow.png) left 6px no-repeat; color:#7d7d7d; background-size:4px auto;}
</style>
<script type="text/javascript">
$(function(){
	$('.track li div, .click a').addClass('pngFix');
});

function jsDayCheck(){
<% If IsUserLoginOK() Then %>

		evtFrm1.submit();

<% Else %>
if(confirm("로그인 후 이벤트 참여가 가능합니다.\n로그인 하시겠습니까?")){
<%
	IF application("Svr_Info") = "Dev" THEN
%>
		top.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=/event/eventmain.asp?eventid=20976";
<%
	Else
%>
		top.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=/event/eventmain.asp?eventid=45950";
<%
	End If
%>
	
}
<% End IF %>
}

<% If IsUserLoginOK() Then %>
function jsGamble(){
	evtFrm2.submit();
}
<% End IF %>
</script>
</head>
<body>
<!-- content area -->
<form name="evtFrm1" action="/event/12th/02/dayCheck_proc.asp" method="post" target="evtFrmProc" style="margin:0px;">
<input type="hidden" name="eventid" value="<%=vEventID%>">
</form>
<% If IsUserLoginOK() Then %>
<form name="evtFrm2" action="/event/12th/02/gambling.asp" method="post" target="evtFrmProc" style="margin:0px;">
<input type="hidden" name="eventid" value="<%=vEventID%>">
</form>
<% End IF %>
<div class="content" id="contentArea">
	<div class="mEvt45950">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_head.png" alt="뛰어! 뛰어! 달리기!" style="width:100%;" /></p>
		<div class="track">
			<ol>
			<% If IsUserLoginOK() Then %>
				<!-- for dev msg : 클릭 손모양 클릭 시 해당 li안의 div에 클래스 on 추가해주세요 / 스타트 영역은 로그인 했을 경우 클래스 on 추가 -->
					<li class="start">
						<div <%=CHKIIF(GetLoginUserID<>"","class='on'","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div>
					</li>
					<li class="day01">
						<div id="day1img" <%=CHKIIF(vTotalCount>=1,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,0,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,0,vLastDate)<>"",vClick,"")%>
						</div>
					</li>
					<li class="day02">
						<div id="day2img" <%=CHKIIF(vTotalCount>=2,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,1,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,1,vLastDate)<>"",vClick,"")%>
						</div>
					</li>
					<li class="day03">
						<div id="day3img" <%=CHKIIF(vTotalCount>=3,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,2,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,2,vLastDate)<>"",vClick,"")%>
						</div>
					</li>
					<li class="day04">
						<div id="day4img" <%=CHKIIF(vTotalCount>=4,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,3,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,3,vLastDate)<>"",vClick,"")%>
						</div>
					</li>
					<li class="day05">
						<div id="day5img" <%=CHKIIF(vTotalCount>=5,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,4,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,4,vLastDate)<>"",vClick,"")%>
						</div>
					</li>
					<li class="day06">
						<div id="day6img" <%=CHKIIF(vTotalCount>=6,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,5,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,5,vLastDate)<>"",vClick,"")%>
							<p class="result" id="day6confirm" style="display:none;">
							<%
								If vTotalCount >= 6 Then
									If arrList(0,5) = "notcheck" AND CStr(arrList(3,5)) = CStr(date()) Then
										vGamblingBtn = "day6confirm"
										Response.Write "<span><img src='http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_btn_win.png' alt='당첨확인' style='width:100%;' onClick='jsGamble();' style='cursor:pointer;'></span>"
									End If
									If arrList(0,5) = "o" Then
										Response.Write "<img src=""http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_txt_win.png"" style=""width:100%;"" alt=""당첨! 축하합니다!"" />"
										Response.Write "<script>$('#day6confirm').show();</script>"
									End If
									If arrList(0,5) = "x" Then
										Response.Write "<img src=""http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_txt_fail.png"" style=""width:100%;"" alt=""꽝! 더 힘차게 달리세요!"" />"
										Response.Write "<script>$('#day6confirm').show();</script>"
									End If
								End If
							%>
							</p>
						</div>
					</li>
					<li class="day07">
						<div id="day7img" <%=CHKIIF(vTotalCount>=7,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,6,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,6,vLastDate)<>"",vClick,"")%>
						</div>
					</li>
					<li class="day08">
						<div id="day8img" <%=CHKIIF(vTotalCount>=8,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,7,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,7,vLastDate)<>"",vClick,"")%>
						</div>
					</li>
					<li class="day09">
						<div id="day9img" <%=CHKIIF(vTotalCount>=9,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,8,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,8,vLastDate)<>"",vClick,"")%>
						</div>
					</li>
					<li class="day10">
						<div id="day10img" <%=CHKIIF(vTotalCount>=10,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,9,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,9,vLastDate)<>"",vClick,"")%>
							<p class="result" id="day10confirm" style="display:none;">
							<%
								If vTotalCount >= 10 Then
									If arrList(0,9) = "notcheck" AND CStr(arrList(3,9)) = CStr(date()) Then
										vGamblingBtn = "day10confirm"
										Response.Write "<span><img src='http://webimage.10x10.co.kr/eventIMG/2013/45882/45882_btn_win.gif' alt='당첨확인' style='width:100%;' onClick='jsGamble();' style='cursor:pointer;'></span>"
									End If
									If arrList(0,9) = "o" Then
										Response.Write "<img src=""http://webimage.10x10.co.kr/eventIMG/2013/45882/45882_txt_win.png"" style=""width:100%;"" alt=""당첨! 축하합니다!"" />"
										Response.Write "<script>$('#day10confirm').show();</script>"
									End If
									If arrList(0,9) = "x" Then
										Response.Write "<span><img src=""http://webimage.10x10.co.kr/eventIMG/2013/45882/45882_txt_fail.png"" style=""width:100%;"" alt=""꽝! 더 힘차게 달리세요!"" /></span>"
										Response.Write "<script>$('#day10confirm').show();</script>"
									End If
								End If
							%>
							</p>
						</div>
					</li>
					<li class="day11">
						<div id="day11img" <%=CHKIIF(vTotalCount>=11,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,10,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,10,vLastDate)<>"",vClick,"")%>
						</div>
					</li>
					<li class="day12">
						<div id="day12img" <%=CHKIIF(vTotalCount>=12,"class='on'","")%>  <%=TodayOnClickCheck(vTotalCount,11,vLastDate)%>>
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" />
							<%=CHKIIF(TodayOnClickCheck(vTotalCount,11,vLastDate)<>"",vClick,"")%>
							<p class="result" id="day12confirm" style="display:none;">
							<%
								If vTotalCount = 12 Then
									If arrList(0,11) = "notcheck" AND CStr(arrList(3,11)) = CStr(date()) Then
										vGamblingBtn = "day12confirm"
										Response.Write "<span><img src='http://webimage.10x10.co.kr/eventIMG/2013/45882/45882_btn_win.gif' alt='당첨확인' style='width:100%;' onClick='jsGamble();' style='cursor:pointer;'></span>"
									End If
								End If
								If vTotalCount >= 12 Then
									If arrList(0,11) = "o" Then
										Response.Write "<img src=""http://webimage.10x10.co.kr/eventIMG/2013/45882/45882_txt_win.png"" style=""width:100%;"" alt=""당첨! 축하합니다!"" />"
										Response.Write "<script>$('#day12confirm').show();</script>"
									End If
									If arrList(0,11) = "x" Then
										Response.Write "<img src=""http://webimage.10x10.co.kr/eventIMG/2013/45882/45882_txt_fail.png"" style=""width:100%;"" alt=""꽝! 더 힘차게 달리세요!"" />"
										Response.Write "<script>$('#day12confirm').show();</script>"
									End If
								End If
							%>
							</p>
						</div>
					</li>
			<% Else %>
					<li class="start"><div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day01"><div id="day1img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day02"><div id="day2img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day03"><div id="day3img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day04"><div id="day4img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day05"><div id="day5img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day06"><div id="day6img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day07"><div id="day7img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day08"><div id="day8img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day09"><div id="day9img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day10"><div id="day10img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day11"><div id="day11img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
					<li class="day12"><div id="day12img" onClick="jsDayCheck()" style="cursor:pointer;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_blank.png" alt="" style="width:100%;" /></div></li>
			<% End If %>
			</ol>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_bg_track.png" alt="" style="width:100%;" /></p>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_gift.png" alt="사은품 안내" style="width:100%;" /></div>
		<div class="notice">
			<div><strong><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/45950_tit_notice.png" alt="이벤트 유의사항" style="width:67px;" /></strong></div>
			<ul>
				<li>본 이벤트는 각 ID당 하루 한번만 참여할 수 있습니다.</li>
				<li>하루에 1미터씩 응모를 할 수 있습니다.</li>
				<li>마일리지 및 할인쿠폰에 당첨되셨을 경우, 2013년 10월 24일(목)에 일괄 발송, 적용 됩니다.</li>
				<li>사은품은 이벤트 종료 후 주소확인 및 간단한 개인 정보 취합 후 발송됩니다. (추후 안내)</li>
			</ul>
		</div>
		<div><a href="/event/eventmain.asp?eventid=45950" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45950/btn_go.gif" style="width:100%;" alt="오늘도 열심히 달리셨나요? 쇼핑을 즐기셨다면, 특별한 사은품도 챙겨가세요! 구매금액별 사은품 확인하기" /></a></div>
	</div>
</div>
<% If vGamblingBtn <> "" Then %>
<script>$("#<%=vGamblingBtn%>").css("display","block");</script>
<% End If %>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
<!-- //content area -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->