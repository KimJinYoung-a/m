<%
'####################################################
' Description : oh! oh! oh!
' History : 2014.06.20 한용민 생성
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
		evt_code   =  21212
	Else
		evt_code   =  52726
	End If
	
	getevt_code = evt_code
end function

function getlimitcnt()
	getlimitcnt = 10000
end function

function geteventisusingyn()
	'geteventisusingyn = true
	geteventisusingyn = false
end function

function getbonuscoupon()
	dim tmpcouponid
	
	IF application("Svr_Info") = "Dev" THEN
		tmpcouponid   =  337
	Else
		tmpcouponid   =  613
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