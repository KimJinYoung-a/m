<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 비정상혜택#2 쿠폰이벤트용 처리페이지
' History : 2018-03-23 이종화
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim strSql
Dim idx, arridx, stype, arrstype, i, userid, mode
	idx		= requestcheckvar(request("idx"),10)			'쿠폰 idx
	stype	= Request("stype")	'발급 종류
	mode	= requestcheckvar(request("mode"),32)
	userid  = GetencLoginUserID
dim vUsr

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "02|로그인 후 참여하실 수 있습니다."
	response.End
End If

dim getbonuscoupon

If idx <> "" Then getbonuscoupon = idx

dim couponexistscount
	couponexistscount = getbonuscouponexistscount(userid, getbonuscoupon, "", "", "")	'' 중복발급 허용안함

if couponexistscount <> 0 then
	Response.Write "13||이미 쿠폰을 받으셨습니다."
	dbget.close() : Response.End
end if

If now() > #04/23/2018 23:59:59# then
	Response.Write "12||기간이 종료되었거나 유효하지 않은 쿠폰입니다."
	dbget.close() : Response.End
end If

if mode = "add1" Then
	'// 대상자 확인 (A: SMS대상, C:SMS허용X대상) 0 구매
	strSql = "Select count(*) as cnt from db_temp.[dbo].[tbl_temp_Send_UserSMS] with (noLock) where yyyymmdd='20180423' and div in ('A','C') and userid='" & userid & "' "
	rsget.Open strSql,dbget,1
		vUsr = rsget("cnt")
	rsget.close
	if vUsr<=0 then
		Response.Write "14||이벤트 대상자가 아닙니다."
		dbget.close() : Response.End
	end if

	'// 쿠폰 발급
	strSql = "if not exists(select masteridx from [db_user].[dbo].tbl_user_coupon where userid='"& userid &"' and masteridx="& getbonuscoupon &")" & vbcrlf
	strSql = strSql & "begin" & vbcrlf
	strSql = strSql & " insert into [db_user].[dbo].tbl_user_coupon" & vbcrlf
	strSql = strSql & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" & vbcrlf
	strSql = strSql & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, getdate(), dateadd(s, -1,dateadd(dd,datediff(dd,0,getdate()+1),0)),couponmeaipprice,validsitename"	 & vbcrlf
	strSql = strSql & " 	from [db_user].[dbo].tbl_user_coupon_master m" & vbcrlf
	strSql = strSql & " 	where idx="& getbonuscoupon &"" & vbcrlf
	strSql = strSql & "end"

	dbget.execute strSql

	Response.Write "11||쿠폰이 발급되었습니다."
	dbget.close() : Response.End
ElseIf mode = "add2" Then
	'// 대상자 확인 (D: SMS대상 ,) 
	strSql = "Select count(*) as cnt from db_temp.[dbo].[tbl_temp_Send_UserSMS] with (noLock) where yyyymmdd='20180423' and div in ('E','F') and userid='" & userid & "' "
	rsget.Open strSql,dbget,1
		vUsr = rsget("cnt")
	rsget.close
	if vUsr<=0 then
		Response.Write "14||이벤트 대상자가 아닙니다."
		dbget.close() : Response.End
	end if

	'// 쿠폰 발급
	strSql = "if not exists(select masteridx from [db_user].[dbo].tbl_user_coupon where userid='"& userid &"' and masteridx="& getbonuscoupon &")" & vbcrlf
	strSql = strSql & "begin" & vbcrlf
	strSql = strSql & " insert into [db_user].[dbo].tbl_user_coupon" & vbcrlf
	strSql = strSql & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" & vbcrlf
	strSql = strSql & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, getdate(), dateadd(s, -1,dateadd(dd,datediff(dd,0,getdate()+1),0)),couponmeaipprice,validsitename"	 & vbcrlf
	strSql = strSql & " 	from [db_user].[dbo].tbl_user_coupon_master m" & vbcrlf
	strSql = strSql & " 	where idx="& getbonuscoupon &"" & vbcrlf
	strSql = strSql & "end"

	dbget.execute strSql

	Response.Write "11||쿠폰이 발급되었습니다."
	dbget.close() : Response.End
else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
