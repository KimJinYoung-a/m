<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/event/renewal/mediaCls.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' Description : 리뉴얼 안내 페이지 박수
' History : 2021-03-16 정태훈 생성
'###############################################

'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

Dim vCidx , vUserId , vUserLevel , vDevice , vClickCount, myLikeCount, tmpMyLikeCount, result, deffNumber, maxLike 
dim sFDesc
Dim sData : sData = Request("json")
Dim oJson
dim ObjMedia , returnflag
Set oJson = jsObject()

vCidx = request("cIdx")
vDevice = request("device")
vClickCount = request("likeCount")

if IsUserLoginOK() Then
	vUserid = getEncLoginUserID
    vUserLevel = getLoginUserLevel
End If 

if vUserid = "" Then
	oJson("response") = "err"	
	oJson("faildesc") = "login"	
	oJson.flush
	Set oJson = Nothing	
	response.end
end if
if vClickCount = "" Then
	oJson("response") = "err"	
	oJson("faildesc") = "count"	
	oJson.flush
	Set oJson = Nothing	
	response.end
end if

'// json객체 선언
	
	set ObjMedia = new MediaCls

	maxLike = 30
	myLikeCount = ObjMedia.getMylikeCount(vUserid, vCidx)
	tmpMyLikeCount = myLikeCount + vClickCount

	if myLikeCount >= maxLike then 'max 모두 찼을경우
		myLikeCount = maxLike
	elseif tmpMyLikeCount > maxLike then '기존 + 넘어온 박수 개수가 max값 초과할경우
		myLikeCount = maxLike
		deffNumber = tmpMyLikeCount - maxLike
		result = ObjMedia.setContentsLikeCount(vCidx , vUserid , vUserLevel , vDevice , deffNumber)
	else	'정상일경우
		myLikeCount = tmpMyLikeCount
		deffNumber = vClickCount
		result = ObjMedia.setContentsLikeCount(vCidx , vUserid , vUserLevel , vDevice , deffNumber)
	end if		

	oJson("response") = "ok"	
	oJson("myLikeCount") = myLikeCount

	set ObjMedia = nothing

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
response.end
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->