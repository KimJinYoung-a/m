<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%

dim i, j, lp
dim page
dim pflag, aflag
pflag = requestCheckvar(request("pflag"),10)
aflag = requestCheckvar(request("aflag"),2)
page = requestCheckvar(request("page"),9)
if (page="") then page = 1

dim userid
userid = GetLoginUserID()


dim myorder
set myorder = new CMyOrder

myorder.FPageSize = 10
myorder.FCurrpage = page
myorder.FRectUserID = userid
myorder.FRectSiteName = "10x10"
myorder.FRectOldjumun = pflag

If aflag = "XX" Then
	if IsUserLoginOK() then
	    myorder.GetMyCancelOrderList
	elseif IsGuestLoginOK() then
	    myorder.FRectOrderserial = GetGuestLoginOrderserial()
	    myorder.GetMyCancelOrderList
	end if
Else
	myorder.FRectArea = aflag

	if IsUserLoginOK() then
	    myorder.GetMyOrderList
	elseif IsGuestLoginOK() then
	    myorder.FRectOrderserial = GetGuestLoginOrderserial()
	    myorder.GetMyOrderList
	end if
End If

strPageTitle = "생활감성채널, 텐바이텐 > 주문배송조회"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type='text/javascript'>
	function goPage(pg){
		var frm = document.frmsearch;
		frm.page.value=pg;
		frm.submit();
	}
	function goLink(page,pflag,aflag){
	    location.href="?page=" + page + "&pflag=" + pflag + "&aflag=" + aflag;
	}
</script>
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
		<% If  IsGuestLoginOK()  Then %>
		<!-- #header -->
        <header id="header">
            <div class="tabs type-c">
                <a href="/apps/appcom/wish/webview/my10x10/order/myorderlist.asp" class="active">주문배송 조회</a>
                <a href="/apps/appcom/wish/webview/my10x10/qna/myqnalist.asp">1:1 상담</a>
            </div>
        </header><!-- #header -->
		<div class="well type-b">
            <ul class="txt-list">
                <li>최근 2개월간 고객님의 주문내역입니다. 주문번호를 탭하시면 상세조회를 하실 수 있습니다.</li>
                <li>2개월 이전 내역 조회는 PC용 사이트에서 이용하실 수 있습니다. </li>
            </ul>
        </div>
		<% End If %>

        <!-- #content -->
        <div id="content">
			<form name="frmsearch" method="post" action="myorderlist.asp" style="margin:0px;">
			<input type="hidden" name="pflag" value="<%=pflag%>">
			<input type="hidden" name="aflag" value="<%=aflag%>">
			<input type="hidden" name="page" value="1">
			</form>

			<% If IsUserLoginOK() Then %>
            <div class="inner">
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">주문 / 배송조회</span></h1>
                </div>
            </div>
            <div class="well type-b">
                <ul class="txt-list">
                    <li>최근 2개월간 고객님의 주문내역입니다. 주문번호를 탭하시면 상세조회를 하실 수 있습니다.</li>
                    <li>2개월 이전 내역 조회는 PC용 사이트에서 이용하실 수 있습니다. </li>
                </ul>
            </div>
            <div class="diff"></div>
			<% End If %>

            <div class="inner">
                <div class="tabs type-c three">
                    <a href="javascript:goLink(1,'<%=pflag%>','');" class="<%=chkIIF(aflag="","active","")%>">일반주문</a>
                    <a href="javascript:goLink(1,'<%=pflag%>','AB');" class="<%=chkIIF(aflag="AB","active","")%>">해외배송 주문조회</a>
                    <a href="javascript:goLink(1,'<%=pflag%>','XX');" class="<%=chkIIF(aflag="XX","active","")%>">취소 주문조회</a>
                    <div class="clear"></div>
                </div>
                <div class="diff"></div>
                <ul class="order-list">
					<%
						if myorder.FResultCount > 0 then
							for i = 0 to (myorder.FResultCount - 1)
					%>
                    <li class="bordered-box">
                        <a href="myorderdetail.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>&pflag=<%=pflag%>&aflag=<%=aflag%>" class="box-meta">
                            <span class="date"><%=formatdate(CStr(myorder.FItemList(i).Fregdate),"0000.00.00")%></span>
                            <span class="box-title">주문번호(<%= myorder.FItemList(i).FOrderSerial %>)</span>
                        </a>
                        <div class="product-info gutter">
                            <strong class="order-status red pull-left"><%=chkIIF(myorder.FItemList(i).FCancelyn<>"N","취소주문",myorder.FItemList(i).GetIpkumDivName)%><%=chkIIF(myorder.FItemList(i).IsReceiveSiteOrder,"(현장수령)","")%></strong>
							<% if (myorder.FItemList(i).FCancelyn="N") and (myorder.FItemList(i).IsWebOrderCancelEnable) then %>
                            <button class="btn type-a small pull-right" onclick="location.href='order_cancel_detail.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>&pflag=<%=pflag%>&aflag=<%=aflag%>';">주문취소</button>
							<% end if %>
                            <div class="clear"></div>                            
                            <div class="product-spec">
                                <p class="product-name"><%=myorder.FItemList(i).GetItemNames%></p>
                            </div>
                            <div class="price">
                                <strong><%=FormatNumber(myorder.FItemList(i).FSubTotalPrice,0)%></strong>원
                            </div>
                        </div>
                    </li>
					<%
							next
						else
					%>
						<p class="t-c" style="padding:30px 0">검색된 주문내역이 없습니다.</p>
					<%	end if %>
                </ul>
            </div>
			<!--페이지표시-->
			<div class="clear"></div>
				<%=fnDisplayPaging_New(myorder.FcurrPage, myorder.FtotalCount, myorder.FPageSize, 3,"goPage")%>
			<div class="diff"></div>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
        
    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<%
set myorder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->