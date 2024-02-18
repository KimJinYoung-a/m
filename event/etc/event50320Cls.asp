<%
'####################################################
' Description :  [무임승차이벤트]텐바이텐 배송 트럭을 잡아라! 
' History : 2014.03.20 한용민 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-03-24"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21116
	Else
		evt_code   =  50320
	End If
	
	getevt_code = evt_code
end function

function getcouponid()
	dim couponid
	
	IF application("Svr_Info") = "Dev" THEN
		couponid = 316
	Else
		couponid = 569
	End If
	
	getcouponid = couponid
end function

function maxcouponcount()
	maxcouponcount=1000
end function
%>