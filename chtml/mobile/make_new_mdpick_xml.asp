<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<%
'###########################################################
' Discription : 모바일 메인페이지 mdpick xml 생성
' History : 2014.01.28 이종화 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
'' 관리자 확정시 Data 작성. 

dim i, j
dim poscode
dim savePath, FileName, refip , itemCnt

'// 유입경로 확인
refip = request.ServerVariables("HTTP_REFERER")

'if (InStr(refip,"10x10.co.kr")<1) then
'	response.write "not valid Referer"
'    response.end
'end if
'
dim vTerm, vTerm2, prevDate, sqlDate, vTotalCount , lprevDate , sumDate
dim sqlStr , FResultCount

vTerm = requestCheckVar(Request("term"),3)
vTerm2 = vTerm
If vTerm2 = "" Then vTerm2 = 1
If vTerm <> "" Then
	vTerm = DateAdd("d",date(),vTerm-1)
End IF
sqlDate = ""

'표시할 상품수 지정
itemCnt = 100

'// 최소 제한수 검사
for j=1 to cInt(vTerm2)
	'해당 날짜 접수
	prevDate = dateadd("d",(j-1),date)

	sqlStr = "select top " & itemCnt
	sqlStr = sqlStr + " *  from db_sitemaster.dbo.tbl_mobile_main_mdpick_list as l "
	sqlStr = sqlStr + " inner join [db_sitemaster].[dbo].tbl_mobile_main_mdpick_item as s "
	sqlStr = sqlStr + " on s.listidx = l.idx "
	sqlStr = sqlStr + " where l.isusing='Y'"
	sqlStr = sqlStr + " and convert(varchar(10),StartDate,120) between '" & prevDate &"' and '" & prevDate &"' "
	sqlStr = sqlStr + " order by s.sortnum asc"

	rsget.Open SqlStr, dbget, 1
	FResultCount = rsget.RecordCount
	rsget.Close

	if (FResultCount<1) then
	    response.write "<script>alert('[" & prevDate & "]일의 적용할 데이터가 없습니다.');self.close();</script>"
		response.End
	end If
	
Next

