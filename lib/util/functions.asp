<%
''// 내 위시 상품 목록(검색 결과에서 상품목록 전송)
'Sub getMyFavItemList(uid,iid,byRef sIid, byRef sCnt)
'  Exit Sub ''더이상 사용안함
'	dim strSQL, aiid, acnt
'	aiid="": acnt=""
'
'	if (uid="" or iid="") then Exit Sub
'	
'	on error resume next
'	strSQL = "execute [db_my10x10].[dbo].[sp_Ten_MyWishSearchItem] '" & CStr(uid) & "', '" & cStr(iid) & "'"
'
'	rsget.CursorLocation = adUseClient
'	rsget.CursorType=adOpenStatic
'	rsget.Locktype=adLockReadOnly
'	rsget.Open strSQL, dbget
'	if Not(rsget.EOF or rsget.BOF) then
'		Do Until rsget.EOF
'			aiid = aiid & chkIIF(aiid<>"",",","") & rsget("itemid")
'			acnt = acnt & chkIIF(acnt<>"",",","") & rsget("favcount")
'			rsget.MoveNext
'		Loop
'	end if
'	rsget.Close
'	on error goto 0
'
'	'결과 반환
'	sIid = aiid
'	sCnt = acnt
'end Sub

'2017 모바일 리뉴얼
Sub getMyFavItemList(uid,iid,byRef sWArr)
  'Exit Sub ''사용안함 2014/09/23
	dim strSQL
	strSQL = "execute [db_my10x10].[dbo].[sp_Ten_MyWishSearchItemNew] '" & CStr(uid) & "', '" & cStr(iid) & "'"
	rsget.CursorLocation = adUseClient
	rsget.Open strSQL,dbget,adOpenForwardOnly,adLockReadOnly
	if Not(rsget.EOF or rsget.BOF) then
		sWArr = rsget.getRows()
	end if
	rsget.Close
end Sub

'// 뱃지 아이콘 목록 접수(코멘트, 후기 등)
Sub getUserBadgeList(uid,byRef sUid,byRef sBno, isRnd)
	dim strSQL, auid, abno
	auid="": abno=""

	if (uid="") then Exit Sub
	strSQL = "execute [db_my10x10].[dbo].[sp_Ten_UserBadgeGetArrList] '" & CStr(uid) & "','" & isRnd & "'"

	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open strSQL, dbget
	if Not(rsget.EOF or rsget.BOF) then
		Do Until rsget.EOF
			if Not(rsget("dispno")="" or isNull(rsget("dispno"))) then
				auid = auid & chkIIF(auid<>"",",","") & rsget("userid")
				abno = abno & chkIIF(abno<>"",",","") & rsget("dispno")
			end if
			rsget.MoveNext
		Loop
	end if
	rsget.Close

	'결과 반환
	sUid = auid
	sBno = abno
end Sub

