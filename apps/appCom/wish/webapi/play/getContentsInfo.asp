<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/webapi/play/getContentsInfo.asp
' Discription : 플레이 컨텐츠 리스트
' Request : 
' Response : 
' History : 2018-06-28 이종화
'###############################################

'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

Dim cTime , dummyName , vQuery , arrList , rsMem
Dim cidx , titlename , contents , isusing , isview , jcnt

	cTime = 60*5
	dummyName = "PlayContent"

	vQuery = "SELECT cidx , titlename , contents , isusing , isview FROM db_sitemaster.dbo.tbl_playcontents ORDER BY sortnum ASC"

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, vQuery, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

Dim sFDesc

'// 전송결과 파징
on Error Resume Next

'// json객체 선언
Dim oJson
Dim contents_json , contents_object

If IsArray(arrList) Then

	ReDim contents_object(ubound(arrList,2))
	For jcnt = 0 to ubound(arrList,2)

		cidx		= arrList(0,jcnt)
		titlename	= arrList(1,jcnt)
		contents	= arrList(2,jcnt)
		isusing		= arrList(3,jcnt)
		isview		= arrList(4,jcnt)

		Set contents_json = jsObject()
			contents_json("contents_name")	= ""& titlename &""
			contents_json("contents_cidx")	= ""& cidx &""
			contents_json("desc")			= ""& contents &""
			contents_json("is_view")		= chkiif(isusing, True , false)
			contents_json("is_using")		= chkiif(isview , True , false)
		Set contents_object(jcnt) = contents_json

	Next 
end If

Set oJson = jsObject()
	oJson("contents") = contents_object
	'Json 출력(JSON)
	oJson.flush
Set oJson = Nothing

if ERR then Call OnErrNoti()
On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->