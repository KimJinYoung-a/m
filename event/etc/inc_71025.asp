<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 페이스백
' History : 2016.06.01 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim eCode, userid, currenttime, subscriptcoun, subscriptcount, systemok, sqlstr, totalprice
dim arrList
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66141"
	Else
		eCode = "71025"
	end if

currenttime = now()
'currenttime = #05/20/2016 10:05:00#

userid = GetEncLoginUserID()
totalprice = 0
subscriptcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", left(currenttime,10))
end if

''응모 차단시 X로 변경
	'systemok="X"
	systemok="O"

if left(currenttime,10)<"2016-06-06" then
	systemok="X"
	if userid = "baboytw" or userid = "greenteenz" then
		systemok="O"
	end if
end if

if userid <> "" then
	sqlstr = sqlstr & " select isnull(sum(subtotalprice),0) as totalprice"
	sqlstr = sqlstr & " from db_order.dbo.tbl_order_master m"
	sqlstr = sqlstr & " where convert(varchar(10),regdate,21)='"&date()&"' "
	sqlstr = sqlstr & " and m.jumundiv not in (6,9)"
	sqlstr = sqlstr & " and m.ipkumdiv>3 and cancelyn='N'"
	sqlstr = sqlstr & " and m.userid='"& userid &"'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		totalprice = rsget("totalprice")
	else
		totalprice = 0
	END IF
	rsget.close
