<% option Explicit %>
<% Response.CharSet = "euc-kr" %>
<%
	Response.Expires = -1
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cahce"
	Response.AddHeader "cache-Control", "no-cache"
%>
<!-- include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim sqlStr, loginid, evt_code, vDownGubun, vDown1Chk, vDown2Chk, vDown3Chk, vOrderCnt, vDown1Cnt, vCoupon1Idx, vDown2Cnt, vCoupon2Idx, vDown3Cnt, vCoupon3Idx
	loginid = GetLoginUserID()
	vDownGubun = requestCheckVar(request("gb"),1)
	
	If loginid = "" Then
		Response.Write "<script>alert('잘못된 경로입니다.');</script>"
		dbget.close()
		Response.End
	End If
	
	If Now() > #12/16/2013 00:00:00# AND Now() < #12/20/2013 23:59:59# Then
		Response.Write "<script>alert('이벤트가 마감되었습니다.');</script>"
		dbget.close()
		Response.End
	End IF
	
	IF application("Svr_Info") = "Dev" THEN
		vCoupon1Idx = "282"
		vCoupon2Idx = "283"
		vCoupon3Idx = "284"
	Else
		vCoupon1Idx = "499"
		vCoupon2Idx = "500"
		vCoupon3Idx = "501"
	End If
	
	vOrderCnt = 0
	vDown1Cnt = 0
	vDown2Cnt = 0
	vDown3Cnt = 0
	
	If vDownGubun = "a" OR vDownGubun = "1" Then
		sqlStr = "SELECT count(orderserial) FROM [db_order].[dbo].[tbl_order_master] WHERE userid = '" & loginid & "' AND regdate > '2013-12-01 00:00:00'"
		rsget.Open sqlStr,dbget,1
		IF Not rsget.Eof Then
			vOrderCnt = rsget(0)
		End IF
		rsget.close
		
		If CStr(vOrderCnt) = CStr(0) Then
			sqlStr = "SELECT count(masteridx) FROM [db_user].dbo.tbl_user_coupon WHERE userid = '" & loginid & "' AND masteridx = '" & vCoupon1Idx & "'"
			rsget.Open sqlStr,dbget,1
			IF Not rsget.Eof Then
				vDown1Cnt = rsget(0)
			End IF
			rsget.close
			
			If CStr(vDown1Cnt) = CStr(0) Then
				sqlStr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " & vbCrLf
				sqlStr = sqlStr & "select '" & vCoupon1Idx & "' , '" & loginid & "','2','5000','[12월 회원 혜택 쿠폰] 첫 구매 쿠폰','40000','2013-12-16 00:00:00.000','2013-12-22 23:59:59.000','',0,'system'"
				dbget.execute(sqlStr)
			Else
				vDown1Chk = "o"
			End IF
		End IF
	End IF
	
	
	If vDownGubun = "a" OR vDownGubun = "2" Then
		sqlStr = "SELECT count(masteridx) FROM [db_user].dbo.tbl_user_coupon WHERE userid = '" & loginid & "' AND masteridx = '" & vCoupon2Idx & "' AND isusing = 'N'"
		rsget.Open sqlStr,dbget,1
		IF Not rsget.Eof Then
			vDown2Cnt = rsget(0)
		End IF
		rsget.close
		If CStr(vDown2Cnt) = CStr(0) Then
			sqlStr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " & vbCrLf
			sqlStr = sqlStr & "select '" & vCoupon2Idx & "' , '" & loginid & "','1','10','[12월 회원 혜택 쿠폰] 10% 할인 쿠폰','70000','2013-12-16 00:00:00.000','2013-12-22 23:59:59.000','',0,'system'"
			dbget.execute(sqlStr)
		Else
			vDown2Chk = "o"
		End IF
	End IF
	
	
	If vDownGubun = "a" OR vDownGubun = "3" Then
		sqlStr = "SELECT count(masteridx) FROM [db_user].dbo.tbl_user_coupon WHERE userid = '" & loginid & "' AND masteridx = '" & vCoupon3Idx & "' AND isusing = 'N'"
		rsget.Open sqlStr,dbget,1
		IF Not rsget.Eof Then
			vDown3Cnt = rsget(0)
		End IF
		rsget.close
		If CStr(vDown3Cnt) = CStr(0) Then
			sqlStr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " & vbCrLf
			sqlStr = sqlStr & "select '" & vCoupon3Idx & "' , '" & loginid & "','2','20000','[12월 회원 혜택 쿠폰] 20,000원 할인 쿠폰','150000','2013-12-16 00:00:00.000','2013-12-22 23:59:59.000','',0,'system'"
			dbget.execute(sqlStr)
		Else
			vDown3Chk = "o"
		End IF
	End IF
%>
<script>
alert("쿠폰은 마이텐바이텐에서 확인하세요.");
parent.location.reload();
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->