<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 2019 보름달이벤트 응모 현황 보기
' History : 2019-09-10 이종화
'####################################################

Dim LoginUserid, SqlStr, numOfParticipantsPerDay, i

LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" Then		

		sqlStr = ""

        sqlStr = sqlStr & " SELECT evt.EvtRegDate, COUNT(evt.userid) as userEvtCnt, COUNT(n.userid) AS userRegCnt "
        sqlStr = sqlStr & " FROM "
        sqlStr = sqlStr & " ( "
        sqlStr = sqlStr & "    SELECT e.userid, CONVERT(VARCHAR(10), e.regdate, 120) AS EvtRegDate "
        sqlStr = sqlStr & "    FROM db_event.dbo.tbl_event_subscript e WITH(NOLOCK) "
        sqlStr = sqlStr & "    WHERE e.evt_code=97105 "
        sqlStr = sqlStr & "    GROUP BY CONVERT(VARCHAR(10), e.regdate, 120), e.userid "
        sqlStr = sqlStr & " )evt "
        sqlStr = sqlStr & " LEFT JOIN db_user.dbo.tbl_user_n n WITH(NOLOCK) ON evt.userid = n.userid AND EvtRegDate = CONVERT(VARCHAR(10), n.regdate, 120) "
        sqlStr = sqlStr & " GROUP BY EvtRegDate "
        sqlStr = sqlStr & " ORDER BY EvtRegDate "
		
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		
 		if not rsget.EOF then
		    numOfParticipantsPerDay = rsget.getRows()	
		end if
		rsget.close	

		if isArray(numOfParticipantsPerDay) then 		
		%>
		<div style="color:red">*마케팅만 노출</div>						
		<%
			for i=0 to uBound(numOfParticipantsPerDay,2) 
			response.write "<div>"& numOfParticipantsPerDay(0,i) &" : " & numOfParticipantsPerDay(1,i) & "-" & numOfParticipantsPerDay(2,i) & "</div>"																		
			next
        else
            response.write "데이터 없음"
		end if
else
    response.write "인증된 사용자만 확인할 수 있습니다."
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->