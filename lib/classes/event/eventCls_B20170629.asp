<%
'----------------------------------------------------
' ClsEvtCont : 이벤트 내용
'----------------------------------------------------
Class ClsEvtCont
	public FECode   '이벤트 코드
	public FEGCode
   	public FEGPCode

	public FEKind
	public FEManager
	public FEScope
	public FEName
	public FESDate
	public FEEDate
	public FEState
	public FERegdate
	public FEPDate
	public FECategory
	public FECateMid
	public FSale
	public FGift
	public FCoupon
	public FComment
	public FBBS
	public FItemeps
	public FApply
	public FTemplate
	public FEMimg
	public FEMimg_mo ' 이벤트 메인 배너 모바일용
	public FEHtml
	public FItemsort
	public FBrand
	public FGimg
	public FFullYN
	public FIteminfoYN
	public FLinkEvtCode
	public FblnBlogURL
	Public FItempriceYN '상품 가격
	Public FDateViewYN	'이벤트 기간 노출여부
	public FFBAppid
	public FFBcontent
	public FBimg
	public FFavCnt
	public FEWideYN
	public FEItemID
	public FEItemImg
	public Fbasicimg600
	public Fbasicimg
	public FEDispCate
	public FEItemListType
	public FEmolistbanner
	Public FevtFile
	Public FevtFile_mo
	Public FevtFileyn
	Public FevtFileyn_mo
	Public FDevice

	'//2015 리뉴얼 모바일추가
	Public Fevt_html_mo
	Public Fisweb
	Public Fismobile
	Public Fisapp
	Public Fevt_subname
	Public Fisbookingsell
	Public Fevt_bannerimg_mo
	Public FTemplate_mo

	Public FEsgroup_m

	Public FESlide_M_Flag '//슬라이드 템플릿 MO
	Public FEvt_m_addimg_cnt '//모바일 추가 이미지 카운트

	Public FSidx
	Public FStopimg
	Public FSbtmimg
	Public FStopaddimg
	

	'##### 이벤트 내용 ######
	public Function fnGetEvent
		Dim strSql
		IF 	FECode = "" THEN Exit Function
		FGimg = ""
		strSql ="[db_event].[dbo].sp_Ten_event_content ("&FECode&")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FECode		= rsget("evt_code")
				FEKind		= rsget("evt_kind")
				FEManager 	= rsget("evt_manager")
				FEScope 	= rsget("evt_scope")
				FEName 		= db2html(rsget("evt_name"))
				FESDate 	= rsget("evt_startdate")
				FEEDate 	= rsget("evt_enddate")
				FEState 	= rsget("evt_state")
				FERegdate 	= rsget("evt_regdate")
				FEPDate  	= rsget("evt_prizedate")
   				FECategory 	= rsget("evt_category")
   				FECateMid 	= rsget("evt_cateMid")
   				FSale 		= rsget("issale")
   				FGift 		= rsget("isgift")
   				FCoupon   	= rsget("iscoupon")
   				FComment 	= rsget("iscomment")
   				FBBS	 	= rsget("isbbs")
   				FItemeps 	= rsget("isitemps")
   				FApply 		= rsget("isapply")
   				FTemplate 	= rsget("evt_template")
   				FEMimg 		= rsget("evt_mainimg")
   				FEHtml 		= db2html(rsget("evt_html"))
   				FItemsort 	= rsget("evt_itemsort")
   				FBrand 		= db2html(rsget("brand"))
   				IF FGift THEN FGimg		= rsget("evt_giftimg")
   				FFullYN		= rsget("evt_fullYN")
   				FIteminfoYN	= rsget("evt_iteminfoYN")
   				FLinkEvtCode = rsget("link_evtCode")
   				FblnBlogURL	= rsget("isGetBlogURL")
				FItempriceYN	= rsget("evt_itempriceyn")
				FDateViewYN = rsget("evt_dateview")
				
   				FFBAppid	= rsget("fb_appid")
   				FFBcontent	= rsget("fb_content")
   				FBimg		= rsget("evt_bannerimg")
   				FFavCnt		= rsget("favCnt")
   				FEWideYN	= rsget("evt_wideyn")
   				FEItemID	= rsget("etc_itemid")
   				FEItemImg	= rsget("etc_itemimg")
   				Fbasicimg600 = rsget("basicimage600")
   				Fbasicimg	= rsget("basicimage")
				If rsget("evt_dispCate") = 0 Then
   					FEDispCate	= ""
   				Else
   					FEDispCate	= rsget("evt_dispCate")
   				End If
				FEItemListType		= rsget("evt_itemlisttype")
   				FEmolistbanner		= rsget("evt_mo_listbanner")
				Fevt_html_mo		= rsget("evt_html_mo")
				Fisweb				= rsget("isweb")
				Fismobile			= rsget("ismobile")
				Fisapp				= rsget("isapp")
				Fevt_subname		= rsget("evt_subname")
				Fisbookingsell		= rsget("isbookingsell")
				Fevt_bannerimg_mo	= rsget("evt_bannerimg_mo")
				'//file execute
				FevtFile			= rsget("evt_execFile")
				FevtFile_mo			= rsget("evt_execFile_mo")
				FevtFileyn			= rsget("evt_isExec")
				FevtFileyn_mo		= rsget("evt_isExec_mo")
				FTemplate_mo 		= rsget("evt_template_mo")
				FEMImg_mo			= rsget("evt_mainimg_mo")

				FESlide_M_Flag      = rsget("evt_slide_m_flag")

				FEsgroup_m			= rsget("evt_sgroup_m") '// 이벤트 랜덤 코드

				FEvt_m_addimg_cnt	= rsget("evt_m_addimg_cnt") '// 이벤트 추가 이미지 카운트
   			ELSE
   				FECode = ""
			END IF
		rsget.close
	END Function

	'##### 텍스트 코멘트 2015추가 - 모바일&앱 전용 ######
	public Function fnGetEventTextTitle
		Dim strSql
		IF  FEGCode = "" THEN FEGCode = 0
		strSql ="[db_event].[dbo].sp_Ten_event_mo_textcontent("&FECode&")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventTextTitle = rsget.getRows()
		END IF
		rsget.close
	End Function

	'##### 그룹 내용 ######
	public Function fnGetEventGroup
		Dim strSql
		IF  FEGCode = "" THEN FEGCode = 0
		strSql ="[db_event].[dbo].sp_Ten_eventitem_group("&FECode&","&FEGCode&")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventGroup = rsget.getRows()
		END IF
		rsget.close
	End Function

	'##### 그룹 내용 2015-06-16 모바일 전용 ######
	public Function fnGetEventGroup_mo
		Dim strSql
		IF  FEGCode = "" THEN FEGCode = 0
		strSql ="[db_event].[dbo].sp_Ten_eventitem_group_mo("&FECode&","&FEGCode&") "
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventGroup_mo = rsget.getRows()
		END IF
		rsget.close
	End Function

	'//그룹형 랜덤 1개
	public Function fnGetEventGroupTop
		Dim strSql
		IF  FEGCode = "" THEN FEGCode = 0
		strSql ="[db_event].[dbo].sp_Ten_eventitem_group_top1_mo("&FECode&")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventGroupTop = rsget.getRows()
		END IF
		rsget.close
	End Function

	'##### 최근리스트 10개 ######
	public Function fnGetRecentEvt
		Dim strSql
		strSql ="[db_event].[dbo].sp_Ten_event_top_list ('"&FECategory&"')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetRecentEvt = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'///브랜드데이 최근리스트 20090323 한용민추가 '/street/street_main.asp
	public Function fngetbrandday
		Dim strSql
		strSql ="[db_event].[dbo].sp_Ten_event_brandday "
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fngetbrandday = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'///브랜드데이총리스트 20090423 한용민추가 '/street/street_brandday.asp
	public Function fngetbrandday_list
		Dim strSql
		strSql ="[db_event].[dbo].sp_Ten_event_brandday_all "
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fngetbrandday_list = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'// 브랜드데이인지 체크 20090324 한용민추가  '/street/street_brandday.asp
    public Function fngetbranddaycheck
        dim SqlStr

		SqlStr ="[db_event].[dbo].sp_Ten_event_brandday_all "

		'response.write sqlStr&"<br>"
		rsget.Open SqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

        if rsget.Eof then
			response.write "<script>"
			response.write "alert('브랜드데이 이벤트가 아니거나 종료된 이벤트 입니다');"
			response.write "history.go(-1);"
			response.write "</script>"
			dbget.close()	:	response.End
        end if
        rsget.close
    end Function

	public Function fnGetRedRibbonRecentCode
		Dim strSql
		strSql ="[db_redribbon].[dbo].ten_RecentEvent "
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FECode		= rsget("evt_code")
				FEKind		= rsget("evt_kind")
   			ELSE
   				FECode = ""
   				FEKind = ""
			END IF
		rsget.close
	End Function
	
	public Function fnEventISSUEList
		Dim strSql
		strSql ="[db_event].[dbo].sp_Ten_event_EventISSUE ('" & FECode & "','" & FEKind & "','" & FBrand & "','" & FEDispCate & "' ,'"& FDevice &"')"
		'rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"EVT",strSql,60*30)
        if (rsMem is Nothing) then Exit function ''추가
		IF Not (rsMem.EOF OR rsMem.BOF) THEN
			fnEventISSUEList = rsMem.GetRows()
		END IF
		rsMem.close
	End Function

	'// 슬라이드 템플릿 
	public Function fnGetSlideTemplate_main
		Dim strSql
		IF FECode = "" THEN Exit Function
		strSql = "[db_event].[dbo].[sp_Ten_event_slidetemplate] ("&FECode&", 'M')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FSidx		= rsget("idx")
				FStopimg	= rsget("topimg")
				FSbtmimg	= rsget("btmimg")
				FStopaddimg	= rsget("topaddimg")
   			ELSE
   				FSidx		= ""
				FStopimg	= ""
				FStopaddimg = ""
			END IF
		rsget.close
	END Function

	public Function fnGetSlideTemplate_sub
		Dim strSql
		If FECode = "" THEN Exit Function
		strSql ="[db_event].[dbo].[sp_Ten_event_slidetemplate_addimg] ("&FECode&", 'M')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetSlideTemplate_sub = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'// 이벤트 모바일 추가 배너
	Public Function fnGetMoAddimg
		Dim strSql
		If FECode = "" THEN Exit Function
		strSql ="[db_event].[dbo].[sp_Ten_event_mobile_addimg] ("&FECode&")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetMoAddimg = rsget.GetRows()
		END IF
		rsget.close
	End function

