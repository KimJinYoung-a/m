<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 19주년 코멘트
' History : 2020-09-28 원승현
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
    Dim mode, eCode, LinkEvtCode, blnBlogURL, com_egCode, bidx, Cidx, userid, spoint, txtcommURL, refer
    Dim currentPage, pageSize, startRowNum, endRowNum, maxIdx
    Dim objCmd
    dim refip
    dim sqlStr, returnValue, returnurl, txtcomm, strSql, i, commentTotalCnt
    Dim liTypeNumber, characterNumber

    mode            = request("mode")
    eCode           = requestCheckVar(request("eventCode"),10)
    currentPage     = requestCheckVar(request("currentPage"),1000)
    LinkEvtCode		= requestCheckVar(Request("linkevt"),10)
    blnBlogURL		= requestCheckVar(Request("blnB"),10)
    com_egCode      = requestCheckVar(request("com_egC"),10)
    bidx            = requestCheckVar(request("bidx"),10)
    Cidx            = requestCheckVar(request("idx"),10)
    userid          = GetEncLoginUserID
    spoint          = requestCheckVar(request("spoint"),10)
    returnurl       = requestCheckVar(request("returnurl"),100)
    txtcommURL      = requestCheckVar(request("txtcommURL"),128)
    txtcommURL      = html2db(txtcommURL)
	refer 		    = request.ServerVariables("HTTP_REFERER") '// 레퍼러    
    txtcomm         = request("inputCommentData")    
    refip           = request.ServerVariables("REMOTE_ADDR")

    IF application("Svr_Info") = "Dev" THEN
        eCode   =  "103232"
    Else
        eCode   =  "106375"
    End If

    If InStr(refer, "10x10.co.kr") < 1 or eCode = "" Then
        Response.Write "Err|잘못된 접속입니다."
        Response.End
    End If

    IF spoint = "" THEN spoint = 0
    IF bidx = "" THEN bidx = 0
    IF com_egCode = "" THEN com_egCode = 0
    IF currentPage = "" THEN currentPage = 1
    pageSize = 6

    if mode="add" Then '// 제한 없음
        if Not(IsUserLoginOK) Then			 	
            Response.write "Err|로그인을 하셔야 축하 메시지를 등록하실 수 있습니다."
            response.end
        end if		

        if checkNotValidTxt(txtcomm) then
            Response.Write "Err|내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요."
            dbget.close()	:	response.End
        end if

    '	txtcomm	= html2db(CheckCurse(request("inputCommentData")))	
        txtcomm = html2db(txtcomm)
        
        'Response.write "err|" & mode
        'response.end

        strSql = "select count(*) as cnt from " & vbcrlf
        strSql = strSql & "db_event.dbo.tbl_event_comment " & vbcrlf
        strSql = strSql & "where evt_code='"&eCode&"' " & vbcrlf
        strSql = strSql & "and userid = '"&userid&"' and evtcom_using = 'Y' " & vbcrlf
        rsget.Open strSql, dbget, adOpenForwardOnly,adLockReadOnly
        If rsget("cnt") >= 100 Then
            Response.Write "Err|이미 등록하셨습니다."			
            dbget.close()	:	response.End
        End If
        rsget.Close

        '입력 프로세스
        strSql = ""
        strSql = strSql & "Insert into db_event.dbo.tbl_event_comment " & vbcrlf
        strSql = strSql & "(evt_code, userid, evtcom_txt, blogurl, evtcom_regdate, evtcom_point, refip) " & vbcrlf
        strSql = strSql & "VALUES " & vbcrlf
        strSql = strSql & "('"&eCode&"','"&userid&"','"&txtcomm&"','"&txtcommURL&"', getdate(),'" & spoint &"', '"&refip&"') "
        dbget.execute strSql
        Response.Write "ok|ok"			
        dbget.close() : Response.End

    ElseIf mode="del" then

        if Not(IsUserLoginOK) Then			 	
            Response.write "Err|로그인 후에 삭제하실 수 있습니다."
            response.end
        end if		

        Set objCmd = Server.CreateObject("ADODB.COMMAND")
            With objCmd
            .ActiveConnection = dbget
            .CommandType = adCmdText
            .CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_delete ("&Cidx&",'"&userid&"',"&bidx&","&com_egCode&")}"		
            .Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
            .Execute, , adExecuteNoRecords
            End With	
            returnValue = objCmd(0).Value		    	
                
        IF returnValue = 1 THEN	
            Response.Write "ok|ok"			
            dbget.close()	:	response.End
        ELSE
            Response.Write "Err|시스템 오류|" & returnValue				
            dbget.close()	:	response.End
        END IF

    ElseIf mode="getlist" Then
        startRowNum = ((currentPage-1)*pageSize)+1
        endRowNum = (currentPage*pageSize)+1
        liTypeNumber = 1

		strSql = " select MAX(evtcom_idx) as maxidx "
		strSql = strSql & " FROM db_event.dbo.tbl_event_comment c WITH(NOLOCK) "
		strSql = strSql & " WHERE c.evtcom_using = 'Y' AND c.evt_code='"&eCode&"' "
		rsget.Open strSql, dbget, adOpenForwardOnly,adLockReadOnly
        If not(rsget.bof or rsget.eof) Then
            maxIdx = rsget("maxidx")
        Else
            maxIdx = 0
        End If
        rsget.close

		strSql = " select COUNT(*) as totalcnt "
		strSql = strSql & " FROM db_event.dbo.tbl_event_comment c WITH(NOLOCK) "
		strSql = strSql & " WHERE c.evtcom_using = 'Y' AND c.evt_code='"&eCode&"' and c.evtcom_idx <= '"&maxIdx&"' "
		rsget.Open strSql, dbget, adOpenForwardOnly,adLockReadOnly
        commentTotalCnt = rsget("totalcnt")
        rsget.close        

		strSql = " Select * From "
		strSql = strSql & " ( "
		strSql = strSql & " 	select  "
		strSql = strSql & " 	ROW_NUMBER() OVER (ORDER BY c.evtcom_idx desc) as rwnum, "
		strSql = strSql & " 	c.evtcom_idx, c.evt_code, c.userid, c.evtcom_txt, c.evtcom_point, "
        strSql = strSql & "     CONVERT(VARCHAR(16), c.evtcom_regdate, 121) AS evtcom_regdate, c.evtcom_using, c.evtbbs_idx, "
        strsql = strsql & "     c.evtgroup_code, c.refip, c.blogurl, c.device "
		strSql = strSql & " 	from db_event.dbo.tbl_event_comment c WITH(NOLOCK) "
		strSql = strSql & " 	where c.evtcom_using = 'Y' and c.evtcom_idx <= '"&maxIdx&"' AND c.evt_code='"&eCode&"' "
		strSql = strSql & " ) pp Where pp.rwnum >= '"&startRowNum&"' And pp.rwnum < '"&endRowNum&"' "
		strSql = strSql & " order by pp.evtcom_idx desc "
		rsget.Open strSql, dbget, adOpenForwardOnly,adLockReadOnly
        If not(rsget.bof or rsget.eof) Then
            i = 1
            do until rsget.eof
                If i mod 2 = 0 Then
                    liTypeNumber = 2
                Else
                    liTypeNumber = 1
                End if

                Randomize()
                characterNumber = Int((Rnd * 20) + 1)

                If len(characterNumber)=1 Then
                    characterNumber = "0"&characterNumber
                End If
