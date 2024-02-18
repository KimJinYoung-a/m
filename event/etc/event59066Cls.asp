<%
'####################################################
' Description :  구매금액별 사은이벤트 선물 못받을까바 오빠가 오다 주웠다
' History : 2015.01.30 한용민 생성
'####################################################

function staffconfirm()
	'staffconfirm=TRUE
	staffconfirm=FALSE
end function

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2015-02-02"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21459
	Else
		evt_code   =  59066
	End If

	getevt_code = evt_code
end function

function getevt_codedisp()
	dim evt_code

	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21461
	Else
		evt_code   =  59067
	End If

	getevt_codedisp = evt_code
end function
	
'//텐바이텐 구매내역 조회
function get10x10onlineorder(userid, startdate, enddate, sitename, rdsite, beadaldiv, cancelyn)
	dim sqlstr, tmp10x10onlineorder
	
	if startdate="" or enddate="" then
		get10x10onlineorder=0
		exit function
	end if

	sqlstr = sqlstr & " select top 10"
	sqlstr = sqlstr & " m.orderserial, m.subtotalpriceCouponNotApplied"
	sqlstr = sqlstr & " from db_order.dbo.tbl_order_master m"
	sqlstr = sqlstr & " left join [db_event].[dbo].[tbl_event_subscript] s"
	sqlstr = sqlstr & " 	on m.userid=s.userid"
	sqlstr = sqlstr & " 	and m.orderserial=s.sub_opt1"
	sqlstr = sqlstr & " 	and s.evt_code="& getevt_code &""
	sqlstr = sqlstr & " where m.regdate >= '"& startdate &"' and m.regdate < '"& enddate &"' "
	sqlstr = sqlstr & " and m.jumundiv<>9"
	sqlstr = sqlstr & " and m.ipkumdiv>3"
	sqlstr = sqlstr & " and s.evt_code is null"
	sqlstr = sqlstr & " and m.userid='"& userid &"'"
	sqlstr = sqlstr & " and m.cancelyn='"& cancelyn &"'"
	
	if sitename<>"" then
		sqlstr = sqlstr & " and m.sitename='"& sitename &"'"
	end if
	if rdsite<>"" then
		sqlstr = sqlstr & " and m.rdsite='"& rdsite &"'"
	end if
		
	if beadaldiv<>"" then
		sqlstr = sqlstr & " and m.beadaldiv in ("& beadaldiv &")"
	end if
	
	sqlstr = sqlstr & " order by m.orderserial desc"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmp10x10onlineorder = rsget.getrows()
	END IF
	rsget.close
	
	get10x10onlineorder = tmp10x10onlineorder
end function
%>