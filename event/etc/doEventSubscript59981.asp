<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 3월. 득템. 성공적!
' History : 2015-03-09 이종화 생성
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
Dim couponidx , renloop , stdate , enddate , wincnt
Dim vQuery

randomize
renloop=int(Rnd*10000)+1 '0.1%

mode = requestcheckvar(request("mode"),32)

totalbonuscouponcount = 0
userid = GetLoginUserID

IF application("Svr_Info") = "Dev" THEN
	eCode = "21481"
	vLinkECode = "21481"
	couponidx = "394"
	stdate = "2015-03-09"
	enddate = "2015-03-09"
Else
	'// 쿠폰 idx 이틀치 미리셋팅
	eCode = "59981"
	vLinkECode = "59981"
	If Date() = "2015-03-11" Then
		couponidx = "711"
		stdate = "2015-03-11"
		enddate = "2015-03-11"
	Else 
		couponidx = "710"
		stdate = "2015-03-10"
		enddate = "2015-03-10"
	End If
End If

'If Now() > #03/10/2015 23:59:59# Then
'	response.write "<script language='javascript'>alert('아직 이벤트 시간이 되지 않았습니다.'); parent.location.reload();</script>"
'	dbget.close()
'	response.end
'End If

If userid = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
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
	response.write "<script language='javascript'>alert('이벤트는 ID당 1일 1회만 참여할 수 있습니다.'); parent.top.location.reload();</script>"
	dbget.close()
	response.end
End If 

'// 마일리지 응모 내역 확인
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code='"&eCode&"' and convert(varchar(10),regdate,120) = '"& Date() &"' and sub_opt3 = 'mileage' "
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	wincnt = rsget(0)
End If
rsget.close()



'//쿠폰발행수량
totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "", Date())

If totalbonuscouponcount < 25001 Then '// 25000건 제한
	if mode="go" Then
'		If renloop < 101 Then '// 확률 0.1% -> 5%
'			If wincnt > 38 then	'//마일리지 당첨자 제한
'				vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '"& couponidx &"' and userid = '" & userid & "'"
'				rsget.Open vQuery,dbget,1
'				If rsget(0) > 0 Then
'					response.write "<script language='javascript'>alert('이미 다운받으셨습니다.'); parent.location.reload();</script>"
'					rsget.close()
'					dbget.close()
'					response.end
'				End IF
'				rsget.close()
'
'				'// 쿠폰 발행
'				vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
'						 "values('"& couponidx &"', '" & userid & "', '2','10000','[app쿠폰]10,000원-5만원이상','50000','"& stdate &" 00:00:00','"& enddate &" 23:59:59','',0,'system','app')"
'				dbget.execute vQuery
'
'				'// 이벤트 테이블에 내역을 남긴다.
'				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','coupon', 'M')"
'				dbget.Execute vQuery
'
'				response.write "<script language='javascript'>alert('발급완료!\n쿠폰은 금일 "& Date()&" 23시59분 종료됩니다!'); parent.top.location.reload();</script>"
'				dbget.close()
'				response.End
'			else
'				'// 마일리지 테이블에 넣는다.
'				vQuery = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 10000, lastupdate=getdate() Where userid='"&userid&"' "
'				dbget.Execute vQuery
'
'				'// 마일리지 로그 테이블에 넣는다.
'				vQuery = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&userid&"', '+10000','"&eCode&"', '3월. 득템. 성공적! 10,000마일리지 지급','N') "
'				dbget.Execute vQuery
'
'				'// 이벤트 테이블에 내역을 남긴다.
'				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','mileage', 'M')"
'				dbget.Execute vQuery
'
'				response.write "<script language='javascript'>alert('10,000 마일리지 당첨!\n지급 된 마일리지는 마이텐바이텐에서 확인해보세요'); parent.top.location.reload();</script>"
'				dbget.close()
'				response.End
'			End If 
'		Else
			vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '"& couponidx &"' and userid = '" & userid & "'"
			rsget.Open vQuery,dbget,1
			If rsget(0) > 0 Then
				response.write "<script language='javascript'>alert('이미 다운받으셨습니다.'); parent.location.reload();</script>"
				rsget.close()
				dbget.close()
				response.end
			End IF
			rsget.close()

			'// 쿠폰 발행
			vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
					 "values('"& couponidx &"', '" & userid & "', '2','10000','[app쿠폰]10,000원-5만원이상','50000','"& stdate &" 00:00:00','"& enddate &" 23:59:59','',0,'system','app')"
			dbget.execute vQuery

			'// 이벤트 테이블에 내역을 남긴다.
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','coupon', 'M')"
			dbget.Execute vQuery

			response.write "<script language='javascript'>alert('발급완료!\n쿠폰은 금일 "& Date()&" 23시59분 종료됩니다!'); parent.top.location.reload();</script>"
			dbget.close()
			response.End
'		End If 
	end If
Else
	response.write "<script language='javascript'>alert('금일 쿠폰이 모두 소진 되었습니다.'); parent.top.location.reload();</script>"
	response.end
End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->