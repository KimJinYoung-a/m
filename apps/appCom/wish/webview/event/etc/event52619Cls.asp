<%
'####################################################
' Description : 만원 팔이피플
' History : 2014.06.11 한용민 생성
'####################################################

function staffconfirm()
	staffconfirm=TRUE
	'staffconfirm=FALSE
end function

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()
	'tmpcurrenttime = #06/16/2014 13:05:00#
	
	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21203
	Else
		evt_code   =  52619
	End If
	
	getevt_code = evt_code
end function

function dateitemlinkval(dateval)
	dim tmpdateitemlinkval
	if dateval="" then exit function

	IF application("Svr_Info") = "Dev" THEN
		if dateval="2014-06-16" then
			tmpdateitemlinkval="&ldv=MzIwMSAg"
		elseif dateval="2014-06-17" then
			tmpdateitemlinkval="&ldv=MzIwMiAg"
		elseif dateval="2014-06-18" then
			tmpdateitemlinkval="&ldv=MzIwMyAg"
		elseif dateval="2014-06-19" then
			tmpdateitemlinkval="&ldv=MzIwNCAg"
		elseif dateval="2014-06-20" then
			tmpdateitemlinkval="&ldv=MzIwNSAg"
		else
			tmpdateitemlinkval=""
		end if
	Else
		if dateval="2014-06-16" then
			tmpdateitemlinkval="&ldv=OTQ0MCAg"
		elseif dateval="2014-06-17" then
			tmpdateitemlinkval="&ldv=OTQ0MSAg"
		elseif dateval="2014-06-18" then
			tmpdateitemlinkval="&ldv=OTQ1OCAg"
		elseif dateval="2014-06-19" then
			tmpdateitemlinkval="&ldv=OTQ0MyAg"
		elseif dateval="2014-06-20" then
			tmpdateitemlinkval="&ldv=OTQ0NCAg"
		else
			tmpdateitemlinkval=""
		end if
	End If

	dateitemlinkval=tmpdateitemlinkval
end function

function dateitemval(dateval)
	dim tmpdateitemval
	if dateval="" then exit function

	IF application("Svr_Info") = "Dev" THEN
		if dateval="2014-06-16" then
			tmpdateitemval="1000065"
		elseif dateval="2014-06-17" then
			tmpdateitemval="1000011"
		elseif dateval="2014-06-18" then
			tmpdateitemval="1000004"
		elseif dateval="2014-06-19" then
			tmpdateitemval="668928"
		elseif dateval="2014-06-20" then
			tmpdateitemval="666045"
		else
			tmpdateitemval=""
		end if
	Else
		if dateval="2014-06-16" then
			tmpdateitemval="1073195"
		elseif dateval="2014-06-17" then
			tmpdateitemval="1073237"
		elseif dateval="2014-06-18" then
			tmpdateitemval="1073229"
		elseif dateval="2014-06-19" then
			tmpdateitemval="1073224"
		elseif dateval="2014-06-20" then
			tmpdateitemval="1073520"
		else
			tmpdateitemval=""
		end if
	End If

	dateitemval=tmpdateitemval
end function

function datecouponval(dateval)
	dim tmpdatecouponval
	if dateval="" then exit function

	IF application("Svr_Info") = "Dev" THEN
		if dateval="2014-06-16" then
			tmpdatecouponval="3201"
		elseif dateval="2014-06-17" then
			tmpdatecouponval="3202"
		elseif dateval="2014-06-18" then
			tmpdatecouponval="3203"
		elseif dateval="2014-06-19" then
			tmpdatecouponval="3204"
		elseif dateval="2014-06-20" then
			tmpdatecouponval="3205"
		else
			tmpdatecouponval=""
		end if
	Else
		if dateval="2014-06-16" then
			tmpdatecouponval="9440"
		elseif dateval="2014-06-17" then
			tmpdatecouponval="9441"
		elseif dateval="2014-06-18" then
			tmpdatecouponval="9458"
		elseif dateval="2014-06-19" then
			tmpdatecouponval="9443"
		elseif dateval="2014-06-20" then
			tmpdatecouponval="9444"
		else
			tmpdatecouponval=""
		end if
	End If

	datecouponval=tmpdatecouponval
end function

'//상품 한정수량
function itemlimitcnt(itemid)
	dim tmpitemlimitcnt ,sqlstr
	tmpitemlimitcnt=0
	
	if itemid="" then
		itemlimitcnt=0
		exit function
	end if

	sqlstr = "select top 1 isnull(limitno,0) as limitno, isnull(limitsold,0) as limitsold"
	sqlstr = sqlstr & " from db_item.dbo.tbl_item"
	sqlstr = sqlstr & " where itemid="&itemid&""

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmpitemlimitcnt = rsget("limitno")
		
		if (rsget("limitno")-rsget("limitsold")) < 1 then tmpitemlimitcnt=0
	END IF
	rsget.close
	
	itemlimitcnt=tmpitemlimitcnt
end function
%>