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
	Public Fevt_subcopyK
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
	'// 슬라이드 동영상 추가
	Public FVideoSize
	Public FVideoLink

	Public FisArrow '// 화살표 유무

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
	public Feval_isusing
	public Feval_text
	public Feval_freebie_img
	public Feval_start
	public Feval_end
	public Fboard_isusing
	public Fboard_text
	public Fboard_freebie_img
	public Fboard_start
	public Fboard_end

	public FisOnlyTen
	public FisOnePlusOne
	public FisNew
	public FcontentsAlign
	public FMenuIDX
	public FCopyHide
	

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

	public Function fnEventThemeColorCode
		If Fthemecolormo="1" Then
			fnEventThemeColorCode = "#ed6c6c"
		ElseIf Fthemecolormo="2" Then
			fnEventThemeColorCode = "#f385af"
		ElseIf Fthemecolormo="3" Then
			fnEventThemeColorCode = "#f3a056"
		ElseIf Fthemecolormo="4" Then
			fnEventThemeColorCode = "#e7b93c"
		ElseIf Fthemecolormo="5" Then
			fnEventThemeColorCode = "#8eba4a"
		ElseIf Fthemecolormo="6" Then
			fnEventThemeColorCode = "#43a251"
		ElseIf Fthemecolormo="7" Then
			fnEventThemeColorCode = "#50bdd1"
		ElseIf Fthemecolormo="8" Then
			fnEventThemeColorCode = "#5aa5ea"
		ElseIf Fthemecolormo="9" Then
			fnEventThemeColorCode = "#2672bf"
		ElseIf Fthemecolormo="10" Then
			fnEventThemeColorCode = "#2c5a85"
		ElseIf Fthemecolormo="11" Then
			fnEventThemeColorCode = "#848484"
		ElseIf Fthemecolormo="12" Then
			fnEventThemeColorCode = "#ff427c"
		ElseIf Fthemecolormo="13" Then
			fnEventThemeColorCode = "#4d96fd"
		ElseIf Fthemecolormo="14" Then
			fnEventThemeColorCode = "#ff2977"
		ElseIf Fthemecolormo="15" Then
			fnEventThemeColorCode = "#018fec"
		ElseIf Fthemecolormo="16" Then
			fnEventThemeColorCode = "#004ae1"
		ElseIf Fthemecolormo="17" Then
			fnEventThemeColorCode = "#ff664e"
		ElseIf Fthemecolormo="18" Then
			fnEventThemeColorCode = "#4ecbc0"
		ElseIf Fthemecolormo="19" Then
			fnEventThemeColorCode = "#58d82a"
		ElseIf Fthemecolormo="20" Then
			fnEventThemeColorCode = "#a5447d"
		ElseIf Fthemecolormo="21" Then
			fnEventThemeColorCode = "#e784a2"
		ElseIf Fthemecolormo="22" Then
			fnEventThemeColorCode = "#4b6182"
		ElseIf Fthemecolormo="23" Then
			fnEventThemeColorCode = "#d88664"
		ElseIf Fthemecolormo="24" Then
			fnEventThemeColorCode = "#d84950"
		ElseIf Fthemecolormo="25" Then
			fnEventThemeColorCode = "#1e4c54"
		ElseIf Fthemecolormo="26" Then
			fnEventThemeColorCode = "#ff7e45"
		ElseIf Fthemecolormo="27" Then
			fnEventThemeColorCode = "#a2b72e"
		Else
			fnEventThemeColorCode = "#656565"
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
			Case "90":  fnEventTypeName = "multi3"
			Case Else : fnEventTypeName = ""
		end Select
	end function

	'##### 이벤트 내용 ######
	public Function fnGetEvent
		Dim strSql
		IF 	FECode = "" THEN Exit Function
		FGimg = ""
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_ContentsView_Get] "&FECode&""
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
				FisOnlyTen	= rsget("isOnlyTen")
				FisOnePlusOne = rsget("isonePlusone")
				FisNew 		= rsget("isNew")
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
				Fevt_subcopyK		= rsget("evt_subcopyK")
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
				Feventtype_mo = rsget("eventtype_mo")
				Feval_isusing = rsget("eval_isusing")
				Feval_text = rsget("eval_text")
				Feval_freebie_img = rsget("eval_freebie_img")
				Feval_start = rsget("eval_start")
				Feval_end = rsget("eval_end")
				Fboard_isusing = rsget("board_isusing")
				Fboard_text = rsget("board_text")
				Fboard_freebie_img = rsget("board_freebie_img")
				Fboard_start = rsget("board_start")
				Fboard_end = rsget("board_end")
				FcontentsAlign = rsget("contentsAlign")
				FCopyHide = rsget("videoType")
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
		strSql ="EXEC [db_event].[dbo].sp_Ten_eventitem_group_mo "&FECode&","&FEGCode
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly , adCmdText
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
		strSql ="[db_event].[dbo].sp_Ten_event_brandday"
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
		strSql ="EXEC [db_event].[dbo].usp_WWW_event_EventISSUE_Get '"& FECode & "','" & FEKind & "','" & FBrand & "','" & FEDispCate & "' ,'"& FDevice &"'"
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
		strSql ="EXEC [db_event].[dbo].[sp_Ten_event_slidetemplate] "&FECode&", 'M'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FSidx		= rsget("idx")
				FStopimg	= rsget("topimg")
				FSbtmimg	= rsget("btmimg")
				FStopaddimg	= rsget("topaddimg")
				'// 슬라이드 동영상 추가
				FVideoSize	= rsget("videosize")
				FVideoLink	= rsget("videolink")
				FisArrow	= rsget("isarrow")
   			ELSE
   				FSidx		= ""
				FStopimg	= ""
				FStopaddimg = ""
				'// 슬라이드 동영상 추가
				FVideoSize	= ""
				FVideoLink	= ""
				FisArrow	= ""
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

	public Function fnGetTopSlideTemplate
		Dim strSql
		If FECode = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_TopSlideaddimg_Get] "&FECode&", 'M'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetTopSlideTemplate = rsget.GetRows()
		Else
			
		END IF
		rsget.close
	End Function

	'// 이벤트 PC 기프트박스 정보
	Public Function fnGetGiftBox
		Dim strSql
		If FECode = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_GiftBox_Get] "&FECode&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetGiftBox = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 마스터 정보
	public Function fnGetEventMultiContentsMaster
		Dim strSql
		If FECode = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContentsMaster_Get] "&FECode&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventMultiContentsMaster = rsget.getRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 이미지 & 영상 정보
	public Function fnGetEventMultiContentsSwife
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContentsImageSwife_Get] "&FMenuIDX&",'M'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventMultiContentsSwife = rsget.getRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 이미지 & 영상 정보
	public Function fnGetEventMultiContentsVideo
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContentsVideo_Get] "&FMenuIDX&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventMultiContentsVideo = rsget.getRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 브랜드 스토리
	public Function fnGetEventMultiContentsBrandStory
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContentsBrandStory_Get] "&FMenuIDX&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventMultiContentsBrandStory = rsget.getRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 기차형 템플릿 (MD추천상품)
	public Function fnGetEventMultiContentsTrainTamplate
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContentsTrainTamplate_Get] "&FMenuIDX&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventMultiContentsTrainTamplate = rsget.getRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 에디터영역
	public Function fnGetEventMultiContentsCustomBox
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContentsCustomBox_Get] "&FMenuIDX&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventMultiContentsCustomBox = rsget.getRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 상단 슬라이드
	public Function fnGetTopSlideTemplateMulti
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_TopSlideaddimg_Multi_Get] " & FMenuIDX & ", 'M'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetTopSlideTemplateMulti = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 이미지 & HTML
	public Function fnGetImageHtmlTemplate
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContents_ImageHtml_Get] " & FMenuIDX & ", 'M'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetImageHtmlTemplate = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'// 멀티 컨텐츠 슬라이드 템플릿 정보 
	public Function fnGetMultiContentsSlideTemplateInfo
		Dim strSql
		IF FMenuIDX = "" THEN Exit Function
		strSql = "EXEC [db_event].[dbo].[usp_WWW_Event_MultiContents_SlideTemplateInfo_Get] "&FMenuIDX&", 'M'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FSidx		= rsget("idx")
				FStopimg	= rsget("topimg")
				FSbtmimg	= rsget("btmimg")
				FStopaddimg	= rsget("topaddimg")
				'// 슬라이드 동영상 추가
				FVideoSize	= rsget("videosize")
				FVideoLink	= rsget("videolink")
				FisArrow	= rsget("isarrow")
   			ELSE
   				FSidx		= ""
				FStopimg	= ""
				FStopaddimg = ""
				'// 슬라이드 동영상 추가
				FVideoSize	= ""
				FVideoLink	= ""
				FisArrow	= ""
			END IF
		rsget.close
	END Function
	'// 멀티 컨텐츠 슬라이드 템플릿 이미지 리스트 
	public Function fnGetMultiContentsSlideTemplateImages
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContents_SlideTemplateImageList_Get] "&FMenuIDX&", 'M'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetMultiContentsSlideTemplateImages = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'// 멀티컨텐츠 모바일 연결배너
	Public Function fnGetMoMultiAddBanner
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MobileAddbannerNew_Multi_Get] "&FMenuIDX&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetMoMultiAddBanner = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 이미지 맵
	public Function fnGetImageMapTemplate
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContents_ImageMap_Get] " & FMenuIDX & ", 'M'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetImageMapTemplate = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 추천리스트 마스터 정보
	public Function fnGetTrainTamplateMasterinfo
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContentsMaster_TrainTamplate_Get] " & FMenuIDX
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetTrainTamplateMasterinfo = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'// 멀티컨텐츠 마스터 정보
	Public Function fnGetMultiContentsTopSlideSetCnt
		Dim strSql
		If FECode = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContents_TopSlideaddimgSetCount_Get] "&FECode&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetMultiContentsTopSlideSetCnt = rsget("CNT")
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
	public FMenuIDX
	public FGroupItemCheck

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
		Dim strSql, arrItem,intI
		IF FECode = "" THEN Exit Function
		IF FEGCode = "" THEN FEGCode= 0

		'strSql ="[db_item].[dbo].sp_Ten_event_GetItem ("&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&")"
		'//리뉴얼 후 교체 디바이스(1 pc , 2 mobile&app) 추가
		strSql ="EXEC [db_item].[dbo].sp_Ten_event_GetItem_newV17 "&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&", 2"

		'response.write strSql &"<br>"
		'rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"EVENTITEM",strSql,60*5)
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
				FCategoryPrdList(intI).FBrandName  	= rtrim(ltrim(db2html(arrItem(5,intI))))

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

				'// 해외직구배송작업추가
				FCategoryPrdList(intI).FDeliverFixDay 			= arrItem(40,intI)

				'// 1depth 카테고리 코드 추가
				FCategoryPrdList(intI).FCateCode 			= arrItem(41,intI)
				FCategoryPrdList(intI).FAdultType 			= arrItem(42,intI)

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

	'멀티 컨텐츠 기차형 템플릿 (MD추천상품)
	public Function fnGetEventMultiContentsTrainTamplate
		Dim strSql, arrItem
		dim totalPrice , salePercentString , couponPercentString , totalSalePercent
		If FMenuIDX = "" THEN Exit Function
		strSql ="EXEC [db_event].[dbo].[usp_WWW_Event_MultiContentsTrainTamplate_Get] "&FMenuIDX&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			arrItem = rsget.getRows()
		END IF
		rsget.close

		IF isArray(arrItem) THEN
			FTotCnt = Ubound(arrItem,2)
			redim preserve FCategoryPrdList(FTotCnt)
			For intI = 0 To FTotCnt
			set FCategoryPrdList(intI) = new CCategoryPrdItem
				FCategoryPrdList(intI).FItemID			= arrItem(0,intI)
				If FGroupItemCheck="T" Then
					FCategoryPrdList(intI).FItemName    = db2html(arrItem(1,intI))
				Else
					FCategoryPrdList(intI).FItemName    = db2html(arrItem(2,intI))
				End If
				FCategoryPrdList(intI).FSellcash		= arrItem(9,intI)
				FCategoryPrdList(intI).FOrgPrice   		= arrItem(10,intI)
				FCategoryPrdList(intI).FSaleYn     		= arrItem(11,intI)
				FCategoryPrdList(intI).Fitemcouponyn 	= arrItem(12,intI)
				FCategoryPrdList(intI).FItemCouponValue	= arrItem(13,intI)
				FCategoryPrdList(intI).Fitemcoupontype	= arrItem(14,intI)
				FCategoryPrdList(intI).FitemScore		= arrItem(4,intI)'groupcode
				FCategoryPrdList(intI).Fevalcnt			= arrItem(5,intI)'iconnew
				FCategoryPrdList(intI).FItemOptionCnt	= arrItem(6,intI)'iconbest
				FCategoryPrdList(intI).FMakerId			= arrItem(7,intI)
				If arrItem(3,intI) <> "" Then
					FCategoryPrdList(intI).FImageBasic = arrItem(3,intI)
				Else
					FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(8,intI)
				End If
				FCategoryPrdList(intI).FBrandName		= arrItem(15,intI)
				FCategoryPrdList(intI).FItemName2		= db2html(arrItem(16,intI))
				FCategoryPrdList(intI).FMobileImageUrl	= arrItem(17,intI)
				FCategoryPrdList(intI).FPCImageUrl		= arrItem(18,intI)
				FCategoryPrdList(intI).FXPosition		= arrItem(19,intI)
				FCategoryPrdList(intI).FYPosition		= arrItem(20,intI)

				call FCategoryPrdList(intI).fnProductPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)

				FCategoryPrdList(intI).FProductTotalPrice 			= totalPrice
				FCategoryPrdList(intI).FProductSalePercentString 	= salePercentString
				FCategoryPrdList(intI).FProductCouponPercentString	= couponPercentString
				FCategoryPrdList(intI).FProductTotalSalePercent		= totalSalePercent


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
	Dim vAmplitudeEventItemListType
	dim classStr, adultChkFlag, adultPopupLink, linkUrl

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
			vAmplitudeEventItemListType = "grid"
		ElseIf eItemListType = "2" Then '### 리스트형
			Response.Write "				<div class=""items type-list"">"
			vAmplitudeEventItemListType = "list"
		ElseIf eItemListType = "3" Then '### BIG형
			Response.Write "				<div class=""items type-big"">"
			vAmplitudeEventItemListType = "big"
		End If
