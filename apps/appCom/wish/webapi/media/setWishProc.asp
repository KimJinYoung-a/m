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
' PageName : /apps/appCom/wish/webapi/media/setWishProc.asp
' Discription : media wish 추가 / 삭제
' Request : json > item_id : user_id
' Response : response > 결과 : item_id , my_wish - true / false
' History : 2018-06-26 이종화
'###############################################

'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

Dim vItemid, vUserid, sFDesc , contentId , vMediaName
Dim oJson
'// json객체 선언
Set oJson = jsObject()
'// Body Data 접수
'If Request.TotalBytes > 0 Then
'    Dim lngBytesCount
'        lngBytesCount = Request.TotalBytes
'    sData = BinaryToText(Request.BinaryRead(lngBytesCount),"UTF-8")
'End If
on Error Resume Next

vItemid = request("itemId")
vUserid = GetEncLoginUserID()
vMediaName = request("mediaName")

if vUserid = "" then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "login"
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if
if vItemid = "" then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "itemid"
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if
if vMediaName = "" then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "mediaName"
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다.1"

ElseIf Not isNumeric(vItemID) Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "상품코드가 잘못 되었습니다."
elseif vUserid <> "" Then

'	'// 로그인 사용자
'	userid = getEncLoginUserID
'
'	If vUserid <> userid Then
'		oJson("response") = getErrMsg("9999",sFDesc)
'		oJson("faildesc") = "로그인 ID가 다릅니다."
'	End If 

	dim vQuery , vIsExistItem , vFolderIdx

	vQuery = "select count(f.itemid) from db_my10x10.dbo.tbl_myfavorite_folder as ff "
	vQuery = vQuery & "left join db_my10x10.dbo.tbl_myfavorite as f on ff.fidx = f.fidx and ff.userid = f.userid "
	vQuery = vQuery & "where f.userid = '" & vUserID & "' and f.itemid = '"& vItemID &"' and ff.foldername = '"& vMediaName &"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	if rsget(0) > 0 then
		vIsExistItem = True
	else
		vIsExistItem = false
	end if
	rsget.close
	
	If vIsExistItem Then	'### 상품 있으면.
		vQuery = " delete [db_my10x10].[dbo].[tbl_myfavorite] from "
		vQuery = vQuery & " [db_my10x10].[dbo].[tbl_myfavorite] as f "
		vQuery = vQuery & " inner join db_my10x10.dbo.tbl_myfavorite_folder as ff "
		vQuery = vQuery & " on ff.fidx = f.fidx and ff.userid = f.userid and f.userid = '"& vUserID &"' and ff.foldername = '"& vMediaName &"'"
		vQuery = vQuery & " and f.itemid = '"& vItemID &"' "
		dbget.execute vQuery

	Else					'### 상품 없으면.
		'### 폴더 존재여부
		vQuery = "select top 1 ff.fidx from db_my10x10.dbo.tbl_myfavorite_folder as ff where ff.userid = '"& vUserID &"' and ff.foldername = '"& vMediaName &"'"
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
		if not rsget.eof then
			vFolderIdx = rsget(0)
		else
			vFolderIdx = ""
		end if
		rsget.close
		
		if vFolderIdx = "" then	'### 폴더 없을경우
			vQuery = "insert into [db_my10x10].[dbo].[tbl_myfavorite_folder](userid, foldername, viewisusing, sortno) values "
			vQuery = vQuery & "('"& vUserID &"', '"& vMediaName &"', 'Y', 0)"
			dbget.execute vQuery
			
			vQuery = "SELECT IDENT_CURRENT(db_my10x10.dbo.tbl_myfavorite_folder) as fidx"
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
			If Not Rsget.Eof then
				vFolderIdx = rsget("fidx")
				vNewfolderflag = True '// 폴더 생성됨
			end if
			rsget.close
		end if
		
		'### 위시 저장
		vQuery = "insert into db_my10x10.dbo.tbl_myfavorite(userid, itemid, regdate, fidx, viewIsUsing) values ('" & vUserID & "', " & vItemID & ", getdate(), " & vFolderIdx & " , 'N')"
		dbget.execute vQuery
	End If

	'// 결과 출력
	IF (Err) then
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "처리중 오류가 발생했습니다.2"
	Else
		If vIsExistItem Then 
			oJson("response") = "ok"
			oJson("item_id") = ""& vItemid &""
			oJson("my_wish") = false
		Else
			oJson("response") = "ok"
			oJson("item_id") = ""& vItemid &""
			oJson("my_wish") = true
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