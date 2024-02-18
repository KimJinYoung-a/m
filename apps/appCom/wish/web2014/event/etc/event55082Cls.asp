<%
'####################################################
' Description : [13주년] 즐겨라,텐바이텐_ 게릴라! 앱 쇼
' History : 2014.10.02 한용민 생성
'####################################################

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

function currenttime()
	dim tmpcurrenttime

	tmpcurrenttime = now()
	'tmpcurrenttime = #10/06/2014 11:01:00#

	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21313
	Else
		evt_code   =  55082
	End If

	getevt_code = evt_code
end function

function getevt_codeprint()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21315
	Else
		evt_code   =  55084
	End If

	getevt_codeprint = evt_code
end function

'//일별로 상품별로 오픈 시간이 다 틀림
function dateopenyn(timeval)
	dim tmpopenyn
	tmpopenyn="N"

	if timeval="" then exit function

	if left(timeval,10)="2014-10-06" then
		if timeval >= #10/06/2014 10:10:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2014-10-07" then
		if timeval >= #10/07/2014 10:00:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2014-10-08" then
		if timeval >= #10/08/2014 09:30:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2014-10-09" then
		if timeval >= #10/09/2014 10:00:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2014-10-10" then
		if timeval >= #10/10/2014 09:00:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2014-10-13" then
		if timeval >= #10/13/2014 10:10:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2014-10-14" then
		if timeval >= #10/14/2014 11:00:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2014-10-15" then
		if timeval >= #10/15/2014 09:30:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2014-10-16" Then '// 오픈시간
		if timeval >= #10/16/2014 10:00:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2014-10-17" then
		if timeval >= #10/17/2014 10:00:00# then tmpopenyn="Y"
	elseif left(timeval,10)="2014-10-20" then
		if timeval >= #10/20/2014 10:00:00# then tmpopenyn="Y"
	end if

	dateopenyn=tmpopenyn
end function

'//날짜별 해당 상품 코드 처리
function dateitemval(dateval)
	dim tmpdateitemval
	if dateval="" then exit function

	if dateval="2014-10-06" then
		tmpdateitemval="1134937"
	elseif dateval="2014-10-07" then
		tmpdateitemval="1134966"
	elseif dateval="2014-10-08" then
		tmpdateitemval="1135053"
	elseif dateval="2014-10-09" then
		tmpdateitemval="1136019"
	elseif dateval="2014-10-10" then
		tmpdateitemval="1135065"
	elseif dateval="2014-10-13" then
		tmpdateitemval="1135072"
	elseif dateval="2014-10-14" then
		tmpdateitemval="1135078"
	elseif dateval="2014-10-15" then
		tmpdateitemval="1135085"
	elseif dateval="2014-10-16" then
		tmpdateitemval="1135099"
	elseif dateval="2014-10-17" then
		tmpdateitemval="1135105"
	elseif dateval="2014-10-20" then
		tmpdateitemval="1135111"
	else
		tmpdateitemval="1134937"
	end if

	dateitemval=tmpdateitemval
end function

'//날자별 상품별 상품상세내역 처리
function dateitemcontents(dateval)
	dim tmpdateitemcontents
	if dateval="" then exit function

	if dateval="2014-10-06" then
		tmpdateitemcontents="<span>Lamy Safari 만년필 / 54,000원</span>"	'/108,000
	elseif dateval="2014-10-07" then
		tmpdateitemcontents="<span>샤오미 보조 배터리 실버 / 26,800원</span>"	'/53,600
	elseif dateval="2014-10-08" then
		tmpdateitemcontents="<span>플라워 USB 가습기 / 20,000원</span>"		'/40,000
	elseif dateval="2014-10-09" then
		tmpdateitemcontents="<span>Hungry Bunny (당근토끼 LED램프) / 13,800원</span>"		'/27,600
	elseif dateval="2014-10-10" then
		tmpdateitemcontents="<span>마이빈스 더치팩 / 13,000원</span>"		'/26,000
	elseif dateval="2014-10-13" then
		tmpdateitemcontents="<span>[아이리버] 블랭크 블루투스 스피커사운드 드럼 / 49,000원</span>"		'/98,000
	elseif dateval="2014-10-14" then
		tmpdateitemcontents="<span>[트라이브] 심슨캐릭터 USB메모리(8G) / 29,900원</span>"		'/59,800
	elseif dateval="2014-10-15" then
		tmpdateitemcontents="<span>KIND BAG _ WAXWEAR / 27,000원</span>"	'/54,000
	elseif dateval="2014-10-16" then
		tmpdateitemcontents="<span>폭스바겐 마이크로버스 / 9,000원</span>"		'/18,000
	elseif dateval="2014-10-17" then
		tmpdateitemcontents="<span>TRAVELLER_CHAIR_GREEN / 19,000원</span>"		'/38,000
	elseif dateval="2014-10-20" then
		tmpdateitemcontents="<span>곰주 티인퓨져 / 12,800원</span>"		'/25,600
	else
		tmpdateitemcontents="<span>Lamy Safari 만년필 / 54,000원</span>"	'/108,000
	end if

	dateitemcontents=tmpdateitemcontents
