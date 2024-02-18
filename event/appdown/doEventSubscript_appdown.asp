<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	dim refer
	refer = request.ServerVariables("HTTP_REFERER")

	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		response.end
	end If

	dim sqlStr, loginid, couponid, releaseDate, evt_option, strsql , evt_option1 , evt_option2 , evt_option3
	Dim kit , coupon3 , coupon5 , arrList , i, mylist
	dim usermail, couponkey

	IF application("Svr_Info") = "Dev" THEN
		couponid   =  2761 '2016년
	Else
		couponid   =  1060 '2018년
	End If

	evt_option2 = requestCheckVar(Request("spoint"),1)
	loginid = GetLoginUserID()

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"<script>" &_
						"alert('쿠폰을 다운로드 하려면 로그인이 필요합니다.');" &_
						"top.location.href='/login/login.asp?backpath=" & RefURLQ() & "';" &_
						"</script>"
		dbget.close()	:	response.End
	end If

	'// 이벤트 기간 확인 //
	sqlStr = "Select startdate, expiredate " &VBCRLF
	sqlStr = sqlStr & " From [db_user].[dbo].tbl_user_coupon_master " &VBCRLF
	sqlStr = sqlStr & " WHERE idx='" & couponid & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script>" &_
						"alert('존재하지 않는 쿠폰입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("startdate") or date>rsget("expiredate") then
		Response.Write	"<script>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"top.location.href='"& RefURLQ() &"';" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'응모 처리

	Dim cnt , totalsum
	'1회 중복 응모 확인
	sqlStr = " Select count(*) as cnt " &VBCRLF
	sqlStr = sqlStr & " From [db_user].dbo.tbl_user_coupon " &VBCRLF
	sqlStr = sqlStr & " WHERE  masteridx = " & couponid & "" &VBCRLF
	sqlStr = sqlStr & " and userid='" & loginid & "'"
	rsget.Open sqlStr,dbget,1
		cnt=rsget(0)
	rsget.Close

	If cnt = 0 Then
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
		sqlstr = sqlstr & " 	SELECT idx, '"& loginid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,getdate(),dateadd(hh,+24,getdate()),couponmeaipprice,validsitename" + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where idx="& couponid &""
		'response.write sqlstr
		dbget.execute(sqlStr)

		response.write "<script>" &_
			"alert('쿠폰이 발급 되었습니다.\n다운로드후 24시간 사용하실 수 있습니다.');" &_
			"</script>"
		 response.write "<script>location.replace('" + Cstr(refer) + "');</script>"
		dbget.close()	:	response.End
	Else
		Response.write "<script>" &_
				"alert('쿠폰은 1회만 발급 가능합니다.');" &_
				"</script>"
		response.write "<script>location.replace('" + Cstr(refer) + "');</script>"
		response.End	
	End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->