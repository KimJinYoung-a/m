<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  오빠나믿지? socar
' History : 2014.12.11 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event57644Cls.asp" -->

<%
dim si, mode, tmpval, addrval, sqlstr, gu, mm, dd, email
	si = requestcheckvar(request("si"),8)
	gu = requestcheckvar(request("gu"),10)
	mm =  getNumeric(requestcheckvar(request("mm"),2))
	dd =  getNumeric(requestcheckvar(request("dd"),2))
	email = requestcheckvar(request("email"),128)
	mode = requestcheckvar(request("mode"),32)
	
dim eCode, userid, i
	eCode=getevt_code
	userid = getloginuserid()

dim subscriptcount, firstsubscriptcount, couponexistscount
	subscriptcount=0
	firstsubscriptcount=0
	couponexistscount=0

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

if mode="mmchange" then
	If not(getnowdate>="2014-12-15" and getnowdate<"2014-12-22") Then
		Response.Write "02"
		dbget.close() : Response.End
	End IF	
	if si="" then
		Response.Write "03"
		dbget.close() : Response.End
	end if
	
	sqlstr = "select top 300 addr_gu"
	sqlstr = sqlstr & " from db_zipcode.dbo.ADDR080TL"
	sqlstr = sqlstr & " where addr_si='"& si &"'"
	sqlstr = sqlstr & " group by addr_gu"
	sqlstr = sqlstr & " order by addr_gu asc"
	
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmpval = rsget.getrows()
	END IF
	rsget.close
	
	addrval = "<option value=''>시/군/구 선택하기</option>"

	if isarray(tmpval) then
		for i = 0 to ubound(tmpval,2)
		addrval = addrval & "<option value='"& tmpval(0,i) &"'>"& tmpval(0,i) &"</option>"
		next
	end if
	
	Response.Write "01" & "!@#" & addrval
	dbget.close() : Response.End

elseif mode="couponinsert" then
	If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	End IF
	If si = "" Then
		Response.Write "<script type='text/javascript'>alert('쏘카를 수령하실 도/시 를 선택해 주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	End IF
	If gu = "" Then
		Response.Write "<script type='text/javascript'>alert('쏘카를 수령하실 시/군/구 를 선택해 주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	End IF
	If mm = "" Then
		Response.Write "<script type='text/javascript'>alert('쏘카를 수령하실 월을 선택해 주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	End IF
	If dd = "" Then
		Response.Write "<script type='text/javascript'>alert('쏘카를 수령하실 일을 선택해 주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	End IF
	If email = "" Then
		Response.Write "<script type='text/javascript'>alert('쏘카에 가입된 이메일 ID를 입력해 주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	End IF
	if checkNotValidHTML(email) or checkNotValidHTML(si) or checkNotValidHTML(gu) or checkNotValidHTML(mm) or checkNotValidHTML(dd) then
		Response.Write "<script type='text/javascript'>alert('유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	end if
		
	If not(getnowdate>="2014-12-15" and getnowdate<"2014-12-22") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	End IF
	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.Write "<script type='text/javascript'>alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	end if
					
	'//본인 참여 여부
	subscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate(), "", "")
	if subscriptcount <> 0 then
		Response.Write "<script type='text/javascript'>alert('하루에 한번만 참여 가능 합니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	end if

	firstsubscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")
	'//본인쿠폰다운로드수
	couponexistscount = getbonuscouponexistscount(userid, couponval57644(), "", "", "")
	
	if firstsubscriptcount=0 and couponexistscount=0 then
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate() &"', 1, '"& si & "!1@#" & gu & "!2@#" & mm & "-" & dd & "!3@#" & email &"', 'M')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
				
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
		sqlstr = sqlstr & "		SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename" + vbcrlf
		sqlstr = sqlstr & "		from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & "		where idx="& couponval57644() &""
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript' src='/js/jquery-1.7.1.min.js'></script>"
		Response.Write "<script type='text/javascript'>parent.$('#lypop').show(); parent.$('.mask').show();</script>"		
	else
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate() &"', 0, '"& si & "!1@#" & gu & "!2@#" & mm & "-" & dd & "!3@#" & email &"', 'M')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		
		Response.Write "<script type='text/javascript'>alert('응모해 주셔서 감사합니다!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	end if
	
else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->