%>
                <% If liTypeNumber = 1 Then %>
                    <li class="list-type01">
                        <div class="img-character">
                            <%'<!-- for dev msg : 캐릭터 20개 img list 입니다. -->%>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_character_<%=characterNumber%>.png" alt="character <%=characterNumber%>">
                        </div>
                        <div>
                            <p class="id"><%=printUserId(rsget("userid"),3,"*")%></p>
                            <div class="message-container">
                                <p class="num">NO. <%=commentTotalCnt-(i-1)-(pagesize*(currentPage-1))%></p>
                                <p class="message"><%=rsget("evtcom_txt")%></p>
                                <p class="date"><%=rsget("evtcom_regdate")%></p>
                                <% If IsUserLoginOK Then %>
                                    <% If Trim(rsget("userid")) = GetEncLoginUserID() Then %>
                                        <button type="button" class="btn-close" onclick='jsSubmitComment("del","<%=rsget("evtcom_idx")%>");'>삭제</button>
                                    <% End If %>
                                <% End If %>
                            </div>
                        </div>
                    </li>
                <% End If %>
                <% If liTypeNumber = 2 Then %>
                    <li class="list-type02">
                        <div>
                            <p class="id"><%=printUserId(rsget("userid"),3,"*")%></p>
                            <div class="message-container">
                                <p class="num">NO. <%=commentTotalCnt-(i-1)-(pagesize*(currentPage-1))%></p>
                                <p class="message"><%=rsget("evtcom_txt")%></p>
                                <p class="date"><%=rsget("evtcom_regdate")%></p>
                                <% If IsUserLoginOK Then %>
                                    <% If Trim(rsget("userid")) = GetEncLoginUserID() Then %>
                                        <button type="button" class="btn-close" onclick='jsSubmitComment("del","<%=rsget("evtcom_idx")%>");'>삭제</button>
                                    <% End If %>
                                <% End If %>
                            </div>
                        </div>
                        <div class="img-character">
                            <%'<!-- for dev msg : 캐릭터 20개 img list 입니다. -->%>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_character_<%=characterNumber%>.png" alt="character <%=characterNumber%>">
                        </div>                        
                    </li>
                <% End If %>
<%
            rsget.MoveNext
            i = i + 1
            loop
        Else
            Response.write ""
            dbget.close()	:	response.End
        End If
        rsget.close
    Else
        Response.Write "Err|시스템 오류|" & "mode"				
        dbget.close()	:	response.End
    End If              
%>
<% Set objCmd = Nothing %>