%>
		<!--<div class="pdtListWrapV15a">-->
		<ul>
<%
			For intI =0 To iTotCnt
				classStr = ""
				linkUrl = "/category/category_itemPrd.asp?itemid="& cEventItem.FCategoryPrdList(intI).Fitemid & "&" & logparam
				adultChkFlag = session("isAdult") <> true and cEventItem.FCategoryPrdList(intI).FadultType = 1																				
				
				if adultChkFlag then
					classStr = addClassStr(classStr,"adult-item")								
				end if						
%>
			<% If cEventItem.FCategoryPrdList(intI).FItemDiv="21" Then %>			
				<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>														
					<a href="/deal/deal.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %><%=logparam%>&flag=e<%=addparam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_event_item','eventkind|eventcode|eventtype|categoryname|brand_id|itemid|group_number|item_index|list_type','<%=ekind%>|<%=eCode%>|<%=evt_type%>|<%=fnCateCodeToCategory1DepthName(cEventItem.FCategoryPrdList(intI).FCateCode)%>|<%=Replace(Replace(cEventItem.FCategoryPrdList(intI).FBrandName," ",""),"'","")%>|<%=cEventItem.FCategoryPrdList(intI).Fitemid%>|<%=intG%>|<%=intI+1%>|<%=vAmplitudeEventItemListType%>');">
					<span class="deal-badge">텐텐<i>DEAL</i></span>
						<!-- for dev msg : 상품명으로 썸네일 alt값 달면 중복되니 alt=""으로 처리해주세요. -->
						<div class="thumbnail">
							<% if (eItemListType = "1") or (eItemListType = "2") then %>
								<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
							<% else %>
								<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
							<% end if %>
							<% if adultChkFlag then %>									
							<div class="adult-hide">
								<p>19세 이상만 <br />구매 가능한 상품입니다</p>
							</div>
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
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0) & "<span class=""won"">원~</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).FItemOptionCnt & "%</b>"
										Response.Write "</div>" &  vbCrLf
									End If
								%>
							</div>
						</div>
					</a>
				</li>
			<% Else %>
				<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
					<a href="/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %><%=logparam%>&flag=e<%=addparam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_event_item','eventkind|eventcode|eventtype|categoryname|brand_id|itemid|group_number|item_index|list_type','<%=ekind%>|<%=eCode%>|<%=evt_type%>|<%=fnCateCodeToCategory1DepthName(cEventItem.FCategoryPrdList(intI).FCateCode)%>|<%=Replace(Replace(cEventItem.FCategoryPrdList(intI).FBrandName," ",""),"'","")%>|<%=cEventItem.FCategoryPrdList(intI).Fitemid%>|<%=intG%>|<%=intI+1%>|<%=vAmplitudeEventItemListType%>');">
						<%'// 해외직구배송작업추가 %>
						<% If cEventItem.FCategoryPrdList(intI).IsDirectPurchase Then %>
							<span class="abroad-badge">해외직구</span>
						<% End If %>
						<!-- for dev msg : 상품명으로 썸네일 alt값 달면 중복되니 alt=""으로 처리해주세요. -->
						<div class="thumbnail">
							<% if (eItemListType = "1") or (eItemListType = "2") then %>
								<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
							<% else %>
								<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
							<% end if %>
							<% if adultChkFlag then %>									
							<div class="adult-hide">
								<p>19세 이상만 <br />구매 가능한 상품입니다</p>
							</div>
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
						<button class="tag wish btn-wish" onclick="goWishPop('<%=cEventItem.FCategoryPrdList(intI).FItemid%>','<%=eCode%>');fnAmplitudeEventMultiPropertiesAction('click_event_item_wish','eventkind|eventcode|eventtype|categoryname|brand_id|itemid|group_number|item_index|list_type','<%=ekind%>|<%=eCode%>|<%=evt_type%>|<%=fnCateCodeToCategory1DepthName(cEventItem.FCategoryPrdList(intI).FCateCode)%>|<%=Replace(Replace(cEventItem.FCategoryPrdList(intI).FBrandName," ",""),"'","")%>|<%=cEventItem.FCategoryPrdList(intI).Fitemid%>|<%=intG%>|<%=intI+1%>|<%=vAmplitudeEventItemListType%>');">
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
	Dim vAmplitudeEventItemListType
	dim classStr, adultChkFlag, adultPopupLink, linkUrl

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
			vAmplitudeEventItemListType = "grid"
		ElseIf eItemListType = "2" Then '### 리스트형
			Response.Write "				<div class=""items type-list"">"
			vAmplitudeEventItemListType = "list"
		ElseIf eItemListType = "3" Then '### BIG형
			Response.Write "				<div class=""items type-big"">"
			vAmplitudeEventItemListType = "big"
		End If
