<%
	dim Docruzer, seed_str, vResultWord
	'검색어 접수	
	seed_str = SearchText
	
	'독크루저 컨퍼넌트 선언
	SET Docruzer = Server.CreateObject("ATLKSearch.Client")
	
	if Docruzer.BeginSession()<0 then
		'에러시 메세지 표시
		Response.Write "BeginSession: " & Docruzer.GetErrorMessage()
	else
	    IF NOT DocSetOption(Docruzer) THEN
			Response.Write "SetOption: " & Docruzer.GetErrorMessage()
		ELSE
    		'실행
    		Call doMain(seed_str, vResultWord)
    		Call Docruzer.EndSession()
    	End if
	end if
	
	'독크루저 종료
	Set Docruzer = Nothing
    
    public function DocSetOption(iDocruzer)
        dim ret 
        ret = iDocruzer.SetOption(iDocruzer.OPTION_REQUEST_CHARSET_UTF8,1)
        DocSetOption = (ret>=0)
    end function
    
	'메인실행 함수
	Sub doMain(seed_str, vResultWord)
		Dim SvrAddr, SvrPort
		Dim ret, i, nFlag, cnv_str, max_count
		Dim kwd_count, result_word
		Dim objXML, objXMLv

		IF application("Svr_Info")	= "Dev" THEN
		    ''SvrAddr = "110.93.128.108"''2차실서버
			SvrAddr = "192.168.50.10"'DocSvrAddr(테섭)
			'SvrAddr = "110.93.128.106"
		ELSE
			''SvrAddr = "192.168.0.109"'DocSvrAddr(실섭)
			SvrAddr = "192.168.0.206"
			'SvrAddr = "110.93.128.106"
		END IF

		if (Application("G_ORGSCH_ADDR")="") then
			Application("G_ORGSCH_ADDR")=SvrAddr
		end if

		SvrAddr = Application("G_ORGSCH_ADDR")
		
		SvrPort = "6167"			'DocSvrPort

		max_count = 1	'최대 검색 수

		'대체 검색
		ret = Docruzer.SpellCheck( _
					SvrAddr & ":" & SvrPort _
					,kwd_count, result_word, max_count, seed_str)
'Response.Write "check: " & kwd_count
		'에러 출력
		if(ret<0) then
			Response.Write "Error: " & Docruzer.GetErrorMessage()
			exit Sub
		end if

			'-----프로세스 시작
			for i=0 to kwd_count-1
				vResultWord = result_word(i)
			next
	end Sub
	
If vResultWord <> "" Then
%>
<div class="search-replace">
	<div class="bg" <%=vSScrnMasking%>></div>'
	<div class="inner">
		<p>혹시 <strong><%=vResultWord%></strong> 찾으셨나요?</p>
		<div class="btn-group">
			<a href="/search/search_item.asp?rect=<%=vResultWord%>" onclick=fnAmplitudeEventMultiPropertiesAction('click_search','action|keyword|searchkeyword|view','replacement|<%=Replace(seed_str," ","")%>|<%=Replace(vResultWord," ","")%>|search_result'); class="btn-flat"><%=vResultWord%> 검색결과 보기</a>
		</div>
	</div>
</div>
<% End If %>