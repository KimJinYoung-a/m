<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 2020 첫 구매 혜택 에어팟 2세대.
' History : 2020-08-06 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim mode, referer, refip, apgubun, currenttime, vQuery, eventStartDate, eventEndDate
    Dim mktTest, itemid, answer, userAnswerText, answerRightHtml, currentDate

	referer         = request.ServerVariables("HTTP_REFERER")
	refip           = request.ServerVariables("REMOTE_ADDR")
    mode            = requestcheckvar(request("mode"),10)
    userAnswerText  = requestcheckvar(request("answer"),10)    

	Dim eCode, userid, eMobileCode
    IF application("Svr_Info") = "Dev" THEN
        eCode = "102208"
        eMobileCode = "104780"
        mktTest = true
        itemid = "2891188"
    ElseIf application("Svr_Info")="staging" Then
        eCode = "104828"
        eMobileCode = "104780"    
        mktTest = true
        itemid = "3076446"
    Else
        eCode = "104828"
        eMobileCode = "104780"
        mktTest = false
        itemid = "3076446"
    End If
    
	'// 아이디
	userid = getEncLoginUserid()

    eventStartDate      = cdate("2020-08-10")		'이벤트 시작일
    eventEndDate 	    = cdate("2020-08-30")		'이벤트 종료일
    if mktTest then
        '// 테스트용
        currentDate = cdate("2020-08-10")
    else
        currentDate = date()
    end if

	'// 모바일웹&앱
	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If

	if InStr(referer,"10x10.co.kr")<1 Then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	If not( Left(Trim(currentDate),10) >= Left(Trim(eventStartDate),10) and Left(Trim(currentDate),10) < Left(Trim(DateAdd("d", 1, Trim(eventEndDate))),10) ) Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		Response.End
	End IF

	'// 로그인시에만 응모가능
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인을 해야>?n이벤트에 참여할 수 있습니다."
		Response.End
	End If

    If mode = "order" Then
        '// 현재 에어팟 상품의 재고가 있는지 확인한다.
		If getitemlimitcnt(itemid) < 1 Then 
            Response.Write "Err|준비한 상품이 모두 소진 되었습니다."
            Response.End
        End If

        '// 해당 사용자가 5년 이내 상품을 구매한적이 있는지 확인한다.
        If fnUserGetOrderCheckFiveYear(userid,"") Then
            Response.Write "Err|텐바이텐에서 한번도 구매하지 않은 고객만 구매하실 수 있습니다."
            Response.End
        End If

        '// 해당 사용자가 에어팟 이벤트 상품을 구매 했는지 확인한다.
        vQuery = vQuery & " select count(*) as cnt"
        vQuery = vQuery & " from db_order.dbo.tbl_order_master m"
        vQuery = vQuery & " join db_order.dbo.tbl_order_detail d"
        vQuery = vQuery & " 	on m.orderserial=d.orderserial"
        vQuery = vQuery & " where "
        vQuery = vQuery & " m.jumundiv<>9"
        vQuery = vQuery & " and m.ipkumdiv>1"
		vQuery = vQuery & " and m.userid='"& userid &"'"
		vQuery = vQuery & " and m.cancelyn<>'Y'"
        vQuery = vQuery & " and d.itemid in ("& itemid &")"
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
        If rsget(0) > 0 Then
            Response.Write "Err|본 상품은 ID당 1회만 결제할 수 있습니다."
            response.End
        End If        
        rsget.close

        '// 이벤트 응모내역을 남긴다.
        vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '"&mode&"', '"&itemid&"', '"&apgubun&"')"
        dbget.Execute vQuery        

        Response.Write "OK|"&itemid
        Response.End        
    Else
		Response.Write "Err|잘못된 접속입니다."
		Response.End
    End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


