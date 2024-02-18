<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim sqlStr, iDiscountSum
Dim icoupontype, icouponvalue, jumunDiv, icouponid
Dim userid

iDiscountSum = 0

If IsUserLoginOK() Then
	userid = getEncLoginUserID
else
    response.write iDiscountSum
    dbget.Close() : response.end
end if

icoupontype = requestCheckvar(request("icoupontype"),10)
icouponvalue = requestCheckvar(request("icouponvalue"),10)
icouponid = requestCheckvar(request("icouponid"),10)  ''2018/01/25 Ãß°¡
jumunDiv = requestCheckvar(request("jumunDiv"),10)
if (icoupontype<>"2") and (icoupontype<>"6" and icoupontype<>"7") then
    response.write iDiscountSum
    dbget.Close() : response.end
end if

if (icoupontype="6" or icoupontype="7") then
    sqlStr = "exec [db_my10x10].[dbo].sp_Ten_ShoppingBag_PriceCpnDiscountList_CateBrand '"&userid&"',"&icouponid&",'Y'"
    rsget.CursorLocation = adUseClient
    rsget.CursorType = adOpenStatic
    rsget.LockType = adLockOptimistic
    
    rsget.Open sqlStr,dbget,1
    if Not rsget.Eof then
        iDiscountSum = rsget("disSum")
    end if
    rsget.Close
else
    sqlStr = "exec [db_my10x10].[dbo].sp_Ten_ShoppingBag_PriceCpnDiscountList '"&userid&"',"&icouponvalue&",'"&jumunDiv&"','Y','Y'"
    rsget.CursorLocation = adUseClient
    rsget.CursorType = adOpenStatic
    rsget.LockType = adLockOptimistic
    
    rsget.Open sqlStr,dbget,1
    if Not rsget.Eof then
        iDiscountSum = rsget("disSum")
    end if
    rsget.Close
end if

response.write iDiscountSum
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
