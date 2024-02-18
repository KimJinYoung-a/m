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
' PageName : /apps/appCom/wish/webapi/media/getContentsList.asp
' Discription : 미디어 플랫폼 메인 리스트
' Request : json > serviceCode , groupcode , sort , 
' Response : 
' History : 2019-05-29 이종화
'###############################################

'//헤더 출력
Response.ContentType = "application/json"
response.charset = "utf-8"

Dim vServiceCode , vGroupCode , vPage , vPageSize , vListType , vSortType , vUserid
dim sFDesc
Dim sData : sData = Request("json")
Dim oJson
dim ObjMedia , arrSwipeList , i , totalcount

dim mainimage , startdate , ctitle , groupname , likecount , contentsidx
dim mylikecount

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
    vGroupCode  = oResult.groupcode
    vPage       = oResult.page
    vPageSize   = oResult.pagesize
    vListType   = oResult.listtype
    vSortType   = oResult.sorttype
set oResult = Nothing

if IsUserLoginOK() Then
	vUserid = getEncLoginUserID
End If 

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
        ObjMedia.FrectListType      = vListType
        ObjMedia.FCurrpage          = vPage
        ObjMedia.FPageSize          = vPageSize
        ObjMedia.FrectServiceCode   = vServiceCode
        ObjMedia.FrectGroupCode     = vGroupCode
        ObjMedia.FrectSortMet       = vSortType
        ObjMedia.FrectUserId        = vUserid
		ObjMedia.getContentsPageListProc

        totalcount = ObjMedia.FTotalCount
	
        if totalcount > 0 then
            ReDim contents_object(ObjMedia.FResultCount-1)
            FOR i=0 to ObjMedia.FResultCount-1
                contentsidx  = ObjMedia.FItemList(i).Fcidx
                mainimage   = ObjMedia.FItemList(i).Fmainimage
                startdate   = ObjMedia.FItemList(i).Fstartdate
                ctitle      = ObjMedia.FItemList(i).Fctitle
                groupname   = ObjMedia.FItemList(i).Fgroupname
                likecount   = ObjMedia.FItemList(i).Flikecount
                mylikecount = ObjMedia.FItemList(i).Fmylikecount
                
                startdate = left(startdate,10)

                Set contents_json = jsObject()
                    contents_json("contentsidx")= contentsidx
                    contents_json("mainimage")	= mainimage
                    contents_json("ctitle")	    = ctitle
                    contents_json("groupname")	= groupname
                    contents_json("likecount")	= likecount
                    contents_json("isNew")		= chkiif(datediff("d", startdate, date()) < 3 , true , false)
                    contents_json("mylikecount")= mylikecount
                Set contents_object(i) = contents_json
            next
        end if 

    oJson("contentstotalcount") = totalcount
    oJson("contentslists") = contents_object

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
On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->