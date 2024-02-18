<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/setZzimBrandProc.asp
' Discription : Wish APP 지정 브랜드를 찜!
' Request : json > type, kind, brandid, OS, versioncode, versionname, verserion
' Response : response > 결과
' History : 2014.01.15 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sKind, sMakerid, sFDesc, i
Dim sData : sData = Request("json")
Dim oJson, userid

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sKind = oResult.kind
	sMakerid = requestCheckVar(oResult.brandid,32)
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType<>"setzzimbrand" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif sKind="" or sMakerid="" then
	'// 잘못된 접근
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 없습니다."

elseif IsUserLoginOK then
	'// 로그인 사용자
	userid = GetLoginUserID

	dim sqlStr

	Select Case sKind
		Case "add"
			'# 찜브랜드 추가
			sqlStr = "	IF Exists(Select makerid from [db_my10x10].[dbo].tbl_mybrand where userid='" & userid & "' and Makerid='" & sMakerid & "') " & vbCrLf
			sqlStr = sqlStr & " Begin " & vbCrLf
			sqlStr = sqlStr & " 	update [db_my10x10].[dbo].tbl_mybrand "
			sqlStr = sqlStr & " 	set regdate=getdate() "
			sqlStr = sqlStr & " 	where userid='" & userid & "'  "
			sqlStr = sqlStr & " 	and Makerid='" & sMakerid & "' " & vbCrLf
			sqlStr = sqlStr & " End " & vbCrLf
			sqlStr = sqlStr & " ELSE " & vbCrLf
			sqlStr = sqlStr & " Begin " & vbCrLf
			sqlStr = sqlStr & " 	insert into [db_my10x10].[dbo].tbl_mybrand(userid,makerid) "
			sqlStr = sqlStr & " 	values('" & userid & "','" & sMakerid & "'); " & vbCrLf
			sqlStr = sqlStr & " 	update db_user.dbo.tbl_user_c "
			sqlStr = sqlStr & " 	Set recommendcount=recommendcount+1 "
			sqlStr = sqlStr & " 	where  userid='" & sMakerid & "'; " & vbCrLf
			sqlStr = sqlStr & " End"
			dbget.Execute(sqlStr)

		Case "delete"
			'# 찜브랜드 삭제
			sqlStr = "	delete from [db_my10x10].[dbo].tbl_mybrand where userid='" & userid & "' and Makerid='" & sMakerid & "'; " & vbCrLf
			sqlStr = sqlStr & " 	update db_user.dbo.tbl_user_c "
			sqlStr = sqlStr & " 	Set recommendcount=recommendcount-1 "
			sqlStr = sqlStr & " 	where userid='" & sMakerid & "'; " & vbCrLf
			dbget.Execute(sqlStr)			

	end Select

	'// 결과 출력
	IF (Err) then
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "처리중 오류가 발생했습니다."
	else
		oJson("response") = getErrMsg("1000",sFDesc)
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