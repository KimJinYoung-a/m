<%
'####################################################
' Description : 0원의 기적
' History : 2015.02.09 한용민 생성
'####################################################

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()
	'tmpcurrenttime = #02/10/2015 10:30:00#

	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21469
	Else
		evt_code   =  59405
	End If
	
	getevt_code = evt_code
end function

function getevt_codeprint()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21469
	Else
		evt_code   =  59405
	End If
	
	getevt_codeprint = evt_code
end function

function datecouponval()
	dim tmpdatecouponval

	IF application("Svr_Info") = "Dev" THEN
		tmpdatecouponval=389
	Else
		tmpdatecouponval=702
	End If

	datecouponval=tmpdatecouponval
end function

'//쿠폰제한수량
function datecouponlimit(vdate)
	dim tmpdatecouponlimit
		tmpdatecouponlimit = 0

	if vdate="" then datecouponlimit=0

	if vdate="2015-02-09" then
		tmpdatecouponlimit=2000
	elseif vdate="2015-02-10" then
		tmpdatecouponlimit=2000
	elseif vdate="2015-02-11" then
		tmpdatecouponlimit=2000
	elseif vdate="2015-02-12" then
		tmpdatecouponlimit=2000
	elseif vdate="2015-02-13" then
		tmpdatecouponlimit=2000
	elseif vdate="2015-02-14" then
		tmpdatecouponlimit=2000
	elseif vdate="2015-02-15" then
		tmpdatecouponlimit=2000
	elseif vdate="2015-02-16" then
		tmpdatecouponlimit=2000
	elseif vdate="2015-02-17" then
		tmpdatecouponlimit=2000
	end if

	datecouponlimit=tmpdatecouponlimit
end function

'//일별로 상품별로 오픈 시간이 다 틀림
function dateopenyn(timeval)
	dim tmpopenyn
	tmpopenyn="N"

	if timeval="" then 
		dateopenyn="N"
		exit function
	end if

	if left(timeval,10)="2015-02-09" then
		if timeval >= #02/09/2015 09:30:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2015-02-10" then
		if timeval >= #02/10/2015 09:30:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2015-02-11" then
		if timeval >= #02/11/2015 09:30:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2015-02-12" then
		if timeval >= #02/12/2015 09:30:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2015-02-13" then
		if timeval >= #02/13/2015 09:30:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2015-02-14" then
		if timeval >= #02/14/2015 09:30:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2015-02-15" then
		if timeval >= #02/15/2015 09:30:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2015-02-16" then
		if timeval >= #02/16/2015 09:30:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2015-02-17" then
		if timeval >= #02/17/2015 09:30:00# then tmpopenyn="Y"
	end if

	dateopenyn=tmpopenyn
end function
%>