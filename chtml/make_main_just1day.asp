<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
' PageName : make_main_just1day.asp
' Discription : 사이트 메인 페이지용 chaance XML생성 (모바일)
' History : 2015-09-23 이종화 생성 chance->just1day 변경
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/main/main_Chance.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
	'// 유입경로 확인
	dim refip
	refip = request.ServerVariables("HTTP_REFERER")
	if (InStr(refip,"10x10.co.kr")<1) then
		'response.end
	end if

	'// 변수 선언
	Dim savePath, FileName, i, cdl, cdm
	Dim objXML, fso, delFile, objXMLv , templdv , temp1day

	'// 생성파일 경로 및 파일명 선언 (날짜별 폴더는 mainLoad.asp에서 확인 뒤 넘어오므로 반드시 존재함)
	savePath = server.mappath("/chtml/main/xml/chance/") + "\"
	Call CreateDir(savePath,replace(dateadd("d",0,date),"-",""))
	savePath = savePath & replace(dateadd("d",0,date),"-","") & "\"
	FileName = "sub_just1day.xml"

	'// 쿼리할꺼 불러오기
	Dim cPk, vIdx, vTitle, intI , vis1day
	Dim oItem , vTimerDate
	
	SET cPk = New CPick
	cPk.GetPickOne()
	
	If cPk.FTotalCount > 0 Then
		vIdx = cPk.FItemOne.Fidx
		vTitle = cPk.FItemOne.Ftitle
		vis1day = cPk.FItemOne.Fis1day
	End IF
	
	If vIdx <> "" Then
		cPk.FPageSize = 3
		cPk.FCurrPage = 1
		cPk.FRectIdx = vIdx
		cPk.FRectSort = 1
		cPk.GetPickItemList()
	End If

	if cPk.fresultcount > 0 then
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
		objXML.appendChild(objXML.createElement("mainchance"))
	
		'-----프로세스 시
		for intI = 0 to cPk.fresultcount

			'//temp
			templdv = cPk.FCategoryPrdList(intI).Fldv
			temp1day = vis1day

			'// 쿠폰여부체크
			if Not(cPk.FCategoryPrdList(intI).Fldv="" or isNull(cPk.FCategoryPrdList(intI).Fldv)) then
				cPk.FCategoryPrdList(intI).Fldv = trim(Base64decode(cPk.FCategoryPrdList(intI).Fldv))
				if isNumeric(cPk.FCategoryPrdList(intI).Fldv) then
					dim strSQL
					strSQL = " select m.itemcoupontype, m.itemcouponvalue "
					strSQL = strSQL & " from [db_item].[dbo].tbl_item_coupon_master as m "
					strSQL = strSQL & " Join [db_item].[dbo].tbl_item_coupon_detail as d "
					strSQL = strSQL & " on m.itemcouponidx=d.itemcouponidx "
					strSQL = strSQL & " where m.itemcouponidx='"& cPk.FCategoryPrdList(intI).Fldv &"' "
					strSQL = strSQL & " and d.itemid= '"& cPk.FCategoryPrdList(intI).Fitemid &"' "

					rsget.Open strSQL,dbget,1
					IF Not (rsget.EOF OR rsget.BOF) THEN
						cPk.FCategoryPrdList(intI).FCurrItemCouponIdx	= cPk.FCategoryPrdList(intI).Fldv
						cPk.FCategoryPrdList(intI).FItemCouponYN		= "Y"
						cPk.FCategoryPrdList(intI).FItemCouponType 		= rsget("itemcoupontype")
						cPk.FCategoryPrdList(intI).FItemCouponValue		= rsget("itemcouponvalue")
					END IF
					rsget.close
				end if
			end If

			'카테고리명 접수
			Set objXMLv = objXML.createElement("item")

			objXMLv.appendChild(objXML.createElement("itemid"))
			objXMLv.appendChild(objXML.createElement("itemname"))
			objXMLv.appendChild(objXML.createElement("sellcash"))
			objXMLv.appendChild(objXML.createElement("orgPrice"))
			objXMLv.appendChild(objXML.createElement("makerid"))

			objXMLv.appendChild(objXML.createElement("brandname"))
			objXMLv.appendChild(objXML.createElement("sellyn"))
			objXMLv.appendChild(objXML.createElement("saleyn"))
			objXMLv.appendChild(objXML.createElement("limityn"))
			objXMLv.appendChild(objXML.createElement("limitno"))

			objXMLv.appendChild(objXML.createElement("limitsold"))
			objXMLv.appendChild(objXML.createElement("itemcouponyn"))
			objXMLv.appendChild(objXML.createElement("ItemCouponvalue"))

			objXMLv.appendChild(objXML.createElement("itemcoupontype"))
			objXMLv.appendChild(objXML.createElement("imagebasic"))
			objXMLv.appendChild(objXML.createElement("itemdiv"))
			objXMLv.appendChild(objXML.createElement("ldv"))
			objXMLv.appendChild(objXML.createElement("label"))
			objXMLv.appendChild(objXML.createElement("templdv"))
			objXMLv.appendChild(objXML.createElement("is1day"))

			'CData 타입정의
			objXMLv.childNodes(11).appendChild(objXML.createCDATASection("regdate_Cdata"))
			objXMLv.childNodes(12).appendChild(objXML.createCDATASection("reipgodate_Cdata"))

			'데이터 넣기
			objXMLv.childNodes(0).text = cPk.FCategoryPrdList(intI).FItemID
			objXMLv.childNodes(1).text = cPk.FCategoryPrdList(intI).FItemName
			objXMLv.childNodes(2).text = cPk.FCategoryPrdList(intI).FSellcash
			objXMLv.childNodes(3).text = cPk.FCategoryPrdList(intI).FOrgPrice
			objXMLv.childNodes(4).text = cPk.FCategoryPrdList(intI).FMakerId

			objXMLv.childNodes(5).text = cPk.FCategoryPrdList(intI).FBrandName
			objXMLv.childNodes(6).text = cPk.FCategoryPrdList(intI).FSellYn
			objXMLv.childNodes(7).text = cPk.FCategoryPrdList(intI).FSaleYn
			objXMLv.childNodes(8).text = cPk.FCategoryPrdList(intI).FLimitYn
			objXMLv.childNodes(9).text = cPk.FCategoryPrdList(intI).FLimitNo

			objXMLv.childNodes(10).text = cPk.FCategoryPrdList(intI).FLimitSold
			objXMLv.childNodes(11).text = cPk.FCategoryPrdList(intI).Fitemcouponyn
			objXMLv.childNodes(12).text = cPk.FCategoryPrdList(intI).FItemCouponValue

			objXMLv.childNodes(13).text = cPk.FCategoryPrdList(intI).Fitemcoupontype
			objXMLv.childNodes(14).text = cPk.FCategoryPrdList(intI).FImageBasic
			objXMLv.childNodes(15).text = cPk.FCategoryPrdList(intI).Fitemdiv
			objXMLv.childNodes(16).text = cPk.FCategoryPrdList(intI).Fldv
			objXMLv.childNodes(17).text = cPk.FCategoryPrdList(intI).Flabel
			objXMLv.childNodes(18).text = templdv
			objXMLv.childNodes(19).text = temp1day


			objXML.documentElement.appendChild(objXMLv.cloneNode(True))
			Set objXMLv = Nothing
		next
		'-----파일 저장

		objXML.save(savePath & FileName)
	
		'-----객체 해제
		Set objXML = Nothing
	end If
	
	set cPk = Nothing


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
<!-- #include virtual="/lib/db/dbclose.asp" -->