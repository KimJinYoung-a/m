<%
'####################################################
' Description : 미안하다 생색이다
' History : 2014-12-04 이종화 생성
'####################################################

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()

	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" Then
		If left(Trim(currenttime),10)>="2014-12-04" And left(Trim(currenttime),10) < "2014-12-06" Then
			evt_code = "21390"
		ElseIf left(Trim(currenttime),10)>="2014-12-10" And left(Trim(currenttime),10) < "2014-12-11" Then
			evt_code = "21391"
		End If
	Else
		If left(Trim(currenttime),10)>="2014-12-05" And left(Trim(currenttime),10) < "2014-12-06" Then
			evt_code = "57029"
		ElseIf left(Trim(currenttime),10)>="2014-12-10" And left(Trim(currenttime),10) < "2014-12-11" Then
			evt_code = "57246"
		End If
	End If
	
	getevt_code = evt_code
end function

function getlimitcnt()
	getlimitcnt = 40000
end function

function geteventisusingyn()
	geteventisusingyn = true
	'geteventisusingyn = false
end function

function getbonuscoupon()
	dim tmpcouponid



	IF application("Svr_Info") = "Dev" Then
		If left(Trim(currenttime),10)>="2014-12-05" And left(Trim(currenttime),10) < "2014-12-06" Then
			tmpcouponid = "379"
		ElseIf left(Trim(currenttime),10)>="2014-12-10" And left(Trim(currenttime),10) < "2014-12-11" Then
			tmpcouponid = "380"
		Else
			tmpcouponid = ""			
		End If
	Else
		If left(Trim(currenttime),10)>="2014-12-05" And left(Trim(currenttime),10) < "2014-12-06" Then
			tmpcouponid = "672"
		ElseIf left(Trim(currenttime),10)>="2014-12-10" And left(Trim(currenttime),10) < "2014-12-11" Then
			tmpcouponid = "676"
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