end function

'//날짜별 보너스쿠폰 번호 처리
function datecouponval(dateval)
	dim tmpdatecouponval
	if dateval="" then exit function

	IF application("Svr_Info") = "Dev" THEN
		if dateval="2014-10-06" then
			tmpdatecouponval="357"
		elseif dateval="2014-10-07" then
			tmpdatecouponval="358"
		elseif dateval="2014-10-08" then
			tmpdatecouponval="359"
		elseif dateval="2014-10-09" then
			tmpdatecouponval="360"
		elseif dateval="2014-10-10" then
			tmpdatecouponval="361"
		elseif dateval="2014-10-13" then
			tmpdatecouponval="362"
		elseif dateval="2014-10-14" then
			tmpdatecouponval="363"
		elseif dateval="2014-10-15" then
			tmpdatecouponval="364"
		elseif dateval="2014-10-16" then
			tmpdatecouponval="365" '// 쿠폰idx(테섭)
		elseif dateval="2014-10-17" then
			tmpdatecouponval="366"
		elseif dateval="2014-10-20" then
			tmpdatecouponval="367"
		else
			tmpdatecouponval=""
		end if
	Else
		if dateval="2014-10-06" then
			tmpdatecouponval="644"
		elseif dateval="2014-10-07" then
			tmpdatecouponval="645"
		elseif dateval="2014-10-08" then
			tmpdatecouponval="646"
		elseif dateval="2014-10-09" then
			tmpdatecouponval="647"
		elseif dateval="2014-10-10" then
			tmpdatecouponval="648"
		elseif dateval="2014-10-13" then
			tmpdatecouponval="649"
		elseif dateval="2014-10-14" then
			tmpdatecouponval="650"
		elseif dateval="2014-10-15" then
			tmpdatecouponval="651"
		elseif dateval="2014-10-16" then
			tmpdatecouponval="652" '// 쿠폰idx(실섭)
		elseif dateval="2014-10-17" then
			tmpdatecouponval="653"
		elseif dateval="2014-10-20" then
			tmpdatecouponval="654"
		else
			tmpdatecouponval=""
		end if
	End If

	datecouponval=tmpdatecouponval
end function

'//날짜별 이미지 넘버 처리
function datenumber(dateval)
	dim tmpdatenumber
	if dateval="" then exit function

	if dateval="2014-10-06" then
		tmpdatenumber="01"
	elseif dateval="2014-10-07" then
		tmpdatenumber="02"
	elseif dateval="2014-10-08" then
		tmpdatenumber="03"
	elseif dateval="2014-10-09" then
		tmpdatenumber="04"
	elseif dateval="2014-10-10" then
		tmpdatenumber="05"
	elseif dateval="2014-10-13" then
		tmpdatenumber="06"
	elseif dateval="2014-10-14" then
		tmpdatenumber="07"
	elseif dateval="2014-10-15" then
		tmpdatenumber="08"
	elseif dateval="2014-10-16" then
		tmpdatenumber="09"
	elseif dateval="2014-10-17" then
		tmpdatenumber="10"
	elseif dateval="2014-10-20" then
		tmpdatenumber="11"
	else
		tmpdatenumber="01"
	end if

	datenumber=tmpdatenumber
end function

'//쿠폰제한수량
function limitbounscoupon()
	limitbounscoupon=0 '// 쿠폰 제한수량(변경가능)
end Function


'// 한명한테만 쿠폰 밀어넣을때
'insert into [db_user].[dbo].tbl_user_coupon
'(masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)
'	SELECT idx, 'hoony83sk',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,'2014-10-16 00:00:00','2014-10-16 23:59:59',couponmeaipprice,validsitename
'	from [db_user].[dbo].tbl_user_coupon_master m
'	where idx=652

'insert into [db_event].[dbo].[tbl_event_subscript] (evt_code,userid,sub_opt1,device)
'values (55082,'hoony83sk', '2014-10-16','A')

%>