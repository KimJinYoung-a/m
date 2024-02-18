<%
'####################################################
' Description :  오빠나믿지? socar
' History : 2014.12.11 한용민 생성
'####################################################

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-12-15"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21404
	Else
		evt_code   =  57644
	End If
	
	getevt_code = evt_code
end function

function getevt_codedisp()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21405
	Else
		evt_code   =  57645
	End If
	
	getevt_codedisp = evt_code
end function

function couponval57644()
	dim tmpdatecouponval

	IF application("Svr_Info") = "Dev" THEN
		tmpdatecouponval="382"
	Else
		tmpdatecouponval="677"
	End If

	couponval57644=tmpdatecouponval
end function

function getaddr_si()
	dim sqlstr, tmevent_addr_si

	sqlstr = "select top 50 addr_si"
	sqlstr = sqlstr & " from db_zipcode.dbo.ADDR080TL"
	sqlstr = sqlstr & " where addr_si not in ('강원','경기','경남','경북','광주','대구','대전','부산','서울','울산','인천','전남','전북','제주','충남','충북')"
	sqlstr = sqlstr & " group by addr_si"
	sqlstr = sqlstr & " order by addr_si asc"
	
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmevent_addr_si = rsget.getrows()
	END IF
	rsget.close
	
	getaddr_si=tmevent_addr_si
end function
%>