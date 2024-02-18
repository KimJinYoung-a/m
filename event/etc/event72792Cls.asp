<%
'####################################################
' Description : [★★2016 F/W 웨딩 메인] A SMALL WEDDING
' History : 2016-09-08 유태욱 생성
' History : 2016-09-08 이종화 사용 (별도의 변경없는 같은 포멧으로 활용)
'####################################################
'----------------------------------------------------
' ClsEvtItem : 상품
'----------------------------------------------------
Class ClsEvtItem
	public FECode   '이벤트 코드
	public FEGCode
	public FEPGsize
	public FEItemCnt
	public FItemsort
	public FTotCnt
	public FItemArr
	public FPoints
	
	public Frectminnum
	public Frectmaxnum
	public Frectgroup_code

	public FCategoryPrdList()

	Private Sub Class_Initialize()
		redim preserve FCategoryPrdList(0)
		FTotCnt = 0
		FItemArr = ""
	End Sub

	Private Sub Class_Terminate()

	End Sub

	'##### 상품 리스트 ###### ver2.0버전
	public Function fnGetEventItem_v2
		Dim strSql, arrItem,intI, sqlsearch
		IF FECode = "" THEN Exit Function

		IF FEGCode = "" THEN 
			FEGCode= 0

			'// 전체 일때 가격 조건 포함 추가
			sqlsearch = sqlsearch & " and  i.sellcash > 15000"
		else
			sqlsearch = sqlsearch & " and  e.evtgroup_code ="& FEGCode &""
		end if

		if Frectminnum <> "" then
			sqlsearch = sqlsearch & " and  e.evtitem_sort_mo >="& Frectminnum &""
		end if

		if Frectmaxnum <> "" then
			sqlsearch = sqlsearch & " and  e.evtitem_sort_mo <="& Frectmaxnum &""
		end if

		strSql = " SELECT TOP "&FEPGsize&" i.itemid, i.itemname, i.sellcash,i.orgprice," & vbcrlf
		strSql = strSql & " (Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as makerid " & vbcrlf
		strSql = strSql & " ,i.brandname, i.listimage,i.listimage120, i.smallImage, i.sellyn, i.sailyn, i.limityn,i.limitno, i.limitsold,i.regdate,i.reipgodate " & vbcrlf
		strSql = strSql & " ,itemcouponYn, itemCouponValue, itemCouponType, i.evalCnt, i.itemScore, icon1image, i.icon2image, e.evtitem_imgsize, i.itemdiv  " & vbcrlf
		strSql = strSql & " ,case i.limityn when 'Y' then case when ((i.limitno-i.limitsold)<=0) then '2' else '1' end Else '1' end as lsold  " & vbcrlf
		strSql = strSql & " ,i.basicimage, i.basicimage600, c.favcount, a.addimage_400 " & vbcrlf
		strSql = strSql & " , (CASE WHEN (orgprice - sellcash) > 0 THEN round((1 - sellcash / orgprice) * 100, 0)  " & vbcrlf
        strSql = strSql & "        WHEN (orgprice - sellcash) <= 0 THEN 0 END) AS SalePercent " & vbcrlf
		strSql = strSql & " ,i.tentenimage, i.tentenimage50, i.tentenimage200, i.tentenimage400, i.tentenimage600, i.tentenimage1000, c.designercomment " & vbcrlf
		strSql = strSql & " ,isNull(convert(int,(ROUND(eps.TotalPoint,2)*100)),0) as totalpoint"
		strSql = strSql & " FROM  [db_event].[dbo].[tbl_eventitem] as e INNER JOIN  [db_item].[dbo].tbl_item as i ON e.itemid = i.itemid " & vbcrlf
		strSql = strSql & " LEFT OUTER JOIN [db_item].[dbo].[tbl_item_contents] AS c ON i.itemid = c.itemid " & vbcrlf
		strSql = strSql & " LEFT OUTER JOIN [db_item].[dbo].[tbl_item_addimage] AS a ON i.itemid = a.itemid and a.gubun = 1 and a.imgtype = 0 " & vbcrlf
		strSql = strSql & " LEFT OUTER JOIN [db_board].[dbo].[tbl_const_eval_PointSummary] as eps ON i.itemid = eps.itemid" & vbcrlf
		strSql = strSql & " WHERE  e.evt_code ="& FECode &" and i.sellyn in ('Y','S')  and e.evtitem_isDisp_mo = 1 " & sqlsearch & vbcrlf

		'빅세일
		if FEGCode <> "" and FEGCode <> 0 then
			'베스트 셀러순 정렬
			
			strSql = strSql & " ORDER BY e.evtitem_sort_mo asc  "	'i.sellyn desc, lsold, i.itemid desc, e.evtitem_imgsize desc

			'랜덤으로 뿌릴경우
	'		strSql = strSql & " ORDER BY newid()  "
		else
			'self house(공간별 상품)정렬순서대로
			strSql = strSql & " ORDER BY i.itemScore desc  "
		end If
		
