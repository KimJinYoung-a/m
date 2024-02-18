<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  TURN ON YOUR CHRISTMAS (크리스마스 기획전 메인페이지)
' History : 2016.11.17 김진영
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/event/etc/event74315Cls.asp" -->
<%
Dim oItem, sunseo, currdate, i, moveevtCode, mktevtCode, bnrImg
currdate = Date()

Select Case currdate
	Case "2016-11-17", "2016-11-18", "2016-11-19", "2016-11-20", "2016-11-21"		sunseo = "1"
	Case "2016-11-22"		sunseo = "2"
	Case "2016-11-23"		sunseo = "3"
	Case "2016-11-24"		sunseo = "4"
	Case "2016-11-25"		sunseo = "5"
	Case "2016-11-26"		sunseo = "6"
	Case "2016-11-27"		sunseo = "7"

	Case "2016-11-28"		sunseo = "8"
	Case "2016-11-29"		sunseo = "9"
	Case "2016-11-30"		sunseo = "10"
	Case "2016-12-01"		sunseo = "11"
	Case "2016-12-02"		sunseo = "12"
	Case "2016-12-03"		sunseo = "13"
	Case "2016-12-04"		sunseo = "14"

	Case "2016-12-05"		sunseo = "15"
	Case "2016-12-06"		sunseo = "16"
	Case "2016-12-07"		sunseo = "17"
	Case "2016-12-08"		sunseo = "18"
	Case "2016-12-09"		sunseo = "19"
	Case "2016-12-10"		sunseo = "20"
	Case "2016-12-11"		sunseo = "21"

	Case "2016-12-12"		sunseo = "22"
	Case "2016-12-13"		sunseo = "23"
	Case "2016-12-14"		sunseo = "24"
	Case "2016-12-15"		sunseo = "25"
	Case "2016-12-16"		sunseo = "26"
	Case "2016-12-17"		sunseo = "27"
	Case "2016-12-18"		sunseo = "28"

	Case "2016-12-19"		sunseo = "29"
	Case "2016-12-20"		sunseo = "30"
	Case "2016-12-21"		sunseo = "31"
	Case "2016-12-22"		sunseo = "32"
	Case "2016-12-23"		sunseo = "33"
	Case Else				sunseo = "33"
End Select

If sunseo <= 7 Then
	moveevtCode = "74325"
ElseIf sunseo >= 8 and sunseo <= 14 Then
	moveevtCode = "74326"
ElseIf sunseo >= 15 and sunseo <= 21 Then
	moveevtCode = "74327"
ElseIf sunseo >= 22 and sunseo <= 28 Then
	moveevtCode = "74328"
ElseIf sunseo >= 29 Then
	moveevtCode = "74329"
End If

If currdate <= "2016-12-18" Then
	mktevtCode = "74319"
	bnrImg = "<img src='http://webimage.10x10.co.kr/eventIMG/2016/74315/m/img_bnr_mk_01.gif' alt='크리스마스에 꼭 사고 싶은 선물을 위시리스트에 담으면 기프트카드 5만원 권의 행운이! 이벤트 참여하러 가기' />"
Else
	mktevtCode = "74320"
	bnrImg = "<img src='http://webimage.10x10.co.kr/eventIMG/2016/74315/m/img_bnr_mk_02.gif' alt='Enjoy with 텐바이텐 이벤트 매일 낮 12시 선착순 500명에게만 산타의 마일리지 증정 이벤트 참여하러 가기' />"
End If
%>
<style type="text/css">
img {vertical-align:top;}

.christmas .desc > span {display:block;}
.christmas .name {overflow:hidden; text-overflow:ellipsis; white-space:nowrap;}

