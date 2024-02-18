<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
Session.Codepage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : mobile_main_banner // cache DB경유
' History : 2016-04-27 이종화 생성
'#######################################################
Dim poscode , intI ,intJ , i
Dim sqlStr , rsMem , arrList
Dim gaParam : gaParam = "&gaparam=fashion_review0" '//GA 체크 변수
Dim CtrlDate : CtrlDate = now()


'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MBIMG_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "MBIMG"
End If

sqlStr = "[db_sitemaster].[dbo].[usp_Ten_FashionBestReview_Data_Get]"
'Response.write sqlStr

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
intJ = 0
If IsArray(arrList) Then
%>
<div class="fashion-review">
	<h2><small>Review Best</small>후기가 증명하는 아이템!</h2>
	<div class="items type-list tenten-best-default tenten-best-new tenten-best-review">
		<ul>
<%
	Dim disp , itemid , makerid , brandname , basicimage , itemname , sellcash , sailyn , orgprice , couponYn , coupontype , couponvalue , evauserid , evacontents , evaTotalpoint 
	Dim totalprice , totalsale , totalcoupon
	'// 추가 이미지
	dim oADD

	For intI = 0 To ubound(arrlist,2)
		disp			= arrlist(0,intI)
		itemid			= arrlist(1,intI)
		makerid			= arrlist(6,intI)
		brandname		= arrlist(7,intI)
		basicimage		= "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(itemid) & "/" & arrlist(11,intI)
		itemname		= arrlist(15,intI)
		sellcash		= arrlist(16,intI)
		sailyn			= arrlist(18,intI)
		orgprice		= arrlist(22,intI)
		couponYn		= arrlist(29,intI)
		coupontype		= arrlist(30,intI)
		couponvalue		= arrlist(31,intI)
		evauserid		= arrlist(36,intI)
		evacontents		= arrlist(37,intI)
		evaTotalpoint	= arrlist(38,intI)

		If sailYN = "N" and couponYn = "N" Then
			totalprice = formatNumber(orgPrice,0)
		End If
		If sailYN = "Y" and couponYn = "N" Then
			totalprice = formatNumber(sellCash,0)
		End If
		if couponYn = "Y" And couponvalue>0 Then
			If coupontype = "1" Then
				totalprice = formatNumber(sellCash - CLng(couponvalue*sellCash/100),0)
			ElseIf coupontype = "2" Then
				totalprice = formatNumber(sellCash - couponvalue,0)
			ElseIf coupontype = "3" Then
				totalprice = formatNumber(sellCash,0)
			Else
				totalprice = formatNumber(sellCash,0)
			End If
		End If
		If sailYN = "Y" And couponYn = "Y" Then
			If coupontype = "1" Then
				'//할인 + %쿠폰
				totalsale = "<b class='discount color-red'>"& CLng((orgPrice-(sellCash - CLng(couponvalue*sellCash/100)))/orgPrice*100)&"%</b>"
			ElseIf coupontype = "2" Then
				'//할인 + 원쿠폰
				totalsale = "<b class='discount color-red'>"& CLng((orgPrice-(sellCash - couponvalue))/orgPrice*100)&"%</b>"
			Else
				'//할인 + 무배쿠폰
				totalsale = "<b class='discount color-red'>"& CLng((orgPrice-sellCash)/orgPrice*100)&"%</b>"
			End If 
		ElseIf sailYN = "Y" and couponYn = "N" Then
			If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
				totalsale = "<b class='discount color-red'>"& CLng((orgPrice-sellCash)/orgPrice*100)&"%</b>"
			End If
		elseif sailYN = "N" And couponYn = "Y" And couponvalue>0 Then
			If coupontype = "1" Then
				totalsale = "<b class='discount color-green'>"&  CStr(couponvalue) & "%<small>쿠폰</small></b>"
			ElseIf coupontype = "2" Then
				totalsale = "<b class='discount color-green'>"&  CStr(couponvalue) & "%<small>쿠폰</small></b>"
			ElseIf coupontype = "3" Then
				totalsale = "<b class='discount color-green'>"&  CStr(couponvalue) & "%<small>쿠폰</small></b>"
			Else
				totalsale = "<b class='discount color-green'>"&  CStr(couponvalue) & "%<small>쿠폰</small></b>"
			End If
		Else 
			totalsale = ""
		End If

