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
	public FevtType

	'MD등록 이벤트 추가
	public Fmdthememo
	public Fthemecolormo
	public Ftextbgcolormo
	public Fmdbntypemo
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
	public Ftitle_mo
	public Feventtype_mo
	public FendlessView
	public FvideoFullLink

	public Function fnEventColorCode
		If FECode > "79054" Then
			If Fthemecolormo="1" Then
				fnEventColorCode = "#ed6c6c"
			ElseIf Fthemecolormo="2" Then
				fnEventColorCode = "#f385af"
			ElseIf Fthemecolormo="3" Then
				fnEventColorCode = "#f3a056"
			ElseIf Fthemecolormo="4" Then
				fnEventColorCode = "#e7b93c"
			ElseIf Fthemecolormo="5" Then
				fnEventColorCode = "#8eba4a"
			ElseIf Fthemecolormo="6" Then
				fnEventColorCode = "#43a251"
			ElseIf Fthemecolormo="7" Then
				fnEventColorCode = "#50bdd1"
			ElseIf Fthemecolormo="8" Then
				fnEventColorCode = "#5aa5ea"
			ElseIf Fthemecolormo="9" Then
				fnEventColorCode = "#2672bf"
			ElseIf Fthemecolormo="10" Then
				fnEventColorCode = "#2c5a85"
			ElseIf Fthemecolormo="11" Then
				fnEventColorCode = "#848484"
			Else
				fnEventColorCode = "#848484"
			End If
		Else
			If Fthemecolormo="1" Then
				fnEventColorCode = "#c80e0e"
			ElseIf Fthemecolormo="2" Then
				fnEventColorCode = "#274e87"
			ElseIf Fthemecolormo="3" Then
				fnEventColorCode = "#9457a1"
			ElseIf Fthemecolormo="4" Then
				fnEventColorCode = "#ea5b8d"
			ElseIf Fthemecolormo="5" Then
				fnEventColorCode = "#e24343"
			ElseIf Fthemecolormo="6" Then
				fnEventColorCode = "#9b613d"
			ElseIf Fthemecolormo="7" Then
				fnEventColorCode = "#f08527"
			ElseIf Fthemecolormo="8" Then
				fnEventColorCode = "#5eb041"
			ElseIf Fthemecolormo="9" Then
				fnEventColorCode = "#209f6e"
			ElseIf Fthemecolormo="10" Then
				fnEventColorCode = "#e4569c"
			ElseIf Fthemecolormo="11" Then
				fnEventColorCode = "#3593d4"
			Else
				fnEventColorCode = "#ffffff"
			End If
		End If
	End Function

	public Function fnEventBarColorCode
		If FECode > "79054" Then
			If Fthemecolormo="1" Then
				fnEventBarColorCode = "#cb4848"
			ElseIf Fthemecolormo="2" Then
				fnEventBarColorCode = "#d55787"
			ElseIf Fthemecolormo="3" Then
				fnEventBarColorCode = "#e37f35"
			ElseIf Fthemecolormo="4" Then
				fnEventBarColorCode = "#ce8d00"
			ElseIf Fthemecolormo="5" Then
				fnEventBarColorCode = "#699426"
			ElseIf Fthemecolormo="6" Then
				fnEventBarColorCode = "#358240"
			ElseIf Fthemecolormo="7" Then
				fnEventBarColorCode = "#2899ae"
			ElseIf Fthemecolormo="8" Then
				fnEventBarColorCode = "#2f7cc3"
			ElseIf Fthemecolormo="9" Then
				fnEventBarColorCode = "#145290"
			ElseIf Fthemecolormo="10" Then
				fnEventBarColorCode = "#1c3e5d"
			ElseIf Fthemecolormo="11" Then
				fnEventBarColorCode = "#656565"
			Else
				fnEventBarColorCode = "656565"
			End If
		Else
			If Fmdthememo="1" Then
				If Fthemecolormo="1" Then
					fnEventBarColorCode = "#f5742f"
				ElseIf Fthemecolormo="2" Then
					fnEventBarColorCode = "#e2b500"
				ElseIf Fthemecolormo="3" Then
					fnEventBarColorCode = "#6db003"
				ElseIf Fthemecolormo="4" Then
					fnEventBarColorCode = "#79811"
				ElseIf Fthemecolormo="5" Then
					fnEventBarColorCode = "#0e6d78"
				ElseIf Fthemecolormo="6" Then
					fnEventBarColorCode = "#209ed2"
				ElseIf Fthemecolormo="7" Then
					fnEventBarColorCode = "#1e5dd0"
				ElseIf Fthemecolormo="8" Then
					fnEventBarColorCode = "#1e3b8e"
				ElseIf Fthemecolormo="9" Then
					fnEventBarColorCode = "#7653ce"
				ElseIf Fthemecolormo="10" Then
					fnEventBarColorCode = "#e4569c"
				Else
					fnEventBarColorCode = "#656565"
				End If
			ElseIf Fmdthememo="2" Then
				If Fthemecolormo="1" Then
					fnEventBarColorCode = "#c80e0e"
				ElseIf Fthemecolormo="2" Then
					fnEventBarColorCode = "#274e87"
				ElseIf Fthemecolormo="3" Then
					fnEventBarColorCode = "#9457a1"
				ElseIf Fthemecolormo="4" Then
					fnEventBarColorCode = "#ea5b8d"
				ElseIf Fthemecolormo="5" Then
					fnEventBarColorCode = "#e24343"
				ElseIf Fthemecolormo="6" Then
					fnEventBarColorCode = "#9b613d"
				ElseIf Fthemecolormo="7" Then
					fnEventBarColorCode = "#f08527"
				ElseIf Fthemecolormo="8" Then
					fnEventBarColorCode = "#5eb041"
				ElseIf Fthemecolormo="9" Then
					fnEventBarColorCode = "#209f6e"
				ElseIf Fthemecolormo="10" Then
					fnEventBarColorCode = "#e4569c"
				ElseIf Fthemecolormo="11" Then
					fnEventBarColorCode = "#3593d4"
				Else
					fnEventBarColorCode = ""
				End If
			Else
				If Fthemecolormo="1" Then
					fnEventBarColorCode = "#2e2e2e"
				ElseIf Fthemecolormo="2" Then
					fnEventBarColorCode = "#102d58"
				ElseIf Fthemecolormo="3" Then
					fnEventBarColorCode = "#5d2869"
				ElseIf Fthemecolormo="4" Then
					fnEventBarColorCode = "#bf1f57"
				ElseIf Fthemecolormo="5" Then
					fnEventBarColorCode = "#b01b1b"
				ElseIf Fthemecolormo="6" Then
					fnEventBarColorCode = "#693718"
				ElseIf Fthemecolormo="7" Then
					fnEventBarColorCode = "#df5834"
				ElseIf Fthemecolormo="8" Then
					fnEventBarColorCode = "#267909"
				ElseIf Fthemecolormo="9" Then
					fnEventBarColorCode = "#26941"
				ElseIf Fthemecolormo="10" Then
					fnEventBarColorCode = "#007c7e"
				ElseIf Fthemecolormo="11" Then
					fnEventBarColorCode = "#0c69aa"
				Else
					fnEventBarColorCode = ""
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
		strSql ="EXEC [db_event].[dbo].sp_Ten_event_content_New "&FECode&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FECode		= rsget("evt_code")
				FEKind		= rsget("evt_kind")
				FEManager 	= rsget("evt_manager")
				FEScope 	= rsget("evt_scope")
				FEName 		= nl2br(db2html(rsget("evt_name")))
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
				FSocName_Kor= db2html(rsget("socname_kor"))
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

				FsalePer = rsget("salePer")
				FsaleCPer = rsget("saleCPer")
				Fmdthememo = rsget("mdthememo")
				Fthemecolormo = rsget("themecolormo")
				Ftextbgcolormo = rsget("textbgcolormo")
				Fmdbntypemo = rsget("mdbntypemo")
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
				Ftitle_mo = rsget("title_mo")
				FendlessView = rsget("endlessView")
				FvideoFullLink = rsget("videoFullLink")
   			ELSE
   				FECode = ""
			END IF
		rsget.close
	END Function

	'##### 텍스트 코멘트 2015추가 - 모바일&앱 전용 ######
	public Function fnGetEventTextTitle
		Dim strSql
		IF  FEGCode = "" THEN FEGCode = 0
		strSql ="EXEC [db_event].[dbo].sp_Ten_event_mo_textcontent "&FECode&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventTextTitle = rsget.getRows()
		END IF
		rsget.close
	End Function

	'##### 그룹 내용 ######
	public Function fnGetEventGroup
		Dim strSql
		IF  FEGCode = "" THEN FEGCode = 0
		strSql ="EXEC [db_event].[dbo].sp_Ten_eventitem_group "&FECode&","&FEGCode&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventGroup = rsget.getRows()
		END IF
		rsget.close
	End Function

	'##### 그룹 내용 2015-06-16 모바일 전용 ######
	public Function fnGetEventGroup_mo
		Dim strSql
		IF  FEGCode = "" THEN FEGCode = 0
		strSql ="EXEC [db_event].[dbo].sp_Ten_eventitem_group_mo "&FECode&","&FEGCode&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventGroup_mo = rsget.getRows()
		END IF
		rsget.close
	End Function

	'//그룹형 랜덤 1개
	public Function fnGetEventGroupTop
		Dim strSql
		IF  FEGCode = "" THEN FEGCode = 0
		strSql ="EXEC [db_event].[dbo].sp_Ten_eventitem_group_top1_mo "&FECode&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventGroupTop = rsget.getRows()
		END IF
		rsget.close
	End Function

	'##### 최근리스트 10개 ######
	public Function fnGetRecentEvt
		Dim strSql
		strSql ="EXEC [db_event].[dbo].sp_Ten_event_top_list '"&FECategory&"'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
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
		strSql ="EXEC [db_event].[dbo].sp_Ten_event_EventISSUE_New '" & FECode & "','" & FEKind & "','" & FBrand & "','" & FEDispCate & "' ,'"& FDevice &"'"
		'rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"EVT",strSql,60*30)
        if (rsMem is Nothing) then Exit function ''추가
		IF Not (rsMem.EOF OR rsMem.BOF) THEN
			fnEventISSUEList = rsMem.GetRows()
		END IF
		rsMem.close
	End Function

	public Function fnEventISSUEList2
		Dim strSql
		strSql ="EXEC [db_event].[dbo].sp_Ten_event_EventISSUE_Temp '" & FECode & "','" & FEKind & "','" & FBrand & "','" & FEDispCate & "' ,'"& FDevice &"'"
		'rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"EVT",strSql,60*30)
        if (rsMem is Nothing) then Exit function ''추가
		IF Not (rsMem.EOF OR rsMem.BOF) THEN
			fnEventISSUEList2 = rsMem.GetRows()
		END IF
		rsMem.close
	End Function

	'// 슬라이드 템플릿 
	public Function fnGetSlideTemplate_main
		Dim strSql
		IF FECode = "" THEN Exit Function
		strSql = "EXEC [db_event].[dbo].[sp_Ten_event_slidetemplate] "&FECode&", 'M'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
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
		strSql ="EXEC [db_event].[dbo].[sp_Ten_event_slidetemplate_addimg] "&FECode&", 'M'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetSlideTemplate_sub = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'// 이벤트 모바일 추가 배너
	Public Function fnGetMoAddimg
		Dim strSql
		If FECode = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[sp_Ten_event_mobile_addimg] "&FECode&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetMoAddimg = rsget.GetRows()
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

		strSql ="EXEC [db_item].[dbo].sp_Ten_event_GetItem "&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&""
		'//리뉴얼 후 교체 디바이스(1 pc , 2 mobile&app) 추가
		'strSql ="[db_item].[dbo].sp_Ten_event_GetItem_newV17 ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&",2)"

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
		Dim strSql, arrItem,intI, cTime, dummyName
		IF FECode = "" THEN Exit Function
		IF FEGCode = "" THEN FEGCode= 0
		If timer > 10 And Cint(timer/60) < 6 Then
			cTime = 60*1
			dummyName = "WeddingEvent_"&FEGCode&"_"&Cint(timer/60)
		Else
			cTime = 60*5
			dummyName = "WeddingEvent_"&FEGCode
		End If

		'strSql ="[db_item].[dbo].sp_Ten_event_GetItem ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&")"
		'//리뉴얼 후 교체 디바이스(1 pc , 2 mobile&app) 추가
		strSql ="EXEC [db_item].[dbo].sp_Ten_event_GetItem_newV17 "&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&", 2 "

		'response.write strSql &"<br>"
		'rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget, dummyName, strSql, cTime)
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

				If arrItem(24,intI)="21" Then
					if instr(arrItem(26,intI),"/") > 0 then
						FCategoryPrdList(intI).FImageList = "http://webimage.10x10.co.kr/image/list/"&arrItem(6,intI)
						FCategoryPrdList(intI).FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&arrItem(7,intI)
						FCategoryPrdList(intI).FImageSmall = "http://webimage.10x10.co.kr/image/small/"&arrItem(8,intI)
						FCategoryPrdList(intI).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&arrItem(21,intI)
						FCategoryPrdList(intI).FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&arrItem(22,intI)
						FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&arrItem(26,intI)
					Else
						FCategoryPrdList(intI).FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(6,intI)
						FCategoryPrdList(intI).FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(7,intI)
						FCategoryPrdList(intI).FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(8,intI)
						FCategoryPrdList(intI).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(21,intI)
						FCategoryPrdList(intI).FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(22,intI)
						FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(26,intI)
					End If
					FCategoryPrdList(intI).FItemOptionCnt = arrItem(39,intI)
				Else
					FCategoryPrdList(intI).FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(6,intI)
					FCategoryPrdList(intI).FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(7,intI)
					FCategoryPrdList(intI).FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(8,intI)
					FCategoryPrdList(intI).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(21,intI)
					FCategoryPrdList(intI).FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(22,intI)
					FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(26,intI)
				End If

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

	'##### 상품 리스트 ###### 'present brand 전용 2015-06-09 이종화
	public Function fnGetEventItem_present
		Dim strSql, arrItem,intI
		IF FECode = "" THEN Exit Function
		IF FEGCode = "" THEN FEGCode= 0
		strSql ="EXEC [db_item].[dbo].sp_Ten_event_GetItem_present "&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&""
		'//리뉴얼 후 교체 디바이스(1 pc , 2 mobile&app) 추가
		'strSql ="[db_item].[dbo].sp_Ten_event_GetItem_newV17 ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&",2)"
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

	Public sub fnGetMDSlideTemplate_sub()
		Dim i, strSql
		'// 추천상품 목록접수
		strSql = "Select top 5 i.basicimage, i.itemid"
		strSql = strSql & " from [db_event].[dbo].[tbl_event_itembanner] e"
		strSql = strSql & "	join [db_item].[dbo].tbl_item i "
		strSql = strSql & "	on e.itemid = i.itemid"
		strSql = strSql & " where 1 = 1 "
		strSql = strSql & "	and e.evt_code=" & CStr(FECode)
		strSql = strSql & "	and e.sdiv='m'"
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
				FCategoryPrdList(i).FItemID	= rsget("itemid")
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	End Sub
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
				<div class="evtPdtListWrapV15">
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
	Dim iEndCnt, intJ, iLp, vWishArr

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

	'// 검색결과 내위시 표시정보 접수
	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		dim rstArrItemid: rstArrItemid=""
		IF iTotCnt >= 0 then
			For iLp=0 To iTotCnt -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & cEventItem.FCategoryPrdList(intI).FItemID
			Next
		End if
		'// 위시결과 상품목록 작성
		if rstArrItemid<>"" then
