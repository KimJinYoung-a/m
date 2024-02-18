<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbevtopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/webapi/feature/geyMyReviewMileage.asp
' Discription : 앱고도화 히스토리 최근본 상품 1건 이미지
' Request : json > user_id
' Response : response > 결과 : item_image
' History : 2018-08-29 이종화 ' 73번 DB select
'###############################################
'//헤더 출력
response.charset = "utf-8"
Response.ContentType = "application/json"

Dim sFDesc
Dim vUserid , vType
Dim sData : sData = Request("json")
dim basicimage , sqlStr

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	vUserid = requestCheckVar(oResult.user_id,32)
	vType	= oResult.type
set oResult = Nothing

'// json객체 선언
Dim oJson

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

ElseIf vUserid = "" Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "회원 ID 가 없습니다."

Else
	'// 현재 들어온 기준 해당 회원의 가장 마지막 상품이미지를 불러온다
    sqlStr = "Select * From "
    sqlStr = sqlStr & "( " 
    sqlStr = sqlStr & "    Select ROW_NUMBER() OVER (PARTITION BY AA.userid ORDER BY AA.idx desc) as rwnum, I.basicimage , I.itemid , i.itemdiv From "
    sqlStr = sqlStr & "        ( "
    sqlStr = sqlStr & "            Select max(U.idx) as idx, U.userid, U.type, U.itemid, U.evtcode, U.rect, max(U.platform) as platform, convert(varchar(10), U.regdate, 120) as regdate "
    sqlStr = sqlStr & "            From [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] U with (nolock) "
    sqlStr = sqlStr & "            Where userid='"& vUserid &"' "
    sqlStr = sqlStr & "            And type in ('item')  "
    sqlStr = sqlStr & "            And platform in ('pc','mw','app')  "
    sqlStr = sqlStr & "            group by U.userid, U.type, U.itemid, U.evtcode, U.rect, convert(varchar(10), U.regdate, 120) "
    sqlStr = sqlStr & "        )AA "
    sqlStr = sqlStr & "    left join db_analyze_data_raw.dbo.tbl_item I with (nolock) on AA.itemid = I.itemid "
    sqlStr = sqlStr & ")TT "
    sqlStr = sqlStr & " Where rwnum = '1' And itemdiv <> 21 "

    rsEVTget.Open sqlStr,dbEVTget,1
    if not rsEVTget.EOF  then
        basicimage = webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(rsEVTget("itemid")) & "/" & rsEVTget("basicimage")
    end if
    rsEVTget.close

	'// 마일리지 있을때
end If

Set oJson = jsObject()
	oJson("response")	= "ok"
    if basicimage = "" then 
    	oJson("item_image")	= ""
    else
        oJson("item_image")	= b64encode(basicimage)
    end if 
	'Json 출력(JSON)
	oJson.flush
Set oJson = Nothing

if ERR then Call OnErrNoti()
On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbEVTclose.asp" -->