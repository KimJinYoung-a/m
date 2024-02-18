<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/media/mediaCls.asp"-->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/webapi/media/getContentskeywordsList.asp
' Discription : 미디어 플랫폼 상세 키워드 목록
' Request : json > contentsidx
' Response : 
' History : 2019-05-30 이종화
'###############################################

'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

Dim vContentsidx 
dim sFDesc
Dim sData : sData = Request("json")
Dim oJson
dim ObjMedia , i , arrKeywords

dim keywordname

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
	vContentsidx = request("cidx")
set oResult = Nothing

'// json객체 선언
SET oJson = jsObject()
set oJson("keyWords") = jsArray()   

Dim contents_json , contents_object

if vContentsidx <> "" Then
	set ObjMedia = new MediaCls
	arrKeywords = ObjMedia.getContentsKeywordList(vContentsidx)

	if isarray(arrKeywords) then		
        for i = 0 to ubound(arrKeywords,2)
			oJson("keyWords")(null) = arrKeywords(2,i)
        next
    end if 
else
end if
oJson.flush
Set oJson = Nothing
'
'if vContentsidx <> "" Then
'
'else
'	'// 로그인 필요
'	oJson("response") = getErrMsg("9000",sFDesc)
'	oJson("faildesc") =	sFDesc
'end if
'
''Json 출력(JSON)
'
'
'if ERR then Call OnErrNoti()
'On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->