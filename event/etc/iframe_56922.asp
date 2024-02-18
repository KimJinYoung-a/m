<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  크리스마스 이벤트(Tab02)M
' History : 2014.11.27 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim datecouponval
IF application("Svr_Info") = "Dev" THEN
	eCode = "21372"
	datecouponval = "3212"
Else
	eCode = "57044"
	datecouponval = "9822"
End If

dim userid, vUserID
	vUserID = GetLoginUserID()
	userid = vUserID
	
dim eCode
dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, eName, esdate, eedate, estate, eregdate, epdate, bimg, eItemListType
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply, edispcate
dim etemplate, emimg, ehtml, eitemsort, ebrand,gimg,blnFull,blnItemifno,blnitempriceyn, LinkEvtCode, blnBlogURL
dim itemid : itemid = ""
dim egCode, itemlimitcnt,iTotCnt
dim cdl_e, cdm_e, cds_e
dim com_egCode : com_egCode = 0
Dim emimgAlt , bimgAlt, isMyFavEvent, clsEvt
Dim j

egCode = requestCheckVar(Request("eGC"),10)	'이벤트 그룹코드
IF egCode = "" THEN egCode = 0
	
if isApp=1 then
	itemlimitcnt = 10	'상품최대갯수
else
	itemlimitcnt = 105	'상품최대갯수
end if
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
		etemplate	= cEvent.FTemplate 	
		emimg		= cEvent.FEMimg 		
		ehtml		= cEvent.FEHtml 		
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
		
		IF etemplate = "3" THEN	'그룹형(etemplate = "3")일때만 그룹내용 가져오기		
		cEvent.FEGCode = 	egCode		
		arrGroup =  cEvent.fnGetEventGroup					
		END IF
		
		cEvent.FECategory  = ecategory
		'arrRecent = cEvent.fnGetRecentEvt
	set cEvent = nothing
