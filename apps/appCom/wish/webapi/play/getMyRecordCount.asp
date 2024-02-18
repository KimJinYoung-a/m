<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/webapi/play/getMyRecordCount.asp
' Discription : myrecord count
' Request : json > user_id
' Response : response > 결과 : record_count
' History : 2018-08-07 이종화
'###############################################

'//헤더 출력
response.charset = "utf-8"
Response.ContentType = "application/json"

Dim sFDesc
Dim vPagenumber , vPageSize , vUserid , vCidx , vType , vAdminid
Dim sData : sData = Request("json")

''// Body Data 접수
'If Request.TotalBytes > 0 Then
'    Dim lngBytesCount
'        lngBytesCount = Request.TotalBytes
'    sData = BinaryToText(Request.BinaryRead(lngBytesCount),"UTF-8")
'End If

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	vUserid = requestCheckVar(oResult.user_id,32)
set oResult = Nothing

'// json객체 선언
Dim oJson

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
Else
	Dim vQuery , recordcount : recordcount = 0

	'// 카운트
	vQuery = "EXEC db_sitemaster.dbo.usp_WWW_Play_PlayList_Count_Get '"& vUserid &"' , '0'"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	If Not Rsget.Eof then
		recordcount = rsget(0)
	end if
	rsget.close
end If

Set oJson = jsObject()
	oJson("record_count")	= ""& recordcount &""
	'Json 출력(JSON)
	oJson.flush
Set oJson = Nothing

if ERR then Call OnErrNoti()
On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->