For j=1 to cInt(vTerm2)
	lprevDate = dateadd("d",(j-1),date)
	sumDate = sumDate &"//"& lprevDate
	sqlDate = "('" & lprevDate & "' between convert(varchar(10),l.startdate,120) and convert(varchar(10),l.startdate,120))"
	'// 메인 데이터 접수
	sqlStr = "Select top "& itemCnt &" s.subidx , s.listidx , s.itemid , s.isusing as itemusing , s.sortnum , isnull(s.itemname,i.itemname) as itemname , i.basicimage , datepart(hh, l.startdate) as starttime , datepart(hh, l.enddate) as endtime  , l.mdpicktitle"
    sqlStr = sqlStr & " , (case when DATEDIFF ( day , i.regdate  , getdate()) < 14 then 'Y' else 'N' end) as newyn "
	sqlStr = sqlStr & " , i.sellCash , i.orgPrice , i.sailyn , i.itemcouponYn , i.itemcouponvalue , i.limitYN , i.itemcoupontype , (i.limitno - i.limitsold) as limitno , i.limitdispyn , i.makerid " 
	sqlStr = sqlStr & " From [db_sitemaster].[dbo].tbl_mobile_main_mdpick_item as s "
	sqlStr = sqlStr & "	left join db_item.dbo.tbl_item as i "
	sqlStr = sqlStr & "		on s.itemid=i.itemid "
	sqlStr = sqlStr & "			and i.itemid<>0 "
	sqlStr = sqlStr & "	left join [db_sitemaster].dbo.tbl_mobile_main_mdpick_list as l "
	sqlStr = sqlStr & "	on s.listidx = l.idx  "
	sqlStr = sqlStr & " Where s.isusing = 'Y' and (" & sqlDate & ") "
	sqlStr = sqlStr & " order by s.listidx asc , s.sortnum asc "

	'response.write sqlStr

	rsget.Open SqlStr, dbget, 1
	vTotalCount = rsget.RecordCount

	savePath = server.mappath("/chtml/main/xml/mdpick") + "\"
	Call CreateDir(savePath,replace(dateadd("d",(j-1),date),"-",""))
	savePath = savePath & replace(dateadd("d",(j-1),date),"-","") & "\"
	FileName = "main_mdpick_"&lprevDate&".xml"

	dim objXML, objXMLv, blnFileExist

	'// 파일 생성
	if vTotalCount>0 then
		 Set objXML = server.CreateObject("Microsoft.XMLDOM")
		 objXML.async = False

		'// 기존 파일 삭제
		Dim fso, delFile
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
		Do Until rsget.EOF
			Set objXMLv = objXML.createElement("item")

			objXMLv.appendChild(objXML.createElement("itemid"))
			objXMLv.appendChild(objXML.createElement("basicimage"))
			objXMLv.appendChild(objXML.createElement("itemname"))

			objXMLv.appendChild(objXML.createElement("sellCash"))
			objXMLv.appendChild(objXML.createElement("orgPrice"))
			objXMLv.appendChild(objXML.createElement("sailYN"))
			objXMLv.appendChild(objXML.createElement("itemcouponYn"))
			objXMLv.appendChild(objXML.createElement("itemcouponvalue"))
			objXMLv.appendChild(objXML.createElement("LimitYn"))
			objXMLv.appendChild(objXML.createElement("itemcoupontype"))
			objXMLv.appendChild(objXML.createElement("newyn"))
			objXMLv.appendChild(objXML.createElement("limitno"))
			objXMLv.appendChild(objXML.createElement("limitdispyn"))
			objXMLv.appendChild(objXML.createElement("starttime"))
			objXMLv.appendChild(objXML.createElement("endtime"))
			objXMLv.appendChild(objXML.createElement("makerid"))

			objXMLv.childNodes(0).text = db2Html(rsget("itemid"))
			objXMLv.childNodes(1).text = webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(rsget("itemid"))) + "/" + db2Html(rsget("basicimage"))
			objXMLv.childNodes(2).text = db2Html(rsget("itemname"))

			objXMLv.childNodes(3).text = db2Html(rsget("sellCash"))
			objXMLv.childNodes(4).text = db2Html(rsget("orgPrice"))
			objXMLv.childNodes(5).text = db2Html(rsget("sailYN"))
			objXMLv.childNodes(6).text = db2Html(rsget("itemcouponYn"))
			objXMLv.childNodes(7).text = db2Html(rsget("itemcouponvalue"))
			objXMLv.childNodes(8).text = db2Html(rsget("LimitYn"))
			objXMLv.childNodes(9).text = db2Html(rsget("itemcoupontype"))
			objXMLv.childNodes(10).text = db2Html(rsget("newyn"))
			objXMLv.childNodes(11).text = db2Html(rsget("limitno"))
			objXMLv.childNodes(12).text = db2Html(rsget("limitdispyn"))
			objXMLv.childNodes(13).text = rsget("starttime")
			objXMLv.childNodes(14).text = rsget("endtime")
			objXMLv.childNodes(15).text = rsget("makerid")

			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
			rsget.MoveNext
		Loop
		 '-----파일 저장
		 '// 생성파일 경로 및 파일명 선언

		  objXML.save(savePath & FileName)

		 '-----객체 해제
		 Set objXML = Nothing
	end if

	rsget.Close

		'// xml 최종 생성 DB-update
	sqlStr = "Update [db_sitemaster].[dbo].tbl_mobile_main_mdpick_list " &_
				" Set xmlregdate =getdate()" &_
				" Where  isusing = 'Y' and (('" & lprevDate & "' between convert(varchar(10),startdate,120) and convert(varchar(10),startdate,120)))  "
	'response.write sqlStr
	dbget.Execute(sqlStr)

Next 

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
<script>
alert("<%=sumDate%>생성완료");
self.close();
</script>
<body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
