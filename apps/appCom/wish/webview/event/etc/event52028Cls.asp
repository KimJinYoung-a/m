<%
'####################################################
' Description :  5월, MAY I HELP YOU
' History : 2014.05.22 유태욱 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	nowdate = "2014-05-26"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21180
	Else
		evt_code   =  52028
	End If
	
	getevt_code = evt_code
end function

dim realtest_url
IF application("Svr_Info") = "Dev" THEN
	realtest_url="test"
End If

function getcouponid4000()
	dim couponid
	
	IF application("Svr_Info") = "Dev" THEN
		couponid   =  330
	Else
		couponid   =  597
	End If
	
	getcouponid4000 = couponid
end function

function getcouponidfree()
	dim couponid
	
	IF application("Svr_Info") = "Dev" THEN
		couponid   =  331
	Else
		couponid   =  598
	End If
	
	getcouponidfree = couponid
end function

function getcouponid10000()
	dim couponid
	
	IF application("Svr_Info") = "Dev" THEN
		couponid   =  332
	Else
		couponid   =  599
	End If
	
	getcouponid10000 = couponid
end function

function getkakaolink()
	dim kakaolink
	
	IF application("Svr_Info") = "Dev" THEN
		kakaolink   =  "http://bit.ly/1gmibv8"
	Else
		kakaolink   =  "http://bit.ly/1gUZ4sJ"
	End If
	
	getkakaolink = kakaolink
end function
%>