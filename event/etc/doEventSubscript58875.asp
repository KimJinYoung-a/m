<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->

<%
dim eCode, userid, sqlstr, mode, vLinkECode
mode = requestcheckvar(request("mode"),32)
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21455"
		vLinkECode = "21455"
	Else
		eCode = "58875"
		vLinkECode = "58875"
	End If

userid = GetLoginUserID

	'response.write "<script language='javascript'>alert('이벤트가 종료되었습니다.'); parent.location.reload();</script>"
	'dbget.close()
    'response.end

If userid = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

dim smssubscriptcount
	smssubscriptcount=0
	
	
if mode="addsms" then

elseif mode="coupon" then
	Dim vQuery

	If Now() < #01/28/2015 08:59:59# Then
		response.write "<script language='javascript'>alert('오전 9시부터 다운 받으실 수 있습니다.'); parent.location.reload();</script>"
		dbget.close()
	    response.end
	End IF

	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '691' and userid = '" & userid & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		response.write "<script language='javascript'>alert('이미 다운받으셨습니다.'); parent.location.reload();</script>"
		rsget.close()
		dbget.close()
	    response.end
	End IF
	rsget.close()

	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '691' "
	rsget.Open vQuery,dbget,1
	If rsget(0) > 16000 Then
		response.write "<script language='javascript'>alert('쿠폰 발급이 종료되었습니다.'); parent.location.reload();</script>"
		rsget.close()
		dbget.close()
	    response.end
	End IF
	rsget.close()


'	vQuery = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
'	vQuery = vQuery & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
'	vQuery = vQuery & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename" + vbcrlf
'	vQuery = vQuery & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
'	vQuery = vQuery & " 	where idx=691"
'	dbget.execute vQuery

'		response.write "<script language='javascript'>alert('발급완료!\n쿠폰은 금일 1/28(수) 23시59분 종료됩니다!'); parent.top.location.reload();</script>"
'		dbget.close()
	    response.end
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->