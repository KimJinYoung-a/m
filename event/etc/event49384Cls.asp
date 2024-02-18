<%
'####################################################
' Description :  [2월 스페셜 쿠폰] 신이 텐바이텐 쿠폰을 만들 때
' History : 2014.02.14 한용민 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-02-17"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21084
	Else
		evt_code   =  49384
	End If
	
	getevt_code = evt_code
end function

function getnewuser(userid)
dim sql , i, stats
	stats=false
	
	if userid = "" then
		stats=false
		exit function
	end if
	if userid = "tozzinet" then
		getnewuser=true
		exit function		
	end if

	sql = "select count(*) as cnt"
	sql = sql & " from db_user.dbo.tbl_logindata l"
	sql = sql & " left join db_order.dbo.tbl_order_master m"
	sql = sql & " 	on l.userid = m.userid"
	sql = sql & " 	and m.regdate>'2014-02-01'"
	sql = sql & " 	and m.ipkumdate>'2014-02-01'"
	sql = sql & " 	and m.cancelyn='N'"
	sql = sql & " 	and m.sitename='10x10'"
	sql = sql & " 	and m.ipkumdiv>3"
	sql = sql & " 	and m.jumundiv<>9"
	sql = sql & " where l.userlevel='5'"
	sql = sql & " and m.idx is null"
	sql = sql & " and l.userid='"& userid &"'"
	
	'response.write sqlshopinfo &"<br>"
	rsget.Open sql,dbget,1
	if not rsget.EOF  then
		if rsget("cnt")>0 then
			stats=true
		else
			stats=false
		end if
	else
		stats=false
	end if
	rsget.close
	
	getnewuser = stats
end function

function get8couponid()
	dim couponid
	
	IF application("Svr_Info") = "Dev" THEN
		couponid   =  306
	Else
		couponid   =  553
	End If
	
	get8couponid = couponid
end function

function get10couponid()
	dim couponid
	
	IF application("Svr_Info") = "Dev" THEN
		couponid   =  307
	Else
		couponid   =  554
	End If
	
	get10couponid = couponid
end function

function get13couponid()
	dim couponid
	
	IF application("Svr_Info") = "Dev" THEN
		couponid   =  308
	Else
		couponid   =  555
	End If
	
	get13couponid = couponid
end function

function getnewcouponid()
	dim couponid
	
	IF application("Svr_Info") = "Dev" THEN
		couponid   =  309
	Else
		couponid   =  556
	End If
	
	getnewcouponid = couponid
end function
%>