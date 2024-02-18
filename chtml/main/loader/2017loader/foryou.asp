<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/foryou/foryouCls.asp" -->
<%
response.charset = "utf-8"
Session.Codepage = 65001
'#######################################################
' Discription : FOR YOU
' History : 2019-05-27 최종원 생성
'              2019-10-21 프로시저 수정, 팝업 배너 제거, 노출 상품 개수 분기처리
'#######################################################

dim foryouObj, userCouponInfoResult, userCouponType, userCouponValue
dim bannerResult, bannerText, i, userid
dim recommenedItems, itemsCnt
dim gaParam

set foryouObj = new ForYouCls

userid = GetLoginUserID()
recommenedItems = foryouObj.getForyouItemList(userid, 5) 

'bannerResult = getForyouBannerInfo(userid)
userCouponInfoResult = getUserCouponInfo(userid)


'if isArray(bannerResult) then
'    for i=0 to ubound(bannerResult,2)
'        bannerText = bannerResult(0, i) 
'    next
'end if

if isArray(userCouponInfoResult) then
    for i=0 to ubound(userCouponInfoResult,2)
        userCouponType = Trim(userCouponInfoResult(0, i))
		userCouponValue = Trim(userCouponInfoResult(1, i))
    next
end if
on Error Resume Next

If isArray(recommenedItems) THEN	
	itemsCnt = ubound(recommenedItems)
	
	select case itemsCnt
		case 5
			itemsCnt = 5			
		case 3,4
			itemsCnt = 3
		case 2,1
			itemsCnt = 1
		case else 	
			itemsCnt = 0
	end select 
	if itemsCnt <> 0 then
