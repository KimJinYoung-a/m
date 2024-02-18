<%
class CGiftTalkItem
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
	public FListCSS
	public FKeyword
	public FItem
	public FContents
	public FUseYN
	public FRegdate
	public FCommCnt
	public FIsNewComm
	public FIdx
	public FTag
	public FDevice
	public FViewCnt

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class


Class CGiftTalk
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
	public FRectDiv
	public FRectSort
	public FRectViewCnt
	public FRectCommCnt
	public FPre
	public FPreItem
	public FPreTitle
	public FNext
	public FNextItem
	public FNextTitle
	public F1Item
	public F2Item
	
    	    
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
	public Sub sbGiftTalkList
		Dim strSql, i, vKey

		If FRectKeyword <> "" Then
			FRectKeyword = Replace(FRectKeyword," ","")
			For i = LBound(Split(FRectKeyword,",")) To UBound(Split(FRectKeyword,","))
				vKey = vKey & "''" & Split(FRectKeyword,",")(i) & "'',"
			Next
			If vKey <> "" Then
				If Right(vKey,1) = "," Then
					FRectKeyword = Left(vKey,Len(vKey)-1)
				End IF
			End If
		End If
		FResultCount = 0
	
		If FRectTalkIdx = "" Then
			strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_List_Count] '" & FpageSize & "', '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectKeyword & "', '" & FRectUseYN & "', '" & FRectDiv & "'"
			'response.write strSql
			rsCTget.CursorLocation = adUseClient
			rsCTget.CursorType = adOpenStatic
			rsCTget.LockType = adLockOptimistic
			rsCTget.Open strSql,dbCTget,1
				FTotalCount = rsCTget(0)
				FTotalPage	= rsCTget(1)
			rsCTget.close
			
			If FRectTalkIdx <> "" Then
				FTotalCount = 1
				FTotalPage = 1
			End IF
		Else	'####### view.asp 에 사용
			FTotalCount = 1
		End IF
		

		If FTotalCount > 0 Then
			If FRectSort = "" Then
				FRectSort = "t.talk_idx DESC"
			Else
				If FRectSort = "1" Then
					FRectSort = "t.talk_idx DESC"
				ElseIf FRectSort = "2" Then
					FRectSort = "t.view_cnt DESC, t.talk_idx DESC"
				ElseIf FRectSort = "3" Then
					FRectSort = "t.comm_cnt DESC, t.talk_idx DESC"
				Else
					FRectSort = "t.talk_idx DESC"
				End If
			End IF
	
			strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_List] '" & (FpageSize*FCurrPage) & "', '" & FRectTalkIdx & "', '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectKeyword & "', '" & FRectUseYN & "', '" & FRectDiv & "', '" & FRectSort & "'"
		'response.write strSql
			rsCTget.CursorLocation = adUseClient
			rsCTget.CursorType = adOpenStatic
			rsCTget.LockType = adLockOptimistic
			rsCTget.pagesize = FPageSize
			rsCTget.Open strSql,dbCTget,1

			FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)
			
			i=0
			if  not rsCTget.EOF  then
				rsCTget.absolutepage = FCurrPage
				do until rsCTget.eof
					set FItemList(i) = new CGiftTalkItem
	
					
					FItemList(i).FTalkIdx	= rsCTget("talk_idx")
					FItemList(i).FUserID	= rsCTget("userid")
					FItemList(i).FTheme		= rsCTget("theme")
					If rsCTget("theme") = "1" Then
						FItemList(i).FListCSS = "YN"
					ElseIf rsCTget("theme") = "2" Then
						FItemList(i).FListCSS = "AB"
					End If
					FItemList(i).FItem		= rsCTget("item")
					'FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsCTget("basicimage")
					
					FItemList(i).FContents	= db2html(rsCTget("contents"))
					FItemList(i).FUseYN		= rsCTget("useyn")
					FItemList(i).FRegdate	= rsCTget("regdate")
					FItemList(i).FCommCnt	= rsCTget("comm_cnt")
					FItemList(i).FIsNewComm	= rsCTget("isnewcomm")
					FItemList(i).FTag		= rsCTget("tag")
					FItemList(i).FDevice	= rsCTget("device")
					FItemList(i).FViewCnt	= rsCTget("view_cnt")

					i=i+1
					rsCTget.moveNext
				loop
			end if
			rsCTget.close
		End If
	End Sub
	
	
	public Function fnGiftTalkKeywordList
		Dim strSql, i, vKey
		
		strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_Keyword_List] '" & FRectUseYN & "'"
		'response.write strSql
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.pagesize = FPageSize
		rsCTget.Open strSql,dbCTget,1

		FResultCount = rsCTget.RecordCount
        if (FResultCount<1) then FResultCount=0

		if not rsCTget.EOF then
			fnGiftTalkKeywordList = rsCTget.getRows()
		end if
		rsCTget.close
	End Function
	
	
	'####### talk 리스트 -->
	public Sub sbGiftTalkPreNext
		Dim strSql, i, vArr

