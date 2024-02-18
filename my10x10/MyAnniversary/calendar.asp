<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 나의 기념일 등록 - 달력
' History : 2014-09-01 이종화 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
<title>10x10: 나의 기념일 등록:날짜 선택</title>
<script language="javascript">
function selectdate(a)
{
	opener.document.frmWrite.setDay.value = a;
	window.close();
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="prevPage">
					<a href="javascript:window.close();"><em class="elmBg">이전으로</em></a>
				</div>
				<!--마이텐바이텐-->
				<div id="my2">
					<div id="my2Tit">
						<h2>나의 기념일 등록</h2>
						<p class="tMar10 pDesc">나의 기념일은 내 생일을 포함, 최대 30개 까지 등록 가능합니다.</p>
					</div>
					<!--나의 기념일-->
					<div id="myanni">
						<form name="frm" action="calendar.asp" method="get">
						<div id="selYM">
							<select name="sel_y" onChange="frm.submit();">
								<%
									Dim y, m, vYear, vMonth
									vYear = Request("sel_y")
									vMonth = Request("sel_m")
									If vYear = "" Then
										vYear = Year(Now)
									End If
									If vMonth = "" Then
										vMonth = Month(Now)
									End If
									For y=(Year(now)+2) To 1900 Step -1
										Response.Write "<option value='" & y & "'"
										If CInt(vYear) = CInt(y) Then
											Response.Write " selected"
										End If
											Response.Write ">" & y & "년</option>"
									Next
								%>
							</select> 
							<select name="sel_m" onChange="frm.submit();">
								<%
									For m=1 To 12
										Response.Write "<option value='" & m & "'"
										If CInt(vMonth) = CInt(m) Then
											Response.Write " selected"
										End If
										Response.Write ">" & m & "월</option>"
									Next
								%>
							</select>
						</div>
						</form>
						<div id="myanniDate">
							<table >
								<colgroup>
									<col span="7" />
								</colgroup>
								<thead>
									<tr>
										<th class="sun">일</th>
										<th>월</th>
										<th>화</th>
										<th>수</th>
										<th>목</th>
										<th>금</th>
										<th>토</th>
									</tr>
								</thead>
								<tbody>
								<%
									Dim i, vBody, vStartDay, vEndDay, vWeekCount, vDayCount, vNow, vNextDay
									vBody		= ""
									vStartDay 	= DateSerial(vYear, vMonth, 1)
									vWeekCount	= WeekDay(vStartDay)
									vDayCount 	= DateDiff("d", vStartDay , DateAdd("m", 1, vStartDay))
									vEndDay		= DateAdd("d", vDayCount-1, vStartDay)
									
									vBody = vBody & "<tr>" & vbCrLf
									
									'앞공백 계산
									For i=1 to vWeekCount-1
										vBody = vBody & "<td></td>" & vbCrLf
									Next
									
									'달력 출력
									For i=1 to vDayCount
										vNow = DateSerial(Year(vStartDay), Month(vStartDay), i)

										If WeekDay(vNow) = 1 Then
											vBody = vBody & "<td class=""sun""><a href=""javascript:selectdate('" & vYear & "-" & TwoNumber(vMonth) & "-" & TwoNumber(i) & "');"">" & i & "</a></td>" & vbCrLf
										Else 
											vBody = vBody & "<td><a href=""javascript:selectdate('" & vYear & "-" & TwoNumber(vMonth) & "-" & TwoNumber(i) & "');"">" & i & "</a></td>" & vbCrLf
										End If

										If WeekDay(vNow) = 7 Then
											vBody = vBody & "</tr><tr>" & vbCrLf
										End If
									Next
									
									'뒷공백 계산
									vNextDay = WeekDay(vNow)+1
									If vNextDay = 8 Then
										vNextDay = 1
									End If
									
									For i=vNextDay To 7
										vBody = vBody & "<td></td>" & vbCrLf
									Next
									
									vBody = vBody & "</tr>" & vbCrLf
									
									Response.Write vBody
								%>
								<tbody>
							</table>
						</div>
					</div>
					<div class="btnArea">
						<span class="btn btn1 gryB w90B"><a href="javascript:window.close();">취소</a></span>
					</div>
				</div>
			</div>
			<!-- //content area -->
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>