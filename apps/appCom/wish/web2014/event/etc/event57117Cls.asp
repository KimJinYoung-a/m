<%
'####################################################
' Description : [럭키백]크리스박스의 기적 
' History : 2014.12.01 유태욱 생성
'####################################################

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-12-04"
	
	getnowdate = nowdate
end function

function currenttime()
	dim tmpcurrenttime

	tmpcurrenttime = now()
	'tmpcurrenttime = #12/05/2014 15:05:00#

	currenttime = tmpcurrenttime
end function

function datetmp()
	dim tmpdatea, tmpdateb
	tmpdatea =  Day(left(currenttime,10))
	tmpdateb = tmpdatea mod 2

	if tmpdateb > 0 then
		datetmp = ""
	else
		datetmp = "a"
	end if
end function

function stylecoange(vdate)
	dim tmpval

	if vdate="" then exit function
	
	if hour(currenttime) < 15 then
		tmpval="a"
	else
		tmpval="b"
	end if

	stylecoange = tmpval
end function

function dateitemval()
	dim tmpdateitemval

	IF application("Svr_Info") = "Dev" THEN
		tmpdateitemval="1000094"
	Else
		tmpdateitemval="1176393"
	End If

	dateitemval=tmpdateitemval
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21387
	Else
		evt_code   =  57117
	End If
	
	getevt_code = evt_code
end function

'//상품 한정수량
function itemlimitcnt(itemid)
'	dim tmpitemlimitcnt ,sqlstr
'	tmpitemlimitcnt=0
'	
'	if itemid="" then
'		itemlimitcnt=0
'		exit function
'	end if
'
'	sqlstr = "select top 1 isnull(limitno,0) as limitno, isnull(limitsold,0) as limitsold"
'	sqlstr = sqlstr & " from db_item.dbo.tbl_item"
'	sqlstr = sqlstr & " where itemid="&itemid&""
'
'	'response.write sqlstr & "<Br>"
'	rsget.Open sqlstr,dbget
'	IF not rsget.EOF THEN
'		tmpitemlimitcnt = rsget("limitno")
'		
'		if (rsget("limitno")-rsget("limitsold")) < 1 then tmpitemlimitcnt=0
'	END IF
'	rsget.close
'	
'	itemlimitcnt=tmpitemlimitcnt
	itemlimitcnt=3000
end function
%>