END Class


'----------------------------------------------------
' ClsEvtItem : 상품
'----------------------------------------------------
Class ClsEvtItem
	public FECode   '이벤트 코드
	public FEGCode
	public FEItemCnt
	public FItemsort
	public FTotCnt
	public FItemArr

	public FCategoryPrdList()

	Private Sub Class_Initialize()
		redim preserve FCategoryPrdList(0)
		FTotCnt = 0
		FItemArr = ""
	End Sub

	Private Sub Class_Terminate()

	End Sub

	'##### 상품 리스트 ######
	public Function fnGetEventItem
		Dim strSql, arrItem,intI
		IF FECode = "" THEN Exit Function
		IF FEGCode = "" THEN FEGCode= 0

		strSql ="[db_item].[dbo].sp_Ten_event_GetItem ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&")"
		'//리뉴얼 후 교체 디바이스(1 pc , 2 mobile&app) 추가
		'strSql ="[db_item].[dbo].sp_Ten_event_GetItem_new ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&",2)"

		'response.write strSql &"<br>"
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
				FCategoryPrdList(intI).FItemName    = db2html(arrItem(1,intI))

				FCategoryPrdList(intI).FSellcash    = arrItem(2,intI)
				FCategoryPrdList(intI).FOrgPrice   	= arrItem(3,intI)
				FCategoryPrdList(intI).FMakerId   	= db2html(arrItem(4,intI))
				FCategoryPrdList(intI).FBrandName  	= db2html(arrItem(5,intI))

				FCategoryPrdList(intI).FSellYn      = arrItem(9,intI)
				FCategoryPrdList(intI).FSaleYn     	= arrItem(10,intI)
				FCategoryPrdList(intI).FLimitYn     = arrItem(11,intI)
				FCategoryPrdList(intI).FLimitNo     = arrItem(12,intI)
				FCategoryPrdList(intI).FLimitSold   = arrItem(13,intI)

				FCategoryPrdList(intI).FRegdate 		= arrItem(14,intI)
				FCategoryPrdList(intI).FReipgodate		= arrItem(15,intI)

                FCategoryPrdList(intI).Fitemcouponyn 	= arrItem(16,intI)
				FCategoryPrdList(intI).FItemCouponValue= arrItem(17,intI)
				FCategoryPrdList(intI).Fitemcoupontype	= arrItem(18,intI)

				FCategoryPrdList(intI).Fevalcnt 		= arrItem(19,intI)
				FCategoryPrdList(intI).FitemScore 		= arrItem(20,intI)

				FCategoryPrdList(intI).FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(6,intI)
				FCategoryPrdList(intI).FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(7,intI)
				FCategoryPrdList(intI).FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(8,intI)
				FCategoryPrdList(intI).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(21,intI)
				FCategoryPrdList(intI).FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(22,intI)
				FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(26,intI)
				FCategoryPrdList(intI).FItemSize	= arrItem(23,intI)
				FCategoryPrdList(intI).Fitemdiv		= arrItem(24,intI)
				FCategoryPrdList(intI).FFavCount	= arrItem(28,intI)

			Next
		ELSE
			FTotCnt = -1
		END IF
	End Function

	'##### 상품 리스트 ###### ver2.0버전
	public Function fnGetEventItem_v2
		Dim strSql, arrItem,intI
		IF FECode = "" THEN Exit Function
		IF FEGCode = "" THEN FEGCode= 0

		'strSql ="[db_item].[dbo].sp_Ten_event_GetItem ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&")"
		'//리뉴얼 후 교체 디바이스(1 pc , 2 mobile&app) 추가
		strSql ="[db_item].[dbo].sp_Ten_event_GetItem_new ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&", 2) "

		'response.write strSql &"<br>"
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
				FCategoryPrdList(intI).FItemName    = db2html(arrItem(1,intI))

				FCategoryPrdList(intI).FSellcash    = arrItem(2,intI)
				FCategoryPrdList(intI).FOrgPrice   	= arrItem(3,intI)
				FCategoryPrdList(intI).FMakerId   	= db2html(arrItem(4,intI))
				FCategoryPrdList(intI).FBrandName  	= db2html(arrItem(5,intI))

				FCategoryPrdList(intI).FSellYn      = arrItem(9,intI)
				FCategoryPrdList(intI).FSaleYn     	= arrItem(10,intI)
				FCategoryPrdList(intI).FLimitYn     = arrItem(11,intI)
				FCategoryPrdList(intI).FLimitNo     = arrItem(12,intI)
				FCategoryPrdList(intI).FLimitSold   = arrItem(13,intI)

				FCategoryPrdList(intI).FRegdate 		= arrItem(14,intI)
				FCategoryPrdList(intI).FReipgodate		= arrItem(15,intI)

                FCategoryPrdList(intI).Fitemcouponyn 	= arrItem(16,intI)
				FCategoryPrdList(intI).FItemCouponValue= arrItem(17,intI)
				FCategoryPrdList(intI).Fitemcoupontype	= arrItem(18,intI)

				FCategoryPrdList(intI).Fevalcnt 		= arrItem(19,intI)
				FCategoryPrdList(intI).FitemScore 		= arrItem(20,intI)

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

			Next
		ELSE
			FTotCnt = -1
		END IF
	End Function

	'##### 상품 리스트 ###### 'present brand 전용 2015-06-09 이종화
	public Function fnGetEventItem_present
		Dim strSql, arrItem,intI
		IF FECode = "" THEN Exit Function
		IF FEGCode = "" THEN FEGCode= 0
		strSql ="[db_item].[dbo].sp_Ten_event_GetItem_present ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&")"
		'//리뉴얼 후 교체 디바이스(1 pc , 2 mobile&app) 추가
		'strSql ="[db_item].[dbo].sp_Ten_event_GetItem_new ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&",2)"
		'response.write strSql &"<br>"
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
				FCategoryPrdList(intI).FItemName    = db2html(arrItem(1,intI))

				FCategoryPrdList(intI).FSellcash    = arrItem(2,intI)
				FCategoryPrdList(intI).FOrgPrice   	= arrItem(3,intI)
				FCategoryPrdList(intI).FMakerId   	= db2html(arrItem(4,intI))
				FCategoryPrdList(intI).FBrandName  	= db2html(arrItem(5,intI))

				FCategoryPrdList(intI).FSellYn      = arrItem(9,intI)
				FCategoryPrdList(intI).FSaleYn     	= arrItem(10,intI)
				FCategoryPrdList(intI).FLimitYn     = arrItem(11,intI)
				FCategoryPrdList(intI).FLimitNo     = arrItem(12,intI)
				FCategoryPrdList(intI).FLimitSold   = arrItem(13,intI)

				FCategoryPrdList(intI).FRegdate 		= arrItem(14,intI)
				FCategoryPrdList(intI).FReipgodate		= arrItem(15,intI)

                FCategoryPrdList(intI).Fitemcouponyn 	= arrItem(16,intI)
				FCategoryPrdList(intI).FItemCouponValue= arrItem(17,intI)
				FCategoryPrdList(intI).Fitemcoupontype	= arrItem(18,intI)

				FCategoryPrdList(intI).Fevalcnt 		= arrItem(19,intI)
				FCategoryPrdList(intI).FitemScore 		= arrItem(20,intI)

				FCategoryPrdList(intI).FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(6,intI)
				FCategoryPrdList(intI).FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(7,intI)
				FCategoryPrdList(intI).FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(8,intI)
				FCategoryPrdList(intI).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(21,intI)
				FCategoryPrdList(intI).FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(22,intI)
				FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(26,intI)
				FCategoryPrdList(intI).FItemSize	= arrItem(23,intI)
				FCategoryPrdList(intI).Fitemdiv		= arrItem(24,intI)

			Next
		ELSE
			FTotCnt = -1
		END IF
	End Function

