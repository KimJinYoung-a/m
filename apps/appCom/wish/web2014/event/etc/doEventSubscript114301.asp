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
' Description : 2021 비밀의 SHOP
' History : 2021-09-17 정태훈 생성
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
    Dim mktTest, iNo, itemid(2), answer, currentDate, userlevel

	referer         = request.ServerVariables("HTTP_REFERER")
	refip           = request.ServerVariables("REMOTE_ADDR")
    mode            = requestcheckvar(request("mode"),10)
    iNo             = requestcheckvar(request("ino"),1)
    userlevel = GetLoginUserLevel()
	Dim eCode, userid
    IF application("Svr_Info") = "Dev" THEN
        eCode = "109395"
        mktTest = true
        itemid(0) = "3324406"
        itemid(1) = "3297090"
        itemid(2) = "3218030"
    ElseIf application("Svr_Info")="staging" Then
        eCode = "114301"
        mktTest = true
        itemid(0) = "4408239" '산리오 플래너
        itemid(1) = "4408240" '디즈니 머그컵
        itemid(2) = "4408243" '모나미 펜
    Else
        eCode = "114301"
        mktTest = false
        itemid(0) = "4408239" '산리오 플래너
        itemid(1) = "4408240" '디즈니 머그컵
        itemid(2) = "4408243" '모나미 펜
    End If

	'// 아이디
	userid = getEncLoginUserid()

    eventStartDate      = cdate("2021-09-20")		'이벤트 시작일
    eventEndDate 	    = cdate("2022-03-24")		'이벤트 종료일(소진시 종료)
    if mktTest then
        '// 테스트용
        currentDate = cdate("2021-09-20")
        if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="cjw0515" or userid="thensi7" or userid = "motions" or userid = "jj999a" or userid = "phsman1" or userid = "jjia94" or userid = "seojb1983" or userid = "kny9480" or userid = "bestksy0527" or userid = "mame234" or userid = "corpse2" or userid = "starsun726" or userid = "bora2116" then
            userlevel="1"
        end if
    else
        currentDate = date()
    end if

	'// 모바일웹&앱
	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If

	If not( Left(Trim(currentDate),10) >= Left(Trim(eventStartDate),10) and Left(Trim(currentDate),10) < Left(Trim(DateAdd("d", 1, Trim(eventEndDate))),10) ) Then
		Response.Write "Err|이벤트 응모기간이 아닙니다." & currentDate
		Response.End
	End IF

	'// 로그인시에만 응모가능
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인을 해야>?n이벤트에 참여할 수 있습니다."
		Response.End
	End If

    Function fnGetUserOrderLevelCheck(userid,userlevel)
        Dim sqlstr
        'if userlevel = "2" then 'VIP 등급은 조건없이 구매가능
        '    fnGetUserOrderLevelCheck = True
        'elseif userlevel = "1" then '레드 등급 리스트 인원만 구매 가능
            sqlstr = " SELECT userid FROM db_temp.dbo.tbl_event_114301 with(nolock)"
            sqlstr = sqlstr & " where userid = '"& userid &"'"
            rsget.Open sqlstr,dbget, adOpenForwardOnly, adLockReadOnly
            IF not rsget.EOF Then
                fnGetUserOrderLevelCheck = True
            else
                fnGetUserOrderLevelCheck = False
            END IF
            rsget.close
        'else
        '    fnGetUserOrderLevelCheck = False
        'end if
    End Function

    If mode = "order" Then
        '// 현재 에어팟 상품의 재고가 있는지 확인한다.
		If getitemlimitcnt(itemid(iNo-1)) < 1 Then 
            Response.Write "Err|준비한 상품이 모두 소진 되었습니다."
            Response.End
        End If

        '// 현 RED 등급 중 1회 더 구매하면 VIP 등급 업되는 고객 or 현재 VIP 고객
        If not fnGetUserOrderLevelCheck(userid,userlevel) Then
            Response.Write "Err|죄송합니다. 시크릿 문자를 받은 고객님만 구매할 수 있는 이벤트입니다"
            Response.End
        End If

        '// 해당 사용자가 이벤트 상품을 구매 했는지 확인한다.
        vQuery = " select count(*) as cnt"
        vQuery = vQuery & " from db_order.dbo.tbl_order_master m"
        vQuery = vQuery & " join db_order.dbo.tbl_order_detail d"
        vQuery = vQuery & " 	on m.orderserial=d.orderserial"
        vQuery = vQuery & " where "
        vQuery = vQuery & " m.jumundiv<>9"
        vQuery = vQuery & " and m.ipkumdiv>1"
		vQuery = vQuery & " and m.userid='"& userid &"'"
		vQuery = vQuery & " and m.cancelyn='N' "
        'vQuery = vQuery & " and d.itemid in (" & itemid(iNo-1) &")"
        vQuery = vQuery & " and d.itemid in ("& itemid(0) & "," & itemid(1) & "," & itemid(2) &")"
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
        If rsget(0) > 0 Then
            Response.Write "Err|본 상품은 ID당 1회만 결제할 수 있습니다."
            response.End
        End If        
        rsget.close

        '// 해당 사용자의 장바구니에 이벤트 상품이 있는지 확인한다.
        vQuery = " select count(*) as cnt"
        vQuery = vQuery & " from [db_my10x10].[dbo].[tbl_my_baguni]"
        vQuery = vQuery & " where userkey='"& userid &"'"
        'vQuery = vQuery & " and itemid in (" & itemid(iNo-1) &")"
        vQuery = vQuery & " and itemid in (" & itemid(0) & "," & itemid(1) & "," & itemid(2) &")"
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
        If rsget(0) > 0 Then
            Response.Write "Err|바로 구매는 한 번만 참여하실 수 있습니다.>?n참여하신 상품은 장바구니에서 확인하실 수 있습니다."
            response.End
        End If        
        rsget.close

        '// 이벤트 응모내역을 남긴다.
        vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '"&mode&"', '"&itemid(iNo-1)&"', '"&apgubun&"')"
        dbget.Execute vQuery        

        Response.Write "OK|"&itemid(iNo-1)
        Response.End
    Else
		Response.Write "Err|잘못된 접속입니다."
		Response.End
    End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


