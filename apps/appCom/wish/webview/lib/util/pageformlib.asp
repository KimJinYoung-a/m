<%
'=========================================================
' 2011 New 페이징 함수 
' 2011.03.21 강준구 생성
' 2012.03.26 허진원 DIV레이아웃으로 변경
' 2014.02.04 허진원 Wish APP 디자인 변경
' ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' sbDisplayPaging_New(현재 페이지번호, 총 레코드 갯수, 한페이지에 보이는 상품 갯수(select top 수), 페이지 블록단위(ex.10페이지씩보기 or 5페이지씩 보기), js 페이지이동 함수명)
' ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' 페이지 이동 js 함수명은 strJsFuncName 으로 임의로 정하고 페이지 번호만 담아서 넘김. 각 페이지에 페이징 전용 form을 만들거나 서칭폼을 같이 쓰거나 하여 post 또는 get으로 넘김.
' 각 페이지의 다양한 성격들로 인해 여러 자동 기능은 빼고 모든 환경에 공통적인 부분만 넣음.
' 사용페이지: 중소카테고리리스트(/shopping/category_list.asp), 디자인핑거스(/designfingers/designfingers_main.asp, /designfingers/designfingers.asp)(ajax제외), 브랜드메인(/street/street_main.asp), 이벤트, 위클리코드
'=========================================================

Function fnDisplayPaging_New(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName)
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
	
	vPageBody = vPageBody & "<div class=""pagination"">" & vbCrLf
	
	'## 이전 페이지
	If intStartBlock > 1 Then
		vPageBody = vPageBody & "			<a href="""" onclick=""" & strJsFuncName & "(" & intStartBlock -1 & ");return false;"" class=""btn-prev"">&lt;</a>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<a href="""" onclick=""return false;"" class=""btn-prev"">&lt;</a>" & vbCrLf
	End If

	'## 현재 페이지
	If intTotalPage > 1 Then
		For intLoop = intStartBlock To intEndBlock
			If intLoop > intTotalPage Then Exit For
			If Int(intLoop) = Int(intCurrentPage) Then
				vPageBody = vPageBody & "			<a href="""" onclick=""" & strJsFuncName & "(" & intLoop & ");return false;"" class=""current"">" & intLoop & "</a>" & vbCrLf
			Else
				vPageBody = vPageBody & "			<a href="""" onclick=""" & strJsFuncName & "(" & intLoop & ");return false;"">" & intLoop & "</a>" & vbCrLf
			End If
		Next
	Else
		vPageBody = vPageBody & "			<a href="""" onclick=""" & strJsFuncName & "(1);return false;""  class=""current"">1</a>" & vbCrLf
	End If
	
	'## 다음 페이지
	If Int(intEndBlock) < Int(intTotalPage) Then	'####### 다음페이지
		vPageBody = vPageBody & "			<a href="""" onclick=""" & strJsFuncName & "(" & intEndBlock+1 & ");return false;"" class=""btn-next"">&gt;</a>" & vbCrLf
	Else
		vPageBody = vPageBody & "			<a href="""" onclick=""return false;"" class=""btn-next"">&gt;</a>" & vbCrLf
	End If
	
	vPageBody = vPageBody & "</div>" & vbCrLf
	
	fnDisplayPaging_New = vPageBody
	
End Function
%>
