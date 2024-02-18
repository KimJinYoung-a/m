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
	public FBlogURL
	public FBBS
	public FItemeps
	public FApply
	public FTemplate
	public FEMimg
	public FEHtml
	public FItemsort
	public FBrand
	public FGimg
	public FFullYN
	public FIteminfoYN
	public frectekind
	public FFBAppid
	public FFBcontent
	public FBimg
	public FFavCnt
	public FEDispCate
	public FEWideYN
	public FEItemID
	public FEItemImg
	public Fbasicimg600
	public Fbasicimg
	Public FevtFile
	Public FevtFileyn

	Public FItempriceYN '상품 가격
	Public FDateViewYN

	'//2015 리뉴얼추가
	Public Fisweb
	Public Fismobile
	Public Fisapp
	public FEmolistbanner '//모바일 리스트 이미지 PC에도 쓸 예정
	public FEvt_subcopyK '//PC용 서브카피

	Public FEsgroup_w

	Public FESlide_W_Flag '//슬라이드 템플릿 PC flag

	public FSidx 
	public FStopimg
	public FSbtmYN
	public FSbtmimg
	public FSbtmcode
	public FStopaddimg 
	public FSbtmaddimg
	public FSpcadd1
	public FSgubun
	public FevtType

	'MD등록 이벤트 추가
	public Fmdtheme
	public Fthemecolor
	public Ftextbgcolor
	public Fmdbntype
	public Fcomm_isusing
	public Fcomm_text
	public Ffreebie_img
	public Fcomm_start
	public Fcomm_end
	public Fgift_isusing
	public Fgift_text1
	public Fgift_img1
	public Fgift_text2
	public Fgift_img2
	public Fgift_text3
	public Fgift_img3
	public Fusinginfo
	public Fusing_text1
	public Fusing_contents1
	public Fusing_text2
	public Fusing_contents2
	public Fusing_text3
	public Fusing_contents3
	public FsalePer
	public FsaleCPer
	public FSocName_Kor

	public Function fnEventColorCode
		If FECode > "79054" Then
			If Fthemecolor="1" Then
				fnEventColorCode = "#ed6c6c"
			ElseIf Fthemecolor="2" Then
				fnEventColorCode = "#f385af"
			ElseIf Fthemecolor="3" Then
				fnEventColorCode = "#f3a056"
			ElseIf Fthemecolor="4" Then
				fnEventColorCode = "#e7b93c"
			ElseIf Fthemecolor="5" Then
				fnEventColorCode = "#8eba4a"
			ElseIf Fthemecolor="6" Then
				fnEventColorCode = "#43a251"
			ElseIf Fthemecolor="7" Then
				fnEventColorCode = "#50bdd1"
			ElseIf Fthemecolor="8" Then
				fnEventColorCode = "#5aa5ea"
			ElseIf Fthemecolor="9" Then
				fnEventColorCode = "#2672bf"
			ElseIf Fthemecolor="10" Then
				fnEventColorCode = "#2c5a85"
			ElseIf Fthemecolor="11" Then
				fnEventColorCode = "#848484"
			Else
				fnEventColorCode = "#848484"
			End If
		Else
			If Fthemecolor="1" Then
				fnEventColorCode = "#c80e0e"
			ElseIf Fthemecolor="2" Then
				fnEventColorCode = "#274e87"
			ElseIf Fthemecolor="3" Then
				fnEventColorCode = "#9457a1"
			ElseIf Fthemecolor="4" Then
				fnEventColorCode = "#ea5b8d"
			ElseIf Fthemecolor="5" Then
				fnEventColorCode = "#e24343"
			ElseIf Fthemecolor="6" Then
				fnEventColorCode = "#9b613d"
			ElseIf Fthemecolor="7" Then
				fnEventColorCode = "#f08527"
			ElseIf Fthemecolor="8" Then
				fnEventColorCode = "#5eb041"
			ElseIf Fthemecolor="9" Then
				fnEventColorCode = "#209f6e"
			ElseIf Fthemecolor="10" Then
				fnEventColorCode = "#e4569c"
			ElseIf Fthemecolor="11" Then
				fnEventColorCode = "#3593d4"
			Else
				fnEventColorCode = "#ffffff"
			End If
		End If
	End Function

	public Function fnEventBarColorCode
		If FECode > "79054" Then
			If Fthemecolor="1" Then
				fnEventBarColorCode = "#cb4848"
			ElseIf Fthemecolor="2" Then
				fnEventBarColorCode = "#d55787"
			ElseIf Fthemecolor="3" Then
				fnEventBarColorCode = "#e37f35"
			ElseIf Fthemecolor="4" Then
				fnEventBarColorCode = "#ce8d00"
			ElseIf Fthemecolor="5" Then
				fnEventBarColorCode = "#699426"
			ElseIf Fthemecolor="6" Then
				fnEventBarColorCode = "#358240"
			ElseIf Fthemecolor="7" Then
				fnEventBarColorCode = "#2899ae"
			ElseIf Fthemecolor="8" Then
				fnEventBarColorCode = "#2f7cc3"
			ElseIf Fthemecolor="9" Then
				fnEventBarColorCode = "#145290"
			ElseIf Fthemecolor="10" Then
				fnEventBarColorCode = "#1c3e5d"
			ElseIf Fthemecolor="11" Then
				fnEventBarColorCode = "#656565"
			Else
				fnEventBarColorCode = "#656565"
			End If
		Else
			If Fmdtheme="1" Then
				If Fthemecolor="1" Then
					fnEventBarColorCode = "#f5742f"
				ElseIf Fthemecolor="2" Then
					fnEventBarColorCode = "#e2b500"
				ElseIf Fthemecolor="3" Then
					fnEventBarColorCode = "#6db003"
				ElseIf Fthemecolor="4" Then
					fnEventBarColorCode = "#79811"
				ElseIf Fthemecolor="5" Then
					fnEventBarColorCode = "#0e6d78"
				ElseIf Fthemecolor="6" Then
					fnEventBarColorCode = "#209ed2"
				ElseIf Fthemecolor="7" Then
					fnEventBarColorCode = "#1e5dd0"
				ElseIf Fthemecolor="8" Then
					fnEventBarColorCode = "#1e3b8e"
				ElseIf Fthemecolor="9" Then
					fnEventBarColorCode = "#7653ce"
				ElseIf Fthemecolor="10" Then
					fnEventBarColorCode = "#e4569c"
				Else
					fnEventBarColorCode = "#656565"
				End If
			ElseIf Fmdtheme="2" Then
				If Fthemecolor="1" Then
					fnEventBarColorCode = "#c80e0e"
				ElseIf Fthemecolor="2" Then
					fnEventBarColorCode = "#274e87"
				ElseIf Fthemecolor="3" Then
					fnEventBarColorCode = "#9457a1"
				ElseIf Fthemecolor="4" Then
					fnEventBarColorCode = "#ea5b8d"
				ElseIf Fthemecolor="5" Then
					fnEventBarColorCode = "#e24343"
				ElseIf Fthemecolor="6" Then
					fnEventBarColorCode = "#9b613d"
				ElseIf Fthemecolor="7" Then
					fnEventBarColorCode = "#f08527"
				ElseIf Fthemecolor="8" Then
					fnEventBarColorCode = "#5eb041"
				ElseIf Fthemecolor="9" Then
					fnEventBarColorCode = "#209f6e"
				ElseIf Fthemecolor="10" Then
					fnEventBarColorCode = "#e4569c"
				ElseIf Fthemecolor="11" Then
					fnEventBarColorCode = "#3593d4"
				Else
					fnEventBarColorCode = "#656565"
				End If
			Else
				If Fthemecolor="1" Then
					fnEventBarColorCode = "#2e2e2e"
				ElseIf Fthemecolor="2" Then
					fnEventBarColorCode = "#102d58"
				ElseIf Fthemecolor="3" Then
					fnEventBarColorCode = "#5d2869"
				ElseIf Fthemecolor="4" Then
					fnEventBarColorCode = "#bf1f57"
				ElseIf Fthemecolor="5" Then
					fnEventBarColorCode = "#b01b1b"
				ElseIf Fthemecolor="6" Then
					fnEventBarColorCode = "#693718"
				ElseIf Fthemecolor="7" Then
					fnEventBarColorCode = "#df5834"
				ElseIf Fthemecolor="8" Then
					fnEventBarColorCode = "#267909"
				ElseIf Fthemecolor="9" Then
					fnEventBarColorCode = "#26941"
				ElseIf Fthemecolor="10" Then
					fnEventBarColorCode = "#007c7e"
				ElseIf Fthemecolor="11" Then
					fnEventBarColorCode = "#0c69aa"
				Else
					fnEventBarColorCode = "#656565"
				End If
			End If
		End If
	End Function

	'// 이벤트 유형 변환
	public Function fnEventTypeName
		Select Case FevtType
			Case "10":  fnEventTypeName = "A"
			Case "20":  fnEventTypeName = "B"
			Case "30":  fnEventTypeName = "C"
			Case "40":  fnEventTypeName = "D"
			Case "70":  fnEventTypeName = "E"
			Case "60":  fnEventTypeName = "F"
			Case "50":  fnEventTypeName = "G"
			Case "80":  fnEventTypeName = "H"
			Case Else : fnEventTypeName = ""
		end Select
	end function

	'##### 이벤트 내용 ######
	public Function fnGetEvent
		Dim strSql
		IF 	FECode = "" THEN Exit Function
		FGimg = ""
		strSql ="[db_event].[dbo].sp_Ten_event_content_New ("&FECode&")"