%>
		<!--<div class="pdtListWrapV15a">-->
		<ul>
<%
			For intI =0 To iTotCnt

			classStr = ""		
			linkUrl = Request.ServerVariables("PATH_INFO") & "?" & "adtprdid="&cEventItem.FCategoryPrdList(intI).FItemID							
			adultChkFlag = session("isAdult") <> true and cEventItem.FCategoryPrdList(intI).FadultType = 1																											

			if adultChkFlag then
				classStr = addClassStr(classStr,"adult-item")								
			end if																	
%>
		<% If cEventItem.FCategoryPrdList(intI).FItemDiv="21" Then %>
			<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"& linkUrl &"', "& chkiif(IsUserLoginOK, "true", "false") &");""","")%>>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_event_item','eventkind|eventcode|eventtype|categoryname|brand_id|itemid|group_number|item_index|list_type','<%=ekind%>|<%=eCode%>|<%=evt_type%>|<%=fnCateCodeToCategory1DepthName(cEventItem.FCategoryPrdList(intI).FCateCode)%>|<%=stripSpaceChar(Replace(Replace(cEventItem.FCategoryPrdList(intI).FBrandName," ",""),"'",""))%>|<%=cEventItem.FCategoryPrdList(intI).Fitemid%>|<%=intG%>|<%=intI+1%>|<%=vAmplitudeEventItemListType%>',function(bool){if(bool) {fnAPPpopupDealProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %><%=addparam%>');}});return false;">
				<span class="deal-badge">텐텐<i>DEAL</i></span>
					<div class="thumbnail">
						<% if (eItemListType = "1") or (eItemListType = "2") then %>
							<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
						<% else %>
							<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
						<% end if %>
						<% if adultChkFlag then %>									
						<div class="adult-hide">
							<p>19세 이상만 <br />구매 가능한 상품입니다</p>
						</div>
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
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0) & "<span class=""won"">원~</span></b>"
									Response.Write "&nbsp;<b class=""discount color-red"">" & cEventItem.FCategoryPrdList(intI).FItemOptionCnt & "%</b>"
									Response.Write "</div>" &  vbCrLf
								End If
							%>
						</div>
					</div>
				</a>
			</li>
		<% Else %>
			<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"& linkUrl &"', "& chkiif(IsUserLoginOK, "true", "false") &");""","")%>>
				<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_event_item','eventkind|eventcode|eventtype|categoryname|brand_id|itemid|group_number|item_index|list_type','<%=ekind%>|<%=eCode%>|<%=evt_type%>|<%=fnCateCodeToCategory1DepthName(cEventItem.FCategoryPrdList(intI).FCateCode)%>|<%=stripSpaceChar(Replace(Replace(cEventItem.FCategoryPrdList(intI).FBrandName," ",""),"'",""))%>|<%=cEventItem.FCategoryPrdList(intI).Fitemid%>|<%=intG%>|<%=intI+1%>|<%=vAmplitudeEventItemListType%>',function(bool){if(bool) {fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %><%=addparam%>');}});return false;">
					<%'// 해외직구배송작업추가 %>
					<% If cEventItem.FCategoryPrdList(intI).IsDirectPurchase Then %>
						<span class="abroad-badge">해외직구</span>
					<% End If %>
					<div class="thumbnail">
						<% if (eItemListType = "1") or (eItemListType = "2") then %>
							<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
						<% else %>
							<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
						<% end if %>
						<% if adultChkFlag then %>									
						<div class="adult-hide">
							<p>19세 이상만 <br />구매 가능한 상품입니다</p>
						</div>
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
					<button class="tag wish btn-wish" onclick="fnAmplitudeEventMultiPropertiesAction('click_event_item_wish','eventkind|eventcode|eventtype|categoryname|brand_id|itemid|group_number|item_index|list_type','<%=ekind%>|<%=eCode%>|<%=evt_type%>|<%=fnCateCodeToCategory1DepthName(cEventItem.FCategoryPrdList(intI).FCateCode)%>|<%=Replace(Replace(cEventItem.FCategoryPrdList(intI).FBrandName," ",""),"'","")%>|<%=cEventItem.FCategoryPrdList(intI).Fitemid%>|<%=intG%>|<%=intI+1%>|<%=vAmplitudeEventItemListType%>',function(bool){if(bool) {goWishPop('<%=cEventItem.FCategoryPrdList(intI).FItemid%>','<%=eCode%>');}});">
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
			<% if cEventadd.FisArrow = 1 then  %>
			<button type="button" class="slideNav btnPrev">이전</button>
			<button type="button" class="slideNav btnNext">다음</button>
			<% end if %>
		</div>
		<% If cEventadd.FSbtmimg <> "" Then %>
		<div class="evtBtm">
			<img src="<%=cEventadd.FSbtmimg%>" alt="" />
		</div>
		<% End If %>
		<%' 슬라이드 동영상 추가 %>
		<% If cEventadd.FVideoSize<>"" And cEventadd.FVideoLink<>"" Then %>
			<div class="vod-wrap<% If cEventadd.FVideoSize="W" Then %> shape-rtgl<% End If %>">
				<div class="vod"><iframe src="<%=cEventadd.FVideoLink%>?rel=0&showinfo=0&playsinline=1&title=0&byline=0&portrait=0" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>
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

