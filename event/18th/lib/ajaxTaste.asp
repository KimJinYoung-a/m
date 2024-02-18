<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 18주년 취향 이벤트 처리
' History : 2019-09-25 원승현
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
    dim refer, mode, sqlstr, LoginUserid, oJson
    dim tasteItemId, tasteviewIdx, masterIdx, chasu, currentdate, foldername
    dim vFidx '// 위시 폴더 idx값
    dim vFolderCheck '// 해당 폴더가 존재하는지
    dim vRewardStatus '// 오늘날짜가 아니면 나의 취향 등록 시 리워드 안줌
    Dim objCmd '// 쿠폰발급용
    Dim rewardValue '// 할인 쿠폰 % 값
    Dim rewardReturnValue '// 할인 쿠폰 발급 return value값
    Dim todayDate '// 오늘날짜
	refer 			= request.ServerVariables("HTTP_REFERER") '// 레퍼러
    mode        	= request("mode") '// 실행구분
    tasteItemId 	= request("tasteItemId") '// 사용자가 선택한 취향 itemid값
	tasteviewIdx 	= request("tasteviewIdx")	'// 표시순서
    masterIdx   	= request("masterIdx") '// 사용자가 입력하는 master 주제 idx값
    chasu       	= request("chasu") '// 사용자가 입력하는 master chasu 값
    currentdate 	= request("currentdate") '// 사용자가 입력할때 보고 있는 페이지의 currentdate값

	if tasteviewIdx="" then
		tasteviewIdx = "-1"
	end if

    Set oJson = jsObject()

    LoginUserid = getEncLoginUserID()

	If InStr(refer, "10x10.co.kr") < 1 Then
		'oJson("response") = "err"
		'oJson("faildesc") = "잘못된 접속입니다."
		'oJson.flush
		'Set oJson = Nothing
		'dbget.close() : Response.End
	End If

    rewardValue = 5

    '// 오늘날짜
    todayDate = Left(now(), 10)

    Select Case Trim(mode)
        Case "add"
            if Not(IsUserLoginOK) Then
                oJson("response") = "err"
                oJson("faildesc") = "로그인 후 등록하실 수 있습니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            end if

            '// 해당 차수에는 상품 한개만 등록할 수 있다.
            sqlstr = " SELECT idx FROM db_sitemaster.dbo.tbl_18thTasteEvent_Detail WITH(NOLOCK) "
            sqlstr = sqlstr & " WHERE chasu='"&chasu&"' AND masterIdx='"&masterIdx&"' AND userid='"&LoginUserid&"' "
            rsget.Open sqlstr, dbget, adOpenForwardOnly,adLockReadOnly
            If Not rsget.Eof Then
                oJson("response") = "err"
                oJson("faildesc") = "오늘의 취향은 하루에 한번만 등록하실 수 있습니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            End If
            rsget.Close

            '// 해당 일자 Detail를 넣는다.
            sqlstr = "insert into [db_sitemaster].[dbo].tbl_18thTasteEvent_Detail" & vbcrlf
			sqlstr = sqlstr & " (masterIdx, chasu, userID, itemID, viewIdx, isUsing, regDate, lastUpDate)" & vbcrlf
			sqlstr = sqlstr & " VALUES ('"&masterIdx&"','"&chasu&"','"&LoginUserid&"','"&tasteItemId&"','"&tasteviewIdx&"','Y',getdate(),getdate())	"
			dbget.execute sqlstr

            '// 위시 등록
                '// 1. 현재 해당 유저에게 나의취향이라는 위시 폴더가 있는지 확인
                foldername = "나의취향"
                sqlstr = "Select TOP 1 fidx From [db_my10x10].[dbo].[tbl_myfavorite_folder] WITH(NOLOCK) WHERE foldername = '" & trim(foldername) & "' and userid='" & LoginUserid & "' "
                sqlstr = sqlstr & " ORDER BY fidx DESC "
                rsget.Open sqlstr, dbget, adOpenForwardOnly,adLockReadOnly
                If Not rsget.Eof Then
                    vFidx = rsget("fidx")
                    vFolderCheck = true
                Else
                    vFidx = ""
                    vFolderCheck = False
                End If
                rsget.Close

                '// 2. 해당 폴더가 없는 경우 폴더를 생성하고, fidx값을 가져온다.(원래 20개까지만 생성이지만 넘치는 인원이 있을경우도 있으므로 그냥 수동으로 입력함)
                If Not(vFolderCheck) Then
                    sqlstr = " INSERT INTO [db_my10x10].[dbo].[tbl_myfavorite_folder] "
                    sqlstr = sqlstr & " (userid, foldername, viewisusing, sortno) "
                    sqlstr = sqlstr & " VALUES ('"&LoginUserid&"','"&trim(foldername)&"','Y',0) "
                    dbget.execute sqlstr

                    '// 입력한 폴더의 idx값을 가져옴
                    sqlstr = "select IDENT_CURRENT('[db_my10x10].[dbo].[tbl_myfavorite_folder]') as fidx"
                    rsget.CursorLocation = adUseClient
                    rsget.Open sqlstr,dbget,adOpenForwardOnly,adLockReadOnly
                    If Not Rsget.Eof then
                        vFidx = rsget("fidx")
                        vFolderCheck = true
                    Else
                        '여기서 데이터가 없으면 뭔가 잘못된거임
                        oJson("response") = "err"
                        oJson("faildesc") = "오류가 발생하였습니다. 다시 시도해주세요."
                        oJson.flush
                        Set oJson = Nothing
                        dbget.close() : Response.End
                    end if
                    rsget.close
                End If

                '// 3. 해당 아이템 해당 폴더에 저장
                If vFolderCheck Then
                    sqlStr = " IF NOT EXISTS (SELECT * FROM db_my10x10.dbo.tbl_myfavorite WITH(NOLOCK) WHERE userid = '" + LoginUserid + "' AND itemid='"&tasteItemId&"' AND fidx='"&vFidx&"') BEGIN " + vbCrlf
                    sqlStr = sqlStr + " 	insert into db_my10x10.dbo.tbl_myfavorite(userid, itemid, regdate, fidx, viewIsUsing) " + vbCrlf
                    sqlStr = sqlStr + " 		values ('" & LoginUserid & "', " & tasteItemId & ", getdate(), " & vFidx & " , 'N')" + vbCrlf
                    sqlStr = sqlStr + " END "
                    dbget.Execute sqlStr
                Else
                    oJson("response") = "err"
                    oJson("faildesc") = "오류가 발생하였습니다. 다시 시도해주세요."
                    oJson.flush
                    Set oJson = Nothing
                    dbget.close() : Response.End
                End If

            '// 사용자 리워드를 준다.(해당 상품코드 대비 추가할인 상품 쿠폰 발급)(아직 개발전 허팀장님에게 프로시저 나오면 그거 호출하면됨)
            '// 오늘날짜가 아니면 리워드 안줌
            If currentdate = left(todayDate, 10) Then
                Set objCmd = Server.CreateObject("ADODB.COMMAND")
                With objCmd
                    .ActiveConnection = dbget
                    .CommandType = adCmdText
                    .CommandText = "{?= call db_item.[dbo].[usp_WWW_ItemCoupon_Appointer_Add]('"&LoginUserid&"',"&tasteItemId&","&rewardValue&")}"
                    .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
                    .Execute, , adExecuteNoRecords
                    End With
                    rewardReturnValue = objCmd(0).Value
                Set objCmd = Nothing
                If rewardReturnValue=0 Then
                    '// 쿠폰 발급시 오류가 난거임
                    vRewardStatus = 2
                    sqlstr = "insert into db_log.[dbo].[tbl_caution_event_log] (evt_code, userid, refip, value1 , value2, value3, device ) values " &_
                        " ('97587' " &_
                        ", '"& LoginUserid &"' " &_
                        ", '"& Left(request.ServerVariables("REMOTE_ADDR"),32) & "' " &_
                        ", '"& rewardReturnValue &"' " &_
                        ", '' " &_
                        ", '' " &_
                        ", 'A') "
                    dbget.Execute sqlstr
                Else
                    '// 리워드 제공
                    vRewardStatus = 1
                End If
            Else
                '// 리워드 안줌
                vRewardStatus = 0
            End If
            oJson("response") = "ok"
            oJson("currentdate") = currentdate
            oJson("rewardstatus") = vRewardStatus
            oJson("rewardvalue") = rewardValue
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End

        '// 타인의 취향 위시 넣기
        Case "otherWishAdd"
            if Not(IsUserLoginOK) Then
                oJson("response") = "err"
                oJson("faildesc") = "로그인 후 등록하실 수 있습니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            end if

            If Trim(tasteItemId) = "" Then
                oJson("response") = "err"
                oJson("faildesc") = "정상적인 경로로 접근해주세요."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            End If


            '// 1. 현재 해당 유저에게 타인의취향 이라는 위시 폴더가 있는지 확인
            foldername = "타인의취향"
            sqlstr = "Select TOP 1 fidx From [db_my10x10].[dbo].[tbl_myfavorite_folder] WITH(NOLOCK) WHERE foldername = '" & trim(foldername) & "' and userid='" & LoginUserid & "' "
            sqlstr = sqlstr & " ORDER BY fidx DESC "
            rsget.Open sqlstr, dbget, adOpenForwardOnly,adLockReadOnly
            If Not rsget.Eof Then
                vFidx = rsget("fidx")
                vFolderCheck = true
            Else
                vFidx = ""
                vFolderCheck = False
            End If
            rsget.Close

            '// 2. 해당 폴더가 없는 경우 폴더를 생성하고, fidx값을 가져온다.(원래 20개까지만 생성이지만 넘치는 인원이 있을경우도 있으므로 그냥 수동으로 입력함)
            If Not(vFolderCheck) Then
                sqlstr = " INSERT INTO [db_my10x10].[dbo].[tbl_myfavorite_folder] "
                sqlstr = sqlstr & " (userid, foldername, viewisusing, sortno) "
                sqlstr = sqlstr & " VALUES ('"&LoginUserid&"','"&trim(foldername)&"','Y',0) "
                dbget.execute sqlstr

                '// 입력한 폴더의 idx값을 가져옴
                sqlstr = "select IDENT_CURRENT('[db_my10x10].[dbo].[tbl_myfavorite_folder]') as fidx"
                rsget.CursorLocation = adUseClient
                rsget.Open sqlstr,dbget,adOpenForwardOnly,adLockReadOnly
                If Not Rsget.Eof then
                    vFidx = rsget("fidx")
                    vFolderCheck = true
                Else
                    '여기서 데이터가 없으면 뭔가 잘못된거임
                    oJson("response") = "err"
                    oJson("faildesc") = "오류가 발생하였습니다. 다시 시도해주세요."
                    oJson.flush
                    Set oJson = Nothing
                    dbget.close() : Response.End
                end if
                rsget.close
            End If

            '// 3. 해당 아이템 해당 폴더에 저장
            If vFolderCheck Then
                sqlStr = " IF NOT EXISTS (SELECT * FROM db_my10x10.dbo.tbl_myfavorite WITH(NOLOCK) WHERE userid = '" + LoginUserid + "' AND itemid='"&tasteItemId&"' AND fidx='"&vFidx&"') BEGIN " + vbCrlf
                sqlStr = sqlStr + " 	insert into db_my10x10.dbo.tbl_myfavorite(userid, itemid, regdate, fidx, viewIsUsing) " + vbCrlf
                sqlStr = sqlStr + " 		values ('" & LoginUserid & "', " & tasteItemId & ", getdate(), " & vFidx & " , 'N')" + vbCrlf
                sqlStr = sqlStr + " END "
                dbget.Execute sqlStr
            Else
                oJson("response") = "err"
                oJson("faildesc") = "오류가 발생하였습니다. 다시 시도해주세요."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            End If

            oJson("response") = "ok"
            oJson("currentdate") = currentdate
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End

        '// 타인의 취향 위시 삭제
        Case "otherWishDelete"

            if Not(IsUserLoginOK) Then
                oJson("response") = "err"
                oJson("faildesc") = "로그인이 필요한 서비스 입니다."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            end if

            If Trim(tasteItemId) = "" Then
                oJson("response") = "err"
                oJson("faildesc") = "정상적인 경로로 접근해주세요."
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            End If


            '// 1. 현재 해당 유저에게 타인의취향 이라는 위시 폴더가 있는지 확인
            foldername = "타인의취향"
            sqlstr = "Select TOP 1 fidx From [db_my10x10].[dbo].[tbl_myfavorite_folder] WITH(NOLOCK) WHERE foldername = '" & trim(foldername) & "' and userid='" & LoginUserid & "' "
            sqlstr = sqlstr & " ORDER BY fidx DESC "
            rsget.Open sqlstr, dbget, adOpenForwardOnly,adLockReadOnly
            If Not rsget.Eof Then
                vFidx = rsget("fidx")
                vFolderCheck = true
            Else
                vFidx = ""
                vFolderCheck = False
            End If
            rsget.Close

            If vFolderCheck Then
                '// 2-1. 해당 폴더가 있으면 삭제한다.(해당 데이터가 있으면 삭제한다.)
                sqlStr = " IF EXISTS (SELECT * FROM db_my10x10.dbo.tbl_myfavorite WITH(NOLOCK) WHERE userid = '" + LoginUserid + "' AND itemid='"&tasteItemId&"' AND fidx='"&vFidx&"') BEGIN " + vbCrlf
                sqlStr = sqlStr + " 	DELETE FROM db_my10x10.dbo.tbl_myfavorite WHERE userid='"&LoginUserid&"' AND itemid='"&tasteItemId&"' And fidx='"&vFidx&"' " + vbCrlf
                sqlStr = sqlStr + " END "
                dbget.Execute sqlStr

                oJson("response") = "ok"
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            Else
                '// 2-2. 해당 폴더가 없으면 상품이 있는게 아니므로 그냥 튕긴다.(굳이 얼렛을 보여줄 필요 없으므로 그냥 ok 처리)
                oJson("response") = "ok"
                oJson.flush
                Set oJson = Nothing
                dbget.close() : Response.End
            End If

    End Select

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
