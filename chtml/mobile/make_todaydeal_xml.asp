<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<%
'#######################################################
' PageName : make_todaydeal_xml.asp
' Discription : 사이트 메인 페이지용 XML생성 (모바일)
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/main/main_todaydealCls.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<%
'' 관리자 확정시 Data 작성. 

dim i, j
dim poscode
dim savePath, FileName, refip

'// 유입경로 확인
refip = request.ServerVariables("HTTP_REFERER")

'if (InStr(refip,"10x10.co.kr")<1) then
'	response.write "not valid Referer"
'    response.end
'end if
'
dim oTodayDeal
dim vTerm, vTerm2, prevDate, sqlDate, vTotalCount , lprevDate , sumDate
dim sqlStr

vTerm = requestCheckVar(Request("term"),3)
vTerm2 = vTerm
If vTerm2 = "" Then vTerm2 = 1
If vTerm <> "" Then
	vTerm = DateAdd("d",date(),vTerm-1)
End IF
sqlDate = ""

''// 최소 제한수 검사
'for j=1 to cInt(vTerm2)
'	'해당 날짜 접수
'	prevDate = dateadd("d",(j-1),date)
'	sqlDate = sqlDate & "('" & prevDate & "' between startdate and enddate)"
'	if j<cInt(vTerm2) then sqlDate = sqlDate & " or "
'
'	set oTodayDeal = New CMainbanner
'	oTodayDeal.FPageSize		= 20
'	oTodayDeal.FCurrPage		= 1
'	oTodayDeal.Fsdt				= prevDate
'	oTodayDeal.GetContentsList()
'
'	if (oTodayDeal.FResultCount<1) then
'	    response.write "<script>alert('[" & prevDate & "]일의 적용할 데이터가 없습니다.');self.close();</script>"
'		response.End
'	end if
'
'	
'	set oTodayDeal = Nothing
'Next


Dim cpid , strSQL
Dim basicimage ,itemname ,itemid ,startdate ,enddate ,dealtitle ,gubun1 ,gubun2 ,itemurl , itemurlmo
Dim sellCash ,orgPrice , sailYN ,itemcouponYn ,itemcouponvalue ,LimitYn ,itemcoupontype

For j=1 to cInt(vTerm2)
	'// 메인 데이터 접수
	sqlStr = "select top 2 t.* , i.sellCash , i.orgPrice , i.sailyn , i.itemcouponYn, i.itemcouponvalue ,i.limitYN ,i.itemcoupontype , i.basicimage600 , i.basicimage "
	sqlStr = sqlStr + " , md.itemcouponidx , isnull(md.itemcoupontype,0) as ctype , isnull(md.itemcouponvalue,0) as cvalue "
	sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_main_todaydeal as t "
	sqlStr = sqlStr + " inner join db_item.dbo.tbl_item as i "
	sqlStr = sqlStr + " on t.itemid = i.itemid "
	sqlStr = sqlStr + " left outer join "
	sqlStr = sqlStr + " ( "
	sqlStr = sqlStr + "   select m.itemcouponidx,m.itemcoupontype, m.itemcouponvalue , d.itemid "
	sqlStr = sqlStr + "   from [db_item].[dbo].tbl_item_coupon_detail as d "
	sqlStr = sqlStr + "		inner join [db_item].[dbo].tbl_item_coupon_master as m "
	sqlStr = sqlStr + "		on d.itemcouponidx = m.itemcouponidx "
	sqlStr = sqlStr + "		and m.coupongubun = 'T' "
