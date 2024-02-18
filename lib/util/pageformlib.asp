<%
'=========================================================
' 2011 New 페이징 함수 
' 2011.03.21 강준구 생성
' 2012.03.26 허진원 DIV레이아웃으로 변경
' ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' sbDisplayPaging_New(현재 페이지번호, 총 레코드 갯수, 한페이지에 보이는 상품 갯수(select top 수), 페이지 블록단위(ex.10페이지씩보기 or 5페이지씩 보기), js 페이지이동 함수명)
' ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' 페이지 이동 js 함수명은 strJsFuncName 으로 임의로 정하고 페이지 번호만 담아서 넘김. 각 페이지에 페이징 전용 form을 만들거나 서칭폼을 같이 쓰거나 하여 post 또는 get으로 넘김.
' 각 페이지의 다양한 성격들로 인해 여러 자동 기능은 빼고 모든 환경에 공통적인 부분만 넣음.
' 사용페이지: 중소카테고리리스트(/shopping/category_list.asp), 디자인핑거스(/designfingers/designfingers_main.asp, /designfingers/designfingers.asp)(ajax제외), 브랜드메인(/street/street_main.asp), 이벤트, 위클리코드
'=========================================================

Function fnDisplayPaging_New_OLD(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName)

	'변수 선언
	Dim intCurrentPage, strCurrentPath, vPageBody
	Dim intStartBlock, intEndBlock, intTotalPage
	Dim strParamName, intLoop

	'현재 페이지 설정
	intCurrentPage = strCurrentPage		'현재 페이지 값
	
	'해당페이지에 표시되는 시작페이지와 마지막페이지 설정
	intStartBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + 1
	intEndBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + intBlockPerPage
	
	'총 페이지 수 설정
	intTotalPage =   int((intTotalRecord-1)/intRecordPerPage) +1 
	''eastone 추가
	if (intTotalPage<1) then intTotalPage=1     
	
	vPageBody = ""
	
	vPageBody = vPageBody & "<div class=""paging pagingV15a"">" & vbCrLf
	
	'## 이전 페이지
	If intStartBlock > 1 Then
		vPageBody = vPageBody & "			<span class=""arrow prevBtn""><a href=""javascript:" & strJsFuncName & "(" & intStartBlock -1 & ")"">prev</a></span>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<span class=""arrow prevBtn""><a href=""javascript:"">prev</a></span>" & vbCrLf
	End If

	'## 현재 페이지
	If intTotalPage > 1 Then
		For intLoop = intStartBlock To intEndBlock
			If intLoop > intTotalPage Then Exit For
			If Int(intLoop) = Int(intCurrentPage) Then
				vPageBody = vPageBody & "			<span class=""current""><a href=""javascript:" & strJsFuncName & "(" & intLoop & ")"">" & intLoop & "</a></span>" & vbCrLf
			Else
				vPageBody = vPageBody & "			<span><a href=""javascript:" & strJsFuncName & "(" & intLoop & ")"">" & intLoop & "</a></span>" & vbCrLf
			End If
		Next
	Else
		vPageBody = vPageBody & "			<span class=""current""><a href=""javascript:" & strJsFuncName & "(1)"">1</a></span>" & vbCrLf
	End If
	
	'## 다음 페이지
	If Int(intEndBlock) < Int(intTotalPage) Then	'####### 다음페이지
		vPageBody = vPageBody & "			<span class=""arrow nextBtn""><a href=""javascript:" & strJsFuncName & "(" & intEndBlock+1 & ")"" class=""arrow"">next</a></span>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<span class=""arrow nextBtn""><a href=""javascript:"" class=""arrow"">next</a></span>" & vbCrLf
	End If
	
	vPageBody = vPageBody & "</div>" & vbCrLf
	
	fnDisplayPaging_New_OLD = vPageBody
	
End Function

