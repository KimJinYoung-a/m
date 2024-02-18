<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 2021 다이어리 스토리 오픈 이벤트
' History : 2020-09-09 정태훈
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, refer, eventStartDate, eventEndDate, i, Cidx
	Dim eCode, LoginUserid, mode, sqlStr, returnValue
	dim oJson, eventobj, itemIMG, ItemId, subscriptcount
	dim bidx, mktTest, com_egCode, refip, txtcommURL, txtcomm
	refip = request.ServerVariables("REMOTE_ADDR")
    refer = request.ServerVariables("HTTP_REFERER")

	mktTest = False

	Set oJson = jsObject()
	IF application("Svr_Info") = "Dev" THEN
	else
		If InStr(refer, "10x10.co.kr") < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "잘못된 접속입니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End If
    Dim objCmd
    Set objCmd = Server.CreateObject("ADODB.COMMAND")

	'currentDate 	= date()
	LoginUserid		= getencLoginUserid()
	mode 			= request("mode")
    com_egCode = 0
    bidx=0

	eventStartDate  = cdate("2020-09-14")		'이벤트 시작일
	eventEndDate 	= cdate("2020-10-05")		'이벤트 종료일+1
	if mktTest then
		currentDate = cdate("2020-09-14")
	else
		currentDate 	= date()
	end if

	if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726"  or LoginUserid = "bora2116" or LoginUserid = "tozzinet" then
		mktTest = True
	end if

    IF application("Svr_Info") = "Dev" THEN
        eCode   =  102223
    Else
        eCode   =  105778
    End If

    if mode="add" then

        if Not(currentDate >= eventStartDate And currentDate < eventEndDate) and not mktTest then	'이벤트 참여기간
            oJson("response") = "err"
            oJson("faildesc") = "이벤트 참여기간이 아닙니다."
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        end if

        txtcomm = request.Form("txtcomm")

        if checkNotValidTxt(txtcomm) then
            oJson("response") = "err"
            oJson("faildesc") = "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요."
            oJson.flush
            Set oJson = Nothing
            dbget.close()	:	response.End
        end if
        
            txtcomm	= html2db(CheckCurse(request.Form("txtcomm")))
            itemID	= requestCheckVar(request.Form("selectedPdt"),10)
            txtcommURL = html2db(CheckCurse(request.Form("selectedPdtIMG")))

            sqlStr ="exec [db_event].[dbo].sp_Ten_event_comment_New_insert '"&eCode&"','"&com_egCode&"','"&LoginUserid&"','"&txtcomm&"','"&itemID&"','"&bidx&"','"&refip&"','"&txtcommURL&"','"&flgDevice&"'"
            rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
                IF Not (rsget.EOF OR rsget.BOF) THEN
                    returnValue = Clng(rsget(0))
                ELSE
                    returnValue = 0
                END IF
            rsget.close
        
        IF returnValue > 0 THEN	
            oJson("response") = "ok"
            oJson("cidx") = returnValue
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        ELSE
            oJson("response") = "err"
            oJson("faildesc") = "데이터처리에 문제가 발생했습니다. 다시 시도 해주세요."
            oJson.flush
            Set oJson = Nothing
            dbget.close()	:	response.End
        END IF 
    elseif mode="del" then
            Cidx=requestCheckVar(request.Form("Cidx"),10)	

            With objCmd
            .ActiveConnection = dbget
            .CommandType = adCmdText
            .CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_delete ("&Cidx&",'"&LoginUserid&"',"&bidx&","&com_egCode&")}"		
            .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
            .Execute, , adExecuteNoRecords
            End With	
            returnValue = objCmd(0).Value		    	
        Set objCmd = Nothing
            
        IF returnValue = 1 THEN	
            oJson("response") = "ok"
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        ELSE
            oJson("response") = "err"
            oJson("faildesc") = "데이터처리에 문제가 발생했습니다. 다시 시도 해주세요."
            oJson.flush
            Set oJson = Nothing
            dbget.close()	:	response.End
        END IF
    elseif mode="edit" then
        Cidx=requestCheckVar(request.Form("Cidx"),10)	
        
        txtcomm	= html2db(CheckCurse(request.Form("txtcomm")))

        Dim strSql
        strSql ="[db_event].[dbo].sp_Ten_event_comment_New_update ('U','"&LoginUserid&"','"&Cidx&"','"&txtcomm&"')"
        rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
            IF Not (rsget.EOF OR rsget.BOF) THEN
                returnValue = rsget(0)
            ELSE
                returnValue = null
            END IF
        rsget.close

        IF returnValue = 1 THEN	
            oJson("response") = "ok"
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        ELSE
            oJson("response") = "err"
            oJson("faildesc") = "데이터처리에 문제가 발생했습니다. 다시 시도 해주세요."
            oJson.flush
            Set oJson = Nothing
            dbget.close()	:	response.End
        END IF 
    elseif mode = "snschk" then
        dim device
        If isApp="1" or isApp="2" Then
            device = "A"
        else
            device = "M"
        end if
        if IsUserLoginOK Then
            set eventobj = new RealtimeEventCls
            eventobj.evtCode = eCode		'이벤트코드
            eventobj.userid = LoginUserid'사용자id
            eventobj.device = device		'기기
            eventobj.snsType = "ka"	'sns종류
            eventobj.snsShareSecond()
        end if

        oJson("response") = "ok"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End

    elseif mode="addcomment" then

        txtcomm	= html2db(CheckCurse(request("txtcomm")))
        subscriptcount = getevent_subscriptexistscount(eCode, LoginUserid, "", "1", "")

        'if subscriptcount > 1 then
        '    oJson("response") = "err"
        '    oJson("faildesc") = "참여는 한번만 가능 합니다."
        '    oJson.flush
        '    Set oJson = Nothing
        '    dbget.close() : Response.End
        'end if
        if txtcomm="" then
            oJson("response") = "err"
            oJson("faildesc") = "6글자로 채워주세요1."
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        end if	
        if checkNotValidTxt(txtcomm) then
            oJson("response") = "err"
            oJson("faildesc") = "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요."
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        end if

        sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2)" + vbcrlf
        sqlstr = sqlstr & " VALUES("& eCode &", '" & LoginUserid & "', '"& html2db(txtcomm) &"', 1)" + vbcrlf

        'response.write sqlstr & "<Br>"
        dbget.execute sqlstr

        sqlstr = "SELECT SCOPE_IDENTITY()"
        rsget.Open sqlstr,dbget, adOpenForwardOnly, adLockReadOnly
        IF not rsget.EOF Then
            returnValue = rsget(0)
        else
            returnValue = 0
        END IF
        rsget.close

        if subscriptcount < 1 then
            sqlstr = "insert into db_user.dbo.tbl_mileagelog (userid , mileage , jukyocd , jukyo , deleteyn)" + vbcrlf
            sqlstr = sqlstr & "     select distinct userid, '+100', '"& eCode &"', '6글자로 말해요! 이벤트 참여','N'" + vbcrlf
            sqlstr = sqlstr & "     from db_user.dbo.tbl_user_n with (nolock)" + vbcrlf
            sqlstr = sqlstr & "     where userid='"& LoginUserid &"'" + vbcrlf

            'response.write sqlstr & "<Br>"
            dbget.execute sqlstr

            sqlstr = "update db_user.dbo.tbl_user_current_mileage" + vbcrlf
            sqlstr = sqlstr & " set bonusmileage = bonusmileage+100 where" + vbcrlf
            sqlstr = sqlstr & " userid='"& LoginUserid &"'" + vbcrlf

            'response.write sqlstr & "<Br>"
            dbget.execute sqlstr

            oJson("response") = "ok"
            oJson("cidx") = returnValue
            oJson("returnstr") = "축하합니다. 마일리지 100P가 지급되었습니다."
        else
            oJson("response") = "ok"
            oJson("cidx") = returnValue
            oJson("returnstr") = "저장 되었습니다."
        END IF

        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    elseif mode="editcomment" then

        Cidx=requestCheckVar(request.Form("Cidx"),10)
        txtcomm	= html2db(CheckCurse(request("txtcomm")))

        if txtcomm="" then
            oJson("response") = "err"
            oJson("faildesc") = "6글자로 채워주세요1."
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        end if	

        if checkNotValidTxt(txtcomm) then
            oJson("response") = "err"
            oJson("faildesc") = "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요."
            oJson.flush
            Set oJson = Nothing
            dbget.close() : Response.End
        end if

        sqlstr = "update [db_event].[dbo].[tbl_event_subscript]" + vbcrlf
        sqlstr = sqlstr & " set sub_opt1='" & html2db(txtcomm) & "'" & vbcrlf
        sqlstr = sqlstr & " where sub_idx=" & Cidx & vbcrlf
        sqlstr = sqlstr & " and userid='" & LoginUserid & "'"
        dbget.execute sqlstr

        oJson("response") = "ok"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->