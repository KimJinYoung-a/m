<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : GS 핫딜
' History : 2014.11.19 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event56700Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, rvalue, k
dim kakaotalksubscriptcount, gsshopsubscriptcount, subscriptcount, itemcouponexistscount, totalitemcouponexistscount, dateitemlimitcnt, totalsubscriptcount
	mode = requestcheckvar(request("mode"),32)
	eCode=getevt_code
	userid = getloginuserid()

kakaotalksubscriptcount=0
gsshopsubscriptcount=0
subscriptcount=0
dateitemlimitcnt=0
totalitemcouponexistscount=0
totalsubscriptcount=0
itemcouponexistscount=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

'/상품 제한수량
dateitemlimitcnt=itemlimitcnt( dateitemval() )

if mode="couponinsert" then
	If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	If not(left(currenttime,10)>="2014-11-20" and left(currenttime,10)<"2014-11-21") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.Write "<script type='text/javascript'>alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	if not (Hour(currenttime) > 11) then
		Response.Write "<script type='text/javascript'>alert('앗! 오후 12시부터 쿠폰 다운이 가능합니다. 조금만 기다려주세요.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	'//본인 참여 여부
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "itemcoupon", "", "")
	if subscriptcount <> 0 then
		Response.Write "<script type='text/javascript'>alert('한 개의 아이디당 한 번만 다운로드 하실 수 있습니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

'	'//전체 응모수
'	totalsubscriptcount=getevent_subscripttotalcount(eCode, "itemcoupon", "", "")
'	if totalsubscriptcount>=dateitemlimitcnt then
'		Response.Write "<script type='text/javascript'>alert('죄송합니다. 핫딜 상품 쿠폰이 모두 소진되었습니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
'		dbget.close() : Response.End
'	end if
'
'	'//전체 상품 쿠폰 발행수량
'	totalitemcouponexistscount=getitemcouponexistscount("", datecouponval(), "", "")
'	if totalitemcouponexistscount>=dateitemlimitcnt then
'		Response.Write "<script type='text/javascript'>alert('죄송합니다. 핫딜 상품 쿠폰이 모두 소진되었습니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
'		dbget.close() : Response.End
'	end if
	
	rvalue = fnSetItemCouponDown(userid, datecouponval() )	'/itemcoupon 처리
	SELECT CASE  rvalue 
		CASE 0	  	
			Response.Write "<script type='text/javascript'>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		CASE 1
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'itemcoupon', 0, '', 'A')" + vbcrlf
		
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr

			Response.Write "<script type='text/javascript'>alert('고객님! 쿠폰이 발급 되었습니다. 구매하러 가기를 눌러 주세요!'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		CASE 2
			Response.Write "<script type='text/javascript'>alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		CASE 3
			Response.Write "<script type='text/javascript'>alert('이미 쿠폰을 받으셨습니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
	END SELECT
	dbget.close() : Response.End

elseif mode="invitereg" then
	If userid = "" Then
		Response.Write "99"
		dbget.close() : Response.End
	End IF
	If not(left(currenttime,10)>="2014-11-20" and left(currenttime,10)<"2014-11-21") Then
		Response.Write "02"
		dbget.close() : Response.End
	End IF

	'//카카오톡 본인 응모수
	kakaotalksubscriptcount = getevent_subscriptexistscount(eCode, userid, "kakaotalk", "", "")
	if kakaotalksubscriptcount>=5 then
		Response.Write "03"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'kakaotalk', 0, '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	response.write "01"
	dbget.close() : Response.End
	
elseif mode="gsshopreg" then
	'If userid = "" Then
	'	Response.Write "99"
	'	dbget.close() : Response.End
	'End IF
	If not(left(currenttime,10)>="2014-11-20" and left(currenttime,10)<"2014-11-21") Then
		Response.Write "02"
		dbget.close() : Response.End
	End IF

	'//gsshop 본인 이동수
	'gsshopsubscriptcount = getevent_subscriptexistscount(eCode, userid, "gsshop", "", "")
	'if gsshopsubscriptcount>=10 then
	'	Response.Write "03"
	'	dbget.close() : Response.End
	'end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", 'gsshopcounttemp', 'gsshop', 0, '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	response.write "01"
	dbget.close() : Response.End

else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"'</script>"
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
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->