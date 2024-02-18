<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'##################################################
' PageName : /offshop/ shopnotice.asp
' Description : 오프라인숍 메인
' History : 2018.06.18 정태훈 리뉴얼
'##################################################
%>
<%
'매장 정보 가져오기
Dim offshopinfo, shopid
shopid = requestCheckVar(request("shopid"),16)
'Response.write shopid
'Response.end
Set  offshopinfo = New COffShop
offshopinfo.FRectShopID=shopid
offshopinfo.GetOneOffShopContents

Dim idx, sflag
Dim ClsOSBoard
Dim arrNoticeCont, arrNotice, intN
Dim iTotCnt,iCurrentPage,iPageSize, iPerCnt
Dim iStartPage, iEndPage, iTotalPage, vCSS

idx = requestCheckVar(Request("idx"),10)

If isNumeric(idx) = False Then
	Response.Write "<script>alert('잘못된 경로입니다.');history.back();</script>"
	dbget.close()
	Response.End
End If

set ClsOSBoard = new COffshopBoard
	ClsOSBoard.Fidx	= idx
	arrNotice = ClsOSBoard.fnGetNoticeCont
set ClsOSBoard = nothing
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body class="default-font body-sub">
	<!-- contents -->
	<% If isArray(arrNotice) Then %>
	<div class="content offshopV18" id="contentArea">
		<div class="offshop-noti">
			<h2 class="hidden">오프라인매장 공지</h2>
			<span>공지</span>
			<h3><%=db2html(arrNotice(3,intN))%></h3>
			<p class="date"><%=FormatDate(arrNotice(7,intN),"0000.00.00")%></p>
			<div class="specific-conts">
				<p>
				<% If IsNull(arrNotice(5,intN)) = "True" Then '진영 추가 2012-09-21 %>
					<%=db2html(arrNotice(4,intN))%>
				<% Else %>
					<%=nl2br(db2html(arrNotice(4,intN)))%>
				<% End If %>
				</p>
				<% If arrNotice(5,intN) <> "" Then %>
				<div class="thumb"><img src="http://webimage.10x10.co.kr/contimage/offshopevent/<%=arrNotice(5,intN)%>" alt="<%=db2html(arrNotice(4,intN))%>"></div>
				<% End If %>
			</div>
		</div>
	</div>
	<% End If %>
	<!-- //contents -->
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->