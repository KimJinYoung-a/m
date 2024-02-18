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
' PageName : /apps/appCom/wish/webapi/media/getContentsItemsList.asp
' Discription : 미디어 플랫폼 상세 아이템 리스트
' Request : json > serviceCode , groupcode , sort , 
' Response : 
' History : 2019-05-29 이종화
'###############################################

'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

Dim vContentsidx 
dim sFDesc
Dim sData : sData = Request("json")
Dim oJson
dim ObjMedia , i , arrItems

'// Body Data 접수
'If Request.TotalBytes > 0 Then
'    Dim lngBytesCount
'        lngBytesCount = Request.TotalBytes
'    sData = BinaryToText(Request.BinaryRead(lngBytesCount),"UTF-8")
'End If

'// 전송결과 파징
'on Error Resume Next

dim oResult
'set oResult = JSON.parse(sData)
	vContentsidx = request("cidx")
set oResult = Nothing

'// json객체 선언
SET oJson = jsObject()
Dim contents_json , contents_object, myLikeCount

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다.1"

ElseIf Not isNumeric(vContentsidx) Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "컨텐츠 IDX가 잘못 되었습니다."

elseif vContentsidx <> "" Then
	
	set ObjMedia = new MediaCls
        ObjMedia.FrectCidx = vContentsidx
		ObjMedia.getOneContents

        myLikeCount = ObjMedia.getmyLikeCount(GetEncLoginUserID(), vContentsidx)        
        if myLikeCount = "" then myLikeCount = 0

        Set oJson = jsObject()
        set oJson("contentsDetails") = jsObject()            
            oJson("contentsDetails")("mainImage")      = ObjMedia.FOneItem.Fmainimage
            oJson("contentsDetails")("isNew")          = chkiif(datediff("d", left(ObjMedia.FOneItem.Fstartdate,10) , date()) < 3 , true , false)
            oJson("contentsDetails")("contentsTitle")  = ObjMedia.FOneItem.Fctitle
            oJson("contentsDetails")("contentsText")   = ObjMedia.FOneItem.Fctext
            oJson("contentsDetails")("viewCount")      = ObjMedia.FOneItem.Fviewcount
            oJson("contentsDetails")("likeCount")      = ObjMedia.FOneItem.Flikecount
            oJson("contentsDetails")("videoUrl")       = ObjMedia.FOneItem.Fvideourl
            oJson("contentsDetails")("addonEventImage1")= chkiif(isnull(ObjMedia.FOneItem.Fevtlinkimage1), "",  ObjMedia.FOneItem.Fevtlinkimage1) 
            oJson("contentsDetails")("addonEventCode1") = chkiif(isnull(ObjMedia.FOneItem.Fevtlinkcode1), 0,  ObjMedia.FOneItem.Fevtlinkcode1)
            oJson("contentsDetails")("addonEventImage2")= chkiif(isnull(ObjMedia.FOneItem.Fevtlinkimage2), "",  ObjMedia.FOneItem.Fevtlinkimage2)
            oJson("contentsDetails")("addonEventCode2") = chkiif(isnull(ObjMedia.FOneItem.Fevtlinkcode2), 0,  ObjMedia.FOneItem.Fevtlinkcode2)
            oJson("contentsDetails")("addonEventImage3")= chkiif(isnull(ObjMedia.FOneItem.Fevtlinkimage3), "",  ObjMedia.FOneItem.Fevtlinkimage3)
            oJson("contentsDetails")("addonEventCode3") = chkiif(isnull(ObjMedia.FOneItem.Fevtlinkcode3), 0,  ObjMedia.FOneItem.Fevtlinkcode3)
            oJson("contentsDetails")("addonEventImage4")= chkiif(isnull(ObjMedia.FOneItem.Fevtlinkimage4), "",  ObjMedia.FOneItem.Fevtlinkimage4)
            oJson("contentsDetails")("addonEventCode4") = chkiif(isnull(ObjMedia.FOneItem.Fevtlinkcode4), 0,  ObjMedia.FOneItem.Fevtlinkcode4)
            oJson("contentsDetails")("addonEventImage5")= chkiif(isnull(ObjMedia.FOneItem.Fevtlinkimage5), "",  ObjMedia.FOneItem.Fevtlinkimage5)
            oJson("contentsDetails")("addonEventCode5")  = chkiif(isnull(ObjMedia.FOneItem.Fevtlinkcode5), 0,  ObjMedia.FOneItem.Fevtlinkcode5)            
            oJson("contentsDetails")("groupName")      = ObjMedia.FOneItem.Ftitlename
            oJson("contentsDetails")("profile")        = ObjMedia.FOneItem.Fprofile
            oJson("contentsDetails")("profileImage")   = ObjMedia.FOneItem.Fprofileimage
            oJson("contentsDetails")("commentEventCode")   = ObjMedia.FOneItem.Fcommenteventid
            oJson("contentsDetails")("myLikeCount")   = myLikeCount
            oJson("contentsDetails")("isLogin") = IsUserLoginOK            
    set ObjMedia = nothing

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
'On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