Function fnDisplayPaging_New(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName)
	intBlockPerPage = 5 '페이징 리뉴얼 이후 모바일은 고정으로 5개 블럭 나옴(기존 4개)

	'변수 선언
	Dim intCurrentPage, strCurrentPath, vPageBody
	Dim intStartBlock, intEndBlock, intTotalPage, intNextPage
	Dim strParamName, intLoop

	'현재 페이지 설정
	intCurrentPage = strCurrentPage		'현재 페이지 값

	'총 페이지 수 설정
	intTotalPage =   int((intTotalRecord-1)/intRecordPerPage) +1

	intNextPage = int(intTotalPage-intCurrentPage)
	
	'해당페이지에 표시되는 시작페이지와 마지막페이지 설정
	if intCurrentPage > 3 then
		if intNextPage > 1 then
			intStartBlock = Int(intCurrentPage-2)
			intEndBlock = Int(intCurrentPage+2)
		elseif intNextPage < 1 then
			intStartBlock = Int(intCurrentPage-4)
			intEndBlock = Int(intCurrentPage+2)
		else
			intStartBlock = Int(intCurrentPage-3)
			intEndBlock = Int(intCurrentPage+2)
		end if
	else
		intStartBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + 1
		intEndBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + intBlockPerPage
	end if

	dim prePgNum
	if intStartBlock > 1 then
		prePgNum = intStartBlock - 1
	else
		prePgNum = 1
	end if
		
	''eastone 추가
	if (intTotalPage<1) then intTotalPage=1
	if intStartBlock < 2 then intStartBlock = 1
	
	vPageBody = ""
	
	vPageBody = vPageBody & "<div class=""paging pagingV15a"">" & vbCrLf
	
	'## 이전 페이지
	If intTotalPage > 5 and intCurrentPage > 3 Then
		vPageBody = vPageBody & "			<span class=""arrow prevBtn""><a href=""javascript:" & strJsFuncName & "(" & prePgNum & ")"">prev</a></span>" & vbCrLf
	End If

	'## 현재 페이지
	If intTotalPage > 1 Then
		For intLoop = intStartBlock To intEndBlock
			If intLoop > intTotalPage Then Exit For
			If Int(intLoop) = Int(intCurrentPage) Then
				vPageBody = vPageBody & "			<span class=""current""><a href=""javascript:" & strJsFuncName & "(" & intLoop & ")"">" & intLoop & "</a></span>" & vbCrLf
			Else
				vPageBody = vPageBody & "			<span><a href=""javascript:" & strJsFuncName & "(" & intLoop & ")"">" & intLoop & "</a></span>" & vbCrLf
			End If
		Next
	Else
		vPageBody = vPageBody & "			<span class=""current""><a href=""javascript:" & strJsFuncName & "(1)"">1</a></span>" & vbCrLf
	End If
	
	'## 다음 페이지
	if intTotalPage > 5 and (intTotalPage-intCurrentPage) > 2 then
		vPageBody = vPageBody & "			<span class=""arrow nextBtn""><a href=""javascript:" & strJsFuncName & "(" & intEndBlock+1 & ")"" class=""arrow"">next</a></span>" & vbCrLf
	End If
	
	vPageBody = vPageBody & "</div>" & vbCrLf
	
	fnDisplayPaging_New = vPageBody
	
End Function


Function fnDisplayPaging_NewSSL(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName)
	'변수 선언
	Dim intCurrentPage, strCurrentPath, vPageBody
	Dim intStartBlock, intEndBlock, intTotalPage
	Dim strParamName, intLoop

	'현재 페이지 설정
	intCurrentPage = strCurrentPage		'현재 페이지 값
	
	'해당페이지에 표시되는 시작페이지와 마지막페이지 설정
	intStartBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + 1
	intEndBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + intBlockPerPage
	
	'총 페이지 수 설정
	intTotalPage =   int((intTotalRecord-1)/intRecordPerPage) +1 
	''eastone 추가
	if (intTotalPage<1) then intTotalPage=1     
	
	vPageBody = ""
	
	vPageBody = vPageBody & "<div class=""pagination cf"">" & vbCrLf
	vPageBody = vPageBody & "	<div class=""center"">" & vbCrLf
	vPageBody = vPageBody & "		<ul class=""cf"">" & vbCrLf

	'## 첫 페이지
	vPageBody = vPageBody & "			<li class=""first""><a href=""javascript:" & strJsFuncName & "(1)"" title=""첫 페이지""><img src=""/fiximage/web2011/category/btn_pageprev02.gif"" /></a></li>" & vbCrLf

	'## 이전 페이지
	If intStartBlock > 1 Then
		vPageBody = vPageBody & "			<li class=""prev""><a href=""javascript:" & strJsFuncName & "(" & intStartBlock -1 & ")"" title=""이전 페이지""><img src=""/fiximage/web2011/category/btn_pageprev01.gif"" /></a></li>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<li class=""prev""><img src=""/fiximage/web2011/category/btn_pageprev01.gif"" /></li>" & vbCrLf
	End If

	'## 현재 페이지
	If intTotalPage > 1 Then
		For intLoop = intStartBlock To intEndBlock
			If intLoop > intTotalPage Then Exit For
			If Int(intLoop) = Int(intCurrentPage) Then
				vPageBody = vPageBody & "			<li class=""number selected""><a href=""javascript:" & strJsFuncName & "(" & intLoop & ")"" title=""" & intLoop & " 페이지"">" & intLoop & "</a></li>" & vbCrLf
			Else
				vPageBody = vPageBody & "			<li class=""number""><a href=""javascript:" & strJsFuncName & "(" & intLoop & ")"" title=""" & intLoop & " 페이지"">" & intLoop & "</a></li>" & vbCrLf
			End If
		Next
	Else
		vPageBody = vPageBody & "			<li class=""number selected""><a href=""javascript:" & strJsFuncName & "(1)"" title=""1 페이지"">1</a></li>" & vbCrLf
	End If
	
	'## 다음 페이지
	If Int(intEndBlock) < Int(intTotalPage) Then	'####### 다음페이지
		vPageBody = vPageBody & "			<li class=""next""><a href=""javascript:" & strJsFuncName & "(" & intEndBlock+1 & ")"" title=""다음 페이지""><img src=""/fiximage/web2011/category/btn_pagenext01.gif"" /></a></li>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<li class=""next""><img src=""/fiximage/web2011/category/btn_pagenext01.gif"" /></li>" & vbCrLf
	End If
	
	'## 마지막 페이지
	vPageBody = vPageBody & "			<li class=""last""><a href=""javascript:" & strJsFuncName & "(" & intTotalPage & ")"" title=""마지막 페이지""><img src=""/fiximage/web2011/category/btn_pagenext02.gif"" /></a></li>" & vbCrLf

	vPageBody = vPageBody & "		</ul>" & vbCrLf
	vPageBody = vPageBody & "	</div>" & vbCrLf
	vPageBody = vPageBody & "</div>" & vbCrLf
	
	fnDisplayPaging_NewSSL = vPageBody
	
