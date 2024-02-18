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

<%
dim eCode, com_egCode, bidx,Cidx
dim userid, txtcomm, txtcommURL, mode, spoint, sub_opt3, vEnterOX, vCoupon4000, vCoupon10000
vEnterOX = "x"
spoint = requestCheckVar(request.Form("spoint"),1)

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21074"
		vCoupon4000 = "304"
		vCoupon10000 = "303"
	Else
		eCode = "49092"
		vCoupon4000 = "550"
		vCoupon10000 = "549"
	End If
	

userid = GetLoginUserID

If userid = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

If spoint = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

If spoint <> "1" AND spoint <> "2" AND spoint <> "3" AND spoint <> "4" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

dim referer,refip, returnurl
referer = request.ServerVariables("HTTP_REFERER")
refip = request.ServerVariables("REMOTE_ADDR")
returnurl = requestCheckVar(request.Form("returnurl"),100)

Dim vGubun, vQuery, vCount, vTotalCount, vArr, vP1, vP2, vP3, vPresent, vRealPresent
dim sqlStr, returnValue, k


	vQuery = "SELECT count(sub_idx) From [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "'"
	rsget.Open vQuery, dbget, 1
	If rsget(0) > 0 Then
		vEnterOX = "o"
	End IF
	rsget.close
	
	If vEnterOX = "o" Then
		response.write "<script language='javascript'>alert('이미 응모하셨습니다!'); parent.location.reload();</script>"
		dbget.close()
	    response.end
	Else
			vP1 = 0
			vP2 = 0
			vP3 = 0
			
			vQuery = "SELECT sub_opt2, count(sub_opt2) From [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' group by sub_opt2"
			rsget.Open vQuery, dbget, 1
			If Not rsget.Eof Then
				vTotalCount = rsget.RecordCount
				Do Until rsget.Eof
					If CStr(rsget(0)) = CStr("1") Then
						vP1 = rsget(1)
					End If
					If CStr(rsget(0)) = CStr("2") Then
						vP2 = rsget(1)
					End If
					If CStr(rsget(0)) = CStr("3") Then
						vP3 = rsget(1)
					End If
					rsget.MoveNext
				Loop
			End IF
			rsget.close
			
			
			'If Int(100 * Rnd) < 100 Then	'### 0,1,2 (3%) 는 선물 3개중 1개 랜덤.
			If Int(100 * Rnd) < 3 Then	'### 0,1,2 (3%) 는 선물 3개중 1개 랜덤.
					If (vP1+vP2+vP3) < 30 Then	'### 이미 가져간게 29개까지는 랜덤돌림.
						Randomize
						vArr = Array("1","2","3")
						k = Int(3 * Rnd)
						vPresent = vArr(k)
						
						If CStr(vPresent) = CStr("1") Then
							IF vP1 > 9 Then
								vRealPresent = "2"
								If vP2 > 9 Then
									vRealPresent = "3"
								End If
							Else
								vRealPresent = "1"
							End IF
						End IF
						
						If CStr(vPresent) = CStr("2") Then
							IF vP2 > 9 Then
								vRealPresent = "3"
								If vP3 > 9 Then
									vRealPresent = "1"
								End If
							Else
								vRealPresent = "2"
							End IF
						End IF
						
						If CStr(vPresent) = CStr("3") Then	'### 1만원쿠폰 - 549
							IF vP3 > 9 Then
								vRealPresent = "1"
								If vP1 > 9 Then
									vRealPresent = "2"
								End If
							Else
								vRealPresent = "3"
							End IF
						End IF
					Else	'### 이미 가져간게 30개부터는 4천원쿠폰 - 550
						vRealPresent = "4"
					End If
			Else	'### 3~99 (97%) 는 4천원쿠폰 - 550
				vRealPresent = "4"
			End If
	
			'userid = "aaaaa1"
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2) VALUES('" & eCode & "', '" & userid & "', '" & spoint & "', '" & vRealPresent & "')"
			dbget.Execute vQuery


			If vRealPresent = "3" Then
				vQuery = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " & _
						 "VALUES('" & vCoupon10000 & "', '" & userid & "', '2', '10000', '[메가박스 제휴이벤트] 쇼핑 플레이 - 10,000원', '10000', '2014-02-07 00:00:00.000', '2014-02-28 23:59:59.000', '', 0, 'system')"
				dbget.Execute vQuery
			End If
			
			If vRealPresent = "4" Then
				vQuery = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " & _
						 "VALUES('" & vCoupon4000 & "', '" & userid & "', '2', '4000', '[메가박스 제휴이벤트] 쇼핑 플레이 - 4,000원', '30000', '2014-02-07 00:00:00.000', '2014-02-28 23:59:59.000', '', 0, 'system')"
				dbget.Execute vQuery
			End If

			
			response.write "<script language='javascript'>parent.location.href='/event/eventmain.asp?eventid=" & eCode & "';</script>"
			dbget.close()
		    response.end
	End IF
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->