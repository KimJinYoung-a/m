<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->

<%
''//// AJAX 상품 수량 변경(확인) 처리

'' 사이트 구분
Const sitename = "10x10"

dim i, tmparr
dim userid, guestSessionID
userid = GetLoginUserID
guestSessionID = GetGuestSessionKey()

dim mode            : mode		    = requestCheckVar(request.Form("mode"),10)
dim itemid          : itemid		= requestCheckVar(request.Form("itemid"),9)
dim itemoption      : itemoption    = requestCheckVar(request.Form("itemoption"),4)
dim itemea          : itemea  	    = requestCheckVar(request.Form("itemea"),9)
dim vAddItemCnt		: vAddItemCnt=0

if (itemid<>"") and (itemoption<>"") and (itemea<>"") and (mode="") then
    mode = "edit"		'기본은 수정
end if

dim oShoppingBag
set oShoppingBag = new CShoppingBag
oShoppingBag.FRectUserID    = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename

if (mode="edit") then
    if (itemid<>"") and (itemoption<>"") and (itemea<>"") then
		oshoppingbag.EditshoppingBagDB itemid,itemoption,itemea
	else
		Response.Write "ERR.01"
		dbget.close(): response.End
	end if
elseif (mode="del") then
	itemid = split(itemid,",")
	itemoption = split(itemoption,",")
	itemea = split(itemea,",")
	for i=LBound(itemid) to UBound(itemid)
	    if (Trim(itemid(i))<>"") and (Trim(itemoption(i))<>"") and (Trim(itemea(i))<>"") then
			oshoppingbag.EditshoppingBagDB Trim(itemid(i)),Trim(itemoption(i)),Trim(itemea(i))
			vAddItemCnt = vAddItemCnt+1
		end if
	next

	if vAddItemCnt=0 then
	    Response.Write "ERR.02"
	    dbget.close(): response.End
	end if

    '장바구니수 업데이트
    Call SetCartCount(GetCartCount-vAddItemCnt)
    Response.Write "OK." & GetCartCount
    dbget.close(): response.End
else
    Response.Write "ERR.03"
    dbget.close(): response.End
end if
Response.Write "OK"
set oshoppingbag = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->