%>
			<!-- 190527 for-you -->
			<section class="for-you">
				<div class="hgroup">
					<h2 class="headline headline-speech">
						<span lang="en">FOR YOU</span> 
						<small>좋아하실 것 같아 골라봤어요!</small>
					</h2>										
				</div>		

				<div class="items">
					<div class="tit-area animove">
						<div>
							<span><b><%=GetLoginUserName()%></b>님&nbsp;<br>이런 상품은 어때요?&nbsp;</span>
						</div>
						<% if userCouponType <> "" then %>
							<p><%=GetLoginUserName()%>님을 위해 준비한 시크릿 쿠폰이 있습니다!</p>
						<% else %>	
							<p>당신만을 위한 오늘의 추천</p>
						<% end if %>						
					</div>
					<ul>
					<% 
					dim firstItemDisp : firstItemDisp = "class=""bigger"""
					dim couponPrice, couponPer, tempPrice, salePer, orgPrice, secretCouponTxt
					dim saleStr, couponStr, tmpEvalArr     

					for i=0 to itemsCnt - 1 
					
					orgPrice = recommenedItems(i).Forgprice
					couponPer = foryouObj.GetCouponDiscountStr(recommenedItems(i).Fitemcoupontype, recommenedItems(i).Fitemcouponvalue)
					couponPrice = foryouObj.GetCouponDiscountPrice(recommenedItems(i).Fitemcoupontype, recommenedItems(i).Fitemcouponvalue, recommenedItems(i).Fsellcash)                    					

					IF NOT(recommenedItems(i).Fsellcash = 0 OR recommenedItems(i).Forgprice = 0) THEN    
						salePer     = CLng((recommenedItems(i).Forgprice-recommenedItems(i).Fsellcash)/recommenedItems(i).FOrgPrice*100)										
					else
						salePer = ""        
					END IF					
					gaParam		= "&gaparam=foryou_" & recommenedItems(i).FForyouType & "_" & i + 1 

					if recommenedItems(i).Fsailyn = "Y" and recommenedItems(i).Fitemcouponyn = "Y" then '세일, 쿠폰
						tempPrice = recommenedItems(i).Fsellcash - couponPrice
						saleStr = "<b class=""discount color-red"">"& salePer &"%</b>"
						couponStr = "<b class=""discount"">"&couponPer&"</b>"  						
						orgPrice = "<s>" & FormatNumber(orgPrice, 0) & "</s>"
					elseif recommenedItems(i).Fitemcouponyn = "Y" then    '쿠폰					
						tempPrice = recommenedItems(i).Fsellcash - couponPrice
						saleStr = ""
						couponStr = "<b class=""discount"">"&couponPer&"</b>"  
						orgPrice = "<s>" & FormatNumber(orgPrice, 0) & "</s>"
					elseif recommenedItems(i).Fsailyn = "Y" then  '세일
						tempPrice = recommenedItems(i).Fsellcash
						saleStr = "<b class=""discount color-red"">"& salePer &"%</b>"
						couponStr = ""    
						orgPrice = "<s>" & FormatNumber(orgPrice, 0) & "</s>"
					else										
						tempPrice = orgPrice
						saleStr = ""
						couponStr = ""             					
						orgPrice = ""
					end if			

					if recommenedItems(i).FSecretCouponyn = "Y" then	'시크릿쿠폰						
						couponStr = "시크릿쿠폰 <b class=""discount"">"&couponPer&"</b>"  												
					end if 	

					if recommenedItems(i).Fitemcouponvalue = "0" then
						couponStr = ""
					end if											
					%>					
						<li <%=chkIIF(i = 0, firstItemDisp, "")%>>
						<% if isapp = 1 then %>
							<a href="javascript:fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%=recommenedItems(i).Fitemid & gaParam%>');">
						<% else %>
							<a href="/category/category_itemprd.asp?itemid=<%=recommenedItems(i).Fitemid & gaParam %>">
						<% end if %> 
								<div class="thumbnail"><img src="<%=recommenedItems(i).FBasicimage%>" alt="" /></div>
								<div class="desc">
									<p class="name"><%=recommenedItems(i).Fitemname%></p>									
									<% if saleStr <> "" or couponStr <> "" then %>
									<div class="scr-coupon">										
										<%=saleStr%>
										<%=couponStr%>																				
									</div>
									<% end if %>
									<div class="price">
										<b class="sum"><%=FormatNumber(tempPrice, 0)%><span class="won">원</span></b>										
										<%=orgPrice%>
									</div>
								</div>
							</a>
						</li>					
					<% next %>										
					</ul>
				</div>
			</section>
			<script>
				// 190527 for-you motion
				$(function(){					
					$(window).scroll(function() {
						var st=$(this).scrollTop();
						var taOfs=$('.tit-area').offset().top;
						var calc=taOfs-st*.94
						if(st>taOfs-window.innerHeight&& taOfs+$('.tit-area').innerHeight()>st){
							$('.tit-area>div').css({'transform':'translateY('+calc*.3+'%)'});
							$('.tit-area>p').css({'transform':'translateY('+calc+'%)'});
						}
					})		
				})		
			</script>
		<% if false then %>
			<script>
				// 190527 for-you toast banner
				$(function(){
					$(".bnr-foryou").addClass("evt-toast2");
					function bnrAni() {			
						if(!$(".bnr-foryou").hasClass("evt-toast2")){							
							$(".bnr-foryou").addClass("evt-toast2");
							setTimeout(function(){$(".bnr-foryou").removeClass("evt-toast2");}, 6200);
						}
					}
					bnrAni();
				});
				function linkToforYou(){
					<% if isapp = 1 then %>
						fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], 'FOR YOU', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/foryou/index.asp'); return false;
					<% else %>
						location.href="/my10x10/foryou/";
					<% end if %>					
				}
			</script>
			<!-- 190527 for-you toast banner -->
			<div class="bnr-foryou" onclick="linkToforYou();">
				<ul>
				<% 
				   for i=0 to ubound(recommenedItems) - 1  
				%>
					<li><span><img src="<%=recommenedItems(i).FBasicimage%>" alt=""></span></li>					
				<% next %>	
				</ul>
				<dl>
					<dt><%=GetLoginUserName()%>님을 위해 준비한 <b>시크릿쿠폰</b>이 있습니다!</dt>
					<dd><%=bannerText%></dd>
				</dl>	
			</div>	
		<% end if %>					
<%	
	end if
End If 
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->