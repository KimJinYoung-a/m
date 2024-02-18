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

%>

	<% If (myitemqna.FResultCount < 1) Then
		if page = "1" then  %>
			<script>$("#myitemqnanodata").show();</script>
	<% 
		end if
		Else %>
    <ul class="product-qna-list">
		<% for i=0 to myitemqna.FResultCount -1 %>
        <li class="bordered-box filled">
			<% if Not (IsNULL(myitemqna.FItemList(i).FItemId) or (myitemqna.FItemList(i).FItemId=0)) then %>
            <div class="product-info gutter">
                <div class="product-img">
                    <a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<% = myitemqna.FItemList(i).FItemID %>"><img src="<%= myitemqna.FItemList(i).FListImage %>" alt="<%= myitemqna.FItemList(i).FItemName %>"></a>
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
                        <% If myitemqna.FItemList(i).Fsecretyn="Y" Then %><i class="icon lock">비밀글</i> <% End If %> <%= Nl2Br(myitemqna.FItemList(i).FContents) %>
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
<% set myitemqna = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->