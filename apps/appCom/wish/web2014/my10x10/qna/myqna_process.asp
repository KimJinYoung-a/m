<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/myqnacls.asp" -->
<%
dim boardqna
dim boarditem
dim id, page, title, qadiv, emailok, usermail, contents
dim userid, userlevel, username, orderserial, itemid, isusing
dim userphone, OS, OSetc, sqlStr

userid = getEncLoginUserID
userlevel = getLoginUserLevel
if userlevel="" then userlevel="5"

Dim mode		: mode		= req("mode","INS")

Dim obj	: Set obj = new CMyQNA

dim evalPoint
evalPoint = requestCheckVar(req("evalPoint",0),8)
if (evalPoint <> "") then
	if (evalPoint < 1) then
		evalPoint = 1
	elseif (evalPoint > 5) then
		evalPoint = 5
	end if
end if

qaDiv			= html2db(requestCheckVar(request("qaDiv"),2))
title			= html2db(CheckCurse(requestCheckVar(request("title"),128)))
contents		= html2db(CheckCurse(requestCheckVar(request("contents"),16000)))
userMail		= html2db(requestCheckVar(request("usermail"),128))
userphone		= html2db(requestCheckVar(request("userphone"),16))
emailOK			= html2db(requestCheckVar(request("emailOK"),1))
itemID			= html2db(requestCheckVar(getNumeric(request("itemID")),10))
md5Key			= html2db(requestCheckVar(request("md5Key"),32))
orderSerial		= requestCheckVar(req("orderSerial",""),32)
username		= html2db(requestCheckVar(request("username"),32))
OS		= requestCheckVar(req("OS",""),16)
OSetc		= requestCheckVar(req("OSetc",""),15)

if (emailOK = "") then
	emailOK = "Y"
end if

if (checkNotValidHTML(title) = True) then
	Alert_return("상담제목에는 HTML을 사용하실 수 없습니다.")
	dbget.Close
	dbput.Close
	response.end
end if

if (checkNotValidHTML(contents) = True) then
	Alert_return("상담내용에는 HTML을 사용하실 수 없습니다.")
	dbget.Close
	dbput.Close
	response.end
end if

'//이름 정보 없을때  개인정보 업데이트 2021-09-23 정태훈
If GetLoginUserName()="" and mode="INS" Then
	''변경된 이미지 저장(기존에사용했음.주석만남김)
	sqlStr = "EXEC [db_user].[dbo].[usp_WWW_CSBoard_Username_Set] '" & userid & "', '" & Cstr(username) & "'"
	dbget.execute sqlStr
End If

Set obj.FOneItem = new CMyQNAItem

obj.FOneItem.Fuserid				= getEncLoginUserID
obj.FOneItem.Fuserlevel				= userlevel
obj.FOneItem.FuserName				= GetLoginUserName()

obj.FOneItem.Fid					= req("id",0)
obj.FOneItem.FqaDiv					= qaDiv
obj.FOneItem.Ftitle					= title
obj.FOneItem.Fcontents				= contents
obj.FOneItem.FuserMail				= userMail
obj.FOneItem.Fuserphone				= userphone
obj.FOneItem.FemailOK				= emailOK
obj.FOneItem.FitemID				= itemID
obj.FOneItem.ForderSerial			= orderSerial
obj.FOneItem.Fmd5Key				= md5Key

obj.FOneItem.Fextsitename			= "app"

obj.FOneItem.FevalPoint				= evalPoint
obj.FOneItem.FOS				= OS
obj.FOneItem.FOSetc				= OSetc

Dim ErrCode
ErrCode = obj.FrontProcData (mode)

Dim MD5Key	: MD5Key	= obj.FOneItem.FMD5Key
Set obj = Nothing

If mode = "INS" Then
	If ErrCode = 0 Then		' 0이면 에러 없음
		'// alert 창 안뜨게 수정
		''response.write "<script>alert('상담신청이 완료되었습니다.');</script>"
	    response.write "<script>location.href='" & wwwUrl & "/apps/appCom/wish/web2014/my10x10/qna/myqnalist.asp';</script>"
	else
		response.write "<script>alert('상담신청 처리중 오류가 발생했습니다.');</script>"
		response.write "<script>history.back();</script>"
	end If
ElseIf mode = "PNT" Then
	If ErrCode = 0 Then		' 0이면 에러 없음
		If MD5Key = "" Then
			response.write "<script>alert('평가하였습니다.\n\n소중한 의견 감사합니다.');</script>"
			response.write "<script>location.replace('" & wwwUrl & "/apps/appCom/wish/web2014/my10x10/qna/myqnalist.asp');</script>"
		Else
			response.write "<script>alert('평가하였습니다.\n\n소중한 의견 감사합니다.');</script>"
			response.write "<script>location.replace('" & wwwUrl & "/apps/appCom/wish/web2014/my10x10/qna/myqnalist.asp');</script>"
			'response.write "<script>location.href='http://www.10x10.co.kr/';</script>"
		End If
	Else
		response.write "<script>alert('평가에 실패하였습니다.\n\n관리자에게 문의해 주십시오.');</script>"
		response.write "<script>history.back();</script>"
	End If
ElseIf mode = "DEL" Then
    response.write "<script>alert('삭제되었습니다.');</script>"
    response.write "<script>location.replace('" & wwwUrl & "/apps/appCom/wish/web2014/my10x10/qna/myqnalist.asp');</script>"
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
