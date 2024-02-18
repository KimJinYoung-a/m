<%
'####################################################
' Description : 기승전쇼핑_빼주세요, APP 쿠폰 (M)
' History : 2014.09.04 유태욱 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-09-11"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   = 21290
	Else
		evt_code   = 54760
	End If
	
	getevt_code = evt_code
end function

function geteventisusingyn()
	geteventisusingyn = true
	'geteventisusingyn = false
end function

function getbonuscoupon5000()
	dim tmpcouponid
	
	IF application("Svr_Info") = "Dev" THEN
		tmpcouponid   =  351
	Else
		tmpcouponid   =  633
	End If
	
	getbonuscoupon5000 = tmpcouponid
end function

function getbonuscoupon10000()
	dim tmpcouponid
	
	IF application("Svr_Info") = "Dev" THEN
		tmpcouponid   =  352
	Else
		tmpcouponid   =  634
	End If
	
	getbonuscoupon10000 = tmpcouponid
end function

function getbonuscoupon15pro()
	dim tmpcouponid
	
	IF application("Svr_Info") = "Dev" THEN
		tmpcouponid   =  350
	Else
		tmpcouponid   =  632
	End If
	
	getbonuscoupon15pro = tmpcouponid
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