End Class


'----------------------------------------------------
' sbEvtItemView : 상품목록 보여주기 (일반형태)
'----------------------------------------------------
Sub sbEvtItemView
	Dim iEndCnt, intJ

	IF eCode = "" THEN Exit Sub
	intI = 0

	set cEventItem = new ClsEvtItem
	cEventItem.FECode 	= eCode
	cEventItem.FEGCode 	= egCode
	cEventItem.FEItemCnt= itemlimitcnt
	cEventItem.FItemsort= eitemsort
	cEventItem.fnGetEventItem
	iTotCnt = cEventItem.FTotCnt

	IF itemid = "" THEN
		itemid = cEventItem.FItemArr
	ELSE
		itemid = itemid&","&cEventItem.FItemArr
	END IF


	IF (iTotCnt >= 0) THEN
		If eItemListType = "1" Then '### 격자형
			Response.Write "<div class=""evtTypeA"">"
		ElseIf eItemListType = "2" Then '### 리스트형
			Response.Write "<div class=""evtTypeB"">"
		ElseIf eItemListType = "3" Then '### BIG형
			Response.Write "<div class=""evtTypeC"">"
		End If
		
		For intI =0 To iTotCnt
%>
			<% If (intI mod 2) = 0 Then %>
				<div class="evtPdtListWrap">
					<div class="pdtListWrapV15a">
						<ul class="pdtListV15a">
			<% End If %>
							<li onclick="location.href='/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&flag=e';" class="<%=chkiif(cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut,"soldOut","")%>">
								<div class="pPhoto">
									<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %><p><span><em>품절</em></span></p><% End if %>
									<% if (eItemListType = "1") or (eItemListType = "2") then %>
									    <img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
									<% else %>
									    <img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
								    <% end if %>
								<div class="pdtCont">
									<p class="pBrand"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></p>
									<p class="pName"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
										<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
										<% End IF %>
										<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
										<% End IF %>
									<% Else %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
									<% End if %>
								</div>
							</li>
			<% If (intI mod 2) = 1 OR intI = iTotCnt Then %>
						</ul>
					</div>
				</div>
			<% End If %>