end if

	dim rsMem
	sqlstr = ""
	sqlstr = sqlstr & " select top 18 d.itemid, d.itemname, i.listimage, i.basicimage "
	sqlstr = sqlstr & " 	from db_order.dbo.tbl_order_detail as d "
	sqlstr = sqlstr & " 	join db_item.dbo.tbl_item as i "
	sqlstr = sqlstr & " 		on d.itemid = i.itemid "
	sqlstr = sqlstr & " where d.itemid <> 0 and d.itemid <> 100 "
	sqlstr = sqlstr & " order by orderserial desc "

	set rsMem = getDBCacheSQL(dbget,rsget,"71025EVT",sqlstr,60*5)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		arrList = rsMem.getRows()
	END IF
	rsMem.close

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 페이스 백!")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "오늘 구매한 금액을\n다시 돌려드리는 이벤트!\n\n당일 구매한 이력이 있는 고객 중\n한 분을 추첨하여\n구매금액을 다시 돌려드립니다!\n\n지금 도전하세요,\n바로 텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/71025/etcitemban20160601140702.JPEG"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	end if
%>
<style type="text/css">
img {vertical-align:top;}
.myShopping {padding:3.3rem 0 3.1rem; background:#d3d8e8 url(http://webimage.10x10.co.kr/eventIMG/2016/71025/m/bg_gradation.png) repeat-x 0 0; background-size:100% 100%;}
.myShopping h3 {width:48.75%; margin:0 auto;}
.myShopping .price {position:relative; padding:2.9rem 4rem 3rem 14rem;}
.myShopping .price:after {content:''; display:block; position:absolute; left:3.5rem; top:2rem; width:7.3rem; height:7.3rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71025/m/ico_member.png) no-repeat 0 0; background-size:100% auto;}
.myShopping .price dl {position:relative; overflow:hidden; padding:2.1rem 0 2rem; font-size:1.2rem; font-weight:bold; border-top:0.15rem solid #cad5e7; border-bottom:0.15rem solid #cad5e7;}
.myShopping .price dt {float:left;}
.myShopping .price dd {float:right; text-align:right;}
.myShopping .price dd strong {color:#fe3b18;}
.myShopping .btnApply {display:block; width:80.625%; margin:0 auto 2.5rem;}
.myShopping .winList {position:relative; width:87.5%; margin:0 auto; padding-left:10.2rem; background:#f8f8f8;}
.myShopping .winList:after {content:''; display:block; position:absolute; left:-0.3rem; top:-0.3rem; z-index:20; width:4.1rem; height:4.1rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71025/m/bg_ribbon.png) no-repeat 0 0; background-size:100% auto;}
.myShopping .winList h4 {position:absolute; left:2.5rem; top:50%; z-index:30; width:5.5rem; margin-top:-0.5rem;}
.myShopping .winSwipe {height:5rem;}
.myShopping .winSwipe button {display:block; position:absolute; right:0; z-index:40; width:3rem; background:transparent;}
.myShopping .winSwipe button.prev {top:0;}
.myShopping .winSwipe button.next {bottom:0;}
.myShopping .winSwipe .swiper-container {overflow:hidden; z-index:1; width:100%; height:100%;}
.myShopping .winSwipe .swiper-container-vertical > .swiper-wrapper {-webkit-box-orient:vertical; -moz-box-orient:vertical; -ms-flex-direction:column; -webkit-flex-direction:column; flex-direction:column;}
.myShopping .winSwipe .swiper-slide {overflow:hidden; height:5rem; font-size:0.9rem; line-height:1.5; color:#646464;}
.myShopping .winSwipe .swiper-slide div {display:table; width:100%; height:5rem;}
.myShopping .winSwipe .swiper-slide div p {display:table-cell; width:100%; padding-top:0.3rem; font-weight:600; vertical-align:middle;}
.myShopping .winSwipe .swiper-slide div p em {color:#3b579d;}
.myShopping .tip {font-size:0.85rem; color:#777; padding-top:1.4rem; text-align:center;}
.saleNow {background:#e9ebee;}
.saleNow .itemRolling {position:relative; padding:0 3.125% 4.7rem;}
.saleNow .itemRolling .swiper-container {background:#fff; border-radius:0.3rem; box-shadow:1px 1px 0.1rem 0 #d5d6d9;}
.saleNow .itemRolling ul {overflow:hidden; padding:1.2rem 1.2rem 2rem;}
.saleNow .itemRolling li {float:left; width:33.33333%; height:12.9rem; text-align:center; padding:1.2rem 0.8rem 0; border-top:1px solid #e1e1e1; border-right:1px solid #e1e1e1;}
.saleNow .itemRolling li:nth-child(1),
.saleNow .itemRolling li:nth-child(2),
.saleNow .itemRolling li:nth-child(3) {padding-top:0; border-top:0;}
.saleNow .itemRolling li:nth-child(3),
.saleNow .itemRolling li:nth-child(6) {border-right:0;}
.saleNow .itemRolling li p {overflow:hidden; margin-top:1.1rem; padding:0 0.5rem; font-size:1rem; line-height:1.2; color:#888; font-weight:600; text-overflow:ellipsis; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; word-wrap:break-word; height:2.4rem;}
.saleNow .itemRolling .pagination {position:absolute; bottom:2.4rem; left:0; z-index:10; width:100%; height:auto; padding-top:0; text-align:center;}
.saleNow .itemRolling .pagination .swiper-pagination-switch {display:inline-block; width:0.8rem; height:0.8rem; margin:0 0.5rem; border:0; background-color:#cfd1d3; cursor:pointer;}
.saleNow .itemRolling .pagination .swiper-active-switch {background-color:#3b579d;}
.shareSns {position:relative; padding-bottom:3.8rem; background:#e9ebee;}
.shareSns ul {position:absolute; right:11%; top:12%; width:38%; height:48%;}
.shareSns li {float:left; width:50%; height:100%;}
.shareSns li a {display:block; width:100%; height:100%; background:transparent; text-indent:-999em;}
.evtNoti {padding:2.4rem 4.68% 0;}
.evtNoti h3 {padding-bottom:1.5rem; font-size:1.3rem;}
.evtNoti h3 strong {display:inline-block; height:1.5rem; border-bottom:0.2rem solid #000;}
.evtNoti li {position:relative; color:#666; font-size:1rem; line-height:1.3; padding:0 0 0.2rem 0.7rem;}
.evtNoti li:after {content:''; position:absolute; left:0; top:0.4rem; width:0.2rem; height:0.2rem; background:#3b579d; border-radius:50%;}
</style>
<script>
$(function(){
	// 당첨자소식
	mySwiper = new Swiper(".winSwipe .swiper-container",{
		loop:false,
		autoplay:2000,
		speed:900,
		direction: 'vertical',
		pagination:false,
		prevButton:'.winSwipe .prev',
		nextButton:'.winSwipe .next'
	});

	// 방금판매상품
	mySwiper2 = new Swiper(".itemRolling .swiper-container",{
		loop:false,
		autoplay:false,
		speed:600,
		pagination:".itemRolling .pagination",
		paginationClickable:true
	});
});

function jsevtgo(){
<% if systemok = "O" then %>
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-06-01" and left(currenttime,10)<"2016-06-13" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount > 0 then %>
				alert('오늘은 이미 응모 하셨습니다.');
				return;
			<% else %>
				<% if totalprice < 1 then %>
					alert('금일 구매 금액이 있어야 응모가 가능 합니다.');
					return false;
				<% else %>
					var str = $.ajax({
						type: "POST",
						url: "/event/etc/doeventsubscript/doEventSubscript71025.asp",
						data: "mode=evtgo",
						dataType: "text",
						async: false
					}).responseText;
					var str1 = str.split("||")
					if (str1[0] == "11"){
						<% if left(currenttime,10)="2016-06-10" or left(currenttime,10)="2016-06-11" or left(currenttime,10)="2016-06-12" then %>
							alert('응모가 완료 되었습니다.\n\n당첨자는 다음주 월요일 오전 10시\n공지사항에서 확인하세요.');
							return false;
						<% else %>
							alert('응모가 완료 되었습니다.');
							return false;
						<% end if %>
					}else if (str1[0] == "01"){
						alert('잘못된 접속입니다.');
						return false;
					}else if (str1[0] == "02"){
						alert('로그인을 해야\n이벤트에 참여할 수 있어요.');
						return false;
					}else if (str1[0] == "03"){
						alert('이벤트 기간이 아닙니다.');
						return false;		
					}else if (str1[0] == "04"){
						alert('오늘은 이미 응모 하셨습니다.');
						return false;
					}else if (str1[0] == "00"){
						alert('정상적인 경로가 아닙니다.');
						return false;
					}else{
						alert('오류가 발생했습니다.');
						return false;
					}
				<% end if %>
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
<% else %>
	alert('잠시 후 다시 시도해 주세요!!');
	return;
<% end if %>
}

function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}
</script>
	<div class="mEvt71025">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/71025/m/tit_pay_back.png" alt="페이스백" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71025/m/txt_step.png" alt="원하는 상품 쇼핑하고 결제→이벤트 페이지에서 응모→다음날 오전 10시 당첨자 확인하기!" /></p>

		<div class="myShopping">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71025/m/tit_my_shopping.png" alt="오늘 MY 쇼핑활동" /></h3>
			<div class="price">
				<dl>
					<dt>구매금액 :</dt>
					<dd><strong><%= FormatNumber(totalprice,0) %></strong>원</dd>
				</dl>
			</div>
			<button type="button" onclick="jsevtgo(); return false;" class="btnApply"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71025/m/btn_apply.png" alt="오늘 MY 쇼핑활동" /></button>
			<div class="winList">
				<h4><img src="http://webimage.10x10.co.kr/eventIMG/2016/71025/m/txt_win.png" alt="당첨자 소식" /></h4>
				<div class="winSwipe">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<% if left(currenttime,10) <="2016-06-06" then %>
								<div class="swiper-slide"><div><p>내일 오전 10시부터 당첨자가 발표 됩니다.</p></div></div>
								
							<% elseif left(currenttime,10) ="2016-06-07" then %>
								<div class="swiper-slide"><div><p>6월 6일 응모하신 <em>waal**</em>님<br />구매금액 <em> 109,181 </em>원 당첨 되셨습니다.</p></div></div>
								
							<% elseif left(currenttime,10) ="2016-06-08" then %>
								<div class="swiper-slide"><div><p>6월 6일 응모하신 <em>waal**</em>님<br />구매금액 <em> 109,181 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 7일 응모하신 <em>kma295**</em>님<br />구매금액 <em> 530,000 </em>원 당첨 되셨습니다.</p></div></div>
								
							<% elseif left(currenttime,10) ="2016-06-09" then %>
								<div class="swiper-slide"><div><p>6월 6일 응모하신 <em>waal**</em>님<br />구매금액 <em> 109,181 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 7일 응모하신 <em>kma295**</em>님<br />구매금액 <em> 530,000 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 8일 응모하신 <em>eehw**</em>님<br />구매금액 <em> 55,260 </em>원 당첨 되셨습니다.</p></div></div>
								
							<% elseif left(currenttime,10) ="2016-06-10" then %>
								<div class="swiper-slide"><div><p>6월 6일 응모하신 <em>waal**</em>님<br />구매금액 <em> 109,181 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 7일 응모하신 <em>kma295**</em>님<br />구매금액 <em> 530,000 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 8일 응모하신 <em>eehw**</em>님<br />구매금액 <em> 55,260 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 9일 응모하신 <em>kindj**</em>님<br />구매금액 <em> 68,610 </em>원 당첨 되셨습니다.</p></div></div>
								
							<% elseif left(currenttime,10) ="2016-06-11" then %>
								<div class="swiper-slide"><div><p>6월 6일 응모하신 <em>waal**</em>님<br />구매금액 <em> 109,181 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 7일 응모하신 <em>kma295**</em>님<br />구매금액 <em> 530,000 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 8일 응모하신 <em>eehw**</em>님<br />구매금액 <em> 55,260 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 9일 응모하신 <em>kindj**</em>님<br />구매금액 <em> 68,610 </em>원 당첨 되셨습니다.</p></div></div>
								<% '' <div class="swiper-slide"><div><p>6월 10일 응모하신 <em>xxxxxx</em>님<br />구매금액 <em> 0 </em>원 당첨 되셨습니다.</p></div></div> %>
								
							<% elseif left(currenttime,10) ="2016-06-12" then %>
								<div class="swiper-slide"><div><p>6월 6일 응모하신 <em>waal**</em>님<br />구매금액 <em> 109,181 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 7일 응모하신 <em>kma295**</em>님<br />구매금액 <em> 530,000 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 8일 응모하신 <em>eehw**</em>님<br />구매금액 <em> 55,260 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 9일 응모하신 <em>kindj**</em>님<br />구매금액 <em> 68,610 </em>원 당첨 되셨습니다.</p></div></div>
								<% '' <div class="swiper-slide"><div><p>6월 10일 응모하신 <em>xxxxxx</em>님<br />구매금액 <em> 0 </em>원 당첨 되셨습니다.</p></div></div> %>
								<% '' <div class="swiper-slide"><div><p>6월 11일 응모하신 <em>xxxxxx</em>님<br />구매금액 <em> 0 </em>원 당첨 되셨습니다.</p></div></div> %>
								
							<% elseif left(currenttime,10) >="2016-06-13" then %>
								<div class="swiper-slide"><div><p>6월 6일 응모하신 <em>waal**</em>님<br />구매금액 <em> 109,181 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 7일 응모하신 <em>kma295**</em>님<br />구매금액 <em> 530,000 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 8일 응모하신 <em>eehw**</em>님<br />구매금액 <em> 55,260 </em>원 당첨 되셨습니다.</p></div></div>
								<div class="swiper-slide"><div><p>6월 9일 응모하신 <em>kindj**</em>님<br />구매금액 <em> 68,610 </em>원 당첨 되셨습니다.</p></div></div>
								<% '' <div class="swiper-slide"><div><p>6월 10일 응모하신 <em>xxxxxx</em>님<br />구매금액 <em> 0 </em>원 당첨 되셨습니다.</p></div></div> %>
								<% '' <div class="swiper-slide"><div><p>6월 11일 응모하신 <em>xxxxxx</em>님<br />구매금액 <em> 0 </em>원 당첨 되셨습니다.</p></div></div> %>
								<% '' <div class="swiper-slide"><div><p>6월 12일 응모하신 <em>xxxxxx</em>님<br />구매금액 <em> 0 </em>원 당첨 되셨습니다.</p></div></div> %>
							<% end if %>
						</div>
					</div>
					<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71025/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71025/m/btn_next.png" alt="다음" /></button>
				</div>
			</div>
			<p class="tip">※ 금, 토, 일 당첨자는 13일 월요일 오전 10시에 공지사항을 통해 발표됩니다.</p>
		</div>

		<div class="saleNow">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71025/m/tit_sell.png" alt="방금 전 판매된 상품" /></h3>
			<div class="itemRolling">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<ul>
							<%
							dim numcols, numrows, rowcounter, colcounter, thisfield
							numcols=ubound(arrList,1)
							numrows=ubound(arrList,2)
								FOR rowcounter= 0 TO numrows
								     thisfield=arrList(colcounter,rowcounter)
								%>
											<li>
												<a href="" onclick="jsViewItem('<%= arrList(0,rowcounter) %>'); return false;">
													<img src="http://webimage.10x10.co.kr/image/basic/<%= GetImageSubFolderByItemid(arrList(0,rowcounter)) %>/<%= arrList(3,rowcounter) %>" alt="" />
													<p><%= arrList(1,rowcounter) %></p>
												</a>
											</li>
									<% if rowcounter = 5 or rowcounter = 11 then %>
										</ul>
									</div>
									<div class="swiper-slide">
										<ul>
									<% end if %>
								<%
								NEXT
								%>
							</ul>
						</div>
					</div>
				</div>
				<div class="pagination"></div>
			</div>
		</div>

		<div class="shareSns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71025/m/txt_share.png" alt="친구들에게 공유하기" /></p>
			<ul>
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;">페이스북으로 공유</a></li>
				<li><a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;">카카오톡으로 공유</a></li>
			</ul>
		</div>

		<div class="evtNoti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>본 이벤트는 당일 구매이력이 있는 고객 대상으로 응모가 가능합니다.</li>
				<li>당첨자는 익일 오전 10시 응모하기 버튼 하단에 있는 당첨자소식을 통해 확인할 수 있습니다.</li>
				<li>금, 토, 일요일 당첨자는 13일 월요일 오전 10시 공지사항을 통해 확인할 수 있습니다.</li>
				<li>당첨된 금액은 당일 구매한 고객님의 총 결제금액이며 해당 금액의 기프트카드로 지급합니다.</li>
				<li>기프트카드는 6월 27일 주문완료 된 고객 대상으로 지급될 예정입니다.</li>
				<li>본 이벤트는 당첨 후 주문취소 및 환불하게 되면 당첨에서 제외됩니다.</li>
				<li>5만원 이상의 경품에 당첨되신 분께는 세무신고를 위해 개인정보를 요청할 수 있으며, 개인정보 확인 후 경품이 지급 됩니다. 제세공과금은 텐바이텐 부담입니다.</li>
			</ul>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->