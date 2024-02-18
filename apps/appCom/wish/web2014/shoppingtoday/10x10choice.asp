<%@ codepage="65001" language="VBScript" %>
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
dim evt_type

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66184
Else
	eCode   =  72425
End If

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


egCode = requestCheckVar(Request("eGC"),10)	'이벤트 그룹코드
IF egCode = "" THEN egCode = 0

IF application("Svr_Info") = "Dev" THEN
	Select Case egCode
		Case "186054" : egCode = 136961
		Case "186055" : egCode = 136962
		Case "186056" : egCode = 136963
	End Select
end if

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

		evt_type = cEvent.fnEventTypeName

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

		if evt_type="multi3" then '멀티3
			etemplate_mo = "10"
		end if

		'그룹형(etemplate_mo = "3")일때만 그룹내용 가져오기
		IF etemplate_mo = "3" Then
			If sgroup_m And egCode = "0" Then '// 그룹형 랜덤 체크 되었을때
				arrTopGroup = cEvent.fnGetEventGroupTop
				egCode = arrTopGroup(0,0)
			End If 
		cEvent.FEGCode = 	egCode		
		arrGroup =  cEvent.fnGetEventGroup_mo					
		END If
		
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
						Else
							tArea = tArea & "<a href='' "& chkiif(arrAddbanner(3,intAi) <> "","","_") &"onclick=""fnAPPpopupAutoUrl('"& arrAddbanner(3,intAi) &"');return false;""><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						End If 
					ElseIf arrAddbanner(0,intAi) = "2" And ( CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
						If InStr(arrAddbanner(3,intAi),"/event/")>0 Then
							mArea = mArea & "<a href='/apps/appcom/wish/web2014"& arrAddbanner(3,intAi) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						Else
							mArea = mArea & "<a href='' "& chkiif(arrAddbanner(3,intAi) <> "","","_") &"onclick=""fnAPPpopupAutoUrl('"& arrAddbanner(3,intAi) &"');return false;""><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
						End If 
					ElseIf arrAddbanner(0,intAi) = "3" And ( CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
						If InStr(arrAddbanner(3,intAi),"/event/")>0 Then
							bArea = bArea & "<a href='/apps/appcom/wish/web2014"& arrAddbanner(3,intAi) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
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
		
	'//이벤트 명 할인이나 쿠폰시
	eOnlyName = "텐텐 초이스"

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	dim snpTitle, snpLink, snpPre, snpImg , snpTag , snpTag2 , kakaourl
	snpTitle = Server.URLEncode(eOnlyName)
	snpLink = Server.URLEncode(wwwUrl&"/shoppingtoday/10x10choice.asp")
	snpPre = Server.URLEncode("10x10 텐텐초이스")
	if bimg<>"" then
		snpImg = Server.URLEncode(bimg)
	elseIf evt_mo_listbanner <> "" Then 
		snpImg = Server.URLEncode(evt_mo_listbanner)
	End If 
	'기본 태그
	snpTag = Server.URLEncode("텐바이텐 텐텐초이스")
	snpTag2 = Server.URLEncode("#10x10")
	kakaourl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/shoppingtoday/10x10choice.asp"
	
	strPageTitle = "텐텐 초이스"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title>10x10: 텐텐 초이스</title>
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
function goGroupSelect(v,a){
	$('html, body').animate({
	    scrollTop: $("#groupBar"+v+"").offset().top
	}, 300)
	
	$("#groupBar"+a+" > option[value="+a+"]").attr("selected", "true");
}

//앵커이동
function goToByScroll(valtop){
	$('html,body').animate({scrollTop: valtop},'fast');
}

// SNS 공유 팝업
function fnAPPRCVpopSNS(){
	fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	return false;
}

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

$(function(){
	// 순차 로딩
	$("img.lazy").lazyload().removeClass("lazy");
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- content area -->
			<div class="content evtDetailV15" id="contentArea">
						<div class="evtContV15">
						<div class="bnrTemplate"><%=tArea%></div><%'모바일 상단 추가 이미지 %>
						<% If slide_m_flag ="Y" Then %><% sbSlidetemplate '//slide template %><% End If %>
						<%
						If isArray(arrGroup) Then
							If arrGroup(0,0) <> "" Then	
								if arrGroup(3,0) <> "" then
						%>
								<div><img src="<%=arrGroup(3,0)%>" alt="<%=egCode%>" /></div>
						<%		End If %>
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
						<%	End If %>
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
						<div class="evtPdtListWrapV15">
						<div class="evtPdtListV15" id="topitem">
						<% sbEvtItemView_app_2015 %>
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
								<div class="evtPdtListV15" id="group<%=arrGroup(0,intG)%>">
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
						<div class="bnrTemplate"><%=bArea%></div><%'모바일 하단 추가 이미지 %>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
			<% '수집 스크립트들 %>
		</div>
	</div>
</div>
<script type='text/javascript' src='/lib/js/jquery.lazyload.min.js'></script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->