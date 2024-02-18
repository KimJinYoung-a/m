<%
'####################################################
' Description : 돌아온 크리스박스의 기적!
' History : 2015.12.07 유태욱 생성
'####################################################

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()
	'tmpcurrenttime = #12/09/2015 10:05:00#

	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  65978
	Else
		evt_code   =  67929
	End If
	
	getevt_code = evt_code
end function

function getevt_codedisp()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  65978
	Else
		evt_code   =  67929
	End If

	getevt_codedisp = evt_code
end function

function getbonuscoupon()
	dim tmpbonuscoupon
	
	IF application("Svr_Info") = "Dev" THEN
		tmpbonuscoupon   =  2754
	Else
		tmpbonuscoupon   =  803
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
		if dateval="2015-12-09" or dateval="2015-12-10" or dateval="2015-12-11" then
			tmpdateitem=1212183

		elseif dateval="2015-12-16" or dateval="2015-12-17" or dateval="2015-12-18" then
			tmpdateitem=1212183

		else
			tmpdateitem=""
		end if
	Else
		if dateval="2015-12-09" or dateval="2015-12-10" or dateval="2015-12-11" then
			tmpdateitem=1404138

		elseif dateval="2015-12-16" or dateval="2015-12-17" or dateval="2015-12-18" then
			tmpdateitem=1404911

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

''전날 얼리버드 예약됬는지 체크
function earlybird(earlybirddateval)
	dim earlybirddatest, earlybirddateed, tmpearlybirddata, sqlstr

	if earlybirddateval="" then
		earlybirddatest=""
		earlybirddateed=""
		exit function
	end if

	if earlybirddateval = "2015-12-10" then
		earlybirddatest = "2015-12-09"
		earlybirddateed = "2015-12-09"
	elseif earlybirddateval = "2015-12-11" then
		earlybirddatest = "2015-12-10"
		earlybirddateed = "2015-12-10"

	elseif earlybirddateval = "2015-12-16" then
		earlybirddatest = "2015-12-11"
		earlybirddateed = "2015-12-15"
	elseif earlybirddateval = "2015-12-17" then
		earlybirddatest = "2015-12-16"
		earlybirddateed = "2015-12-16"
	elseif earlybirddateval = "2015-12-18" then
		earlybirddatest = "2015-12-17"
		earlybirddateed = "2015-12-17"
	end if

'	sqlstr = "select top 1 userid from db_log.[dbo].[tbl_caution_event_log] where evt_code='"&getevt_code&"' and userid='"& userid &"' and value1='al_com' and convert(varchar(10),regdate,121) = '"& earlybirddatest &"' "
	sqlstr = "select top 1 userid from db_log.[dbo].[tbl_caution_event_log] where evt_code='"&getevt_code&"' and userid='"& userid &"' and value1='al_com' and regdate between '"&earlybirddatest&" 00:00:00' and '"&earlybirddateed&" 23:59:59' "
	
	'response.write sqlstr & "<br>"
	rsget.Open sqlstr, dbget, 1
	If Not rsget.Eof Then
		'//최초 응모
		tmpearlybirddata = rsget(0) '전날 얼리버드 예약한사람
	End IF
	rsget.close
	
	earlybird=tmpearlybirddata
	
	if earlybird <> "" then
		earlybird = "OK"
	end if
end function

'// 당첨자 핸드폰번호로 걸러내기
Function event_userCell_Selection67929(usercell, stevtDate, edevtDate, evtcode)
	Dim sqlstr
	sqlstr = " Select count(e.userid) From db_event.dbo.tbl_event_subscript e "
	sqlstr = sqlstr & " inner join db_user.dbo.tbl_user_n u on e.userid = u.userid "
	sqlstr = sqlstr & " Where evt_code='"&evtcode&"' And sub_opt2 <> 0 And convert(varchar(10), e.regdate, 120) >= '"&stevtDate&"' And convert(varchar(10), e.regdate, 120) <= '"&edevtDate&"'"
	sqlstr = sqlstr & " And usercell='"&usercell&"' "
	rsget.Open sqlstr,dbget
		event_userCell_Selection67929 = rsget(0)
	rsget.close

End Function

%>