End Function

Function fnDisplayPaging_NewEvt(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName , eventId , evtKind)
	intBlockPerPage = 5 '페이징 리뉴얼 이후 모바일은 고정으로 5개 블럭 나옴(기존 4개)

	'변수 선언
	Dim intCurrentPage, strCurrentPath, vPageBody
	Dim intStartBlock, intEndBlock, intTotalPage, intNextPage
	Dim strParamName, intLoop

	'현재 페이지 설정
	intCurrentPage = strCurrentPage		'현재 페이지 값

	'총 페이지 수 설정
	intTotalPage =   int((intTotalRecord-1)/intRecordPerPage) +1

	intNextPage = int(intTotalPage-intCurrentPage)
	
	'해당페이지에 표시되는 시작페이지와 마지막페이지 설정
	if intCurrentPage > 3 then
		if intNextPage > 1 then
			intStartBlock = Int(intCurrentPage-2)
			intEndBlock = Int(intCurrentPage+2)
		elseif intNextPage < 1 then
			intStartBlock = Int(intCurrentPage-4)
			intEndBlock = Int(intCurrentPage+2)
		else
			intStartBlock = Int(intCurrentPage-3)
			intEndBlock = Int(intCurrentPage+2)
		end if
	else
		intStartBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + 1
		intEndBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + intBlockPerPage
	end if

	dim prePgNum
	if intStartBlock > 1 then
		prePgNum = intStartBlock - 1
	else
		prePgNum = 1
	end if
		
	''eastone 추가
	if (intTotalPage<1) then intTotalPage=1
	if intStartBlock < 2 then intStartBlock = 1
	
	vPageBody = ""
	
	vPageBody = vPageBody & "<div class=""paging pagingV15a"">" & vbCrLf
	
	'## 이전 페이지
	If intTotalPage > 5 and intCurrentPage > 3 Then
		vPageBody = vPageBody & "			<span class=""arrow prevBtn""><a href=""javascript:" & strJsFuncName & "(" & prePgNum & ","& eventId &","& evtKind &")"">prev</a></span>" & vbCrLf
	End If

	'## 현재 페이지
	If intTotalPage > 1 Then
		For intLoop = intStartBlock To intEndBlock
			If intLoop > intTotalPage Then Exit For
			If Int(intLoop) = Int(intCurrentPage) Then
				vPageBody = vPageBody & "			<span class=""current""><a href=""javascript:" & strJsFuncName & "("& intLoop &","& eventId &","& evtKind &")"">" & intLoop & "</a></span>" & vbCrLf
			Else
				vPageBody = vPageBody & "			<span><a href=""javascript:" & strJsFuncName & "("& intLoop &","& eventId &","& evtKind &")"">" & intLoop & "</a></span>" & vbCrLf
			End If
		Next
	Else
		vPageBody = vPageBody & "			<span class=""current""><a href=""javascript:" & strJsFuncName & "(1,"& eventId &","& evtKind &")"">1</a></span>" & vbCrLf
	End If
	
	'## 다음 페이지
	if intTotalPage > 5 and (intTotalPage-intCurrentPage) > 2 then
		vPageBody = vPageBody & "			<span class=""arrow nextBtn""><a href=""javascript:" & strJsFuncName & "("& intEndBlock+1 &","& eventId &","& evtKind &")"" class=""arrow"">next</a></span>" & vbCrLf
	End If
	
	vPageBody = vPageBody & "</div>" & vbCrLf
	
	fnDisplayPaging_NewEvt = vPageBody
	
End Function
%>
