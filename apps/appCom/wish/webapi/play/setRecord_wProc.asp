<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/webapi/play/setRecord_wProc.asp
' Discription : 플레이 record 추가 / 삭제
' Request : json > contents_pidx : record
' Response : response > 결과 : contents_pidx , record - true / false
' History : 2018-06-26 이종화
'###############################################

'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

Dim vPidx, vUserid, sFDesc 
Dim sData
Dim oJson, userid

If Request.TotalBytes > 0 Then
    Dim lngBytesCount
        lngBytesCount = Request.TotalBytes
    sData = BinaryToText(Request.BinaryRead(lngBytesCount),"UTF-8")
End If

'// 전송결과 파징
on Error Resume Next

'// json객체 선언
Set oJson = jsObject()

dim oResult
set oResult = JSON.parse(sData)
	vPidx	= oResult.contents_pidx
	vUserid = requestCheckVar(oResult.user_id,32)
set oResult = Nothing

'// 로그인 사용자일 경우 
if IsUserLoginOK() Then
	vUserid = getEncLoginUserID
End If 

IF (Err) Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다.1"

ElseIf Not isNumeric(vPidx) Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "리스트코드가 잘못 되었습니다."

elseif vUserid <> "" Then
	dim vQuery , vIsExist

	vQuery = "SELECT count(pidx) FROM db_sitemaster.dbo.tbl_playlist_mylist WHERE pidx = "& vPidx &" and userid = '"& vUserid &"'"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	if rsget(0) > 0 then
		vIsExist = True
	else
		vIsExist = false
	end if
	rsget.close

	If vIsExist Then
		vQuery = "DELETE FROM db_sitemaster.dbo.tbl_playlist_mylist "
		vQuery = vQuery & "	WHERE pidx = "& vPidx &" and userid = '"& vUserid &"' "
		dbget.execute vQuery
	Else
		vQuery = "INSERT INTO db_sitemaster.dbo.tbl_playlist_mylist "
		vQuery = vQuery & " (pidx , userid) VALUES ("& vPidx &" , '"& vUserid &"') "
		dbget.execute vQuery
	End If 

	'// 결과 출력
	IF (Err) then
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "처리중 오류가 발생했습니다.2"
	Else
		If vIsExist Then
			oJson("contents_pidx") = ""& vPidx &""
			oJson("record") = False
		Else
			oJson("contents_pidx") = ""& vPidx &""
			oJson("record") = True
		End If 
	end if
else
	'// 로그인 필요
	oJson("response") = getErrMsg("9000",sFDesc)
	oJson("faildesc") =	sFDesc
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->