%>
			<li>
				<% If isapp = "1" Then %>
				<a href="" onclick="fnAPPpopupProduct('<%=itemid%>');return false;">
				<% Else %>
				<a href="/category/category_itemPrd.asp?itemid=<%=itemid%><%=gaParam & (intI+1) %>_item">
				<% End If %>
					<div class="thumbnail swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="<%=getThumbImgFromURL(basicimage,"200","200","true","false") %>"/></div>
							<%	
								set oADD = new CatePrdCls
								oADD.getAddImage itemid

								IF oAdd.FResultCount > 0 THEN
									FOR i= 0 to oAdd.FResultCount-1
										If i >= 3 Then Exit For
										IF oAdd.FADD(i).FAddImageType=0 THEN
											Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oAdd.FADD(i).FAddimage,200,200,"true","false") & """/></div>"
										End IF
									NEXT
								END If

								set oADD = Nothing
							%>
						</div>
					</div>
					<div class="desc">
						<span class="brand"><%=brandname %></span>
						<p class="name"><%=itemname %></p>
						<div class="price">
							<div class="unit"><b class="sum"><%=totalprice%><span class="won">원</span></b> <%=totalsale%></div>
						</div>
					</div>
					<div class="review-desc">
						<p><%=chrbyte(evaContents, "140","Y")%></p>
						<div class="review">
							<span class="id"><%= printUserId(evaUserid,2,"*") %></span>
							<span class="icon icon-rating"><i style="width:<%=evaTotalpoint*20%>%;"><%=evaTotalpoint*20%>점</i></span>
						</div>
					</div>
				</a>
<!-- 				<div class="etc"> -->
<!-- 					<button class="tag wish btn-wish" onclick="goWishPop('<%=Itemid%>','');"><span class="icon icon-wish" id="wish<%=ItemID%>"><span class="icon icon-wish"><i> wish</i></span></span></button> -->
<!-- 				</div> -->
			</li>
<%
	Next
%>
		</ul>
		<div class="btn-group">
			<% If isapp = "1" Then %>
			<a href="" onclick="fnAPPselectGNBMenu('best','http://m.10x10.co.kr/apps/appCom/wish/web2014/award/awarditem.asp?atype=vi&disp=117');return false;" class="btn-plus"><span class="icon icon-plus icon-plus-black"></span> 베스트 리뷰 더보기</a>
			<% Else %>
			<a href="/list/best/review_detail2020.asp" class="btn-plus"><span class="icon icon-plus icon-plus-black"></span> 베스트 리뷰 더보기</a>
			<% End If %>
		</div>
	</div>
</div>
<script>
// best review
var reivewSwiper1 = new Swiper(".fashion-review .items li:nth-child(1) .swiper-container", {
	loop:true,
	autoplay:1200,
	speed:600,
	effect:'fade'
});
var reivewSwiper2 = new Swiper(".fashion-review .items li:nth-child(2) .swiper-container", {
	loop:true,
	autoplay:1200,
	speed:600,
	effect:'fade'
});
var reivewSwiper3 = new Swiper(".fashion-review .items li:nth-child(3) .swiper-container", {
	loop:true,
	autoplay:1200,
	speed:600,
	effect:'fade'
});
var reivewSwiper4 = new Swiper(".fashion-review .items li:nth-child(4) .swiper-container", {
	loop:true,
	autoplay:1200,
	speed:600,
	effect:'fade'
});
</script>
<%
End If
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->