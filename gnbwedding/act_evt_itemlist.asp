<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%'쇼핑찬스 이벤트 내용보기
dim eCode : eCode   = requestCheckVar(Request("eventid"),10) '이벤트 코드번호
dim cEvent, cEventItem, arrItem, arrGroup, intI, intG , intT
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, eName, esdate, eedate, estate, eregdate, epdate, bimg, eItemListType, eOnlyName
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply, edispcate
dim etemplate_mo, emimg , emimg_mo , eitemsort, ebrand,gimg,blnFull,blnItemifno,blnitempriceyn, LinkEvtCode, blnBlogURL
dim itemid : itemid = ""
Dim evtFile_mo,  evtFileyn_mo
dim egCode, itemlimitcnt,iTotCnt
dim cdl_e, cdm_e, cds_e
dim com_egCode : com_egCode = 0
Dim emimgAlt , bimgAlt, isMyFavEvent, clsEvt, vDateView
Dim j
Dim arrTopGroup , sgroup_m '//그룹 랜덤
Dim cEventadd , slide_m_flag '//슬라이드 사용 미사용
Dim ThemeColorCode, ThemeBarColorCode, endlessView, videoFullLink
Dim comm_isusing, comm_text, freebie_img, comm_start, comm_end, gift_isusing, gift_text1, gift_img1, gift_text2, gift_img2
Dim gift_text3, gift_img3, usinginfo, using_text1, using_contents1, using_text2, using_contents2, using_text3, using_contents3
Dim mdthememo, themecolormo, textbgcolormo, mdbntypemo, salePer, saleCPer, SocName_Kor, evt_type, title_mo, eventtype_mo

'//logparam
Dim logparam : logparam = "&pEtr="&eCode
Dim searchback_Param : searchback_Param = requestCheckVar(request("pNtr"),20)
Dim addparam
If searchback_Param <> "" Then
	addparam = "&pNtr="& server.URLEncode(searchback_Param)
End If

'//2015이벤트
Dim evt_bannerimg_mo , evt_mo_listbanner , evt_html_mo , vIsweb , vIsmobile , vIsapp , evt_subname , blnbookingsell
Dim arrTextTitle
Dim arrAddbanner , evt_m_addimg_cnt , intAi '이미지 추가

Dim upin '카카오 이벤트 key값 parameter
	upin = requestCheckVar(Request("upin"),200)

Dim vScope '// 별에서 온 운세 값(58021)
	vScope = requestCheckVar(Request("vScope"),200)

IF eCode = "" THEN
	'response.redirect("/shoppingtoday/shoppingchance_allevent.asp")
	Call Alert_Return("이벤트번호가 없습니다.")
	dbget.close()	:	response.End
elseif Not(isNumeric(eCode)) then
	Call Alert_Return("잘못된 이벤트번호입니다.")
	dbget.close()	:	response.End
ElseIf eCode = "75209" THEN		'2016-12-27 10:46 김진영 수정 / 사은품 품절로 다른 이벤트로 리다이렉트
	response.redirect("/event/eventmain.asp?eventid=75249")
	dbget.close()	:	response.End
ElseIf eCode = "77547" THEN		'2017-04-17 이종화 수정 // 브랜드 위크 리스트로 리다이렉트
	response.redirect("/shoppingtoday/shoppingchance_allevent.asp?scTgb=bw")
	dbget.close()	:	response.End
END IF