Sub sbTopSlidetemplateMD
	IF eCode = "" THEN Exit Sub
	
	Dim vSArray , intSL , gubuncls
	'template
	set cEventadd = new ClsEvtCont
	cEventadd.FECode 	= eCode
	'slide
	vSArray = cEventadd.fnGetTopSlideTemplate

		If isArray(vSArray) THEN 
			For intSL = 0 To UBound(vSArray,2)
	%>
	<div class="swiper-slide"><% If vSArray(1,intSL) <> "" Then %><a href="<%=Trim(vSArray(1,intSL))%>"><% End If %><div class="thumbnail"><img src="<%=vSArray(0,intSL)%>" /></div><% If vSArray(1,intSL) <> "" Then %></a><% End If %></div>
	<%
			Next 
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

'----------------------------------------------------
' sbMultiContentsSlidetemplate : 멀티 컨텐츠 슬라이드 템플릿 모바일
' 2019.10.16 정태훈
'----------------------------------------------------
Function sbMultiContentsSlidetemplate(MenuIDX)

	IF MenuIDX = "" THEN Exit Function
	
	Dim vSArray , intSL
	'template
	set cEventadd = new ClsEvtCont
	cEventadd.FMenuIDX 	= MenuIDX
	cEventadd.fnGetMultiContentsSlideTemplateInfo
	'slide
	vSArray = cEventadd.fnGetMultiContentsSlideTemplateImages

	If cEventadd.FSidx <> "" Then 
%>
	<script>
	$(function(){
		// slide template
		slideTemplate = new Swiper('#rolling<%=MenuIDX%> .swiper-container',{
			loop:true,
			autoplay:3000,
			autoplayDisableOnInteraction:false,
			speed:800,
			pagination:'#rolling<%=MenuIDX%> .pagination',
			paginationClickable:true,
			nextButton:'#rolling<%=MenuIDX%> .btnNext',
			prevButton:'#rolling<%=MenuIDX%> .btnPrev'
		});
	});
	</script>
	<div class="slideTemplateV15 <% If cEventadd.FStopaddimg <> "" Then %>txtFix<% End If %>">
		<% If cEventadd.FStopimg <> "" Then %>
		<div class="evtTop">
			<img src="<%=cEventadd.FStopimg%>" alt="" />
		</div>
		<% End If %>
		<div class="swiper" id="rolling<%=MenuIDX%>">
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
				<div class="pagination"></div>
				<% if cEventadd.FisArrow = 1 then  %>
				<button type="button" class="slideNav btnPrev">이전</button>
				<button type="button" class="slideNav btnNext">다음</button>
				<% end if %>
			</div>
		</div>
		<% If cEventadd.FSbtmimg <> "" Then %>
		<div class="evtBtm">
			<img src="<%=cEventadd.FSbtmimg%>" alt="" />
		</div>
		<% End If %>
		<%' 슬라이드 동영상 추가 %>
		<% If cEventadd.FVideoSize<>"" And cEventadd.FVideoLink<>"" Then %>
			<div class="vod-wrap<% If cEventadd.FVideoSize="W" Then %> shape-rtgl<% End If %>">
				<div class="vod"><iframe src="<%=cEventadd.FVideoLink%>?rel=0&showinfo=0&playsinline=1&title=0&byline=0&portrait=0" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>
			</div>
		<% End If %>
	</div>
<%
	End If 
End Function

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
Function fnGetMoTopSlideImgCnt(FECode)
	Dim strSql
	If FECode = "" THEN Exit Function
	strSql ="SELECT count(idx) as cnt FROM [db_event].[dbo].[tbl_event_top_slide_addimage] where  evt_code="&FECode&" and device='M' and isusing='Y'"
	rsget.Open strSql,dbget,1
	IF Not (rsget.EOF OR rsget.BOF) THEN
		fnGetMoTopSlideImgCnt = rsget("cnt")
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

