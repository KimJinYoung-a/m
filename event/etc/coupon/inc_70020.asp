<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 꽃샘 쿠폰
' History : 2016-04-06 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid , strSql
Dim getbonuscoupon1 , getlimitcnt1, currenttime
Dim totcnt1

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66099"
	Else
		eCode = "70020"
	End If

	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon1 = "2781"
	Else
		getbonuscoupon1 = "844"
	End If

	userid = getEncLoginUserID()
	getlimitcnt1 = 30000		'30000
	currenttime = now()

dim bonuscouponcount1, subscriptcount, totalsubscriptcount1, totalbonuscouponcount1, totalbonuscouponcountusingy

bonuscouponcount1=0
subscriptcount=0
totalsubscriptcount1=0
totalbonuscouponcount1=0


'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	bonuscouponcount1 = getbonuscouponexistscount(userid, getbonuscoupon1, "", "", "")
end if

'//전체 참여수
totalsubscriptcount1 = getevent_subscripttotalcount(eCode, "", "", "")
'//전체 쿠폰 발행수량
totalbonuscouponcount1 = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")
totalbonuscouponcountusingy = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")


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
	itemlimitcnt = 40	'상품최대갯수
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
		
'		IF etemplate = "3" THEN	'그룹형(etemplate = "3")일때만 그룹내용 가져오기		
		cEvent.FEGCode = 	egCode		
		arrGroup =  cEvent.fnGetEventGroup					
'		END IF
		
		cEvent.FECategory  = ecategory
		'arrRecent = cEvent.fnGetRecentEvt
	set cEvent = nothing
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.floweringCoupon {overflow:hidden;}

.btnCoupon {position:relative;}
.btnCoupon button {width:100%; background-color:transparent; vertical-align:top;}
.btnCoupon .close {position:absolute; top:-15%; left:-1.5%; width:26.56%;}
.btnCoupon .close {animation-name:bounce; animation-iteration-count:5; animation-duration:0.8s;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:5px; animation-timing-function:ease-in;}
}

.btnCoupon .soldout {position:absolute; top:0; left:0; width:100%;}

.noti {background-color:#f1f3e8;}
.noti ul {padding:0 4.53% 8%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#7a7a7a; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#abc73e;}
</style>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".sproutCoupon .app").show();
			$(".sproutCoupon .mo").hide();
	}else{
			$(".sproutCoupon .app").hide();
			$(".sproutCoupon .mo").show();
	}
});

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10) >= "2016-04-10" and left(currenttime,10) < "2016-04-13") Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if totalsubscriptcount1>=getlimitcnt1 or totalbonuscouponcount1>=getlimitcnt1 then %>
				alert("죄송합니다. 쿠폰이 모두 소진 되었습니다.");
				return;
			<% else %>
				frm.action="/event/etc/doeventsubscript/doEventSubscript70020.asp";
				frm.target="evtFrmProc";
				frm.mode.value='coupon';
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

function goGroupSelect(v,a){
	window.parent.$('html, body').animate({
	    scrollTop: $("#group"+v+"").offset().top
	}, 300)

	window.parent.$("#group"+a+" > option[value="+a+"]").attr("selected", "true");
}
</script>
<% If userid = "cogusdk" Or userid = "greenteenz" Or userid = "baboytw" Then %>
<div>
	<p>&lt;<%= getbonuscoupon1 %>&gt; 쿠폰 발급건수 : <%= totalbonuscouponcount1 %> 사용건수 : <%= totalbonuscouponcountusingy %> </p>
