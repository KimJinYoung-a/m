<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
'#######################################################
' PageName : mainLoader.asp
' Discription : 사이트 메인 템플릿 XML파일 로더
'     1. 지정된 날짜의 템플릿 목록을 읽음
'     2. 서브내용에 맞는 템플릿형태를 호출하여 출력
' History : 2013.04.05 허진원 : 신규 생성
'#######################################################

'// 변수 선언
	Dim selDate, sMainXmlUrl, oFile, fileCont, xmlDOM, fso
	Dim sFolder, mainFile
	Dim mainIdx, mainTitle, mainTitleYn, mainUseTime, mainIconCd, mainExtCd, mainModiDate, mainSdt, mainEdt, mainPreOpen, selFullTime, strTime
	Dim chkPrint, chkBlind, i, chkSort
	Dim strPrintRst

	selDate = getNumeric(requestCheckVar(Request("seldt"),8))

	'날짜 확인(오늘기준으로 7일전부터 2일뒤까지; 기간 총 10일)
	if selDate="" or len(selDate)<>8 then selDate = replace(date,"-","")
	if selDate<replace(dateadd("d",-7,date),"-","") or selDate>replace(dateadd("d",2,date),"-","") then
		selDate = replace(date,"-","")
	end if

	sFolder = "/chtml/main/xml/" & selDate & "/"
	mainFile = "main_list.xml"

	'// 파일 존재유무 확인
	Set fso = CreateObject("Scripting.FileSystemObject")
	if not(fso.FileExists(server.MapPath(sFolder & mainFile))) then
		'파일이 없으면 오늘날짜(오늘자가 없다면 종료)!
		if selDate<>replace(date,"-","") then
			''Response.Write "<script>self.location.href='?seldt=" & replace(date,"-","") & "';</script>"
			Response.Write "<script>self.location.reload();</script>"
		end if
		Response.End
	end if
	set fso = Nothing

	'// 메인페이지를 구성하는 XML로딩 (파일직접로딩)
	sMainXmlUrl = server.MapPath(sFolder & mainFile)	'// 접수 파일
	Set oFile = CreateObject("ADODB.Stream")
	With oFile
		.Charset = "UTF-8"
		.Type=2
		.mode=3
		.Open
		.loadfromfile sMainXmlUrl
		fileCont=.readtext
		.Close
	End With
	Set oFile = Nothing

	If fileCont<>"" Then
		
		'// XML 파싱
		Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
		xmlDOM.async = False
		xmlDOM.LoadXML fileCont

		'// 하위 항목이 여러개일 때
		Dim cTmpl, tplNodes, cSub, subNodes, tmpOrder
		Set cTmpl = xmlDOM.getElementsByTagName("item")

		Set xmlDOM = Nothing
		tmpOrder = 1

		'설정시간 지정
		if selDate=replace(date,"-","") then
			selFullTime = now
		else
			selFullTime = DateSerial(left(selDate,4),mid(selDate,5,2),right(selDate,2))
		end if

		for each tplNodes in cTmpl
			'변수 저장
			mainIdx			= tplNodes.getElementsByTagName("idx").item(0).text
			mainTitle		= tplNodes.getElementsByTagName("title").item(0).text
			mainTitleYn		= tplNodes.getElementsByTagName("useTitle").item(0).text
			mainUseTime		= tplNodes.getElementsByTagName("useTime").item(0).text
			mainIconCd		= tplNodes.getElementsByTagName("iconCd").item(0).text
			mainExtCd		= tplNodes.getElementsByTagName("extCd").item(0).text
			mainModiDate	= tplNodes.getElementsByTagName("modiDate").item(0).text
			mainSdt			= cDate(tplNodes.getElementsByTagName("startdate").item(0).text)
			mainEdt			= cDate(tplNodes.getElementsByTagName("enddate").item(0).text)
			mainPreOpen		= tplNodes.getElementsByTagName("preOpen").item(0).text

			chkPrint		= false		'출력여부
			
			'블라인드 여부 (내일자선택 시 시작전 이벤트)
			if selDate>replace(date,"-","") and mainSdt>date then
				chkBlind = true
			else
				chkBlind = false
			end if

			'타임라인 시간 표시
			strTime = ""
			if dateDiff("d",selFullTime,mainModiDate)=0 and mainUseTime="Y" then
				strTime = Num2Str(chkIIF(hour(mainModiDate)>12,hour(mainModiDate)-12,hour(mainModiDate)),2,"0","R") & ":" & Num2Str(minute(mainModiDate),2,"0","R") & " " & chkIIF(hour(mainModiDate)>=12,"PM","AM")
			end if

			'노출시간 및 선노출 확인
			if selFullTime>=mainSdt and selFullTime<=mainEdt then chkPrint=true
			if datediff("d",date,selFullTime)>0 and mainPreOpen="N" then chkPrint=false

			if chkPrint then
				'템플릿별 분기
				Select Case tplNodes.getElementsByTagName("template").item(0).text
					Case "1"
						'[A] 키워드 이슈 #1 (복합)
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_1.asp" -->
					<%
					Case "2"
						'[A] 키워드 이슈 #2 (이미지형)
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_2.asp" -->
					<%
					Case "3"
						'[C] 이벤트 배너 (단수형)
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_3.asp" -->
					<%
					Case "15"
						'[C] 이벤트 배너 (복수형)
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_15.asp" -->
					<%
					Case "16"
						'[C] 이벤트 배너 (소형)
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_16.asp" -->
					<%
					Case "4"
						'[D] 할인 및 신상품 #1 (큰사이즈)
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_4.asp" -->
					<%
					Case "5"
						'[D] 할인 및 신상품 #2 (작은사이즈)
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_5.asp" -->
					<%
					Case "6"
						'[E] 베스트 어워드
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_award.asp" -->
					<%
					Case "12"
						'[E] 디자인 핑거스
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_fingers.asp" -->
					<%
					Case "7"
						'[E] 저스트 원데이
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_just1day.asp" -->
					<%
					Case "8"
						'[F] 이벤트 + 상품
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_8.asp" -->
					<%
					Case "9"
						'[D] 실시간 추천상품 (작은사이즈)
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_9.asp" -->
					<%
					Case "13"
						'[D] 실시간 추천상품 (큰사이즈)
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_13.asp" -->
					<%
					Case "14"
						'[E] 핑거스+컬쳐+컬러 3단탭
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_14_3Tab.asp" -->
					<%
					Case "10"
						'[G] 동영상 이벤트
					%>
					<!-- #include virtual="/chtml/main/template/inc_tpl_10.asp" -->
					<%
				End Select

				tmpOrder = tmpOrder+1
			end if
		Next
		Set cTmpl = Nothing
		
	end if

	'//컬러코드명 반환
	Function getTabColorCode(ccd)
		Dim arrCNm
		if ccd<>"" then
			arrCNm = split("WINE,RED,ORANGE,BROWN,CAMEL,YELLOW,BEGDE,IVORY,KHAKI,GREEN,MINT,SKY BLUE,BLUE,NAVY,VIOLET,LILAC,BABY PINK,PINK,WHITE,GRAY,CHARCOAL,BLACK,SILVER,GOLD,CHECK,STRIPE,DOT,FLOWER,DRAWING,ANIMAL,GEOMETRIC",",")
			getTabColorCode = arrCNm(ccd)
		end if
	End function
%>