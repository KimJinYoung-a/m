<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 꽃보다 쿠폰 for Mobile & app
' History : 2015-04-06 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount
Dim totalbonuscouponcount '//쿠폰
Dim couponidx , stdate , enddate , wincnt
Dim vQuery

mode = requestcheckvar(request("mode"),32)

totalbonuscouponcount = 0
userid = GetLoginUserID

IF application("Svr_Info") = "Dev" THEN
	eCode = "21538"
	vLinkECode = "21538"
	couponidx = "401"
	stdate = "2015-04-06"
	enddate = "2015-04-06"
Else
	eCode = "61001"
	vLinkECode = "61001"
	If Date() = "2015-04-28" Then
		couponidx = "723"
		stdate = "2015-04-28"
		enddate = "2015-04-28"
	End If
End If

If Not(Now() > #04/28/2015 11:00:00# And Now() < #04/29/2015 00:00:00#) Then
	response.write "<script>alert('아직 이벤트 시간이 되지 않았습니다.'); parent.location.reload();</script>"
	dbget.close()
	response.end
End If

If userid = "" Then
	response.write "<script>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
	response.end
End If

'// 이벤트 응모 내역 확인
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' and convert(varchar(10),regdate,120) = '"& Date() &"' "
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	vTotalCount = rsget(0)
End If
rsget.close()

If vTotalCount > 0 Then
	response.write "<script>alert('이벤트는 ID당 1회만 참여할 수 있습니다.'); parent.top.location.reload();</script>"
	dbget.close()
	response.end
End If 

'//쿠폰발행수량
totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "", Date())

If totalbonuscouponcount < 28000 Then '// 25000건 제한
	if mode="coupondown" Then
		vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '"& couponidx &"' and userid = '" & userid & "'"
		rsget.Open vQuery,dbget,1
		If rsget(0) > 0 Then
			response.write "<script>alert('이미 다운받으셨습니다.'); parent.location.reload();</script>"
			rsget.close()
			dbget.close()
			response.end
		End IF
		rsget.close()

		'// 쿠폰 발행
		vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
				 "values('"& couponidx &"', '" & userid & "', '2','10000','[app쿠폰]10,000원-3만원이상','30000','"& stdate &" 00:00:00','"& enddate &" 23:59:59','',0,'system','app')"
		dbget.execute vQuery

		'// 이벤트 테이블에 내역을 남긴다.
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','coupon', 'M')"
		dbget.Execute vQuery

		response.write "<script>alert('발급완료!\n쿠폰은 금일 "& Date()&" 23시59분 종료됩니다!'); parent.top.location.reload();</script>"
		dbget.close()
		response.End
	end If
Else
	response.write "<script>alert('금일 쿠폰이 모두 소진 되었습니다.'); parent.top.location.reload();</script>"
	response.end
End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->