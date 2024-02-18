<%
class CShoppingTalkItem
	public FItemID
	public FItemName
	public FSellcash
	public FOrgPrice
	public FMakerID
	public FBrandName
	public FBrandName_kor
	public FBrandLogo
	public FMakerName
	public FcdL
	public FcdM
	public FcdS
	public FCateName
	public FImageBasic
	public FImageList
	public FImageList120
	public FImageSmall
	public FImageBasicIcon
	public FImageIcon1
	public FImageIcon2
	public FTalkIdx
	public FUserID
	public FTheme
	public FKeyword
	public FItem
	public FContents
	public FUseYN
	public FRegdate
	public FCommCnt
	public FIsNewComm
	public FIdx
	public FTag

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class


Class CShoppingTalk
	public FItemList()
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	public FRectGubun
	public FRectIdx
	public FRectTalkIdx
	public FRectItemId
	public FRectUserId
	public FRectTheme
	public FRectUseYN
	public FRectGoodBad
	public FRectContents
	public FRectKeyword
	public FRectOnlyCount
	
    	    
	Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FCurrPage =1
		FPageSize = 10
		FResultCount = 0
		FScrollCount = 10
		FTotalCount = 0
	End Sub

	Private Sub Class_Terminate()

	End Sub



	'####### talk 리스트 -->
	public Function fnShoppingTalkList
		Dim strSql, i
		
			strSql = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_List_Count] '" & FpageSize & "', '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectKeyword & "', '" & FRectUseYN & "'"
			'response.write strSql
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.Open strSql,dbget,1
				FTotalCount = rsget(0)
				FTotalPage	= rsget(1)
			rsget.close
			
			If FRectTalkIdx <> "" Then
				FTotalCount = 1
				FTotalPage = 1
			End IF
		

		If FTotalCount > 0 AND FRectOnlyCount = "" Then
			strSql = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_List] '" & (FpageSize*FCurrPage) & "', '" & FRectTalkIdx & "', '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectKeyword & "', '" & FRectUseYN & "'"
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.pagesize = FPageSize
			rsget.Open strSql,dbget,1
			'response.write strSql

			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)
			
			i=0
			if  not rsget.EOF  then
				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FItemList(i) = new CShoppingTalkItem
	
					
					FItemList(i).FTalkIdx	= rsget("talk_idx")
					FItemList(i).FUserID	= rsget("userid")
					FItemList(i).FTheme		= rsget("theme")
					FItemList(i).FKeyword	= rsget("keyword")
					FItemList(i).FItem		= rsget("item")
					'FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")
					
					FItemList(i).FContents	= db2html(rsget("contents"))
					FItemList(i).FUseYN		= rsget("useyn")
					FItemList(i).FRegdate	= rsget("regdate")
					FItemList(i).FCommCnt	= rsget("comm_cnt")
					FItemList(i).FIsNewComm	= rsget("isnewcomm")
					FItemList(i).FTag		= rsget("tag")

					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.close
		End If
	End Function
	
	
	'####### 나의 아이템 리스트 -->
	public Function fnShoppingTalkMyItemList
		Dim strSql, i
		
		strSql = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_MyItemList_Count] '" & FpageSize & "', '" & FRectUserId & "'"
		'response.write strSql
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSql,dbget,1
			FTotalCount = rsget(0)
			FTotalPage	= rsget(1)
		rsget.close
		

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_MyItemList] '" & FpageSize & "', '" & FRectUserId & "'"
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.pagesize = FPageSize
			rsget.Open strSql,dbget,1
			'response.write strSql

			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)
			
			i=0
			if  not rsget.EOF  then
				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FItemList(i) = new CShoppingTalkItem
	
					FItemList(i).FItemID		= rsget("itemid")
					FItemList(i).FItemName		= db2html(rsget("itemname"))
					FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")
					FItemList(i).FImageIcon1	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("icon1image")
					FItemList(i).FBrandName		= db2html(rsget("brandname"))
					FItemList(i).FMakerID		= rsget("makerid")
					
					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.close
		End If
	End Function
	
	
	'####### talk comment 리스트 -->
	public Function fnShoppingTalkCommList
		Dim strSql, i
		
			strSql = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_CommList_Count] '" & FpageSize & "', '" & FRectTalkIdx & "', '" & FRectUserId & "', '" & FRectUseYN & "'"
			'response.write strSql
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.Open strSql,dbget,1
				FTotalCount = rsget(0)
				FTotalPage	= rsget(1)
			rsget.close
			

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_CommList] '" & (FpageSize*FCurrPage) & "', '" & FRectTalkIdx & "', '" & FRectUserId & "', '" & FRectUseYN & "'"
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.pagesize = FPageSize
			rsget.Open strSql,dbget,1
			'response.write strSql

			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)
			
			i=0
			if  not rsget.EOF  then
				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FItemList(i) = new CShoppingTalkItem
	
					
					FItemList(i).FIdx		= rsget("idx")
					FItemList(i).FUserID	= rsget("userid")
					FItemList(i).FContents	= db2html(rsget("contents"))
					FItemList(i).FUseYN		= rsget("useyn")
					FItemList(i).FRegdate	= rsget("regdate")

					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.close
		End If
	End Function
	
	
	
	public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function

	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