<%
		Next
		Response.Write "</div>"
	End IF
End Sub

'----------------------------------------------------
' sbEvtItemView_2015 : 상품목록 보여주기 (일반형태)
' 2015-06-19 ver2.0 이종화
'----------------------------------------------------
Sub sbEvtItemView_2015
	Dim iEndCnt, intJ

	IF eCode = "" THEN Exit Sub
	intI = 0

	set cEventItem = new ClsEvtItem
	cEventItem.FECode 	= eCode
	cEventItem.FEGCode 	= egCode
	cEventItem.FEItemCnt= itemlimitcnt
	cEventItem.FItemsort= eitemsort
	cEventItem.fnGetEventItem_v2
	iTotCnt = cEventItem.FTotCnt

	IF itemid = "" THEN
		itemid = cEventItem.FItemArr
	ELSE
		itemid = itemid&","&cEventItem.FItemArr
	END IF


	IF (iTotCnt >= 0) THEN
		If eItemListType = "1" Then '### 격자형
			Response.Write "<div class=""evtTypeA"">"
		ElseIf eItemListType = "2" Then '### 리스트형
			Response.Write "<div class=""evtTypeB"">"
		ElseIf eItemListType = "3" Then '### BIG형
			Response.Write "<div class=""evtTypeC"">"
		End If

		Response.write "<div class=""pdtListWrapV15a""><ul class=""pdtListV15a"">"
		For intI =0 To iTotCnt
