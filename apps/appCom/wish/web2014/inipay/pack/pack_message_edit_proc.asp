<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	Dim vQuery, vUserID, vGuestSessionID, vOrderserial, vMidx, vMessage
	vUserID       		= getEncLoginUserID()
	'vGuestSessionID 	= GetGuestSessionKey
	vOrderserial		= requestCheckVar(request("idx"),11)
	vMidx				= requestCheckVar(request("midx"),11)
	vMessage			= ReplaceBracket(requestCheckVar(request("message"),200))
	
	if checkNotValidTxt(vMessage) then		
		Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); location.href='/apps/appCom/wish/web2014/my10x10/order/myorderdetail.asp?idx="&vOrderserial&"&packopen=packopen';</script>"
		dbget.close() : Response.End
	end if
	
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_pack_master] SET message = '" & vMessage & "' WHERE midx = '" & vMidx & "' AND orderserial = '" & vOrderserial & "'"
	dbget.execute vQuery
	
	Response.Write "<script type='text/javascript'>alert('저장되었습니다.'); location.href='/apps/appCom/wish/web2014/my10x10/order/myorderdetail.asp?idx="&vOrderserial&"&packopen=packopen';</script>"
	dbget.close() : Response.End
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->