<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim sqlStr, loginid, evt_code, mode , masteridx , spoint , releaseDate
	loginid = GetLoginUserID()
	releaseDate = requestCheckVar(Request("releaseDate"),42)
	mode = requestCheckVar(Request("mode"),5)		'이벤트 코드
	spoint = requestCheckVar(Request("spoint"),1)		'이벤트 코드
	if releaseDate="" then releaseDate = "2월 3일에"

	IF application("Svr_Info") = "Dev" THEN
		masteridx = 296
		evt_code = "21056"
	Else
		masteridx = 536
		evt_code = "48679"
	End If
	
	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & evt_code & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script language='javascript'>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script language='javascript'>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"<script language='javascript'>" &_
						"alert('이벤트에 응모를 하려면 로그인이 필요합니다.');" &_
						"top.location.href='/login/login.asp?backpath=" & RefURLQ() & "';" &_
						"</script>"
		dbget.close()	:	response.End
	end If

	Dim cnt
	sqlStr = "Select count(idx) " &_
			" From db_user.dbo.tbl_user_coupon " &_
			" WHERE masteridx='" & masteridx & "'" &_
			" and userid='" & loginid & "'"
	rsget.Open sqlStr,dbget,1

	cnt = rsget(0)
	rsget.Close
	If cnt >= 1 Then
		response.write "<script type='text/javascript'>" &_
						"alert('쿠폰 다운은 한 번만 가능합니다.');" &_
						"top.location.href='/event/eventmain.asp?eventid="&evt_code&"';" &_
						"</script>"&_
	else
		sqlStr = "insert into db_user.dbo.tbl_user_coupon " &_
				" (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " &_
				" select '"& masteridx &"','" & loginid & "','2','5000','[카카오톡] 친구야 새해 복 Money 받아','40000' , '2014-01-20 00:00:00', '2014-02-02 23:59:59', '', 0, 'system'"

		dbget.execute(sqlStr)
			response.write "<script type='text/javascript'>" &_
				"alert('쿠폰 다운이 완료 되었습니다.');" &_
				"top.location.href='/event/eventmain.asp?eventid="&evt_code&"';" &_
				"</script>" &_
		dbget.close()	:	response.End
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->