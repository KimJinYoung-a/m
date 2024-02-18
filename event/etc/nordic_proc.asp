<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  크리스마스 이벤트(01)M
' History : 2014.11.27 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
dim eCode, userid, sqlstr, mode, rvalue, vQuery
	userid = GetLoginUserID
	mode = requestcheckvar(request("mode"),32)
	ecode = requestcheckvar(request("ecode"),32)

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-12-01"
	
	getnowdate = nowdate
end function

If userid = "" Then
	'response.write "<script language='javascript'>alert('로그인을 해주세요.'); parent.location.reload();</script>"
	response.write 99
	dbget.close() : Response.End
End IF

If ecode = "" Then
	'response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	response.write "i3"
	dbget.close() : Response.End
End IF

if mode="coupon" then
	If getnowdate>="2014-12-01" and getnowdate<="2014-12-23" Then
		if ecode = "57042" or ecode = "21371" or ecode = "57044" or ecode = "21372" or ecode = "57045" or ecode = "21373" then
			vQuery = "select count(*) from [db_item].[dbo].tbl_user_item_coupon where itemcouponidx = '" & datecouponval & "' and userid = '" & userid & "'"
			rsget.Open vQuery,dbget,1
		elseif ecode = "57046" or ecode = "21374" then
			vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '" & datecouponval & "' and userid = '" & userid & "'"
			rsget.Open vQuery,dbget,1
		end if
	
		If rsget(0) > 0 Then
			'response.write "<script language='javascript'>alert('이미 다운받으셨습니다.'); parent.location.reload();</script>"
			response.write "i2"
			rsget.close()
			dbget.close() : Response.End
		End IF
		rsget.close()
	
		if ecode = "57042" or ecode = "21371" or ecode = "57044" or ecode = "21372" or ecode = "57045" or ecode = "21373" then
			rvalue = fnSetItemCouponDown(userid, datecouponval() )	'/itemcoupon 처리
			SELECT CASE  rvalue
				CASE 0
					Response.write "i3"  	
					'Response.Write "<script type='text/javascript'>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
					dbget.close() : Response.End
				CASE 1
					response.write "i1"
					'Response.Write "<script type='text/javascript'>alert('고객님! 쿠폰이 발급 되었습니다. 구매하러 가기를 눌러 주세요!'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
					dbget.close() : Response.End
				CASE 2
					response.write "i4"
					'Response.Write "<script type='text/javascript'>alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
					dbget.close() : Response.End
				CASE 3
					response.write "i2"
					'Response.Write "<script type='text/javascript'>alert('이미 쿠폰을 받으셨습니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
					dbget.close() : Response.End
			END SELECT
	
		elseif ecode = "57046" or ecode = "21374" then
			vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
					 "values('" & datecouponval & "', '" & userid & "', '2','3000','[크리스마스 스페셜] 쿠폰_3000원 할인','30000','2014-12-01 00:00:00','2014-12-24 23:59:59','',0,'system','')"
		end if
		dbget.execute vQuery
	
		'response.write "<script language='javascript'>alert('발급완료!'); parent.location.reload();</script>"
		response.write "i1"
		dbget.close() : Response.End
	Else
		response.write "i4"
		dbget.close() : Response.End
	End if
else
	'response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	response.write "i3"
	dbget.close() : Response.End
end if

'## 상품쿠폰 다운 함수
Function fnSetItemCouponDown(ByVal userid, ByVal idx)
	dim sqlStr
	Dim objCmd
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_item].[dbo].sp_Ten_itemcoupon_down("&idx&",'"&userid&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    fnSetItemCouponDown = objCmd(0).Value	
	Set objCmd = Nothing	
END Function

function datecouponval()
	dim tmpdatecouponval

	IF application("Svr_Info") = "Dev" THEN
		If ecode ="21371" Then
			tmpdatecouponval="3211"
		Elseif ecode ="21372" Then
			tmpdatecouponval="3212"
		Elseif ecode ="21373" Then
			tmpdatecouponval="3213"
		Elseif 	eCode = "21374" Then
			tmpdatecouponval = "377"
		End if
	Else
		If ecode ="57042" Then
			tmpdatecouponval="9823"
		Elseif ecode ="57044" Then
			tmpdatecouponval="9822"
		Elseif ecode ="57045" Then
			tmpdatecouponval="9812"
		Elseif 	eCode = "57046" Then
			tmpdatecouponval = "669"
		End if
	End If
	datecouponval=tmpdatecouponval
end function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->