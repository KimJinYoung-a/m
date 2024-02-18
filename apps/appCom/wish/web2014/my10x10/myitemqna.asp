<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_item_qnacls.asp" -->
<%
dim userid, page, SortMethod
userid = getEncLoginUserID
page   = requestCheckVar(request("page"),9)
SortMethod = requestCheckVar(request("SortMethod"),16)

if page="" then page=1
if SortMethod="" then SortMethod="all"

dim myitemqna
set myitemqna = new CItemQna
myitemqna.FPageSize = 5
myitemqna.FCurrpage = page
myitemqna.FRectUserID = userid

if SortMethod="fin" then
    myitemqna.FRectReplyYN = "Y"
end if

if userid<>"" then
    myitemqna.GetMyItemQnaList
end if

dim i, lp
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
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
	
	function modiItemQna(idx,itemid) {
		fnAPPpopupBrowserURL("상품문의","<%=wwwUrl%>/apps/appcom/wish/web2014/category/itemQnA_Write.asp?id="+idx+"&itemid="+itemid+"");
	}
	
	function goPage(p){
		frmItem.page.value = p;
		frmItem.submit();
	}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
			<form name="frmItem" method="get" onsubmit="return;" action="">
			<input type="hidden" name="page" value="">
			<input type="hidden" name="mode" value="">
			<input type="hidden" name="itemid" value="">
			<input type="hidden" name="id" value="">
			<input type="hidden" name="userid" value="<%= userid %>">
			<input type="hidden" name="SortMethod" value="<%= SortMethod %>">
			<div class="content pdtQna" id="contentArea">
				<!-- <h2 class="tit01 tMar20 lMar10">상품 Q&amp;A</h2> -->
				<div class="inner10">
					<ul class="cpNoti">
						<li>상품 페이지에서 문의하신 질문에 대한 답변을 편리하게 보실 수 있습니다.</li>
						<li>답변이 완료된 Q&A는 수정을 하실 수 없습니다.</li>
					</ul>
					<ul class="myQnaList">
					<% If (myitemqna.FResultCount < 1) Then %>
						<li class="noData"><p>문의하신 Q&A내역이 없습니다.</p></li>
					<% Else %>
						<% for i=0 to myitemqna.FResultCount -1 %>
						<li>
							<% if Not (IsNULL(myitemqna.FItemList(i).FItemId) or (myitemqna.FItemList(i).FItemId=0)) then %>
							<div class="pdtWrap" onClick="fnAPPpopupProduct('<% = myitemqna.FItemList(i).FItemID %>');">
								<p class="pic"><img src="<%= myitemqna.FItemList(i).FListImage %>" alt="<%= myitemqna.FItemList(i).FItemName %>" /></p>
								<div class="pdtInfo">
									<p class="pBrand"><%= myitemqna.FItemList(i).FBrandName %></p>
									<p class="pName"><%= myitemqna.FItemList(i).FItemName %></p>
								</div>
							</div>
							<% end if %>
							<div class="q<%=chkiif(myitemqna.FItemList(i).IsReplyOk," isA","")%>">
								<div><% If myitemqna.FItemList(i).Fsecretyn="Y" Then %><i class="icon lock">비밀글</i> <% End If %> <%= Nl2Br(myitemqna.FItemList(i).FContents) %></div>
								<p class="writer"><%=printUserId(myitemqna.FItemList(i).Fuserid,2,"*")%> / <%= FormatDate(myitemqna.FItemList(i).Fregdate,"0000.00.00") %></p>
								<p class="btnWrap">
									<% If myitemqna.FItemList(i).IsReplyOk = False Then %><span class="button btS2 btWht cBk1"><a href="" onClick="modiItemQna('<%= myitemqna.FItemList(i).Fid %>','<%=myitemqna.FItemList(i).FItemId%>');return false;">수정</a></span><% End If %>
									<span class="button btS2 btWht cBk1"><a href="" onClick="delItemQna('<%= myitemqna.FItemList(i).Fid %>','<%=myitemqna.FItemList(i).FItemId%>'); return false;">삭제</a></span>
								</p>
							</div>
							<% if myitemqna.FItemList(i).IsReplyOk then %>
							<div class="a">
								<div><%= Nl2Br(myitemqna.FItemList(i).FReplycontents) %></div>
							</div>
							<% end if %>
						</li>
						<% Next %>
					<% End If %>
					</ul>
					<%=fnDisplayPaging_New(myitemqna.FcurrPage,myitemqna.FtotalCount,myitemqna.FPageSize,4,"goPage")%>
				</div>
			</div>
			</form>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<% SET myitemqna = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->