<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 바꿔방 이벤트 처리
' History : 2020-02-06 원승현
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
    
    Dim refer, mode, sqlstr, vQuery, vQuery1, LoginUserid, oJson, eCode, totalUserSelectItemPrice, userSelectItemId, vSub_Idx
    Dim tableItemId, tableItemPrice
    Dim lightItemId, lightItemPrice
    Dim wardrobeItemId, wardrobeItemPrice
    Dim bedItemId, bedItemPrice
    Dim beddingItemId, beddingItemPrice
    Dim chairItemId, chairItemPrice

    IF application("Svr_Info") = "Dev" THEN
        eCode = "90464"	
    Else
        eCode = "100420"
    End If

	refer 			= request.ServerVariables("HTTP_REFERER") '// 레퍼러
    mode        	= request("mode") '// 실행구분
    tableItemId     = request("tableItemId")
    tableItemPrice  = request("tableItemPrice")
    lightItemId  = request("lightItemId")
    lightItemPrice  = request("lightItemPrice")
    wardrobeItemId  = request("wardrobeItemId")
    wardrobeItemPrice  = request("wardrobeItemPrice")
    bedItemId  = request("bedItemId")
    bedItemPrice  = request("bedItemPrice")
    beddingItemId  = request("beddingItemId")
    beddingItemPrice  = request("beddingItemPrice")
    chairItemId  = request("chairItemId")
    chairItemPrice  = request("chairItemPrice")

    Set oJson = jsObject()

    LoginUserid = getEncLoginUserID()

	If InStr(refer, "10x10.co.kr") < 1 Then
		oJson("response") = "err"
		oJson("faildesc") = "잘못된 접속입니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	End If

    Select Case Trim(mode)
        Case "add"
            if Not(IsUserLoginOK) Then
                oJson("response") = "err"
                oJson("faildesc") = "로그인 후 응모하실 수 있습니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            end if

            '// 6개의 상품을 다 등록했는지 확인한다.
            If tableItemId <>"" And tableItemPrice <> "" And lightItemId <> "" And lightItemPrice <> "" And wardrobeItemId <> "" And wardrobeItemPrice <> "" And bedItemId <> "" And bedItemPrice <> "" And beddingItemId <> "" And beddingItemPrice <> "" And chairItemId <> "" And chairItemPrice <> "" Then
                '// 해당 이벤트는 한번만 등록할 수 있다.
                sqlstr = " SELECT sub_idx FROM db_event.dbo.tbl_event_subscript WITH(NOLOCK) "
                sqlstr = sqlstr & " WHERE evt_code='"&eCode&"'  AND userid='"&LoginUserid&"' "
                rsget.Open sqlstr, dbget, adOpenForwardOnly,adLockReadOnly
                If Not rsget.Eof Then
                    oJson("response") = "err"
                    oJson("faildesc") = "바꿔 방 이벤트는 한번만 응모하실 수 있습니다."
                    oJson.flush
                    Set oJson = Nothing
                    dbget.close() : Response.End
                End If
                rsget.Close

                '// 사용자가 선택한 상품의 총 금액 계산
                totalUserSelectItemPrice = CLng(tableItemPrice)+CLng(lightItemPrice)+CLng(wardrobeItemPrice)+CLng(bedItemPrice)+CLng(beddingItemPrice)+CLng(chairItemPrice)

                '// 사용자가 선택한 상품
                userSelectItemId = tableItemId&"|"&lightItemId&"|"&wardrobeItemId&"|"&bedItemId&"|"&beddingItemId&"|"&chairItemId

                '// 이벤트 테이블에 내역을 남긴다.
                vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & LoginUserid & "', '"&totalUserSelectItemPrice&"', '"&userSelectItemId&"', 'A')"
                dbget.Execute vQuery

                '// 등록한 이벤트 내역의 sub_idx값을 가져온다.
                vQuery1 = " SELECT SCOPE_IDENTITY() "
                rsget.Open vQuery1,dbget
                IF Not rsget.EOF THEN
                    vSub_Idx = rsget(0)
                END IF
                rsget.close

                '// sub_idx validation 체크
                If vSub_Idx = "" Then
                    oJson("response") = "err"
                    oJson("faildesc") = "오류가 발생하였습니다."
                    oJson.flush
                    Set oJson = Nothing
                    dbget.close() : Response.End
                End If

                '// 사용자가 입력한 상품정보를 넣는다.
                Call fnChangeRoomItemInsert(eCode, vSub_Idx, "table", tableItemId, tableItemPrice, LoginUserid) '// 테이블
                Call fnChangeRoomItemInsert(eCode, vSub_Idx, "light", lightItemId, lightItemPrice, LoginUserid) '// 조명
                Call fnChangeRoomItemInsert(eCode, vSub_Idx, "wardrobe", wardrobeItemId, wardrobeItemPrice, LoginUserid) '// 옷장
                Call fnChangeRoomItemInsert(eCode, vSub_Idx, "bed", bedItemId, bedItemPrice, LoginUserid) '// 침대
                Call fnChangeRoomItemInsert(eCode, vSub_Idx, "bedding", beddingItemId, beddingItemPrice, LoginUserid) '// 페브릭
                Call fnChangeRoomItemInsert(eCode, vSub_Idx, "chair", chairItemId, chairItemPrice, LoginUserid) '// 의자
            Else
                oJson("response") = "err"
                oJson("faildesc") = "카테고리별 상품을 전부 등록하셔야 응모하실 수 있습니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            End If

            oJson("response") = "ok"
            oJson("totalUserSelectItemPrice") = totalUserSelectItemPrice
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End

        Case Else
            oJson("response") = "err"
            oJson("faildesc") = "오류가 발생하였습니다."
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
    End Select

	Function fnChangeRoomItemInsert(ByVal evt_code, ByVal Sub_Idx, ByVal category, ByVal ItemId, ByVal ItemPrice, ByVal LoginUserid)
		dim sqlStr
		sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_EventUserItemSelect](sub_idx, evt_code, category, itemid, sellcash, userid)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& Sub_Idx &","&evt_code&",'"&category&"',"&itemid&","&ItemPrice&",'"& LoginUserid & "')" + vbcrlf
		dbget.execute sqlstr
	End Function        

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