'		If FRectSort = "" Then
'			FRectSort = "t.talk_idx DESC"
'			
'		Else
'			If FRectSort = "1" Then
'				FRectSort = "t.talk_idx DESC"
'				
'			ElseIf FRectSort = "2" Then
'				FRectSort = "t.view_cnt DESC, t.talk_idx DESC"
'			ElseIf FRectSort = "3" Then
'				FRectSort = "t.comm_cnt DESC, t.talk_idx DESC"
'			Else
'				FRectSort = "t.talk_idx DESC"
'			End If
'		End IF

		strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_PreNext] '" & FRectTalkIdx & "', '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectKeyword & "', '" & FRectUseYN & "', '" & FRectDiv & "', '" & FRectSort & "'"
		'response.write strSql
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open strSql,dbCTget,1
		
		FResultCount = rsCTget.RecordCount
		
		vArr = rsCTget.getRows()
		
		rsCTget.close
		
		If IsArray(vArr) Then
			If FResultCount = 3 Then
				FPre 		= vArr(1,0)
				FPreItem	= vArr(2,0)
				FPreTitle	= chrbyte(vArr(3,0),34,"Y")
				FNext 		= vArr(1,2)
				FNextItem	= vArr(2,2)
				FNextTitle	= chrbyte(vArr(3,2),34,"Y")
			Else
				If CStr(vArr(1,0)) = CStr(FRectTalkIdx) Then
					FPre 		= ""
					FPreItem	= ""
					FPreTitle	= ""
					FNext 		= vArr(1,1)
					FNextItem	= vArr(2,1)
					FNextTitle	= chrbyte(vArr(3,1),34,"Y")
				End IF
				
				If CStr(vArr(1,1)) = CStr(FRectTalkIdx) Then
					FPre 		= vArr(1,0)
					FPreItem	= vArr(2,0)
					FPreTitle	= chrbyte(vArr(3,0),34,"Y")
					FNext 		= ""
					FNextItem	= ""
					FNextTitle	= ""
				End IF
			End IF
		End IF
	End Sub
	
	
	'####### 나의 아이템 리스트 -->
	public Function fnGiftTalkMyItemList
		Dim strSql, i
		
		strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_MyItemList_Count] '" & FpageSize & "', '" & FRectUserId & "'"
		'response.write strSql
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open strSql,dbCTget,1
			FTotalCount = rsCTget(0)
			FTotalPage	= rsCTget(1)
		rsCTget.close
		

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_MyItemList] '" & FpageSize & "', '" & FRectUserId & "'"
			rsCTget.CursorLocation = adUseClient
			rsCTget.CursorType = adOpenStatic
			rsCTget.LockType = adLockOptimistic
			rsCTget.pagesize = FPageSize
			rsCTget.Open strSql,dbCTget,1
			'response.write strSql

			FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)
			
			i=0
			if  not rsCTget.EOF  then
				rsCTget.absolutepage = FCurrPage
				do until rsCTget.eof
					set FItemList(i) = new CGiftTalkItem
	
					FItemList(i).FItemID		= rsCTget("itemid")
					FItemList(i).FItemName		= db2html(rsCTget("itemname"))
					FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsCTget("basicimage")
					FItemList(i).FImageIcon1	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsCTget("icon1image")
					FItemList(i).FBrandName		= db2html(rsCTget("brandname"))
					FItemList(i).FMakerID		= rsCTget("makerid")
					
					i=i+1
					rsCTget.moveNext
				loop
			end if
			rsCTget.close
		End If
	End Function
	
	
	'####### talk comment 리스트 -->
	public Function fnGiftTalkCommList
		Dim strSql, i
		
			strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_CommList_Count] '" & FpageSize & "', '" & FRectTalkIdx & "', '" & FRectUserId & "', '" & FRectUseYN & "'"
			'response.write strSql
			rsCTget.CursorLocation = adUseClient
			rsCTget.CursorType = adOpenStatic
			rsCTget.LockType = adLockOptimistic
			rsCTget.Open strSql,dbCTget,1
				FTotalCount = rsCTget(0)
				FTotalPage	= rsCTget(1)
			rsCTget.close
			

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_CommList] '" & (FpageSize*FCurrPage) & "', '" & FRectTalkIdx & "', '" & FRectUserId & "', '" & FRectUseYN & "'"
			rsCTget.CursorLocation = adUseClient
			rsCTget.CursorType = adOpenStatic
			rsCTget.LockType = adLockOptimistic
			rsCTget.pagesize = FPageSize
			rsCTget.Open strSql,dbCTget,1
			'response.write strSql

			FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)
			
			i=0
			if  not rsCTget.EOF  then
				rsCTget.absolutepage = FCurrPage
				do until rsCTget.eof
					set FItemList(i) = new CGiftTalkItem
	
					
					FItemList(i).FIdx		= rsCTget("idx")
					FItemList(i).FUserID	= rsCTget("userid")
					FItemList(i).FContents	= db2html(rsCTget("contents"))
					FItemList(i).FUseYN		= rsCTget("useyn")
					FItemList(i).FRegdate	= rsCTget("regdate")
					FItemList(i).FDevice	= rsCTget("device")

					i=i+1
					rsCTget.moveNext
				loop
			end if
			rsCTget.close
		End If
	End Function
	
	
	'####### best talk 리스트 -->
	public Function fnGiftTalkBestTalk
		Dim strSql, i
		
		strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_BestTalk]"
		'response.write strSql
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open strSql,dbCTget,1

		FResultCount = rsCTget.RecordCount
        if (FResultCount<1) then FResultCount=0

		if not rsCTget.EOF then
			fnGiftTalkBestTalk = rsCTget.getRows()
		end if
		rsCTget.close
	End Function
	
	
	'####### gift story 리스트 -->
	public Function fnGiftStoryList
		Dim strSql, i
		
		strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftStory_List] '" & FRectItemId & "', '" & FRectUseYN & "'"
		'response.write strSql
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open strSql,dbCTget,1

		FResultCount = rsCTget.RecordCount
        if (FResultCount<1) then FResultCount=0

		if not rsCTget.EOF then
			fnGiftStoryList = rsCTget.getRows()
		end if
		rsCTget.close
	End Function
	
	
	'####### gift write itemlist AJAX -->
	public Sub fnGiftTalkItemAjaxList
		Dim strSql, vArr, i
		
		strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_ItemAjaxList] '" & FRectItemId & "'"
		'response.write strSql
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open strSql,dbCTget,1

		FResultCount = rsCTget.RecordCount
        if (FResultCount<1) then FResultCount=0

		if not rsCTget.EOF then
			vArr = rsCTget.getRows()
		end if
		rsCTget.close
		
		REDIM FItemList(FResultCount)
		
		For i=0 To FResultCount -1
			SET FItemList(i) = NEW CCategoryPrdItem
				FItemList(i).FItemid = vArr(0,i)
				FItemList(i).FItemName = db2html(vArr(1,i))
				FItemList(i).FMakerId = vArr(2,i)
				FItemList(i).FBrandName = db2html(vArr(3,i))
				FItemList(i).FImageList 	= "http://webimage.10x10.co.kr/image" & "/list/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(vArr(4,i))
				FItemList(i).FImageIcon1 = "http://webimage.10x10.co.kr/image" & "/icon1/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(vArr(5,i))
				FItemList(i).FImageIcon2 	= "http://webimage.10x10.co.kr/image" & "/icon2/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(vArr(6,i))
				FItemList(i).FImageBasic 	= "http://webimage.10x10.co.kr/image" & "/basic/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(vArr(7,i))
				FItemList(i).FSellCash = vArr(8,i)
				FItemList(i).FOrgPrice = vArr(9,i)
				FItemList(i).FSaleyn = vArr(10,i)
				FItemList(i).FSellyn = vArr(11,i)
				FItemList(i).FItemcouponyn = vArr(12,i)
				FItemList(i).FItemCouponValue = vArr(13,i)
				FItemList(i).FItemCouponType = vArr(14,i)
				FItemList(i).FSpecialUserItem = vArr(15,i)
				FItemList(i).FfavCount = vArr(16,i)
				FItemList(i).FEvalCnt = vArr(17,i)
				
				If FResultCount > 1 Then
					If CStr(Split(FRectItemId,",")(0)) = CStr(FItemList(i).FItemid) Then
						F1Item = i
					End If
					If CStr(Split(FRectItemId,",")(1)) = CStr(FItemList(i).FItemid) Then
						F2Item = i
					End If
				End If
		Next
		
	End Sub
	
	
	
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
	vQuery = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_MyTalkConfirm] '" & talkidx & "', '" & userID & "'"
	dbCTget.execute vQuery
	response.Cookies("uinfo")("isnewcomm") = ""
