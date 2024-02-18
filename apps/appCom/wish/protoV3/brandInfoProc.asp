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
<!-- #include virtual="/apps/appCom/wish/protoV3/protoV3Function.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/brandInfoProc.asp
' Discription : Wish APP 브랜드 정보 출력 (Story 출력)
' Request : json > type, brandid, OS, versioncode, versionname, verserion
' Response : response > 결과, brandid, brandstory, tag(rray)
' History : 2014.01.15 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sMakerid, sFDesc, i
Dim sData : sData = Request("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sMakerid = requestCheckVar(oResult.brandid,32)
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType<>"brandinfo" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif sMakerid="" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터가 없습니다."

Else

	'// 검색 로그 사용여부(2017.01.12)
	Dim LogUsingCustomChk
	If getLoginUserId="thensi7" Then
		LogUsingCustomChk = True
	Else
		LogUsingCustomChk = True
	End If
	
	'// 검색 로그저장(2017.01.11 원승현)
	If LogUsingCustomChk Then
		If IsUserLoginOK() Then
			Call fnUserLogCheck("brand", getEncLoginUserId, "", "", sMakerid, "app")
		End If
	End If

	dim oItemList, arrTag

	Set oItemList = new CWish
	oItemList.FRectMakerid = sMakerid
	oItemList.FRectUserID = GetLoginUserID
	oItemList.getBrandInfo()

		'추가로 정보가 필요할경우 아래 항목에서 선택하세효~
		'oItemList.FItemList(0).FStoryTitle
		'oItemList.FItemList(0).FStoryCont
		'oItemList.FItemList(0).FphilosophyTitle
		'oItemList.FItemList(0).FphilosophyCont
		'oItemList.FItemList(0).Fdesignis
		'oItemList.FItemList(0).FTag

	'// 결과 출력
	if oItemList.FResultCount>0 then
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("brandid") = sMakerid
        
        oJson("brandstory") = ""
		'#브랜드Story
'		if Not(oItemList.FItemList(0).FStoryTitle="" or isNull(oItemList.FItemList(0).FStoryTitle)) then
'			oJson("brandstory") = oItemList.FItemList(0).FStoryCont
'		else
'			oJson("brandstory") = oItemList.FItemList(0).FStoryTitle & vbCrLf & oItemList.FItemList(0).FStoryCont
'		end if

		'#브랜드 Tag
'		Set oJson("tag") = jsArray()
'		if Not(oItemList.FItemList(0).FTag="" or isNull(oItemList.FItemList(0).FTag)) then
'			arrTag = split(oItemList.FItemList(0).FTag,",")
'			for i=0 to ubound(arrTag)
'				Set oJson("tag")(null) = jsObject()
'				oJson("tag")(null)("name") = trim(arrTag(i))
'			next
'		end if
		
		''proto V2 추가
		oJson("icon") = oItemList.FItemList(0).FiconName
		oJson("numofzzim") =  oItemList.FItemList(0).FbrandZzimCnt
		oJson("zzim") = oItemList.FItemList(0).FisMyZzim
		oJson("hangulname") = oItemList.FItemList(0).Fbrandname
		oJson("englishname") = oItemList.FItemList(0).FbrandnameEng
		oJson("designis") = oItemList.FItemList(0).Fdesignis
		oJson("bgurl") = oItemList.FItemList(0).Fbgurl
		
		''관련 이벤트
		set oJson("eventlist") = getBrandeventListJson(sMakerid)
		
	else
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "브랜드 정보가 없습니다."
	end if

	Set oItemList = Nothing

end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->