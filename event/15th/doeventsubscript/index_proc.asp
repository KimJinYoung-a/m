<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"

%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer, vBookNo, vState, vQuery, vIsEnd, vNowTime, vCouponMaxCount
Dim eCode, LoginUserid, mode, sqlStr, device, cnt
		

currenttime = date()
mode			= requestcheckvar(request("mode"),32)
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

if mode<>"G" then
	Response.Write "Err|잘못된 접속입니다.E04"
	dbget.close: Response.End
end If

'// expiredate
If Now() > #10/24/2016 23:59:59# Then
	Response.Write "Err|이벤트가 종료되었습니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 다운받으실 수 있습니다."
	response.End
End If

If Now() < #10/10/2016 00:00:00# Then
	'If GetLoginUserLevel() <> "7" Then
		Response.Write "Err|이벤트 시작전 입니다."
		Response.End
	'End If
End If


If GetLoginUserLevel() = "7" Then
	Response.Write "Err|STAFF은 참여할 수 없습니다."
	Response.End
End If


If isapp = "1" Then '앱일경우
	device = "A"
Else '앱이 아닐경우
	device = "M"
End If


	If Now() < #10/15/2016 00:00:00# Then
		vCouponMaxCount = 48
	Else
		vCouponMaxCount = 13
	End If
	

'#######
' vState = "0" ### 이벤트 종료됨.
' vState = "1" ### 쿠폰다운가능.
' vState = "2" ### 다운 가능 시간 아님.
' vState = "3" ### 이미 받음.
' vState = "4" ### 한정수량 오버됨.
' vState = "5" ### 로그인안됨.
If IsUserLoginOK() Then
	If Now() > #10/24/2016 23:59:59# Then
		vIsEnd = True
		vState = "0"	'### 이벤트 종료됨. 0
	Else
		vIsEnd = False
	End If
	
	If Not vIsEnd Then	'### 이벤트 종료안됨.
		vQuery = "select convert(int,replace(convert(char(8),getdate(),8),':',''))"
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
		vNowTime = rsget(0)	'### DB시간받아옴.
		rsget.close

		'If vNowTime > 100000 AND vNowTime < 235959 Then	'### 15시에서 24시 사이 다운가능. 1
		If vNowTime > 150000 AND vNowTime < 235959 Then	'### 15시에서 24시 사이 다운가능. 1
			vQuery = "select count(sub_idx) from [db_event].[dbo].[tbl_event_subscript] where userid = '" & getencLoginUserid() & "' and evt_code = '73053'"
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
			If rsget(0) > 0 Then	' ### 이미 받음. 3
				vState = "3"
			End IF
			rsget.close
			
			If vState <> "3" Then	'### 한정수량 계산
				vQuery = "select count(sub_idx) from [db_event].[dbo].[tbl_event_subscript] where evt_code = '73053' and sub_opt1 = convert(varchar(10),getdate(),120)"
				rsget.CursorLocation = adUseClient
				rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
				If rsget(0) >= vCouponMaxCount Then	' 한정수량 100 오버됨. 4
					vState = "4"
				Else
					vState = "1"	'### 쿠폰다운가능.
				End IF
				rsget.close
			End IF
		Else	' ### 다운 가능 시간 아님. 2
			vState = "2"
		End IF
	End IF
Else
	vState = "5"
End IF


If vState = "1" Then	'### 쿠폰다운가능.
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, device) VALUES ('73053', '"& LoginUserid &"', convert(varchar(10),getdate(),120), '"&device&"')"
	dbget.execute sqlstr
	
	sqlStr = "insert into [db_user].[dbo].tbl_user_coupon " & vbCrLf
	sqlStr = sqlStr & "(masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " & vbCrLf
	sqlStr = sqlStr & "SELECT m.idx, '" & LoginUserid & "', m.coupontype, m.couponvalue, m.couponname, m.minbuyprice, m.targetitemlist " & vbCrLf
	sqlStr = sqlStr & ", convert(varchar(10),getdate(),120), convert(datetime,convert(varchar(10),getdate(),120) + ' 23:59:59'), m.couponmeaipprice, m.validsitename " & vbCrLf
	sqlStr = sqlStr & "from [db_user].[dbo].tbl_user_coupon_master as m " & vbCrLf
	
	IF application("Svr_Info") = "Dev" THEN
		sqlStr = sqlStr & "where m.isusing='Y' and m.idx='2818' "
	Else
		sqlStr = sqlStr & "where m.isusing='Y' and m.idx='914' "
	End If
	dbget.execute sqlstr

	Response.write "OK|쿠폰이 발급되었습니다. 금일 자정까지 사용하세요!"
	dbget.close()	:	response.End
ElseIf vState = "2" Then	' ### 다운 가능 시간 아님. 2
	Response.write "Err|쿠폰은 15시에 다운 받을 수 있습니다."
	dbget.close()	:	response.End
ElseIf vState = "3" Then	' ### 이미 받음. 3
	Response.write "Err|이미 쿠폰을 발급받으셨습니다.>?n타임쿠폰은 이벤트기간동안 ID당 한번만 발급 받을 수 있습니다."
	dbget.close()	:	response.End
ElseIf vState = "4" Then	' 한정수량 100 오버됨. 4
	Response.write "Err|1일 한정 수량을 넘었습니다."
	dbget.close()	:	response.End
ElseIf vState = "5" Then	' 한정수량 100 오버됨. 4
	Response.write "Err|로그인 후 다운받으실 수 있습니다."
	dbget.close()	:	response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->