End Function


Function keywordSelectBox(key1, key2)
	Dim i, vBody, vQuery
	vBody = vBody & "<div class=""overHidden"">"
	vBody = vBody & "<select name=""keyword1"" class=""ftLt"" style=""width:49%"" onChange=""showKeyword2(this.value);"">" & vbCrLf
	vBody = vBody & "	<option value="""">상황 선택하기</option>" & vbCrLf
	
	vQuery = "SELECT code, codename FROM [db_Gifts].[dbo].[tbl_shopping_talk_keywordcode] WHERE depth = '1' AND useyn = 'y' ORDER BY sortno ASC, code ASC"
	rsCTget.Open vQuery,dbCTget,1
	
	Do Until rsCTget.Eof
		vBody = vBody & "	<option value=""" & rsCTget("code") & """ " & CHKIIF(key1=rsCTget("code"),"selected","") & ">" & rsCTget("codename") & "</option>" & vbCrLf
		rsCTget.MoveNext
	Loop
	rsCTget.close()

	vBody = vBody & "</select>" & vbCrLf
	
	If key1 <> "" Then
		vBody = vBody & "<select name=""keyword2"" class=""ftRt"" style=""width:49%"" onChange=""searchTalkList('"&key1&"',this.value);"">" & vbCrLf
		vBody = vBody & "	<option value="""">대상 선택하기</option>" & vbCrLf
		
		vQuery = "SELECT code, codename FROM [db_Gifts].[dbo].[tbl_shopping_talk_keywordcode] WHERE depth = '2' AND Left(code,1) = '" & key1 & "' AND useyn = 'y' ORDER BY sortno ASC, code ASC"
		rsCTget.Open vQuery,dbCTget,1
		
		Do Until rsCTget.Eof
			vBody = vBody & "	<option value=""" & rsCTget("code") & """ " & CHKIIF(CStr(key2)=CStr(rsCTget("code")),"selected","") & ">" & rsCTget("codename") & "</option>" & vbCrLf
			rsCTget.MoveNext
		Loop
		rsCTget.close()

		vBody = vBody & "</select>" & vbCrLf
	End If
	vBody = vBody & "</div>"
	
	Response.Write vBody
End Function


Function fnTagLinkSetting(g, tag)
	Dim vBody, i, vTemp, vTag, vKey, vPage
	If g = "i" Then
		vPage = "/gift/gifttalk/index.asp"
	ElseIf g = "m" Then
		vPage = "/gift/gifttalk/mytalk.asp"
	End If

	For i = LBound(Split(tag,"@")) To UBound(Split(tag,"@"))
		vTemp = Split(tag,"@")(i)
		vKey = Split(vTemp,",")(0)
		vTag = Split(vTemp,",")(1)
		vBody = vBody & "<a href=""javascript:goKeyword('"&vKey&"');"">" & vTag &"</a>, "
	Next
	
	If vBody <> "" Then
		vBody = Trim(vBody)
		If Right(vBody,1) = "," Then
			vBody = Left(vBody,Len(vBody)-1)
		End IF
	End IF
	
	fnTagLinkSetting = vBody
End Function


'//카테고리 // 구 카테고리임..
'function drawwishcategory(stats)
'	dim userquery, tem_str
'
'	response.write "<option value=''"
'		if stats ="" then
'			response.write " selected"
'		end if
'	response.write ">전체 카테고리</option>"
'
'		userquery = "select L.code_large, L.code_nm"
'		userquery = userquery + " from db_item.dbo.tbl_Cate_large as L "
'		userquery = userquery + " where L.display_yn = 'Y' and L.code_large <> '999' "
'		userquery = userquery + " order by orderNo asc"
'
'	rsCTget.Open userquery, dbCTget, 1
'	'response.write userquery&"<br>"
'
'	if not rsCTget.EOF then
'		do until rsCTget.EOF
'			if cstr(stats) = cstr(rsCTget("code_large")) then
'				tem_str = " selected"
'			end if
'			response.write "<option value='" & rsCTget("code_large") & "' " & tem_str & ">" & rsCTget("code_nm") & "</option>"
'			tem_str = ""
'			rsCTget.movenext
'		loop
'	end if
'	rsCTget.close
'End function


Function fnTalkReadCount(talkidx)
	Dim vQuery
	vQuery = "EXECUTE [db_Gifts].[dbo].[sp_Ten_GiftTalk_ReadCount] '" & talkidx & "'"
	dbCTget.Execute vQuery
End function


Function fnTalkPicRandom()
	Dim k
	Randomize
	k = Int(2 * Rnd)
	If k = 0 Then
		fnTalkPicRandom = "A"
	Else
		fnTalkPicRandom = "B"
	End If
End Function


Function fnTalkRegTime(d)
	If DateDiff("h",d,now()) > 23 Then
		fnTalkRegTime = Replace(Left(d,10),"-",".")
	ElseIf DateDiff("h",d,now()) = 0 Then
		fnTalkRegTime = "지금 막"
	Else 
		fnTalkRegTime = DateDiff("h",d,now()) & "시간 전"
	End If
End Function


Function fnTalkKeywordTab(skey, key)
	'### skey : 검색값, key : 리스트의 한개값
	Dim i, a, vSearch, vValue
	vSearch = skey
	vValue = key
	a = "x"
	If vValue <> "" Then
		vSearch = Replace(vSearch," ","")
		vSearch = "," & vSearch & ","
		vValue = Replace(vValue," ","")
		vValue = "," & vValue & ","
		
		If InStr(vSearch,vValue) > 0 Then
			a = "o"
		End If
	End If
	fnTalkKeywordTab = a
End Function


Function fnTalkKeywordOnClick(skey,key)
	'### skey : 검색값, key : 리스트의 한개값
	Dim i, a, vSearch, vValue
	vSearch = skey
	vValue = key
	If vSearch <> "" Then
		If fnTalkKeywordTab(vSearch,vValue) = "o" Then
			vSearch = "," & vSearch & ","
			vValue = "," & vValue & ","
			vSearch = Replace(vSearch,vValue,",")

			If Left(vSearch,1) = "," Then
				vSearch = Right(vSearch,Len(vSearch)-1)
			End IF
			If Right(vSearch,1) = "," Then
				vSearch = Left(vSearch,Len(vSearch)-1)
			End IF
			
			fnTalkKeywordOnClick = vSearch
		Else
			fnTalkKeywordOnClick = vSearch & "," & vValue
		End IF
	Else
		fnTalkKeywordOnClick = vValue
	End If
End Function


'// 원 판매 가격  '!
Function getOrgPrice(FOrgPrice, FSellCash)
	if FOrgPrice=0 then
		getOrgPrice = FSellCash
	else
		getOrgPrice = FOrgPrice
	end if
End Function
	

'// 세일포함 실제가격  '!
Function getRealPrice(sellcash, specialuseritem)
	getRealPrice = sellcash

	if (IsSpecialUserItem(specialuseritem)) then
		getRealPrice = getSpecialShopItemPrice(sellcash)
	end if
End Function


'// 할인율 '!
Function getSalePro(FOrgprice, sellcash, specialuseritem)
	if FOrgprice=0 then
		getSalePro = 0 & "%"
	else
		getSalePro = CLng((FOrgPrice-getRealPrice(sellcash, specialuseritem))/FOrgPrice*100) & "%"
	end if
End Function


'// 우수회원샵 상품 여부 '!
Function IsSpecialUserItem(specialuseritem)
    dim uLevel
    uLevel = GetLoginUserLevel()
	IsSpecialUserItem = (specialuseritem>0) and (uLevel>0 and uLevel<>5)
End Function


'// 세일 상품 여부 '!
Function IsSaleItem(FSaleYn, FOrgPrice, FSellCash, specialuseritem)
    IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FSellCash>0)) or (IsSpecialUserItem(specialuseritem))
End Function


'// 상품 쿠폰 여부  '!
Function IsCouponItem(FItemCouponYN)
	IsCouponItem = (FItemCouponYN="Y")
End Function


'// 쿠폰 적용가
Function GetCouponAssignPrice(FItemCouponYN, sellcash, specialuseritem, Fitemcoupontype, Fitemcouponvalue)
	if (IsCouponItem(FItemCouponYN)) then
		GetCouponAssignPrice = getRealPrice(sellcash, specialuseritem) - GetCouponDiscountPrice(Fitemcoupontype, Fitemcouponvalue, sellcash, specialuseritem)
	else
		GetCouponAssignPrice = getRealPrice(sellcash, specialuseritem)
	end if
End Function


'// 쿠폰 할인가 '?
Function GetCouponDiscountPrice(Fitemcoupontype, Fitemcouponvalue, sellcash, specialuseritem)
	Select case Fitemcoupontype
		case "1" ''% 쿠폰
			GetCouponDiscountPrice = CLng(Fitemcouponvalue*getRealPrice(sellcash, specialuseritem)/100)
		case "2" ''원 쿠폰
			GetCouponDiscountPrice = Fitemcouponvalue
		case "3" ''무료배송 쿠폰
		    GetCouponDiscountPrice = 0
		case else
			GetCouponDiscountPrice = 0
	end Select
End Function


'// 상품 쿠폰 내용  '!
Function GetCouponDiscountStr(Fitemcoupontype, Fitemcouponvalue)
	Select Case Fitemcoupontype
		Case "1"
			GetCouponDiscountStr =CStr(Fitemcouponvalue) + "%"
		Case "2"
			GetCouponDiscountStr = formatNumber(Fitemcouponvalue,0) + "원 할인"
		Case "3"
			GetCouponDiscountStr ="무료배송"
		Case Else
			GetCouponDiscountStr = Fitemcoupontype
	End Select
End Function

Function fnSortMatching(a)
	SELECT Case a
		Case "fav" : fnSortMatching = "be"
		Case "highprice" : fnSortMatching = "hp"
		Case "lowprice" : fnSortMatching = "lp"
		Case Else : fnSortMatching = "be"
	End SELECT
End Function


Function fnGetSearchCategoryList(DocSearchText, SortMet, SearchCateDep)
	Dim vBody, Lp, oGrCat, vName, vCode
	set oGrCat = new SearchItemCls
		oGrCat.FRectSearchTxt = DocSearchText
		oGrCat.FRectSortMethod = SortMet
		oGrCat.FRectSearchItemDiv = "y"
		oGrCat.FRectSearchCateDep = SearchCateDep
		oGrCat.FCurrPage = 1
		oGrCat.FPageSize = 200
		oGrCat.FScrollCount =10
		oGrCat.FListDiv = "search"
		oGrCat.FGroupScope = "2"	'카테고리 그룹 범위(depth)
		oGrCat.FLogsAccept = False '그룹형은 절대 !!! False 
		oGrCat.getGroupbyCategoryList		'//카테고리 접수
		
		for Lp=0 to oGrCat.FResultCount-1
			If oGrCat.FItemList(Lp).FCateCd1 <> vCode Then
				vBody = vBody & "<li><span>" & Split(oGrCat.FItemList(Lp).FCateName,"^^")(0) & "</span></li>" & vbCrLf
			End IF
			vCode = oGrCat.FItemList(Lp).FCateCd1
		next
	set oGrCat = nothing
		fnGetSearchCategoryList = vBody
End Function

Function fnTalkModifyKeySetting(k)
	Dim i, vTmp
	For i = LBound(Split(k,"@")) To UBound(Split(k,"@"))
		vTmp = vTmp & Split(Split(k,"@")(i),",")(0)
		If i <> UBound(Split(k,"@")) Then
			vTmp = vTmp & ","
		End IF
	Next
	fnTalkModifyKeySetting = vTmp
End Function
%>