'			response.write getLoginUserid() &"//"& rstArrItemid &"//"&vWishArr
'			response.end
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
		end if
	end if

	IF (iTotCnt >= 0) THEN
		If eItemListType = "1" Then '### 격자형
			Response.Write "				<div class=""items type-grid"">"
		ElseIf eItemListType = "2" Then '### 리스트형
			Response.Write "				<div class=""items type-list"">"
		ElseIf eItemListType = "3" Then '### BIG형
			Response.Write "				<div class=""items type-big"">"
		End If
%>
		<!--<div class="pdtListWrapV15a">-->
		<ul>
<%
			For intI =0 To iTotCnt
%>
			<% If cEventItem.FCategoryPrdList(intI).FItemDiv="21" Then %>
				<li class="deal-item">
					<a href="/deal/deal.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %><%=logparam%>&flag=e<%=addparam%>">
					<span class="deal-badge">텐텐<i>DEAL</i></span>
						<!-- for dev msg : 상품명으로 썸네일 alt값 달면 중복되니 alt=""으로 처리해주세요. -->
						<div class="thumbnail">
							<% if (eItemListType = "1") or (eItemListType = "2") then %>
								<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
							<% else %>
								<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
							<% end if %>
							<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
								<b class="soldout">일시 품절</b>
							<% end if %>
						</div>
						<div class="desc">
							<span class="brand"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></span>
							<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
							<div class="price">
								<%
									If cEventItem.FCategoryPrdList(intI).FItemOptionCnt="" Or cEventItem.FCategoryPrdList(intI).FItemOptionCnt="0" Then	'### 쿠폰 X 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0) & "<span class=""won"">" & CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") & "~</span></b></div>" &  vbCrLf
									Else
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">원~</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).FItemOptionCnt & "%</b>"
										Response.Write "</div>" &  vbCrLf
									End If
								%>
							</div>
						</div>
					</a>
				</li>
			<% Else %>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %><%=logparam%>&flag=e<%=addparam%>">
						<!-- for dev msg : 상품명으로 썸네일 alt값 달면 중복되니 alt=""으로 처리해주세요. -->
						<div class="thumbnail">
							<% if (eItemListType = "1") or (eItemListType = "2") then %>
								<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
							<% else %>
								<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
							<% end if %>
							<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
								<b class="soldout">일시 품절</b>
							<% end if %>
						</div>
						<div class="desc">
							<span class="brand"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></span>
							<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
							<div class="price">
								<%
									If cEventItem.FCategoryPrdList(intI).IsSaleItem AND cEventItem.FCategoryPrdList(intI).isCouponItem Then	'### 쿠폰 O 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
										If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
											Else
												Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
											End If
										End If
										Response.Write "</div>" &  vbCrLf
									ElseIf cEventItem.FCategoryPrdList(intI).IsSaleItem AND (Not cEventItem.FCategoryPrdList(intI).isCouponItem) Then	'### 쿠폰 X 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
										Response.Write "</div>" &  vbCrLf
									ElseIf cEventItem.FCategoryPrdList(intI).isCouponItem AND (NOT cEventItem.FCategoryPrdList(intI).IsSaleItem) Then	'### 쿠폰 O 세일 X
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
										If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
											Else
												Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
											End If
										End If
										Response.Write "</div>" &  vbCrLf
									Else
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">" & CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
									End If
								%>
							</div>
						</div>
					</a>
					<div class="etc">
						<!-- for dev msg : 리뷰
							1. 리뷰수와 wish수가 1,000건 이상이면 999+로 표시해주세요
							2. 리뷰는 총 평점으로 퍼센트로 표현해주세요. <i style="width:50%;">...</i>
						--> 
						<% if cEventItem.FCategoryPrdList(intI).FEvalcnt > 0 then %>
							<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(cEventItem.FCategoryPrdList(intI).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(cEventItem.FCategoryPrdList(intI).FEvalcnt>999,"999+",cEventItem.FCategoryPrdList(intI).FEvalcnt)%></span></div>
						<% end if %>
						<button class="tag wish btn-wish" onclick="goWishPop('<%=cEventItem.FCategoryPrdList(intI).FItemid%>','<%=eCode%>');">
						<%
						If cEventItem.FCategoryPrdList(intI).FFavCount > 0 Then
							If fnIsMyFavItem(vWishArr,cEventItem.FCategoryPrdList(intI).FItemID) Then
								Response.Write "<span class=""icon icon-wish on"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
								Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
							Else
								Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
								Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
							End If
						Else
							Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&"""></span>"
						End If
						%>
						</button>
						<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem AND cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr = "무료배송" Then %>
							<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
						<% End If %>
					</div>
				</li>
			<% End If %>
<%
			Next
		Response.write "</ul>"	'</div>
		Response.Write "</div>"
	End IF
End Sub

'//상품후기 총점수 %로 환산
function fnEvalTotalPointAVG(t,g)
	dim vTmp
	vTmp = 0
	If t <> "" Then
		If isNumeric(t) Then
			If t > 0 Then
				If g = "search" Then
					vTmp = (t/5)
				Else
					vTmp = ((Round(t,2) * 100)/5)
				End If
				vTmp = Round(vTmp)
			End If
		End If
	End If
	fnEvalTotalPointAVG = vTmp
end function

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
	Dim iEndCnt, intJ, iLp, vWishArr

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

	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		dim rstArrItemid: rstArrItemid=""
		IF cEventItem.FResultCount >0 then
			For iLp=0 To cEventItem.FResultCount -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & cEventItem.FCategoryPrdList(iLp).FItemID
			Next
		End if
		'// 위시결과 상품목록 작성
		if rstArrItemid<>"" then
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
		end if
	end if

	IF (iTotCnt >= 0) THEN
		If eItemListType = "1" Then '### 격자형
			Response.Write "				<div class=""items type-grid"">"
		ElseIf eItemListType = "2" Then '### 리스트형
			Response.Write "				<div class=""items type-list"">"
		ElseIf eItemListType = "3" Then '### BIG형
			Response.Write "				<div class=""items type-big"">"
		End If
%>
		<!--<div class="pdtListWrapV15a">-->
		<ul>
<%
			For intI =0 To iTotCnt
%>
		<% If cEventItem.FCategoryPrdList(intI).FItemDiv="21" Then %>
			<li class="deal-item">
				<a href="" onclick="fnAPPpopupDealProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %><%=addparam%>');return false;">
				<span class="deal-badge">텐텐<i>DEAL</i></span>
					<div class="thumbnail">
						<% if (eItemListType = "1") or (eItemListType = "2") then %>
							<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
						<% else %>
							<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
						<% end if %>
						<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
							<b class="soldout">일시 품절</b>
						<% end if %>
					</div>
					<div class="desc">
						<span class="brand"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></span>
						<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
						<div class="price">
							<%
								If cEventItem.FCategoryPrdList(intI).FItemOptionCnt="" Or cEventItem.FCategoryPrdList(intI).FItemOptionCnt="0" Then	'### 쿠폰 X 세일 O
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0) & "<span class=""won"">" & CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") & "~</span></b></div>" &  vbCrLf
								Else
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">원~</span></b>"
									Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).FItemOptionCnt & "%</b>"
									Response.Write "</div>" &  vbCrLf
								End If
							%>
						</div>
					</div>
				</a>
			</li>
		<% Else %>
			<li>
				<a href="" onclick="fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %><%=addparam%>');return false;">
					<div class="thumbnail">
						<% if (eItemListType = "1") or (eItemListType = "2") then %>
							<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
						<% else %>
							<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
						<% end if %>
						<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
							<b class="soldout">일시 품절</b>
						<% end if %>
					</div>
					<div class="desc">
						<span class="brand"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></span>
						<p class="name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
						<div class="price">
							<%
								If cEventItem.FCategoryPrdList(intI).IsSaleItem AND cEventItem.FCategoryPrdList(intI).isCouponItem Then	'### 쿠폰 O 세일 O
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
									Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
									If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
										If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
											Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
										Else
											Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
										End If
									End If
									Response.Write "</div>" &  vbCrLf
								ElseIf cEventItem.FCategoryPrdList(intI).IsSaleItem AND (Not cEventItem.FCategoryPrdList(intI).isCouponItem) Then	'### 쿠폰 X 세일 O
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">원</span></b>"
									Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).getSalePro & "</b>"
									Response.Write "</div>" &  vbCrLf
								ElseIf cEventItem.FCategoryPrdList(intI).isCouponItem AND (NOT cEventItem.FCategoryPrdList(intI).IsSaleItem) Then	'### 쿠폰 O 세일 X
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
									If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
										If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
											Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
										Else
											Response.Write "&nbsp;<b class=""discount color-green"">" & cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr & "<small>쿠폰</small></b>"
										End If
									End If
									Response.Write "</div>" &  vbCrLf
								Else
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) & "<span class=""won"">" & CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
								End If
							%>
						</div>
					</div>
				</a>
				<div class="etc">
					<!-- for dev msg : 리뷰
						1. 리뷰수와 wish수가 1,000건 이상이면 999+로 표시해주세요
						2. 리뷰는 총 평점으로 퍼센트로 표현해주세요. <i style="width:50%;">...</i>
					--> 
					<% if cEventItem.FCategoryPrdList(intI).FEvalcnt > 0 then %>
						<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(cEventItem.FCategoryPrdList(intI).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(cEventItem.FCategoryPrdList(intI).FEvalcnt>999,"999+",cEventItem.FCategoryPrdList(intI).FEvalcnt)%></span></div>
					<% end if %>
					<button class="tag wish btn-wish" onclick="goWishPop('<%=cEventItem.FCategoryPrdList(intI).FItemid%>','<%=eCode%>');">
					<%
					If cEventItem.FCategoryPrdList(intI).FFavCount > 0 Then
						If fnIsMyFavItem(vWishArr,cEventItem.FCategoryPrdList(intI).FItemID) Then
							Response.Write "<span class=""icon icon-wish on"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
							Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
						Else
							Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&""">"
							Response.Write CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999+",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) & "</span>"
						End If
					Else
						Response.Write "<span class=""icon icon-wish"" id=""wish"&cEventItem.FCategoryPrdList(intI).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&cEventItem.FCategoryPrdList(intI).FItemID&"""></span>"
					End If
					%>
					</button>
					<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem AND cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr = "무료배송" Then %>
						<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
					<% End If %>
				</div>
			</li>
		<% End If %>
<%
		Next
		Response.write "</ul>"
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
	<div class="swiper-slide"><% If vSArray(4,intSL) <> "" Then %><a href="<%=Trim(vSArray(4,intSL))%>"><% End If %><div class="thumbnail"><img src="<%=vSArray(3,intSL)%>" /></div><% If vSArray(4,intSL) <> "" Then %></a><% End If %></div>
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
	<% if isApp=1 then %>
	<div class="swiper-slide"><div class="thumbnail"><a href="javascript:fnAPPpopupProduct('<%=cEventadd.FCategoryPrdList(intSL).FItemID%>');"><img src="<%=cEventadd.FCategoryPrdList(intSL).FImageList%>" alt="" /></a></div></div>
	<% Else %>
	<div class="swiper-slide"><div class="thumbnail"><a href="/category/category_itemPrd.asp?itemid=<%=cEventadd.FCategoryPrdList(intSL).FItemID%>&pEtr=<%=eCode%>"><img src="<%=cEventadd.FCategoryPrdList(intSL).FImageList%>" alt="" /></a></div></div>
	<% End If %>
	<%
		Next
	End If 
End Sub

Sub sbSlidetemplateCntMD
	IF eCode = "" And mdthememo ="" THEN Exit Sub
	
	Dim intSL , gubuncls, Tcnt, vSArray
	'template
	If mdthememo=3 Then
	set cEventadd = new ClsEvtItem
	cEventadd.FECode 	= eCode
	cEventadd.fnGetMDSlideTemplate_sub
	Tcnt = cEventadd.FResultCount-1
	Else
	set cEventadd = new ClsEvtCont
	cEventadd.FECode 	= eCode
	cEventadd.fnGetSlideTemplate_main
	vSArray = cEventadd.fnGetSlideTemplate_sub
	Tcnt = UBound(vSArray,2)-1
	End If

	Response.write Tcnt
End Sub

'// 이벤트 모바일 추가 배너
Function fnGetMoSlideImgCnt(FECode)
	Dim strSql
	If FECode = "" THEN Exit Function
	strSql ="SELECT count(idx) as cnt FROM [db_event].[dbo].[tbl_event_slide_addimage] where  evt_code="&FECode&" and device='M' and isusing='Y'"
	rsget.Open strSql,dbget,1
	IF Not (rsget.EOF OR rsget.BOF) THEN
		fnGetMoSlideImgCnt = rsget("cnt")
	END IF
	rsget.close
End Function

'// 이벤트 모바일 추가 배너
Function fnGetMoItemSlideImgCnt(FECode)
	Dim strSql
	If FECode = "" THEN Exit Function
	strSql ="SELECT count(idx) as cnt FROM [db_event].[dbo].[tbl_event_itembanner] where  evt_code="&FECode&" and sdiv='m'"
	rsget.Open strSql,dbget,1
	IF Not (rsget.EOF OR rsget.BOF) THEN
		fnGetMoItemSlideImgCnt = rsget("cnt")
	END IF
	rsget.close
End function
%>