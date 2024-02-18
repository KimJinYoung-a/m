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
'Dim sData : sData = Request("json")
Dim oJson
dim ObjMedia , i , arrItems, folderName

dim itemid , basicimage , tentenimage400 , itemname , evalcnt , wishcnt , totalpoint , sellyn , limityn , limitno , limitsold, isWishItem
dim wishItemList, wishItemStr

'// Body Data 접수
'If Request.TotalBytes > 0 Then
'    Dim lngBytesCount
'        lngBytesCount = Request.TotalBytes
'    sData = BinaryToText(Request.BinaryRead(lngBytesCount),"UTF-8")
'End If

'// 전송결과 파징
on Error Resume Next

dim oResult
'set oResult = JSON.parse(sData)
	vContentsidx = request("cidx")
	folderName = request("folderName")
set oResult = Nothing

'임시
folderName = "텐플루언서"

'//상품후기 총점수 %로 환산
function fnEvalTotalPointAVG(t,g)
	dim vTmp
	vTmp = 0
	If t <> "" Then
		If isNumeric(t) Then
			If t > 0 Then
				If g = "search" Then
					vTmp = (t/5)
				Else
					vTmp = ((Round(t,2) * 100)/5)
				End If
				vTmp = Round(vTmp)
			End If
		End If
	End If
	fnEvalTotalPointAVG = vTmp
end function

public Function IsSoldOut(sellyn , limityn , limitno ,limitsold) 
    IF limitno<>"" and limitsold<>"" Then
        isSoldOut = (sellyn<>"Y") or ((limityn = "Y") and (clng(limitno)-clng(limitsold)<1))
    Else
        isSoldOut = (sellyn<>"Y")
    End If
end Function

'//일시품절 여부 '2008/07/07 추가 '!
public Function isTempSoldOut(sellyn) 
    isTempSoldOut = (sellyn="S")
end Function 

'// json객체 선언
SET oJson = jsObject()
Dim contents_json , contents_object

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다.1"

ElseIf Not isNumeric(vContentsidx) Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "컨텐츠 IDX가 잘못 되었습니다."

elseif vContentsidx <> "" Then
	
	set ObjMedia = new MediaCls
		arrItems = ObjMedia.getContentsItemsList(vContentsidx)
		wishItemList = ObjMedia.getMyMediaWishList(GetEncLoginUserID(), folderName)
	set ObjMedia = nothing

	if isarray(wishItemList) then
		for i = 0 to ubound(wishItemList,2)
			wishItemStr = wishItemStr & wishItemList(0,i) & "|" 
		next
	end if

    if isarray(arrItems) then
        ReDim contents_object(ubound(arrItems,2))
        for i = 0 to ubound(arrItems,2)
            itemid          = arrItems(0,i)
            basicimage      = webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(itemid)) + "/" + db2Html(arrItems(1,i))
            tentenimage400  = webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(itemid)) + "/" + db2Html(arrItems(2,i))
            itemname        = arrItems(3,i)
            evalcnt         = arrItems(4,i)
            wishcnt         = arrItems(5,i)
            totalpoint      = arrItems(6,i)

            sellyn          = arrItems(7,i)
            limityn         = arrItems(8,i)
            limitno         = arrItems(9,i)
            limitsold       = arrItems(10,i)
			if InStr(wishItemStr, itemid) > 0 then
				isWishItem		= true
			else
				isWishItem		= false
			end if			
            Set contents_json = jsObject()
                contents_json("itemid")         = itemid
                contents_json("itemimage")	    = chkiif(arrItems(2,i) = "" or isnull(arrItems(2,i)) , basicimage , tentenimage400)
                contents_json("itemname")	    = itemname
                contents_json("totalpoint")		= fnEvalTotalPointAVG(totalpoint,"search")
                contents_json("wishcnt")        = wishcnt
                contents_json("linkurl")		= "/category/category_itemprd.asp?itemid="&itemid
                contents_json("issoldout")      = chkiif(IsSoldOut(sellyn , limityn , limitno ,limitsold) or isTempSoldOut(sellyn) , true , false )
				contents_json("isWishItem")      = isWishItem				
		    Set contents_object(i) = contents_json
        next
    end if 

	if isarray(arrItems) then
		oJson("relatedProducts") = contents_object
	else
		set oJson("relatedProducts") = jsArray()   
	end if
    
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