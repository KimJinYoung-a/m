<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% Session.CodePage = 65001 %>
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
Dim ThemeColorCode, ThemeBarColorCode
Dim comm_isusing, comm_text, freebie_img, comm_start, comm_end, gift_isusing, gift_text1, gift_img1, gift_text2, gift_img2
Dim gift_text3, gift_img3, usinginfo, using_text1, using_contents1, using_text2, using_contents2, using_text3, using_contents3
Dim mdthememo, themecolormo, textbgcolormo, mdbntypemo, salePer, saleCPer, SocName_Kor, evt_type, title_mo
dim endlessView, videoFullLink
dim eval_isusing, eval_text, eval_freebie_img, eval_start, eval_end
Dim board_isusing, board_text, board_freebie_img, board_start, board_end
Dim etc_itemid, arrGiftBox, isNew, isOnePlusOne, isOnlyTen, evt_html, contentsAlign, CopyHide

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

'//gnb 체크
Dim gnbflag : gnbflag =  RequestCheckVar(request("gnbflag"),1)
If gnbflag = "" Then '//gnb 숨김 여부
	gnbflag = true 
Else 
	gnbflag = False
End if

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
ElseIf eCode = "77547" THEN		'2017-04-17 이종화 수정 // 브랜드 위크 리스트로 리다이렉트
	response.redirect("/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp?scTgb=bw")
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
		eval_isusing = cEvent.Feval_isusing
		eval_text = cEvent.Feval_text
		eval_freebie_img = cEvent.Feval_freebie_img
		eval_start = cEvent.Feval_start
		eval_end = cEvent.Feval_end
		evt_html= cEvent.FEHtml
		contentsAlign= cEvent.FcontentsAlign
		CopyHide= cEvent.FCopyHide

		board_isusing = cEvent.Fboard_isusing
		board_text = cEvent.Fboard_text
		board_freebie_img = cEvent.Fboard_freebie_img
		board_start = cEvent.Fboard_start
		board_end = cEvent.Fboard_end

		'// 대표 상품 코드 
		etc_itemid = cEvent.FEItemID

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
		IF etemplate_mo = "3" OR etemplate_mo = "9" OR etemplate_mo = "11" OR etemplate_mo = "6" Then
			If sgroup_m And egCode = "0" Then '// 그룹형 랜덤 체크 되었을때
				arrTopGroup = cEvent.fnGetEventGroupTop
				egCode = arrTopGroup(0,0)
			End If 
		cEvent.FEGCode = 	egCode		
		arrGroup =  cEvent.fnGetEventGroup_mo					
		END If
		ThemeColorCode=cEvent.fnEventColorCode
		if etemplate_mo="11" OR etemplate_mo = "6" then
			ThemeBarColorCode=cEvent.fnEventThemeColorCode
		else
			ThemeBarColorCode=cEvent.fnEventBarColorCode
		end if
		'//2015추가 코멘트(테스터) or 상품후기 or 사은품 or 예약판매 체크가 되어 있을때만 가저오기
		If blncomment Or blnitemps Or blngift Or blnbookingsell Then
			cEvent.FEGCode	=	egCode		
			arrTextTitle	=	cEvent.fnGetEventTextTitle
		End If

		cEvent.FECategory  = ecategory
		'arrRecent = cEvent.fnGetRecentEvt
		
		'//gnb영역으로 들어 오는 이벤트
		Dim gnbUse : gnbUse = False
		If inStr(Request.ServerVariables("QUERY_STRING"),"gnbflag=1")>0 Then 
			gnbUse = true
		End If 

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
							If gnbUse Then 
								tArea = tArea & "<a href='' onclick='fnAPPpopupBrowserURL(""기획전"","""& wwwUrl &"/apps/appCom/wish/web2014"& arrAddbanner(3,intAi) &""");return false;' ><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
							Else
								tArea = tArea & "<a href='/apps/appcom/wish/web2014"& arrAddbanner(3,intAi) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
							End If 
						ElseIf InStr(arrAddbanner(3,intAi),"#group")>0 Then
							tArea = tArea & "<a href='"& arrAddbanner(3,intAi)& "'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						Else 
							tArea = tArea & "<a href='' "& chkiif(arrAddbanner(3,intAi) <> "","","_") &"onclick=""fnAPPpopupAutoUrl('"& arrAddbanner(3,intAi) &"');return false;""><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						End If 
					ElseIf arrAddbanner(0,intAi) = "2" And ( CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
						If InStr(arrAddbanner(3,intAi),"/event/")>0 Then
							mArea = mArea & "<a href='/apps/appcom/wish/web2014"& arrAddbanner(3,intAi) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						ElseIf InStr(arrAddbanner(3,intAi),"#group")>0 Then
							mArea = mArea & "<a href='"& arrAddbanner(3,intAi)& "'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
                        else
							mArea = mArea & "<a href='' "& chkiif(arrAddbanner(3,intAi) <> "","","_") &"onclick=""fnAPPpopupAutoUrl('"& arrAddbanner(3,intAi) &"');return false;""><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						End If 
					ElseIf arrAddbanner(0,intAi) = "3" And ( CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
						If InStr(arrAddbanner(3,intAi),"/event/")>0 Then
							If gnbUse Then 
								bArea = bArea & "<a href='' onclick='fnAPPpopupBrowserURL(""기획전"","""& wwwUrl &"/apps/appCom/wish/web2014"& arrAddbanner(3,intAi) &""");return false;' ><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
							Else
								bArea = bArea & "<a href='/apps/appcom/wish/web2014"& arrAddbanner(3,intAi) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
							End If 
                        ElseIf InStr(arrAddbanner(3,intAi),"#group")>0 Then
							bArea = bArea & "<a href='"& arrAddbanner(3,intAi)& "'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						Else
							bArea = bArea & "<a href='' "& chkiif(arrAddbanner(3,intAi) <> "","","_") &"onclick=""fnAPPpopupAutoUrl('"& arrAddbanner(3,intAi) &"');return false;""><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						End If 
					End If
				End If
			Next
		End If
		'#######################################################################################
        '#######################################################################################
        '// 기프트박스 가져오기
        '#######################################################################################
        arrGiftBox = cEvent.fnGetGiftBox
        Dim newGiftBox
        If gift_isusing>0 Then '//이미지들 있음
            newGiftBox="        <div class='gift-eventV19'>" & vbcrlf
            newGiftBox=newGiftBox+"         <ul>" & vbcrlf
            
            newGiftBox=newGiftBox+"             <li>" & vbcrlf
            newGiftBox=newGiftBox+"                 <div class='box'>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='desc'>" & vbcrlf
			If gift_isusing>1 Then
			newGiftBox=newGiftBox+"							<p class='tit' style='color:" + ThemeColorCode + ";'>GIFT1</p>" & vbcrlf
			else
			newGiftBox=newGiftBox+"							<p class='tit' style='color:" + ThemeColorCode + ";'>GIFT</p>" & vbcrlf
			end if
            newGiftBox=newGiftBox+"                         <p class='txt'>" + gift_text1 + "</p>" & vbcrlf
            newGiftBox=newGiftBox+"                     </div>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='thumb' style='background-image:url(" + gift_img1 + ")'></div>" & vbcrlf
            newGiftBox=newGiftBox+"                 </div>" & vbcrlf
            newGiftBox=newGiftBox+"             </li>" & vbcrlf
            If gift_isusing>1 Then
            newGiftBox=newGiftBox+"             <li>" & vbcrlf
            newGiftBox=newGiftBox+"                 <div class='box'>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='desc'>" & vbcrlf
            newGiftBox=newGiftBox+"                         <p class='tit' style='color:" + ThemeColorCode + ";'>GIFT2</p>" & vbcrlf
            newGiftBox=newGiftBox+"                         <p class='txt'>" + gift_text2 + "</p>" & vbcrlf
            newGiftBox=newGiftBox+"                     </div>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='thumb' style='background-image:url(" + gift_img2 + ")'></div>" & vbcrlf
            newGiftBox=newGiftBox+"                 </div>" & vbcrlf
            newGiftBox=newGiftBox+"             </li>" & vbcrlf
            End If
            If gift_isusing>2 Then
            newGiftBox=newGiftBox+"             <li>" & vbcrlf
            newGiftBox=newGiftBox+"                 <div class='box'>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='desc'>" & vbcrlf
            newGiftBox=newGiftBox+"                         <p class='tit' style='color:" + ThemeColorCode + ";'>GIFT3</p>" & vbcrlf
            newGiftBox=newGiftBox+"                         <p class='txt'>" + gift_text3 + "</p>" & vbcrlf
            newGiftBox=newGiftBox+"                     </div>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='thumb' style='background-image:url(" + gift_img3 + ")'></div>" & vbcrlf
            newGiftBox=newGiftBox+"                 </div>" & vbcrlf
            newGiftBox=newGiftBox+"             </li>" & vbcrlf
            End If
            newGiftBox=newGiftBox+"         </ul>" & vbcrlf
            if contentsAlign="Y" then
            newGiftBox=newGiftBox+"         <p class='caution'>* 사은품은 한정수량으로 조기소진 또는 종료될 수 있습니다.</p>" & vbcrlf
            End If
            newGiftBox=newGiftBox+"     </div>" & vbcrlf
        End If

	set cEvent = nothing
		cdl_e = ecategory	
		cdm_e = ecateMid
		
		IF cdl_e = "" THEN blnFull= True	'카테고리가 없을경우 전체페이지로		
		IF eCode = "" THEN 
		Alert_return("유효하지 않은 이벤트 입니다.")
		dbget.close()	:	response.End
		END IF
		
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

	'//이벤트 종료시 레이어 2016-02-02 유태욱 추가
	Dim strExpireMsg : strExpireMsg=""
	IF (datediff("d",eedate,date()) >0) OR (estate =9) Then
		strExpireMsg = "<script type=""text/javascript"" src=""/common/addlog.js?tp=noresult&ror="&server.UrlEncode(Request.serverVariables("HTTP_REFERER"))&"""></script><div class=""finishEvt""><p"& chkIIF(GetLoginUserLevel()=7," onclick=""$('.finishEvt').hide();"" style=""cursor:pointer""","") &">죄송합니다.<br />종료된 이벤트 입니다.</p></div>"
	END If

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	dim snpTitle, snpLink, snpPre, snpImg , snpTag , snpTag2 , kakaourl
	snpTitle = Server.URLEncode(eOnlyName)
	snpLink = Server.URLEncode(wwwUrl&"/event/eventmain.asp?eventid="&eCode)
	snpPre = Server.URLEncode("10x10 이벤트")
	if bimg<>"" then
		snpImg = Server.URLEncode(bimg)
	elseIf evt_mo_listbanner <> "" Then 
		snpImg = Server.URLEncode(evt_mo_listbanner)
	End If 
	'기본 태그
	snpTag = Server.URLEncode("텐바이텐 " & Replace(eName," ",""))
	snpTag2 = Server.URLEncode("#10x10")
	kakaourl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=" &eCode
	
	strPageTitle = "생활감성채널, 텐바이텐 > 이벤트 > " & eName

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

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
$(function(){
	<% if ekind = "28" then %>
		fnAPPchangPopCaption('이벤트');
	<% end if %>
});

function fnMyEvent() {
<% If IsUserLoginOK Then %>
	$.ajax({
		url: "/my10x10/myfavorite_eventProc.asp?hidM=U&eventid=<%=eCode%>",
		cache: false,
		async: false,
		success: function(message) {
			<% If etemplate_mo<>"9" Then %>
			if($("#myfavoriteevent").attr("class") == "wishViewV15 wishView wishActive"){
				$("#myfavoriteevent").removeClass("wishActive");
				alert("선택하신 이벤트가 삭제 되었습니다.");
			}else{
				$("#myfavoriteevent").addClass("wishActive");
				alert("관심 이벤트로 등록되었습니다.");
			}
			<% Else %>
			if($("#myfavoriteevent").attr("class") == "btnWish on"){
				$("#myfavoriteevent").removeClass("on");
				alert("선택하신 이벤트가 삭제 되었습니다.");
			}else{
				$("#myfavoriteevent").addClass("on");
				alert("관심 이벤트로 등록되었습니다.");
			}
			<% End If %>
		}
	});
<% Else %>
	calllogin();
	return false;
<% End If %>
}

function DelComments(v){
	if (confirm('삭제 하시겠습니까?')){
		document.frmact.mode.value= "del";
		document.frmact.Cidx.value = v;
		document.frmact.submit();
	}
}

function goGroupSelect(v,a){
	$('html, body').animate({
	    scrollTop: $("#group"+v+"").offset().top
	}, 300)
	
	$("#group"+a+" > option[value="+a+"]").attr("selected", "true");
}

// SNS 공유 팝업
function fnAPPRCVpopSNS(){
	fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	return false;
}

$(function(){
	/* 코멘트 남기러 가기 버튼 추가 */
	$(".btnComment .button a").click(function(event){
		event.preventDefault();
		$('html,body').animate({scrollTop:$(this.hash).offset().top}, 500);
	});

	//' ver2.0 추가
	$(".btnCmtV15 .button a, .evtShareV15 a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});

	// 순차 로딩
	$("img.lazy").lazyload().removeClass("lazy");

	<% if eCode = "72616" then %>
		$('html, body').animate({scrollTop: $(".evtContV15").offset().top}, 'fast')
	<% end if %>
});

function goWishPop(i,ecd){
	<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1)%>
	   fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?ecode="+ecd+"&itemid="+i+"&ErBValue=13&gb=search2017",'','wishfolder');
	<% Else %>
		calllogin();
		return false;
	<% End If %>
}

function jsAfterWishBtn(i){
	if($("#wish"+i+"").hasClass("on")){
		
	}else{
		$("#wish"+i+"").addClass("on");
		
		var cnt = $("#cnt"+i+"").text();

		if(cnt == ""){
			$("#wish"+i+"").empty();
			$("#cnt"+i+"").empty().text("1");
		}else{
			cnt = parseInt(cnt) + 1;
			if(cnt > 999){
				$("#cnt"+i+"").empty().text("999+");
			}else{
				$("#cnt"+i+"").empty().text(cnt);
			}
		}
	}
}

// gnbevent일경우 파라메터 추가
$(function(){
	$('a').each(function(){
		if ( $(this).attr('href') !== undefined && $(this).attr('href').indexOf("eventid") > 0 && $(this).attr('href').indexOf("javascript") < 0 )
		{
			$(this).attr('href', $(this).attr('href') + '&gnbflag=1');
		}
	});
});

function parent_kakaolink(label , imageurl , width , height , linkurl ){
	//카카오 SNS 공유
	Kakao.init('c967f6e67b0492478080bcf386390fdd');

	Kakao.Link.sendTalkLink({
		label: label,
		image: {
			src: imageurl,
			width: width,
			height: height
			},
		appButton: {
			text: '10X10 앱으로 이동',
			execParams :{
				android: { url: linkurl},
				iphone: { url: linkurl}
			}
		}
  });
}

// gnb용 이벤트 URL
function jsEventlinkURL(ecode){
	fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+ecode);
	return false;
}

// gnb내 이벤트 이동
function jsGNBEventlink(ecode,gcode){
	var url = '/apps/appcom/wish/web2014/event/gnbeventmain.asp?eventid='+ecode;
	if(typeof(gcode)!="undefined") {
		url += '&eGc='+gcode;
	}
	url += '&gnbflag=1';

	location.replace(url);
	return false;
}

// gnb내 이벤트 이동
function jsGNBEventlinkFocus(ecode,gcode,focus){
	var url = '/apps/appcom/wish/web2014/event/gnbeventmain.asp?eventid='+ecode;
	if(typeof(gcode)!="undefined") {
		url += '&eGc='+gcode;
	}
	url += '&gnbflag=1';
	if(focus!="")
	{
		url += "&#"+focus;
	}
	location.replace(url);
	return false;
}

function jsMobAppUrlChange(e,g,m){
		var ecode = e;
		var gcode = g;
		var mcode=m;
		<% if isapp = "1" then %>
				<% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
				jsGNBEventlink(ecode,gcode);
			<% else %>
				location.href = '/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&mid="+mcode;
			<% end if %>
		<% else %>
			<% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
				jsGNBEventlink(ecode,gcode);
			<% else %>
				location.href = '/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&mid="+mcode;
			<% end if %>
		<% end if %>
		return false;
}

function jsMobAppUrlChangeFocus(e,g,f){
	var ecode = e;
	var gcode = g;
	var focus = f;
	<% if isapp = "1" then %>
		<% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
			jsGNBEventlinkFocus(ecode,gcode,focus);
		<% else %>
			location.href = '/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&#"+focus;
		<% end if %>
	<% else %>
		<% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
			jsGNBEventlinkFocus(ecode,gcode,focus);
		<% else %>
			location.href = '/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&#"+focus;
		<% end if %>
	<% end if %>
	return false;
}
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"sub","main")%>">
	<div id="content" class="content">
		<% SELECT CASE etemplate_mo
			CASE "3" '그룹형
		%>
            <div class="evtContV15">
                <div class="bnrTemplate"><%=tArea%></div><%'모바일 상단 추가 이미지 %>
                <% If slide_m_flag ="Y" Then %><% sbSlidetemplate '//slide template %><% End If %>
                <%= strExpireMsg %>
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
                end if 
                %>
            </div>
			<% egCode = arrGroup(0,0) %>
			<% if blncomment then %>
                <!-- <div class="btnCmtV15">
                    <span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
                </div> -->
			<% end if %>
			<div class="bnrTemplate"><%=mArea%></div><%'모바일 중간 추가 이미지 %>
			<% If isArray(arrTextTitle) Then %>
                <!-- 코멘트 타이틀 영역 -->
                <!-- #include virtual="/event/lib/inc_evtcmt.asp" -->
                <!-- 코멘트 타이틀 영역 -->
			<% End If %>

			<%'// 상품 리스트 분리 -- 이종화 %>
            <div id="eventitemlist" v-cloak>
                <div class="exhibition-list-wrap<% If UBound(arrGroup, 2)>0 Then %> exhibition-list-wrap<% Else %> exhibition-list-wrap-nogroupbar<% End If %>">
                    <% If UBound(arrGroup, 2)>0 Then %>
						<group-itemlist v-for="(item,index) in sliced" v-if="sliced" :items="item" :groups="groups" :key="index" :wrapper="true" :barcolor="themebarColor" :ltype="listType" :isapp="1" ></group-itemlist>
					<% Else %>
						<nogroup-itemlist :items="sliced" :ltype="listType" :isapp="1" ></nogroup-itemlist>
					<% End If %>
					<temp-layout v-if="tempFlag"></temp-layout>
                </div>
            </div>

			<div class="bnrTemplate"><%=bArea%></div><%'모바일 하단 추가 이미지 %>
		<%
			CASE "5" '수작업
		%>
			<div class="evtContV15">
				<div class="bnrTemplate"><%=tArea%></div><%'모바일 상단 추가 이미지 %>
				<%= strExpireMsg %>
				<% If Trim(evtFileyn_mo)="" Or evtFileyn_mo = "0" Or isnull(evtFileyn_mo) Or evtFileyn_mo = "False" Then %>
					<div><%=evt_html_mo%></div>
				<% Else %>
					<% If checkFilePath(server.mappath(evtFile_mo)) Then %>
						<div width="100%"><% server.execute(evtFile_mo)%></div>
					<% Else %>
						<div><%=evt_html_mo%></div>
					<% End If %>
				<% End If %>
				<div class="bnrTemplate"><%=mArea%></div>
			</div>
			<% If isArray(arrTextTitle) Then %>
			<!-- 코멘트 타이틀 영역 -->
			<!-- #include virtual="/event/lib/inc_evtcmt.asp" -->
			<!-- 코멘트 타이틀 영역 -->
			<% End If %>
			<div class="bnrTemplate"><%=bArea%></div>
		<%	
            CASE "6" '수작업+상품목록 
        %>
			<div class="evtContV15">
				<div class="bnrTemplate"><%=tArea%></div>
				<%= strExpireMsg %>
				<% If emimg_mo <> "" Then %><div><img src="<%=emimg_mo%>" alt="<%=eName%>" /></div><% End If %>
				<% If slide_m_flag ="Y" Then %><% sbSlidetemplate '//slide template %><% End If %>
				<% If Trim(evtFileyn_mo)="" Or evtFileyn_mo = "0" Or isnull(evtFileyn_mo) Or evtFileyn_mo = "False" Then %>
					<div><%=evt_html_mo%></div>
				<% Else %>
					<% If checkFilePath(server.mappath(evtFile_mo)) Then %>
						<div width="100%"><% server.execute(evtFile_mo)%></div>
					<% Else %>
						<div><%=evt_html_mo%></div>
					<% End If %>
				<% End If %>
				<div class="bnrTemplate"><%=mArea%></div>
			</div>

			<!-- 코멘트 박스 -->
			<% If blncomment Then %>
			<section class="comment-eventV19">
				<h3 style="color:<%=ThemeColorCode%>;">Comment Event</h3>
				<p class="topic"><%=nl2br(comm_text)%></p>
				<ul>
					<li>작성기간 <span class="date"><%=Replace(comm_start,"-",".")%> ~ <%=Replace(comm_end,"-",".")%></span></li>
					<li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
				</ul>
				<div class="btnGroup">
					<a href="#replyList" class="btn-go">코멘트 쓰러가기<span class="icon"></span></a>
				</div>
				<% if freebie_img<>"" then %><div class="thumbnail"><img src="<%=freebie_img%>" alt=""></div><% End If %>
			</section>
			<% End If %>

			<!-- 상품후기 박스 -->
			<% If blnitemps Then %>
			<section class="comment-eventV19">
				<h3 style="color:<%=ThemeColorCode%>;">Review Event</h3>
				<p class="topic"><%=nl2br(eval_text)%></p>
				<ul>
					<li>작성기간 <span class="date"><%=Replace(eval_start,"-",".")%> ~ <%=Replace(eval_end,"-",".")%></span></li>
					<li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
				</ul>
				<div class="btnGroup">
					<a href="#replyPrdList" class="btn-go">리뷰 쓰러가기<span class="icon"></span></a>
				</div>
				<% if eval_freebie_img<>"" then %><div class="thumbnail"><img src="<%=eval_freebie_img%>" alt=""></div><% End If %>
			</section>
			<% End If %>

			<!-- 포토 코멘트 박스 -->
			<% If blnbbs Then %>
			<section class="comment-eventV19">
				<h3 style="color:<%=ThemeColorCode%>;">Photo Comment Event</h3>
				<p class="topic"><%=nl2br(board_text)%></p>
				<ul>
					<li>작성기간 <span class="date"><%=Replace(board_start,"-",".")%> ~ <%=Replace(board_end,"-",".")%></span></li>
					<li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
				</ul>
				<div class="btnGroup">
					<a href="#replyPhotoList" class="btn-go">코멘트 쓰러가기<span class="icon"></span></a>
				</div>
				<% if board_freebie_img<>"" then %><div class="thumbnail"><img src="<%=board_freebie_img%>" alt=""></div><% End If %>
			</section>
			<% End If %>
			
			<%'// 상품 리스트 분리 -- 이종화 %>
            <div id="eventitemlist" v-cloak>
                <div class="exhibition-list-wrap<% If isArray(arrGroup) Then %> exhibition-list-wrap<% Else %> exhibition-list-wrap-nogroupbar<% End If %>">
                    <% If isArray(arrGroup) Then %>
						<group-itemlist v-for="(item,index) in sliced" v-if="sliced" :items="item" :groups="groups" :key="index" :wrapper="true" :barcolor="themebarColor" :ltype="listType" :isapp="1" ></group-itemlist>
					<% Else %>
						<nogroup-itemlist :items="sliced" :ltype="listType" :isapp="1" ></nogroup-itemlist>
					<% End If %>
					<temp-layout v-if="tempFlag"></temp-layout>
                </div>
            </div>
			<script>
            $(function(){
				
                /* rolling for md event */
                if ($("#mdRolling .swiper-container .swiper-slide").length > 1) {
                    var mdRolling = new Swiper("#mdRolling .swiper-container", {
                        pagination:"#mdRolling .pagination-line",
                        paginationClickable:true,
                        autoplay:1700,
                        loop:true,
                        speed:800,
                        nextButton:"#mdRolling .btnNext",
                        prevButton:"#mdRolling .btnPrev"
                    });
                } else {
                    var mdRolling = new Swiper("#mdRolling .swiper-container", {
                        pagination:false,
                        noSwipingClass:".noswiping",
                        noSwiping:true
                    });
                }

                $("#mdRolling .pagination-line").each(function(){
                    var checkItem = $(this).children(".swiper-pagination-switch").length;
                    if (checkItem == 2) {
                        $(this).addClass("grid2");
                    }
                    if (checkItem == 3) {
                        $(this).addClass("grid3");
                    }
                    if (checkItem == 4) {
                        $(this).addClass("grid4");
                    }
                    if (checkItem == 5) {
                        $(this).addClass("grid5");
                    }
                });
            });
            </script>
			<div class="bnrTemplate"><%=bArea%></div>
		<%	
            CASE "9" 'MD 등록 이벤트 
        %>
			<div class="evtContV15">
			    <%= strExpireMsg %>
			</div>
			<% If mdthememo="1" Then %>
			<div class="event-article event-text-type"><!-- type 1 : text 타입 -->
				<section class="section-event hgroup-event">
					<h2 style="word-break:keep-all;"><%=title_mo%></h2>
					<p class="subcopy" style="word-break:keep-all;"><%=evt_subname%></p>
					<% If blnsale Or blncoupon Then %><div class="discount"><% If blnsale Then %><b class="red"><span>~<%=salePer%>%</span></b><% end if %>&nbsp;<% If blncoupon Then %><b class="green"><small>쿠폰</small><span><%=saleCPer%></span></b><% end if %></div><% end if %>
					<!-- 브랜드 링크 -->
					<% If ebrand<>"" Then %><div class="btnGroup"><a href="" onclick="fnAPPpopupBrand('<%=ebrand%>'); return false;" class="btnV16a"><%=SocName_Kor%></a></div><% end if %>
				</section>
			</div>
			<% ElseIf mdthememo="2" Then %>
			<!-- type 2 : full rolling 타입 -->
			<div class="event-article event-full-rolling-type">
				<!-- rolling -->
				<div id="mdRolling" class="swiper">
					<div class="swiper-container">
						<% If fnGetMoSlideImgCnt(eCode) > 1 Then %>
						<div class="swiper-wrapper">
							<% sbSlidetemplateMD %>
						</div>
						<div class="pagination-line"></div>
						<button type="button" class="btnNav btnPrev">이전</button>
						<button type="button" class="btnNav btnNext">다음</button>
						<% Else %>
							<% sbSlidetemplateMD %>
						<% End If %>
					</div>
				</div>
				<section class="section-event hgroup-event">
					<h2 style="word-break:keep-all;"><%=title_mo%></h2>
					<p class="subcopy" style="word-break:keep-all;"><%=evt_subname%></p>
					<% If blnsale Or blncoupon Then %><div class="discount"><% If blnsale Then %><b class="red"><span>~<%=salePer%>%</span></b><% end if %>&nbsp;<% If blncoupon Then %><b class="green"><small>쿠폰</small><span><%=saleCPer%></span></b><% end if %></div><% end if %>
					<% If ebrand<>"" Then %><div class="btnGroup"><a href="" onclick="fnAPPpopupBrand('<%=ebrand%>'); return false;" class="btnV16a"><%=SocName_Kor%></a></div><% end if %>
				</section>
			</div>
			<% ElseIf mdthememo="3" Then %>
			<!-- type 3 : rolling 타입 -->
			<div class="event-article event-rolling-type" style="background-color:<%=ThemeColorCode%>;"><!-- for dev msg : 어드민에서 배경 등록 부분입니다. -->
				<section class="section-event hgroup-event">
					<% If ebrand<>"" Then %><div class="btnGroup"><a href="" onclick="fnAPPpopupBrand('<%=ebrand%>'); return false;" class="btnV16a"><%=SocName_Kor%></a></div><% end if %>
					<h2 style="word-break:keep-all;"><%=title_mo%></h2>
					<p class="subcopy" style="word-break:keep-all;"><%=evt_subname%></p>
					<% If blnsale Or blncoupon Then %><div class="discount"><% If blnsale Then %><b class="red"><span>~<%=salePer%>%</span></b><% end if %>&nbsp;<% If blncoupon Then %><b class="green"><small>쿠폰</small><span><%=saleCPer%></span></b><% end if %></div><% end if %>
				</section>
				<div id="mdRolling" class="swiper">
					<div class="swiper-container">
						<% If fnGetMoItemSlideImgCnt(eCode) > 1 Then %>
						<div class="swiper-wrapper">
							<% sbSlidetemplateItemMD %>
						</div>
						<div class="pagination-line"></div>
						<button type="button" class="btnNav btnPrev">이전</button>
						<button type="button" class="btnNav btnNext">다음</button>
						<% Else %>
							<% sbSlidetemplateItemMD %>
						<% End If %>
					</div>
				</div>
			</div>
			<% End If %>
			<% If using_text1 <> "" And usinginfo>0 Then %>
			<section class="section-event brand-event">
				<h3 lang="ko" style="word-break:keep-all;"><%=using_text1%></h3>
				<div class="desc" style="word-break:keep-all;">
					<p><%=using_contents1%></p>
				</div>
			</section>
			<% End If %>
			<% If using_text2 <> "" And usinginfo>1 Then %>
			<section class="section-event book-event">
				<h3 lang="ko"><%=using_text2%></h3>
				<p><%=using_contents2%></p>
			</section>
			<% End If %>
			<% If using_text3 <> "" And usinginfo>2 Then %>
			<section class="section-event book-event">
				<h3 lang="ko"><%=using_text3%></h3>
				<p><%=using_contents3%></p>
			</section>
			<% End If %>
			<% If gift_isusing>0 Then %>
			<section class="section-event gift-event">
				<h3 lang="en">GIFT</h3>
				<% If gift_text1 <> "" And gift_isusing>0 Then %>
				<div class="desc">
					<p><%=gift_text1%></p>
					<% If gift_img1 <> "" Then %><div class="thumbnail"><img src="<%=gift_img1%>" alt="" /></div><% End If %>
				</div>
				<% End If %>
				<% If gift_text2 <> "" And gift_isusing>1 Then %>
				<div class="desc">
					<p><%=gift_text2%></p>
					<% If gift_img2 <> "" Then %><div class="thumbnail"><img src="<%=gift_img2%>" alt="" /></div><% End If %>
				</div>
				<% End If %>
				<% If gift_text3 <> "" And gift_isusing>2 Then %>
				<div class="desc">
					<p><%=gift_text3%></p>
					<% If gift_img3 <> "" Then %><div class="thumbnail"><img src="<%=gift_img3%>" alt="" /></div><% End If %>
				</div>
				<% End If %>
			</section>
			<% End If %>
			<% If comm_isusing="Y" Then %>
			<section class="section-event comment-event">
				<h3 lang="en">COMMENT EVENT</h3>
				<p class="gift"><%=comm_text%></p>
				<ul>
					<li>기간 : <span class="date"><%=Replace(comm_start,"-",".")%> ~ <%=Replace(comm_end,"-",".")%></span></li>
					<li>당첨자 발표 : <span class="date"><%=Replace(epdate,"-",".")%></span></li>
				</ul>
				<div class="btnGroup">
					<a href="#replyList" class="btnV16a">코멘트 남기러가기<span class="icon"></span></a>
				</div>
			</section>
			<% End If %>
			
            <%'// 상품 리스트 분리 -- 이종화 %>
			<% If isArray(arrGroup) Then %>
            <div id="eventitemlist" v-cloak>
                <div class="exhibition-list-wrap<% If UBound(arrGroup, 2)>0 Then %> exhibition-list-wrap<% Else %> exhibition-list-wrap-nogroupbar<% End If %>">
                    <% If UBound(arrGroup, 2)>0 Then %>
						<group-itemlist v-for="(item,index) in sliced" v-if="sliced" :items="item" :groups="groups" :key="index" :wrapper="true" :barcolor="themebarColor" :ltype="listType" :isapp="1" ></group-itemlist>
					<% Else %>
						<nogroup-itemlist :items="sliced" :ltype="listType" :isapp="1" ></nogroup-itemlist>
					<% End If %>
					<temp-layout v-if="tempFlag"></temp-layout>
                </div>
            </div>
			<% End If %>
			<style type="text/css">
			.noscroll {overflow:hidden; height:100%;}
			</style>
			<script>
			$(function(){
				/* rolling for md event */
				if ($("#mdRolling .swiper-container .swiper-slide").length > 1) {
					var mdRolling = new Swiper("#mdRolling .swiper-container", {
						pagination:"#mdRolling .pagination-line",
						paginationClickable:true,
						autoplay:1700,
						loop:true,
						speed:800,
						nextButton:"#mdRolling .btnNext",
						prevButton:"#mdRolling .btnPrev"
					});
				} else {
					var mdRolling = new Swiper("#mdRolling .swiper-container", {
						pagination:false,
						noSwipingClass:".noswiping",
						noSwiping:true
					});
				}

				$("#mdRolling .pagination-line").each(function(){
					var checkItem = $(this).children(".swiper-pagination-switch").length;
					if (checkItem == 2) {
						$(this).addClass("grid2");
					}
					if (checkItem == 3) {
						$(this).addClass("grid3");
					}
					if (checkItem == 4) {
						$(this).addClass("grid4");
					}
					if (checkItem == 5) {
						$(this).addClass("grid5");
					}
				});

				var menuTop=0;

				window.onload=function(){
					menuTop = $(".evtPdtListWrapV15").offset().top;

					$(window).scroll(function(){
						//if( $(window).scrollTop()>=menuTop ) {
						//	$(".dropdownWrap").css("position","fixed");
						//} else {
						//	$(".dropdownWrap").css("position","absolute");
						//}
						$(".dropdownWrap").css("z-index","99");
						<% If isArray(arrGroup) Then %>
						<% For intG = 1 To UBound(arrGroup,2) %>
						// for dev msg : 2017.06.08 id값은 기차코드로 뿌려주세요 group******
						if($("#groupBar<%=arrGroup(0,intG)%>").length) {
							if( $(window).scrollTop()>=$("#groupBar<%=arrGroup(0,intG)%>").offset().top-$(".dropdownWrap").outerHeight()) {
								var groupbar = $("#groupBar<%=arrGroup(0,intG)%>").children("h3").text();
								$(".evtPdtListWrapV15").find(".btnDrop").text(groupbar);
							}
						}
						<% next %>
						<% end if %>
						if($("#remove").length) {
							if( $(window).scrollTop()>=$("#remove").offset().top-$(".dropdownWrap").outerHeight()) {
								$(".dropdownWrap").css("position","absolute");
							}
						}
					});
				}
			});
			</script>
			<div id="remove"></div>
		<%	
            CASE "11" 'MD 등록 이벤트 I형 
        %>
			<% If vDateView = False Then %>
			<div class="section-event event-head">
				<p class="date"><%=Replace(esdate,"-",".")%> ~ <%=Replace(eedate,"-",".")%></p>
			</div>
			<% end if %>
			<div class="evtContV15">
			<%= strExpireMsg %>
            <% If Trim(evtFileyn_mo)="" Or evtFileyn_mo = "0" Or isnull(evtFileyn_mo) Or evtFileyn_mo = "False" Then %>
            <% else %>
                <% If checkFilePath(server.mappath(evtFile_mo)) Then %>
                    <div width="100%"><% server.execute(evtFile_mo)%></div>
                <% End If %>
            <% End If %>
            <% If Trim(evt_html_mo)="" Or not isnull(evt_html_mo) Then %>
                <%=evt_html_mo%>
            <% End If %>
			<div class="bnrTemplate"><%=tArea%></div><%'모바일 상단 추가 이미지 %>
			</div>

			<!-- type 2 : full rolling 타입 -->
			<div class="event-article event-full-rolling-type">
				<!-- I형 이미지 슬라이더 -->
				<div class="evt-sliderV19">
					<div class="swiper-container">
						<% If fnGetMoTopSlideImgCnt(eCode) > 1 Then %>
						<div class="swiper-wrapper">
							<% If videoFullLink<>"" Then %>
							<div class="swiper-slide has-vod">
								<div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
							</div>
							<% End If %>
							<% sbTopSlidetemplateMD %>
						</div>
						<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
						<% ElseIf fnGetMoTopSlideImgCnt(eCode) > 0 And videoFullLink<>"" Then %>
						<div class="swiper-wrapper">
							<% If videoFullLink<>"" Then %>
							<div class="swiper-slide has-vod">
								<div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
							</div>
							<% End If %>
							<% sbTopSlidetemplateMD %>
						</div>
						<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
						<% ElseIf fnGetMoTopSlideImgCnt(eCode) < 1 And videoFullLink<>"" Then %>
							<div class="swiper-slide has-vod">
								<div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
							</div>
						<% Else %>
						<div class="swiper-wrapper">
							<% sbTopSlidetemplateMD %>
						</div>
						<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
						<% End If %>
					</div>
				</div>
				<section class="hgroup-event"<% if CopyHide="1" then %> style="display:none"<% end if %>>
					<h2 style="word-break:keep-all;"><%=title_mo%></h2>
					<p class="subcopy" style="word-break:keep-all;"><%=evt_subname%></p>
					<div class="labels">
						<% If blnsale Or blncoupon Then %>
						<% If blnsale Then %><span class="labelV19 label-red">~<%=salePer%>%</span><% end if %>
						<% If blncoupon Then %>&nbsp;<span class="labelV19 label-green">~<%=saleCPer%>%</span><% end if %>
						<% end if %>
						<% If blngift Then %>&nbsp;<span class="labelV19 label-blue">GIFT</span><% end if %>
						<% If isOnePlusOne Then %>&nbsp;<span class="labelV19 label-blue">1+1</span><% end if %>
						<% If isNew Then %>&nbsp;<span class="labelV19 label-black">런칭</span><% end if %>
						<% If blncomment or blnbbs or blnitemps Then %>&nbsp;<span class="labelV19 label-black">참여</span><% end if %>
						<% If isOnlyTen Then %>&nbsp;<span class="labelV19 label-black">단독</span><% end if %>
					</div>
				</section>
			</div>

			<div class="bnrTemplate"><%=mArea%></div><%'모바일 중간 추가 이미지 %>

			<%=newGiftBox%>

			<% sbMultiContentsView %>

			<!-- 코멘트 박스 -->
			<% If blncomment Then %>
			<section class="comment-eventV19">
				<h3 style="color:<%=ThemeColorCode%>;">Comment Event</h3>
				<p class="topic"><%=nl2br(comm_text)%></p>
				<ul>
					<li>작성기간 <span class="date"><%=Replace(comm_start,"-",".")%> ~ <%=Replace(comm_end,"-",".")%></span></li>
					<li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
				</ul>
				<div class="btnGroup">
					<a href="#replyList" class="btn-go">코멘트 쓰러가기<span class="icon"></span></a>
				</div>
				<% if freebie_img<>"" then %><div class="thumbnail"><img src="<%=freebie_img%>" alt=""></div><% End If %>
			</section>
			<% End If %>

			<!-- 상품후기 박스 -->
			<% If blnitemps Then %>
			<section class="comment-eventV19">
				<h3 style="color:<%=ThemeColorCode%>;">Review Event</h3>
				<p class="topic"><%=nl2br(eval_text)%></p>
				<ul>
					<li>작성기간 <span class="date"><%=Replace(eval_start,"-",".")%> ~ <%=Replace(eval_end,"-",".")%></span></li>
					<li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
				</ul>
				<div class="btnGroup">
					<a href="#replyPrdList" class="btn-go">리뷰 쓰러가기<span class="icon"></span></a>
				</div>
				<% if eval_freebie_img<>"" then %><div class="thumbnail"><img src="<%=eval_freebie_img%>" alt=""></div><% End If %>
			</section>
			<% End If %>

			<!-- 포토 코멘트 박스 -->
			<% If blnbbs Then %>
			<section class="comment-eventV19">
				<h3 style="color:<%=ThemeColorCode%>;">Photo Comment Event</h3>
				<p class="topic"><%=nl2br(board_text)%></p>
				<ul>
					<li>작성기간 <span class="date"><%=Replace(board_start,"-",".")%> ~ <%=Replace(board_end,"-",".")%></span></li>
					<li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
				</ul>
				<div class="btnGroup">
					<a href="#replyPhotoList" class="btn-go">코멘트 쓰러가기<span class="icon"></span></a>
				</div>
				<% if board_freebie_img<>"" then %><div class="thumbnail"><img src="<%=board_freebie_img%>" alt=""></div><% End If %>
			</section>
			<% End If %>

			<%'// 상품 리스트 분리 -- 이종화 %>
            <div id="eventitemlist" v-cloak>
                <div class="exhibition-list-wrap<% If isArray(arrGroup) Then %> exhibition-list-wrap<% Else %> exhibition-list-wrap-nogroupbar<% End If %>">
                    <% If isArray(arrGroup) Then %>
						<group-itemlist v-for="(item,index) in sliced" v-if="sliced" :items="item" :groups="groups" :key="index" :wrapper="true" :barcolor="themebarColor" :ltype="listType" :isapp="1" ></group-itemlist>
					<% Else %>
						<nogroup-itemlist :items="sliced" :ltype="listType" :isapp="1" ></nogroup-itemlist>
					<% End If %>
					<temp-layout v-if="tempFlag"></temp-layout>
                </div>
            </div>
			<style type="text/css">
				.noscroll {overflow:hidden; height:100%;}
				.exhibition-list-wrap .dropdownWrap {transition-duration: .2s;}
			</style>
            <script>
            $(function(){
                $('.evt-sliderV19 .pagination-progressbar-fill').css('background', '<%=ThemeColorCode%>'); // for dev msg : 테마색상 등록
				// I형 이미지 슬라이더
				$('.evt-sliderV19').each(function(index, slider) {
					var slider = $(this).find('.swiper-container');
					var amt = slider.find('.swiper-slide').length;
					var progress = $(this).find('.pagination-progressbar-fill');
					if (amt > 1) {
						var evtSwiper = new Swiper(slider, {
							autoplay: 1700,
							loop: true,
							speed: 800,
							autoplayDisableOnInteraction: false,
							onInit: function(evtSwiper) {
								var init = (1 / amt).toFixed(2);
								progress.css('transform', 'scaleX(' + init + ') scaleY(1)');
							},
							onSlideChangeStart: function(evtSwiper) {
								var activeIndex = evtSwiper.activeIndex;
								var realIndex = parseInt(evtSwiper.slides.eq(activeIndex).attr('data-swiper-slide-index') || activeIndex, 10);
								var calc = ( (realIndex+1) / amt ).toFixed(2);
								progress.css('transform', 'scaleX(' + calc + ') scaleY(1)');
							}
						});
					} else {
						var evtSwiper = new Swiper(slider, {
							noSwiping: true,
							noSwipingClass: '.noswiping'
						});
						$(this).find('.pagination-progressbar').hide();
					}
				});

                /* dropdown */
                $(".btnDrop").on("click", function(e){
                    e.stopPropagation();
                    //$(".dropdownWrap").css("position","fixed");
                    //$("#mask").show();
                    $(".btnDrop + .dropBox").hide();
                    $(this).next().show();
                    $(this).toggleClass("on");
                    $(this).next().toggleClass("on");
                    //$("body").addClass("noscroll");
                    return false;
                });
                $(".dropBox ul li a").on("click", function(e){
                    $(this).parent().parent().parent().prev(".btnDrop").removeClass("on")
                    $(this).parent().parent().parent().removeClass("on").prev(".btnDrop").text($(this).text());
                    //$("body").removClass("noscroll");
                    //$("#mask").hide();
                });
                $(document).on("click", function(e){
                    $(".dropBox + .dropBox").hide();
                    $(".btnDrop").removeClass("on");
                    $(".lyDropdown .btnDrop").addClass("on");
                    $(".dropBox").removeClass("on");
                });
            });
            </script>
			<div class="bnrTemplate"><%=bArea%></div>
			<div id="remove"></div>
		<%	
            CASE ELSE '기본:메인이미지+상품목록 
        %>
            <div class="evtContV15">
                <div class="bnrTemplate"><%=tArea%></div>
                <% If slide_m_flag ="Y" Then %><% sbSlidetemplate '//slide template %><% End If %>
                <%= strExpireMsg %>
                <% If emimg_mo <> "" Then %><div><img src="<%=emimg_mo%>" alt="<%=eName%>" /></div><% End If %>
                <div class="bnrTemplate"><%=mArea%></div>
            </div>
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

			<%'// 상품 리스트 분리 -- 이종화 %>
            <div id="eventitemlist" v-cloak>
                <div class="exhibition-list-wrap exhibition-list-wrap-nogroupbar">
                    <nogroup-itemlist :items="sliced" :ltype="listType" :isapp="1" ></nogroup-itemlist>
                    <temp-layout v-if="tempFlag"></temp-layout>
                </div>
            </div>

			<div class="bnrTemplate"><%=bArea%></div>
		<%	
            End SELECT 
        %>

		<%'상품 이후 하단 컨텐츠 %>
		<!-- #include virtual="/event/lib/add_footcontents.asp" -->

		<% If blnitemps Then %>
		<div class="inner5 tMar25" id="replyPrdList">
			<!-- #include virtual="/apps/appcom/wish/web2014/event/lib/evaluate_lib.asp" -->
		</div>
		<% End If %>

		<% if blncomment then
			dim cEComment, iCTotCnt, arrCList, intCLoop

			'코멘트 데이터 가져오기
			set cEComment = new ClsEvtComment
			
			if LinkEvtCode>0 then
				cEComment.FECode 		= LinkEvtCode	'관련코드 = 온라인 코드
			else
				''2017 웨딩 이벤트 코멘트 통합 171010 유태욱
				if eCode = "80615" or eCode = "80616" or eCode = "80617" then
					cEComment.FECode 		= 80833
				else
					cEComment.FECode 		= eCode
				end if
			end if
			cEComment.FComGroupCode	= com_egCode
			cEComment.FEBidx    	= bidx 
			cEComment.FCPage 		= 1	'현재페이지
			cEComment.FPSize 		= 5	'페이지 사이즈
			cEComment.FTotCnt 		= -1  '전체 레코드 수
			arrCList = cEComment.fnGetComment
			iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
			set cEComment = nothing
		%>
		<div class="inner5 tMar25">
			<div id="replyList" class="replyList box1 evtReplyV15">
				<p class="total">총 <%=iCTotCnt%>개의 댓글이 있습니다.</p>
				<% If Trim(epdate) <> "" Then %>
					<% If Left(epdate, 10) <= Left(Now(), 10) Then %>
						<a href="" onClick="alert('당첨자 발표일이 지난 이벤트 입니다.'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
					<% Else %>
						<a href="" onClick="fnAPPpopupBrowserURL('코멘트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/event_comment.asp?view=w&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
					<% End If %>
				<% Else %>
					<a href="" onClick="fnAPPpopupBrowserURL('코멘트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/event_comment.asp?view=w&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
				<% End If %>
				<%IF isArray(arrCList) THEN
					dim arrUserid, bdgUid, bdgBno
					'사용자 아이디 모음 생성(for Badge)
					for intCLoop = 0 to UBound(arrCList,2)
						arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(arrCList(2,intCLoop)) & "''"
					next

					'뱃지 목록 접수(순서 랜덤)
					Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")
				%>
				<ul>
					<%For intCLoop = 0 To UBound(arrCList,2)%>
					<li>
						<p class="num"><%=iCTotCnt-intCLoop-(Int(iCTotCnt/3)*(1-1))%><% If arrCList(8,intCLoop) <> "W" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
						<div class="replyCont">
							<%
								Dim strBlog
								'URL이 존재하고 본인 또는 STAFF가 접속해있다면 링크 표시
								strBlog = ReplaceBracket(db2html(arrCList(7,intCLoop)))
								if trim(strBlog)<>"" and (GetLoginUserLevel=7 or arrCList(2,intCLoop)=GetLoginUserID) then
									Response.Write "<p class='bMar05'><strong>URL :</strong> <a href='" & ChkIIF(left(trim(strBlog),4)="http","","http://") & strBlog & "' target='_blank'>" & strBlog & "</a></p>"
								end if
							%>
							<p><%=striphtml(db2html(arrCList(1,intCLoop)))%></p>
							<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<p class="tPad05">
								<span class="button btS1 btWht cBk1"><a href="" onClick="DelComments('<% = arrCList(0,intCLoop) %>'); return false;">삭제</a></span>
							</p>
							<% end if %>
							<div class="writerInfo">
								<p><%=FormatDate(arrCList(4,intCLoop),"0000.00.00")%> <span class="bar">/</span> <% if arrCList(2,intCLoop)<>"10x10" then %><%=printUserId(arrCList(2,intCLoop),2,"*")%><% End If %></p>
								<p class="badge">
									<%=getUserBadgeIcon(arrCList(2,intCLoop),bdgUid,bdgBno,3)%>
								</p>
							</div>
						</div>
					</li>
					<% Next %>
				</ul>
				<% ELSE %>
					<p class="no-data ct">해당 게시물이 없습니다.</p>
				<% END IF %>
				<% If isArray(arrCList) Then %>
				<div class="btnWrap tPad15">
					<span class="button btM1 btBckBdr cBk1 w100p"><a href="" onClick="fnAPPpopupBrowserURL('코멘트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/event_comment.asp?view=l&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>&epdate=<%=epdate%>'); return false;"><em>전체보기</em></a></span>
				</div>
				<% End If %>
			</div>
		</div>
		<% end if %>
		<form name="frmact" method="post" action="/apps/appCom/wish/web2014/event/lib/doEventComment.asp" target="iframeDB" style="margin:0px;">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="returnurl" value="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>&comm=o">
		<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= LinkEvtCode %>">
		</form>
		<%
			Dim vArrIssue, vLink , vName , vSale
			set cEvent = new ClsEvtCont
				cEvent.FECode = eCode
				cEvent.FEKind = ekind
				cEvent.FBrand = ebrand
				cEvent.FDevice = "A" 'device
				cEvent.FEDispCate = edispcate
				vArrIssue = cEvent.fnEventISSUEList
			set cEvent = nothing
		%>
		<% If ekind<>"29" Then %>
		<% If isArray(vArrIssue) THEN %>
		<%'관련 기획전 날려버림 클래스 전용%>
		<% End If %>
		<% End If %>
		<script>
		<!--
			function jsDownCoupon(stype,idx){
			<% IF IsUserLoginOK THEN %>
			var frm;
				frm = document.frmC;
				//frm.target = "iframecoupon";
				frm.action = "/shoppingtoday/couponshop_process.asp";
				frm.stype.value = stype;
				frm.idx.value = idx;
				frm.submit();
			<%ELSE%>
				if(confirm("로그인하시겠습니까?")) {
					self.location="/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
				}
			<%END IF%>
			}
		//-->
		</script>
		<form name="frmC" method="post">
		<input type="hidden" name="stype" value="">
		<input type="hidden" name="idx" value="">
		</form>
		<iframe src="about:blank" name="iframecoupon" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>
		<iframe src="about:blank" name="iframeDB" frameborder="0" width="0" height="0"></iframe>
	</div>
	<!-- //content area -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incfooter.asp" -->
<% If requestCheckVar(Request("comm"),1) = "o" Then %>
<script>$('html, body').animate({ scrollTop: $(".replyList").offset().top }, 0)</script>
<% End If %>
<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>
<script type='text/javascript' src='/lib/js/jquery.lazyload.min.js'></script>
<% If slide_m_flag = "Y" Then '// slide template %>
<script type="text/javascript">
$(function(){
	slideTemplate = new Swiper('.slideTemplateV15 .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".slideTemplateV15 .pagination",
		paginationClickable:true,
		nextButton:'.slideTemplateV15 .btnNext',
		prevButton:'.slideTemplateV15 .btnPrev'
	});
});
</script>
<% End If %>
<script src="/vue/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script>
<% 
    dim apitest : apitest = true
    dim apiurl : apiurl = ""
    IF application("Svr_Info") = "Dev" THEN
        apiurl = "//testfapi.10x10.co.kr/api/web/v1/event/items-v2"
    ElseIf application("Svr_Info")="staging" Then
        apiurl = "//fapi.10x10.co.kr/api/web/v1/event/items-v2"
    Else
        apiurl = "//fapi.10x10.co.kr/api/web/v1/event/items-v2"
    End If

    if apitest then
%>
    var itemparam = "?eventid=<%=eCode%>&eventGroupCode=<%=egCode%>&itemsort=<%=eitemsort%>&listtype=<%=eItemListType%>&themebarcolor=<%=replace(ThemeBarColorCode,"#","")%>&ekind=<%=ekind%>&eventtype=<%=evt_type%>&pNtr=<%=server.URLEncode(searchback_Param)%>&userid=<%= GetLoginUserID %>";

    var dataObject = {
        eventid : <%=eCode%>,
        logparam : "&pEtr=<%=eCode%>",
        addparam : "&pNtr=<%=server.URLEncode(searchback_Param)%>",
        eventkind : "<%=ekind%>",
        eventtype : "<%=evt_type%>",
        listtype : "<%=eItemListType%>",
    }

    var data_itemlist = "<%=apiurl%>"+itemparam;
<% else %>
    var itemparam = "?eventid=<%=eCode%>&eGC=<%=egCode%>&itemsort=<%=eitemsort%>&listtype=<%=eItemListType%>&themebarcolor=<%=replace(ThemeBarColorCode,"#","")%>&ekind=<%=ekind%>&eventtype=<%=evt_type%>&pNtr=<%=server.URLEncode(searchback_Param)%>";

    var data_itemlist = "/event/lib/act_eventgroupjson.asp"+itemparam;
<% end if %>    
</script>
<script src="/event/lib/eventgroupitemlist2021.js?v=1.05"></script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->