<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/media/mediaCls.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/webapi/media/getSwipeList.asp
' Discription : 미디어 플랫폼 Swipre 리스트
' Request : json > serviceCode
' Response : 
' History : 2019-05-29 이종화
'###############################################

'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

Dim vServiceCode , vChannel
dim sFDesc
Dim sData : sData = Request("json")
Dim oJson
dim ObjMedia , arrSwipeList , i

dim bannerimage , linkurl , maincopy , subcopy , eventid , contentsidx

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
	vServiceCode = oResult.servicecode
    vChannel = oResult.channel
set oResult = Nothing

'// json객체 선언
SET oJson = jsObject()
Dim contents_json , contents_object

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다.1"

ElseIf Not isNumeric(vServiceCode) Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "컨텐츠 IDX가 잘못 되었습니다."

elseif vServiceCode <> "" Then
	
	set ObjMedia = new MediaCls
		arrSwipeList = ObjMedia.getSwipeBanner(vServiceCode,vChannel)
	set ObjMedia = nothing

    if isarray(arrSwipeList) then
        ReDim contents_object(ubound(arrSwipeList,2))
        for i = 0 to ubound(arrSwipeList,2)
            bannerimage = arrSwipeList(1,i)
            maincopy    = arrSwipeList(2,i)
            subcopy     = arrSwipeList(3,i)
            linkurl     = arrSwipeList(4,i)
			eventid     = arrSwipeList(11,i)
            contentsidx = arrSwipeList(12,i)

            Set contents_json = jsObject()
                contents_json("bannerimage")	= bannerimage
                contents_json("maincopy")	    = maincopy
                contents_json("subcopy")		= subcopy
                contents_json("linkurl")		= linkurl
				contents_json("eventid")		= eventid
				contents_json("contentsidx")	= contentsidx
		    Set contents_object(i) = contents_json
        next
    end if 

    oJson("lists") = contents_object

	'// 결과 출력
	IF (Err) then
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "처리중 오류가 발생했습니다.2"
	end if
else
	'// 로그인 필요
	oJson("response") = getErrMsg("9000",sFDesc)
	oJson("faildesc") =	sFDesc
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

if ERR then Call OnErrNoti()
On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->