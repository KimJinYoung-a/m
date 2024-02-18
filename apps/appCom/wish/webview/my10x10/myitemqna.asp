<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/webview/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_item_qnacls.asp" -->
<%
dim userid, page, SortMethod
userid = GetLoginUserID
page   = requestCheckVar(request("page"),9)
SortMethod = requestCheckVar(request("SortMethod"),16)

if page="" then page=1
if SortMethod="" then SortMethod="all"

dim myitemqna
set myitemqna = new CItemQna
myitemqna.FPageSize = 4
myitemqna.FCurrpage = page
myitemqna.FRectUserID = userid

if SortMethod="fin" then
    myitemqna.FRectReplyYN = "Y"
end if

if userid<>"" then
    myitemqna.GetMyItemQnaList
end if

dim i, lp

strPageTitle = "생활감성채널, 텐바이텐 > 상품 Q&amp;A"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script>
	// 상품목록 리플레시
	function chgItemList(sm){
		var frm = document.frmItem;
		frm.action="myitemqna.asp";
		frm.SortMethod.value=sm;
		frm.mode.value = "";
		frm.submit();
	}

	// 상품목록 페이지 이동
	function goPage(pg){
		var frm = document.frmItem;
		frm.action="myitemqna.asp";
		frm.SortMethod.value="<%= SortMethod %>";
		frm.mode.value = "";
		frm.page.value=pg;
		frm.submit();
	}

	// 상품 문의 삭제
	function delItemQna(idx,iid){
		var frm = document.frmItem;
		if(confirm("상품문의를 삭제 하시겠습니까?\n답변이 완료된 경우 답변까지 삭제됩니다.")){
			frm.action="/my10x10/doitemqna.asp";
			frm.id.value = idx;
			frm.itemid.value = iid;
			frm.mode.value = "del";
			frm.submit();
		}
	}
</script>
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
        <!-- #content -->
        <div id="content">
			<form name="frmItem" method="get" onsubmit="return;" action="">
			<input type="hidden" name="page" value="">
			<input type="hidden" name="mode" value="">
			<input type="hidden" name="itemid" value="">
			<input type="hidden" name="id" value="">
			<input type="hidden" name="userid" value="<%= userid %>">
			<input type="hidden" name="SortMethod" value="<%= SortMethod %>">
            <div class="inner">
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">상품 Q&amp;A</span></h1>
                </div>
            </div>
            <div class="well type-b">
                <ul class="txt-list">
                    <li>상품 페이지에서 문의하신 .질문에 대한 답변을 확인하실 수 있습니다.</li>
                    <li>모바일에서는 문의내용 수정기능을 제공하지 않습니다. 수정을 원하시는 경우 PC 를 이용하여주세요.</li>
                </ul>
            </div>
            <div class="inner">
				<% If (myitemqna.FResultCount < 1) Then %>
				<p class="t-c" style="padding:30px 0">문의하신 상품 Q&A가 없습니다.</p>
				<% Else %>
                <ul class="product-qna-list">
					<% for i=0 to myitemqna.FResultCount -1 %>
                    <li class="bordered-box filled">
						<% if Not (IsNULL(myitemqna.FItemList(i).FItemId) or (myitemqna.FItemList(i).FItemId=0)) then %>
                        <div class="product-info gutter">
                            <div class="product-img">
                                <a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<% = myitemqna.FItemList(i).FItemID %>"><img src="<%= myitemqna.FItemList(i).FListImage %>" alt="<%= myitemqna.FItemList(i).FItemName %>"></a>
                            </div>
                            <div class="product-spec">
                                <p class="product-brand">[<%= myitemqna.FItemList(i).FBrandName %>] </p>
                                <p class="product-name"><%= myitemqna.FItemList(i).FItemName %></p>
                            </div>
                        </div>
						<% end if %>
                        <div class="clear"></div>
                        <div class="qna-box">
                            <div class="q">
                                <div class="qna-type <%=chkiif(myitemqna.FItemList(i).IsReplyOk,"complete","ing")%>"><span class="label"><%=chkiif(myitemqna.FItemList(i).IsReplyOk,"답변완료","답변대기")%></span></div>
                                <p class="qna-content">
                                    <%= Nl2Br(myitemqna.FItemList(i).FContents) %>
                                </p>
                                <div class="qna-meta">
                                    <span class="date"><%= FormatDate(myitemqna.FItemList(i).Fregdate,"0000.00.00") %></span>
                                </div>
                                <button class="btn type-e btn-delete small" onclick="delItemQna('<%= myitemqna.FItemList(i).Fid %>','<%=myitemqna.FItemList(i).FItemId%>');"><i class="icon-trash"></i>삭제</button>
                            </div>
							<% if myitemqna.FItemList(i).IsReplyOk then %>
                            <div class="a">
                                <div class="qna-type"></div>
                                <p class="qna-content">
                                    <%= Nl2Br(myitemqna.FItemList(i).FReplycontents) %>
                                </p>
                            </div>
							<% End If %>
                        </div>
                    </li>
					<% Next %>
                </ul>       
				<% End If %>
            </div> 
			<!-- paging Apps 전용 -->
			<div class="pagination">
	            <%=fnPaging_Apps("page", myitemqna.FTotalCount, myitemqna.FCurrPage, myitemqna.FPageSize, myitemqna.FScrollCount)%>                
            </div>
			</form>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
        
    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->