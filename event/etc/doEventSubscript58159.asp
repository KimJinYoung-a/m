<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 2015년의 시작, 소원을 빌어요 
' History : 2014.12.30 유태욱 생성
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/etc/event58159Cls.asp" -->

<%
	dim sqlStr, loginid, evt_code, strsql, wish_cnt
	Dim i, mode, Rdevice
	Dim totalsum, cnt
	Dim renloop
	
	randomize
	renloop		=	int(Rnd*100)+1 '100
	'renloop=10
	evt_code	=	getevt_code
	loginid		=	GetLoginUserID()
	mode		=	requestCheckVar(Request("mode"),32)
	
	if isApp=1 then
		Rdevice="A"
	else
		Rdevice="M"
	end if

	dim referer
	referer = request.ServerVariables("HTTP_REFERER")
	'//접속 경로 확인
	if InStr(referer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write "99"
		dbget.close() : Response.End
	end If

	If Not(loginid="" or isNull(loginid)) Then
		sqlstr = "Select count(sub_idx) as totcnt" &_
				"  ,count(case when convert(varchar(10),regdate,120) = '" & Left(now(),10) & "' then sub_idx end) as daycnt" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & evt_code & "' and userid='" & GetLoginUserID() & "'"
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			totalsum = rsget(0)
			cnt = rsget(1)
		rsget.Close
	End if

	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & evt_code & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write "02"
		dbget.close() : Response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write "02"
		dbget.close() : Response.End
	end if
	rsget.Close

	'// 중복이벤트 참여 여부 확인
	if cnt >= 1 then
		Response.Write "06"
		dbget.close() : Response.End
	end if

	dim couponkind, couponnum, couponsum, coupontitle, couponmin
	If getnowdate	=	"2015-01-01" Then
		couponkind	=	"2"
		couponnum	=	681
		couponsum	=	3000
		coupontitle =	"올해도 승승장구!"
		couponmin	=	20000
	Elseif getnowdate = "2015-01-02" Then
		couponkind	=	"2"
		couponnum	=	682
		couponsum	=	5000
		coupontitle =	"로맨스가 듬뿍"
		couponmin	=	30000
	Elseif getnowdate = "2015-01-03" Then
		couponkind	=	"2"
		couponnum	=	683
		couponsum	=	10000
		coupontitle =	"금은보화가 가득"
		couponmin	=	50000
	Elseif getnowdate = "2015-01-04" Then
		couponkind	=	"1"
		couponnum	=	684
		couponsum	=	15
		coupontitle =	"튼튼하고 건강하게"
		couponmin	=	70000
	End if

if mode = "result58159" then
	If renloop < 4 Then
		sqlstr = "select count(*) as cnt2 " &_
				"  from db_event.dbo.tbl_event_subscript where sub_opt1 = '" & getnowdate & "' and evt_code = '" & evt_code & "' and sub_opt3 = 'wish' and sub_opt2 = '10'"
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			wish_cnt = rsget(0)
		rsget.Close

		If wish_cnt < 30 Then	'### 30명만
			sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
					" (evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device) values " &_
					" (" & evt_code &_
					",'" & loginid & "'" &_
					",'" & getnowdate & "'" &_
					",'" & renloop & "'" &_
					",'wish'" &_
					",'" & Rdevice & "')"

			dbget.execute(sqlStr)

			Response.Write "03" '당첨
			dbget.close() : Response.End
		else
			
			sqlStr = "insert into db_user.dbo.tbl_user_coupon " &_
					" (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " &_
					" select '" & couponnum & "','" & loginid & "','" & couponkind & "','" & couponsum & "','" & coupontitle & "','" & couponmin & "','2015-01-01 00:00:00' ,'2015-01-14 23:59:59','',0,'system'"
					'response.write sqlstr
			dbget.execute(sqlStr)

			sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
					" (evt_code, userid, sub_opt1, sub_opt2, device) values " &_
					" (" & evt_code &_
					",'" & loginid & "'" &_
					",'" & getnowdate & "'" &_
					",'" & renloop & "'" &_
					",'" & Rdevice & "')"

			dbget.execute(sqlStr)
			
			Response.Write "04" '꽝
			dbget.close() : Response.End
		End If

	else
		sqlStr = "insert into db_user.dbo.tbl_user_coupon " &_
				" (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " &_
				" select '" & couponnum & "','" & loginid & "','" & couponkind & "','" & couponsum & "','" & coupontitle & "','" & couponmin & "','2015-01-01 00:00:00' ,'2015-01-14 23:59:59','',0,'system'"
				'response.write sqlstr
		dbget.execute(sqlStr)

		sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
				" (evt_code, userid, sub_opt1, sub_opt2, device) values " &_
				" (" & evt_code &_
				",'" & loginid & "'" &_
				",'" & getnowdate & "'" &_
				",'" & renloop & "'" &_
				",'" & Rdevice & "')"

		dbget.execute(sqlStr)

		Response.Write "04" '꽝
		dbget.close() : Response.End
	End If
else
	Response.Write "05"
	dbget.close()	:	response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->