.christmas .rolling {background-color:#434444;}
.christmas .rolling .swiper-container .swiper-wrapper .swiper-slide {width:61.56%; padding-top:8%; text-align:center;}
.christmas .rolling .swiper-container .swiper-wrapper .swiper-slide .figure {padding:3%; border-radius:50%; background-color:#fff; box-shadow:0.1rem 0.7rem 6.4rem -1rem rgba(255, 255, 255, 0.1);}
.christmas .rolling .swiper-container .swiper-wrapper .swiper-slide .figure img {border-radius:50%;}
.christmas .swiper .pagination {height:auto; padding:0; margin-top:1.5rem;}
.christmas .swiper .pagination .swiper-pagination-switch {width:0.9rem; height:0.25rem; margin:0 0.25rem; border-radius:0; background-color:#565757; transition:all 0.5s;}
.christmas .swiper .pagination .swiper-active-switch {background-color:#fff;}

.christmas .rolling a {display:block; position:relative; color:#fff;}
.christmas .rolling a em {position:absolute; top:0; right:0; width:29.18%;}
.christmas .rolling .desc {margin-top:1.2rem;}
.christmas .rolling .name {height:1.4rem; font-size:1.3rem;}
.christmas .rolling .price {margin-top:0.5rem;}
.christmas .rolling .price s {color:rgba(255, 255, 255, 0.45);}
.christmas .rolling .price b {color:#ff5858; font-size:1.4rem; font-weight:bold;}
.christmas .rolling .cRd1 {color:#ff5858 !important;}

.christmas .btnMore {width:52.96%; margin:2.4rem auto 0;}

.christmas .bnr {background-color:#fff;}
.christmas .bnr ul {overflow:hidden;}
.christmas .bnr ul li {padding:0.6% 0;}
.christmas .bnr ul li:first-child {padding:0;}
.christmas .bnr ul li:nth-child(2),
.christmas .bnr ul li:nth-child(3) {float:left; width:50%;}
.christmas .bnr ul li:nth-child(2) a,
.christmas .bnr ul li:nth-child(3) a {display:block;}
.christmas .bnr ul li:nth-child(2) a {padding-right:0.8%;}
.christmas .bnr ul li:nth-child(3) a {padding-left:0.8%;}
.christmas .bnr ul li:last-child {padding-bottom:0.4%;}

.christmas .itemWrap {padding-bottom:18%; background-color:#434444;}
.christmas .item ul {overflow:hidden; padding:0 1%;}
.christmas .item ul li {float:left; width:50%; padding:0 1.1%; margin-top:2.2%;}
.christmas .item ul li:first-child {width:100%; margin-top:0;}
.christmas .item ul li a {display:block; background-color:#fff; text-align:center; color:#222; font-size:1.1rem;}
.christmas .item ul li .desc {padding:1.2rem 1rem 1.3rem;}
.christmas .item ul li .desc > span {display:block;}
.christmas .item ul li .name {padding-top:0.1rem; font-weight:bold;}
.christmas .item ul li .price {margin-top:0.3rem;}
</style>
<script type="text/javascript">
$(function(){
	itemSwiper = new Swiper('#rolling .swiper-container',{
		speed:800,
		slidesPerView:"auto",
		centeredSlides:true,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		spaceBetween:"7%"
	});
});
</script>
<div class="mEvt74315 christmas">
	<div id="rolling" class="rolling">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/txt_christmas.jpg" alt="2016 빛나는 당신의 잊지 못할 크리스마스를 위하여!" /></p>
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
			<%
				Set oItem = new CatePrdCls
					oItem.get74315RollingItemList sunseo
					For i = 0 to oItem.FResultcount - 1
			%>
					<div class="swiper-slide">
					<% If isApp = 1 Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= oItem.FItemList(i).FItemid %>&amp;pEtr=74315'); return false;">
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=<%= oItem.FItemList(i).FItemid %>&pEtr=74315">
					<% End If %>
					<%' for dev msg : 단독상품일 경우 %>
						<% If oItem.FItemList(i).FtenOnlyYn = "Y" Then %>
							<em><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/ico_tag_special_price.png" alt="단독특가" /></em>
						<% Else %>
							<em><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/ico_tag_special_item.png" alt="단독상품" /></em>
						<% End If %>
							<div class="figure"><img src="<%= oItem.FItemList(i).FImageBasic %>" alt="" /></div>
							<div class="desc">
								<span class="name"><%= oItem.FItemList(i).FItemname %></span>
								<span class="price">
									<% IF (oItem.FItemList(i).FSaleYn="Y") and (oItem.FItemList(i).FOrgPrice-oItem.FItemList(i).FSellCash>0) THEN %>
										<s><%= FormatNumber(oItem.FItemList(i).getOrgPrice,0) %>원</s> <b><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %> <i class="cRd1">[<%= Format00(2, CLng((oItem.FItemList(i).FOrgPrice-oItem.FItemList(i).FSellCash)/oItem.FItemList(i).FOrgPrice*100) ) %>%]</i></b>
									<% ElseIf (oItem.FItemList(i).FItemCouponYN="Y") Then %>
										<s><%= FormatNumber(oItem.FItemList(i).getOrgPrice,0) %>원</s> <b><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %> <i class="cGr1"><%= oItem.FItemList(i).GetCouponDiscountStr %></i></b>
									<% Else %>
										<b><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %></b>
									<% End If %>
								</span>
							</div>
						</a>
					</div>
			<%
					Next
				Set oItem = nothing
			%>
				</div>
			</div>
			<div class="pagination"></div>
		</div>

		<div class="btnMore">
			<%' for dev msg :  1주 74325, 2주 74326, 3주 74327, 4주 74328, 5주 74329 %>
		<% If isApp = 1 Then %>
			<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= moveevtCode %>" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/btn_more.png" alt="더 많은 상품 보러가기" /></a>
		<% Else %>
			<a href="/event/eventmain.asp?eventid=<%= moveevtCode %>"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/btn_more.png" alt="더 많은 상품 보러가기" /></a>
		<% End If %>
		</div>
	</div>

	<div class="bnr">
		<ul>
			<%' for dev msg : 산타의 위시 74319, 산타의 선물 74320 %>
		<% If isApp = 1 Then %>
			<li><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=mktevtCode%>" target="_blank"><%=bnrImg%></a></li>
		<% Else %>
			<li><a href="/event/eventmain.asp?eventid=<%=mktevtCode%>"><%=bnrImg%></a></li>
		<% End If %>
		
		<% If isApp = 1 Then %>
			<li><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=74317" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/img_bnr_md_01.jpg" alt="NORDIC WHITE 기획전 보러가기" /></a></li>
		<% Else %>
			<li><a href="/event/eventmain.asp?eventid=74317"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/img_bnr_md_01.jpg" alt="NORDIC WHITE 기획전 보러가기" /></a></li>
		<% End If %>
		
		<% If isApp = 1 Then %>
			<li><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=74318" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/img_bnr_md_02.jpg" alt="SWEET PASTER 기획전 보러가기" /></a></li>
		<% Else %>
			<li><a href="/event/eventmain.asp?eventid=74318"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/img_bnr_md_02.jpg" alt="SWEET PASTER 기획전 보러가기" /></a></li>
		<% End If %>

		<% If isApp = 1 Then %>
			<li><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=74316" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/img_bnr_md_03.jpg" alt="CHAMPAGNE GOLD 기획전 보러가기" /></a></li>
		<% Else %>
			<li><a href="/event/eventmain.asp?eventid=74316"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/img_bnr_md_03.jpg" alt="CHAMPAGNE GOLD 기획전 보러가기" /></a></li>
		<% End If %>
		</ul>
	</div>
	<%' item %>
	<div class="itemWrap">
		<%' living room %>
		<div class="item">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/tit_item_living_room.png" alt="Living room" /></h3>
			<ul>
			<%' for dev msg : 상품 25개씩 뿌려주세요 %>
			<%
				Set oItem = new CatePrdCls
					oItem.get74315UnderItemList "livingroom"
					For i = 0 to oItem.FResultcount - 1
			%>
				<li>
				<% If isApp = 1 Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= oItem.FItemList(i).FItemid %>&amp;pEtr=74315'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=<%= oItem.FItemList(i).FItemid %>&pEtr=74315">
				<% End If %>
						<%' or dev msg : 이미지 alt값은 상품명 있으니 빈값으로 해주세요 alt="" %>
						<div class="figure">
						<% If oItem.FItemList(i).ForderMinNum = "1" Then  %>
							<img src="<%= oItem.FItemList(i).FImageBasic %>" alt="" />
						<% Else %>
							<img src="<%= getThumbImgFromURL(oItem.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="" />
						<% End If %>
						</div>
						<div class="desc">
							<span class="name"><%= oItem.FItemList(i).FItemname %></span>
						<%'  for dev msg : 최종 가격과 할인률만 보여주세요 %>
						<% IF (oItem.FItemList(i).FSaleYn="Y") and (oItem.FItemList(i).FOrgPrice-oItem.FItemList(i).FSellCash>0) THEN %>
							<span class="price"><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %> <i class="cRd1">[<%= Format00(2, CLng((oItem.FItemList(i).FOrgPrice-oItem.FItemList(i).FSellCash)/oItem.FItemList(i).FOrgPrice*100) ) %>%]</i></span>
						<% ElseIf (oItem.FItemList(i).FItemCouponYN="Y") Then %>
							<span class="price"><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %> <i class="cGr1">[<%= oItem.FItemList(i).GetCouponDiscountStr %>]</i></span>
						<% Else %>
							<span class="price"><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %></span>
						<% End If %>
						</div>
					</a>
				</li>
			<%
					Next
				Set oItem = nothing
			%>
			</ul>
		</div>

		<%' bed room %>
		<div class="item">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/tit_item_bed_room.png" alt="Bed room" /></h3>
			<ul>
			<%
				Set oItem = new CatePrdCls
					oItem.get74315UnderItemList "bedroom"
					For i = 0 to oItem.FResultcount - 1
			%>
				<li>
				<% If isApp = 1 Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= oItem.FItemList(i).FItemid %>&amp;pEtr=74315'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=<%= oItem.FItemList(i).FItemid %>&pEtr=74315">
				<% End If %>
						<div class="figure">
						<% If oItem.FItemList(i).ForderMinNum = "1" Then  %>
							<img src="<%= oItem.FItemList(i).FImageBasic %>" alt="" />
						<% Else %>
							<img src="<%= getThumbImgFromURL(oItem.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="" />
						<% End If %>
						</div>
						<div class="desc">
							<span class="name"><%= oItem.FItemList(i).FItemname %></span>
						<% IF (oItem.FItemList(i).FSaleYn="Y") and (oItem.FItemList(i).FOrgPrice-oItem.FItemList(i).FSellCash>0) THEN %>
							<span class="price"><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %> <i class="cRd1">[<%= Format00(2, CLng((oItem.FItemList(i).FOrgPrice-oItem.FItemList(i).FSellCash)/oItem.FItemList(i).FOrgPrice*100) ) %>%]</i></span>
						<% ElseIf (oItem.FItemList(i).FItemCouponYN="Y") Then %>
							<span class="price"><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %> <i class="cGr1">[<%= oItem.FItemList(i).GetCouponDiscountStr %>]</i></span>
						<% Else %>
							<span class="price"><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %></span>
						<% End If %>
						</div>
					</a>
				</li>
			<%
					Next
				Set oItem = nothing
			%>
			</ul>
		</div>

		<%' kitchen %>
		<div class="item">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74315/m/tit_item_kitchen.png" alt="Kitchen" /></h3>
			<ul>
			<%
				Set oItem = new CatePrdCls
					oItem.get74315UnderItemList "kitchen"
					For i = 0 to oItem.FResultcount - 1
			%>
				<li>
				<% If isApp = 1 Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= oItem.FItemList(i).FItemid %>&amp;pEtr=74315'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=<%= oItem.FItemList(i).FItemid %>&pEtr=74315">
				<% End If %>
						<div class="figure">
						<% If oItem.FItemList(i).ForderMinNum = "1" Then  %>
							<img src="<%= oItem.FItemList(i).FImageBasic %>" alt="" />
						<% Else %>
							<img src="<%= getThumbImgFromURL(oItem.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="" />
						<% End If %>
						</div>
						<div class="desc">
							<span class="name"><%= oItem.FItemList(i).FItemname %></span>
						<% IF (oItem.FItemList(i).FSaleYn="Y") and (oItem.FItemList(i).FOrgPrice-oItem.FItemList(i).FSellCash>0) THEN %>
							<span class="price"><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %> <i class="cRd1">[<%= Format00(2, CLng((oItem.FItemList(i).FOrgPrice-oItem.FItemList(i).FSellCash)/oItem.FItemList(i).FOrgPrice*100) ) %>%]</i></span>
						<% ElseIf (oItem.FItemList(i).FItemCouponYN="Y") Then %>
							<span class="price"><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %> <i class="cGr1">[<%= oItem.FItemList(i).GetCouponDiscountStr %>]</i></span>
						<% Else %>
							<span class="price"><%= FormatNumber(oItem.FItemList(i).FSellCash,0) & "원" %></span>
						<% End If %>
						</div>
					</a>
				</li>
			<%
					Next
				Set oItem = nothing
			%>
			</ul>
		</div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->