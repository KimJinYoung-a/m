<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'#######################################################
'	History	: 2014.09.17 한용민 생성
'	Description : CS Center
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/boardfaqcls.asp" -->
<%
Dim boardfaq, idx
	idx = requestCheckVar(Request("idx"),10)

	If idx = "" Then
		response.write "<script>alert('경로가 잘못되었습니다');location.replace('/cscenter/');</script>"
		dbget.close()
		Response.End
	End If
	
	set boardfaq = New CBoardFAQ
		boardfaq.FRectFaqId = idx
		boardfaq.getOneFaq()
%>
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="faqdetail">
					<div class="tit01">FAQ 상세</div>
					<h1><%=boardfaq.FOneItem.Ftitle%></h1>
					<div class="desc">
						<p><%=nl2br(boardfaq.FOneItem.Fcontents)%></p>
						<div class="btnConsult"><a href="/my10x10/qna/myqnalist.asp"><strong>1:1 상담 신청하기</strong></a></div>
					</div>
					<div class="btnwrap">
						<span class="button btB2 btGry cBk1"><a href="javascript:history.back();"><span>목록</span></a></span>
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
<% set boardfaq = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->