'		If GetEncLoginUserID() = "motions" then
''			response.write strSql &"<br/>"
''			response.end
'		End If 

		'rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"ITEM",strSql,60*5)
        if (rsMem is Nothing) then Exit function ''추가

		IF Not (rsMem.EOF OR rsMem.BOF) THEN
			arrItem = rsMem.GetRows()
		END IF
		rsMem.close

		IF isArray(arrItem) THEN
			FTotCnt = Ubound(arrItem,2)
			redim preserve FCategoryPrdList(FTotCnt)

			For intI = 0 To FTotCnt

			set FCategoryPrdList(intI) = new CCategoryPrdItem
				FCategoryPrdList(intI).FItemID       = arrItem(0,intI)

				IF intI =0 THEN
					FItemArr = 	FCategoryPrdList(intI).FItemID
				ELSE
					FItemArr = FItemArr&","&FCategoryPrdList(intI).FItemID
				END IF

				FCategoryPrdList(intI).FItemName			= db2html(arrItem(1,intI))
				FCategoryPrdList(intI).FSellcash			= arrItem(2,intI)
				FCategoryPrdList(intI).FOrgPrice			= arrItem(3,intI)
				FCategoryPrdList(intI).FMakerId				= db2html(arrItem(4,intI))
				FCategoryPrdList(intI).FBrandName			= db2html(arrItem(5,intI))
				FCategoryPrdList(intI).FSellYn				= arrItem(9,intI)
				FCategoryPrdList(intI).FSaleYn				= arrItem(10,intI)
				FCategoryPrdList(intI).FLimitYn				= arrItem(11,intI)
				FCategoryPrdList(intI).FLimitNo				= arrItem(12,intI)
				FCategoryPrdList(intI).FLimitSold			= arrItem(13,intI)
				FCategoryPrdList(intI).FRegdate				= arrItem(14,intI)
				FCategoryPrdList(intI).FReipgodate			= arrItem(15,intI)
				FCategoryPrdList(intI).Fitemcouponyn		= arrItem(16,intI)
				FCategoryPrdList(intI).FItemCouponValue	= arrItem(17,intI)
				FCategoryPrdList(intI).Fitemcoupontype		= arrItem(18,intI)
				FCategoryPrdList(intI).Fevalcnt				= arrItem(19,intI)
				FCategoryPrdList(intI).FitemScore			= arrItem(20,intI)

				FCategoryPrdList(intI).FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(6,intI)
				FCategoryPrdList(intI).FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(7,intI)
				FCategoryPrdList(intI).FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(8,intI)
				FCategoryPrdList(intI).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(21,intI)
				FCategoryPrdList(intI).FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(22,intI)
				FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(26,intI)
				FCategoryPrdList(intI).FItemSize	= arrItem(23,intI)
				FCategoryPrdList(intI).Fitemdiv		= arrItem(24,intI)
				FCategoryPrdList(intI).FFavCount	= arrItem(28,intI)

				If Not(arrItem(31,intI)="" Or isnull(arrItem(31,intI))) Then 
					FCategoryPrdList(intI).Ftentenimage	= "http://webimage.10x10.co.kr/image/tenten/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(31,intI)
					FCategoryPrdList(intI).Ftentenimage50	= "http://webimage.10x10.co.kr/image/tenten50/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(32,intI)
					FCategoryPrdList(intI).Ftentenimage200	= "http://webimage.10x10.co.kr/image/tenten200/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(33,intI)
					FCategoryPrdList(intI).Ftentenimage400	= "http://webimage.10x10.co.kr/image/tenten400/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(34,intI)
					FCategoryPrdList(intI).Ftentenimage600	= "http://webimage.10x10.co.kr/image/tenten600/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(35,intI)
					FCategoryPrdList(intI).Ftentenimage1000	= "http://webimage.10x10.co.kr/image/tenten1000/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(36,intI)
				End If

				FCategoryPrdList(intI).FDesignerComment 		= arrItem(37,intI)
				FCategoryPrdList(intI).FPoints 					= arrItem(38,intI)
			Next
		ELSE
			FTotCnt = -1
		END IF
	End Function
End Class


public Function fnGetGroupMaxSalePer(ecode,grcode)
	dim strSql, MaxSalePer

	strSql = " SELECT TOP 1 max((CASE WHEN (orgprice - sellcash) > 0 THEN round((1 - sellcash / orgprice) * 100, 0) WHEN (orgprice - sellcash) <= 0 THEN 0 END)) as maxsalep	"
	strSql = strSql & " FROM [db_event].[dbo].[tbl_eventitem] as e 	"
	strSql = strSql & " 	INNER JOIN [db_item].[dbo].tbl_item as i 	"
	strSql = strSql & " 		ON e.itemid = i.itemid 	"
	strSql = strSql & " WHERE e.evt_code ="&ecode
	strSql = strSql & " and e.evtgroup_code="&grcode
	strSql = strSql & " and i.sellyn in ('Y','S') and e.evtitem_isDisp_mo = 1 	"
	strSql = strSql & " group by orgprice, sellcash	"
	strSql = strSql & " ORDER BY maxsalep desc	"

'	response.write strSql &"<Br>"
'	response.end
	rsget.Open strSql,dbget,1
	IF Not rsget.EOF THEN
		MaxSalePer = rsget("maxsalep")
	END IF
	rsget.Close
	response.write MaxSalePer
End Function
%>