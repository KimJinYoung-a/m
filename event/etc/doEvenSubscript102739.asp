<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 카카오 싱크 이벤트
' History : 2020-05-20 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	dim mysubsctiptcnt, totalsubsctiptcnt, refer, subscriptcount
	Dim eCode, LoginUserid, mode, sqlStr, device, eventStartDate, eventEndDate, currentDate
    Dim i, mileageCode, couponIsUsing, couponUserId, couponKeyCheck

    '// 쿠폰 코드가 존재하는지 확인여부
    couponKeyCheck = False

	LoginUserid		= getencLoginUserid()			
	mileageCode 	= request("mileageCode")
	refer = request.ServerVariables("HTTP_REFERER")

    '// 받은 마일리지코드를 대문자로..
    mileageCode = UCase(mileageCode)

    IF application("Svr_Info") = "Dev" THEN
        eCode = "102172"
    Else
        eCode = "102739"
    End If

    eventStartDate = "2020-06-03"
    eventEndDate = "2020-06-09"
    currentDate = date()
    '// 테스트용 코드
    'currentDate = "2020-06-03"
    
    If isapp="1" Then
        device = "A"
    Else
        device = "M"
    End If

	if InStr(refer,"10x10.co.kr")<1 Then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	If not(Left(Trim(currentDate),10) >= Trim(eventStartDate) and Left(Trim(currentDate),10) < Trim(DateAdd("d", 1, Trim(eventEndDate)))) Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		Response.End
	End IF

	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 쿠폰을 받으실 수 있습니다."
		response.End
	End If

    If Trim(mileageCode) = "" Then
		Response.Write "Err|정상적인 경로로 접근해 주세요."
		response.End
	End If

    '// 쿠폰 발급갯수가 3만개 넘어가면 제한
    sqlStr = "SELECT COUNT(*) FROM [db_temp].[dbo].[tbl_KakaoPlusUserCouponState] WITH (NOLOCK) WHERE isusing='Y' "
    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
    If rsget(0) >= 30000 Then
        Response.Write "Err|선착순 마일리지가 모두 소진되었습니다.>?n참여해주셔서 감사합니다."
        response.End                    
    End If
    rsget.close    

    '// 해당 이벤트에 참여 하였는지 확인
    if LoginUserid<>"" then
        sqlStr = "SELECT * FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code='"&eCode&"' And userid='"&LoginUserid&"' "
        rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
        IF Not rsget.Eof Then
            Response.Write "Err|이미 참여하신 이벤트 입니다."
            response.End            
        End IF
        rsget.close
    End If

    '// 사용자가 입력한 쿠폰 번호의 유효성 체크 및 사용여부 데이터 가져오기
    sqlStr = "SELECT * FROM [db_temp].[dbo].[tbl_KakaoPlusUserCouponState] WITH (NOLOCK) WHERE couponkey='"&mileageCode&"' "
    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
    IF Not rsget.Eof Then
        '// 사용자가 입력한 쿠폰코드가 존재
        couponKeyCheck = True
        couponIsUsing = rsget("isusing")
        couponUserId = rsget("userid")
    Else
        '// 사용자가 입력한 쿠폰코드가 존재하지 않음
        couponKeyCheck = False
        couponIsUsing = ""
        couponUserId = ""
    End IF
    rsget.close

    '// 쿠폰값이 유효하면
    If couponKeyCheck Then
        '// 해당 쿠폰의 사용여부 체크
        If Trim(couponIsUsing) = "Y" Then
            Response.Write "Err|이미 사용한 쿠폰코드 입니다."
            response.End            
        End If
    Else
        Response.Write "Err|잘못된 코드 입니다. 다시 확인해주세요!"
        response.End            
    End If


	'// 이벤트 테이블에 내역을 남긴다.
	sqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3, device) VALUES('" & eCode & "', '" & LoginUserid & "', '카카오톡 채널 추가 1,000 마일리지 지급', '"&mileageCode&"', '"&device&"')"
	dbget.Execute sqlStr	

	'// 마일리지 로그 테이블에 넣는다.
	sqlStr = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&LoginUserid&"', '+1000','"&eCode&"', '카카오톡 채널 추가 1,000마일리지 지급','N') "
	dbget.Execute sqlStr

	'// 마일리지 테이블에 넣는다.
	sqlStr = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 1000, lastupdate=getdate() Where userid='"&LoginUserid&"' "
	dbget.Execute sqlStr

    '// 마일리지 코드 테이블 업데이트 해준다.
    sqlStr = " update [db_temp].[dbo].[tbl_KakaoPlusUserCouponState] set userid='"&LoginUserid&"', isusing='Y' Where couponkey='"&mileageCode&"' "
	dbget.Execute sqlStr

	Response.Write "OK|카카오톡 채널추가 1,000마일리지 지급"
	Response.End    
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->