%>
				<li onclick="location.href='/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %><%=logparam%>&flag=e';" class="<%=chkiif(cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut,"soldOut","")%>">
					<div class="pPhoto">
						<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %><p><span><em>품절</em></span></p><% End if %>
						<% if (eItemListType = "1") or (eItemListType = "2") then %>
							<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
						<% else %>
							<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
						<% end if %>
					<div class="pdtCont">
						<p class="pBrand"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></p>
						<p class="pName"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
						<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
							<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
								<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
							<% End IF %>
							<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
								<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
							<% End IF %>
						<% Else %>
							<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
						<% End if %>
						<p class="pShare">
							<span class="cmtView"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).FEvalcnt,0)%></span>
							<span class="wishView" _onclick="TnAddFavoritePrd('<%=cEventItem.FCategoryPrdList(intI).FItemID%>');"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)%></span>
						</p>
					</div>
				</li>
<%
		Next
		Response.write "</ul></div>"
		Response.Write "</div>"
	End IF
End Sub


'----------------------------------------------------
' sbEvtItemView_app : 상품목록 보여주기 (일반형태)
'----------------------------------------------------
Sub sbEvtItemView_app
	Dim iEndCnt, intJ

	IF eCode = "" THEN Exit Sub
	intI = 0

	set cEventItem = new ClsEvtItem
	cEventItem.FECode 	= eCode
	cEventItem.FEGCode 	= egCode
	cEventItem.FEItemCnt= itemlimitcnt
	cEventItem.FItemsort= eitemsort
	cEventItem.fnGetEventItem
	iTotCnt = cEventItem.FTotCnt

	IF itemid = "" THEN
		itemid = cEventItem.FItemArr
	ELSE
		itemid = itemid&","&cEventItem.FItemArr
	END IF


	IF (iTotCnt >= 0) THEN
		If eItemListType = "1" Then '### 격자형
			Response.Write "<div class=""evtTypeA"">"
		ElseIf eItemListType = "2" Then '### 리스트형
			Response.Write "<div class=""evtTypeB"">"
		ElseIf eItemListType = "3" Then '### BIG형
			Response.Write "<div class=""evtTypeC"">"
		End If
		
		For intI =0 To iTotCnt
