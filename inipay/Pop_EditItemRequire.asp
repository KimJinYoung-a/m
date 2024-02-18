<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<%
'' 사이트 구분
Const sitename = "10x10"

dim userid, guestSessionID
userid = GetLoginUserID
guestSessionID = GetGuestSessionKey

dim oShoppingBag
set oShoppingBag = new CShoppingBag
oShoppingBag.FRectUserID    = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename

oshoppingbag.GetShoppingBagDataDB


dim itemid, itemoption, itemea, imageList, itemname, brandname, i
dim requiredetail
dim mode, requiredetailedit

itemid      = requestCheckVar(request("itemid"),9)
itemoption  = requestCheckVar(request("itemoption"),4)
requiredetail = oShoppingBag.getRequireDetailByItemID(itemid,itemoption)
itemea      = oShoppingBag.getItemNoByItemID(itemid,itemoption)
imageList	= oShoppingBag.getListImageByItemID(itemid)
itemname	= oShoppingBag.getItemNameByItemID(itemid)
brandname	= oShoppingBag.getItemBrandByItemID(itemid)

if (itemea<1) then 
    response.write "<script type=""text/javascript"">alert('해당 상품이 없습니다.');window.close();</script>"
    dbget.close() : response.end
end if

mode = request.form("mode")
requiredetailedit = (request.form("requiredetailedit"))

dim ret
if mode="edit" then
    if (itemea>1) then
        requiredetailedit = ""
        for i=0 to itemea-1
            if (request.form("requiredetailedit"&i)<>"") then
            requiredetailedit = requiredetailedit & request.form("requiredetailedit"&i) & CAddDetailSpliter
            end if
        next
        if Right(requiredetailedit,2)=CAddDetailSpliter then
            requiredetailedit = Left(requiredetailedit,Len(requiredetailedit)-2)
        end if
    end if
    ret = oShoppingBag.EditShoppingRequireDetail(itemid, itemoption, Html2DB(requiredetailedit))
end if

set oShoppingBag = Nothing

if (ret) then
    response.write "<script type='text/javascript'>"
    response.write "alert('수정 되었습니다.');"
    response.write "location.href='/inipay/ShoppingBag.asp';"
    response.write "</script>"
    dbget.close() : response.end
end if
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 상품 문구수정</title>
<script language="javascript" src="/lib/js/shoppingbag_script.js"></script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="editWords">
					<h1 class="tit01">상품 제작문구 수정</h1>
					<ul class="cpNoti">
						<li>같은 상품을 2개이상 주문하신 경우 제작문구가 다를 시, 각각 입력해 주시기바랍니다.</li>
						<li>제작문구가 같을 경우 1번째 상품에만 입력하시기 바랍니다.</li>
					</ul>
					<div class="pdtWrap">
						<a href="">
							<p class="pic"><img src="<%=imageList%>" alt="<%=replace(itemname,"""","")%>" /></p>
							<div class="pdtInfo">
								<p class="pBrand">[<%=brandname%>]</p>
								<p class="pName"><%=itemname%></p>
							</div>
						</a>
					</div>
					<form name="frm" method="post" action="/inipay/Pop_EditItemRequire.asp" onSubmit="return false;">
					<input type="hidden" name="mode" value="">
					<input type="hidden" name="itemid" value="<%= itemid %>">
					<input type="hidden" name="itemoption" value="<%= itemoption %>">
						<fieldset>
						<legend>제작 상품 문구 수정</legend>
						<% if (itemea=1) then %>
							<textarea name="requiredetailedit" id="requiredetailedit" cols="60" rows="5" title="수정할 문구 입력" class="w100p enterTxt"><%= Replace(requiredetail,CAddDetailSpliter,VbCrlf) %></textarea>
						<% else %>
						<%		for i=0 to itemea-1 %>
							<h2><%= i+1 %>번 상품</h2>
							<textarea name="requiredetailedit<%= i %>" id="requiredetailedit<%= i %>" cols="60" rows="5" title="수정할 문구 입력" class="w100p enterTxt"><%= splitValue(requiredetail,CAddDetailSpliter,i) %></textarea>
						<%		next %>
						<% end if %>
							<div class="btnwrap">
								<span class="button btB1 btGry2 cWh1"><a href="/inipay/ShoppingBag.asp">취소</a></span>
								<span class="button btB1 btRed cWh1"><button type="button" onclick="editRequire(document.frm,<%=itemea%>);">수정</button></span>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->