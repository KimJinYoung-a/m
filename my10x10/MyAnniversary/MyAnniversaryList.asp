<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 나의 기념일
' History : 2014-09-01 이종화 생성
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/membercls/clsMyAnniversary.asp" -->
<%
Dim i

Dim page		: page			= req("page",1)

Dim obj	: Set obj = new clsMyAnniversary

obj.PageBlock	= 3
obj.PageSize	= 10
obj.CurrPage	= page

obj.FrontGetList 

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
<title>10x10: 나의 기념일</title>
	<script language="javascript">
		function popAnniversarySave(idx)
		{
			//var url = "popAnniversarySave.asp?idx="+idx;
			//window.open(url,"popAnniversarySave","width=400,height=500,left=400,top=200,location=no,menubar=no,resizable=no,scrollbars=yes,status=no,toolbar=no");
			location.href = "popAnniversarySave.asp?page=<%=page%>&idx="+idx+"";
		}

		function popAnniversaryView()
		{
			var url = "popAnniversaryView.asp";
			window.open(url,"popAnniversaryView","width=400,height=500,left=400,top=200,location=no,menubar=no,resizable=no,scrollbars=yes,status=no,toolbar=no");
		}

		// 삭제 처리
		function jsDelete(idx)
		{
			location.href = "popAnniversaryProc.asp?mode=DEL&idx="+idx;
		}

		// 상품목록 페이지 이동
		function goPage(pg){
			var frm = document.frmsearch;
			frm.page.value=pg;
			frm.submit();
		}
	</script>
</head>
<body>
<form name="frmsearch" method="post" action="MyAnniversaryList.asp">
<input type="hidden" name="page" value="1">
</form>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<!--마이텐바이텐-->
				<div id="my2">
					<div id="my2Tit">
						<h2>나의 기념일</h2>
						<p class="tMar10 pDesc">나의 기념일은 내 생일을 포함, 최대 30개 까지 등록 가능합니다.</p>
					</div>
					<!--나의 기념일-->
					<div id="myanni">
						<div class="overHidden">
							<%If obj.TotalCount < 30 Then %>
							<p class="ftLt total">Total <%=obj.TotalCount%></p>
							<p class="ftRt"><span class="btn btn3 redB w70B"><a href="javascript:popAnniversarySave('');" class="cWh1">신규등록</a></span></p>
							<%End If %>
						</div>
						<div id="myanniList">
							<table border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col />
									<col style="width:22%" />
									<col style="width:15%" />
									<col style="width:30%" />
								</colgroup>
								<tr bgcolor="#f5f5f5">
									<th>이벤트명</th>
									<th>날짜</th>
									<th>D-Day</th>
									<th>관리</th>
								</tr>
								<%For i = 1 To UBound(obj.Items) %>
								<tr>
									<td><%=obj.Items(i).title%></td>
									<td><%=obj.Items(i).getSetDay%></td>
									<td>
										<%If obj.Items(i).getDecimalDay < 0 Then %>
										-
										<%ElseIf obj.Items(i).getDecimalDay = 0 Then %>
											오늘
										<%Else %>
											D-<%=obj.Items(i).getDecimalDay%>
										<%End If %>	
									</td>
									<td class="fs16">
										<span class="btn btn5 gryB w40B"><a href="javascript:popAnniversarySave('<%=obj.Items(i).idx%>');">수정</a></span>
										<span class="btn btn5 gryB w40B"><a href="javascript:jsDelete('<%=obj.Items(i).idx%>');">삭제</a></span>
									</td>
								</tr>
								<%Next%>
								<%If UBound(obj.Items) = 0 Then %>
								<tr>
									<td colspan="4" height="50">등록하신 기념일이 없습니다.</td>
								</tr>
								<%End If %>
							</table>
						</div>
						<!--페이지표시-->
						<div class="paging tMar25">
							<%=fnDisplayPaging_New(obj.CurrPage,obj.TotalCount,obj.PageSize,4,"goPage")%>
						</div>
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
<%
Set obj = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->