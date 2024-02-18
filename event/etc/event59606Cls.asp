<%
'####################################################
' Description :  [설 명절엔 쇼핑] 쿠폰도 넣어둬 넣어둬 
' History : 2015.02.16 유태욱 생성
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
		evt_code   =  21475
	Else
		evt_code   =  59606
	End If
	
	getevt_code = evt_code
end function

function getevt_codelink()
	dim evt_codelink
	
	IF application("Svr_Info") = "Dev" THEN
		evt_codelink = 21476
	Else
		evt_codelink = 59607
	End If
	
	getevt_codelink = evt_codelink
end function

function getnewuser(userid)
dim sql , i, stats
	stats=false
	
	if userid = "" then
		stats=false
		exit function
	end if
	if userid = "baboytw" then
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

function get1couponid()'1만원이상구매시 10프로
	dim couponid
	
	IF application("Svr_Info") = "Dev" THEN
		couponid   =  391
	Else
		couponid   =  703
	End If
	
	get1couponid = couponid
end function

function get3couponid()'3만원이상구매시 5000원
	dim couponid
	
	IF application("Svr_Info") = "Dev" THEN
		couponid   =  392
	Else
		couponid   =  704
	End If
	
	get3couponid = couponid
end function

function get7couponid()'7만원이상구매시 10000원
	dim couponid
	
	IF application("Svr_Info") = "Dev" THEN
		couponid   =  393
	Else
		couponid   =  705
	End If
	
	get7couponid = couponid
end function

'function getnewcouponid()
'	dim couponid
'	
'	IF application("Svr_Info") = "Dev" THEN
'		couponid   =  309
'	Else
'		couponid   =  556
'	End If
'	
'	getnewcouponid = couponid
'end function
%>