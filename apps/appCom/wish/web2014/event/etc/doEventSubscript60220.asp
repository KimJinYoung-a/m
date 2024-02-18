<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 지금 뭐해 ?
' History : 2015.03.17 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event60220Cls.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<%
dim eCode, userid, itemid, oItem, mode, ordercount, arritem
	mode = requestcheckvar(request("mode"),32)
	itemid = getNumeric(requestcheckvar(request("itemid"),10))

eCode=getevt_code
userid = getloginuserid()
ordercount=0
arritem=""

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end If

If mode = "add" Then '//응모버튼 클릭
	if not(left(currenttime,10)>="2015-03-19" and left(currenttime,10)<"2015-03-24") then
		Response.Write "DATENOT"
		dbget.close() : Response.End
	End If
	if userid="" then
		Response.Write "USERNOT"
		dbget.close() : Response.End
	End If
	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.write "STAFF"
		dbget.close() : Response.End
	end if
	if itemid="" then
		Response.Write "ITEMNOT"
		dbget.close() : Response.End
	End If

	ordercount=0
	arritem = getitem("1") & "," & getitem("2") & "," & getitem("3") & "," & getitem("4") & "," & getitem("5") & "," & getitem("6")
	
	ordercount = get10x10onlineorderdetailcount60220(userid, "2015-03-19", "2015-03-24", "", "", "", "N", "Y", arritem, "")

	if ordercount > 0 then
		Response.Write "ORDERCOUNT"
		dbget.close() : Response.End
	end if

	set oItem = new CatePrdCls
		oItem.GetItemData itemid

		if oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem then
			Response.Write "END"
			dbget.close() : Response.End
		end if
	set oItem = nothing

	Response.write "SUCCESS"
	dbget.close() : Response.End
Else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
