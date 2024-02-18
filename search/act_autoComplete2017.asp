<%@  codepage="65001" language="VBScript" %>
<%
option Explicit
Response.Buffer = True
Response.CharSet = "utf-8"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<%
	dim Docruzer, seed_str, searchviewType

	'검색어 접수	
	seed_str = Request("str")

	'Amplitude용 데이터
	If InStr(LCase(request.servervariables("HTTP_REFERER")), "search/search_item") > 0 Then
		searchviewType = "search_result"
	Else
		searchviewType = "search_main"
	End If

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
    		Call doMain(seed_str)
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
	Sub doMain(seed_str)
		Dim SvrAddr, SvrPort
		Dim ret, i, nFlag, cnv_str, max_count
		Dim kwd_count, kwd_list
		Dim rank, meta1, meta2
		Dim objXML, objXMLv

		IF application("Svr_Info")	= "Dev" THEN
		    ''SvrAddr = "110.93.128.108"''2차실서버
			SvrAddr = "192.168.50.10"'DocSvrAddr(테섭)
			'SvrAddr = "110.93.128.106"
		ELSE
			''SvrAddr = "192.168.0.109"'DocSvrAddr(실섭)
			SvrAddr = "192.168.0.206" ''"192.168.0.206"
			'SvrAddr = "110.93.128.106"
		END IF

		if (Application("G_ORGSCH_ADDR")="") then
			Application("G_ORGSCH_ADDR")=SvrAddr
		end if

		SvrAddr = Application("G_ORGSCH_ADDR")
		
		SvrPort = "6167"			'DocSvrPort

		nFlag = 2		'검색방법 (0:앞부터, 1: 뒤부터, 2:앞or뒤)
		cnv_str = ""	'한영자동변환 결과
		max_count = 100	'최대 검색 수

		'자동완성 검색
		ret = Docruzer.CompleteKeyword2( _
					SvrAddr & ":" & SvrPort _
					,kwd_count, kwd_list, rank, meta1, meta2, cnv_str, max_count, seed_str, nFlag, 5)
			
		'에러 출력
		if(ret<0) then
			Response.Write "Error: " & Docruzer.GetErrorMessage()
			exit Sub
		end if

			'----- XML 컨퍼넌트 선언
			Set objXML = server.CreateObject("Microsoft.XMLDOM")
			objXML.async = False

			'----- XML 해더 생성
			objXML.appendChild(objXML.createProcessingInstruction("xml","version=""1.0"""))
			objXML.appendChild(objXML.createElement("categoryPage"))
			
			'-----프로세스 시작
			for i=0 to kwd_count-1
				Set objXMLv = objXML.createElement("item")
				
				objXMLv.appendChild(objXML.createElement("No"))
				objXMLv.appendChild(objXML.createElement("Flag"))
				objXMLv.appendChild(objXML.createElement("Word"))
				objXMLv.appendChild(objXML.createElement("Seed"))
				objXMLv.appendChild(objXML.createElement("Conv"))
				objXMLv.appendChild(objXML.createElement("meta1"))
				objXMLv.appendChild(objXML.createElement("meta2"))
				objXMLv.appendChild(objXML.createElement("searchviewType"))
				
				objXMLv.childNodes(0).text = i
				objXMLv.childNodes(1).text = nFlag
				objXMLv.childNodes(2).text = kwd_list(i)
				objXMLv.childNodes(3).text = seed_str
				if cnv_str<>"" then
					'objXMLv.childNodes(4).text = cnv_str
					objXMLv.childNodes(4).text = "null"  ''search4에서 변경되었음.
				else
					objXMLv.childNodes(4).text = "null"
				end if
				objXMLv.childNodes(5).text = meta1(i)
				objXMLv.childNodes(6).text = meta2(i)
				objXMLv.childNodes(7).text = searchviewType
				
				objXML.documentElement.appendChild(objXMLv.cloneNode(True))
				Set objXMLv = Nothing
			next

			'----- 생성된 내용 출력
			Response.ContentType = "text/xml"
			Response.Write(objXML.xml)
			
			'-----객체 해제
			Set objXML = Nothing

			Set kwd_list = Nothing
	end Sub
%>