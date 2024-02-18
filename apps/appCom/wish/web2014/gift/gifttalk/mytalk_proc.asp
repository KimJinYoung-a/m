<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description :  기프트톡 등록,수정,삭제 처리페이지
' History : 2015.02.17 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/gift/lib/giftFunction.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/gift/Underconstruction_gift.asp" -->
<%
	Dim strSql, vGubun, vdelGubun, vIdx, vTalkIdx, vVote, vResult, vGood, vBad, vTheme, vUseYN, vkeyword, vContents
	vResult = "xxx"
	vGubun = requestCheckVar(request("gubun"),10)
	vdelGubun = requestCheckVar(request("mydell"),10)

	If vGubun <> "i" AND vGubun <> "u" AND vGubun <> "d" Then
		dbget.close()
		Response.End
	End If

	vTalkIdx = requestCheckVar(request("talkidx"),10)
	If isNumeric(vTalkIdx) = False Then
		dbget.close()
		Response.End
	End If

	if checkNotValidTxt(vContents) then		
		Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); location.href='about:blank';</script>"
		dbget.close() : Response.End
	end if

	strSql = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_Proc] '" & vGubun & "', '" & vTalkIdx & "', '" & GetLoginUserID() & "', '" & vTheme & "', '" & vkeyword & "', '" & vContents & "', '" & vUseYN & "', 'm'"
	'response.write strSql
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open strSql,dbget,1
	If Not rsget.Eof Then
		vResult = rsget(0)
	End IF
	rsget.close()

	'### 기프트 상품 연결정보(카운트) 업데이트
	Call updateGiftItemInfo("talk",vTalkIdx)
%>
<script type="text/javascript">
	<% If vResult = "o" Then %>
		alert("처리되었습니다.");
		<% If vGubun = "d" Then %>
			<% If vdelGubun = "m" Then %>
				top.location.href = "/apps/appCom/wish/web2014/gift/gifttalk/mytalk.asp";
			<% Else %>
				top.location.href = "/apps/appCom/wish/web2014/gift/gifttalk/index.asp";
			<% End if %>
		<% End If %>
	<% Else %>
		<% If vResult = "xxx" Then %>
			alert("일시적인 통신장애입니다.\n새로고침 후 다시 해주세요.");
		<% Else %>
			
		<% End If %>
	<% End If %>
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->