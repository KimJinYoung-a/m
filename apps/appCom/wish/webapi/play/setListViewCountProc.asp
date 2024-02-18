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
' PageName : /apps/appCom/wish/webapi/play/setWishProc.asp
' Discription : 플레이 리스트 viewcount 증가
' Request : json > contents_pidx
' Response : 
' History : 2018-06-28 이종화
'###############################################

'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

Dim vPidx, sFDesc
Dim sData : sData = Request("json")
Dim oJson

'// Body Data 접수
'If Request.TotalBytes > 0 Then
'    Dim lngBytesCount
'        lngBytesCount = Request.TotalBytes
'    sData = BinaryToText(Request.BinaryRead(lngBytesCount),"UTF-8")
'End If

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	vPidx = oResult.contents_pidx
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다.1"

ElseIf Not isNumeric(vPidx) Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "리스트코드가 잘못 되었습니다."

elseif vPidx <> "" Then 

	dim vQuery
	'### viewcount 증가
	vQuery = "UPDATE db_sitemaster.dbo.tbl_playlist SET viewcount = viewcount + 1 WHERE pidx = "& vPidx &" "
	dbget.execute vQuery

	'// 결과 출력
	IF (Err) then
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "처리중 오류가 발생했습니다.2"
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