'		Response.write strSql
'		Response.end
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
   				FBlogURL	= rsget("isGetBlogURL")
   				FBBS	 	= rsget("isbbs")
   				FItemeps 	= rsget("isitemps")
   				FApply 		= rsget("isapply")
   				FTemplate 	= rsget("evt_template")
   				FEMimg 		= rsget("evt_mainimg")
   				FEHtml 		= db2html(rsget("evt_html"))
   				FItemsort 	= rsget("evt_itemsort")
   				FBrand 		= db2html(rsget("brand"))
				FSocName_Kor= db2html(rsget("socname_kor"))
   				IF FGift THEN FGimg		= rsget("evt_giftimg")
   				FFullYN		= rsget("evt_fullYN")
   				FIteminfoYN	= rsget("evt_iteminfoYN")
   				FFBAppid	= rsget("fb_appid")
   				FFBcontent	= rsget("fb_content")
   				FBimg		= rsget("evt_bannerimg")
   				FItempriceYN	= rsget("evt_itempriceyn")
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
   				FDateViewYN = rsget("evt_dateview")

				FevtFile			= rsget("evt_execFile")
				FevtFileyn			= rsget("evt_isExec")
				Fisweb				= rsget("isweb")
				Fismobile			= rsget("ismobile")
				Fisapp				= rsget("isapp")
				FEmolistbanner		= rsget("evt_mo_listbanner")
				FEvt_subcopyK		= rsget("evt_subcopyK")

				FESlide_W_Flag       = rsget("evt_slide_w_flag")

				FEsgroup_w		= rsget("evt_sgroup_w") '// 이벤트 랜덤 코드
				
				FsalePer = rsget("salePer")
				FsaleCPer = rsget("saleCPer")
				Fmdtheme = rsget("mdtheme")
				Fthemecolor = rsget("themecolor")
				Ftextbgcolor = rsget("textbgcolor")
				Fmdbntype = rsget("mdbntype")
				Fcomm_isusing = rsget("comm_isusing")
				Fcomm_text = rsget("comm_text")
				Ffreebie_img = rsget("freebie_img")
				Fcomm_start = rsget("comm_start")
				Fcomm_end = rsget("comm_end")
				Fgift_isusing = rsget("gift_isusing")
				Fgift_text1 = rsget("gift_text1")
				Fgift_img1 = rsget("gift_img1")
				Fgift_text2 = rsget("gift_text2")
				Fgift_img2 = rsget("gift_img2")
				Fgift_text3 = rsget("gift_text3")
				Fgift_img3 = rsget("gift_img3")
				Fusinginfo = rsget("usinginfo")
				Fusing_text1 = rsget("using_text1")
				Fusing_contents1 = rsget("using_contents1")
				Fusing_text2 = rsget("using_text2")
				Fusing_contents2 = rsget("using_contents2")
				Fusing_text3 = rsget("using_text3")
				Fusing_contents3 = rsget("using_contents3")
				FevtType = rsget("evt_type")
   			ELSE
   				FECode = ""
			END IF
		rsget.close
	END Function

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

	public Function fnGetEventGpcode0
		Dim strSql
		IF  FEGCode = "" THEN FEGCode = 0
		strSql ="[db_event].[dbo].sp_Ten_eventitem_grouppcode0("&FECode&")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventGpcode0 = rsget.getRows()
		END IF
		rsget.close
	End Function

	'//그룹형 랜덤 1개
	public Function fnGetEventGroupTop
		Dim strSql
		IF  FEGCode = "" THEN FEGCode = 0
		strSql ="[db_event].[dbo].sp_Ten_eventitem_group_top1("&FECode&")"
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
	
	''최근리스트 _캐시 /2015/04/03
	public Function fnGetRecentEvt_Cache
		Dim strSql
		strSql ="[db_event].[dbo].sp_Ten_event_top_list ('"&FECategory&"')"
		''rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"EVTRCT",strSql,60*5)
        if (rsMem is Nothing) then Exit function ''추가

		IF Not (rsMem.EOF OR rsMem.BOF) THEN
			fnGetRecentEvt_Cache = rsMem.GetRows()
		END IF
		rsMem.close
	End Function
	
	'///브랜드데이 최근리스트 20090323 한용민추가 '/street/index.asp
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

	'//기프트 플러스용 '/giftplus/giftplus_event.asp 2010.04.06 한용민 추가
	public Function fnGetRedRibbonRecentCode
		Dim strSql
		
		strSql ="[db_giftplus].[dbo].ten_giftplus_RecentEvent ('"&frectekind&"') "
		
		'response.write strSql &"<br>"
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

	'// 슬라이드 템플릿 
	public Function fnGetSlideTemplate_main
		Dim strSql
		IF FECode = "" THEN Exit Function
		strSql = "[db_event].[dbo].[sp_Ten_event_slidetemplate] ("&FECode&", 'W')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FSidx		= rsget("idx")
				FStopimg	= rsget("topimg")
				FSbtmYN		= rsget("btmYN")
				FSbtmimg	= rsget("btmimg")
				FSbtmcode	= rsget("btmcode")
				FStopaddimg	= rsget("topaddimg")
				FSbtmaddimg = rsget("btmaddimg")
				FSpcadd1	= rsget("pcadd1")
				FSgubun		= rsget("gubun")
   			ELSE
   				FSidx		= ""
				FStopimg	= ""
				FSbtmYN		= ""
				FSbtmimg	= ""
				FSbtmcode	= ""
				FStopaddimg = ""
				FSbtmaddimg = ""
				FSpcadd1	= ""
				FSgubun		= ""
			END IF
		rsget.close
	END Function

	public Function fnGetSlideTemplate_sub
		Dim strSql
		If FECode = "" THEN Exit Function
		strSql ="[db_event].[dbo].[sp_Ten_event_slidetemplate_addimg] ("&FECode&", 'W')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetSlideTemplate_sub = rsget.GetRows()
		Else
			
		END IF
		rsget.close
	End Function

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
	public FResultCount

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
		'//리뉴얼 교체 디바이스(1 pc , 2 mobile&app) 추가
		'strSql ="[db_item].[dbo].sp_Ten_event_GetItem ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&")"
		strSql ="[db_item].[dbo].sp_Ten_event_GetItem_new ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&",1)"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			arrItem = rsget.GetRows()
		END IF
		rsget.close

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
				FCategoryPrdList(intI).FItemCouponValue	= arrItem(17,intI)
				FCategoryPrdList(intI).Fitemcoupontype	= arrItem(18,intI)

				FCategoryPrdList(intI).Fevalcnt 		= arrItem(19,intI)
				FCategoryPrdList(intI).FitemScore 		= arrItem(20,intI)

				FCategoryPrdList(intI).FImageList		= "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(6,intI)
				FCategoryPrdList(intI).FImageList120	= "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(7,intI)
				FCategoryPrdList(intI).FImageSmall		= "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(8,intI)
				FCategoryPrdList(intI).FImageIcon1		= "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(21,intI)
				FCategoryPrdList(intI).FImageIcon2		= "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(22,intI)
				FCategoryPrdList(intI).FItemSize		= arrItem(23,intI)
				FCategoryPrdList(intI).Fitemdiv			= arrItem(24,intI)
				FCategoryPrdList(intI).FImageBasic		= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(26,intI)
				FCategoryPrdList(intI).FImageBasic600	= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(27,intI)
				FCategoryPrdList(intI).FfavCount		= arrItem(28,intI)

				If arrItem(29,intI) <> "" then
				FCategoryPrdList(intI).FAddImage		= "http://webimage.10x10.co.kr/image/add1/" & GetImageSubFolderByItemid(arrItem(0,intI)) & "/" & db2html(arrItem(29,intI))
				End if

				If Not(arrItem(31,intI)="" Or isnull(arrItem(31,intI))) Then 
					FCategoryPrdList(intI).Ftentenimage	= "http://webimage.10x10.co.kr/image/tenten/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(31,intI)
					FCategoryPrdList(intI).Ftentenimage50	= "http://webimage.10x10.co.kr/image/tenten50/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(32,intI)
					FCategoryPrdList(intI).Ftentenimage200	= "http://testwebimage.10x10.co.kr/image/tenten200/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(33,intI)
					FCategoryPrdList(intI).Ftentenimage400	= "http://testwebimage.10x10.co.kr/image/tenten400/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(34,intI)
					FCategoryPrdList(intI).Ftentenimage600	= "http://webimage.10x10.co.kr/image/tenten600/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(35,intI)
					FCategoryPrdList(intI).Ftentenimage1000	= "http://webimage.10x10.co.kr/image/tenten1000/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(36,intI)
				End If


			Next
		ELSE
			FTotCnt = -1
		END IF
	End Function

	Public sub fnGetMDSlideTemplate_sub()
		Dim i, strSql
		'// 추천상품 목록접수
		strSql = "Select top 5 i.basicimage, i.itemid"
		strSql = strSql & " from [db_event].[dbo].[tbl_event_itembanner] e"
		strSql = strSql & "	join [db_item].[dbo].tbl_item i "
		strSql = strSql & "	on e.itemid = i.itemid"
		strSql = strSql & " where 1 = 1 "
		strSql = strSql & "	and e.evt_code=" & CStr(FECode)
		strSql = strSql & "	and e.sdiv='w'"
		strSql = strSql & " order by e.viewidx asc"
		''response.Write strSql
		rsget.Open strSql, dbget, 1

		FResultCount = rsget.RecordCount
		redim preserve FCategoryPrdList(FResultCount)

		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FCategoryPrdList(i) = new CCategoryPrdItem
				FCategoryPrdList(i).FImageList		= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	End Sub

