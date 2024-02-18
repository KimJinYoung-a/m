<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbEVTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV3/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/todayshoppingcls.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/protoV3/getRecentViewInSearchPage.asp
' Discription : 검색창에 표시될 최근 본 상품
' Request : json > 
' Response : response > 결과, screengubun, screenmasking, tags[keyword,type,url,code]
' History : 2018.10.11 원승현 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "application/json"

Dim sFDesc, oList, oItems
Dim sType, sUserId, sItemId, sIdx
Dim sData : sData = Request.form("json")
Dim oJson, sqlStr, sMaxId, dChkCnt

'sData = "{""type"":""deletehistoryitem"",""user_id"":""10x10blue"",""item_id"":""786868"",""idx"":""17491""}"
'sData = "{""type"":""gethistoryitemlist"",""user_id"":""10x10blue""}"

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
    If oResult.hasOwnProperty("type") Then
	    sType			= oResult.type
    End If
    If oResult.hasOwnProperty("user_id") Then
	    sUserId	    	= requestCheckVar(oResult.user_id,32)
    End If
    '// 삭제일경우에만 넘어온다.
    If trim(sType)="deletehistoryitem" Then
        If oResult.hasOwnProperty("item_id") Then
	        sItemId			= requestCheckVar(oResult.item_id,50)
        End If
        If oResult.hasOwnProperty("idx") Then
            sIdx            = requestCheckVar(oResult.idx,50)
        End If
    End If   
set oResult = Nothing

'// Type 체크
If Not(trim(sType)="gethistoryitemlist" or trim(sType)="deletehistoryitem") Then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "Type이 일치하지 않습니다."
    oJson.flush
    Set oJson = Nothing
    response.end
End If

'// 유저아이디 체크
If trim(sUserId) = "" Then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "유저 아이디가 없습니다."
    oJson.flush
    Set oJson = Nothing
    response.end
End If

'// 삭제일경우 필요한 값 체크
If Trim(sType)="deletehistoryitem" Then
    If Trim(sItemId)="" Then
        Set oJson = jsObject()
        oJson("response") = getErrMsg("9999",sFDesc)
        oJson("faildesc") = "상품코드가 없습니다."
        oJson.flush
        Set oJson = Nothing
        response.end
    End If

    If Trim(sIdx)="" Then
        Set oJson = jsObject()
        oJson("response") = getErrMsg("9999",sFDesc)
        oJson("faildesc") = "Idx값이 없습니다."
        oJson.flush
        Set oJson = Nothing
        response.end
    End If
End If

'// 최근 본 상품 리스트 호출
If sType="gethistoryitemlist" Then
    sqlStr = "select max(idx) "
    sqlStr = sqlStr + " from [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] with (nolock) "
    sqlStr = sqlStr + " where userid = '"&sUserId&"' "
    rsEVTget.Open sqlStr,dbEVTget,1
        sMaxId = rsEVTget(0)
    rsEVTget.close

    '// json객체 선언
    Set oJson = jsObject()

    Dim myRecentView, lp
    Set myRecentView = new CTodayShopping
    myRecentView.FRecttypeitem        = true
    myRecentView.FRecttypeevt        = false
    myRecentView.FRecttypemkt     = false
    myRecentView.FRecttypebrand   = false
    myRecentView.FRecttyperect   = false
    myRecentView.FRectUserid   = sUserId
    myRecentView.FRectmaxid   = sMaxId
    myRecentView.FRectstdnum   = 1
    myRecentView.FRectpagesize   = 20
    myRecentView.FRectplatform   = ""
    myRecentView.GetMyViewRecentViewList

    set oList = jsArray()
    If myRecentView.FResultCount>0 Then   
        For lp=0 To myRecentView.FResultCount-1
            Set oItems = jsObject()
            oItems("idx") = cStr(myRecentView.FItemList(lp).FIdx)
            oItems("name") = myRecentView.FItemList(lp).FItemName
            oItems("imageurl") = b64encode(myRecentView.FItemList(lp).FImageicon1)
            oItems("url") = b64encode(mDomain &"/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid="&myRecentView.FItemList(lp).FItemId)
            oItems("price") = FormatNumber(myRecentView.FItemList(lp).getRealPrice,0)
            IF myRecentView.FItemList(lp).IsSaleItem Then
                oItems("sale") = myRecentView.FItemList(lp).getSalePro
            Else
                oItems("sale") = ""
            End If
            oItems("itemid") = cStr(myRecentView.FItemList(lp).FItemId)
            set oList(null) = oItems
            Set oItems = Nothing
        Next
    End If

    oJson("response") = getErrMsg("1000",sFDesc)
    set oJson("items") = oList

    'Json 출력(JSON)
    oJson.flush
    Set oJson = Nothing
    Set oList = Nothing
End If

'// 최근 본 상품 삭제
If Trim(sType)="deletehistoryitem" Then
    sqlStr = "select count(idx) "
    sqlStr = sqlStr + " from [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] with (nolock) "
    sqlStr = sqlStr + " where userid = '"&sUserId&"' And type='item' And idx = '"&sIdx&"' And itemid='"&sItemId&"' "
    rsEVTget.Open sqlStr,dbEVTget,1
        dChkCnt = rsEVTget(0)
    rsEVTget.close

    If dChkCnt > 0 Then
        sqlStr = " Delete From [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] "
        sqlStr = sqlStr & " Where userid='"&sUserId&"' And type='item' And idx = '"&sIdx&"' And itemid='"&sItemId&"' "
        dbEVTget.execute sqlStr
        Set oJson = jsObject()
        oJson("response") = getErrMsg("1000",sFDesc)
        oJson("idx") = sIdx
        oJson.flush
        Set oJson = Nothing        
    Else
        Set oJson = jsObject()
        oJson("response") = getErrMsg("9999",sFDesc)
        oJson("faildesc") = "삭제할 상품이 없습니다."
        oJson.flush
        Set oJson = Nothing
    End If
End If

IF (Err) then
    Set oJson = jsObject()
    oJson("response") = getErrMsg("9999",sFDesc)
    oJson("faildesc") = "처리중 오류가 발생했습니다."
    oJson.flush
    Set oJson = Nothing
End if

if ERR then Call OnErrNoti()		'// 오류 이메일로 발송
On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<!-- #include virtual="/lib/db/dbEVTclose.asp" -->