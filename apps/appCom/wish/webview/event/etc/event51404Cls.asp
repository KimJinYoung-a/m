<%
'####################################################
' Description :  텐바이텐 웰컴 투 APP어랜드 
' History : 2014.04.25 한용민 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-04-30"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21161
	Else
		evt_code   =  51404
	End If
	
	getevt_code = evt_code
end function

function getcoupon3000()
	dim tmpcouponidx
	
	IF application("Svr_Info") = "Dev" THEN
		tmpcouponidx   =  325
	Else
		tmpcouponidx   =  589
	End If
	
	getcoupon3000 = tmpcouponidx
end function
%>