%>
			<% If (intI mod 2) = 0 Then %>

					<div class="pdtListWrapV15a">
						<ul class="pdtListV15a">
			<% End If %>
							<li onclick="fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %>');"class="<%=chkiif(cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut,"soldOut","")%>">
								<div class="pPhoto">
									<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %><p><span><em>품절</em></span></p><% End if %>
									<% if (eItemListType = "1") or (eItemListType = "2") then %>
									    <% if flgDevice="I" then %>
									    <img src="<% = getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
									    <% else %>
									    <img data-original="<% = getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" src="http://fiximage.10x10.co.kr/web2008/category/blank.gif" class="lazy" /></div>
									    <% end if %>
									<% else %>
									    <% if flgDevice="I" then %>
									    <img src="<% = getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
									    <% else %>
									    <img data-original="<% = getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" src="http://fiximage.10x10.co.kr/web2008/category/blank.gif" class="lazy" /></div>
									    <% end if %>
								    <% end if %>
								<div class="pdtCont">
									<p class="pBrand"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></p>
									<p class="pName"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
										<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
										<% End IF %>
										<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
											<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
										<% End IF %>
									<% Else %>
										<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
									<% End if %>
								</div>
							</li>
			<% If (intI mod 2) = 1 OR intI = iTotCnt Then %>
						</ul>
					</div>

			<% End If %>
