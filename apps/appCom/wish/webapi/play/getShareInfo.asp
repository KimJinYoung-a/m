<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/webapi/play/getShareInfo.asp
' Discription : 플레이 상세형 공유 api
' Request : json > contents_pidx 
' Response : response > 결과 : tw , fb , kakao , pn , ln
' History : 2018-07-04 이종화
'###############################################

'//헤더 출력
response.charset = "utf-8"
Response.ContentType = "application/json"

Dim vPidx, sFDesc
Dim sData : sData = Request("json")
Dim oJson , vQuery
Dim titlename , listimage , contents
Dim shareTitle , shareImage , sharePre , shareLink

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
	vPidx = oResult.contents_pidx
set oResult = Nothing

Dim twitter_json , twitter_object
Dim facebook_json , facebook_object
Dim pinterrest_json , pinterrest_object
Dim kakaotalk_json , kakaotalk_object
Dim line_json , line_object

'// json객체 선언
Set oJson = jsObject()


IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다.1"

ElseIf Not isNumeric(vPidx) Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "리스트코드가 잘못 되었습니다."

Else

	vQuery = "SELECT titlename , listimage , contents FROM db_sitemaster.dbo.tbl_playlist WHERE pidx = "& vPidx &""
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		titlename = rsget("titlename")
		listimage = rsget("listimage")
		contents = rsget("contents")
	End IF
	rsget.close

	shareTitle	=	Server.URLEncode(titlename)
	sharePre	=	Server.URLEncode("10x10 Play")

	'// 결과 출력
	IF (Err) then
		oJson("response") = getErrMsg("9999",sFDesc)
		oJson("faildesc") = "처리중 오류가 발생했습니다.2"
	Else
		Set oJson("twitter") = jsObject()
			oJson("twitter")("funcname") = "shareTwitter"
			oJson("twitter")("title") = "["& sharePre &"]"& shareTitle &""
			oJson("twitter")("url") = ""& b64encode("http://m.10x10.co.kr/apps/appcom/wish/web2014/playwebview/detail.asp?pidx="&vPidx) &""

		Set oJson("facebook") = jsObject()
			oJson("facebook")("url") = ""& b64encode("http://m.10x10.co.kr/apps/appcom/wish/web2014/playwebview/detail.asp?pidx="&vPidx) &""

		'// 스펙미정 추후추가 개발 해야됨 2018-07-04 
		Set oJson("pinterrest") = jsObject()
			oJson("pinterrest")("title") = ""& titlename &""
			oJson("pinterrest")("image") = ""& b64encode(Trim(Replace(listimage,"//play","/play"))) &""
			oJson("pinterrest")("url") = ""& b64encode("http://m.10x10.co.kr/apps/appcom/wish/web2014/playwebview/detail.asp?pidx="&vPidx) &""

		Set oJson("kakaotalk") = jsObject()
			oJson("kakaotalk")("appurl") = ""& b64encode("url=http://m.10x10.co.kr/apps/appcom/wish/web2014/playwebview/detail.asp?pidx="& vPidx) &""
			oJson("kakaotalk")("desc") = ""& contents &""
			oJson("kakaotalk")("discountprice") = ""
			oJson("kakaotalk")("discountrate") = ""
			oJson("kakaotalk")("imageurl") = ""& b64encode(Trim(Replace(listimage,"//play","/play"))) &""
			oJson("kakaotalk")("mobileweburl") = ""& b64encode("http://m.10x10.co.kr") &""
			oJson("kakaotalk")("regularprice") = ""
			oJson("kakaotalk")("title") = ""& titlename &""
			oJson("kakaotalk")("type") = "etc"
			oJson("kakaotalk")("weburl") = ""& b64encode("http://www.10x10.co.kr") &""
		
		Set oJson("line") = jsObject()
			oJson("line")("title") = "["& sharePre &"]"& shareTitle &""
			oJson("line")("url") = ""& b64encode("http://m.10x10.co.kr/apps/appcom/wish/web2014/playwebview/detail.asp?pidx="&vPidx) &""

			oJson("url") = ""& b64encode("http://m.10x10.co.kr/apps/appcom/wish/web2014/playwebview/detail.asp?pidx="&vPidx) &""
	end if
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->