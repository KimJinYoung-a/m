<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV2/inc_constVar.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV2/searchItemCls.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV2/protoV2Function.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/Proc.asp
' Discription : Wish APP 목록 출력
' Request : json > type, kind, offset, size, filter, OS, versioncode, versionname, verserion
' Response : response > 결과, requestoffset, requestsize, numofproduct, product(array)
' History : 2014.01.15 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sFDesc, i
Dim sData : sData = Request("json")
Dim oJson, objRst, userid, iSeedStr

'// 전송결과 파징
'on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
    if sType="autocomplete" then
        iSeedStr = oResult.seedstr
    end if
	
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType="bestkeyword" then
	
	oJson("response") = getErrMsg("1000",sFDesc)
	Set oJson("keywords") = jsArray()			'상품
	Set oJson("keywords") = getRealTimeBestKeywords2  ''순위변동 포함
elseif sType="autocomplete" then
	
	oJson("response") = getErrMsg("1000",sFDesc)
	Set oJson("keywords") = jsArray()			'상품
	Set oJson("keywords") = getAutoCompleteKeywords(iSeedStr)   '' 자동완성				
else
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
