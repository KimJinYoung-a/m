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
' Description : 2020 메몽을 드립니다.
' History : 2020-07-30 원승현 생성
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
        eCode = "102204"
        eMobileCode = "102203"
        mktTest = true
        itemid = "2891188"
    ElseIf application("Svr_Info")="staging" Then
        eCode = "104812"
        eMobileCode = "104813"    
        mktTest = true
        itemid = "3054711"
    Else
        eCode = "104812"
        eMobileCode = "104813"
        mktTest = false
        itemid = "3054711"
    End If

    '// 메몽 이벤트 정답
    answer = "몽랑이"

	'// 아이디
	userid = getEncLoginUserid()

    eventStartDate      = cdate("2020-08-03")		'이벤트 시작일
    eventEndDate 	    = cdate("2020-08-13")		'이벤트 종료일
    if mktTest then
        '// 테스트용
        currentDate = cdate("2020-08-03")
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

    '// 이벤트 응모
    If mode = "evt" Then
        '// 사용자가 입력한 정답이 맞는지 확인한다.
        If Trim(answer)<>Trim(userAnswerText) Then
            Response.Write "Err|정답이 아닙니다.>?n다시 입력해주세요."
            Response.End
        End If

        '// 이벤트 응모내역을 남긴다.
        vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '"&mode&"', '"&userAnswerText&"', '"&apgubun&"')"
        dbget.Execute vQuery        

        '// 사용자가 입력한 정답이 맞다면 팝업을 띄어준다.
        answerRightHtml = "<p><img src='//webimage.10x10.co.kr/fixevent/event/2020/104812/m/img_winner.jpg' alt='축하드려요 정답입니다!'></p> "
        answerRightHtml = answerRightHtml & "<a href='' onclick='goDirOrdItem();return false;'><img src='//webimage.10x10.co.kr/fixevent/event/2020/104812/m/btn_buy.png' alt='메몽 세트 구매하러 가기'></a> "
        answerRightHtml = answerRightHtml & "<p><img src='//webimage.10x10.co.kr/fixevent/event/2020/104812/m/txt_winner.png' alt='해당 상품은 선착순 상품으로, 품절되기 전에 서둘러 구매 부탁드립니다.'></p> "
        answerRightHtml = answerRightHtml & "<button class='btn-close' onclick='fnPopupClose();'><img src='//webimage.10x10.co.kr/fixevent/event/2020/104812/m/btn_close.png' alt='닫기'></button> "

        Response.Write "OK|"&answerRightHtml
        Response.End
    ElseIf mode = "order" Then
        '// 현재 메몽 상품의 재고가 있는지 확인한다.
		If getitemlimitcnt(itemid) < 1 Then 
            Response.Write "Err|아쉽게도 준비한 상품이 모두 품절되었습니다.>?n참여해 주셔서 감사합니다."
            Response.End
        End If

        '// 해당 사용자가 메몽 이벤트 상품을 구매 했는지 확인한다.
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

        Response.Write "OK|"&itemid
        Response.End        
    Else
		Response.Write "Err|잘못된 접속입니다."
		Response.End
    End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