egCode = requestCheckVar(Request("eGC"),10)	'이벤트 그룹코드
IF egCode = "" THEN egCode = 0

	itemlimitcnt = 105	'상품최대갯수
	'이벤트 개요 가져오기
	set cEvent = new ClsEvtCont
		cEvent.FECode = eCode

		cEvent.fnGetEvent

		eCode		= cEvent.FECode
		ekind		= cEvent.FEKind
		emanager	= cEvent.FEManager
		escope		= cEvent.FEScope
		eName		= cEvent.FEName
		esdate		= cEvent.FESDate
		eedate		= cEvent.FEEDate
		estate		= cEvent.FEState
		eregdate	= cEvent.FERegdate
		epdate		= cEvent.FEPDate
		ecategory	= cEvent.FECategory
		ecateMid	= cEvent.FECateMid
		blnsale		= cEvent.FSale
		blngift		= cEvent.FGift
		blncoupon	= cEvent.FCoupon
		blncomment	= cEvent.FComment
		blnbbs		= cEvent.FBBS
		blnitemps	= cEvent.FItemeps
		blnapply	= cEvent.FApply
		etemplate_mo= cEvent.FTemplate_mo
		emimg		= cEvent.FEMimg
		emimg_mo	= cEvent.FEMimg_mo
		eitemsort	= cEvent.FItemsort
		ebrand		= cEvent.FBrand
		gimg		= cEvent.FGimg
		blnFull		= cEvent.FFullYN
		blnItemifno = cEvent.FIteminfoYN
		blnitempriceyn = cEvent.FItempriceYN
		LinkEvtCode = cEvent.FLinkEvtCode
		blnBlogURL	= cEvent.FblnBlogURL
		edispcate	= cEvent.FEDispCate
		eItemListType = cEvent.FEItemListType
		evtFileyn_mo	= cEvent.FevtFileyn_mo
		evtFile_mo		= cEvent.FevtFile_mo
		SocName_Kor = cEvent.FSocName_Kor

		vDateView			= cEvent.FDateViewYN
		'//2015추가
		evt_mo_listbanner	= cEvent.FEmolistbanner
		evt_html_mo			= cEvent.Fevt_html_mo
		vIsweb				= cEvent.Fisweb
		vIsmobile			= cEvent.Fismobile
		vIsapp				= cEvent.Fisapp
		evt_subname			= cEvent.Fevt_subname
		blnbookingsell		= cEvent.Fisbookingsell
		evt_bannerimg_mo	= cEvent.Fevt_bannerimg_mo

		sgroup_m			=	cEvent.FEsgroup_m '//그룹형 랜덤 플레그

		slide_m_flag		=	cEvent.FESlide_M_Flag '// 슬라이드 모바일 플레그
		evt_m_addimg_cnt	=	cEvent.FEvt_m_addimg_cnt '// 이벤트 추가 이미지 카운트

		mdthememo = cEvent.Fmdthememo
		themecolormo = cEvent.Fthemecolormo
		textbgcolormo = cEvent.Ftextbgcolormo
		mdbntypemo = cEvent.Fmdbntypemo
		comm_isusing = cEvent.Fcomm_isusing
		comm_text = cEvent.Fcomm_text
		freebie_img = cEvent.Ffreebie_img
		comm_start = cEvent.Fcomm_start
		comm_end = cEvent.Fcomm_end
		gift_isusing = cEvent.Fgift_isusing
		gift_text1 = cEvent.Fgift_text1
		gift_img1 = cEvent.Fgift_img1
		gift_text2 = cEvent.Fgift_text2
		gift_img2 = cEvent.Fgift_img2
		gift_text3 = cEvent.Fgift_text3
		gift_img3 = cEvent.Fgift_img3
		usinginfo = cEvent.Fusinginfo
		using_text1 = cEvent.Fusing_text1
		using_contents1 = cEvent.Fusing_contents1
		using_text2 = cEvent.Fusing_text2
		using_contents2 = cEvent.Fusing_contents2
		using_text3 = cEvent.Fusing_text3
		using_contents3 = cEvent.Fusing_contents3
		salePer = cEvent.FsalePer
		saleCPer = cEvent.FsaleCPer
		evt_type = cEvent.fnEventTypeName
		title_mo = cEvent.Ftitle_mo
		endlessView = cEvent.FendlessView
		eventtype_mo = cEvent.Feventtype_mo
		videoFullLink = cEvent.FvideoFullLink

		If Not(cEvent.FEItemImg="" or isNull(cEvent.FEItemImg)) then
			bimg		= cEvent.FEItemImg
		ElseIf cEvent.FEItemID<>"0" Then
			If cEvent.Fbasicimg600 <> "" Then
				bimg		= "http://webimage.10x10.co.kr/image/basic600/" & GetImageSubFolderByItemid(cEvent.FEItemID) & "/" & cEvent.Fbasicimg600 & ""
			Else
				bimg		= "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(cEvent.FEItemID) & "/" & cEvent.Fbasicimg & ""
			End IF
		Else
			bimg		= ""
		End IF

		'PC, 모바일 타입 분리 체크 2017.12.12 정태훈
		If evt_type="90" Then
			If eventtype_mo="80" Then
				etemplate_mo="9"
			End If
		End If

		'그룹형(etemplate_mo = "3")일때만 그룹내용 가져오기
		IF etemplate_mo = "3" OR etemplate_mo = "9" Then
			If sgroup_m And egCode = "0" Then '// 그룹형 랜덤 체크 되었을때
				arrTopGroup = cEvent.fnGetEventGroupTop
				egCode = arrTopGroup(0,0)
			End If
		cEvent.FEGCode = 	egCode
		arrGroup =  cEvent.fnGetEventGroup_mo
		END If
		ThemeColorCode=cEvent.fnEventColorCode
		ThemeBarColorCode=cEvent.fnEventBarColorCode
		'//2015추가 코멘트(테스터) or 상품후기 or 사은품 or 예약판매 체크가 되어 있을때만 가저오기
		If blncomment Or blnitemps Or blngift Or blnbookingsell Then
			cEvent.FEGCode	=	egCode
			arrTextTitle	=	cEvent.fnGetEventTextTitle
		End If

		cEvent.FECategory  = ecategory
		'arrRecent = cEvent.fnGetRecentEvt

		'// 모바일 전용 추가 이미지
		'#######################################################################################
		If evt_m_addimg_cnt > 0 Then
			arrAddbanner	=	cEvent.fnGetMoAddimg
		End If

		If isArray(arrAddbanner) Then '//이미지들 있음
			Dim tArea , mArea , bArea
			For intAi = 0 To UBound(arrAddbanner,2)
				If arrAddbanner(1,intAi) <> "" Then
					If arrAddbanner(0,intAi) = "1" And (CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
						tArea = tArea & "<a href='"& chkiif(arrAddbanner(3,intAi) <> "",arrAddbanner(3,intAi),"#") &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
					ElseIf arrAddbanner(0,intAi) = "2" And (CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
						mArea = mArea & "<a href='"& chkiif(arrAddbanner(3,intAi) <> "",arrAddbanner(3,intAi),"#") &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
					ElseIf arrAddbanner(0,intAi) = "3" And (CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
						bArea = bArea & "<a href='"& chkiif(arrAddbanner(3,intAi) <> "",arrAddbanner(3,intAi),"#") &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
					End If
				End If
			Next
		End If
		'#######################################################################################

	set cEvent = nothing
		cdl_e = ecategory
		cdm_e = ecateMid

		IF cdl_e = "" THEN blnFull= True	'카테고리가 없을경우 전체페이지로
		IF eCode = "" THEN
		Alert_return("유효하지 않은 이벤트 입니다.")
		dbget.close()	:	response.End
		END IF

	'// 이벤트 시작전이면 STAFF를 제외한 이벤트 메인으로 리다이렉션
	if datediff("d",esdate,date)<0 and GetLoginUserLevel<>"7" then
		response.redirect("/shoppingtoday/shoppingchance_allevent.asp")
		dbget.close()	:	response.End
	end if

	'// 내 관심 이벤트 확인
	if IsUserLoginOK then
		set clsEvt = new CMyFavoriteEvent
			clsEvt.FUserId = getEncLoginUserID
			clsEvt.FevtCode = eCode
			isMyFavEvent = clsEvt.fnIsMyFavEvent
		set clsEvt = nothing
	end If

	'//이벤트 명 할인이나 쿠폰시
	eOnlyName = eName
	If blnsale Or blncoupon Then
		if ubound(Split(eName,"|"))> 0 Then
			eOnlyName = cStr(Split(eName,"|")(0))
			If blnsale Or (blnsale And blncoupon) then
				eName	= cStr(Split(eName,"|")(0)) &" <span style=color:red>"&cStr(Split(eName,"|")(1))&"</span>"
			ElseIf blncoupon Then
				eName	= cStr(Split(eName,"|")(0)) &" <span style=color:green>"&cStr(Split(eName,"|")(1))&"</span>"
			End If
		end if
	End If

	'// sns공유용 이미지
	dim snpImg, ogImg
	if bimg<>"" then
		snpImg = bimg
	elseIf evt_mo_listbanner <> "" Then
		snpImg = evt_mo_listbanner
	End If
	If evt_mo_listbanner <> "" Then
		ogImg = evt_mo_listbanner
	elseif bimg<>"" then
		ogImg = bimg
	End If

	'head.asp에서 출력
	strOGMeta = strOGMeta & "<meta property=""og:title"" content=""" & eOnlyName & """>" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/event/eventmain.asp?eventid=" & eCode & """ />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:image"" content=""" & ogImg & """>" & vbCrLf
	if trim(evt_subname)<>"" then
		If ekind="28" Then
			strOGMeta = strOGMeta & "<meta property=""og:description"" content=""" & "[텐바이텐] 이벤트 - " & evt_subname & """>" & vbCrLf
		Else
			strOGMeta = strOGMeta & "<meta property=""og:description"" content=""" & "[텐바이텐] 기획전 - " & evt_subname & """>" & vbCrLf
		End If
	end if

	If ekind="28" Then
		strPageKeyword = "이벤트, " & replace(eOnlyName,"""","")
		strHeadTitleName = "이벤트"
	Else
		strPageKeyword = "기획전, " & replace(eOnlyName,"""","")
		strHeadTitleName = "기획전"
	End If


	'//이벤트 종료시 레이어 2016-02-02 유태욱 추가
	Dim strExpireMsg : strExpireMsg=""
	If endlessView <> "Y" Then endlessView = "N"
	If endlessView = "N" Then
	IF (datediff("d",eedate,date()) >0) OR (estate =9) Then
		strExpireMsg = "<script type=""text/javascript"" src=""/common/addlog.js?tp=noresult&ror="&server.UrlEncode(Request.serverVariables("HTTP_REFERER"))&"""></script><div class=""finish-event"">이벤트가 종료되었습니다.</div>"
	END If
	END If

	'// 이벤트 로그 사용여부(2017.01.12)
	Dim LogUsingCustomChk
	If getEncLoginUserId="thensi7" Then
		LogUsingCustomChk = True
	Else
		LogUsingCustomChk = True
	End If

	'// 이벤트 로그저장(2017.01.11 원승현)
	If LogUsingCustomChk Then
		If IsUserLoginOK() Then
			'// 마케팅이벤트(ekind=28)
			If ekind="28" Then
				Call fnUserLogCheck("mktevt", getEncLoginUserId, "", eCode, "", "mw")
			Else
				Call fnUserLogCheck("planevt", getEncLoginUserId, "", eCode, "", "mw")
			End If
		End If
	End If

	'// 이벤트 유형 및 테마번호 Web Log에 추가(2017.06.26; 허진원)
	Response.AppendToLog "&evttp=" & evt_type & mdthememo

	'// amplitude를 통한 데이터 확인을 위해 gaparam으로 넘어오는값 체크
	Dim gaparamChkVal
	gaparamChkVal = requestCheckVar(request("gaparam"),30)

	'// 구글 ADS 스크립트 관련(2018.09.21 신규버전 추가)
	googleADSCRIPT = " <script> "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "   gtag('event', 'page_view', { "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'send_to': 'AW-851282978', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_pagetype': 'other', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_prodid': '', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_totalvalue': '' "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "   }); "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & " </script> "

%>
<%
	'# 현재 페이지명 접수
	dim nowViewPage
	nowViewPage = request.ServerVariables("SCRIPT_NAME")
	Dim strOGMeta		'RecoPick환경변수

'/서버 주기적 업데이트 위한 공사중 처리 '2011.11.11 한용민 생성
'/리뉴얼시 이전해 주시고 지우지 말아 주세요
Call serverupdate_underconstruction()

	'// 사이트 공사중
	'Call Underconstruction()

	'// 로그인 유효기간 확인 및 처리
	Select Case lcase(Request.ServerVariables("URL"))
		Case "/_index.asp", "/index.asp"
			Call chk_ValidLogin()
	End Select

	'// 자동로그인 확인
	Call chk_AutoLogin()

	'####### .js 파일 연동시 사용 - CC_currentyyyymmdd=V_CURRENTYYYYMM 변수로 .js에서 해당 날짜 이미지/링크등 뿌려줌
	dim CC_currentyyyymmdd
	On Error Resume Next
	CC_currentyyyymmdd=request("yyyymmdd")
	On Error Goto 0
	if CC_currentyyyymmdd="" then CC_currentyyyymmdd = Left(now(),10)
	'#########################################################################

	'###### 제휴사 flag 관련 - 주문 저장시/회원가입시  제휴사 Flag 저장 ######
	dim irdsite20, arrRdSite, irdData
	irdsite20 = requestCheckVar(request("rdsite"),32)
	irdData = requestCheckVar(request("rddata"),100)	'기타 전송 데이터 (회원ID,이벤트 번호 등)
	'//파라메터가 겹쳐있는 경우 중복 제거
	if irdsite20<>"" then
		arrRdSite = split(irdsite20,",")
		irdsite20 = arrRdSite(0)
	end if

	if (irdsite20<>"") then
		if (request.cookies("rdsite")<>irdsite20) then
			response.cookies("rdsite").domain = "10x10.co.kr"
			if (left(irdsite20,7)<>"mobile_") then     ''2015/05/22 추가 mobile_mobile_da CASE
			    response.cookies("rdsite") = Left("mobile_"&trim(irdsite20),25)
			else
			    response.cookies("rdsite") = Left(trim(irdsite20),32)
		    end if
		end if
		if (request.cookies("rddata")<>irdData) then
			response.cookies("rddata") = irdData
		end if
	end if
	'#########################################################################

	Dim strPageKeyword
	'// 페이지 검색 키워드
	if strPageKeyword="" then
		strPageKeyword = "감성디자인, 디자인상품, 아이디어상품, 즐거움, 선물, 문구, 소품, 인테리어, 가구, 가전, 패션, 화장품, 반려동물, 핸드폰케이스, 패브릭, 조명, 식품"
	else
		strPageKeyword = "10x10, 텐바이텐, 감성, 디자인, " & strPageKeyword
	end If

	'################# Amplitude에 들어갈 Referer 값 정의 ###################
	Dim AmpliduteReferer
	AmpliduteReferer = Request.ServerVariables("HTTP_REFERER")
	If Trim(AmpliduteReferer) <> "" Then
		If Not(InStr(AmpliduteReferer, "10x10")>0) Then
			response.cookies("CheckReferer") = AmpliduteReferer
		End If
	End If
	'#########################################################################

%>
					<%
					If isArray(arrGroup) Then
						If arrGroup(0,0) <> "" Then
							if arrGroup(3,0) <> "" then
					%>
							<div><img src="<%=arrGroup(3,0)%>" alt="<%=egCode%>" /></div>
					<%
							End If
					%>
							<%'excute 추가%>
							<% If Trim(evtFileyn_mo)="" Or evtFileyn_mo = "0" Or isnull(evtFileyn_mo) Or evtFileyn_mo = "False" Then %>
							<map name="mapGroup<%=egCode%>"><%=db2html(arrGroup(4,0))%></map>
							<% Else %>
								<% If checkFilePath(server.mappath(evtFile_mo)) Then %>
									<div width="100%"><% server.execute(evtFile_mo)%></div>
								<% Else %>
									<map name="mapGroup<%=egCode%>"><%=db2html(arrGroup(4,0))%></map>
								<% End If %>
							<% End If %>
					<%
						End If
					%>
					<div class="bnrTemplate"><%=mArea%></div><%'모바일 중간 추가 이미지 %>
					</div>
					<% egCode = arrGroup(0,0) %>
					<% if blncomment then %>
					<!-- <div class="btnCmtV15">
						<span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
					</div> -->
					<% end if %>
					<% If isArray(arrTextTitle) Then %>
					<!-- 코멘트 타이틀 영역 -->
					<!-- #include virtual="/event/lib/inc_evtcmt.asp" -->
					<!-- 코멘트 타이틀 영역 -->
					<% End If %>
					<div class="exhibition-list-wrap exhibition-list-wrap-nogroupbar">
					<div class="items-list" id="topitem">
					<% sbEvtItemView_2015 %>
					</div>
					<%
						'// 최상위 그룹 아이템이 없을경우 마크업 제거
						If itotcnt < 0 Then
					%>
					<script>$("#topitem").remove();</script>
					<%
						End If
					End If ''isarray
					%>
					<%
					Dim vGroupOption , vTmpgcode '//아이템없는 그룹코드
					Dim intS
					Dim tempi

					If isArray(arrGroup) Then
						For intG = 1 To UBound(arrGroup,2)
							intS = 0
							'//그룹 중복일경우 중복 그룹은 제외 상품만 가저오기
							on Error Resume Next '// 혹시 모르니 -_-;
							if intG < UBound(arrGroup,2) then
								for tempi = intG to (UBound(arrGroup,2))
									If tempi = UBound(arrGroup,2) Then Exit For
									if arrGroup(9,intG) = arrGroup(9,tempi+1) Then
										intS = intS + 1
									Else
										Exit For
									End If
								Next
							End If
							on Error Goto 0

							vGroupOption = vGroupOption & "<option class=""g"&arrGroup(0,intG)&""" value="""&arrGroup(0,intG)&""">" & db2html(arrGroup(1,intG)) & "</option>"

							intG = intG+intS
						Next

						For intG = 1 To UBound(arrGroup,2)
							intS = 0
							egCode = arrGroup(9,intG)

							on Error Resume Next '// 혹시 모르니 -_-;
							if intG < UBound(arrGroup,2) then
								for tempi = intG to (UBound(arrGroup,2))
									If tempi = UBound(arrGroup,2) Then Exit for
									if arrGroup(9,intG) = arrGroup(9,tempi+1) Then
										intS = intS + 1
									Else
										Exit For
									End If
								Next
							End If
							on Error Goto 0
					%>
							<div class="items-list" id="group<%=arrGroup(0,intG)%>">
								<div class="groupBarV15">
									<select id="groupBar<%=arrGroup(0,intG)%>" onChange="goGroupSelect(this.value,'<%=arrGroup(0,intG)%>');">
										<%=vGroupOption%>
									</select>
								</div>
								<%'//상품도 묶인 그룹으로 노출%>
								<% sbEvtItemView_2015 %>
							</div>
							<script>$("#groupBar<%=arrGroup(0,intG)%> > option[value=<%=arrGroup(0,intG)%>]").attr("selected", "true");</script>
							<% If itotcnt < 0 Then vTmpgcode = arrGroup(0,intG) %>
							<%
								'//상품이 없을때 select 박스 숨김 options 삭제
								If vTmpgcode <> "" then
							%>
								<script>
									$("#group<%=vTmpgcode%>").remove();
									$(".groupBarV15").find(".g<%=vTmpgcode%>").remove();
								</script>
							<%
								End If

							intG = intG+intS
						Next
					End If
					Response.write "</div>"
		%>
<!-- #include virtual="/lib/db/dbclose.asp" -->