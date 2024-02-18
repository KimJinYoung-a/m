<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 신한 체크카드 프로모션
' History : 2020-10-22 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim mode, referer,refip, apgubun, receiveUserKey
	mode = requestcheckvar(request("mode"),32)
  receiveUserKey = requestcheckvar(request("userkey"),2048)
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

dim eCode, userid
Dim sqlstr, vQuery, tenbytenCheckCount, mileageIssuedCheck
  IF application("Svr_Info") = "Dev" THEN
    eCode   =  103246
  Else
    eCode   =  106761
  End If

  userid = GetEncLoginUserID()

  '// 모바일웹&앱전용
  If isApp="1" Then
    apgubun = "A"
  Else
    apgubun = "M"
  End If

  'apgubun = "W"

  If not( left(now(),10)>="2020-10-19" and left(now(),10)<"2020-12-01" ) Then
    Response.Write "Err|이벤트 신청기간이 아닙니다."
    dbget.close() : Response.End
  End IF

  If mode="ins" Then
    if InStr(referer,"10x10.co.kr")<1 then
      Response.Write "Err|잘못된 접속입니다."
      dbget.close() : Response.End
    end If

    If userid = "" Then
      Response.Write "Err|로그인을 해야>?n신청 하실 수 있습니다."
      dbget.close() : Response.End
    End If

    ' 카드 신청을 완료하고 마일리지를 발급 받았는지 확인
    vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And sub_opt2=1 "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    If rsget(0) > 0 Then
      Response.Write "Err|이미 신청 하셨습니다."
      dbget.close() : Response.End	
    End IF
    rsget.close

    ' 카드 신청은 완료하지 않았지만 기존에 신청하여 DB에 들어와 있는지 확인
    vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And sub_opt1='send' "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    IF Not rsget.Eof Then
        tenbytenCheckCount = rsget(0)
    End IF
    rsget.close

    If tenbytenCheckCount > 0 Then
      Response.Write "OK|shinhanmove"
      dbget.close() : Response.End
    Else
      '// 이벤트 내역을 남긴다.
      sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
      sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'send', '"&apgubun&"')" + vbcrlf
      dbget.execute sqlstr

      '// 해당 유저의 로그값 집어넣는다.
      sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
      sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '신한 체크카드 발급 프로모션 텐바이텐에서 신청', '"&apgubun&"')"
      dbget.execute sqlstr

      Response.Write "OK|sendcomplate"
      dbget.close() : Response.End
    End If
  ElseIf mode="sCardComplate" Then
    ' 받은 userkey값이 텐텐 회원인지 확인
    vQuery = "SELECT count(*) FROM [db_user].[dbo].[tbl_user_n] WHERE userid='"&tenDec(URLDecodeUTF8(receiveUserKey))&"' "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    If rsget(0) < 1 Then
      Response.Write "Err|정상적인 유저 정보가 아닙니다."
      dbget.close() : Response.End	
    End IF
    rsget.close

    ' 텐바이텐을 통해서 카드를 신청했는지 확인.
    vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&tenDec(URLDecodeUTF8(receiveUserKey))&"' And sub_opt1='send' "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    IF rsget(0) < 1 Then
      Response.Write "Err|텐바이텐을 통해 신한 체크카드 이벤트를 신청한 회원이 아닙니다."
      dbget.close() : Response.End
    End IF
    rsget.close    

    ' 카드 신청을 완료하고 마일리지를 발급 받았는지 확인
    vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&tenDec(URLDecodeUTF8(receiveUserKey))&"' And sub_opt2=1 "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    If rsget(0) > 0 Then
      Response.Write "Err|이미 카드 신청 후 마일리지를 발급 받으셨습니다."
      dbget.close() : Response.End	
    End If
    rsget.close

    '// 신한 체크카드 신청 완료 후 정상적으로 넘어온 회원이면 업데이트
    sqlStr = ""
    sqlstr = "UPDATE [db_event].[dbo].[tbl_event_subscript] SET sub_opt2 = 1, sub_opt3 = '"&now()&"' " & vbCrlf
    sqlstr = sqlstr & " WHERE userid= '"&tenDec(URLDecodeUTF8(receiveUserKey))&"' and evt_code="& eCode
    dbget.execute sqlstr

    mileageIssuedCheck = true
    '// 혹시나.. 마일리지를 기존에 발급 받았는지 체크
    vQuery = "SELECT count(*) FROM [db_user].[dbo].[tbl_mileagelog] WITH(NOLOCK) WHERE jukyocd = '" & eCode & "' And userid='"&tenDec(URLDecodeUTF8(receiveUserKey))&"' "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    IF rsget(0) > 0 Then
      mileageIssuedCheck = false
    End IF
    rsget.close

    '// 기존에 발급받은적이 없으면 true 아니면 false임.. 헷갈릴 수 있어서..
    '// 즉, 기존에 발급받은적이 없는 유저만 아래 쿼리를 탐
    If mileageIssuedCheck Then
      If left(now(), 10) >= "2020-10-26" Then
        '// 마일리지 로그 테이블에 넣는다.
        sqlstr = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&tenDec(URLDecodeUTF8(receiveUserKey))&"', '+10000','"&eCode&"', '텐바이텐x신한 체크카드 신청 10,000 마일리지 지급','N') "
        dbget.Execute sqlstr

        '// 마일리지 테이블에 넣는다.
        sqlstr = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 10000, lastupdate=getdate() Where userid='"&tenDec(URLDecodeUTF8(receiveUserKey))&"' "
        dbget.Execute sqlstr
      End If
    End If

    Response.write "OK|mileageok"
    dbget.close()	:	response.End
  Else
    Response.Write "Err|잘못된 접속입니다."
    dbget.close() : Response.End
  End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->