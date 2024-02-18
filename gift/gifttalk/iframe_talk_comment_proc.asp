<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description :  기프트
' History : 2015.02.23 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shoppingtalk/shoppingtalkCls.asp" -->
<!-- #include virtual="/lib/util/badgelibUTF8.asp" -->
<%
	'### 상황유형 셀렉박스.
	Dim vQuery, vGubun, vContents, vUseYN, vUserID, vTalkIdx, vIdx
	vUserID = GetLoginUserID()
	vIdx = requestCheckVar(request("idx"),10)
	vTalkIdx = requestCheckVar(request("talkidx"),10)
	vGubun = requestCheckVar(request("gubun"),1)
	vUseYN = requestCheckVar(request("useyn"),1)
	vContents = ReplaceBracket(requestCheckVar(request("contents"),100))
	
	If vTalkIdx = "" Then
		dbget.close() : Response.End
	End If

	If isNumeric(vTalkIdx) = False Then
		dbget.close() : Response.End
	End If

	If getloginuserid = "" Then
		response.write 99
		dbget.close() : Response.End
	End If
	
	If vGubun = "i" then
		if checkNotValidTxt(vContents) then		
			'Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); location.href='about:blank';</script>"
			response.write "i3"
			dbget.close() : Response.End
		end if

		vQuery = "SELECT COUNT(idx) FROM [db_board].[dbo].[tbl_shopping_talk_comment] WHERE talk_idx = '" & vTalkIdx & "' AND userid = '" & vUserID & "' AND useyn = 'y'"
		rsget.Open vQuery,dbget,1
		If rsget(0) > 4 Then
			'Response.Write "<script>alert('하나의 쇼핑톡엔 의견을 5개까지 남길 수 있습니다.');history.back();</script>"
			'Alert_move "하나의 쇼핑톡엔 의견을 5개까지 남길 수 있습니다.","about:blank"
			response.write "i2"
			rsget.close()
			dbget.close()
			Response.End
		Else
			rsget.close()
		End IF

		vQuery = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_CommProc] 'i', '0', '" & vTalkIdx & "', '" & vUserID & "', '" & html2db(vContents) & "', 'm'"
		dbget.execute vQuery

		'// 뱃지 카운트(톡댓글 등록)
		Call MyBadge_CheckInsertBadgeLog(vUserID, "0003", vTalkIdx, "", "")

		response.write "i1"

	ElseIf vGubun = "d" then
		vQuery = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_CommProc] 'd', '" & vIdx & "', '" & vTalkIdx & "', '" & vUserID & "', '', ''"
		dbget.execute vQuery

		response.write "d1"

	ElseIf vGubun = "u" then
		if checkNotValidTxt(vContents) then		
			Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); location.href='about:blank';</script>"
			dbget.close() : Response.End
		end if

		vQuery = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_CommProc] 'u', '" & vIdx & "', '" & vTalkIdx & "', '" & vUserID & "', '" & html2db(vContents) & "', ''"
		dbget.execute vQuery

%>
		<script>
			parent.location.href = "/gift/gifttalk/talk_view.asp?talkidx=<%=vTalkIdx%>";
			location.href = "about:blank";
		</script>
<% End If %>
<!-- #include virtual="/lib/db/dbclose.asp" -->