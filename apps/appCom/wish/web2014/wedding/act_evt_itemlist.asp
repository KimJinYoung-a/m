<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
	session.codepage = 65001
	response.Charset="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/event/weddingCls.asp" -->
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
Dim mdthememo, themecolormo, textbgcolormo, mdbntypemo, salePer, saleCPer, SocName_Kor, evt_type, title_mo

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

		Dim tempurl : tempurl = "/apps/appcom/wish/web2014"

		If isArray(arrAddbanner) Then '//이미지들 있음
			Dim tArea , mArea , bArea
			For intAi = 0 To UBound(arrAddbanner,2)
				If arrAddbanner(1,intAi) <> "" Then
					If arrAddbanner(0,intAi) = "1" And ( CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
						If InStr(arrAddbanner(3,intAi),"/event/")>0 Then
							tArea = tArea & "<a href='/apps/appcom/wish/web2014"& arrAddbanner(3,intAi) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						ElseIf InStr(arrAddbanner(3,intAi),"#group")>0 Then
							tArea = tArea & "<a href='"& arrAddbanner(3,intAi) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						else
							tArea = tArea & "<a href='' "& chkiif(arrAddbanner(3,intAi) <> "","","_") &"onclick=""fnAPPpopupAutoUrl('"& arrAddbanner(3,intAi) &"');return false;""><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						End If
					ElseIf arrAddbanner(0,intAi) = "2" And ( CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
						If InStr(arrAddbanner(3,intAi),"/event/")>0 Then
							mArea = mArea & "<a href='/apps/appcom/wish/web2014"& arrAddbanner(3,intAi) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						ElseIf InStr(arrAddbanner(3,intAi),"#group")>0 Then
							mArea = mArea & "<a href='"& arrAddbanner(3,intAi) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						Else
							mArea = mArea & "<a href='' "& chkiif(arrAddbanner(3,intAi) <> "","","_") &"onclick=""fnAPPpopupAutoUrl('"& arrAddbanner(3,intAi) &"');return false;""><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						End If
					ElseIf arrAddbanner(0,intAi) = "3" And ( CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
						If InStr(arrAddbanner(3,intAi),"/event/")>0 Then
							bArea = bArea & "<a href='/apps/appcom/wish/web2014"& arrAddbanner(3,intAi) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						ElseIf InStr(arrAddbanner(3,intAi),"#group")>0 Then
							bArea = bArea & "<a href='"& arrAddbanner(3,intAi) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						Else
							bArea = bArea & "<a href='' "& chkiif(arrAddbanner(3,intAi) <> "","","_") &"onclick=""fnAPPpopupAutoUrl('"& arrAddbanner(3,intAi) &"');return false;""><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						End If
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
				Call fnUserLogCheck("mktevt", getEncLoginUserId, "", eCode, "", "app")
			Else
				Call fnUserLogCheck("planevt", getEncLoginUserId, "", eCode, "", "app")
			End If
		End If
	End If

	'// 이벤트 유형 및 테마번호 Web Log에 추가(2017.06.26; 허진원)
	Response.AppendToLog "&evttp=" & evt_type & mdthememo

	'// amplitude를 통한 데이터 확인을 위해 gaparam으로 넘어오는값 체크
	Dim gaparamChkVal
	gaparamChkVal = requestCheckVar(request("gaparam"),30)

%>
<%
    Dim C_WEBVIEWURL, C_WEBVIEWURL_SSL
    IF application("Svr_Info")="Dev" THEN
	    C_WEBVIEWURL = "http://testm.10x10.co.kr/apps/appcom/wish/web2014"
	    C_WEBVIEWURL_SSL = "http://testm.10x10.co.kr/apps/appcom/wish/web2014"
	Else
	    C_WEBVIEWURL = "http://m.10x10.co.kr/apps/appcom/wish/web2014"
	    C_WEBVIEWURL_SSL = "https://m.10x10.co.kr/apps/appcom/wish/web2014"
	End if

    '' 앱 구분 //2014/02/17
    Dim CGLBAppName
    CGLBAppName = "app_wish2"  ''/web2014 폴더 app_wish2
    uAgent = Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    if InStr(uAgent,"tencolorapp")>0 then
        CGLBAppName = "app_cal"
    end if

	'' iScroll Click옵션 여부 //2014.03.27
	dim vIsClick: vIsClick = false
	if instr(uAgent,"ipod")>0 or instr(uAgent,"iphone")>0 or instr(uAgent,"ipad")>0 then
		vIsClick = true
	elseif instr(uAgent,"android")>0 then
		dim vAdrVer: vAdrVer = mid(uAgent,instr(uAgent,"android")+8,3)
		if vAdrVer>="4.4" then
			vIsClick = true
		end if
	end If

	'// 사이트 공사중 리뉴얼용
	'Call Underconstruction()

	Dim strPageTitle
	if strPageTitle="" then strPageTitle = "10X10"

	'###### 제휴사 flag 관련 - 주문 저장시/회원가입시  제휴사 Flag 저장 ######
	dim irdsite20, arrRdSite, irdData
	irdsite20 = request("rdsite")
	irdData = request("rddata")	'기타 전송 데이터 (회원ID,이벤트 번호 등)
	'//파라메터가 겹쳐있는 경우 중복 제거
	if irdsite20<>"" then
		arrRdSite = split(irdsite20,",")
		irdsite20 = arrRdSite(0)
	end if

	if (irdsite20<>"") then
		if (request.cookies("rdsite")<>irdsite20) then
			response.cookies("rdsite").domain = "10x10.co.kr"
			response.cookies("rdsite") = Left("mobile_"&trim(irdsite20),32)
		end if
		if (request.cookies("rddata")<>irdData) then
			response.cookies("rddata") = irdData
		end if
	end if
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
					<% egCode = arrGroup(0,0) %>
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
								<% sbEvtItemView_app_2015 %>
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