'--------------------------------------------------------------
' sbMultiContentsView : I형 멀티 컨텐츠
' 2019-02-13 정태훈
' 순서 지정 가능, 컨텐츠 중복 가능
' 2019.10.15 6-10번 컨텐츠 추가 정태훈
'==============================================================
' memudiv 1~5
' 1. 롤링 이미지 & 영상
' 2. 영상
' 3. 브랜드 스토리
' 4. 기차형 템플릿
' 5. 추가 텍스트 박스
' 6. 상단 슬라이드
' 7. 이미지 & HTML
' 8. 이미지 템플릿 슬라이드
' 9. 연결배너
' 10. 개발파일
' 12. 가격 연동 템플릿
'--------------------------------------------------------------
Sub sbMultiContentsView
	IF eCode = "" THEN Exit Sub
	Dim vSArray , intSL , AddContents
	'멀티 컨텐츠 마스터 정보 가져오기
	set cEventadd = new ClsEvtCont
	cEventadd.FECode = eCode
	vSArray = cEventadd.fnGetEventMultiContentsMaster
	AddContents=""
	If isArray(vSArray) THEN 
		For intSL = 0 To UBound(vSArray,2)
			if vSArray(1,intSL)="1" then
				AddContents=""
				AddContents = AddContents + "<div class='evt-sliderV19'>" + vbcrlf
				AddContents = AddContents + "	<div class='swiper-container' id='multi"&Cstr(vSArray(0,intSL))&"'>" + vbcrlf
				AddContents = AddContents + "		<div class='swiper-wrapper'>" + vbcrlf
				AddContents = AddContents + sbMultiContentsDetail(vSArray(0,intSL), vSArray(1,intSL), vSArray(3,intSL))
				AddContents = AddContents + "		</div>" + vbcrlf
				AddContents = AddContents + "		<div class='pagination-progressbar'><span class='pagination-progressbar-fill'></span></div>" + vbcrlf
				AddContents = AddContents + "	</div>" + vbcrlf
				AddContents = AddContents + "</div>" + vbcrlf
				response.write AddContents
				AddContents=""
			elseif vSArray(1,intSL)="2" then
				AddContents = sbMultiContentsDetail(vSArray(0,intSL), vSArray(1,intSL), vSArray(3,intSL))
				response.write AddContents
			elseif vSArray(1,intSL)="3" then
				AddContents = sbMultiContentsDetail(vSArray(0,intSL), vSArray(1,intSL), vSArray(3,intSL))
				response.write AddContents
			elseif vSArray(1,intSL)="4" then
				AddContents=""
				AddContents = AddContents + "<div class='prd-evtV19'>" + vbcrlf
				AddContents = AddContents + "	<div class='items type-list' id='multi"&Cstr(vSArray(0,intSL))&"'>" + vbcrlf
				AddContents = AddContents + "		<ul>" + vbcrlf
				AddContents = AddContents + sbMultiContentsDetail(vSArray(0,intSL), vSArray(1,intSL), vSArray(3,intSL))
				AddContents = AddContents + "		</ul>" + vbcrlf
				AddContents = AddContents + "	</div>" + vbcrlf
				AddContents = AddContents + "</div>" + vbcrlf
				response.write AddContents
				AddContents=""
			elseif vSArray(1,intSL)="5" then
				AddContents = sbMultiContentsDetail(vSArray(0,intSL), vSArray(1,intSL), vSArray(3,intSL))
				response.write AddContents
			elseif vSArray(1,intSL)="6" then
				AddContents=""
				AddContents = AddContents + "<div class='event-article event-full-rolling-type'>" + vbcrlf
				AddContents = AddContents + "	<div class='evt-sliderV19'>" + vbcrlf
				AddContents = AddContents + "		<div class='swiper-container'>" + vbcrlf
				AddContents = AddContents + "			<div class='swiper-wrapper'>" + vbcrlf
				AddContents = AddContents + sbMultiContentsDetail(vSArray(0,intSL), vSArray(1,intSL), vSArray(3,intSL))
				AddContents = AddContents + "			</div>" + vbcrlf
				AddContents = AddContents + "			<div class='pagination-progressbar'><span class='pagination-progressbar-fill'></span></div>" + vbcrlf
				AddContents = AddContents + "		</div>" + vbcrlf
				AddContents = AddContents + "	</div>" + vbcrlf
				
				if CopyHide="1" then
				AddContents = AddContents + "	<section class='hgroup-event' style='display:none'>" + vbcrlf
				else
				AddContents = AddContents + "	<section class='hgroup-event'>" + vbcrlf
				end if
				AddContents = AddContents + "		<h2 style='word-break:keep-all;' id='title'>" + title_mo + "</h2>" + vbcrlf
				AddContents = AddContents + "		<p class='subcopy' style='word-break:keep-all;'>" + evt_subname + "</p>" + vbcrlf
				AddContents = AddContents + "		<div class='labels'>" + vbcrlf
			If blnsale Or blncoupon Then
				If blnsale And salePer>"0" Then
				AddContents = AddContents + "		<span class='labelV19 label-red' id='esale'>~" + salePer + "%</span>" + vbcrlf
				end if
				If blncoupon And saleCPer>"0" Then
				AddContents = AddContents + "		&nbsp;<span class='labelV19 label-green'>~" + saleCPer + "%</span>" + vbcrlf
				end if
			end if
				If blngift Then
				AddContents = AddContents + "		&nbsp;<span class='labelV19 label-blue'>GIFT</span>" + vbcrlf
				end if
				If isOnePlusOne Then
				AddContents = AddContents + "		&nbsp;<span class='labelV19 label-blue'>1+1</span>" + vbcrlf
				end if
				If isNew Then
				AddContents = AddContents + "		&nbsp;<span class='labelV19 label-black'>런칭</span>" + vbcrlf
				end if
				If blncomment or blnbbs or blnitemps Then
				AddContents = AddContents + "		&nbsp;<span class='labelV19 label-black'>참여</span>" + vbcrlf
				end if
				If isOnlyTen Then
				AddContents = AddContents + "		&nbsp;<span class='labelV19 label-black'>단독</span>" + vbcrlf
				end if
				AddContents = AddContents + "		</div>" + vbcrlf
				AddContents = AddContents + "	</section>" + vbcrlf
				
				AddContents = AddContents + "</div>" + vbcrlf
				response.write AddContents
				AddContents=""
			elseif vSArray(1,intSL)="7" then
				AddContents = sbMultiContentsDetail(vSArray(0,intSL), vSArray(1,intSL), vSArray(3,intSL))
				response.write AddContents
			elseif vSArray(1,intSL)="8" then
				AddContents = sbMultiContentsDetail(vSArray(0,intSL), vSArray(1,intSL), vSArray(3,intSL))
				response.write AddContents
			elseif vSArray(1,intSL)="9" then
				AddContents = sbMultiContentsDetail(vSArray(0,intSL), vSArray(1,intSL), vSArray(3,intSL))
				response.write AddContents
			elseif vSArray(1,intSL)="10" then
				AddContents = sbMultiContentsDetail(vSArray(0,intSL), vSArray(1,intSL), vSArray(3,intSL))
				response.write AddContents
			elseif vSArray(1,intSL)="11" then
				AddContents = "<div class='desc-event'>" & vbcrlf
				AddContents = AddContents & sbMultiContentsDetail(vSArray(0,intSL), vSArray(1,intSL), vSArray(3,intSL))
				AddContents = AddContents & "</div>" & vbcrlf
				response.write AddContents
			elseif vSArray(1,intSL)="12" then
				Dim TopMargin, TopMarginColor, BottomMargin, BottomMarginColor
				TopMargin = vSArray(9,intSL) '// 상단 여백
				TopMarginColor = chkiif(vSArray(18,intSL) <> "", vSArray(18,intSL), "#FFF") '// 상단 여백 배경 색 코드
				BottomMargin = vSArray(19,intSL) '// 하단 여백
				BottomMarginColor = chkiif(vSArray(20,intSL) <> "", vSArray(20,intSL), "#FFF") '// 하단 여백 배경 색 코드

				AddContents = ""
				AddContents = AddContents & "<div class='event-priceV20'>" & vbcrlf
				If TopMargin <> "" And TopMargin <> "0" Then
					AddContents = AddContents & "<div class='blank' style='height:50px; background-color:" & TopMarginColor & ";'></div>"
				End If
				AddContents = AddContents & getMultiItemContentsList(vSArray(0,intSL) , vSArray(2,intSL) , vSArray(3,intSL), vSArray(10,intSL) _
										, vSArray(11,intSL), vSArray(12,intSL), vSArray(13,intSL), vSArray(14,intSL), vSArray(15,intSL) _
										, vSArray(16,intSL), vSArray(5,intSL))
				If BottomMargin <> "" And BottomMargin <> "0" Then
					AddContents = AddContents & "<div class='blank' style='height:50px; background-color:" & BottomMarginColor & ";'></div>"
				End If
				AddContents = AddContents & "</div>" & vbcrlf
				response.write AddContents
			end if
		Next 
	End If
End Sub

