<%
'####################################################
' Description : 결정해줘 app쿠폰
' History : 2014.11.03 원승현 생성
'####################################################

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()
	'tmpcurrenttime = #06/23/2014 09:00:00#
	
	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21353
	Else
		evt_code   =  56092
	End If
	
	getevt_code = evt_code
end Function

Function getevt_linkCode()
	dim evt_linkcode
	
	IF application("Svr_Info") = "Dev" THEN
		evt_linkCode = 21354
	Else
		evt_linkCode = 56093
	End If
	
	getevt_linkCode = evt_linkCode

End Function

function getlimitcnt()
	getlimitcnt = 20000
end function

function geteventisusingyn()
	'geteventisusingyn = true
	geteventisusingyn = false
end function

function getbonuscoupon()
	dim tmpcouponid

	IF application("Svr_Info") = "Dev" Then
		If left(Trim(currenttime),10)>="2014-11-03" And left(Trim(currenttime),10) < "2014-11-05" Then
			tmpcouponid   =  373
		ElseIf left(Trim(currenttime),10)>="2014-11-05" And left(Trim(currenttime),10) < "2014-11-06" Then
			tmpcouponid = 374
		Else
			tmpcouponid = ""			
		End If
	Else
		If left(Trim(currenttime),10)>="2014-11-04" And left(Trim(currenttime),10) < "2014-11-05" Then
			tmpcouponid   =  660
		ElseIf left(Trim(currenttime),10)>="2014-11-05" And left(Trim(currenttime),10) < "2014-11-06" Then
			tmpcouponid = 661
		Else
			tmpcouponid = ""			
		End If
	End If
	getbonuscoupon = tmpcouponid
end function

function getusercell(userid)
	dim sqlstr, tmpusercell
	
	if userid="" then
		getusercell=""
		exit function
	end if
	
	sqlstr = "select top 1 n.usercell"
	sqlstr = sqlstr & " from db_user.dbo.tbl_user_n n"
	sqlstr = sqlstr & " where n.userid='"& userid &"'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmpusercell = rsget("usercell")
	else
		tmpusercell = ""
	END IF
	rsget.close
	
	getusercell = tmpusercell
end function

%>