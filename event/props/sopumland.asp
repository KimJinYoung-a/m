<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 웰컴투 소품랜드
' History : 2017-03-30 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim currentDate , i , init
	currentDate = date()
	init = 0

Dim eCode , egCode , intI , iTotCnt , itemid , TeCode
Dim logparam 
Dim cEventItem  
Dim eitemsort :	eitemsort = 1
Dim itemlimitcnt : itemlimitcnt = 105
Dim blnitempriceyn
Dim blnItemifno :  blnItemifno = True
Dim eItemListType

	eCode = requestCheckVar(request("eventid"),5)
	TeCode = eCode
%>
<!-- #include virtual="/event/props/sns.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.sopumland {background-color:#fdbab8}
.sopumlandHead {position:relative; }
.sopumland .balloon {position:absolute; top:25.7%; right:3.2%; width:20.78%; animation:swing 2s infinite forwards ease-in-out; transform-origin:20% 100%;}
.evntDateWrap {background-color:#fdbab8;}
.evntDate {width:100%; height:100%; background-color:#fdbab8;}
.evntDate .swiper-container {height:100%}
.evntDate .swiper-wrapper {height:100%;}
.evntDate .swiper-slide {position:relative; float:left; width:30.4% !important; height:100%;}
.evntDate .swiper-slide a {display:block; height:80%;}
.evntDate .swiper-slide img {vertical-align:top;} 
.evntDate .swiper-slide .tabOn {position:relative; bottom:-10%; left:50%;  width:13%; margin-left:-6.5%;}
.rolling .swiper {position:relative;}
.rolling .swiper .pagination{position:absolute; bottom:-10.2%; z-index:20; left:0; width:100%;}
.rolling .swiper .swiper-pagination-switch {width:11px; height:11px; margin:0 0.6rem; border:2px solid #000000; background-color:transparent;}
.rolling .swiper .swiper-active-switch {background-color:#000; border:#000 solid 1px;}
.sns {position:relative;}
.sns ul {width:33.75%; position:absolute; top:31%; right:3.43%;}
@keyframes swing { 0%,100%{transform:rotate(8deg);} 50% {transform:rotate(-3deg);} }

.bnr {background-color:#f4f7f7;}
.bnr ul li {margin-top:1rem;}
.bnr ul li:first-child {margin-top:0;}
</style>
<div class="sopum sopumland">
	<div class="sopumlandHead">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/tit_sopumland.png" alt="소품들의 환상적 케미쇼 웰컴투 소품랜드" /></h2>
		<div class="balloon"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/img_balloon.png" alt="" /></div>
	</div>
	
	<div class="evntDate">
		<div class="swiper-container">
			<ul class="swiper-wrapper">
				<%
					Dim ii , currentDate2 , tempevtcode , nowcnt
					ii = 0
					nowcnt = 0
					For ii=0 To 14
						currentDate2 = DateAdd("d", (ii), "2017-04-03") '// 기준일 가변
						tempevtcode  = "771"&chkiif((ii+1)<10,"0"&(ii+1),(ii+1)) '// 기준 이벤트 코드 선정
						If datediff("d", currentDate, currentDate2) = 0 Then '// 기준일과 오늘 비교 -- 오픈일

							If eCode = "" or eCode = "77060" Then eCode = tempevtcode End If '//없을경우
				%>
				<li class="swiper-slide"><a href="<%=chkiif(isapp<>"1","/event/eventmain.asp?eventid=771"&chkiif((ii+1)<10,"0"&(ii+1),(ii+1))&"","/apps/appcom/wish/web2014/event/eventmain.asp?eventid=771"&chkiif((ii+1)<10,"0"&(ii+1),(ii+1))&"")%>"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/tab_<%=ii%>_<%=chkiif(CStr(eCode) = CStr(tempevtcode),"open","opening")%>.jpg"/></a><% If CStr(eCode) = CStr(tempevtcode) Then %><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/tab_on.png" alt="" class="tabOn"/><% End if%></li>
				<%						
						ElseIf datediff("d", currentDate, currentDate2) > 0 Then '//기준일과 오늘 비교 -- 오픈전
				%>
				<li class="swiper-slide"><a href="" onclick="alert('coming soon');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/tab_<%=ii%>_<%=chkiif(CStr(eCode) = CStr(tempevtcode),"open.jpg","coming.png")%>"/></a><% If CStr(eCode) = CStr(tempevtcode) Then %><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/tab_on.png" alt="" class="tabOn"/><% End if%></li>
				<%						
						Else													'// 지난날짜
				%>
				<li class="swiper-slide"><a href="<%=chkiif(isapp<>"1","/event/eventmain.asp?eventid=771"&chkiif((ii+1)<10,"0"&(ii+1),(ii+1))&"","/apps/appcom/wish/web2014/event/eventmain.asp?eventid=771"&chkiif((ii+1)<10,"0"&(ii+1),(ii+1))&"")%>"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/tab_<%=ii%>_<%=chkiif(CStr(eCode) = CStr(tempevtcode),"open","opening")%>.jpg"/></a><% If CStr(eCode) = CStr(tempevtcode) Then %><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/tab_on.png" alt="" class="tabOn"/><% End if%></li>
				<%
						End If

						If CStr(eCode) = CStr(tempevtcode) Then '// 이벤트 코드 기준 현재 이벤트 코드 일때 위치 선정
							If ii < 2 Then
								init = 0
							ElseIf ii > 1  Then
								init = ii-1
							End If

							If init > 11 Then
								init = 12
							End If 
							nowcnt = ii
						End If
					Next
					'//로그파라메터
					logparam = "&pEtr="&eCode
				%>
			</ul>
			<script type="text/javascript">
			$(function(){
				dateSwiper = new Swiper('.evntDate .swiper-container',{
					initialSlide:<%=init%>,
					slidesPerView:"auto",
					speed:300,
					nextButton:'.evntDate .btnNext',
					prevButton:'.evntDate .btnPrev'
				});

				mySwiper = new Swiper("#rolling .swiper-container",{
					loop:true,
					autoplay:2500,
					speed:800,
					pagination:"#rolling .pagination",
					paginationClickable:true,
					prevButton:'#rolling .btnPrev',
					nextButton:'#rolling .btnNext',
					spaceBetween:"0%",
					effect:"slide"
				});
			});
			</script>
		</div>
	</div>
	<%
		'//map itemid 
		Dim itemurl1, itemurl2 , itemurl3
		'//4월 3일부터 ~ 4월 17일 까지 배열
		itemurl1 = array(1465642,1260092,1538702,1578677,1659553,1575860,1677420,1575187,1168270,1659999,1619733,1606935,1660629,1444573,1510635)
		itemurl2 = array(1491856,1645913,1647131,1553075,1658352,1539868,1651986,1331701,1672000,1552889,1680298,1679326,1576373,1403604,1511959)
		itemurl3 = array(1673735,1446823,1667442,1663690,1575179,1680719,1662536,1551182,1317315,1428152,1427173,1291761,1238605,1644213,292182)

	%>
	<div id="rolling" class="rolling">
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><% If isapp = "1" Then %><a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemurl1(nowcnt)%>&amp;pEtr=<%=eCode%>'); return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=<%=itemurl1(nowcnt)%>&amp;pEtr=<%=eCode%>"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/img_slide_<%=nowcnt%>_0.jpg" alt="" /></a></div>
					<div class="swiper-slide"><% If isapp = "1" Then %><a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemurl2(nowcnt)%>&amp;pEtr=<%=eCode%>'); return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=<%=itemurl2(nowcnt)%>&amp;pEtr=<%=eCode%>"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/img_slide_<%=nowcnt%>_1.jpg" alt="" /></a></div>
					<div class="swiper-slide"><% If isapp = "1" Then %><a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemurl3(nowcnt)%>&amp;pEtr=<%=eCode%>'); return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=<%=itemurl3(nowcnt)%>&amp;pEtr=<%=eCode%>"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/img_slide_<%=nowcnt%>_2.jpg" alt="" /></a></div>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
	</div>

	<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77060/m/bg_toys.jpg" alt="" /></div>
	<div>
		<div class="sns">
			<%=snsHtml%>
		</div>
	</div>
</div>
<%
	If TeCode = "77060" Then '// 상품 깔기
%>
<div class="evtPdtListWrapV15">
	<% If isapp = "1" then%>
		<% sbEvtItemView_app_2015 %>
	<% Else %>
		<% sbEvtItemView_2015 %>
	<% End If %>
<%
	End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->