'	sqlStr = sqlStr + "		and m.openstate in ('7') "
'	sqlStr = sqlStr + "		and getdate() between m.itemcouponstartdate and m.itemcouponexpiredate "
	sqlStr = sqlStr + "  ) as md on i.itemid = md.itemid "
	sqlStr = sqlStr & " where t.isusing = 'Y' "
	sqlStr = sqlStr & "		and t.enddate >= getdate() "
	sqlStr = sqlStr & " order by t.startdate asc , t.sortnum asc , cvalue desc"

	rsget.Open SqlStr, dbget, 1
	vTotalCount = rsget.RecordCount
		

	'// 생성파일 경로 및 파일명 선언
	savePath = server.mappath("/chtml/main/xml/main_banner/") + "\"
	FileName = "main_todaydeal.xml"

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

			If isNull(rsget("basicimage600")) OR rsget("basicimage600") = "" Then
				If isNull(rsget("basicimage")) OR rsget("basicimage") = "" Then
					basicimage 	= ""						
				else
					basicimage 	= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
				end if
			Else
				basicimage 		= webImgUrl & "/image/basic600/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage600")
			End If

			itemname		= db2Html(rsget("itemname"))
			itemid			= db2Html(rsget("itemid"))  
			startdate		= rsget("startdate") 
			enddate			= rsget("enddate")   
			dealtitle		= db2Html(rsget("dealtitle"))      
			gubun1			= db2Html(rsget("gubun1"))  
			gubun2			= db2Html(rsget("gubun2"))  
			itemurl			= db2Html(rsget("itemurl")) 
			sellCash		= db2Html(rsget("sellCash"))
			orgPrice		= db2Html(rsget("orgPrice"))      
			sailYN			= db2Html(rsget("sailYN")) 
			itemcouponYn	= db2Html(rsget("itemcouponYn"))  
			itemcouponvalue	= db2Html(rsget("itemcouponvalue")) 
			LimitYn			= db2Html(rsget("LimitYn"))
			itemcoupontype	= db2Html(rsget("itemcoupontype"))
			itemurlmo		= db2Html(rsget("itemurlmo"))

			If itemurl <> "" And (ubound(Split(db2Html(itemurl),"ldv")) > 0) then
				If Trim(Replace(Split(db2Html(itemurl),"ldv")(1),"=","")) <> "" Then
					itemcouponYn = "Y"
					itemcoupontype = rsget("ctype")
					itemcouponvalue = rsget("cvalue")
				End If 
			End If 

			Set objXMLv = objXML.createElement("item")

			objXMLv.appendChild(objXML.createElement("basicimage"))
			objXMLv.appendChild(objXML.createElement("itemname"))
			objXMLv.appendChild(objXML.createElement("itemid"))
			objXMLv.appendChild(objXML.createElement("startdate"))
			objXMLv.appendChild(objXML.createElement("enddate"))
			objXMLv.appendChild(objXML.createElement("dealtitle"))
			objXMLv.appendChild(objXML.createElement("gubun1"))
			objXMLv.appendChild(objXML.createElement("gubun2"))
			objXMLv.appendChild(objXML.createElement("itemurl"))


			objXMLv.appendChild(objXML.createElement("sellCash"))
			objXMLv.appendChild(objXML.createElement("orgPrice"))
			objXMLv.appendChild(objXML.createElement("sailYN"))
			objXMLv.appendChild(objXML.createElement("itemcouponYn"))
			objXMLv.appendChild(objXML.createElement("itemcouponvalue"))
			objXMLv.appendChild(objXML.createElement("LimitYn"))
			objXMLv.appendChild(objXML.createElement("itemcoupontype"))
			objXMLv.appendChild(objXML.createElement("itemurlmo"))

			objXMLv.childNodes(0).text = basicimage
			objXMLv.childNodes(1).text = itemname
			objXMLv.childNodes(2).text = itemid
			objXMLv.childNodes(3).text = startdate
			objXMLv.childNodes(4).text = enddate
			objXMLv.childNodes(5).text = dealtitle
			objXMLv.childNodes(6).text = gubun1
			objXMLv.childNodes(7).text = gubun2
			objXMLv.childNodes(8).text = itemurl


			objXMLv.childNodes(9).text = sellCash
			objXMLv.childNodes(10).text = orgPrice
			objXMLv.childNodes(11).text = sailYN
			objXMLv.childNodes(12).text = itemcouponYn
			objXMLv.childNodes(13).text = itemcouponvalue
			objXMLv.childNodes(14).text = LimitYn
			objXMLv.childNodes(15).text = itemcoupontype
			objXMLv.childNodes(16).text = itemurlmo

			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
			rsget.MoveNext
		Loop
		 '-----파일 저장
		  objXML.save(savePath & FileName)

		 '-----객체 해제
		 Set objXML = Nothing
	end If
	
	rsget.Close

	'// xml 최종 생성 DB-update
	sqlStr = "Update [db_sitemaster].[dbo].tbl_mobile_main_todaydeal " &_
				" Set xmlregdate =getdate()" &_
				" Where isusing = 'Y' and enddate >= getdate() "
	'response.write sqlStr
	'response.end
	dbget.Execute(sqlStr)
Next 

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