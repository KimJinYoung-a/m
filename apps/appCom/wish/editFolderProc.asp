<%@ codepage="65001" language="VBScript" %>
<%
	Option Explicit
	Session.CodePage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/editFolderProc.asp
' Discription : Wish APP 위시폴더를 추가/수정/삭제 처리
' Request : json > type, kind, folderid, foldername, public, OS, versioncode, versionname, verserion
' Response : response > 결과, folderid, foldername
' History : 2014.01.16 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"
Response.Charset = "UTF-8"

''Json 인코딩 안하므로.. 아래 함수로 대체..
Function fnGetPostDataStr()
	Dim strMethod			: strMethod			= Request.ServerVariables("REQUEST_METHOD")	' Form의 Method 정보

	'// 지역변수
	Dim strFormName
	Dim strPostData		: strPostData		= ""

	'// Post 형식일 경우 Form값을 String 형태로 취합한다.
	If Lcase(strMethod) = "post" Then
		For Each strFormName	 In Request.Form
		    if (Request.Form(strFormName)="") then
		        strPostData = strPostData & "&"&strFormName
		    else
    			strPostData = strPostData & Request.Form(strFormName)
    		end if
		Next
	End If
	fnGetPostDataStr =strPostData
End Function

Dim sType, sKind, sFidx, sFname, sIsView, sViewYN, sFDesc, i
Dim sData : sData = Request("json")''fnGetPostDataStr ''
Dim oJson, userid

'sData = (replace(sData,"json=",""))
'response.write sData
'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sKind = oResult.kind
	sFidx = requestCheckVar(oResult.folderid,9)
	sFname = requestCheckVar(oResult.foldername,20)
	sIsView = requestCheckVar(oResult.public,1)
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType<>"createfolder" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif sKind="" then
	'// 잘못된 접근
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 없습니다."
elseif sKind="create" and sFname="" then
	'// 생성시 폴더이름 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "폴더 이름이 없습니다."
elseif sKind="modify" and (sFname="" or sFidx="") then
	'// 수정시 폴더명 또는 폴더번호 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = chkIIF(sFname="","폴더 이름이","폴더번호가") & " 없습니다."
elseif IsUserLoginOK then
	'// 로그인 사용자
	userid = GetLoginUserID
	if sFidx="" then sFidx="0"
	if sIsView="1" then
		sViewYN = "Y"
	else
		sViewYN = "N"
	end if

	dim myfavorite, intResult
	dim sqlStr

	Select Case sKind
		Case "create"
			'# 신규 등록
			set myfavorite = new CMyFavorite
				myfavorite.FRectUserID	= userid
				myfavorite.FFolderName	= sFname
				myfavorite.fviewisusing	= sViewYN
				intResult = myfavorite.fnSetFolder
			set myfavorite = nothing

			IF intResult>0  THEN
				'등록 폴더ID 접수
				sqlStr = "Select max(fidx) from db_my10x10.dbo.tbl_myfavorite_folder "
				sqlStr = sqlStr & " Where userid='" & userid & "'"
				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					sFidx = rsget(0)
				end if
				rsget.Close
			end if

		Case "modify"
			'# 폴더 수정
			set myfavorite = new CMyFavorite
				myfavorite.FFolderIdx	= sFidx
				myfavorite.FFolderName	= sFname
				myfavorite.fviewisusing	= sViewYN
				intResult = myfavorite.fnSetFolderUpdate
			set myfavorite = nothing

		Case "delete"
			'# 삭제
			set myfavorite = new CMyFavorite
				myfavorite.FFolderIdx	= sFidx
				myfavorite.FRectUserID	= userid
				intResult = myfavorite.fnSetFolderDelete
			set myfavorite = nothing

	end Select

	'//처리 결과
	IF intResult > 0  THEN
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("folderid") = cStr(sFidx)
		oJson("foldername") = sFname
		oJson("public") = sIsView
	ELSEIF 	intResult =-1 THEN
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "폴더는 20개까지만 등록가능합니다."
	ELSE
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "처리중 오류가 발생했습니다."
	END IF

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