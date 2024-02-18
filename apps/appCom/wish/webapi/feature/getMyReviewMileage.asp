<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/webapi/feature/geyMyReviewMileage.asp
' Discription : 앱고도화 내 후기 마일리지 
' Request : json > user_id
' Response : response > 결과 : Mileage , Count
' History : 2018-08-17 이종화
'###############################################
'//헤더 출력
response.charset = "utf-8"
Response.ContentType = "application/json"

Dim sFDesc
Dim vUserid , vType
Dim sData : sData = Request("json")

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	vUserid = requestCheckVar(oResult.user_id,32)
	vType	= oResult.type
set oResult = Nothing

'// json객체 선언
Dim oJson
Dim contents_json , contents_object

'// 상품 후기 마일리지
Dim cMil , vMileArr
Dim vTotalcount : vTotalcount = 0
Dim vTotalmileage : vTotalmileage = 0
Dim vMileValue : vMileValue = 100
If isdoubleMileage Then
	vMileValue = 200
End If 

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

ElseIf vUserid = "" Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "회원 ID 가 없습니다."

Else
	Set cMil = New CEvaluateSearcher
		cMil.FRectUserID = vUserid
		cMil.FRectMileage = vMileValue
		vMileArr = cMil.getEvaluatedTotalMileCnt
	Set cMil = Nothing

	'// 마일리지 있을때
	If vMileArr(0,0) > 0 Then
		vTotalcount = vMileArr(0,0)
		vTotalmileage = chkiif(isdoubleMileage,FormatNumber(vMileArr(1,0),0)*2,FormatNumber(vMileArr(1,0),0))
	End If
end If

Set oJson = jsObject()
	oJson("response")	= "ok"
	oJson("mileage")	= ""& vTotalmileage &""
	oJson("count")		= ""& vTotalcount &""
	'Json 출력(JSON)
	oJson.flush
Set oJson = Nothing

if ERR then Call OnErrNoti()
On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->