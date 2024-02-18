<%
'###########################################################
' Description :  기프트
' History : 2015.02.23 유태욱 생성
'###########################################################
%>
<%
	'// 입력및 체크
	Dim strSql, vMyItemCount, vResult, vGubun, h
	dim deleteitem1idx, deleteitem2idx, deleteitemarr

	vResult = "x"
	vGubun = requestCheckVar(request("gubun"),2)
	vItemID = requestCheckVar(request("itemid"),10)

'	If isNumeric(vItemID) = False Then
'		dbget.close() : Response.End
'	End If

	strSql = "SELECT count(idx) FROM [db_board].[dbo].[tbl_shopping_talk_myitemlist] WHERE userid = '" & vUserID & "'"
	rsget.Open strSql,dbget,1
	vMyItemCount = rsget(0)
	rsget.close()
	strSql = ""

	If vGubun <> "u" then '업데이트가 아닐때
		If vMyItemCount > 1 Then '상품 2개가 들어있는지 체크
			Response.Write "<script>if(!confirm('이미 2개의 비교하기 상품이 담겨져 있습니다.\n기프트톡 쓰기로 이동하시겠습니까?')){ goBack('/category/category_itemprd.asp?itemid=" & vItemID & "'); }</script>"

			'상품 삭제(X버튼)를 위해 임시테이블에 담겨있는 상품의 idx값을 배열로 담음
			strSql = "SELECT top 2 idx FROM [db_board].[dbo].[tbl_shopping_talk_myitemlist] WHERE userid = '" & vUserID & "' order by idx asc"'AND itemid = '" & vItemID & "' "
			rsget.Open strSql,dbget,1
			if not rsget.EOF  then
				deleteitemarr = rsget.getrows()
			end if
			rsget.close()
		
			if isarray(deleteitemarr) then
				for h = 0 to ubound(deleteitemarr,2)
					if h=0 then
						deleteitem1idx = deleteitemarr(0,h)
					else
						deleteitem2idx = deleteitemarr(0,h)
					end if
				next
			end if
		Else
			strSql = strSql & "SELECT count(idx) FROM [db_board].[dbo].[tbl_shopping_talk_myitemlist] WHERE userid = '" & vUserID & "' AND itemid = '" & vItemID & "' " & vbCrLf
			rsget.Open strSql,dbget,1
			If rsget(0) > 0 Then '이미 담긴 상품인지 체크
				Response.Write "<script>if(!confirm('[Gift Talk] 이미 저장하신 상품입니다.\n기프트톡 쓰기로 이동하시겠습니까?')){ goBack('/category/category_itemprd.asp?itemid=" & vItemID & "'); }</script>"
				rsget.close()
			Elseif vItemID <> "" then '담기지 않은 상품이면 임시로 상품id 저장
				rsget.close()
	
				'등록
				strSql = "EXECUTE [db_board].[dbo].[sp_Ten_giftTalk_MyItemProc] 'i', '" & vUserID & "', '" & vItemID & "'"
				dbget.execute strSql
			Else
				rsget.close()
			End If

			strSql = "SELECT top 2 idx FROM [db_board].[dbo].[tbl_shopping_talk_myitemlist] WHERE userid = '" & vUserID & "' order by idx asc"'AND itemid = '" & vItemID & "' "
			rsget.Open strSql,dbget,1
			if not rsget.EOF  then
				deleteitemarr = rsget.getrows()
			end if
			rsget.close()
		
			if isarray(deleteitemarr) then
				for h = 0 to ubound(deleteitemarr,2)
					if h=0 then
						deleteitem1idx = deleteitemarr(0,h)
					else
						deleteitem2idx = deleteitemarr(0,h)
					end if
				next
			end if
		End If
	End if
%>