'// 뱃지 아이콘 출력 (아이콘 목록 사용;getUserBadgeList())
Function getUserBadgeIcon(uid,arrUid,arrBno,pno)
	Dim strRst, tmpBdg, i, arrBdgNm
	arrBdgNm = split("슈퍼 코멘터||기프트 초이스||위시 메이커||포토 코멘터||브랜드 쿨!||얼리버드||세일헌터||스타일리스트||컬러홀릭||텐텐 트윅스||카테고리 마스터||톡! 엔젤||10월 스페셜||11월 스페셜||12월 스페셜","||")

	if chkArrValue(arrUid,uid) then
		tmpBdg = chkArrSelVal(arrUid,arrBno,uid)
		tmpBdg = split(tmpBdg,"||")

		'strRst = "<p class=""badgeView"">"

		for i=0 to ubound(tmpBdg)
			strRst = strRst & "<span><img src=""http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge" & Num2Str(tmpBdg(i),2,"0","R") & ".png"" title=""" & arrBdgNm(tmpBdg(i)-1) & """ /></span> "
			if i>=(pno-1) then Exit For
		next

		'strRst = strRst & "</p>"
	end if

	getUserBadgeIcon = strRst
End Function

'//텐바이텐 상품고시관련 상품후기 제외 상품		'//2013.12.26 한용민 생성
function getEvaluate_exclude_Itemyn(itemid)
	dim sqlstr, tmpexists
	tmpexists="N"
	
	if itemid="" or itemid="0" then
		getEvaluate_exclude_Itemyn=tmpexists
		exit function
	end if

	sqlstr = "exec db_board.dbo.sp_Ten_Evaluate_exclude_oneItem '"& itemid &"'"
	
	'response.write sqlstr & "<Br>"
	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open sqlstr, dbget
	if Not(rsget.EOF or rsget.BOF) then
		if rsget("cnt")>0 then
			tmpexists="Y"
		end if
	else
		tmpexists="N"
	end if
	rsget.Close
	
	getEvaluate_exclude_Itemyn=tmpexists
end function

'// 이벤트 로그 저장(이벤트코드, 유저ID, IP-자동저장, 값1, 값2, 값3, 디바이스 ) '//2015.05.13 유태욱 생성
Function fnCautionEventLog(evt_code,userid,value1,value2,value3,device)
	Dim strSql
	strSql = "insert into db_log.[dbo].[tbl_caution_event_log] (evt_code, userid, refip, value1 , value2, value3, device ) values " &_
			" ('"& evt_code &"'" &_
			", '"& userid &"'" &_
			", '"& Left(request.ServerVariables("REMOTE_ADDR"),32) & "'" &_
			", '"& value1 &"'" &_
			", '"& value2 &"'" &_
			", '"& value3 &"'" &_
			", '"& device & "')"
	dbget.Execute strSql
End Function


'// 2016 카테고리 선택 상자 (sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명)
Sub fnPrntDispCateNaviV16(sDisp,sType,sCallback)
	Dim sName, sDepth, sResult, sTmp
	Dim strSql

	'// 카테고리 명 접수
	If sDisp = "" Then
		sName = "전체 카테고리"
	Else
		sName = getDisplayCateNameDB(sDisp)
	End If

	'// 카테고리 조회 범위 설정
	if sDisp="" then
		sDepth = 1
	else
		sDepth = cInt(len(sDisp)/3)
	end if

	'// 표시 형태 (F: 1뎁스 고정, E: 하위분류 확장, S:검색엔진)
	if sType="" then sType="F"
	if sType="E" and sDisp<>"" then sDepth = sDepth +1
	if sType="S" and sDisp<>"" then
		sDepth = sDepth +1
		if sDepth>3 then sDepth=3
	End if

	'// 결과 출력
	sResult = "<button type=""button"" id=""btnDispCate"">" & sName & "</button>" & vbCrLf &_
		"	<div class=""sortNaviV16a" & chkIIF(sDepth>1," depth2","")& """>" & vbCrLf &_
		"	<ul id=""lyrDispCateList"">" & vbCrLf

		Select Case sType
			Case "F","E"
				'/// DB에서 전시카테고리 접수

				'1Depth는 전체 항목 추가
				if sDepth=1 then
					sResult = sResult & "<li " & chkIIF(sDisp="","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('');return false;""><span>전체<span></a></li>" & vbCrLf
				end if

				'최종뎁스 확인
				If sDepth > 1 Then
					strSql = " select count(catecode) as cnt from [db_item].[dbo].tbl_display_cate "
					strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode<>123 "
					strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
					rsget.Open strSql,dbget,1
					if rsget("cnt")=0 then
						sDepth = sDepth -1
					end if
					rsget.Close
				end if
		
				'전시카테고리 접수
				strSql = " select catecode, catename from [db_item].[dbo].tbl_display_cate "
				strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode<>123 "
				If sDepth > 1 Then
					strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
				End If
				strSql = strSql & " order by sortno Asc"
				rsget.Open strSql,dbget,1
				if  not rsget.EOF  then
					do until rsget.EOF
						if Left(Cstr(sDisp),3*sDepth) = Cstr(rsget("catecode")) then
							sTmp = "class=""selected"""
						end if
						sResult = sResult & "<li "&sTmp&"><a href=""#"" onclick=""" & sCallback & "(" &rsget("catecode") &");return false;""><span>"& db2html(rsget("catename")) &"</span></a></li>"
						sTmp = ""
					rsget.MoveNext
					loop
				end if
				rsget.close
			Case "S"
				'/// Ajax 사용 (호출 페이지에서 처리: 여기선 내용없음)
		End Select
		sResult = sResult & "	</ul>" & vbCrLf &_	
		"</div>"
	Response.Write sResult
End Sub

'// 카테고리 리스트 _ 해당카테고리 매출순 이벤트 top 5
Sub fnCategoryBestEvent(sDisp,catename)

	Dim strSql , vReturnHtml , vLink , eName , eNameredsale
	strSql = "EXEC [db_event].[dbo].[usp_WWW_Event_CategoryBestEvent_Get] @primaryCategory='"& sDisp &"'"
	rsget.Open strSql,dbget,1
	if  not rsget.EOF  Then
		If rsget.RecordCount < 3 Then Exit Sub
	vReturnHtml = vReturnHtml & "<div class='category-exhibition'><div class='list-card type-align-left swiper-container'><ul class='swiper-wrapper'>"
		do until rsget.EOF

			if rsget("evt_kind") = "13" Then '//상품이벤트 일경우
				vLink = "TnGotoProduct('" & rsget("itemid") & "');"
			Else '// 그외에
				IF rsget("evt_bannerlink")="I" and rsget("itemid") <>"" THEN '링크타입 체크
					vLink = "location.href='" & rsget("evt_bannerlink") & "';"
				ELSE
					vLink = "TnGotoEventMain("""&rsget("evt_code")&"&pCtr="&sDisp&""");"
				END IF
			End If

			'//이벤트 명 할인이나 쿠폰시
			If rsget("issale") Or rsget("iscoupon") Then
				if ubound(Split(rsget("evt_name"),"|"))> 0 Then
					If rsget("issale") Or (rsget("issale") And rsget("iscoupon")) then
						eName = cStr(Split(rsget("evt_name"),"|")(0))
						eNameredsale = cStr(Split(rsget("evt_name"),"|")(1))
					ElseIf rsget("iscoupon") Then
						eName = cStr(Split(rsget("evt_name"),"|")(0))
						eNameredsale = cStr(Split(rsget("evt_name"),"|")(1))
					End If
				Else
					eName = rsget("evt_name")
					eNameredsale = ""
				end If
			Else
				eName = rsget("evt_name")
				eNameredsale = ""
			End If

		vReturnHtml = vReturnHtml & "<li class='swiper-slide'><a href='' onclick='"& vLink &"return false;'><div class='thumbnail'><img src='"& rsget("evt_mo_listbanner")&"' alt=''></div><p class='desc'><b class='headline'><span class='ellipsis'>"& fn_brcheck(eName) &"</span>"& chkiif(eNameredsale<>"","<b class='discount color-red'>"& eNameredsale &"</b>","") &"</b><span class='subcopy ellipsis'>"& fn_brcheck(rsget("evt_subname")) &"</span></p></a></li>"

		rsget.MoveNext
		Loop
		
	vReturnHtml = vReturnHtml & "<li class='swiper-slide view-all-ex'><a href='/gnbevent/shoppingchance_allevent.asp?disp="& sDisp &"&scTgb=planevt'><span class='icon icon-hand'></span>"& catename &"<br />기획전 전체보기</a></li></ul></div></div>"
	end if
	rsget.close

	Response.write vReturnHtml
End sub

'// 카테고리 리스트 _ pc에 등록된 카테고리별 이벤트
Sub fnCategoryBestEventPcSync(sDisp,catename)

	Dim strSql , vReturnHtml , vLink , eName , eNameredsale
	'strSql = "EXEC [db_event].[dbo].[usp_WWW_Event_CategoryBestEvent_Get] @primaryCategory='"& sDisp &"'"
	strSql = "EXEC [db_event].[dbo].[usp_WWW_Event_CategoryBestEventPCSync_Get] @primaryCategory='"& sDisp &"'"
	rsget.Open strSql,dbget,1
	if  not rsget.EOF  Then
		If rsget.RecordCount < 3 Then Exit Sub
	vReturnHtml = vReturnHtml & "<div class='category-exhibition'><div class='list-card type-align-left swiper-container'><ul class='swiper-wrapper'>"
		do until rsget.EOF

			If rsget("linkurl") <> "" Then
				vLink = "<a href='"&trim(db2html(rsget("linkurl")))&"'>"
			Else
				vLink = "<a href='' onclick='TnGotoEventMain("""&rsget("evt_code")&"&pCtr="&sDisp&""");return false;'>"
			End If

			'//이벤트 명 할인이나 쿠폰시
			If rsget("issale") Or rsget("iscoupon") Then
				if ubound(Split(rsget("evt_name"),"|"))> 0 Then
					If rsget("issale") Or (rsget("issale") And rsget("iscoupon")) then
						eName = cStr(Split(rsget("evt_name"),"|")(0))
						eNameredsale = cStr(Split(rsget("evt_name"),"|")(1))
					ElseIf rsget("iscoupon") Then
						eName = cStr(Split(rsget("evt_name"),"|")(0))
						eNameredsale = cStr(Split(rsget("evt_name"),"|")(1))
					End If
				Else
					eName = rsget("evt_name")
					eNameredsale = ""
				end If
			Else
				eName = rsget("evt_name")
				eNameredsale = ""
			End If

		vReturnHtml = vReturnHtml & "<li class='swiper-slide'>"& vLink &"<div class='thumbnail'><img src='"& rsget("evt_mo_listbanner")&"' alt=''></div><p class='desc'><b class='headline'><span class='ellipsis'>"& fn_brcheck(eName) &"</span>"& chkiif(eNameredsale<>"","<b class='discount color-red'>"& eNameredsale &"</b>","") &"</b><span class='subcopy ellipsis'>"& fn_brcheck(rsget("evt_subname")) &"</span></p></a></li>"

		rsget.MoveNext
		Loop
		
	vReturnHtml = vReturnHtml & "<li class='swiper-slide view-all-ex'><a href='/gnbevent/shoppingchance_allevent.asp?disp="& sDisp &"&scTgb=planevt'><span class='icon icon-hand'></span>"& catename &"<br />기획전 전체보기</a></li></ul></div></div>"
	end if
	rsget.close

	Response.write vReturnHtml
End sub

'// 2017 카테고리 선택 상자 (sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명)
Sub fnPrntDispCateNaviV17(sDisp,sType,sCallback)
	Dim sName, sDepth, sResult, sTmp
	Dim strSql
	Dim amplitudeDepth, amplitudemove, amplitudemoveDepth

	'// 카테고리 명 접수
	If sDisp = "" Then
		sName = "전체 카테고리"
	Else
		sName = getDisplayCateNameDB(sDisp)
	End If

	'// 카테고리 조회 범위 설정
	if sDisp="" then
		sDepth = 1
		amplitudeDepth = 1
	else
		sDepth = cInt(len(sDisp)/3)
		amplitudeDepth = cInt(len(sDisp)/3)
	end if

	If Trim(CStr(amplitudeDepth)) = "4" Then
		amplitudemove = "same"
		amplitudemoveDepth = amplitudeDepth
	Else
		amplitudemove = "down"
		amplitudemoveDepth = amplitudeDepth + 1
	End If

	'// 표시 형태 (F: 1뎁스 고정, E: 하위분류 확장, S:검색엔진)
	if sType="" then sType="F"
	if sType="E" and sDisp<>"" then sDepth = sDepth +1
	if sType="S" and sDisp<>"" then
		sDepth = sDepth +1
		if sDepth>3 then sDepth=3
	End if

	'// 결과 출력
'	sResult = "<button type=""button"" id=""btnDispCate"">" & sName & "</button>" & vbCrLf &_
'		"	<div class=""sortNaviV16a" & chkIIF(sDepth>1," depth2","")& """>" & vbCrLf &_
	sResult = 	"	<ul id=""lyrDispCateList"">" & vbCrLf

		Select Case sType
			Case "F","E"
				'/// DB에서 전시카테고리 접수

				'1Depth는 전체 항목 추가
				if sDepth=1 then
					sResult = sResult & "<li " & chkIIF(sDisp="","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('');return false;""><span>전체<span></a></li>" & vbCrLf
				end if

				'최종뎁스 확인
				If sDepth > 1 Then
					strSql = " select count(catecode) as cnt from [db_item].[dbo].tbl_display_cate "
					strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode<>123 "
					strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
					rsget.Open strSql,dbget,1
					if rsget("cnt")=0 then
						sDepth = sDepth -1
					end if
					rsget.Close
				end if
		
				'전시카테고리 접수
				strSql = " select catecode, catename from [db_item].[dbo].tbl_display_cate "
				strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode<>123 "
				If sDepth > 1 Then
					strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
				End If
				strSql = strSql & " order by sortno Asc"
				rsget.Open strSql,dbget,1
				if  not rsget.EOF  then
					do until rsget.EOF
						if Left(Cstr(sDisp),3*sDepth) = Cstr(rsget("catecode")) then
							sTmp = "class=""on"""
						end if
						sResult = sResult & "<li><a href=""#""  "&sTmp&" onclick=""" & sCallback & "(" &rsget("catecode") &");fnAmplitudeEventMultiPropertiesAction('click_category_productlist_depth', 'category_code|category_depth|move_category_code|move_category_depth|move', '"&sDisp&"|"&amplitudeDepth&"|"&rsget("catecode")&"|"&amplitudemoveDepth&"|"&amplitudemove&"');return false;"">"& db2html(rsget("catename")) &"</a></li>"
						sTmp = ""
					rsget.MoveNext
					loop
				end if
				rsget.close
			Case "S"
				'/// Ajax 사용 (호출 페이지에서 처리: 여기선 내용없음)
		End Select
		sResult = sResult & "	</ul>"' & vbCrLf &_	
'		"</div>"
	Response.Write sResult
End Sub


'// 카테고리 호출 2depth 
Sub fnPrntDispCateNavi_2Depth(sDisp,sType,sCallback)
	Dim sName, sDepth, sResult, sTmp
	Dim strSql

	'// 카테고리 조회 범위 설정
	if sDisp="" then
		sDepth = 1
	else
		sDepth = cInt(len(sDisp)/3)
	end If
	
	'// 표시 형태 (F: 1뎁스 고정, E: 하위분류 확장, S:검색엔진)
	if sType="" then sType="F"
	if sType="E" and sDisp<>"" then sDepth = sDepth +1
	if sType="S" and sDisp<>"" then
		sDepth = sDepth +1
		if sDepth>3 then sDepth=3
	End if

	'최종뎁스 확인
	If sDepth > 1 Then
		strSql = " select count(catecode) as cnt from [db_item].[dbo].tbl_display_cate "
		strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode<>123 "
		strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
		rsget.Open strSql,dbget,1
		if rsget("cnt")=0 then
			sDepth = sDepth -1
		end if
		rsget.Close
	end If
	
	sResult = sResult & "<li><a href=""#"" onclick=""" & sCallback & "("& sDisp &");return false;""><span>전체보기<span></a></li>" & vbCrLf

	'전시카테고리 접수
	strSql = " select catecode, catename from [db_item].[dbo].tbl_display_cate "
	strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode not in(123,117112) "
	If sDepth > 1 Then
		strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
	End If
	strSql = strSql & " order by sortno Asc"
	rsget.Open strSql,dbget,1
	if  not rsget.EOF  then
		do until rsget.EOF
			if Left(Cstr(sDisp),3*sDepth) = Cstr(rsget("catecode")) then
				sTmp = "class=""on"""
			end if
			sResult = sResult & "<li><a href=""#"" onclick=""" & sCallback & "(" &rsget("catecode") &");return false;"">"& db2html(rsget("catename")) &"</a></li>"
			sTmp = ""
		rsget.MoveNext
		loop
	end if
	rsget.close

	Response.Write sResult
End Sub

'// 카테고리 호출 2depth 
Sub fnPrntDispCateNavi_2DepthLiving(sDisp,sType,sCallback)
	Dim sName, sDepth, sResult, sTmp
	Dim strSql

	'// 카테고리 조회 범위 설정
	if sDisp="" then
		sDepth = 1
	else
		sDepth = cInt(len(sDisp)/3)
	end If
	
	'// 표시 형태 (F: 1뎁스 고정, E: 하위분류 확장, S:검색엔진)
	if sType="" then sType="F"
	if sType="E" and sDisp<>"" then sDepth = sDepth +1
	if sType="S" and sDisp<>"" then
		sDepth = sDepth +1
		if sDepth>3 then sDepth=3
	End if

	'최종뎁스 확인
	If sDepth > 1 Then
		strSql = " select count(catecode) as cnt from [db_item].[dbo].tbl_display_cate "
		strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and catecode not in(123,117112,121114,120113,122112,112113)  "
		strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
		rsget.Open strSql,dbget,1
		if rsget("cnt")=0 then
			sDepth = sDepth -1
		end if
		rsget.Close
	end If
	
	sResult = sResult & "<li><a href=""#"" onclick=""" & sCallback & "("& sDisp &");return false;""><span>전체보기<span></a></li>" & vbCrLf

	'전시카테고리 접수
	strSql = " select catecode, catename from [db_item].[dbo].tbl_display_cate "
	strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode not in(123,117112,121114,120113,122112,112113) "
	If sDepth > 1 Then
		strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
	End If
	strSql = strSql & " order by sortno Asc"
	rsget.Open strSql,dbget,1
	if  not rsget.EOF  then
		do until rsget.EOF
			if Left(Cstr(sDisp),3*sDepth) = Cstr(rsget("catecode")) then
				sTmp = "class=""on"""
			end if
			sResult = sResult & "<li><a href=""#"" onclick=""" & sCallback & "(" &rsget("catecode") &");return false;"">"& db2html(rsget("catename")) &"</a></li>"
			sTmp = ""
		rsget.MoveNext
		loop
	end if
	rsget.close

	Response.Write sResult
End Sub

'// 2017 카테고리 선택 상자 _ BEST (sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명)
Sub fnPrntDispCateNaviV17BEST(sDisp,sType,sCallback)
	Dim sName, sDepth, sResult, sTmp
	Dim strSql

	'// 카테고리 명 접수
	If sDisp = "" Then
		sName = "전체 카테고리"
	Else
		sName = getDisplayCateNameDB(sDisp)
	End If

	'// 카테고리 조회 범위 설정
	if sDisp="" then
		sDepth = 1
	else
		sDepth = cInt(len(sDisp)/3)
	end if

	'// 표시 형태 (F: 1뎁스 고정, E: 하위분류 확장, S:검색엔진)
	if sType="" then sType="F"
	if sType="E" and sDisp<>"" then sDepth = sDepth +1
	if sType="S" and sDisp<>"" then
		sDepth = sDepth +1
		if sDepth>3 then sDepth=3
	End if

	'// 결과 출력
	sResult = 	"	<select class=""select"" title=""카테고리 선택옵션"" onchange=""" & sCallback & "(this.value);"">" & vbCrLf

		Select Case sType
			Case "F","E"
				'/// DB에서 전시카테고리 접수

				'1Depth는 전체 항목 추가
				if sDepth=1 then
					sResult = sResult & "<option " & chkIIF(sDisp="","class=""selected""","") & " value="""">전체 카테고리</option>" & vbCrLf
				end if

				'최종뎁스 확인
				If sDepth > 1 Then
					strSql = " select count(catecode) as cnt from [db_item].[dbo].tbl_display_cate "
					strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode<>123 "
					strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
					rsget.Open strSql,dbget,1
					if rsget("cnt")=0 then
						sDepth = sDepth -1
					end if
					rsget.Close
				end if
		
				'전시카테고리 접수
				strSql = " select catecode, catename from [db_item].[dbo].tbl_display_cate "
				strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode<>123 "
				If sDepth > 1 Then
					strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
				End If
				strSql = strSql & " order by sortno Asc"
				rsget.Open strSql,dbget,1
				if  not rsget.EOF  then
					do until rsget.EOF
						if Left(Cstr(sDisp),3*sDepth) = Cstr(rsget("catecode")) then
							sTmp = "selected=""selected"""
						end if
						sResult = sResult & "<option "&sTmp&" value=""" &rsget("catecode") &""">"& db2html(rsget("catename")) &"</option>"
						sTmp = ""
					rsget.MoveNext
					loop
				end if
				rsget.close
			Case "S"
				'/// Ajax 사용 (호출 페이지에서 처리: 여기선 내용없음)
		End Select
		sResult = sResult & "	</select>"' & vbCrLf &_	
'		"</div>"
	Response.Write sResult
End Sub
'// 2017 조건선택상자
Sub fnPrntSortNaviV17BEST(sType,sCallback)
	Dim sName, sResult, lp
	if sType="" then sType="be"
	
	sResult = "<select class=""select"" title=""베스트 정렬 옵션"" onchange=""" & sCallback & "(this.value);"">" & vbCrLf
	sResult = sResult& "<option " & chkIIF(sType="ne","selected=""selected""","") & " value=""ne"">신상품 베스트</option>" & vbCrLf
	sResult = sResult& "<option " & chkIIF(sType="be","selected=""selected""","") & " value=""be"">베스트셀러</option>" & vbCrLf
	sResult = sResult& "<option " & chkIIF(sType="st","selected=""selected""","") & " value=""st"">스테디셀러</option>" & vbCrLf
	sResult = sResult& "<option " & chkIIF(sType="br","selected=""selected""","") & " value=""br"">베스트 브랜드</option>" & vbCrLf
	sResult = sResult& "<option " & chkIIF(sType="vi","selected=""selected""","") & " value=""vi"">VIP 베스트</option>" & vbCrLf
	sResult = sResult& "</select>"
	Response.Write sResult
End Sub 

'// 2017 조건선택상자
Sub fnPrntSortNaviver17(sType,sCallback)
	Dim sName, sResult, lp
	if sType="" then sType="be"
	
	sResult = "<select class=""select"" title=""정렬 옵션"" onchange=""" & sCallback & "(this.value);"">" & vbCrLf
	sResult = sResult& "<option " & chkIIF(sType="ne","selected=""selected""","") & " value=""ne"">신규순</option>" & vbCrLf
	sResult = sResult& "<option " & chkIIF(sType="be","selected=""selected""","") & " value=""be"">인기순</option>" & vbCrLf
	sResult = sResult& "<option " & chkIIF(sType="ws","selected=""selected""","") & " value=""ws"">위시등록순</option>" & vbCrLf
	sResult = sResult& "<option " & chkIIF(sType="hs","selected=""selected""","") & " value=""hs"">할인율순</option>" & vbCrLf
	sResult = sResult& "<option " & chkIIF(sType="hp","selected=""selected""","") & " value=""hp"">높은가격순</option>" & vbCrLf
	sResult = sResult& "<option " & chkIIF(sType="lp","selected=""selected""","") & " value=""lp"">낮은가격순</option>" & vbCrLf
	sResult = sResult& "</select>"
	Response.Write sResult
End Sub 

'// 2016 정렬선택 상자 (sType:정렬방법, sUse:사용처 구분, sCallback:콜백함수명)
Sub fnPrntSortNaviV16(sType,sUse,sCallback)
	Dim sName, sResult, lp
	if sType="" then sType="be"

	if sUse="dft" then
		sUse = "abcdef"
	end if

	'// 현재 정렬명
	Select Case sType
		Case "ne": sName = "신규순"
		Case "be": sName = "인기순"
		Case "ws": sName = "위시등록순"
		Case "hs": sName = "할인율순"
		Case "hp": sName = "높은가격순"
		Case "lp": sName = "낮은가격순"
		Case "br": sName = "리뷰등록순"
		Case "pj": sName = "인기포장순"
		Case "rg": sName = "등록순"
		Case "nm": sName = "이름순"
	End Select

	sResult = "<button type=""button"">" & sName & "</button>" & vbCrLf
	sResult = sResult& "	<div class=""sortNaviV16a"">" & vbCrLf
	sResult = sResult& "	<ul>" & vbCrLf

	for lp=1 to len(sUse)
		Select Case mid(sUse,lp,1)
			Case "a":  sResult = sResult& "		<li " & chkIIF(sType="ne","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('ne');return false;"">신규순</a></li>" & vbCrLf
			Case "b":  sResult = sResult& "		<li " & chkIIF(sType="be","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('be');return false;"">인기순</a></li>" & vbCrLf
			Case "c":  sResult = sResult& "		<li " & chkIIF(sType="ws","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('ws');return false;"">위시등록순</a></li>" & vbCrLf
			Case "d":  sResult = sResult& "		<li " & chkIIF(sType="hs","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('hs');return false;"">할인율순</a></li>" & vbCrLf
			Case "e":  sResult = sResult& "		<li " & chkIIF(sType="hp","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('hp');return false;"">높은가격순</a></li>" & vbCrLf
			Case "f":  sResult = sResult& "		<li " & chkIIF(sType="lp","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('lp');return false;"">낮은가격순</a></li>" & vbCrLf
			Case "g":  sResult = sResult& "		<li " & chkIIF(sType="br","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('br');return false;"">리뷰등록순</a></li>" & vbCrLf
			Case "h":  sResult = sResult& "		<li " & chkIIF(sType="pj","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('pj');return false;"">인기포장순</a></li>" & vbCrLf
			Case "i":  sResult = sResult& "		<li " & chkIIF(sType="rg","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('rg');return false;"">등록순</a></li>" & vbCrLf
			Case "j":  sResult = sResult& "		<li " & chkIIF(sType="nm","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('nm');return false;"">이름순</a></li>" & vbCrLf
		End Select
	next

	sResult = sResult& "	</ul>" & vbCrLf
	sResult = sResult& "</div>"
	Response.Write sResult
End Sub

'// 2017 정렬선택 상자 (sType:정렬방법, sUse:사용처 구분, sCallback:콜백함수명)
Sub fnPrntSortNaviV17(sType,sUse,sCallback)
	Dim sName, sResult, lp
	if sType="" then sType="be"

	if sUse="dft" then
		sUse = "abcdef"
	end if

	'// 현재 정렬명
	Select Case sType
		Case "ne": sName = "신규순"
		Case "be": sName = "인기순"
		Case "ws": sName = "위시등록순"
		Case "hs": sName = "할인율순"
		Case "hp": sName = "높은가격순"
		Case "lp": sName = "낮은가격순"
		Case "br": sName = "리뷰등록순"
		Case "pj": sName = "인기포장순"
		Case "rg": sName = "등록순"
		Case "nm": sName = "이름순"
	End Select

	sResult = "<select class=""select"" onchange=""" & sCallback & "(this.value);"" title=""검색결과 리스트 정렬 선택옵션"">" & vbCrLf
'	sResult = "<button type=""button"">" & sName & "</button>" & vbCrLf
'	sResult = sResult& "	<div class=""sortNaviV16a"">" & vbCrLf
'	sResult = sResult& "	<ul>" & vbCrLf

	for lp=1 to len(sUse)
		Select Case mid(sUse,lp,1)
			Case "a":  sResult = sResult& " <option " & chkIIF(sType="ne","selected=""selected""","") & " value=""ne"" >신규순</option>" & vbCrLf
			Case "b":  sResult = sResult& " <option " & chkIIF(sType="be","selected=""selected""","") & " value=""be"" >인기순</option> " & vbCrLf
			Case "c":  sResult = sResult& " <option " & chkIIF(sType="ws","selected=""selected""","") & " value=""ws"" >위시등록순</option> " & vbCrLf
			Case "g":  sResult = sResult& " <option " & chkIIF(sType="br","selected=""selected""","") & " value=""br"" >리뷰등록순</option> " & vbCrLf
			Case "d":  sResult = sResult& " <option " & chkIIF(sType="hs","selected=""selected""","") & " value=""hs"" >할인율순</option> " & vbCrLf
			Case "e":  sResult = sResult& " <option " & chkIIF(sType="hp","selected=""selected""","") & " value=""hp"" >높은가격순</option> " & vbCrLf
			Case "f":  sResult = sResult& " <option " & chkIIF(sType="lp","selected=""selected""","") & " value=""lp"" >낮은가격순</option> " & vbCrLf

'			Case "a":  sResult = sResult& "		<li " & chkIIF(sType="ne","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('ne');return false;"">신규순</a></li>" & vbCrLf
'			Case "b":  sResult = sResult& "		<li " & chkIIF(sType="be","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('be');return false;"">인기순</a></li>" & vbCrLf
'			Case "c":  sResult = sResult& "		<li " & chkIIF(sType="ws","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('ws');return false;"">위시등록순</a></li>" & vbCrLf
'			Case "d":  sResult = sResult& "		<li " & chkIIF(sType="hs","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('hs');return false;"">할인율순</a></li>" & vbCrLf
'			Case "e":  sResult = sResult& "		<li " & chkIIF(sType="hp","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('hp');return false;"">높은가격순</a></li>" & vbCrLf
'			Case "f":  sResult = sResult& "		<li " & chkIIF(sType="lp","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('lp');return false;"">낮은가격순</a></li>" & vbCrLf
'			Case "g":  sResult = sResult& "		<li " & chkIIF(sType="br","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('br');return false;"">리뷰등록순</a></li>" & vbCrLf
'			Case "h":  sResult = sResult& "		<li " & chkIIF(sType="pj","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('pj');return false;"">인기포장순</a></li>" & vbCrLf
'			Case "i":  sResult = sResult& "		<li " & chkIIF(sType="rg","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('rg');return false;"">등록순</a></li>" & vbCrLf
'			Case "j":  sResult = sResult& "		<li " & chkIIF(sType="nm","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('nm');return false;"">이름순</a></li>" & vbCrLf
		End Select
	next

'	sResult = sResult& "	</ul>" & vbCrLf
'	sResult = sResult& "</div>"
	sResult = sResult& "</select> "
	Response.Write sResult
End Sub

'// 카테고리 Histoty 출력(2016 Ver.)
function fnPrnCategoryHistorymultiV16(vCode, vDiv, byRef vCateCnt, vCallBack)
	dim strHistory, strLink, SQL, i, j
	j = (len(vCode)/3)
    
	'히스토리 기본
	if vDiv="A" then
		strHistory = "<em class=""swiper-slide""><a href=""#"" onclick=""" & vCallBack & "(''); return false;"">전체</a></em>"
	end if

	i = 0
	'// 카테고리 이름 접수
	SQL = "SELECT ([db_item].[dbo].[getCateCodeFullDepthName]('" & vCode & "'))"
	rsget.CursorLocation = adUseClient
	rsget.Open SQL, dbget, adOpenForwardOnly, adLockReadOnly  '' 수정.2015/08/12

	if NOT(rsget.EOF or rsget.BOF) then
		If Not(isNull(rsget(0))) Then
			for i = 1 to j
				strHistory = strHistory & "<em class=""swiper-slide""><a href=""#"" onclick=""" & vCallBack & "('" &  Left(vCode,(3*i)) & "'); return false;"">"
				strHistory = strHistory & Split(db2html(rsget(0)),"^^")(i-1)
				
				If i=j Then strHistory = strHistory & " ()" End If

				strHistory = strHistory & "</a></em>"
			next
		End If
	end if
	
	rsget.Close
	vCateCnt = i
	
	fnPrnCategoryHistorymultiV16 = strHistory
end Function

'// 카테고리 Histoty 출력(2017 Ver.)
function fnPrnCategoryHistorymultiV17(vCode, vDiv, byRef vCateCnt, vCallBack)
	dim strHistory, strLink, SQL, i, j
	Dim amplitudeMoveCatecorydepth, amplitudemoveaction
	j = (len(vCode)/3)
    
	'히스토리 기본
	if vDiv="A" then
		strHistory = "<em class=""swiper-slide""><a href=""#"" onclick=""" & vCallBack & "(''); return false;"">전체</a></em>"
	end if

	i = 0
	'// 카테고리 이름 접수
	SQL = "SELECT ([db_item].[dbo].[getCateCodeFullDepthName]('" & vCode & "'))"
	rsget.CursorLocation = adUseClient
	rsget.Open SQL, dbget, adOpenForwardOnly, adLockReadOnly  '' 수정.2015/08/12

	if NOT(rsget.EOF or rsget.BOF) then
		If Not(isNull(rsget(0))) Then
			for i = 1 to j

				amplitudeMoveCatecorydepth = Len(Left(vCode,(3*i)))/3
				If Len(Left(vCode,(3*i)))/3 > j Then
					amplitudemoveaction = "down"
				ElseIf Len(Left(vCode,(3*i)))/3 = j Then
					amplitudemoveaction = "same"
				ElseIf Len(Left(vCode,(3*i)))/3 < j Then
					amplitudemoveaction = "up"
				End If

				If InStr(LCase(trim(request.Servervariables("HTTP_url"))), "/street/street_brand") > 0 Then
					strHistory = strHistory & "<li class=""swiper-slide""><a href=""#"" onclick=""" & vCallBack & "('" &  Left(vCode,(3*i)) & "'); fnAmplitudeEventMultiPropertiesAction('click_brand_productlist_depth', 'brand_id|category_code|category_depth|move_category_code|move_category_depth|move', '"&makerid&"|"&vCode&"|"&j&"|"&Left(vCode,(3*i))&"|"&amplitudeMoveCatecorydepth&"|"&amplitudemoveaction&"'); return false;"">"
				Else
					strHistory = strHistory & "<li class=""swiper-slide""><a href=""#"" onclick=""" & vCallBack & "('" &  Left(vCode,(3*i)) & "'); fnAmplitudeEventMultiPropertiesAction('click_category_productlist_depth', 'category_code|category_depth|move_category_code|move_category_depth|move', '"&vCode&"|"&j&"|"&Left(vCode,(3*i))&"|"&amplitudeMoveCatecorydepth&"|"&amplitudemoveaction&"'); return false;"">"
				End If
				strHistory = strHistory & Split(db2html(rsget(0)),"^^")(i-1)
				
'				If i=j Then strHistory = strHistory & " ()" End If

				strHistory = strHistory & "</a></li>"
			next
		End If
	end if
	
	rsget.Close
	vCateCnt = i
	
	fnPrnCategoryHistorymultiV17 = strHistory
end Function

Function getSuperCoolFestivalItemExists(itemid)
	dim strSql

	strSql = "SELECT TOP 1  itemid FROM  [db_event].[dbo].[tbl_eventitem] WHERE  evt_code in (78707) and itemid=" & CStr(itemid)
	rsget.open strSql, dbget
	If Not rsget.EOF Then
		getSuperCoolFestivalItemExists 	= true
	ELSE
		getSuperCoolFestivalItemExists 	= false
	End if
	rsget.close
End Function

'// 안전인증
function fnSafetyDivCodeName(c)
	dim r
	select case c
		case "10" : r = "전기용품 > 안전인증"
		case "20" : r = "전기용품 > 안전확인 신고"
		case "30" : r = "전기용품 > 공급자 적합성 확인"
		case "40" : r = "생활제품 > 안전인증"
		case "50" : r = "생활제품 > 안전확인"
		case "60" : r = "생활제품 > 공급자 적합성 확인"
		case "70" : r = "어린이제품 > 안전인증"
		case "80" : r = "어린이제품 > 안전확인"
		case "90" : r = "어린이제품 > 공급자 적합성 확인"
	end select
	fnSafetyDivCodeName = r
end function
%>