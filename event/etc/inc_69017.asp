<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%

'###########################################################
' Description : MD 이벤트 신입의 정석(1)
' History : 2016.02.12 원승현
'###########################################################

dim eCode
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
Dim evt_bannerimg_mo , evt_mo_listbanner , evt_html_mo , vIsweb , vIsmobile , vIsapp , evt_subname , blnbookingsell 
Dim arrTextTitle
Dim iEndCnt, intJ
'//logparam
Dim logparam : logparam = "&pEtr="&eCode

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "66027"
	Else
		eCode 		= "69017"
	End If



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


		If sgroup_m And egCode = "0" Then '// 그룹형 랜덤 체크 되었을때
			arrTopGroup = cEvent.fnGetEventGroupTop
			egCode = arrTopGroup(0,0)
		End If 
		cEvent.FEGCode = 	egCode		
		arrGroup =  cEvent.fnGetEventGroup_mo					

		
		'//2015추가 코멘트(테스터) or 상품후기 or 사은품 or 예약판매 체크가 되어 있을때만 가저오기
		If blncomment Or blnitemps Or blngift Or blnbookingsell Then
			cEvent.FEGCode	=	egCode		
			arrTextTitle	=	cEvent.fnGetEventTextTitle
		End If
				
		cEvent.FECategory  = ecategory
		'arrRecent = cEvent.fnGetRecentEvt
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
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.swiper {position:relative;}
.swiper .only {position:absolute; right:13%; top:0; width:18.5%; z-index:20;}
.swiper button {position:absolute; top:37%; z-index:150; width:13.5%; background:transparent;}
.swiper .btnPrev {left:0;}
.swiper .btnNext {right:0;}
.swiper .pagination {position:absolute; bottom:0; left:0; width:100%; height:auto; z-index:100; padding-top:0; text-align:center;}
.swiper .pagination span {display:inline-block; width:0.7rem; height:0.7rem; margin:0 0.5rem; border-radius:50%;  border:0.18rem solid #fff; cursor:pointer; background-color:rgba(0,0,0,.1); box-shadow:0 0 0.4rem 0 rgba(0,0,0,.25); transition:all .3s;}
.swiper .pagination .swiper-active-switch {background-color:#fff;}
.navigator {position:relative;}
.navigator ul {overflow:hidden; position:absolute; top:12%; left:2%; width:96%; height:75%;}
.navigator ul li {float:left; width:50%; height:100%;}
.navigator ul li a {display:block; position:relative; height:100%; color:transparent; font-size:0; line-height:0;}
.forNewcomer .list {padding-bottom:1.5rem;}
.forNewcomer .list ul {background:#fff;}
.forNewcomer .list li {display:table; overflow:hidden; width:100%; padding:5%; border-bottom:0.1rem solid #dfdfdf;}
.forNewcomer .list li .pPhoto {display:table-cell; width:42%; vertical-align:top;}
.forNewcomer .list li .pdtCont {position:relative; display:table-cell; width:58%; padding:0.5rem 0 0 1.5rem; vertical-align:top;}
.forNewcomer .list li .pdtCont p {line-height:1;}
.forNewcomer .list li .numbering {width:2.4rem; height:2.4rem; padding-top:0.5rem; text-align:center; border:2px solid #000; border-radius:50%;}
.forNewcomer .list li .numbering span {font-size:1.4rem; line-height:0.92; color:#000; font-weight:bold;}
.forNewcomer .list li p.pName {height:2.8rem; font-size:1.2rem; line-height:1.3; padding-top:0; margin-top:1.5rem; color:#999;}
.forNewcomer .list li .pType {font-size:1.5rem; padding:1.3rem 0 0.5rem; font-weight:600;}
.forNewcomer .list li .type01 {color:#d60000;}
.forNewcomer .list li .type02 {color:#ff7800;}
.forNewcomer .list li .type03 {color:#1cbbb4;}
.forNewcomer .list li .type04 {color:#477da5;}
.forNewcomer .list li .type05 {color:#d60000;}
.forNewcomer .list li .pPrice {position:absolute; left:1.5rem; bottom:0.5rem; font-size:1.5rem; padding-top:0; color:#676767;}
.relatedEvt {overflow:hidden;}
.relatedEvt p {float:left; width:50%;}
.relatedEvt p.wide {width:100%;}
</style>


<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		autoplay:3000,
		speed:1000,
		pagination:".pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		prevButton:'.btnPrev',
		nextButton:'.btnNext',
		effect:'fade'
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
		}, 500);
	});
});
</script>

<div class="mEvt69017 forNewcomer">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/tit_newcomer.png" alt="신입의 정석" /></h2>
	<div class="swiper">
		<p class="only"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/ico_only.png" alt="ONLY 10X10" /></p>
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
				<% If isApp="1" Then %>
					<div class="swiper-slide"><a href="" onclick="fnAPPpopupEvent('69016');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_01.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="" onclick="fnAPPpopupEvent('69016');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_02.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="" onclick="fnAPPpopupEvent('69016');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_03.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="" onclick="fnAPPpopupEvent('69016');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_04.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="" onclick="fnAPPpopupEvent('69016');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_05.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="" onclick="fnAPPpopupEvent('69016');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_06.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="" onclick="fnAPPpopupEvent('69016');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_07.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="" onclick="fnAPPpopupEvent('69016');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_08.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="" onclick="fnAPPpopupEvent('69016');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_09.png" alt="" /></a></div>
				<% Else %>
					<div class="swiper-slide"><a href="/event/eventmain.asp?eventid=69016"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_01.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="/event/eventmain.asp?eventid=69016"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_02.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="/event/eventmain.asp?eventid=69016"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_03.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="/event/eventmain.asp?eventid=69016"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_04.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="/event/eventmain.asp?eventid=69016"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_05.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="/event/eventmain.asp?eventid=69016"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_06.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="/event/eventmain.asp?eventid=69016"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_07.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="/event/eventmain.asp?eventid=69016"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_08.png" alt="" /></a></div>
					<div class="swiper-slide"><a href="/event/eventmain.asp?eventid=69016"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/img_slide_09.png" alt="" /></a></div>
				<% End If %>
			</div>
		</div>
		<div class="pagination"></div>
		<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/btn_prev.png" alt="이전" /></button>
		<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/btn_next.png" alt="다음" /></button>
	</div>
	<div class="navigator">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/tab_01.png" alt="" /></p>
		<ul>
			<li class="nav1">
				<% If isApp="1" Then %>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=69017">
				<% Else %>
					<a href="/event/eventmain.asp?eventid=69017">
				<% End If %>
					FOR 신입생
				</a>
			</li>
			<li class="nav2">
				<% If isApp="1" Then %>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=69015">
				<% Else %>
					<a href="/event/eventmain.asp?eventid=69015">
				<% End If %>
					FOR 신입사원
				</a>
			</li>
		</ul>
	</div>

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
			<div id="group<%=arrGroup(0,intG)%>">
				<div class="groupBarV15">
					<select id="groupBar<%=arrGroup(0,intG)%>" onChange="goGroupSelect(this.value,'<%=arrGroup(0,intG)%>');">
						<%=vGroupOption%>
					</select>
				</div>
				<%'//상품도 묶인 그룹으로 노출%>
				<%
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

						Response.write "<div class=""list""><ul>"
						For intI =0 To iTotCnt

						'Response.write cEventItem.FCategoryPrdList(intI).FDesignerComment
				%>
							<% If isApp="1" Then %>
								<li onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %><%=logparam%>&flag=e');return false;" class="<%=chkiif(cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut,"soldOut","")%>">
							<% Else %>
								<li onclick="location.href='/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %><%=logparam%>&flag=e';" class="<%=chkiif(cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut,"soldOut","")%>">
							<% End If %>
									<div class="pPhoto">
										<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %><p><span><em>품절</em></span></p><% End if %>
										<% if (eItemListType = "1") or (eItemListType = "2") then %>
											<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
										<% else %>
											<img src="<%=chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false")) %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
										<% end if %>
									<div class="pdtCont">
										<p class="numbering"><span><% = intI+1 %></span></p>
										<p class="pName">
											<%
												If Trim(cEventItem.FCategoryPrdList(intI).FDesignerComment)<>"" Then
													Response.write Replace(Replace(Replace(Replace(Replace(Trim(cEventItem.FCategoryPrdList(intI).FDesignerComment), "●",""), "◆", ""), "▲", ""), "■", ""), "♠", "")
												Else
													Response.write cEventItem.FCategoryPrdList(intI).FItemName
												End If
											%>
										</p>
											<% If InStr(Trim(cEventItem.FCategoryPrdList(intI).FDesignerComment), "●") > 0 Then %>
												<p class="pType type01">단독특가</p>
											<% ElseIf InStr(Trim(cEventItem.FCategoryPrdList(intI).FDesignerComment), "◆") > 0 Then %>
												<p class="pType type02">무료배송</p>
											<% ElseIf InStr(Trim(cEventItem.FCategoryPrdList(intI).FDesignerComment), "▲") > 0 Then %>
												<p class="pType type03">GIFT</p>
											<% ElseIf InStr(Trim(cEventItem.FCategoryPrdList(intI).FDesignerComment), "■") > 0 Then %>
												<p class="pType type04">NEW</p>
											<% ElseIf InStr(Trim(cEventItem.FCategoryPrdList(intI).FDesignerComment), "♠") > 0 Then %>
												<p class="pType type05">SALE</p>
											<% End If %>
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
				<%
						Next
						Response.write "</ul></div>"
						Response.Write "</div>"
					End If
				%>
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

%>

	<%' 배너영역 %>
	<div class="relatedEvt">
		<p class="wide">
			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupEvent('69089');return false;">
			<% Else %>
				<a href="/event/eventmain.asp?eventid=69089">
			<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/bnr_stationery.png" alt="이건, 나만 알고 싶은 STATIONERY" />
			</a>
		</p>
		<p>
			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupEvent('68662');return false;">
			<% Else %>
				<a href="/event/eventmain.asp?eventid=68662">
			<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/bnr_digital_v2.png" alt="선물하기 좋은 디지털" />
			</a>
		</p>
		<p>
			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupEvent('69248');return false;">
			<% Else %>
				<a href="/event/eventmain.asp?eventid=69248">
			<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/bnr_interior_v2.png" alt="공부방 인테리어 노하우" />
			</a>
		</p>
		<p class="wide">
			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupEvent('68993');return false;">
			<% Else %>
				<a href="/event/eventmain.asp?eventid=68993">
			<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/69017/bnr_fashion.png" alt="FRESH UP, Its your time!" />
			</a>
		</p>
	</div>
	<%'// 배너영역 %>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->