end Class


Function fnConFirmMyTalk(talkidx, userID)
	Dim vQuery
	vQuery = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_MyTalkConfirm] '" & talkidx & "', '" & userID & "'"
	dbget.execute vQuery
	response.Cookies("uinfo")("isnewcomm") = ""
End Function


Function keywordSelectBox(key1, key2)
	Dim i, vBody, vQuery
	vBody = vBody & "<div class=""overHidden"">"
	vBody = vBody & "<select name=""keyword1"" class=""ftLt"" style=""width:49%"" onChange=""showKeyword2(this.value);"">" & vbCrLf
	vBody = vBody & "	<option value="""">상황 선택하기</option>" & vbCrLf
	
	vQuery = "SELECT code, codename FROM [db_board].[dbo].[tbl_shopping_talk_keywordcode] WHERE depth = '1' AND useyn = 'y' ORDER BY sortno ASC, code ASC"
	rsget.Open vQuery,dbget,1
	
	Do Until rsget.Eof
		vBody = vBody & "	<option value=""" & rsget("code") & """ " & CHKIIF(key1=rsget("code"),"selected","") & ">" & rsget("codename") & "</option>" & vbCrLf
		rsget.MoveNext
	Loop
	rsget.close()

	vBody = vBody & "</select>" & vbCrLf
	
	If key1 <> "" Then
		vBody = vBody & "<select name=""keyword2"" class=""ftRt"" style=""width:49%"" onChange=""searchTalkList('"&key1&"',this.value);"">" & vbCrLf
		vBody = vBody & "	<option value="""">대상 선택하기</option>" & vbCrLf
		
		vQuery = "SELECT code, codename FROM [db_board].[dbo].[tbl_shopping_talk_keywordcode] WHERE depth = '2' AND Left(code,1) = '" & key1 & "' AND useyn = 'y' ORDER BY sortno ASC, code ASC"
		rsget.Open vQuery,dbget,1
		
		Do Until rsget.Eof
			vBody = vBody & "	<option value=""" & rsget("code") & """ " & CHKIIF(CStr(key2)=CStr(rsget("code")),"selected","") & ">" & rsget("codename") & "</option>" & vbCrLf
			rsget.MoveNext
		Loop
		rsget.close()

		vBody = vBody & "</select>" & vbCrLf
	End If
	vBody = vBody & "</div>"
	
	Response.Write vBody
End Function


Function fnTagLinkSetting(g, tag, keyword)
	Dim vBody, vTag1, vTag2, vKey1, vKey2, vPage
	If g = "i" Then
		vPage = "/shoppingtalk/index.asp"
	ElseIf g = "m" Then
		vPage = "/shoppingtalk/mytalk.asp"
	End If
	vTag1 = Split(tag,"@")(0)
	vTag2 = Split(tag,"@")(1)
	vKey1 = Left(keyword, Len(keyword)-2)
	vKey2 = Right(keyword, 2)
	vBody = "<a href="""&vPage&"?cpg=1&key1="&vKey1&"&key2="">" & vTag1 &"</a>, <a href="""&vPage&"?cpg=1&key1="&vKey1&"&key2="&keyword&""">" & vTag2 &"</a>"
	fnTagLinkSetting = vBody
End Function


'//카테고리
function drawwishcategory(stats)
	dim userquery, tem_str

	response.write "<option value=''"
		if stats ="" then
			response.write " selected"
		end if
	response.write ">전체 카테고리</option>"

		userquery = "select L.code_large, L.code_nm"
		userquery = userquery + " from db_item.dbo.tbl_Cate_large as L "
		userquery = userquery + " where L.display_yn = 'Y' and L.code_large <> '999' "
		userquery = userquery + " order by orderNo asc"

	rsget.Open userquery, dbget, 1
	'response.write userquery&"<br>"

	if not rsget.EOF then
		do until rsget.EOF
			if cstr(stats) = cstr(rsget("code_large")) then
				tem_str = " selected"
			end if
			response.write "<option value='" & rsget("code_large") & "' " & tem_str & ">" & rsget("code_nm") & "</option>"
			tem_str = ""
			rsget.movenext
		loop
	end if
	rsget.close
End function


Function fnTalkReadCount(talkidx)
	Dim vQuery
	vQuery = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_ReadCount] '" & talkidx & "'"
	dbget.Execute vQuery
End function
%>