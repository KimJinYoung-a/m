<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
' PageName : make_main_xml.asp
' Discription : 사이트 메인 페이지용 XML생성 (모바일)
'     - 생성일로 부터 3일간 자료 생성
'     - 컨텐츠 순서와 각 컨텐츠별 소재 파일은 분리 저장
' History : 2013.04.04 허진원 : 신규 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/main/wcmsCls.asp" -->
<%
'// 유입경로 확인
dim refip
refip = request.ServerVariables("HTTP_REFERER")

if (InStr(refip,"10x10.co.kr")<1) then
	response.write "not valid Referer"
	response.end
end if

'// 변수 선언 및 접수
Dim sIdx, lp, sTrm, eTrm, i, j, rstMsg
Dim oMain, oSub
dim savePath, FileName
dim objXML, objXMLv, blnFileExist
Dim fso, delFile
Dim chkAll, tmpIdx, arrIdx

set sIdx = request.form("chkIdx")
sTrm = request.form("sTrm")
chkAll = request.form("chkAll")
if sTrm="" or sTrm="0" then
	sTrm = 0: eTrm= sTrm+3
else
	sTrm = cInt(sTrm)
	eTrm = cInt(sTrm)
end if
if chkAll="" then chkAll="N"

for lp=sTrm to eTrm
'========================================================
	'// 생성파일 경로 및 파일명 선언
	savePath = server.mappath("/chtml/main/xml/") + "\"
	Call CreateDir(savePath,replace(dateadd("d",lp,date),"-",""))
	savePath = savePath & replace(dateadd("d",lp,date),"-","") & "\"
	
	rstMsg = rstMsg & "=== " & dateadd("d",lp,date) & " ===\n"
	
	'#####################################################
	' 템플릿 목록 저장
	'#####################################################
	'// 생성파일명 선언
	FileName = "main_list.xml"
	
	'// 페이지 목록 저장
	set oMain = new CCMSContent
	oMain.FRectDateTerm = lp		'오늘부터 날짜수(오늘은 0, 내일은 1)
	oMain.FRectSiteDiv = "M"
	oMain.FRectPageDiv = "10"
	oMain.GetMainPageList

	if oMain.FResultCount>0 then
		ReDim tmpIdx(oMain.FResultCount)

		 Set objXML = server.CreateObject("Microsoft.XMLDOM")
		 objXML.async = False
	
		'// 기존 파일 삭제
		Set fso = CreateObject("Scripting.FileSystemObject")
		if fso.FileExists(savePath & FileName) then
			Set delFile = fso.GetFile(savePath & FileName)
			delFile.Delete 
			set delFile = Nothing
		end if
		set fso = Nothing
	
		'----- XML 해더 생성
		objXML.appendChild(objXML.createProcessingInstruction("xml","version=""1.0"""))
		objXML.appendChild(objXML.createElement("mainPage"))
	
		'-----프로세스 시작
		for i=0 to oMain.FResultCount-1
			Set objXMLv = objXML.createElement("item")
	
			objXMLv.appendChild(objXML.createElement("idx"))
			objXMLv.appendChild(objXML.createElement("template"))
			objXMLv.appendChild(objXML.createElement("startdate"))
			objXMLv.appendChild(objXML.createElement("enddate"))
			objXMLv.appendChild(objXML.createElement("title"))
			objXMLv.appendChild(objXML.createElement("useTitle"))
			objXMLv.appendChild(objXML.createElement("useTime"))
			objXMLv.appendChild(objXML.createElement("preOpen"))
			objXMLv.appendChild(objXML.createElement("iconCd"))
			objXMLv.appendChild(objXML.createElement("extCd"))
			objXMLv.appendChild(objXML.createElement("modiDate"))
	
			'CData 타입정의
			objXMLv.childNodes(2).appendChild(objXML.createCDATASection("startdate_Cdata"))
			objXMLv.childNodes(3).appendChild(objXML.createCDATASection("enddate_Cdata"))
			objXMLv.childNodes(4).appendChild(objXML.createCDATASection("title_Cdata"))
			objXMLv.childNodes(10).appendChild(objXML.createCDATASection("modiDate_Cdata"))
	
			'데이터 넣기
			objXMLv.childNodes(0).text = oMain.FItemList(i).FmainIdx
			objXMLv.childNodes(1).text = oMain.FItemList(i).FtplIdx
			objXMLv.childNodes(2).childNodes(0).text = oMain.FItemList(i).FmainStartDate
			objXMLv.childNodes(3).childNodes(0).text = oMain.FItemList(i).FmainEndDate
			objXMLv.childNodes(4).childNodes(0).text = oMain.FItemList(i).FmainTitle
			objXMLv.childNodes(5).text = oMain.FItemList(i).FmainTitleYn
			objXMLv.childNodes(6).text = oMain.FItemList(i).FmainTimeYN
			objXMLv.childNodes(7).text = oMain.FItemList(i).FmainIsPreOpen
			objXMLv.childNodes(8).text = oMain.FItemList(i).FmainIcon
			objXMLv.childNodes(9).text = oMain.FItemList(i).FmainExtDataCd
			objXMLv.childNodes(10).childNodes(0).text = oMain.FItemList(i).FmainModiDate
	
			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing

			tmpIdx(i) = oMain.FItemList(i).FmainIdx
		Next
	
		'-----파일 저장
		objXML.save(savePath & FileName)
		rstMsg = rstMsg & "- 템플릿 목록 파일 [" & FileName & "] 생성 완료\n"
	
		'-----객체 해제
		Set objXML = Nothing


		'// 전체적용일 경우 메인컨텐츠 배열 재정리
		if chkAll="Y" then
			arrIdx = tmpIdx
		else
			ReDim arrIdx(sIdx.count)
			for j=0 to sIdx.count-1
				arrIdx(j) = sIdx(j+1)
			next
		end if
		
		'#####################################################
		' 각 템플릿 내용 저장
		'#####################################################
		
		'@선택된 템플릿별 저장
		for j=0 to ubound(arrIdx)
			
			'// 생성파일명 선언
			FileName = "sub_" & arrIdx(j) & ".xml"
		
			'// 페이지 목록 저장
			set oSub = new CCMSContent
			oSub.FRectMainIdx = arrIdx(j)
			oSub.FRectDateTerm = lp
			oSub.GetMainSubItem
			if oSub.FResultCount>0 then
				 Set objXML = server.CreateObject("Microsoft.XMLDOM")
				 objXML.async = False
			
				'// 기존 파일 삭제
				Set fso = CreateObject("Scripting.FileSystemObject")
				if fso.FileExists(savePath & FileName) then
					Set delFile = fso.GetFile(savePath & FileName)
					delFile.Delete 
					set delFile = Nothing
				end if
				set fso = Nothing
			
				'----- XML 해더 생성
				objXML.appendChild(objXML.createProcessingInstruction("xml","version=""1.0"""))
				objXML.appendChild(objXML.createElement("subPage"))
			
				'-----프로세스 시작
				for i=0 to oSub.FResultCount-1
					Set objXMLv = objXML.createElement("item")
			
					objXMLv.appendChild(objXML.createElement("image1"))
					objXMLv.appendChild(objXML.createElement("image2"))
					objXMLv.appendChild(objXML.createElement("text1"))
					objXMLv.appendChild(objXML.createElement("text2"))
					objXMLv.appendChild(objXML.createElement("link"))
					objXMLv.appendChild(objXML.createElement("itemid"))
					objXMLv.appendChild(objXML.createElement("video"))
					objXMLv.appendChild(objXML.createElement("bgcolor"))
					objXMLv.appendChild(objXML.createElement("imgdesc"))
		
					objXMLv.appendChild(objXML.createElement("itemname"))
					objXMLv.appendChild(objXML.createElement("sellCash"))
					objXMLv.appendChild(objXML.createElement("orgPrice"))
					objXMLv.appendChild(objXML.createElement("salePer"))
					objXMLv.appendChild(objXML.createElement("saleYn"))
					objXMLv.appendChild(objXML.createElement("LimitYn"))
					objXMLv.appendChild(objXML.createElement("NewYn"))
					objXMLv.appendChild(objXML.createElement("couponYn"))
					objXMLv.appendChild(objXML.createElement("GiftYn"))
					objXMLv.appendChild(objXML.createElement("itemImg100"))
					objXMLv.appendChild(objXML.createElement("itemImg200"))
					objXMLv.appendChild(objXML.createElement("itemImg400"))
					objXMLv.appendChild(objXML.createElement("sortno"))
			
					'CData 타입정의
					objXMLv.childNodes(0).appendChild(objXML.createCDATASection("image1_Cdata"))
					objXMLv.childNodes(1).appendChild(objXML.createCDATASection("image2_Cdata"))
					objXMLv.childNodes(2).appendChild(objXML.createCDATASection("text1_Cdata"))
					objXMLv.childNodes(3).appendChild(objXML.createCDATASection("text2_Cdata"))
					objXMLv.childNodes(4).appendChild(objXML.createCDATASection("link_Cdata"))
					objXMLv.childNodes(6).appendChild(objXML.createCDATASection("video_Cdata"))
					objXMLv.childNodes(8).appendChild(objXML.createCDATASection("imgdesc_Cdata"))
		
					objXMLv.childNodes(9).appendChild(objXML.createCDATASection("itemname_Cdata"))
					objXMLv.childNodes(12).appendChild(objXML.createCDATASection("salePer_Cdata"))
					objXMLv.childNodes(18).appendChild(objXML.createCDATASection("itemImg100_Cdata"))
					objXMLv.childNodes(19).appendChild(objXML.createCDATASection("itemImg200_Cdata"))
					objXMLv.childNodes(20).appendChild(objXML.createCDATASection("itemImg400_Cdata"))
		
					'데이터 넣기
					objXMLv.childNodes(0).childNodes(0).text = oSub.FItemList(i).getImageUrl(1)
					objXMLv.childNodes(1).childNodes(0).text = oSub.FItemList(i).getImageUrl(2)
					objXMLv.childNodes(2).childNodes(0).text = oSub.FItemList(i).FsubText1
					objXMLv.childNodes(3).childNodes(0).text = oSub.FItemList(i).FsubText2
					objXMLv.childNodes(4).childNodes(0).text = oSub.FItemList(i).FsubLinkUrl
					objXMLv.childNodes(5).text = oSub.FItemList(i).FsubItemid
					objXMLv.childNodes(6).childNodes(0).text = oSub.FItemList(i).FsubVideoUrl
					objXMLv.childNodes(7).text = oSub.FItemList(i).FsubBGColor
					objXMLv.childNodes(8).childNodes(0).text = oSub.FItemList(i).FsubImageDesc
		
					objXMLv.childNodes(9).childNodes(0).text = oSub.FItemList(i).Fitemname
					objXMLv.childNodes(10).text = oSub.FItemList(i).getSalePrice
					objXMLv.childNodes(11).text = oSub.FItemList(i).FOrgprice
					objXMLv.childNodes(12).childNodes(0).text = oSub.FItemList(i).getSalePro
					objXMLv.childNodes(13).text = oSub.FItemList(i).IsSaleItem
					objXMLv.childNodes(14).text = oSub.FItemList(i).IsLimitItem
					objXMLv.childNodes(15).text = oSub.FItemList(i).IsNewItem
					objXMLv.childNodes(16).text = oSub.FItemList(i).IsCouponItem
					objXMLv.childNodes(17).text = oSub.FItemList(i).isGiftItem
					objXMLv.childNodes(18).childNodes(0).text = oSub.FItemList(i).FImageList
					objXMLv.childNodes(19).childNodes(0).text = oSub.FItemList(i).FImageicon1
					objXMLv.childNodes(20).childNodes(0).text = oSub.FItemList(i).FImageBasic
					objXMLv.childNodes(21).text = oSub.FItemList(i).FsubSortNo
		
					objXML.documentElement.appendChild(objXMLv.cloneNode(True))
					Set objXMLv = Nothing
				Next
		
				'-----파일 저장
				objXML.save(savePath & FileName)
				rstMsg = rstMsg & "- 소재 파일 [" & FileName & "] 생성 완료\n"
			
				'-----객체 해제
				Set objXML = Nothing
			end if
			
			set oSub = Nothing
		next
		'========================================================
	else
		rstMsg = rstMsg & "- 적용할 템플릿 없음 \n"
	end if
	
	set oMain = Nothing

next


'========================================================
'// 폴더검사 및 생성 함수
Sub CreateDir(defaultpath, subpath)
	dim fso

	set fso = server.createobject("Scripting.fileSystemObject")
	if not fso.FolderExists(defaultpath) Then
		fso.createfolder(defaultpath)
	end if

	if not fso.FolderExists(defaultpath + "\" + subpath) Then
		fso.createfolder(defaultpath + "\" + subpath)
	end if
	set fso = Nothing
end Sub
%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<title>텐바이텐 메인페이지 생성기</title>
</head>
<body>
<script language='javascript'>
alert("<%=rstMsg%>");
self.close();
</script>
<body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->