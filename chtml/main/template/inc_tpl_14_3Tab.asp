<%
	'// [E Type] 핑거스+컬쳐+컬러 3단탭

	'현재시각 표시 없음
	strTime = ""

	'출력 결과값 초기화
	strPrintRst = ""

	'표시 우선순위 초기화
	chkSort = 0

	'// 항목 시작
	strPrintRst = "<div class=""" & chkIIF((tmpOrder mod 2)=1,"timelineRt","timelineLt") & """>" & vbCrLf
	strPrintRst = strPrintRst & "	<section>" & vbCrLf

	'// 타이틀/시간 라인
	if mainTitleYn="Y" then
		strPrintRst = strPrintRst & "		<h2>" & vbCrLf
		strPrintRst = strPrintRst & "			<p class=""tit""><span class=""box1 bgWt rdBox2 inner"">" & mainTitle & "</span><em class=""elmBg""></em></p>" & vbCrLf
		strPrintRst = strPrintRst & "			<p class=""time""><span>" & strTime & "</span></p>" & vbCrLf
		strPrintRst = strPrintRst & "		</h2>" & vbCrLf
		strPrintRst = strPrintRst & "		<div class=""box1 bgWt tMar10"">" & vbCrLf
	else
		strPrintRst = strPrintRst & "		<div class=""box1 bgWt"">" & vbCrLf
	end if

	'// 브라인드 처리
	if chkBlind then
		strPrintRst = strPrintRst & "		<div class=""blindWrap""><div><span></span></div></div>" & vbCrLf
	end if

	'// 탭
	strPrintRst = strPrintRst & "			<div class=""templateK"">" & vbCrLf
	strPrintRst = strPrintRst & "				<ul class=""tabs"">" & vbCrLf
	strPrintRst = strPrintRst & "					<li><a href=""#tab01"" class=""tab01""><span>Design Fingers</span></a></li>" & vbCrLf
	strPrintRst = strPrintRst & "					<li><a href=""#tab02"" class=""tab02""><span>Culture Station</span></a></li>" & vbCrLf
	strPrintRst = strPrintRst & "					<li><a href=""#tab03"" class=""tab03""><span>Color Trend</span></a></li>" & vbCrLf
	strPrintRst = strPrintRst & "				</ul>" & vbCrLf

	'-----------------------------------------
	'-- 핑거스 파일 오픈
	'-----------------------------------------

	'# 파일이 없거나 존재하더라도 하루에 한번 신규 XML 생성!!(로드밸런싱 1차 서버에서만, 1시간에 한번 생성)
	''Application("chk_main_fingers_update")="2008-12-12 05:00:00"
	if (application("Svr_Info")="137" or application("Svr_Info")="082" or application("Svr_Info")="Dev") then
		Set fso = CreateObject("Scripting.FileSystemObject")
		if not(fso.FileExists(server.MapPath(sFolder & "sub_fingers.xml"))) or dateDiff("h",Application("chk_main_fingers_update"),now())>1 then
			Server.Execute("/chtml/make_main_fingersXML.asp")
			if selDate=replace(date,"-","") then
				Application("chk_main_fingers_update")=now
			end if
		end if
		set fso = Nothing
	end if

	on Error Resume Next
	fileCont = ""
	'서브 파일 로드
	sMainXmlUrl = server.MapPath(sFolder & "sub_fingers.xml")	'// 접수 파일
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
	on Error Goto 0

	If fileCont<>"" Then
		'// XML 파싱
		Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
		xmlDOM.async = False
		xmlDOM.LoadXML fileCont

		'// 하위 항목이 여러개일 때
		Set cSub = xmlDOM.getElementsByTagName("item")
		Set xmlDOM = Nothing

		i = 1
		for each subNodes in cSub

			strPrintRst = strPrintRst & "				<div id=""tab01"" class=""tabCont fingers"">" & vbCrLf
			strPrintRst = strPrintRst & "					<a href=""/designfingers/fingers.asp?fingerid=" & subNodes.getElementsByTagName("fid").item(0).text & "&sort=1"">" & vbCrLf
			strPrintRst = strPrintRst & "					<div class=""ftLt txtP"">" & vbCrLf
			strPrintRst = strPrintRst & "						<p class=""contit tPad10""><img src=""http://fiximage.10x10.co.kr/m/2013/main/fingers_contit.png"" alt=""매주 2회의 새로운 즐거움 - Design fingers"" style=""width:128px"" /></p>" & vbCrLf
			strPrintRst = strPrintRst & "						<p class=""despTxt tPad10"">" & Replace(subNodes.getElementsByTagName("title").item(0).text,"""","") & "</p>" & vbCrLf
			strPrintRst = strPrintRst & "					</div>" & vbCrLf
			strPrintRst = strPrintRst & "					<p class=""ftRt""><img src=""" & subNodes.getElementsByTagName("image").item(0).text & """ alt=""" & Replace(subNodes.getElementsByTagName("title").item(0).text,"""","") & """ style=""width:120px;"" /></p>" & vbCrLf
			strPrintRst = strPrintRst & "					</a>" & vbCrLf
			strPrintRst = strPrintRst & "				</div>" & vbCrLf

			i=i+1
			if i>1 then Exit For
		next

		Set cSub = Nothing
	end if


	'-----------------------------------------
	'-- 컬쳐스테이션 및 컬러트렌드 파일 오픈
	'-----------------------------------------

	on Error Resume Next
	fileCont = ""
	'서브 파일 로드
	sMainXmlUrl = server.MapPath(sFolder & "sub_" & mainIdx & ".xml")	'// 접수 파일
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
	on Error Goto 0

	If fileCont<>"" Then
		'// XML 파싱
		Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
		xmlDOM.async = False
		xmlDOM.LoadXML fileCont

		'// 하위 항목이 여러개일 때
		Set cSub = xmlDOM.getElementsByTagName("item")
		Set xmlDOM = Nothing

		i = 1
		for each subNodes in cSub
			'컬쳐 스테이션 (이미지가 있는 경우)
			if subNodes.getElementsByTagName("image1").item(0).text<>"" then

				strPrintRst = strPrintRst & "				<div id=""tab02"" class=""tabCont culture"">" & vbCrLf
				strPrintRst = strPrintRst & "					<a href=""" & subNodes.getElementsByTagName("link").item(0).text & """>" & vbCrLf
				strPrintRst = strPrintRst & "					<div class=""ftLt txtP"">" & vbCrLf
				strPrintRst = strPrintRst & "						<p class=""contit tPad10""><img src=""http://fiximage.10x10.co.kr/m/2013/main/culture_contit.png"" alt=""매주 2회의 새로운 즐거움 - Design fingers"" style=""width:128px"" /></p>" & vbCrLf
				strPrintRst = strPrintRst & "						<p class=""despTxt tPad10"">" & subNodes.getElementsByTagName("text1").item(0).text & "</p>" & vbCrLf
				strPrintRst = strPrintRst & "					</div>" & vbCrLf
				strPrintRst = strPrintRst & "					<p class=""ftRt""><img src=""" & subNodes.getElementsByTagName("image1").item(0).text & """ alt=""" & subNodes.getElementsByTagName("imgdesc").item(0).text & """ style=""width:120px;"" /></p>" & vbCrLf
				strPrintRst = strPrintRst & "					</a>" & vbCrLf
				strPrintRst = strPrintRst & "				</div>" & vbCrLf

				i=i+1

				if subNodes.getElementsByTagName("sortno").length then
					if subNodes.getElementsByTagName("sortno").item(0).text="1" then
						chkSort = 1
					end if
				end if
			end if

			'컬러 트랜드 (상품코드와 가격정보가 있는 경우)
			if subNodes.getElementsByTagName("itemid").item(0).text<>"" and subNodes.getElementsByTagName("orgPrice").item(0).text<>"" then
                if isNumeric(subNodes.getElementsByTagName("text1").item(0).text) then  ''2013/07/15 서동석추가
    				strPrintRst = strPrintRst & "				<div id=""tab03"" class=""tabCont colorT"">" & vbCrLf
    				strPrintRst = strPrintRst & "					<a href=""" & subNodes.getElementsByTagName("link").item(0).text & """>" & vbCrLf
    				strPrintRst = strPrintRst & "					<div class=""ftLt txtP"">" & vbCrLf
    				strPrintRst = strPrintRst & "						<p class=""contit tPad10""><img src=""http://fiximage.10x10.co.kr/m/2013/main/color_contit" & Num2Str(subNodes.getElementsByTagName("text1").item(0).text+1,2,"0","R") & ".png"" alt=""어떤 컬러를 좋아하시나요? - Color Trend"" style=""width:120px"" /></p>" & vbCrLf
    				strPrintRst = strPrintRst & "						<p class=""despTxt tPad10"">" & getTabColorCode(subNodes.getElementsByTagName("text1").item(0).text) & "</p>" & vbCrLf
    				strPrintRst = strPrintRst & "					</div>" & vbCrLf
    				strPrintRst = strPrintRst & "					<p class=""ftRt""><img src=""" & subNodes.getElementsByTagName("itemImg200").item(0).text & """ alt=""" & replace(subNodes.getElementsByTagName("itemname").item(0).text,"""","") & """ style=""width:120px;"" /></p>" & vbCrLf
    				strPrintRst = strPrintRst & "					</a>" & vbCrLf
    				strPrintRst = strPrintRst & "				</div>" & vbCrLf
                end if
				i=i+1

				if subNodes.getElementsByTagName("sortno").length then
					if subNodes.getElementsByTagName("sortno").item(0).text="1" then
						chkSort = 2
					end if
				end if
			end if

			if i>2 then Exit For
		next

		Set cSub = Nothing
	end if


	'// 항목 끝
	strPrintRst = strPrintRst & "			</div>" & vbCrLf
	strPrintRst = strPrintRst & "		</div>" & vbCrLf
	strPrintRst = strPrintRst & "	</section>" & vbCrLf
	strPrintRst = strPrintRst & "</div>" & vbCrLf
	strPrintRst = strPrintRst & "<hr />" & vbCrLf

	'// 결과 출력
	if i>2 then
		Response.Write strPrintRst
%>
	<script type="text/javascript">
	$(function(){
		$(".tabCont").hide();
	<% if chkSort>0 then %>
		$("ul.tabs li").eq(<%=chkSort%>).addClass("active").show();
		$(".tabCont").eq(1).show();
	<% else %>
		$("ul.tabs li:first").addClass("active").show();
		$(".tabCont:first").show();
	<% end if %>

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tabCont").hide();

			var activeTab = $(this).find("a").attr("href");
			$(activeTab).fadeIn();
			return false;
		});
	});
	</script>
<%
	else
		tmpOrder = tmpOrder-1
	end if
%>