<%
		Next
		Response.Write "</div>"
	End IF
End Sub


'----------------------------------------------------
' sbEvtItemView_app_2015 : 상품목록 보여주기 (일반형태)
' 2015-06-19 ver2.0 이종화
'----------------------------------------------------
Sub sbEvtItemView_app_2015
	Dim iEndCnt, intJ

	IF eCode = "" THEN Exit Sub
	intI = 0

	set cEventItem = new ClsEvtItem
	cEventItem.FECode 	= eCode
	cEventItem.FEGCode 	= egCode
	cEventItem.FEItemCnt= itemlimitcnt
	cEventItem.FItemsort= eitemsort
	cEventItem.fnGetEventItem_v2
	iTotCnt = cEventItem.FTotCnt

	IF itemid = "" THEN
		itemid = cEventItem.FItemArr
	ELSE
		itemid = itemid&","&cEventItem.FItemArr
	END IF


	IF (iTotCnt >= 0) THEN
		If eItemListType = "1" Then '### 격자형
			Response.Write "<div class=""evtTypeA"">"
		ElseIf eItemListType = "2" Then '### 리스트형
			Response.Write "<div class=""evtTypeB"">"
		ElseIf eItemListType = "3" Then '### BIG형
			Response.Write "<div class=""evtTypeC"">"
		End If
		
		Response.write "<div class=""pdtListWrapV15a""><ul class=""pdtListV15a"">"
		For intI =0 To iTotCnt
