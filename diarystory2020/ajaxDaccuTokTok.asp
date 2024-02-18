<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 다이어리 스토리 2020 다꾸톡톡 작성 처리
' History : 2019-09-09 원승현
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
    dim refer, mode, sqlstr, ImageUrl, LoginUserid, vMasterIdx, oJson, daccuTokModeTemp
    dim clickInsertItemId, MasterIdxUseItem, posX, posY, clickInsertItemOption, daccuTokMasterIdx, daccuTokProcTitle
	refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
    mode        = request("daccuTokMode")
    ImageUrl    = request("daccuTokMainImageUrl")

    clickInsertItemId = request("clickInsertItemId") '// 구매 상품 리스트에서 클릭한 상품코드값
    clickInsertItemOption = request("clickInsertItemOption") '// 구매 상품 리스트에서 클릭한 상품의 옵션코드
    MasterIdxUseItem = request("MasterIdxUseItem") '// 구매 상품 리스트에서 넘어오는 MasterIDX값
    posX = request("posX") '// 위치값(가로)
    posY = request("posY") '// 위치값(세로)
    daccuTokMasterIdx = request("daccuTokMasterIdx")
    daccuTokProcTitle = request("daccuTokProcTitle")

    '// 레이어 팝업때문에..
    If Trim(request("daccuTokModeTemp"))<>"" Then
        mode = request("daccuTokModeTemp")
    End If

    Set oJson = jsObject()

    LoginUserid = getEncLoginUserID()

	If InStr(refer, "10x10.co.kr") < 1 Then
		'oJson("response") = "err"
		'oJson("faildesc") = "잘못된 접속입니다."
		'oJson.flush
		'Set oJson = Nothing
		'dbget.close() : Response.End
	End If

    Select Case Trim(mode)
        Case "ImageProc"
            if Not(IsUserLoginOK) Then			 			
                oJson("response") = "err"
                oJson("faildesc") = "로그인 후 등록하실 수 있습니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            end if	

            '// 일단 임시 저장
            sqlstr = "insert into [db_sitemaster].[dbo].tbl_ImageLinkUser_Master" & vbcrlf
			sqlstr = sqlstr & " (Image,UserId,IsUsing,RegDate,LastUpDate,ViewCount)" & vbcrlf
			sqlstr = sqlstr & " VALUES ('"&ImageUrl&"','"&LoginUserid&"','N',getdate(),getdate(),0)	"
			dbget.execute sqlstr

			sqlstr = "select IDENT_CURRENT('[db_sitemaster].[dbo].tbl_ImageLinkUser_Master') as masterIdx"
			rsget.CursorLocation = adUseClient
			rsget.Open sqlstr,dbget,adOpenForwardOnly,adLockReadOnly
			If Not Rsget.Eof then
				vMasterIdx = rsget("masterIdx")
			end if
			rsget.close

            oJson("response") = "ok"
            oJson("MasterIdx") = vMasterIdx
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End

        Case "DetailItemProc"
            if Not(IsUserLoginOK) Then			 			
                oJson("response") = "err"
                oJson("faildesc") = "로그인 후 등록하실 수 있습니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            end if	

            '// 마스터가 이미 등록된 상태이므로 Detail은 그냥 넣음
            sqlstr = "insert into [db_sitemaster].[dbo].tbl_ImageLinkUser_Detail" & vbcrlf
			sqlstr = sqlstr & " (MasterIdx,XValue,YValue,ItemID,ItemOption,IconType,IsUsing,UserID,RegDate,LastUpDate)" & vbcrlf
			sqlstr = sqlstr & " VALUES ('"&MasterIdxUseItem&"','"&posX&"','"&posY&"','"&clickInsertItemId&"','"&clickInsertItemOption&"',1,'Y','"&LoginUserid&"',getdate(),getdate())	"
			dbget.execute sqlstr
            oJson("response") = "ok"
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End

        Case "daccuProc"
            if Not(IsUserLoginOK) Then			 			
                oJson("response") = "err"
                oJson("faildesc") = "로그인 후 등록하실 수 있습니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            end if

            if trim(daccuTokMasterIdx)="" Then
                oJson("response") = "err"
                oJson("faildesc") = "정상적인 경로로 접근해 주세요."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            End if

            '// 최종 업데이트
            sqlstr = "update [db_sitemaster].[dbo].tbl_ImageLinkUser_Master" & vbcrlf
			sqlstr = sqlstr & " set IsUsing='Y', title='"&daccuTokProcTitle&"' " & vbcrlf
			sqlstr = sqlstr & " Where idx='"&daccuTokMasterIdx&"'	"
			dbget.execute sqlstr

            oJson("response") = "ok"
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End

        Case "daccuDelete"
            if Not(IsUserLoginOK) Then			 			
                oJson("response") = "err"
                oJson("faildesc") = "로그인 후 삭제하실 수 있습니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            end if

            if trim(daccuTokMasterIdx)="" Then
                oJson("response") = "err"
                oJson("faildesc") = "정상적인 경로로 접근해 주세요."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            End if

            '// 최종 업데이트
            sqlstr = "update [db_sitemaster].[dbo].tbl_ImageLinkUser_Master" & vbcrlf
			sqlstr = sqlstr & " set IsUsing='N', title='"&daccuTokProcTitle&"' " & vbcrlf
			sqlstr = sqlstr & " Where idx='"&daccuTokMasterIdx&"'	"
			dbget.execute sqlstr

            oJson("response") = "ok"
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End

    End Select

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->