'/*
' * IDX 				: 인덱스
' * GroupItemPriceView	: 가격 노출 여부
' * GroupItemCheck		: 
' * TextColor			: 상품명/브랜드명 색 코드
' * GroupItemTitleName	: 상품명 노출 여부
' * GroupItemViewType	: 타입
' * GroupItemBrandName	: 브랜드명 노출 여부
' * SaleColor			: 할인율 색 코드
' * PriceColor			: 가격 색 코드
' * OrgPriceColor		: 원가 색 코드
' * BGImage				: 배경이미지
' */
public function getMultiItemContentsList(IDX , GroupItemPriceView , GroupItemCheck , TextColor , GroupItemTitleName , GroupItemViewType , GroupItemBrandName , SaleColor _
						 , PriceColor , OrgPriceColor, BGImage)
	IF IDX = "" THEN Exit Function
	IF GroupItemViewType = "" THEN Exit Function

	'// 색 Default 설정
	If TextColor = "" Then TextColor = "#222" End If
	If SaleColor = "" Then SaleColor = "#222" End If
	If PriceColor = "" Then PriceColor = "#222" End If
	If OrgPriceColor = "" Then OrgPriceColor = "#222" End If

	DIM BodyContents , ArrContents , iTotCnt , cEventItem , intSL
	dim totalPrice , salePercentString , couponPercentString , totalSalePercent
		
	Set cEventItem = New ClsEvtItem
	cEventItem.FMenuIDX = IDX
	cEventItem.FGroupItemCheck = GroupItemCheck
	cEventItem.fnGetEventMultiContentsTrainTamplate
	iTotCnt = cEventItem.FTotCnt

	ArrContents = ""
	If (iTotCnt >= 0) Then
		IF GroupItemViewType = "A" OR GroupItemViewType = "B" THEN '// A or B
			For intSL = 0 To iTotCnt
				'// 배경이미지
				Dim thisBackgroundImage
				If cEventItem.FCategoryPrdList(intSL).FMobileImageUrl <> "" Then
					thisBackgroundImage = cEventItem.FCategoryPrdList(intSL).FMobileImageUrl
				Else
					thisBackgroundImage = cEventItem.FCategoryPrdList(intSL).FImageBasic
				End If

				ArrContents = ArrContents & "<div class='event-itemV20 "& chkiif( GroupItemViewType = "A" , "typeA" , "typeB" ) &"'>"
				if isApp=1 then
					ArrContents = ArrContents & "<a href=""javascript:fnAPPpopupProduct('" + Cstr(cEventItem.FCategoryPrdList(intSL).FItemID) + logparam + "')"">" & vbcrlf
				Else
					ArrContents = ArrContents & "<a href='/category/category_itemPrd.asp?itemid=" + Cstr(cEventItem.FCategoryPrdList(intSL).FItemID) + logparam + "'>" & vbcrlf
				End If
				ArrContents = ArrContents & "<div class='thumbnail'><img src='"& thisBackgroundImage &"' alt='"& cEventItem.FCategoryPrdList(intSL).FItemName &"'></div>"
				ArrContents = ArrContents & createPriceLinkageItemDescHtml(cEventItem.FCategoryPrdList(intSL), GroupItemBrandName _
								 ,GroupItemTitleName, GroupItemPriceView, TextColor, SaleColor, OrgPriceColor, PriceColor)
				ArrContents = ArrContents & "</a>"
				ArrContents = ArrContents & "</div>"
			Next
		ELSE '// 세로형(Type A, B)
			Dim horizonYn, thisContentType, classA, classB, borderStyle

			horizonYn = chkiif(GroupItemViewType = "C" or GroupItemViewType = "E", "Y", "N") '// 가로형:Y, 세로형:N
			thisContentType = chkiif(GroupItemViewType = "C" or GroupItemViewType = "D", "A", "B") '// Type
			classA = chkiif(horizonYn = "Y", "type-grid", "type-list") '// 껍데기 div 클래스
			classB = "type" & thisContentType '// li아래 div 클래스
			borderStyle = chkiif(horizonYn = "Y", "style='border-color:'" & OrgPriceColor & "'", "") '// 세로형이면 li아래 div에 border-color스타일 추가(정가 색코드와 동일)

			ArrContents = "<div class='items " & classA & "' " & chkiif(BGImage<>"", "style='background-image:url(" & BGImage & ");'", "") & ">"
			ArrContents = ArrContents & "<ul>"
				FOR intSL = 0 TO iTotCnt
					'// 상품이미지
					Dim thisItemImage
					If cEventItem.FCategoryPrdList(intSL).FMobileImageUrl <> "" Then
						thisItemImage = cEventItem.FCategoryPrdList(intSL).FMobileImageUrl
					Else
						thisItemImage = cEventItem.FCategoryPrdList(intSL).FImageBasic
					End If

					ArrContents = ArrContents & "<li>"
					ArrContents = ArrContents & "<div class='event-itemV20 "& classB &"' " & borderStyle & ">"
					if isApp = 1 then
						ArrContents = ArrContents & "<a href=""javascript:fnAPPpopupProduct('" + Cstr(cEventItem.FCategoryPrdList(intSL).FItemID) + logparam + "')"">"
					Else
						ArrContents = ArrContents & "<a href='/category/category_itemPrd.asp?itemid=" + Cstr(cEventItem.FCategoryPrdList(intSL).FItemID) + logparam + "'>"
					End If
					ArrContents = ArrContents & "<div class='thumbnail'><img src='" & thisItemImage & "' alt=''></div>"
					ArrContents = ArrContents & createPriceLinkageItemDescHtml(cEventItem.FCategoryPrdList(intSL), GroupItemBrandName _
								 ,GroupItemTitleName, GroupItemPriceView, TextColor, SaleColor, OrgPriceColor, PriceColor)
					ArrContents = ArrContents & "</a>"
					ArrContents = ArrContents & "</div>"
					ArrContents = ArrContents & "</li>"

				NEXT
			ArrContents = ArrContents & "</ul>"
			ArrContents = ArrContents & "</div>"

		END IF
	End If

	getMultiItemContentsList = ArrContents

	Set cEventItem = Nothing
end function 

'// 가격연동 템플릿 상품 desc영역 HTML 생성
' = linkItem		: 상품
' = brandViewYn		: 브랜드명 노출 여부 (Y/N)
' = nameViewYn		: 상품명 노출 여부 (Y/N)
' = priceViewYn		: 가격영역 노출 여부 (Y/N)
' = textColor		: 브랜드명/상품명 텍스트 색코드
' = saleColor		: 할인율 텍스트 색코드
' = orgPriceColor	: 정가 텍스트 색코드
' = priceColor		: 가격 텍스트 색코드
Private Function createPriceLinkageItemDescHtml(linkItem, brandViewYn, nameViewYn, priceViewYn, textColor, saleColor, orgPriceColor, priceColor)
	Dim contentHtml
	contentHtml = "<div class='desc'>"
	If brandViewYn = "Y" Then '// 브랜드명
		contentHtml = contentHtml & "<span class='brand' style='color:" & textColor & ";'>"& linkItem.FBrandName &"</span>"
	End If
	If nameViewYn = "Y" Then '// 상품명
		contentHtml = contentHtml & "<p class='name' style='color:" & textColor & ";'>"& linkItem.FItemName &"</p>"
	End If
	If priceViewYn = "Y" Then '// 가격정보
		contentHtml = contentHtml & "<div class='price'>"
		If linkItem.FProductTotalSalePercent <> "" And linkItem.FProductTotalSalePercent <> "0" Then '// 할인율
			contentHtml = contentHtml & "<p class='origin-price' style='color:" & orgPriceColor & ";'>"& FormatNumber(linkItem.getOrgPrice,0) &"</p>"
			contentHtml = contentHtml & "<b class='discount' style='color:" & saleColor & ";'>"& linkItem.FProductTotalSalePercent &"</b>"
		End If
		contentHtml = contentHtml & "<span class='sum' style='color:" & priceColor & ";'>"& linkItem.FProductTotalPrice & "원</span>"
		contentHtml = contentHtml & "</div>"
	End If
	createPriceLinkageItemDescHtml = contentHtml & "</div>"
