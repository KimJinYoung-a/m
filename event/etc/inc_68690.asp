<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 두근두근 love factory
' History : 2016.01.22 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->

<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66008
Else
	eCode   =  68690
End If

dim currenttime
currenttime = now()
'currenttime = #02/01/2016 10:05:00#

dim itemid
if left(currenttime,10) < "2016-01-26" then
	itemid   =  1204304
elseif left(currenttime,10) = "2016-01-26" then
	itemid   =  441545
elseif left(currenttime,10) = "2016-01-27" then
	itemid   =  1220421
elseif left(currenttime,10) = "2016-01-28" then
	itemid   =  1423025
elseif left(currenttime,10) = "2016-01-29" then
	itemid   =  439795
elseif left(currenttime,10) = "2016-01-30" then
	itemid   =  439795
elseif left(currenttime,10) = "2016-01-31" then
	itemid   =  439795
elseif left(currenttime,10) = "2016-02-01" then
	itemid   =  550704
elseif left(currenttime,10) = "2016-02-02" then
	itemid   =  317909
elseif left(currenttime,10) = "2016-02-03" then
	itemid   =  999831
elseif left(currenttime,10) = "2016-02-04" then
	itemid   =  1004098
elseif left(currenttime,10) = "2016-02-05" then
	itemid   =  995334
elseif left(currenttime,10) = "2016-02-06" then
	itemid   =  1419814
elseif left(currenttime,10) = "2016-02-07" then
	itemid   =  1419814
elseif left(currenttime,10) = "2016-02-08" then
	itemid   =  1419814
elseif left(currenttime,10) = "2016-02-09" then
	itemid   =  793985
elseif left(currenttime,10) = "2016-02-10" then
	itemid   =  793985
else
	itemid   =  1406831
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid
%>

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

.container {background-color:#f3f3f3;}

.mEvt68690 .hidden {visibility:hidden; width:0; height:0;}

.specialItem {position:relative;}
.specialItem .item {position:absolute; top:7%; left:50%; width:74.84%; margin-left:-37.42%; text-align:center;}
.specialItem .item a {display:block; padding:10% 9.185% 8%;}
.specialItem .item .today {position:absolute; top:-4%; left:-5%; width:21.29%;}
.specialItem .item .name {display:block; margin-top:1.8rem; color:#222; font-size:1.2rem; font-weight:bold;}
.specialItem .item .price {display:block; margin-top:0.5rem; color:#000; font-size:1.1rem;}

@-webkit-keyframes shake {
	0%, 100% {-webkit-transform:translateY(0);}
	10%, 30%, 50%, 70% {-webkit-transform:translateY(-7px);}
	20%, 40%, 60%, 80% {-webkit-transform:translateY(7px);}
}
@keyframes shake {
	0%, 100% {transform:translateY(0);}
	10%, 30%, 50%, 70% {transform:translateY(-7px);}
	20%, 40%, 60%, 80% {transform:translateY(7px);}
}
.shake {-webkit-animation-name:shake; animation-name:shake; -webkit-animation-duration:2s; animation-duration:2s; -webkit-animation-fill-mode:both; animation-fill-mode:both; -webkit-animation-iteration-count:1; animation-iteration-count:1;}

.bnr {position:relative;}
.bnr ul {overflow:hidden; position:absolute; top:0; left:0; width:100%;}
.bnr ul li {float:left; width:50%;}
.bnr ul li:first-child {width:100%;}
.bnr ul li a {overflow:hidden; display:block; position:relative; height:0; padding-bottom:72.5%; color:transparent; font-size:12px; line-height:12px; text-align:center;}
.bnr ul li:first-child a {padding-bottom:41.5%;}
.bnr ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
.bnr ul li:nth-child(2) a span {background-color:red;}
.bnr ul li:nth-child(3) a span {background-color:blue;}
</style>

<% '<!-- 2016 VALENTINE'S DAY --> %>
<div class="mEvt68690">
	<article>
		<h2 class="hidden">2016 VALENTINE&apos;S DAY LOVE FACTORY</h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68690/txt_love_factory.png" alt="텐바이텐이 달콤한 가격으로 골라담은 초콜렛" /></p>

		<div class="specialItem">
			<div class="item">
				<% '<!-- for dev msg : 매일 특가 상품이 바뀝니다 --> %>
				<% if isApp=1 then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= itemid %>'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=<%= itemid %>" target="_blank">
				<% End If %>

					<img src="<%= oItem.Prd.FImageBasic %>" alt="<%= oItem.Prd.Fitemname %>" />
					<b class="today shake"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68690/ico_today.png" alt="달콤한 오늘의 특가!" /></b>
					<span class="name"><%= oItem.Prd.Fitemname %></span>

					<% if oItem.FResultCount > 0 then %>
						<span class="price">
							<%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %>

							<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) then %>
								 <span class="cRd1">[<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</span>
							<% end if %>
						</span>
					<% end if %>
				</a>
			</div>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/68690/bg_box.png" alt="" />
		</div>

		<div class="bnr">
			<ul>
				<li>
					<% if isApp=1 then %>
						<a href="" onclick="fnAPPpopupBrowserURL('이벤트','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=68692'); return false;">
					<% Else %>
						<a href="/event/eventmain.asp?eventid=68692" target="_blank">
					<% End If %>

					<span></span>전문가의 비법 클래스</a>
				</li>
				<li>
					<% if isApp=1 then %>
						<a href="" onclick="fnAPPpopupBrowserURL('이벤트','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=68813'); return false;">
					<% Else %>
						<a href="/event/eventmain.asp?eventid=68813" target="_blank">
					<% End If %>

					<span></span>초보자도 금손으로, D.I.Y</a>
				</li>
				<li>
					<% if isApp=1 then %>
						<a href="" onclick="fnAPPpopupBrowserURL('이벤트','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=68816'); return false;">
					<% Else %>
						<a href="/event/eventmain.asp?eventid=68816" target="_blank">
					<% End If %>

					<span></span>친구에게 하나, 연인에게 둘! Chocolate</a>
				</li>
			</ul>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/68690/img_bnr_01_v1.png" alt="" />
		</div>

		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/68690/tit_md_pick.png" alt="10X10 MD&apos;S PICK!" /></h3>

		<!--<div class="bnr">
			<% if isApp=1 then %>
				<a href="" onclick="fnAPPpopupBrowserURL('이벤트','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=68832'); return false;">
			<% Else %>
				<a href="/event/eventmain.asp?eventid=68832" target="_blank">
			<% End If %>

			<img src="http://webimage.10x10.co.kr/eventIMG/2016/68690/img_bnr_02.jpg" alt="사랑에 꿀 좀 발랐나 봐요? 꿀 떨어질 것 같은 달콤한 속삭임" /></a>
		</div>-->
	</article>
</div>

<%
set oItem=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->