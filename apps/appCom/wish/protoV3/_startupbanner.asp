<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/startupbanner.asp
' Discription : APP 구동시 팝업 배너 정보 처리
' Request : json > type, os, id
' Response : response > 결과, closetype, title, bannertype, imageurl, link
' History : 2017.03.24 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sFDesc
Dim sType, sOS, sUserID
Dim sCloseType, sBnTitle, sBnType, sBnImgUrl, sLnkType, sLnkTitle, sLnkUrl
Dim sData : sData = Request("json")
Dim oJson
Dim sAppKey, sVerCd

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = requestCheckVar(oResult.type,12)
	sOS = requestCheckVar(oResult.os,8)
	sUserID = requestCheckVar(oResult.id,32)

	sAppKey = getWishAppKey(sOS)
	sVerCd = requestCheckVar(oResult.versioncode,20)
set oResult = Nothing


'// json객체 선언
Set oJson = jsObject()

If sType<>"startbanner" then
	'// 잘못된 콜싸인 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif Not(sOS="ios" or sOS="android") then
	'// OS 파라메터 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 잘못됐습니다."

else
	dim sqlStr, addSql, sUserLevel
	dim chkBanner: chkBanner = false

	'// 회원 정보 접수
	if sUserID<>"" then
		sqlStr = "Select userlevel From db_user.dbo.tbl_logindata where userid='" & sUserID & "'"
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			sUserLevel = rsget("userlevel")
		End if
		rsget.close
	End if

	'// 조건문 생성
	'기본 조건
	addSql = "Where getdate() between startdate and expireDate and isUsing='Y' and status=5 "

	'운영체제
	addSql = addSql & "and (targetOS='' or targetOS='" & sOS & "') "

	'타겟
	addSql = addSql & "and ("
	addSql = addSql & "	targetType='00' "			'전체회원 대상
	if sUserID="" then
		addSql = addSql & "	or targetType='30' "	'비회원
	elseif sUserLevel="3" or sUserLevel="4" or sUserLevel="6" then
		'VIP
		addSql = addSql & "	or targetType='20' or targetType='1" & sUserLevel & "' "
	else
		'일반회원
		addSql = addSql & "	or targetType='1" & sUserLevel & "' "
	end if
	addSql = addSql & ") "
	

	'// 시작 배너 정보 접수
	sqlStr = "Select top 1 * From db_sitemaster.dbo.tbl_app_startupBanner " & addSql &_
			" order by importance desc, idx desc"
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		chkBanner = true
		sCloseType =	rsget("closetype")
		sBnTitle =		rsget("bannertitle")
		sBnType =		rsget("bannertype")
		sBnImgUrl =		rsget("bannerimg")
		sLnkType =		rsget("linktype")
		sLnkTitle =		fnGetPopLinkTitle(sLnkType,rsget("linkTitle"))
		sLnkUrl =		wwwUrl & appUrlPath & rsget("linkurl")			'http없는 절대주소임 추가요망
		sLnkUrl =	sLnkUrl & chkIIF(instr(sLnkUrl,"?")>0,"&","?") & "gaparam=startupbanner"	'로그 파라메터 추가
	else
		'진행되는 배너 없음
		chkBanner = false
	end if
	rsget.Close

	'// 결과데이터 생성
	if Not(chkBanner) then
		oJson("response") = "none"
	else
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("closetype") = cStr(sCloseType)
		oJson("title") =  cStr(sBnTitle)
		oJson("bannertype") =  cStr(sBnType)
		oJson("imageurl") =  b64encode(sBnImgUrl)
		set oJson("link") = jsObject()
		oJson("link")("type") =  cStr(sLnkType)
		oJson("link")("title") =  cStr(sLnkTitle)
		oJson("link")("url") =  b64encode(sLnkUrl)
	end if
end if

IF (Err) then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
End if

''if ERR then Call OnErrNoti()		'// 오류 이메일로 발송

if oJson("response")<>"ok" and date>="2017-09-18" and date<="2017-09-30" then
	if ((sAppKey="6") and (sVerCd<"96")) or ((sAppKey="5") and (sVerCd<"2.0")) then	'구버전만 노출 (under v2)
		'V2 APP 업글 배너 출력
		Set oJson = jsObject()	'// 리셋
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("closetype") = "1"
		oJson("title") =  "새로운 텐바이텐을 만나다"
		oJson("bannertype") =  "R"
		oJson("imageurl") =  b64encode("http://fiximage.10x10.co.kr/web2017/main/startupNewApp_20170918.jpg")
		set oJson("link") = jsObject()
		oJson("link")("type") =  "event"
		oJson("link")("title") =  "새로운 텐바이텐"
		oJson("link")("url") =  b64encode("http://m.10x10.co.kr/event/appdown/inApp.asp")
	end if
end if

On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

''// 팝업 타이틀 선택 함수
function fnGetPopLinkTitle(sType,sTitle)
	Select Case sType
		Case "event"
			fnGetPopLinkTitle = "이벤트"
		Case "spevt"
			fnGetPopLinkTitle = "기획전"
		Case "prd"
			fnGetPopLinkTitle = "상품정보"
		Case else
			fnGetPopLinkTitle = sTitle
	end Select
end function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->