%>
<!-- #include virtual="lib/inc/head.asp" -->
<style type="text/css">
.xmasNight {background-color:#f5f5f5;}
.xmasNight img {width:100%; vertical-align:top;}
.xmasNight .hgroup {position:relative;}
.xmasNight .deco {position:absolute; top:0; left:0; width:100%;}
.find-presentbox {position:relative;}
.presentbox {position:absolute; top:25.8%; left:0.5%; width:25%; padding-bottom:20%;}
.presentbox a, .presentbox span {display:block; position:absolute; width:100%; height:100%; background-repeat:no-repeat; background-position:50% 50%; background-size:100% auto; text-indent:-999em;}
.presentbox a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_present_night_off.png);}
.presentbox span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_present_night_on.png);}
/*present box layer popop*/
#lyPresent {display:none; position:absolute; top:0; left:50% !important; z-index:210; width:84%; margin-left:-42%; border:5px solid #b3915c; background-color:#fff;}
.lyPresent {position:relative;}
.lyPresent .close {position:absolute; top:0; right:0; width:30px; height:30px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_close.gif) no-repeat 50% 50%; text-indent:-999em; background-size:10px 10px;}
.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.65);}
@media all and (min-width:480px){
	.lyPresent .close {width:45px; height:45px; background-size:15px 15px;}
}
.animated {-webkit-animation-duration:2s; animation-duration:2s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* FadeIn animation */
@-webkit-keyframes fadeIn {
	0% {opacity:0;}
	50% {opacity:0.5;}
	100% {opacity:1;}
}
@keyframes fadeIn {
	0% {opacity:0;}
	50% {opacity:0.5;}
	100% {opacity:1;}
}
.fadeIn {-webkit-animation-name: fadeIn; animation-name: fadeIn; -webkit-animation-iteration-count:5; animation-iteration-count:5;}
</style>
<script type="text/javascript">
	$(function() {
//		$(".presentbox a").click(function(){
//			$("#lyPresent").show();
//			$(".mask").show();
//			return false;
//		});

		$(".lyPresent .close").click(function(){
			$("#lyPresent").hide();
			$(".mask").hide();
		});

		$(".mask").click(function(){
			$("#lyPresent").hide();
			$(".mask").hide();
		});
	});

<%
	Dim vQuery, vCheck
	
	vQuery = "select count(*) from [db_item].[dbo].tbl_user_item_coupon where itemcouponidx = '" & datecouponval & "' and userid = '" & userid & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vCheck = "2"
	End IF
	rsget.close()
%>

function jsSubmitC() {
	<% If vUserID = "" Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin('<%=IsUserLoginOK%>');
			return false;
		<% end if %>
	<% End If %>

	var str = $.ajax({
		type: "GET",
        url: "/event/etc/nordic_proc.asp",
        data: "ecode=<%=eCode%>&mode=coupon",
        dataType: "text",
        async: false
	}).responseText;
	<% If vUserID <> "" Then %>
		<% If vCheck = "2" then %>
			alert("이미 다운받으셨습니다.");
			$('.presentbox').html("<span id='testDiv'>쿠폰 다운로드 완료!</span>")
		<% Else %>
			if (str.length=='2'){
				if (str=='i1'){
					$('.presentbox').html("<span id='testDiv'>쿠폰 다운로드 완료!</span>")
					$("#lyPresent").show();
					$(".mask").show();
					return;
				}else if (str=='99'){
					alert('로그인을 해주세요.');
					return;
				}else if (str=='i2'){
					alert('이미 다운받으셨습니다.');
					$('.presentbox').html("<span id='testDiv'>쿠폰 다운로드 완료!</span>")
					return;
				}else if (str=='i3'){
					alert('잘못된 접근입니다.');
					return;
				}else if (str=='i4'){
					alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
					return;
				}
			}else{
				alert('정상적인 경로가 아닙니다.');
				return;
			}
	   <% End If %>
	<% End If %>
}

function goGroupSelect(v,a){
	window.parent.$('html, body').animate({
	    scrollTop: $("#group"+v+"").offset().top
	}, 300)

	window.parent.$("#group"+a+" > option[value="+a+"]").attr("selected", "true");
}
</script>
</head>
<body>
<!-- 이벤트 배너 등록 영역 -->
<div class="evtCont evtView">
	<!-- NORDIC PARTY TABLE -->
	<div class="xmasNight">
		<div class="hgroup">
			<span class="deco animated fadeIn"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_deco_night.png" alt="" /></span>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/txt_christmas_night.gif" alt="침대 옆 로맨틱한 크리스마스 공간을 만들어 보세요" /></p>
		</div>

		<div class="find-presentbox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/txt_find_presentbox.gif" alt="공간에 숨겨진 크리스마스 선물을 찾아보세요" /></p>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_night.jpg" alt="" /></div>

			<!-- for dev msg : 선물박스 찾기 -->
			<div class="presentbox">
				<% If vCheck <> "2" Then %>
					<a href="" onclick="jsSubmitC(); return false;">크리스마스 쿠폰</a>
				<% Else %>
					<span id="testDiv" >쿠폰 다운로드 완료!</span>
				<% End if %>
			</div>

			<div id="lyPresent">
				<div class="lyPresent window">
					<div class="present">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/txt_merry_christmas.gif" alt="메리크리스마스" /></p>
						<div class="coupon"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_xmas_coupon_02.gif" alt="새해 인테리어 변신을 위한 리빙브랜드 20% 할인" /></div>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/txt_coupon_guide.gif" alt="크리스마스 스페셜 쿠폰이 발급 되었습니다 4개의 북유럽 공간에 숨겨진 크리스마스 선물박스를 모두 찾아보세요. 여러분을 위한 4가지 특별한 크리스마스 쿠폰이 숨겨져 있어요." /></p>
						<!-- for dev msg : 혜택 페이지로 링크 -->
						<% if isApp=1 then %>
							<div class="btn-go"><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56928" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_go_benefit01.gif" alt="크리스마스 혜택 보고 이벤트 응모하러 가기" /></a></div>
						<% else %>
							<div class="btn-go"><a href="/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56928" %>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_go_benefit01.gif" alt="크리스마스 혜택 보고 이벤트 응모하러 가기" /></a></div>
						<% end if %>
						<button type="button" class="close">닫기</button>
					</div>
				</div>
			</div>
		</div>
		<div class="evtCont">
		<%
			IF (datediff("d",eedate,date()) >0) OR (estate =9) THEN
				Response.Write "<div class=""finishEvt""><p>죄송합니다.<br />종료된 이벤트 입니다.</p></div>"
			END IF
			
			If arrGroup(0,0) <> "" Then	
				if arrGroup(3,0) <> "" then
		%>
				<div><img src="<%=arrGroup(3,0)%>" alt="<%=egCode%>" /></div>
		<%		End If %>
				<map name="mapGroup<%=egCode%>"><%=db2html(arrGroup(4,0))%></map>
		<%	End If %>
		</div>
		<% egCode = arrGroup(0,0) %>
		<% if blncomment then %>
		<div class="btnComment">
			<span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
		</div>
		<% end if %>
		<% sbEvtItemView %>

		<%
		Dim iEndCnt, intJ
		
		Dim vGroupOption
		If isArray(arrGroup) THEN
			For intG = 1 To UBound(arrGroup,2)
				vGroupOption = vGroupOption & "<option value="""&arrGroup(0,intG)&""">" & db2html(arrGroup(1,intG)) & "</option>"
			Next
			
			For intG = 1 To UBound(arrGroup,2)
				egCode = arrGroup(0,intG)
		%>
				<div class="inner10">
				<select class="groupBar" id="group<%=arrGroup(0,intG)%>" onChange="goGroupSelect(this.value,'<%=arrGroup(0,intG)%>');">
					<%=vGroupOption%>
				</select>
				</div>

				<% if isApp=1 then %>
					<%
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
										<div class="pdtListWrap">
											<ul class="pdtList">
								<% End If %>
												<li onclick="parent.fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %>');">
													<div class="pPhoto">
														<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Then %><p><span><em>품절</em></span></p><% End if %>
														<img src="<% = cEventItem.FCategoryPrdList(intI).FImageBasic %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
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
					%>
				<% else %>
					<%
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
										<div class="pdtListWrap">
											<ul class="pdtList">
								<% End If %>
												<li onclick="parent.location.href='/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&flag=e';">
													<div class="pPhoto">
														<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Then %><p><span><em>품절</em></span></p><% End if %>
														<img src="<% = cEventItem.FCategoryPrdList(intI).FImageBasic %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
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
					%>
				<% end if %>

				<script>$("#group<%=arrGroup(0,intG)%> > option[value=<%=arrGroup(0,intG)%>]").attr("selected", "true");</script>
		<%
			Next
		Else
			Call sbEvtItemView
		End If
		%>
	</div>
</div>
<!--// 이벤트 배너 등록 영역 -->
<div class="mask"></div>
<form name="frmGubun2" method="post" action="nordic_proc.asp" style="margin:0px;" target="evtFrmProc">
<input type="hidden" name="mode" value="">
<input type="hidden" name="ecode" value="">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->