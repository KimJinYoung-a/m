<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, sqlstr, mode , totalbonuscouponcount
mode = requestcheckvar(request("mode"),32)
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21464"
	Else
		eCode = "59298"
	End If

userid = GetLoginUserID
totalbonuscouponcount=0

If userid = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

'//전체 쿠폰 발행수량
totalbonuscouponcount = getbonuscoupontotalcount("701", "", "", Date())
	
If totalbonuscouponcount < 20001 then
	if mode="coupon" then
		Dim vQuery

		If Not(Now() > #02/04/2015 00:00:00# And Now() < #02/05/2015 00:00:00#) Then
			response.write "<script language='javascript'>alert('이벤트 기간이 아닙니다.'); parent.location.reload();</script>"
			dbget.close()
			response.end
		End If

		vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '701' and userid = '" & userid & "'"
		rsget.Open vQuery,dbget,1
		If rsget(0) > 0 Then
			response.write "<script language='javascript'>alert('이미 다운받으셨습니다.'); parent.location.reload();</script>"
			rsget.close()
			dbget.close()
			response.end
		End IF
		rsget.close()

		vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
				 "values('701', '" & userid & "', '2','10000','[app쿠폰]10,000원-4만원이상','40000','2015-02-04 00:00:00','2015-02-04 23:59:59','',0,'system','app')"
		dbget.execute vQuery

			response.write "<script language='javascript'>alert('발급완료!\n쿠폰은 금일 02/04(수) 23시59분 종료됩니다!'); parent.top.location.reload();</script>"
			dbget.close()
			response.end
	end If
Else
	response.write "<script language='javascript'>alert('금일 쿠폰은 소진 되었습니다.'); parent.top.location.reload();</script>"
	dbget.close()
	response.end
End If 
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->