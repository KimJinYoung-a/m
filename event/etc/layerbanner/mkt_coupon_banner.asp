<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'로그인 시 쿠폰 체크 및 발급 합니다.(2018-05-31 정태훈)
on Error Resume Next
If getloginuserid<>"" Then

	' 2018-05-31 정태훈 추가..2일 모든 고객 쿠폰 발급(6월 쿠폰)
		Dim sqltoday, CheckIDX
	'	원할인
		sqltoday = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & getloginuserid & "' AND masteridx = '1055') " & vbCrlf
		sqltoday = sqltoday & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
		sqltoday = sqltoday & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
		sqltoday = sqltoday & " targetitemlist,startdate,expiredate) " & vbCrlf
		sqltoday = sqltoday & " values(1055,'" & getloginuserid & "',5000,'2','로그인 쿠폰 5000',30000, " & vbCrlf
		sqltoday = sqltoday & " '','2018-06-04 00:00:00' ,'2018-06-05 23:59:59') " & vbCrlf
		dbget.Execute sqltoday, 1

		sqltoday = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & getloginuserid & "' AND masteridx = '1056') " & vbCrlf
		sqltoday = sqltoday & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
		sqltoday = sqltoday & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
		sqltoday = sqltoday & " targetitemlist,startdate,expiredate) " & vbCrlf
		sqltoday = sqltoday & " values(1056,'" & getloginuserid & "',10000,'2','로그인 쿠폰 10000',60000, " & vbCrlf
		sqltoday = sqltoday & " '','2018-06-04 00:00:00' ,'2018-06-05 23:59:59') " & vbCrlf
		dbget.Execute sqltoday, 1

		sqltoday = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & getloginuserid & "' AND masteridx = '1057') " & vbCrlf
		sqltoday = sqltoday & "insert into [db_user].[dbo].tbl_user_coupon " & vbCrlf
		sqltoday = sqltoday & " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice, " & vbCrlf
		sqltoday = sqltoday & " targetitemlist,startdate,expiredate) " & vbCrlf
		sqltoday = sqltoday & " values(1057,'" & getloginuserid & "',15000,'2','로그인 쿠폰 15000',100000, " & vbCrlf
		sqltoday = sqltoday & " '','2018-06-04 00:00:00' ,'2018-06-05 23:59:59') " & vbCrlf
		dbget.Execute sqltoday, 1
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->