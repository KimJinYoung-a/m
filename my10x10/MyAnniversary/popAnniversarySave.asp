<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 나의 기념일 등록
' History : 2014-09-01 이종화 생성
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/clsMyAnniversary.asp" -->
<%
Dim idx	: idx	= req("idx","")

Dim page	: page	= req("page",1)

Dim obj	: Set obj = new clsMyAnniversary
obj.GetData idx


' 화면표시정보
Dim pageInfo1, pageInfo2, pageInfo3
If idx = "" Then
	pageInfo1 = "INS"
Else
	pageInfo1 = "UPD"
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
<title>10x10: 나의 기념일 등록</title>
	<script language='javascript'>
	<!--
	// 등록,수정 처리
	function jsSubmit(mode)
	{
		var f = document.frmWrite;
		if (!mode)
			if (f.idx.value=="")
				f.mode.value = "INS";
			else
				f.mode.value = "UPD";
		else
			f.mode.value = mode;

		if (!validField(f.setDay, "날짜를"))	return ;
		if (!validField(f.title, "기념일명을"))		return ;

		f.submit();

	}

	function calendarOpen3(objTarget,caption,defaultval){
		 //var objTarget = document.getElementById(targetName);
		 //var ret = window.showModalDialog("calendar.asp?caption=" + caption + "&defaultval=" + defaultval , null, "");
		window.open("calendar.asp","","");
	}
	//-->
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
					<a href="MyAnniversaryList.asp?page=<%=page%>"><em class="elmBg">이전으로</em></a>
				</div>
				<!--마이텐바이텐-->
				<form name="frmWrite" method="post" action="popAnniversaryProc.asp">
				<input type="hidden" name="mode">
				<input type="hidden" name="idx" value="<%=obj.Item.idx%>">
				<input type="hidden" name="memo" value="<%=obj.Item.memo%>">
				<input type="hidden" name="alarmcycle" value="<%=obj.Item.alarmcycle%>">
				<div id="my2">
					<div id="my2Tit">
						<h2>나의 기념일 등록</h2>
						<p class="tMar10 pDesc">나의 기념일은 내 생일을 포함, 최대 30개 까지 등록 가능합니다.</p>
					</div>
					<!--나의 기념일-->
					<div id="myanni">
						<div id="myshipInfo">
							<dl>
								<dt>기념일명</dt>
								<dd>
									<input name="title" type="text" class="text" style="width:70%;" value="<%=doubleQuote(obj.Item.title)%>" maxlength="50"/>
								</dd>
								<dt>날짜</dt>
								<dd>
									<select name="dayType">
										<option value="S" <%If obj.Item.dayType = "S" Then response.write "selected" %>>양력</option>
										<option value="L" <%If obj.Item.dayType = "L" Then response.write "selected" %>>음력</option>
									</select>
									<input name="setDay" type="text" class="text" style="width:64%;" value="<%=obj.Item.getSetDay%>" onKeyPress="calendarOpen3(this,'기념일',this.value);" onClick="calendarOpen3(this,'기념일',this.value);" maxlength="10" readonly/>
								</dd>
							</dl>
						</div>
					</div>
					<div class="btnArea">
						<span class="btn btn1 redB w90B"><a href="javascript:jsSubmit('<%=pageInfo1%>');">확인</a></span>
						<span class="btn btn1 gryB w90B"><a href="MyAnniversaryList.asp?page=<%=page%>">취소</a></span>
					</div>
				</div>
				</form>
			</div>
			<!-- //content area -->
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<%
Set obj = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->