End Function

Public Function sbMultiContentsDetail(IDX, MenuDIV, GroupItemCheck)
	IF IDX = "" THEN Exit Function

	dim ArrContents, vSArray, intSL, iTotCnt, cEventItem
	'멀티 컨텐츠 마스터 정보 가져오기
	set cEventadd = new ClsEvtCont
	cEventadd.FMenuIDX = IDX
	if MenuDIV="1" then
		vSArray = cEventadd.fnGetEventMultiContentsSwife
	elseif MenuDIV="2" then
		vSArray = cEventadd.fnGetEventMultiContentsVideo
	elseif MenuDIV="3" then
		vSArray = cEventadd.fnGetEventMultiContentsBrandStory
	elseif MenuDIV="4" then
		vSArray = cEventadd.fnGetTrainTamplateMasterinfo
		Set cEventItem = New ClsEvtItem
		cEventItem.FMenuIDX = IDX
		cEventItem.FGroupItemCheck = GroupItemCheck
		cEventItem.fnGetEventMultiContentsTrainTamplate
		iTotCnt = cEventItem.FTotCnt
	elseif MenuDIV="5" then
		vSArray = cEventadd.fnGetEventMultiContentsCustomBox
	elseif MenuDIV="6" then
		vSArray = cEventadd.fnGetTopSlideTemplateMulti
	elseif MenuDIV="7" then
		vSArray = cEventadd.fnGetImageHtmlTemplate
	elseif MenuDIV="9" then
		vSArray = cEventadd.fnGetMoMultiAddBanner
	elseif MenuDIV="10" then
		vSArray = cEventadd.fnGetImageHtmlTemplate
	elseif MenuDIV="11" then
		vSArray = cEventadd.fnGetImageMapTemplate
	end if
	ArrContents=""
	if MenuDIV="4" then
		If (iTotCnt >= 1) Then
			For intSL=0 To iTotCnt
				ArrContents = ArrContents + "<li>" + vbcrlf
				If GroupItemCheck="T" Then
					if cEventItem.FCategoryPrdList(intSL).FItemID <> "" then
						if isApp=1 then
							ArrContents = ArrContents + "	<a href=""javascript:fnAPPpopupProduct('" + Cstr(cEventItem.FCategoryPrdList(intSL).FItemID) + logparam + "')"">" + vbcrlf
						Else
							ArrContents = ArrContents + "	<a href='/category/category_itemPrd.asp?itemid=" + Cstr(cEventItem.FCategoryPrdList(intSL).FItemID) + logparam + "'>" + vbcrlf
						End If
					else
						ArrContents = ArrContents + "	<a href='#group" + Cstr(cEventItem.FCategoryPrdList(intSL).FitemScore) + "'>" + vbcrlf
					end if
				ElseIf GroupItemCheck="B" Then
					if isApp=1 then
						ArrContents = ArrContents + "	<a href=""javascript:fnAPPpopupBrand('" + cEventItem.FCategoryPrdList(intSL).FMakerid + "');"">" + vbcrlf
					Else
						ArrContents = ArrContents + "	<a href=""javascript:GoToBrandShop('" + cEventItem.FCategoryPrdList(intSL).FMakerid + "');"">" + vbcrlf
					End If
				Else
					if isApp=1 then
						ArrContents = ArrContents + "	<a href=""javascript:fnAPPpopupProduct('" + Cstr(cEventItem.FCategoryPrdList(intSL).FItemID) + logparam + "')"">" + vbcrlf
					Else
						ArrContents = ArrContents + "	<a href='/category/category_itemPrd.asp?itemid=" + Cstr(cEventItem.FCategoryPrdList(intSL).FItemID) + logparam + "'>" + vbcrlf
					End If
				End If

				ArrContents = ArrContents + "	<div class='thumbnail'>" + vbcrlf
				ArrContents = ArrContents + "		<img src='" + cEventItem.FCategoryPrdList(intSL).FImageBasic + " ' alt='" + cEventItem.FCategoryPrdList(intSL).FItemName + "'>" + vbcrlf
				ArrContents = ArrContents + "	</div>" + vbcrlf
				ArrContents = ArrContents + "	<div class='desc'>" + vbcrlf
				ArrContents = ArrContents + "		<p class='name'>" + cEventItem.FCategoryPrdList(intSL).FItemName + "</p>" + vbcrlf
				If vSArray(0,0)<>"N" Then
				ArrContents = ArrContents + "		<div class='price'>" + vbcrlf
														If cEventItem.FCategoryPrdList(intSL).IsSaleItem Or cEventItem.FCategoryPrdList(intSL).isCouponItem Then
															If cEventItem.FCategoryPrdList(intSL).IsSaleItem and not(cEventItem.FCategoryPrdList(intSL).isCouponItem) Then
				ArrContents = ArrContents + "			<b class='discount color-red'>" + cEventItem.FCategoryPrdList(intSL).getSalePro + " </b>" + vbcrlf
				ArrContents = ArrContents + "			<span class='sum'>" + FormatNumber(cEventItem.FCategoryPrdList(intSL).getRealPrice,0) + " <span class='won'>원</span></span>" + vbcrlf
															elseIf not(cEventItem.FCategoryPrdList(intSL).IsSaleItem) and cEventItem.FCategoryPrdList(intSL).isCouponItem Then
				ArrContents = ArrContents + "			<b class='discount color-green'>" + cEventItem.FCategoryPrdList(intSL).GetCouponDiscountStr + " </b>" + vbcrlf
				ArrContents = ArrContents + "			<span class='sum'>" + FormatNumber(cEventItem.FCategoryPrdList(intSL).GetCouponAssignPrice,0) + " <span class='won'>원</span></span>" + vbcrlf
															else
				ArrContents = ArrContents + "			<b class='discount color-red'>" + cEventItem.FCategoryPrdList(intSL).getSalePro + " </b>" + vbcrlf
				ArrContents = ArrContents + "			<b class='discount color-green'> + " + cEventItem.FCategoryPrdList(intSL).GetCouponDiscountStr + " </b>" + vbcrlf
				ArrContents = ArrContents + "			<span class='sum'>" + FormatNumber(cEventItem.FCategoryPrdList(intSL).GetCouponAssignPrice,0) + " <span class='won'>원</span></span>" + vbcrlf
															End If
														Else
				ArrContents = ArrContents + "			<span class='sum'>" + FormatNumber(cEventItem.FCategoryPrdList(intSL).getRealPrice,0) + " <span class='won'>원</span></span>" + vbcrlf
														End If
				ArrContents = ArrContents + "		</div>" + vbcrlf
				End If
				ArrContents = ArrContents + "		<div class='label-group'>" + vbcrlf
														If cEventItem.FCategoryPrdList(intSL).Fevalcnt="Y" Then
				ArrContents = ArrContents + "			<em class='new-label'>NEW</em>" + vbcrlf
														End If
														If cEventItem.FCategoryPrdList(intSL).FItemOptionCnt="Y" Then
				ArrContents = ArrContents + "			<em class='best-label'>BEST</em>" + vbcrlf
														End If
				ArrContents = ArrContents + "		</div>" + vbcrlf
				ArrContents = ArrContents + "	</div>" + vbcrlf
				ArrContents = ArrContents + "	</a>" + vbcrlf
				ArrContents = ArrContents + "</li>" + vbcrlf
			Next
		End If
	elseif MenuDIV="11" then
		If isArray(vSArray) then
			ArrContents = ArrContents & "<img src='" & vSArray(0,0) & "' usemap='#CustomMap" & Cstr(IDX) & "' />" & vbcrlf
			ArrContents = ArrContents & "<map name='CustomMap" & Cstr(IDX) & "'>" & vbcrlf
			For intSL = 0 To UBound(vSArray,2)
				if isapp then
					ArrContents = ArrContents & "	<area shape='rect' coords='" & Cstr(vSArray(1,intSL)) & "," & Cstr(vSArray(2,intSL)) & "," & Cstr(vSArray(3,intSL)) & "," & Cstr(vSArray(4,intSL)) & "' href='javascript:fnAPPpopupAutoUrl(""" & Cstr(vSArray(5,intSL)) & """)' onfocus='this.blur();'>" & vbcrlf
				else
					ArrContents = ArrContents & "	<area shape='rect' coords='" & Cstr(vSArray(1,intSL)) & "," & Cstr(vSArray(2,intSL)) & "," & Cstr(vSArray(3,intSL)) & "," & Cstr(vSArray(4,intSL)) & "' href='" & Cstr(vSArray(5,intSL)) & "' onfocus='this.blur();'>" & vbcrlf
				end if
			Next
			ArrContents = ArrContents & "</map>" & vbcrlf
		end if
	else
		If isArray(vSArray) THEN
			For intSL = 0 To UBound(vSArray,2)
				if MenuDIV="1" then
					ArrContents = ArrContents + "			<div class='swiper-slide' id='multi"&Cstr(IDX)&"'>" + vbcrlf
					ArrContents = ArrContents + "				<div class='thumbnail'><img src='" + vSArray(0,intSL) + "' alt='' /></div>" + vbcrlf '이미지
					ArrContents = ArrContents + "			</div>" + vbcrlf
				elseif MenuDIV="2" then
					ArrContents = ArrContents + "<div class='vod-wrap shape-rtgl' id='multi"&Cstr(IDX)&"'>" + vbcrlf
					ArrContents = ArrContents + "	<div class='vod'>" + vbcrlf
					ArrContents = ArrContents + "		" + vSArray(0,intSL) + "" + vbcrlf'동영상
					ArrContents = ArrContents + "	</div>" + vbcrlf
					ArrContents = ArrContents + "</div>" + vbcrlf
				elseif MenuDIV="3" then
					ArrContents = ArrContents + "<div class='brand-eventV19' id='multi"&Cstr(IDX)&"'>" + vbcrlf
					if vSArray(0,intSL)<>"" then
					ArrContents = ArrContents + "	<h3>" + vSArray(0,intSL) + "</h3>" + vbcrlf
						if isApp=1 then
							ArrContents = ArrContents + "	<a href=""javascript:fnAPPpopupBrand('" + vSArray(2,intSL) + "');"" class='btn-go-brand'>BRAND HOME</a>" + vbcrlf
						Else
							ArrContents = ArrContents + "	<a href=""javascript:GoToBrandShop('" + vSArray(2,intSL) + "');"" class='btn-go-brand'>BRAND HOME</a>" + vbcrlf
						End If
					
					end if
					ArrContents = ArrContents + "	<div class='txt'>" + nl2br(db2html(vSArray(1,intSL))) + "</div>" + vbcrlf
					ArrContents = ArrContents + "</div>" + vbcrlf
				elseif MenuDIV="5" then
					ArrContents = ArrContents + "<div class='desc-event' id='multi"&Cstr(IDX)&"'>" + vbcrlf
					ArrContents = ArrContents + "	" + nl2br(db2html(vSArray(1,intSL))) + vbcrlf
					ArrContents = ArrContents + "</div>" + vbcrlf
				elseif MenuDIV="6" then
					ArrContents = ArrContents + "<div class='swiper-slide' id='multi"&Cstr(IDX)&"'>" + vbcrlf
						If vSArray(1,intSL) <> "" Then
					ArrContents = ArrContents + "	<a href='"&Trim(vSArray(1,intSL))&"'>"
						End If
					ArrContents = ArrContents + "<div class='thumbnail'><img src='"&vSArray(0,intSL)&"' /></div>"
						If vSArray(1,intSL) <> "" Then
					ArrContents = ArrContents + "</a>" + vbcrlf
						End If
					ArrContents = ArrContents + "</div>" + vbcrlf
				elseif MenuDIV="7" then
					if vSArray(0,intSL)<>"" then
					ArrContents = ArrContents + "<div><img src='" & vSArray(0,intSL) & "' usemap='#Mainmap" & Cstr(IDX) & "' /></div>" + vbcrlf
					end if
					ArrContents = ArrContents + "<div>" & vSArray(1,intSL) & "</div>" + vbcrlf
				elseif MenuDIV="9" then
					If vSArray(1,intSL) <> "" Then
						If vSArray(3,intSL)<>"" Then
							if isApp=1 then
								If instr(vSArray(3,intSL),"#group")>0 Then
									ArrContents = ArrContents + "<a href='" & vSArray(3,intSL) & "'><img src='"& vSArray(1,intSL) &"'></a>" + vbcrlf
								elseIf instr(vSArray(3,intSL),"#replyList")>0 Then
									ArrContents = ArrContents + "<a href='" & vSArray(3,intSL) & "'><img src='"& vSArray(1,intSL) &"'></a>" + vbcrlf
								elseIf instr(vSArray(3,intSL),"#replyPrdList")>0 Then
									ArrContents = ArrContents + "<a href='" & vSArray(3,intSL) & "'><img src='"& vSArray(1,intSL) &"'></a>" + vbcrlf
								else
									ArrContents = ArrContents + "<a href=""javascript:fnAPPpopupAutoUrl('" & vSArray(3,intSL) & gaparamchk(vSArray(3,intSL),"&pEtr="&eCode) &"')""><img src='"& vSArray(1,intSL) &"' alt='"& vSArray(2,intSL) &"'></a>" + vbcrlf
								end if
							Else
								ArrContents = ArrContents + "<a href='"& chkiif(vSArray(3,intSL) <> "" And InStr("#",vSArray(3,intSL)) < 0,vSArray(3,intSL) & gaparamchk(vSArray(3,intSL),"&pEtr="&eCode),vSArray(3,intSL)) &"'><img src='"& vSArray(1,intSL) &"' alt='"& vSArray(2,intSL) &"'></a>" + vbcrlf
							End If
						Else
							ArrContents = ArrContents + "<img src='"& vSArray(1,intSL) &"' alt='"& vSArray(2,intSL) &"'>" + vbcrlf
						End If
					End If
				elseif MenuDIV="10" then
					ArrContents = ArrContents + "<div width='100%'>" & server.execute(vSArray(0,intSL)) & "</div>" + vbcrlf
				end if
			Next
		End If
	End If

	if MenuDIV="8" then
		sbMultiContentsDetail=sbMultiContentsSlidetemplate(IDX)
	else
		sbMultiContentsDetail=ArrContents
	end if
End Function
%>