</div>
<% End If %>
	<div class="mEvt70020 floweringCoupon">
		<article>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/70020/m/tit_coupon.png" alt="꽃샘쿠폰 이른 봄, 꽃들도 샘내는 아름다운 할인쿠폰이 찾아왔습니다!" /></h2>

			<div class="btnCoupon">
				<button type="button" onclick="jseventSubmit(evtFrm1);return false;" title="만원 쿠폰 다운 받기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70020/m/btn_coupon.png" alt="6만원 이상 구매시, 4월 11, 22일 사용 가능" /></button>
				<% if totalsubscriptcount1>=getlimitcnt1 or totalbonuscouponcount1>=getlimitcnt1 then %>
					<%'' for dev msg : 쿠폰 모두 소진 시 %>
					<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70020/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다. 다음 기회에 이용해주세요" /></p>
				<% else %>
					<% if ((getlimitcnt1 - totalsubscriptcount1) < 10000) or ((getlimitcnt1 - totalbonuscouponcount1) < 10000) then %>
						<%'' for dev msg : 쿠폰이 ** 남아있을때 보여주세요 %>
						<strong class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70020/m/ico_close.png" alt="마감임박" /></strong>
					<% end if %>
				<% end if %>


			</div>

			<div class="appdownJoin">
				<% if not(isApp=1) then %>
					<%'' for dev msg : 모바일웹에서만 보여주세요 / 앱에서는 숨겨주세요 %>
					<p><a href="/event/appdown/"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70020/m/btn_app.png" alt="텐바이텐 앱 설치 아직이신가요? 텐바이텐 앱 다운" /></a></p>
				<% end if %>
				<% If userid = "" Then %>
					<% if isApp=1 then %>
						<%'' for dev msg : 로그인시 숨겨주세요 (비로그인시에만 보여주세요) %>
						<p><a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70020/m/btn_join.png" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기!" /></a></p>
					<% else %>
						<p><a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70020/m/btn_join.png" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기!" /></a></p>
					<% end if %>
				<% End If %>
			</div>

			<div class="noti">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/70020/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
				<ul>
					<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
					<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
					<li>쿠폰은 04/12(화) 23시 59분 종료됩니다.</li>
					<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
					<li>이벤트는 조기 마감 될 수 있습니다.</li>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70020/m/img_ex.png" alt="주문결제 화면에서 할인정보에서 보너스 쿠폰 선택 상자에서 꽃쌤쿠폰을 선택해주세요" /></p>
			</div>
		</article>



	

		<%
			IF (datediff("d",eedate,date()) >0) OR (estate =9) THEN
				Response.Write "<div class=""finishEvt""><p>죄송합니다.<br />종료된 이벤트 입니다.</p></div>"
			END IF
		IF isArray(arrGroup) THEN
			If arrGroup(0,0) <> "" Then	
				if arrGroup(3,0) <> "" then
		%>
					<div><img src="<%=arrGroup(3,0)%>" alt="<%=egCode%>" /></div>
		<%		End If %>
				<map name="mapGroup<%=egCode%>"><%=db2html(arrGroup(4,0))%></map>
		<%	End If %>

		</div>
		<% egCode = arrGroup(0,0) %>
		<% end if %>
		<% if blncomment then %>
		<div class="btnComment">
			<span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
		</div>
		<% end if %>
		<div class="evtPdtListWrapV15">
		<div class="evtPdtListV15" id="topitem">
		<% sbEvtItemView %>
		

		<%
		Dim iEndCnt, intJ
		
		Dim vGroupOption
		If isArray(arrGroup) THEN
			For intG = 1 To UBound(arrGroup,2)
				vGroupOption = vGroupOption & "<option class=""g"&arrGroup(0,intG)&""" value="""&arrGroup(0,intG)&""">" & db2html(arrGroup(1,intG)) & "</option>"
			Next
			
			For intG = 1 To UBound(arrGroup,2)
				egCode = arrGroup(0,intG)
		%>

				<div class="groupBarV15">
					<select id="group<%=arrGroup(0,intG)%>" onChange="goGroupSelect(this.value,'<%=arrGroup(0,intG)%>');">
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
				<!--</div>-->
		<%
			Next
		Else
			Call sbEvtItemView
		End If
		%>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0 style="display:none;"></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->