%>
			<li onclick="fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %>');"class="<%=chkiif(cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut,"soldOut","")%>">
				<div class="pPhoto">
					<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %><p><span><em>품절</em></span></p><% End if %>
					<% if (eItemListType = "1") or (eItemListType = "2") then %>
						<% if flgDevice="I" then %>
						<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
						<% else %>
						<img data-original="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" src="http://fiximage.10x10.co.kr/web2008/category/blank.gif" class="lazy" /></div>
						<% end if %>
					<% else %>
						<% if flgDevice="I" then %>
						<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
						<% else %>
						<img data-original="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" src="http://fiximage.10x10.co.kr/web2008/category/blank.gif" class="lazy" /></div>
						<% end if %>
					<% end if %>
				<div class="pdtCont">
					<p class="pBrand"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></p>
					<p class="pName"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
					<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
						<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
							<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
						<% End IF %>
						<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
							<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
						<% End IF %>
					<% Else %>
						<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
					<% End if %>
					<p class="pShare">
						<span class="cmtView"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).FEvalcnt,0)%></span>
						<span class="wishView" _onclick="TnAddFavoritePrd('<%=cEventItem.FCategoryPrdList(intI).FItemID%>');"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)%></span>
					</p>
				</div>
			</li>
<%
		Next
		Response.write "</ul></div>"
		Response.Write "</div>"
	End IF
End Sub

'----------------------------------------------------
' sbSlidetemplate : 슬라이드 템플릿 모바일
' 2016-02-17 이종화
'----------------------------------------------------
Sub sbSlidetemplate

	IF eCode = "" THEN Exit Sub
	
	Dim vSArray , intSL
	'template
	set cEventadd = new ClsEvtCont
	cEventadd.FECode 	= eCode
	cEventadd.fnGetSlideTemplate_main
	'slide
	vSArray = cEventadd.fnGetSlideTemplate_sub

	If cEventadd.FSidx <> "" Then 
%>
	<div class="slideTemplateV15 <% If cEventadd.FStopaddimg <> "" Then %>txtFix<% End If %>">
		<% If cEventadd.FStopimg <> "" Then %>
		<div class="evtTop">
			<img src="<%=cEventadd.FStopimg%>" alt="" />
		</div>
		<% End If %>
		<div class="swiper">
			<% If cEventadd.FStopaddimg <> "" Then %>
			<div class="txt"><img src="<%=cEventadd.FStopaddimg%>" alt="" /></div>
			<% End If %>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<% 
						If isArray(vSArray) THEN 
							For intSL = 0 To UBound(vSArray,2)
					%>
					<div class="swiper-slide"><% If vSArray(4,intSL) <> "" Then %><a href="<%=chkiif(InStr(vSArray(4,intSL),"#group") > 0,Trim(vSArray(4,intSL)),"")%>" onclick="<% If isapp = 1 Then %><% If InStr(vSArray(4,intSL),"#group") > 0 Then %>location.href='<%=Trim(vSArray(4,intSL))%>';<% Else %>fnAPPpopupAutoUrl('<%=Trim(vSArray(4,intSL))%>');<% End If %><% Else %>location.href='<%=Trim(vSArray(4,intSL))%>';<% End If %>return false;"><% End If %><img src="<%=vSArray(3,intSL)%>" alt="" /><% If vSArray(4,intSL) <> "" Then %></a><% End If %></div>
					<%
							Next 
						End If 
					%>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="slideNav btnPrev">이전</button>
			<button type="button" class="slideNav btnNext">다음</button>
		</div>
		<% If cEventadd.FSbtmimg <> "" Then %>
		<div class="evtBtm">
			<img src="<%=cEventadd.FSbtmimg%>" alt="" />
		</div>
		<% End If %>
	</div>
<%
	End If 
End Sub
%>