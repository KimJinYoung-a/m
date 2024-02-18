<%
'####################################################
' Description : 슈퍼백의 기적(박스이벤트)
' History : 2015.03.11 한용민 생성
'####################################################

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()
	'tmpcurrenttime = #03/23/2015 10:05:00#
	
	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21494
	Else
		evt_code   =  59795
	End If
	
	getevt_code = evt_code
end function

function getevt_codedisp()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21493
	Else
		evt_code   =  59796
	End If

	getevt_codedisp = evt_code
end function

function getbonuscoupon()
	dim tmpbonuscoupon
	
	IF application("Svr_Info") = "Dev" THEN
		tmpbonuscoupon   =  395
	Else
		tmpbonuscoupon   =  707
	End If
	
	getbonuscoupon = tmpbonuscoupon
end function

function getdateitem(dateval)
	dim tmpdateitem

	if dateval="" then
		getdateitem=""
		exit function
	end if

	IF application("Svr_Info") = "Dev" THEN
		if dateval="2015-03-16" then
			tmpdateitem=662881
		elseif dateval="2015-03-17" then
			tmpdateitem=662880
		elseif dateval="2015-03-18" then
			tmpdateitem=662878
		elseif dateval="2015-03-19" then
			tmpdateitem=662872
		elseif dateval="2015-03-20" then
			tmpdateitem=662867
		elseif dateval="2015-03-23" then
			tmpdateitem=662865
		elseif dateval="2015-03-24" then
			tmpdateitem=662842
		elseif dateval="2015-03-25" then
			tmpdateitem=662838
		else
			tmpdateitem=""
		end if
	Else
		if dateval="2015-03-16" then
			tmpdateitem=1224460
		elseif dateval="2015-03-17" then
			tmpdateitem=1224461
		elseif dateval="2015-03-18" then
			tmpdateitem=1224462
		elseif dateval="2015-03-19" then
			tmpdateitem=1224482
			'tmpdateitem=1224466
		elseif dateval="2015-03-20" then
			tmpdateitem=1224472
		elseif dateval="2015-03-23" then
			tmpdateitem=1224478
		elseif dateval="2015-03-24" then
			tmpdateitem=1224479
		elseif dateval="2015-03-25" then
			tmpdateitem=1224481
		else
			tmpdateitem=""
		end if
	End If

	getdateitem=tmpdateitem
end function

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

%>