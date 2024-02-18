<%
'####################################################
' Description : 기승전 2차 매일 매일 한가위만 같아라
' History : 2014.08.29 한용민 생성
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-09-02"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21282
	Else
		evt_code   =  54589
	End If
	
	getevt_code = evt_code
end function

function getevt_codepage()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21283
	Else
		evt_code   =  54590
	End If
	
	getevt_codepage = evt_code
end function

function randomitemcnt(dateval)
	dim tmpcount
	
	IF dateval="2014-09-02" THEN
		tmpcount   =  6
	elseIF dateval="2014-09-03" THEN
		tmpcount   =  6
	elseIF dateval="2014-09-04" THEN
		tmpcount   =  5
	elseIF dateval="2014-09-05" THEN
		tmpcount   =  3
	elseIF dateval="2014-09-06" THEN
		tmpcount   =  3
	elseIF dateval="2014-09-07" THEN
		tmpcount   =  5
	elseIF dateval="2014-09-08" THEN
		tmpcount   =  5
	elseIF dateval="2014-09-09" THEN
		tmpcount   =  3
	Else
		tmpcount   =  1
	End If
	
	randomitemcnt = tmpcount
end function

function limitgift(dateval)
	dim tmpcount
	
	IF dateval="2014-09-02" THEN
		tmpcount   =  150
	elseIF dateval="2014-09-03" THEN
		tmpcount   =  200
	elseIF dateval="2014-09-04" THEN
		tmpcount   =  100
	elseIF dateval="2014-09-05" THEN
		tmpcount   =  50
	elseIF dateval="2014-09-06" THEN
		tmpcount   =  50
	elseIF dateval="2014-09-07" THEN
		tmpcount   =  100
	elseIF dateval="2014-09-08" THEN
		tmpcount   =  100
	elseIF dateval="2014-09-09" THEN
		tmpcount   =  50
	Else
		tmpcount   =  0
	End If
	
	limitgift = tmpcount
end function

function get54589event_subscriptarr(evt_code, userid)
	dim sqlstr, tmparr
	
	if evt_code="" or userid="" then
		get54589event_subscriptarr=""
		exit function
	end if
	
	sqlstr = "select top 50 isnull(sc.sub_opt1,'') as sub_opt1, isnull(sc.sub_opt2,'') as sub_opt2, isnull(sc.sub_opt3,'') as sub_opt3"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& evt_code &""
	sqlstr = sqlstr & " and sc.userid='"& userid &"'"
	sqlstr = sqlstr & " and isnull(sc.sub_opt1,'') in ('2014-09-02','2014-09-03','2014-09-04','2014-09-05','2014-09-06','2014-09-07','2014-09-08','2014-09-09')"
	sqlstr = sqlstr & " and isnull(sc.sub_opt2,'') in (1,2)"
	sqlstr = sqlstr & " order by sc.sub_idx asc"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmparr = rsget.getrows()
	END IF
	rsget.close
	
	get54589event_subscriptarr = tmparr
end function

function get54589event_subscriptresultval(evt_code, userid, sub_opt1)
	dim sqlstr, tmparr
	
	if evt_code="" or userid="" or sub_opt1="" then
		get54589event_subscriptresultval=""
		exit function
	end if
	
	sqlstr = "select top 1 isnull(sc.sub_opt1,'') as sub_opt1, isnull(sc.sub_opt2,'') as sub_opt2, isnull(sc.sub_opt3,'') as sub_opt3"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.evt_code="& evt_code &""
	sqlstr = sqlstr & " and sc.userid='"& userid &"'"
	sqlstr = sqlstr & " and isnull(sc.sub_opt1,'') = '"& sub_opt1 &"'"
	sqlstr = sqlstr & " and isnull(sc.sub_opt2,'') in (1,2)"
	sqlstr = sqlstr & " order by sc.sub_idx desc"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmparr = rsget.getrows()
	END IF
	rsget.close
	
	get54589event_subscriptresultval = tmparr
end function
%>