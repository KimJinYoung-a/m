<%
'####################################################
' Description : oh! oh! oh!
' History : 2014.07.08 원승현 생성
'####################################################

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()
	'tmpcurrenttime = #06/25/2014 09:00:00#
	
	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code, evt_linkcode
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21232
	Else
		evt_code   =  53148
	End If
	
	getevt_code = evt_code
end Function

function getevt_linkcode()
	dim evt_linkcode
	
	IF application("Svr_Info") = "Dev" THEN
		evt_linkcode   =  21234
	Else
		evt_linkcode   =  53150
	End If
	
	getevt_linkcode = evt_linkcode
end Function

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
		tmpcouponid   =  342
	Else
		tmpcouponid   =  617
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