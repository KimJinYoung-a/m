<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description :  기프트Talk 입력
' History : 2015.02.23 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/gift/lib/giftFunction.asp" -->
<!-- #include virtual="/gift/Underconstruction_gift.asp" -->
<%
	'### 상황유형 셀렉박스.
	Dim i, vQuery, vGubun, vUserID, vTalkIdx, vKey1, vKeyword, vContents, vItem, vTheme, vUseYN, vItemID1, vItemID2, vTmpItemID, vTmpKeyword, vDelTalkIdx
	Dim vGood, vBad, vGood1, vGood2, presentcnt
	vUserID = GetLoginUserID()
	vGubun = requestCheckVar(request("gubun"),1)
	vTalkIdx = requestCheckVar(request("talkidx"),10)
	vDelTalkIdx = requestCheckVar(request.Form("dtalkidx"),60)
	vContents = ReplaceBracket(requestCheckVar(request.Form("contents"),500))
	vUseYN = requestCheckVar(request("useyn"),1)
	vTmpItemID = requestCheckVar(request.Form("itemid"),30)
	vTmpKeyword = requestCheckVar(request.Form("keyword"),30)

	If vGubun = "i" OR vGubun = "u" Then
		'####### 상품코드 정리 #######
		If vTmpItemID = "" OR vTmpItemID = "," Then
			dbget.close()
			Response.End
		End If

		If Left(vTmpItemID,1) = "," Then
			vTmpItemID = Right(vTmpItemID,Len(vTmpItemID)-1)
		End If
		If Right(vTmpItemID,1) = "," Then
			vTmpItemID = Left(vTmpItemID,Len(vTmpItemID)-1)
		End If

		For i = LBound(Split(vTmpItemID,",")) To UBound(Split(vTmpItemID,","))
			If i = 0 Then
				vItemID1 = Split(vTmpItemID,",")(i)
				vTheme = "1"
			End If
			If i = 1 Then
				vItemID2 = Split(vTmpItemID,",")(i)
				vTheme = "2"
			End If
		Next

		'####### 키워드 정리 #######
		If vTmpKeyword = "" OR vTmpKeyword = "," Then
			dbget.close()
			Response.End
		End If

		If Left(vTmpKeyword,1) = "," Then
			vTmpKeyword = Right(vTmpKeyword,Len(vTmpKeyword)-1)
		End If
		If Right(vTmpKeyword,1) = "," Then
			vTmpKeyword = Left(vTmpKeyword,Len(vTmpKeyword)-1)
		End If
	ElseIf vGubun = "d" Then
		If vDelTalkIdx = "" Then
			dbget.close()
			Response.End
		End If
	Else
		dbget.close()
		Response.End
	End If
	
	If vGubun = "i" Then
		''이벤트 상품은 등록불가(박스이벤트 등등..)
		vQuery = "select count(*) presentcnt"
		vQuery = vQuery & " from [db_const].[dbo].[tbl_const_award_NotInclude_Item]"
		vQuery = vQuery & " where 1=1"
	
		If vItemID2 <> "" Then
			vQuery = vQuery & " and itemid in ( "& vItemID1 &" , "& vItemID2 &")"
		else
			vQuery = vQuery & " and itemid in ( "& vItemID1 &")"
		end if
	
		'response.write vQuery & "<Br>"
		rsget.Open vQuery,dbget
		IF not rsget.EOF THEN
			presentcnt = rsget("presentcnt")
		else
			presentcnt = 0	
		END IF
		rsget.close
	
		if presentcnt > 0 then		
			Response.Write "<script type='text/javascript'>alert('이벤트상품은 GIFT TALK에 등록할 수 없습니다.'); location.href='about:blank';</script>"
			dbget.close() : Response.End
		end if

		if checkNotValidTxt(vContents) then		
			Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); location.href='about:blank';</script>"
			dbget.close() : Response.End
		end if

		vQuery = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_Proc] '" & vGubun & "', '" & vTalkIdx & "', '" & vUserID & "', '" & vTheme & "', '" & vKeyword & "', '" & html2db(vContents) & "', '" & vUseYN & "', 'm'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open vQuery,dbget,1
			vTalkIdx = rsget(0)
		rsget.close

		vQuery = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_ItemProc] '" & vGubun & "', '" & vTalkIdx & "', '" & vItemID1 & "' " &vbCrLf
		If vItemID2 <> "" Then
			vQuery = vQuery & " EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_ItemProc] '" & vGubun & "', '" & vTalkIdx & "', '" & vItemID2 & "' " &vbCrLf
		End IF

'		For i = LBound(Split(vTmpKeyword,",")) To UBound(Split(vTmpKeyword,","))
'			vQuery = vQuery & " INSERT INTO [db_board].[dbo].[tbl_shopping_talk_keyword](talk_idx, keyword) VALUES('" & vTalkIdx & "','" & Split(vTmpKeyword,",")(i) & "') " &vbCrLf
'		Next

		''### pc에서는 쓰기페이지에서 선택해서 바로 저장하기에 dbo.tbl_shopping_talk_item 필요없음. 모바일에서는 필요함.
		vQuery = vQuery & " EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_MyItemProc] 'd', '" & vUserID & "', 0 " &vbCrLf

		dbget.execute vQuery

		'### 기프트 상품 연결정보(카운트) 업데이트
		Call updateGiftItemInfo("talk",vTalkIdx)
	ElseIf vGubun = "u" Then
		if checkNotValidTxt(vContents) then		
			Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); location.href='about:blank';</script>"
		dbget.close() : Response.End
		end if

		'### 본문저장
		vQuery = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_Proc] '" & vGubun & "', '" & vTalkIdx & "', '" & vUserID & "', '" & vTheme & "', '', '" & html2db(vContents) & "', '', '' " &vbCrLf

		'### 키워드 삭제
		vQuery = vQuery & " DELETE [db_board].[dbo].[tbl_shopping_talk_keyword] WHERE talk_idx = '" & vTalkIdx & "'" &vbCrLf
		
		'### 새로 선택한 키워드 입력
'		For i = LBound(Split(vTmpKeyword,",")) To UBound(Split(vTmpKeyword,","))
'			vQuery = vQuery & " INSERT INTO [db_board].[dbo].[tbl_shopping_talk_keyword](talk_idx, keyword) VALUES('" & vTalkIdx & "','" & Split(vTmpKeyword,",")(i) & "') " &vbCrLf
'		Next

		dbget.execute vQuery

	ElseIf vGubun = "d" Then
		vDelTalkIdx = Trim(Replace(vDelTalkIdx," ",""))
		vQuery = ""
		For i = LBound(Split(vDelTalkIdx,",")) To UBound(Split(vDelTalkIdx,","))
			vQuery = vQuery & " EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_Proc] '" & vGubun & "', '" & Split(vDelTalkIdx,",")(i) & "', '" & vUserID & "', 0, '', '', '', '' " & vbCrLf
		Next
		If vQuery <> "" Then
			dbget.execute vQuery

			'### 기프트 상품 연결정보(카운트) 업데이트
			Call updateGiftItemInfo("talk",vDelTalkIdx)
		End If
	End If
%>
<script>
<%
	Select Case vGubun
		Case "i"
			'새로 등록일 경우
			Response.Write "parent.top.location.replace(""/gift/gifttalk/"");"
		Case "u"
			'수정일 경우
			Response.Write "parent.top.location.replace(""/gift/gifttalk/mytalk.asp"");"
		Case Else
			'기타/삭제
			Response.Write "parent.location.reload();"
	End Select
%>
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->