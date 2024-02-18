<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/myqnacls.asp" -->
<%
dim boardqna
dim boarditem
dim id, page, title, qadiv, emailok, usermail, contents
dim userid, userlevel, username, orderserial, itemid, isusing
dim userphone


userid = getLoginUserID
userlevel = getLoginUserLevel
if userlevel="" then userlevel="5"

Dim mode		: mode		= req("mode","INS")

Dim obj	: Set obj = new CMyQNA

Set obj.FOneItem = new CMyQNAItem

obj.FOneItem.Fuserid				= getLoginUserID
obj.FOneItem.Fuserlevel				= userlevel
obj.FOneItem.FuserName				= req("userName","")

obj.FOneItem.Fid					= req("id",0)
obj.FOneItem.FqaDiv					= req("qaDiv","")
obj.FOneItem.Ftitle					= req("title","")
obj.FOneItem.Fcontents				= CheckCurse(req("contents",""))
obj.FOneItem.FuserMail				= req("userMail","")
obj.FOneItem.Fuserphone				= req("userphone","")
obj.FOneItem.FemailOK				= req("emailOK","Y")
obj.FOneItem.FitemID				= req("itemID",0)
obj.FOneItem.ForderSerial			= req("orderSerial","")
obj.FOneItem.Fmd5Key				= req("MD5Key","")

obj.FOneItem.Fextsitename			= "mobile"

obj.FOneItem.FevalPoint				= req("evalPoint",0)

Dim ErrCode
ErrCode = obj.FrontProcData (mode)

Dim MD5Key	: MD5Key	= obj.FOneItem.FMD5Key
Set obj = Nothing

If mode = "INS" Then
	If ErrCode = 0 Then		' 0이면 에러 없음
	    response.write "<script>alert('상담신청이 완료되었습니다.');</script>"
	    response.write "<script>location.href='" & wwwUrl & "/apps/appcom/wish/webview/my10x10/qna/myqnalist.asp';</script>"
	else
		response.write "<script>alert('상담신청 처리중 오류가 발생했습니다.');</script>"
		response.write "<script>history.back();</script>"
	end If
ElseIf mode = "PNT" Then
	If ErrCode = 0 Then		' 0이면 에러 없음
		If MD5Key = "" Then
			response.write "<script>alert('평가하였습니다.\n\n소중한 의견 감사합니다.');</script>"
			response.write "<script>location.href='myqnalist.asp';</script>"
		Else
			response.write "<script>alert('평가하였습니다.\n\n소중한 의견 감사합니다.');</script>"
			response.write "<script>location.href='myqnalist.asp';</script>"
			'response.write "<script>location.href='http://www.10x10.co.kr/';</script>"
		End If
	Else
		response.write "<script>alert('평가에 실패하였습니다.\n\n관리자에게 문의해 주십시오.');</script>"
		response.write "<script>history.back();</script>"
	End If
ElseIf mode = "DEL" Then
    response.write "<script>alert('삭제되었습니다.');</script>"
    response.write "<script>location.href='myqnalist.asp';</script>"
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
