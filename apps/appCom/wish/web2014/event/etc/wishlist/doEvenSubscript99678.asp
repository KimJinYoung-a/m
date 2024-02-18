<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 소원을 담아봐 이벤트 처리 페이지
' History : 2019-12-23 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
	dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer, subscriptcount, couponIdxs
	Dim eCode, LoginUserid, mode, sqlStr, device, viewisusing, foldername, strSql
    dim evtinfo, eventStartDate, eventEndDate, currentDate, folderCount

	eCode			= request("eventCode")    
	currenttime 	= date()
	LoginUserid		= getencLoginUserid()
    viewisusing  = "Y"
    foldername = "2020 소원템" '// 이벤트에 사용할 폴더명

    If isapp="1" Then
        device = "A"
    Else
        device = "M"
    End If
	
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 이벤트에 참여하실 수 있습니다."
		response.End
	End If

    If Trim(eCode) = "" Then
		Response.Write "Err|정상적인 경로로 접근해 주세요."
		response.End
	End If
    
    evtinfo = getEventDate(eCode) '// 이벤트 정보 가져옴
    if not isArray(evtinfo) then
		Response.Write "Err|잘못된 이벤트번호입니다."
		response.End    
    end if

    '변수 초기화
    eventStartDate = cdate(evtinfo(0,0))
    eventEndDate = cdate(evtinfo(1,0))
    currentDate = date()

    '// Staff는 미리 테스트 해보기 위해 이벤트 시작일자를 수정 
    '// 다만 로그인하지 않으면 이벤트 페이지가 보이지 않는건 같음
    If GetLoginUserLevel=7 Then
        eventStartDate = cdate("2019-12-27")
    End If

    '// 이벤트 기간 확인
	If not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then
		Response.Write "Err|이벤트 참여기간이 아닙니다."
		response.End    
    End If

	'// 이벤트에 참여하였는지 확인
	if LoginUserid<>"" then
		subscriptcount = getevent_subscriptexistscount(eCode, LoginUserid, "", "", "")
	end if

    '// 해당 위시 폴더가 있는지 확인
    strSql = "Select COUNT(*) From [db_my10x10].[dbo].[tbl_myfavorite_folder] WITH(NOLOCK) WHERE foldername = '" & trim(foldername) & "' and userid='" & LoginUserid & "' "
    rsget.CursorLocation = adUseClient
    rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
    IF Not rsget.Eof Then
        folderCount = rsget(0)
    END IF
    rsget.Close

    '// 이벤트에는 참여한 기록이 있는데 폴더가 생성 안되어 있을 경우
    If subscriptcount > 0 And folderCount < 1 Then
        '// 이러한 경우가 많지는 않겠지만 이벤트 참여해놓고 폴더를 지웠을경우 대응
        '// 보통 폴더 생성 갯수 제한이 20개 이지만 이벤트이기 때문에 몇개가 있던 생성 해준다.
        CALL fnEventWishFolderMake(LoginUserid, Trim(foldername), viewisusing)
        CALL fnEventWishDataDeleteMake(eCode, device, fnEventWishFolderFidxValue(LoginUserid, foldername), LoginUserid)
		Response.write "OK|OK"
		dbget.close()	:	response.End

    '// 위시 폴더는 있는데 이벤트 데이터가 없을경우
    ElseIf subscriptcount < 1 And folderCount > 0 Then
        '// 기존에 유저가 만들었던거겠지만 이벤트 참여 유도가 목적이기 때문에 이벤트 데이터만 넣어준다.
        CALL fnEventWishDataMake(eCode, device, fnEventWishFolderFidxValue(LoginUserid, foldername), LoginUserid)
		Response.write "OK|OK"
		dbget.close()	:	response.End

    '// 위시 폴더도 없고 이벤트 데이터도 없을경우
    ElseIf subscriptcount < 1 And foldercount < 1 Then
        '// 이경우가 거의 대부분일듯 위시 폴더 만들어 주고 이벤트 데이터도 넣어준다.
        CALL fnEventWishFolderMake(LoginUserid, Trim(foldername), viewisusing)
        CALL fnEventWishDataMake(eCode, device, fnEventWishFolderFidxValue(LoginUserid, foldername), LoginUserid)
		Response.write "OK|OK"
		dbget.close()	:	response.End
    
    '// 위시 폴더도 있고 이벤트 데이터도 있을경우
    ElseIf subscriptcount > 0 And foldercount > 0 Then
		Response.write "Err|이미 위시 폴더가 생성되어 있습니다.>?n폴더에 상품을 담으면 참여가 완료됩니다."
		dbget.close()	:	response.End

    '// 그 외
    Else
		Response.Write "Err|정상적인 경로로 접근해 주세요."
		response.End
    End If

    '// 이벤트 데이터 지우고 재생성
    Function fnEventWishDataDeleteMake(ByVal evt_code, ByVal device, ByVal fidx, ByVal LoginUserid)
		dim sqlStr
        If Trim(evt_code) <> "" And Trim(LoginUserid) <> "" Then
            '// 일단 기존에 등록된 이벤트 데이터는 지운다.        
            sqlstr = "DELETE [db_event].[dbo].[tbl_event_subscript] WHERE evt_code='"&evt_code&"' And userid='"&LoginUserid&"' "
		    dbget.execute sqlstr        

            '// 이벤트를 다시 등록해준다.
            sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device)" + vbcrlf
            sqlstr = sqlstr & " VALUES("& evt_code &",'" & LoginUserid & "','"&fidx&"','"& device &"')" + vbcrlf
            dbget.execute sqlstr
        Else
            Response.Write "Err|정상적인 경로로 접근해 주세요."
            response.End            
        End If
    End Function

    '// 이벤트 데이터 생성
	Function fnEventWishDataMake(ByVal evt_code, ByVal device, ByVal fidx, ByVal LoginUserid)
		dim sqlStr
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& evt_code &",'" & LoginUserid & "','"&fidx&"','"& device &"')" + vbcrlf
		dbget.execute sqlstr
	End Function    

    '// 위시 폴더 생성
	Function fnEventWishFolderMake(ByVal LoginUserid, ByVal foldername, ByVal viewisusing)
		dim sqlStr
		sqlstr = "INSERT INTO [db_my10x10].[dbo].[tbl_myfavorite_folder](userid, foldername, viewisusing, sortno)" + vbcrlf
		sqlstr = sqlstr & " VALUES('"& LoginUserid &"','" & foldername & "','"&viewisusing&"',99)"
		dbget.execute sqlstr
	End Function

    '// 이벤트용 위시 폴더가 있다면 fidx값 가져옴
	Function fnEventWishFolderFidxValue(ByVal LoginUserid, ByVal foldername)
        strSql = "Select top 1 fidx From [db_my10x10].[dbo].[tbl_myfavorite_folder] WITH(NOLOCK) WHERE foldername = '" & trim(foldername) & "' and userid='" & LoginUserid & "' ORDER BY fidx DESC "
        rsget.CursorLocation = adUseClient
        rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
        IF Not rsget.Eof Then
            fnEventWishFolderFidxValue = rsget(0)
        END IF
        rsget.Close
    End Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->