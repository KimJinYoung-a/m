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
	response.write "<script>alert('파라메터 오류');fnAPPclosePopup();</script>"
Else
	set boardfaq = New CBoardFAQ
		boardfaq.FRectFaqId = idx
		boardfaq.getOneFaq()
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="faqdetail">
				<h1><%=boardfaq.FOneItem.Fcomm_name%></h1>
				<div class="desc">
					<%=nl2br(boardfaq.FOneItem.Fcontents)%>
					<div class="btnConsult"><a href="/apps/appCom/wish/web2014/my10x10/qna/myqnalist.asp"><strong>1:1 상담 신청하기</strong></a></div>
				</div>
				<div class="btnwrap">
					<span class="button btB2 btGry cBk1"><a href="/apps/appCom/wish/web2014/cscenter/"><span>목록</span></a></span>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
<% set boardfaq = nothing %>
<% end if %>

<!-- #include virtual="/lib/db/dbclose.asp" -->