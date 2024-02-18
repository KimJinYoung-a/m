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
' Description :  기프트
' History : 2015.02.10 유태욱 리뉴얼 - 모바일
'			2020.10.07 정태훈 19th 선물의참견 이벤트 수정
'###########################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/gift/Underconstruction_gift.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<%
	Dim strSql, vIdx, vTalkIdx, vVote, vResult, vGood, vBad, vTheme, vSelect
	vResult = "xxx"
	vIdx = requestCheckVar(request("idx"),10)
	If isNumeric(vIdx) = False Then
		dbget.close()
		Response.End
	End If
	vTalkIdx = requestCheckVar(request("talkidx"),10)
	If isNumeric(vTalkIdx) = False Then
		dbget.close()
		Response.End
	End If
	vVote = requestCheckVar(request("vote"),10)
	If vVote <> "good" AND vVote <> "bad" Then
		dbget.close()
		Response.End
	End If
	vTheme = requestCheckVar(request("theme"),10)
	vSelect = requestCheckVar(request("selectoxab"),10)

	strSql = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_Vote] '" & vIdx & "', '" & vTalkIdx & "', '" & GetLoginUserID() & "', '" & vVote & "', 'y', '" & vSelect & "'"
	'response.write strSql
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open strSql,dbget,1
	If Not rsget.Eof Then
		vResult = rsget(0)
	End IF
	rsget.close()

	If vResult = "ok" Then
		strSql = "SELECT good, bad FROM [db_board].[dbo].[tbl_shopping_talk_item] WHERE idx = '" & vIdx & "'"
		rsget.Open strSql,dbget,1
		If Not rsget.Eof Then
			vGood = rsget("good")
			vBad = rsget("bad")
			
			vResult = vGood & "," & vBad
		End IF
		rsget.close()

		'19th 마일리지 이벤트 추가 
		Dim currentDate, userid
		userid = GetLoginUserID()
		IF application("Svr_Info") = "Dev" THEN
			currentDate = #09/20/2021 09:00:00#
		ElseIf application("Svr_Info")="staging" Then
			currentDate = #09/20/2021 09:00:00#
		else
			currentDate =  now()
		End If

		If (currentDate >= "2021-09-20" And currentDate < "2021-09-25") Then
			Dim paramInfo, ErrCode
			paramInfo = Array(Array("@RETURN_VALUE", adInteger, adParamReturnValue, , 0) _
				,Array("@evt_Code", adInteger, adParamInput, , 114296)	_
				,Array("@userID" , adVarchar , adParamInput, 32, userid) _
			)
			strSql = "db_event.dbo.usp_WWW_19THEvent_PresentInterfere_Set"
			Call fnExecSP(strSql, paramInfo)
			ErrCode  = CInt(GetValue(paramInfo, "@RETURN_VALUE"))	'에러코드
			'if ErrCode="0" then
			'	vResult=vResult + "|t"
			'else
			'	vResult=vResult + "|f"
			'end if
		end if

	End IF
%>
<%=vResult%>
<!-- #include virtual="/lib/db/dbclose.asp" -->