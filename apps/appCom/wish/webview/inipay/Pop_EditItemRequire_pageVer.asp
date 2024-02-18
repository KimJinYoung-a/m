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


dim itemid, itemoption, itemea, imageList, itemname, i
dim requiredetail
dim mode, requiredetailedit

itemid      = requestCheckVar(request("itemid"),9)
itemoption  = requestCheckVar(request("itemoption"),4)
requiredetail = oShoppingBag.getRequireDetailByItemID(itemid,itemoption)
itemea      = oShoppingBag.getItemNoByItemID(itemid,itemoption)
imageList	= oShoppingBag.getListImageByItemID(itemid)
itemname	= oShoppingBag.getItemNameByItemID(itemid)

if (itemea<1) then 
    response.write "<script language='javascript'>alert('해당 상품이 없습니다.');window.close();</script>"
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
    response.write "location.href='/apps/appCom/wish/webview/inipay/ShoppingBag.asp';"
    response.write "</script>"
    dbget.close() : response.end
end if
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title>10X10</title>
<link rel="shortcut icon" href="../favicon.ico" type="image/x-icon">
<link rel="icon" href="../favicon.ico" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="../css/style.css">
<link rel="stylesheet" type="text/css" href="../css/jquery.bxslider.css">
<script type="text/javascript" src="../js/jquery-latest.js"></script>
<script type="text/javascript" src="../js/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript" src="../js/jquery.bxslider.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script language="javascript" src="/apps/appCom/wish/webview/js/shoppingbag_script.js"></script>
</head>
<body class="shop">
	<div class="box">
	    
	    <header class="modal-header">
	        <h1 class="modal-title">주문제작 문구수정</h1>
	    </header>
	
	    <div class="modal-body">
			<div class="iscroll-area">
		        <p class="well type-b">같은 상품을 2개 이상 주문하시고 문구를 다르게 하실 경우, 반드시 각각의 문구를 작성해주시기 바랍니다.</p>
		        <div class="gutter">
					<form name="frm" method="post" action="/apps/appCom/wish/webview/inipay/Pop_EditItemRequire.asp" onSubmit="return false;" style="margin:0px;">
					<input type="hidden" name="mode" value="">
					<input type="hidden" name="itemid" value="<%= itemid %>">
					<input type="hidden" name="itemoption" value="<%= itemoption %>">
					<% if (itemea=1) then %>
		            <textarea name="requiredetailedit" id="requiredetailedit" cols="30" rows="10" class="form bordered  full-size"><%= Replace(requiredetail,CAddDetailSpliter,VbCrlf) %></textarea>
		            <%	else %>
		            <%		for i=0 to itemea-1 %>
		            <textarea name="requiredetailedit<%= i %>" id="requiredetailedit<%= i %>" cols="30" rows="10" class="form bordered  full-size"><%= splitValue(requiredetail,CAddDetailSpliter,i) %></textarea><br />
		            <%		next %>
		            <%	end if %>
		            </form>
		        </div>
			</div>
	    </div>
	    <footer class="modal-footer">
	        <div class="two-btns">
	            <div class="col"><input type="button" class="btn type-b" value="수정" onClick="editRequire(document.frm,<%=itemea%>);"></div>
	            <div class="col"><a href="/apps/appCom/wish/webview/inipay/ShoppingBag.asp" class="btn type-a full-size">취소</a></div>
	        </div>
	    </footer>
	    
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->