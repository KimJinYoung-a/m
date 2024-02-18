<%
'####################################################
' Description : 정말 빼빼로가 좋아요
' History : 2014.10.30 한용민 생성
'####################################################

function staffconfirm()
	staffconfirm=TRUE
	'staffconfirm=FALSE
end function

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()
	'tmpcurrenttime = #11/07/2014 13:05:00#
	
	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21351
	Else
		evt_code   =  56037
	End If
	
	getevt_code = evt_code
end function

function getevt_codeprint()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21351
	Else
		evt_code   =  56037
	End If
end function

'//맥북제한수량
function limitmacbook()
	limitmacbook=1
end function

'//기프트카드제한수량
function limitgiftcard()
	limitgiftcard=10
end function

'//쿠폰제한수량
function limitbounscoupon()
	limitbounscoupon=2000
end function

function datecouponval()
	dim tmpdatecouponval

	IF application("Svr_Info") = "Dev" THEN
		tmpdatecouponval   =  372
	Else
		tmpdatecouponval   =  662
	End If

	datecouponval=tmpdatecouponval
end function

%>