End Class


'----------------------------------------------------
' sbEvtItemView : 상품목록 보여주기
'----------------------------------------------------
Sub sbEvtItemView
	Dim intIx, sBadges

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
	END If
	
	intI = 0
	'// 이미지 사이즈가 큰경우(200px) 먼저 표시(2008.10.20; 허진원)
	IF (iTotCnt >= 0) THEN
		if cEventItem.FCategoryPrdList(0).FItemSize="2" or cEventItem.FCategoryPrdList(0).FItemSize="200" Then
			IF blnItemifno THEN 
			%>
			<div class="pdtWrap pdt400V15">
				<ul class="pdtList">
			<%
				For intI =0 To iTotCnt
					'큰이미지가 끝나면 출력 종료
					if cEventItem.FCategoryPrdList(intI).FItemSize="1" or cEventItem.FCategoryPrdList(intI).FItemSize="100" or cEventItem.FCategoryPrdList(intI).FItemSize="150" or cEventItem.FCategoryPrdList(intI).FItemSize="155" or cEventItem.FCategoryPrdList(intI).FItemSize="160" then Exit For
			%>
					<li <%=chkIIF(cEventItem.FCategoryPrdList(intI).isSoldOut," class=""soldOut""","")%>>
					<div class="pdtBox">
						<div class="pdtPhoto">
							<a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><span class="soldOutMask"></span><% if Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)) Then %> <img src="<%=cEventItem.FCategoryPrdList(intI).Ftentenimage400%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% Else %> <img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,"400","400","true","false")%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% End If %> <% if cEventItem.FCategoryPrdList(intI).FAddimage<>"" then %><dfn><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FAddimage,"400","400","true","false")%>" alt="<%=Replace(cEventItem.FCategoryPrdList(intI).FItemName,"""","")%>" /></dfn><% end if %></a>
						</div>
						<div class="pdtInfo">
							<p class="pdtBrand tPad20"><a href="/street/street_brand.asp?makerid=<%=cEventItem.FCategoryPrdList(intI).FMakerId %>"><%=cEventItem.FCategoryPrdList(intI).FBrandName %></a></p>
							<p class="pdtName tPad07"><a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><%=cEventItem.FCategoryPrdList(intI).FItemName%></a></p>
							<% If blnitempriceyn = "1" Then %>
							<% Else %>
								<% if cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem then %>
									<p class="pdtPrice"><span class="txtML"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0)%>원</span></p>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0)%>원</span> <strong class="cRd0V15">[<%=cEventItem.FCategoryPrdList(intI).getSalePro%>]</strong></p>
									<% End If %>
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<% if Not(cEventItem.FCategoryPrdList(intI).IsFreeBeasongCoupon() or cEventItem.FCategoryPrdList(intI).IsSaleItem) Then %>
									<p class="pdtPrice"><span class="txtML"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0)%>원</span></p>
										<% end If %>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0)%>원</span> <strong class="cGr0V15">[<%=cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr%>]</strong></p>
									<% End If %>
								<% Else %>
								<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & chkIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem,"Point","원")%></span></p>
								<% End If %>
							<p class="pdtStTag tPad10">
								<% IF cEventItem.FCategoryPrdList(intI).isSoldOut Then %>
									<img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_soldout.gif" alt="SOLDOUT" />
								<% else %>
									<% IF cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_soldout.gif" alt="SOLDOUT" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isSaleItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_sale.gif" alt="SALE" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isCouponItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_coupon.gif" alt="쿠폰" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isLimitItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_limited.gif" alt="한정" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).IsTenOnlyitem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_only.gif" alt="ONLY" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isNewItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_new.gif" alt="NEW" /> <% end if %>
								<% end if %>
							</p>
							<% End If %>
						</div>
						<ul class="pdtActionV15">
							<li class="largeView"><a href="" onclick="ZoomItemInfo('<%=cEventItem.FCategoryPrdList(intI).FItemid %>'); return false;"><img src="http://fiximage.10x10.co.kr/web2015/common/btn_quick.png" alt="QUICK" /></a></li>
							<li class="postView"><a href="" <%=chkIIF(cEventItem.FCategoryPrdList(intI).Fevalcnt>0,"onclick=""popEvaluate('" & cEventItem.FCategoryPrdList(intI).FItemid & "');return false;""","onclick=""return false;""")%>><span><%=cEventItem.FCategoryPrdList(intI).Fevalcnt%></span></a></li>
							<li class="wishView"><a href="" onclick="TnAddFavorite('<%=cEventItem.FCategoryPrdList(intI).FItemid %>');return false;"><span><%=cEventItem.FCategoryPrdList(intI).FfavCount%></span></a></li>
						</ul>
					</div>
					</li>
			<%
					set cEventItem.FCategoryPrdList(intI) = nothing
				Next
			%>
				</ul>
			</div>
		 <% Else %>
			<div class="pdtWrap pdt400V15">
				<ul class="pdtList">
			<%
				For intI =0 To iTotCnt
					if cEventItem.FCategoryPrdList(intI).FItemSize="1" or cEventItem.FCategoryPrdList(intI).FItemSize="100" or cEventItem.FCategoryPrdList(intI).FItemSize="150" or cEventItem.FCategoryPrdList(intI).FItemSize="155" or cEventItem.FCategoryPrdList(intI).FItemSize="160" then Exit For
			%>
					<li <%=chkIIF(cEventItem.FCategoryPrdList(intI).isSoldOut," class=""soldOut""","")%>>
						<div class="pdtBox">
							<div class="pdtPhoto">
								<a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><span class="soldOutMask"></span><% if Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)) Then %> <img src="<%=cEventItem.FCategoryPrdList(intI).Ftentenimage400%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% Else %> <img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,"400","400","true","false")%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% End If %> <% if cEventItem.FCategoryPrdList(intI).FAddimage<>"" then %><dfn><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FAddimage,"400","400","true","false")%>" alt="<%=Replace(cEventItem.FCategoryPrdList(intI).FItemName,"""","")%>" /></dfn><% end if %></a>
							</div>
						</div>
					</li>
			<%
					Set cEventItem.FCategoryPrdList(intI) = nothing
				Next 
			%>
				</ul>
			</div>
<%
			End If
		end if
	end If
	
	'// 이미지 사이즈가 중간일경우(320px) 표시(2015-04-01; 이종화) 추가
	intIx = intI

	IF (iTotCnt >= intIx) THEN
		if cEventItem.FCategoryPrdList(intI).FItemSize="160" then
			IF blnItemifno THEN 
			%>
			<div class="pdtWrap pdt320V15">
				<ul class="pdtList">
			<%
				For intI = intIx To iTotCnt
			
					'중간이미지가 끝나면 출력 종료
					if cEventItem.FCategoryPrdList(intI).FItemSize="1" or cEventItem.FCategoryPrdList(intI).FItemSize="100" or cEventItem.FCategoryPrdList(intI).FItemSize="150" or cEventItem.FCategoryPrdList(intI).FItemSize="155" then Exit For
			%>
					<li <%=chkIIF(cEventItem.FCategoryPrdList(intI).isSoldOut," class=""soldOut""","")%>>
					<div class="pdtBox">
						<div class="pdtPhoto">
							<a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><span class="soldOutMask"></span><% if Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)) Then %> <img src="<%=cEventItem.FCategoryPrdList(intI).Ftentenimage400%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% Else %> <img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,"320","320","true","false")%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% End If %> <% if cEventItem.FCategoryPrdList(intI).FAddimage<>"" then %><dfn><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FAddimage,"320","320","true","false")%>" alt="<%=Replace(cEventItem.FCategoryPrdList(intI).FItemName,"""","")%>" /></dfn><% end if %></a>
						</div>
						<div class="pdtInfo">
							<p class="pdtBrand tPad20"><a href="/street/street_brand.asp?makerid=<%=cEventItem.FCategoryPrdList(intI).FMakerId %>"><%=cEventItem.FCategoryPrdList(intI).FBrandName %></a></p>
							<p class="pdtName tPad07"><a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><%=cEventItem.FCategoryPrdList(intI).FItemName%></a></p>
							<% If blnitempriceyn = "1" Then %>
							<% Else %>
								<% if cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem then %>
									<p class="pdtPrice"><span class="txtML"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0)%>원</span></p>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0)%>원</span> <strong class="cRd0V15">[<%=cEventItem.FCategoryPrdList(intI).getSalePro%>]</strong></p>
									<% End If %>
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<% if Not(cEventItem.FCategoryPrdList(intI).IsFreeBeasongCoupon() or cEventItem.FCategoryPrdList(intI).IsSaleItem) Then %>
									<p class="pdtPrice"><span class="txtML"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0)%>원</span></p>
										<% end If %>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0)%>원</span> <strong class="cGr0V15">[<%=cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr%>]</strong></p>
									<% End If %>
								<% Else %>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & chkIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem,"Point","원")%></span></p>
								<% End If %>
							<p class="pdtStTag tPad10">
								<% IF cEventItem.FCategoryPrdList(intI).isSoldOut Then %>
									<img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_soldout.gif" alt="SOLDOUT" />
								<% else %>
									<% IF cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_soldout.gif" alt="SOLDOUT" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isSaleItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_sale.gif" alt="SALE" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isCouponItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_coupon.gif" alt="쿠폰" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isLimitItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_limited.gif" alt="한정" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).IsTenOnlyitem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_only.gif" alt="ONLY" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isNewItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_new.gif" alt="NEW" /> <% end if %>
								<% end if %>
							</p>
							<% End If %>
						</div>
						<ul class="pdtActionV15">
							<li class="largeView"><a href="" onclick="ZoomItemInfo('<%=cEventItem.FCategoryPrdList(intI).FItemid %>'); return false;"><img src="http://fiximage.10x10.co.kr/web2015/common/btn_quick.png" alt="QUICK" /></a></li>
							<li class="postView"><a href="" <%=chkIIF(cEventItem.FCategoryPrdList(intI).Fevalcnt>0,"onclick=""popEvaluate('" & cEventItem.FCategoryPrdList(intI).FItemid & "');return false;""","onclick=""return false;""")%>><span><%=FormatNumber(cEventItem.FCategoryPrdList(intI).Fevalcnt,0)%></span></a></li>
							<li class="wishView"><a href="" onclick="TnAddFavorite('<%=cEventItem.FCategoryPrdList(intI).FItemid %>');return false;"><span><%=FormatNumber(cEventItem.FCategoryPrdList(intI).FfavCount,0)%></span></a></li>
						</ul>
					</div>
					</li>
			<%
					set cEventItem.FCategoryPrdList(intI) = nothing
				Next
			%>
				</ul>
			</div>
		 <% Else %>
			<div class="pdtWrap pdt320V15">
				<ul class="pdtList">
			<%
				For intI =intIx To iTotCnt
					if cEventItem.FCategoryPrdList(intI).FItemSize="1" or cEventItem.FCategoryPrdList(intI).FItemSize="100" or cEventItem.FCategoryPrdList(intI).FItemSize="150" or cEventItem.FCategoryPrdList(intI).FItemSize="155" then Exit For
			%>
					<li <%=chkIIF(cEventItem.FCategoryPrdList(intI).isSoldOut," class=""soldOut""","")%>>
						<div class="pdtBox">
							<div class="pdtPhoto">
								<a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><span class="soldOutMask"></span><% if Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)) Then %> <img src="<%=cEventItem.FCategoryPrdList(intI).Ftentenimage400%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% Else %> <img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,"320","320","true","false")%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% End If %> <% if cEventItem.FCategoryPrdList(intI).FAddimage<>"" then %><dfn><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FAddimage,"320","320","true","false")%>" alt="<%=Replace(cEventItem.FCategoryPrdList(intI).FItemName,"""","")%>" /></dfn><% end if %></a>
							</div>
						</div>
					</li>
			<%
					Set cEventItem.FCategoryPrdList(intI) = nothing
				Next 
			%>
				</ul>
			</div>
<%
			End If
		end if
	end If
	
	'// 이미지 사이즈가 중간일경우(270px) 표시(2015-04-01; 이종화 추가)
	intIx = intI

	IF (iTotCnt >= intIx) THEN
		if cEventItem.FCategoryPrdList(intI).FItemSize="155" then
			IF blnItemifno THEN 
			%>
			<div class="pdtWrap pdt270V15">
				<ul class="pdtList">
			<%
				For intI = intIx To iTotCnt
			
					'중간이미지가 끝나면 출력 종료
					if cEventItem.FCategoryPrdList(intI).FItemSize="1" or cEventItem.FCategoryPrdList(intI).FItemSize="100" or cEventItem.FCategoryPrdList(intI).FItemSize="150" then Exit For
			%>
					<li <%=chkIIF(cEventItem.FCategoryPrdList(intI).isSoldOut," class=""soldOut""","")%>>
					<div class="pdtBox">
						<div class="pdtPhoto">
							<a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><span class="soldOutMask"></span><% if Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)) Then %> <img src="<%=cEventItem.FCategoryPrdList(intI).Ftentenimage400%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% Else %> <img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,"270","270","true","false")%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% End If %> <% if cEventItem.FCategoryPrdList(intI).FAddimage<>"" then %><dfn><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FAddimage,"270","270","true","false")%>" alt="<%=Replace(cEventItem.FCategoryPrdList(intI).FItemName,"""","")%>" /></dfn><% end if %></a>
						</div>
						<div class="pdtInfo">
							<p class="pdtBrand tPad20"><a href="/street/street_brand.asp?makerid=<%=cEventItem.FCategoryPrdList(intI).FMakerId %>"><%=cEventItem.FCategoryPrdList(intI).FBrandName %></a></p>
							<p class="pdtName tPad07"><a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><%=cEventItem.FCategoryPrdList(intI).FItemName%></a></p>
							<% If blnitempriceyn = "1" Then %>
							<% Else %>
								<% if cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem then %>
									<p class="pdtPrice"><span class="txtML"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0)%>원</span></p>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0)%>원</span> <strong class="cRd0V15">[<%=cEventItem.FCategoryPrdList(intI).getSalePro%>]</strong></p>
									<% End If %>
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<% if Not(cEventItem.FCategoryPrdList(intI).IsFreeBeasongCoupon() or cEventItem.FCategoryPrdList(intI).IsSaleItem) Then %>
									<p class="pdtPrice"><span class="txtML"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0)%>원</span></p>
										<% end If %>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0)%>원</span> <strong class="cGr0V15">[<%=cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr%>]</strong></p>
									<% End If %>
								<% Else %>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & chkIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem,"Point","원")%></span></p>
								<% End If %>
							<p class="pdtStTag tPad10">
								<% IF cEventItem.FCategoryPrdList(intI).isSoldOut Then %>
									<img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_soldout.gif" alt="SOLDOUT" />
								<% else %>
									<% IF cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_soldout.gif" alt="SOLDOUT" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isSaleItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_sale.gif" alt="SALE" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isCouponItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_coupon.gif" alt="쿠폰" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isLimitItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_limited.gif" alt="한정" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).IsTenOnlyitem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_only.gif" alt="ONLY" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isNewItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_new.gif" alt="NEW" /> <% end if %>
								<% end if %>
							</p>
							<% End If %>
						</div>
						<ul class="pdtActionV15">
							<li class="largeView"><a href="" onclick="ZoomItemInfo('<%=cEventItem.FCategoryPrdList(intI).FItemid %>'); return false;"><img src="http://fiximage.10x10.co.kr/web2015/common/btn_quick.png" alt="QUICK" /></a></li>
							<li class="postView"><a href="" <%=chkIIF(cEventItem.FCategoryPrdList(intI).Fevalcnt>0,"onclick=""popEvaluate('" & cEventItem.FCategoryPrdList(intI).FItemid & "');return false;""","onclick=""return false;""")%>><span><%=FormatNumber(cEventItem.FCategoryPrdList(intI).Fevalcnt,0)%></span></a></li>
							<li class="wishView"><a href="" onclick="TnAddFavorite('<%=cEventItem.FCategoryPrdList(intI).FItemid %>');return false;"><span><%=FormatNumber(cEventItem.FCategoryPrdList(intI).FfavCount,0)%></span></a></li>
						</ul>
					</div>
					</li>
			<%
					set cEventItem.FCategoryPrdList(intI) = nothing
				Next
			%>
				</ul>
			</div>
		 <% Else %>
			<div class="pdtWrap pdt270V15">
				<ul class="pdtList">
			<%
				For intI =intIx To iTotCnt
					if cEventItem.FCategoryPrdList(intI).FItemSize="1" or cEventItem.FCategoryPrdList(intI).FItemSize="100" or cEventItem.FCategoryPrdList(intI).FItemSize="150" then Exit For
			%>
					<li <%=chkIIF(cEventItem.FCategoryPrdList(intI).isSoldOut," class=""soldOut""","")%>>
						<div class="pdtBox">
							<div class="pdtPhoto">
								<a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><span class="soldOutMask"></span><% if Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)) Then %> <img src="<%=cEventItem.FCategoryPrdList(intI).Ftentenimage400%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% Else %> <img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,"270","270","true","false")%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% End If %> <% if cEventItem.FCategoryPrdList(intI).FAddimage<>"" then %><dfn><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FAddimage,"270","270","true","false")%>" alt="<%=Replace(cEventItem.FCategoryPrdList(intI).FItemName,"""","")%>" /></dfn><% end if %></a>
							</div>
						</div>
					</li>
			<%
					Set cEventItem.FCategoryPrdList(intI) = nothing
				Next 
			%>
				</ul>
			</div>
<%
			End If
		end if
	end if

	'// 이미지 사이즈가 중간일경우(200px 기존 -> 180xp 변경)
	intIx = intI

	IF (iTotCnt >= intIx) THEN
		if cEventItem.FCategoryPrdList(intI).FItemSize="150" then
			IF blnItemifno THEN 
			%>
			<div class="pdtWrap pdt180V15">
				<ul class="pdtList">
			<%
				For intI = intIx To iTotCnt
			
					'중간이미지가 끝나면 출력 종료
					if cEventItem.FCategoryPrdList(intI).FItemSize="1" or cEventItem.FCategoryPrdList(intI).FItemSize="100" then Exit For
			%>
					<li <%=chkIIF(cEventItem.FCategoryPrdList(intI).isSoldOut," class=""soldOut""","")%>>
					<div class="pdtBox">
						<div class="pdtPhoto">
							<a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><span class="soldOutMask"></span><% if Not(cEventItem.FCategoryPrdList(intI).Ftentenimage200="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage200)) Then %> <img src="<%=cEventItem.FCategoryPrdList(intI).Ftentenimage200%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% Else %> <img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,"180","180","true","false")%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% End If %> <% if cEventItem.FCategoryPrdList(intI).FAddimage<>"" then %><dfn><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FAddimage,"180","180","true","false")%>" alt="<%=Replace(cEventItem.FCategoryPrdList(intI).FItemName,"""","")%>" /></dfn><% end if %></a>
						</div>
						<div class="pdtInfo">
							<p class="pdtBrand tPad20"><a href="/street/street_brand.asp?makerid=<%=cEventItem.FCategoryPrdList(intI).FMakerId %>"><%=cEventItem.FCategoryPrdList(intI).FBrandName %></a></p>
							<p class="pdtName tPad07"><a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><%=cEventItem.FCategoryPrdList(intI).FItemName%></a></p>
							<% If blnitempriceyn = "1" Then %>
							<% Else %>
								<% if cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem then %>
									<p class="pdtPrice"><span class="txtML"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0)%>원</span></p>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0)%>원</span> <strong class="cRd0V15">[<%=cEventItem.FCategoryPrdList(intI).getSalePro%>]</strong></p>
									<% End If %>
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<% if Not(cEventItem.FCategoryPrdList(intI).IsFreeBeasongCoupon() or cEventItem.FCategoryPrdList(intI).IsSaleItem) Then %>
									<p class="pdtPrice"><span class="txtML"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0)%>원</span></p>
										<% end If %>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0)%>원</span> <strong class="cGr0V15">[<%=cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr%>]</strong></p>
									<% End If %>
								<% Else %>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & chkIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem,"Point","원")%></span></p>
								<% End If %>
							<p class="pdtStTag tPad10">
								<% IF cEventItem.FCategoryPrdList(intI).isSoldOut Then %>
									<img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_soldout.gif" alt="SOLDOUT" />
								<% else %>
									<% IF cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_soldout.gif" alt="SOLDOUT" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isSaleItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_sale.gif" alt="SALE" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isCouponItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_coupon.gif" alt="쿠폰" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isLimitItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_limited.gif" alt="한정" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).IsTenOnlyitem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_only.gif" alt="ONLY" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isNewItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_new.gif" alt="NEW" /> <% end if %>
								<% end if %>
							</p>
							<% End If %>
						</div>
						<ul class="pdtActionV15">
							<li class="largeView"><a href="" onclick="ZoomItemInfo('<%=cEventItem.FCategoryPrdList(intI).FItemid %>'); return false;"><img src="http://fiximage.10x10.co.kr/web2015/common/btn_quick.png" alt="QUICK" /></a></li>
							<li class="postView"><a href="" <%=chkIIF(cEventItem.FCategoryPrdList(intI).Fevalcnt>0,"onclick=""popEvaluate('" & cEventItem.FCategoryPrdList(intI).FItemid & "');return false;""","onclick=""return false;""")%>><span><%=FormatNumber(cEventItem.FCategoryPrdList(intI).Fevalcnt,0)%></span></a></li>
							<li class="wishView"><a href="" onclick="TnAddFavorite('<%=cEventItem.FCategoryPrdList(intI).FItemid %>');return false;"><span><%=FormatNumber(cEventItem.FCategoryPrdList(intI).FfavCount,0)%></span></a></li>
						</ul>
					</div>
					</li>
			<%
					set cEventItem.FCategoryPrdList(intI) = nothing
				Next
			%>
				</ul>
			</div>
		 <% Else %>
			<div class="pdtWrap pdt200V15">
				<ul class="pdtList">
			<%
				For intI =intIx To iTotCnt
					If cEventItem.FCategoryPrdList(intI).FItemSize="1" or cEventItem.FCategoryPrdList(intI).FItemSize="100" Then Exit For
			%>
					<li <%=chkIIF(cEventItem.FCategoryPrdList(intI).isSoldOut," class=""soldOut""","")%>>
						<div class="pdtBox">
							<div class="pdtPhoto">
								<a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><span class="soldOutMask"></span><% if Not(cEventItem.FCategoryPrdList(intI).Ftentenimage200="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage200)) Then %> <img src="<%=cEventItem.FCategoryPrdList(intI).Ftentenimage200%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% Else %> <img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,"200","200","true","false")%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /> <% End If %> <% if cEventItem.FCategoryPrdList(intI).FAddimage<>"" then %><dfn><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FAddimage,"200","200","true","false")%>" alt="<%=Replace(cEventItem.FCategoryPrdList(intI).FItemName,"""","")%>" /></dfn><% end if %></a>
							</div>
						</div>
					</li>
			<%
					Set cEventItem.FCategoryPrdList(intI) = nothing
				Next 
			%>
				</ul>
			</div>
<%
			End If
		end if
	end if

	'// 일반 사이즈 상품 목록 출력
	intIx = intI

	IF (iTotCnt >= intIx) THEN
		IF blnItemifno THEN 
%>
			<div class="pdtWrap pdt130V15">
				<ul class="pdtList">
			<%
				For intI =intIx To iTotCnt
			%>
					<li <%=chkIIF(cEventItem.FCategoryPrdList(intI).isSoldOut," class=""soldOut""","")%>>
					<div class="pdtBox">
						<div class="pdtPhoto">
							<a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><span class="soldOutMask"></span><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,"130","130","true","false")%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /><% if cEventItem.FCategoryPrdList(intI).FAddimage<>"" then %><dfn><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FAddimage,"130","130","true","false")%>" alt="<%=Replace(cEventItem.FCategoryPrdList(intI).FItemName,"""","")%>" /></dfn><% end if %></a>
						</div>
						<div class="pdtInfo">
							<p class="pdtBrand tPad20"><a href="/street/street_brand.asp?makerid=<%=cEventItem.FCategoryPrdList(intI).FMakerId %>"><%=cEventItem.FCategoryPrdList(intI).FBrandName %></a></p>
							<p class="pdtName tPad07"><a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><%=cEventItem.FCategoryPrdList(intI).FItemName%></a></p>
							<% If blnitempriceyn = "1" Then %>
							<% Else %>
								<% if cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
									<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem then %>
									<p class="pdtPrice"><span class="txtML"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0)%>원</span></p>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0)%>원</span> <strong class="cRd0V15">[<%=cEventItem.FCategoryPrdList(intI).getSalePro%>]</strong></p>
									<% End If %>
									<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
										<% if Not(cEventItem.FCategoryPrdList(intI).IsFreeBeasongCoupon() or cEventItem.FCategoryPrdList(intI).IsSaleItem) Then %>
									<p class="pdtPrice"><span class="txtML"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0)%>원</span></p>
										<% end If %>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0)%>원</span> <strong class="cGr0V15">[<%=cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr%>]</strong></p>
									<% End If %>
								<% Else %>
									<p class="pdtPrice"><span class="finalP"><%=FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & chkIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem,"Point","원")%></span></p>
								<% End If %>
							<p class="pdtStTag tPad10">
								<% IF cEventItem.FCategoryPrdList(intI).isSoldOut Then %>
									<img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_soldout.gif" alt="SOLDOUT" />
								<% else %>
									<% IF cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_soldout.gif" alt="SOLDOUT" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isSaleItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_sale.gif" alt="SALE" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isCouponItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_coupon.gif" alt="쿠폰" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isLimitItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_limited.gif" alt="한정" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).IsTenOnlyitem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_only.gif" alt="ONLY" /> <% end if %>
									<% IF cEventItem.FCategoryPrdList(intI).isNewItem Then %><img src="http://fiximage.10x10.co.kr/web2013/shopping/tag_new.gif" alt="NEW" /> <% end if %>
								<% end if %>
							</p>
							<% End If %>
						</div>
						<ul class="pdtActionV15">
							<li class="largeView"><a href="" onclick="ZoomItemInfo('<%=cEventItem.FCategoryPrdList(intI).FItemid %>'); return false;"><img src="http://fiximage.10x10.co.kr/web2015/common/btn_quick.png" alt="QUICK" /></a></li>
							<li class="postView"><a href="" <%=chkIIF(cEventItem.FCategoryPrdList(intI).Fevalcnt>0,"onclick=""popEvaluate('" & cEventItem.FCategoryPrdList(intI).FItemid & "');return false;""","onclick=""return false;""")%>><span><%=FormatNumber(cEventItem.FCategoryPrdList(intI).Fevalcnt,0)%></span></a></li>
							<li class="wishView"><a href="" onclick="TnAddFavorite('<%=cEventItem.FCategoryPrdList(intI).FItemid %>');return false;"><span><%=FormatNumber(cEventItem.FCategoryPrdList(intI).FfavCount,0)%></span></a></li>
						</ul>
					</div>
					</li>
			<%
					set cEventItem.FCategoryPrdList(intI) = nothing
				Next
			%>
				</ul>
			</div>
			<%set cEventItem = nothing%>
	   <% Else %>
			<div class="pdtWrap pdt130V15">
				<ul class="pdtList">
			<%
				For intI =intIx To iTotCnt
			%>
					<li <%=chkIIF(cEventItem.FCategoryPrdList(intI).isSoldOut," class=""soldOut""","")%>>
						<div class="pdtBox">
							<div class="pdtPhoto">
								<a href="/shopping/category_prd.asp?itemid=<%=cEventItem.FCategoryPrdList(intI).FItemID %><%=logparam%>"><span class="soldOutMask"></span><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,"130","130","true","false")%>" alt="<%=cEventItem.FCategoryPrdList(intI).FItemName%>" /><% if cEventItem.FCategoryPrdList(intI).FAddimage<>"" then %><dfn><img src="<%=getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FAddimage,"130","130","true","false")%>" alt="<%=Replace(cEventItem.FCategoryPrdList(intI).FItemName,"""","")%>" /></dfn><% end if %></a>
							</div>
						</div>
					</li>
			<%
					Set cEventItem.FCategoryPrdList(intI) = nothing
				Next 
			%>
				</ul>
			</div>
<%			
			Set cEventItem = nothing
		End If
	End IF
End Sub

'----------------------------------------------------
' sbSlidetemplate : 슬라이드 템플릿 PCWEB
' 2016-02-17 이종화
'----------------------------------------------------
Sub sbSlidetemplate

	IF eCode = "" THEN Exit Sub
	
	Dim vSArray , intSL , gubuncls
	'template
	set cEventadd = new ClsEvtCont
	cEventadd.FECode 	= eCode
	cEventadd.fnGetSlideTemplate_main
	'slide
	vSArray = cEventadd.fnGetSlideTemplate_sub

	If cEventadd.FSgubun = "1" Then
		gubuncls = " wideSlide" '//와이드 슬라이드
	ElseIf cEventadd.FSgubun = "2" Then
		gubuncls = " wideSwipe" '//와이드+풀단 슬라이드
	ElseIf cEventadd.FSgubun = "3" Then
		gubuncls = " fullSlide" '//풀단 슬라이드
	End If

	if cEventadd.FSgubun = "1" or cEventadd.FSgubun = "2" Then 
		Response.write "<script>$(function(){ $('.contF').addClass('contW');$('.gpimg').hide(); });</script>" 
	ElseIf cEventadd.FSgubun = "3" Then 
		Response.write "<script>$(function(){ $('.contF').removeClass('contW');$('.gpimg').hide(); });</script>" 
	End If
	
	If cEventadd.FSidx <> "" Then 
%>
	<div class="slideTemplateV15 <%=gubuncls%>">
		<% If cEventadd.FStopimg <> "" Then %>
		<div class="evtTop" <% If cEventadd.FStopaddimg <> "" Then %>style="background-image:url(<%=cEventadd.FStopaddimg%>);"<% End If %>>
			<img src="<%=cEventadd.FStopimg%>" alt="" />
		</div>
		<% End If %>
		<div class="swiper-container" <% If cEventadd.FSpcadd1 <>"" Then %>style="background-image:url(<%=cEventadd.FSpcadd1%>);"<% End If %>>
			<div class="swiper-wrapper">
				<% 
					If isArray(vSArray) THEN 
						For intSL = 0 To UBound(vSArray,2)
				%>
				<div class="swiper-slide" <% If vSArray(5,intSL) <> "" Then %>style="background-image:url(<%=vSArray(5,intSL)%>);"<% End If %>>
					<% If vSArray(4,intSL) <> "" Then %><a href="<%=Trim(vSArray(4,intSL))%>"><% End If %><img src="<%=vSArray(3,intSL)%>" alt="" /><% If vSArray(4,intSL) <> "" Then %></a><% End If %>
				</div>
				<%
						Next 
					End If 
				%>
			</div>
			<div class="pagination"></div>
			<button class="slideNav btnPrev">이전</button>
			<button class="slideNav btnNext">다음</button>
			<div class="mask left"></div>
			<div class="mask right"></div>
		</div>
		<div class="evtBtm" <% If cEventadd.FSbtmaddimg <>"" Then %>style="background-image:url(<%=cEventadd.FSbtmaddimg%>);"<% End If %>>
		<% If cEventadd.FSbtmYN = "Y" Then %>
			<% IF cEventadd.FSbtmimg <> "" THEN %>
			<img src="<%=cEventadd.FSbtmimg%>" alt="" />
			<% End If %>
		</div>
		<% Else %>
			<%=db2html(cEventadd.FSbtmcode)%>
		<% End If %>
	</div>
<%
	End If 
End Sub

Sub sbSlidetemplateMD
	IF eCode = "" THEN Exit Sub
	
	Dim vSArray , intSL , gubuncls
	'template
	set cEventadd = new ClsEvtCont
	cEventadd.FECode 	= eCode
	cEventadd.fnGetSlideTemplate_main
	'slide
	vSArray = cEventadd.fnGetSlideTemplate_sub

	If cEventadd.FSidx <> "" Then 
		If isArray(vSArray) THEN 
			For intSL = 0 To UBound(vSArray,2)
	%>
	<div><% If vSArray(4,intSL) <> "" Then %><a href="<%=Trim(vSArray(4,intSL))%>"><% End If %><img src="<%=vSArray(3,intSL)%>" alt="" /><% If vSArray(4,intSL) <> "" Then %></a><% End If %></div>
	<%
			Next 
		End If 
	End If 
End Sub

Sub sbSlidetemplateItemMD
	IF eCode = "" THEN Exit Sub
	
	Dim intSL , gubuncls
	'template
	set cEventadd = new ClsEvtItem
	cEventadd.FECode 	= eCode
	cEventadd.fnGetMDSlideTemplate_sub

	If cEventadd.FResultCount >= 1 Then 
		for intSL=0 to cEventadd.FResultCount-1
	%>
	<div><img src="<%=cEventadd.FCategoryPrdList(intSL).FImageList%>" alt="" /></div>
	<%
		Next 
	End If 
End Sub

Sub sbSlidetemplateCntMD
	IF eCode = "" And mdtheme ="" THEN Exit Sub
	
	Dim intSL , gubuncls, Tcnt, vSArray
	'template
	If mdtheme=3 Then
	set cEventadd = new ClsEvtItem
	cEventadd.FECode 	= eCode
	cEventadd.fnGetMDSlideTemplate_sub
	Tcnt = cEventadd.FResultCount-1
	ElseIf mdtheme=2 Then
	set cEventadd = new ClsEvtCont
	cEventadd.FECode 	= eCode
	cEventadd.fnGetSlideTemplate_main
	vSArray = cEventadd.fnGetSlideTemplate_sub
		IF isArray(vSArray) THEN
		Tcnt = UBound(vSArray,2)
		Else
		Tcnt=0
		End If
	Else
	Tcnt=0
	End If
	If Tcnt=0 Then Tcnt=1
	Response.write Tcnt
End Sub

Function fnEvtItemGroupLinkInfo(LinkKind)
	If LinkKind="1" Then
		fnEvtItemGroupLinkInfo = "/search/search_result.asp?rect="
	ElseIf LinkKind="2" Then
		fnEvtItemGroupLinkInfo = "/event/eventmain.asp?eventid="
	ElseIf LinkKind="3" Then
		fnEvtItemGroupLinkInfo = "/shopping/category_prd.asp?itemid="
	ElseIf LinkKind="4" Then
		fnEvtItemGroupLinkInfo = "/shopping/category_list.asp?disp="
	ElseIf LinkKind="5" Then
		fnEvtItemGroupLinkInfo = "/street/street_brand.asp?makerid="
	End If
End Function

Function fnEvtItemGroupLinkTitle(LinkKind)
	If LinkKind="1" Then
		fnEvtItemGroupLinkTitle = "더보기"
	ElseIf LinkKind="2" Then
		fnEvtItemGroupLinkTitle = "이벤트 바로가기"
	ElseIf LinkKind="3" Then
		fnEvtItemGroupLinkTitle = "상품 바로가기"
	ElseIf LinkKind="4" Then
		fnEvtItemGroupLinkTitle = "카테고리 더보기"
	ElseIf LinkKind="5" Then
		fnEvtItemGroupLinkTitle = "브랜드 바로가기"
	End If
End Function
%>