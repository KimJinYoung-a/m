<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV3/inc_constVar.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV3/wishCls.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/categoryListProc.asp
' Discription : Wish APP 지정 카테고리의 하위 목록 출력
' Request : json > type, categoryid, OS, versioncode, versionname, verserion
' Response : response > 결과, categoryid, category(array)
' History : 2014.01.15 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sCate, sFDesc, i
Dim sData : sData = Request("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sCate = getNumeric(requestCheckVar(oResult.categoryid,16))
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType<>"categorylist" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif (len(sCate) mod 3)>0 then
	'// 카테고리 길이 이상
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 카테고리 코드입니다."

else
	dim oItemList, sDep

	'// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	oJson("categoryid") = sCate

	if sCate<>"" then
		sDep = cStr(len(sCate)\3)+1			'하위 뎁스
	else
		sDep = "1"							'Root
	end if

	set oItemList = new CWish
	oItemList.FRectCateCd = sCate
	Set oJson("category") = oItemList.getDispCategoryListJson(sDep)

	set oItemList = Nothing
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->