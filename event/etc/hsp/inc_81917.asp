<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 94 MA
' 시간이 지닌 색
' History : 2017-11-14 유태욱 생성
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
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
Dim itemid, oItem
dim currenttime
	currenttime =  now()
'	currenttime = #11/10/2017 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  67460
Else
	eCode   =  81917
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

if userid = "baboytw" or userid = "baboytw1" or userid = "chaem35" or userid = "answjd248" then
	currenttime = #11/15/2017 09:00:00#
end if

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload, page
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= getNumeric(requestCheckVar(Request("iCC"),10))	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

	page	= getNumeric(requestCheckVar(Request("page"),10))	'헤이썸띵 메뉴용 페이지 번호

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if
'iCPageSize = 1

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1


%>
<style type="text/css">
.finish-event {display:none;}
.hsp-buy .thumbnail {overflow:hidden;}
.hsp-buy .thumbnail a {float:left; display:block; width:50%;}
.hsp-buy {font-family:'AvenirNext-Regular', 'AppleSDGothicNeo-Regular', 'RobotoRegular', 'Noto Sans', sans-serif;}
.hsp-buy .name {display:block; font-weight:normal !important;}
.hsp-buy .name1 {color:#3e3e3e; font-size:1.2rem !important;}
.hsp-buy .name2 {margin-top:0.85rem; color:#333; color:#000; font-size:2.3rem !important;}
.hsp-buy .name3 {margin-top:1.54rem; color:#777; font-size:1.1rem !important; line-height:1.6rem;}
.hsp-buy .price s {display:inline !important;}

.heySomethingV17 .hsp-desc p {position:relative; margin-bottom:0; opacity:1; transition:none;}

.heySomethingV17 .hsp-finish {padding-top:6rem;}
.heySomethingV17 .hsp-finish .txt2 {margin-top:1.19rem; padding-top:0;}
.heySomethingV17 .gift {width:15.05rem; margin:1.37rem auto 0;}
.heySomethingV17 .article .btn-go {margin-top:2.6rem;}

.heySomethingV17 .comment-write .txt {padding-right:0;}
.choice li:nth-child(n+5) {margin-top:0.55rem;}
.heySomethingV17 .comment-evt .ico {width:5.5rem; height:5.5rem; margin-right:0.55rem; background-color:#f7acaa; border-radius:50%; color:#fff; font-size:1.2rem;}
.heySomethingV17 .comment-evt .ico2 {background-color:#162957;}
.heySomethingV17 .comment-evt .ico3 {background-color:#66680c;}
.heySomethingV17 .comment-evt .ico4 {background-color:#848484;}
.heySomethingV17 .comment-evt .ico5 {background-color:#9b1212;}
.heySomethingV17 .comment-evt .ico6 {background-color:#151715;}
.heySomethingV17 .comment-evt .comment-list .ico {left:0.5rem; margin-top:-2.78rem;}
.heySomethingV17 .comment-evt .comment-list li {min-height:9rem;}
.heySomethingV17 .comment-evt strong {font-weight:normal;}
</style>
<script type="text/javascript">
$(function(){
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% else %>
		setTimeout("pagup()",500);
	<% end if %>

	<% ''헤이썸띵 메뉴용 %>
	fnGetListHeader('<%=page%>');

	$("#navHey").hide();
	$("#hamburger").click(function(){
		if ($(this).hasClass("open")){
			$("#navHey").hide();
			$("#dimmed").hide();
			$(this).removeClass("open");
		} else {
			$("#navHey").show();
			$("#dimmed").show();
			$(this).addClass("open");
		}
		return false;
	});

	$("#dimmed").click(function(){
		$("#navHey").hide();
		$("#dimmed").hide();
		$("#hamburger").removeClass("open");
	});
	<% ''// 헤이썸띵 메뉴용 %>

});

function pagup(){
	window.$('html,body').animate({scrollTop:$("#toparticle").offset().top}, 0);
}

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#comment-evt").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2017-11-15" and left(currenttime,10)<"2017-11-23" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.gubunval.value == ''){
					alert('원하는 아이콘을 선택해 주세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 400){
					alert("코맨트를 남겨주세요.\n400자 까지 작성 가능합니다.");
					frm.txtcomm1.focus();
					return false;
				}

				frm.txtcomm.value = frm.gubunval.value + '!@#' + frm.txtcomm1.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}

	//if (frmcom.txtcomm.value == ''){
	//	frmcom.txtcomm.value = '';
	//}	
}

//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}

<% ''헤이썸띵 메뉴용 %>
function fnGetListHeader(pg) {
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/HSPheader.asp",
		data: "eventid=<%=eCode%>&page="+pg,
		dataType: "text",
		async: false
	}).responseText;
	if(str!="") {
		$("#HSPHeaderNew").empty().html(str);
		//document.getElementById("HSPList").innerHTML=str;
	}
}

function goHSPPageH(pg) {
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/HSPheader.asp",
		data: "eventid=<%=eCode%>&page="+pg,
		dataType: "text",
		async: false
	}).responseText;
	if(str!="") {
		$("#HSPHeaderNew").empty().html(str);
		$("#navHey").show();
		$("#dimmed").show();
		$(this).addClass("open");
		//document.getElementById("HSPList").innerHTML=str;
	}
}
<% ''// 헤이썸띵 메뉴용 %>

$(function(){ 
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		speed:800,
		autoplay:false,
		nextButton:'.next',
		prevButton:'.prev',
		autoplayDisableOnInteraction:false,
		onSlideChangeStart: function (mySwiper) {
			var vActIdx = parseInt(mySwiper.activeIndex);
			if (vActIdx<=0) {
				vActIdx = mySwiper.slides.length-2;
			} else if(vActIdx>(mySwiper.slides.length-2)) {
				vActIdx = 1;
			}
			$(".pagingNo .page strong").text(vActIdx);
		}
	});
	$('.pagingNo .page strong').text(1);
	$('.pagingNo .page span').text(mySwiper.slides.length-2);

	/* skip to comment */
	$(".btn-go").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	$(".heySomethingV17 .choice li:first-child").addClass("on");
	frmcom.gubunval.value = '1';
	$(".heySomethingV17 .choice li").click(function(){
		frmcom.gubunval.value = $(this).val();
		$(".heySomethingV17 .choice li").removeClass("on");
		$(this).addClass("on");
	});
});
</script>
	<div class="heySomethingV17">
	<%''햄버거 메뉴%>
	<a href="#navHey" title="Hey something project 메뉴" id="hamburger" class="hamburger">
		<span>
			<i></i>
			<i></i>
			<i></i>
		</span>
	</a>
	<div id="HSPHeaderNew"></div>
	<%''//햄버거 메뉴%>
		<div class="section article">
			<!-- swiper -->
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<!-- topic -->
						<div class="swiper-slide hsp-topic">
							<h2>Hey,<br /><b>something</b><br />project</h2>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_represent.jpg" alt="" /></div>
						</div>

						<!-- about -->
						<div class="swiper-slide hsp-about">
							<h3>About</h3>
							<p class="txt1">Hey,<br />something<br />project</p>
							<p class="txt2">텐바이텐만의 시각으로<br />주목해야 할 상품을 선별해 소개하고<br />새로운 트렌드를 제안하는<br />ONLY 텐바이텐만의 프로젝트</p>
						</div>

						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/txt_brand.gif" alt="시간을 뉘어놓는 시간 TIME TRAY" /></p>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_brand_ani.gif" alt="" /></div>
						</div>

						<!-- buy -->
						<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1812273
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
						%>
						<div class="swiper-slide hsp-buy">
							<div class="logo"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_vilivstudio_logo.png" alt="Vilivstudio" /></div>
								<div class="thumbnail">
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1812273&amp;pEtr=81917'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_01_v1.jpg" alt="Gray" /></a>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1812274&amp;pEtr=81917'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_02_v1.jpg" alt="Black" /></a>
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1812273&pEtr=81917"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_01_v1.jpg" alt="Gray" /></a>
										<a href="/category/category_itemPrd.asp?itemid=1812274&pEtr=81917"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_02_v1.jpg" alt="Black" /></a>
									<% End If %>
								</div>
								<div class="option">
									<p class="desc">
										<span class="name name1">모던하고 세련된 느낌을 주는</span>
										<span class="name name2">스테인리스 트레이</span>
										<span class="name name3">타임트레이는 시계를 모티브로 디자인 되었습니다. 시침,<br /> 분침을 파티션으로 형상화했고 공간을 자유롭게 조절하여<br /> 사용이 가능합니다.</span>
									</p>
									<% If oItem.FResultCount > 0 then %>
										<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
											<div class="price">
												<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong>
											</div>
										<% else %>
											<div class="price priceEnd">
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
											</div>
										<% end if %>
									<% end if %>
								</div>
							</a>
						</div>
						<% Set oItem = Nothing %>
						
						
						<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1812275
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
						%>
						<div class="swiper-slide hsp-buy">
							<div class="thumbnail">
								<% If isApp = 1 Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1812275&amp;pEtr=81917'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_03_v1.jpg" alt="Pink" /></a>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1812277&amp;pEtr=81917'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_04_v1.jpg" alt="Navy" /></a>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1812276&amp;pEtr=81917'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_05_v1.jpg" alt="Green" /></a>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1812278&amp;pEtr=81917'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_06_v1.jpg" alt="Red" /></a>
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1812275&pEtr=81917"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_03_v1.jpg" alt="Pink" /></a>
									<a href="/category/category_itemPrd.asp?itemid=1812277&pEtr=81917"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_04_v1.jpg" alt="Navy" /></a>
									<a href="/category/category_itemPrd.asp?itemid=1812276&pEtr=81917"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_05_v1.jpg" alt="Green" /></a>
									<a href="/category/category_itemPrd.asp?itemid=1812278&pEtr=81917"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_item_06_v1.jpg" alt="Red" /></a>
								<% End If %>
							</div>
								<div class="option">
									<p class="desc">
										<span class="name name1">시간이 지날수록 빈티지한 멋이 더해지는</span>
										<span class="name name2">황동 트레이</span>
										<span class="name name3">타임트레이는 시계를 모티브로 디자인 되었습니다. 시침,<br /> 분침을 파티션으로 형상화했고 공간을 자유롭게 조절하여<br /> 사용이 가능합니다.</span>
									</p>
									<% If oItem.FResultCount > 0 then %>
										<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
											<div class="price">
												<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(1, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong>
											</div>
										<% else %>
											<div class="price priceEnd">
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
											</div>
										<% end if %>
									<% end if %>
								</div>
							</a>
						</div>
						<% Set oItem = Nothing %>

						<!-- story -->
						<div class="swiper-slide hsp-desc">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_story_01.jpg" alt="사랑스러움으로 물든 Pink" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_story_02_v1.jpg" alt="겨울 밤이 생각나는 Navy" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_story_03.jpg" alt="올해의 컬러 Green" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_story_04.jpg" alt="때로는 아날로그 감성 Gray" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_story_05.jpg" alt="매혹적 그리고 치명적인 Red" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_story_06.jpg" alt="무심한듯 시크하게 Black" /></p>
						</div>

						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/txt_finish.jpg" alt="작은 것들을 더 소중하고 돋보이게 TIME TRAY" /></p>
						</div>

						<!-- comment Evt -->
						<div class="swiper-slide hsp-finish">
							<p class="txt1"><span>Hey, something project</span> 당신의 색은 무엇인가요?</p>
							<p class="txt2">빌리브스튜디오의 트레이 중 가장 마음에 드는<br /> 컬러나, 새로운 컬러가 출시된다면 가장 갖고 싶은<br /> 컬러는 무엇인가요? 정성스러운 코멘트를 남겨주신<br /> 5분을 추첨하여 명함꽂이 or 황동 마그넷을<br /> 선물로 드립니다! (랜덤발송)</p>
							<div class="gift"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81917/m/img_gift.jpg" alt="k" /></div>
							<p class="txt3">기간 : <b>017.11.15 ~ 11.22</b> / 발표 : <b>11.23</b></p>
							<a href="#comment-evt" class="btn-go">응모하러 가기<i></i></a>
						</div>
					</div>
				</div>
				<div class="pagingNo">
					<p class="page"><strong></strong>/<span></span></p>
				</div>
				<button type="button" class="btn-nav prev"><span>이전</span></button>
				<button type="button" class="btn-nav next"><span>다음</span></button>
			</div>
			<!-- vilivstudio 브랜드 페이지로 연결 -->
			<% If isApp="1" Then %>
				<div class="btn-get"><a href="" onclick="fnAPPpopupBrand('vilivstudio'); return false;" title="빌리브 스튜디오 브랜드 페이지로 이동">BRAND SHOP<i></i></a></div>
			<% Else %>
				<div class="btn-get"><a href="/street/street_brand.asp?makerid=vilivstudio" title="빌리브 스튜디오 브랜드 페이지로 이동">BRAND SHOP<i></i></a></div>
			<% End If %>
		</div>
		<!-- //main contents -->

		<!-- comment event -->
		<div id="comment-evt" class="section comment-evt">
			<!-- for dev msg : comment write -->
			<div class="comment-write">
				<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="pagereload" value="ON">
				<input type="hidden" name="iCC" value="1">
				<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
				<input type="hidden" name="eventid" value="<%= eCode %>">
				<input type="hidden" name="linkevt" value="<%= eCode %>">
				<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
				<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
				<input type="hidden" name="txtcomm">
				<input type="hidden" name="gubunval">
				<input type="hidden" name="isApp" value="<%= isApp %>">	
					<fieldset>
					<legend>코멘트 작성 폼</legend>
						<h3><span>Hey, something project</span> 당신의 색은 무엇인가요?</h3>
						<p class="txt">빌리브스튜디오의 트레이 중 가장 마음에 드는 컬러는<br /> 무엇이며, 새로운 컬러가 출시된다면 가장 갖고 싶은<br /> 컬러는 무엇인가요? 정성스러운 코멘트를 남겨주신<br /> 5분을 추첨하여 명함꽂이 or 황동 마그넷을 선물로<br /> 드립니다! (랜덤발송)</p>
						<p class="date">기간 : <b>2017.11.15 ~ 11.22</b> / 발표 : <b>11.23</b></p>
						<div class="inner">
							<ul class="choice">
								<li class="ico ico1" value="1"><button type="button">Pink</button></li>
								<li class="ico ico2" value="2"><button type="button">Navy</button></li>
								<li class="ico ico3" value="3"><button type="button">Green</button></li>
								<li class="ico ico4" value="4"><button type="button">Gray</button></li>
								<li class="ico ico5" value="5"><button type="button">Red</button></li>
								<li class="ico ico6" value="6"><button type="button">Black</button></li>
							</ul>
							<div class="field">
								<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="코멘트 작성" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
								<input type="submit" value="응모하기" onclick="jsSubmitComment(document.frmcom); return false;" class="btnsubmit" />
							</div>
						</div>
					</fieldset>
				</form>
				<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
				<input type="hidden" name="mode" value="del">
				<input type="hidden" name="pagereload" value="ON">
				<input type="hidden" name="Cidx" value="">
				<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
				<input type="hidden" name="eventid" value="<%= eCode %>">
				<input type="hidden" name="linkevt" value="<%= eCode %>">
				<input type="hidden" name="isApp" value="<%= isApp %>">
				</form>
			</div>

			<!-- for dev msg : comment list -->
			<div class="comment-list">
				<p class="total">total <%=iCTotCnt%></p>
					<% IF isArray(arrCList) THEN %>
						<ul>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
								<li>
									<% If isarray(split(arrCList(1,intCLoop),"!@#")) Then %>
									<div class="ico ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
										<strong>
											<% If split(arrCList(1,intCLoop),"!@#")(0)="1" Then %>
												Pink
											<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
												Navy
											<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
												Green
											<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
												Gray
											<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="5" Then %>
												Red
											<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="6" Then %>
												Black
											<% Else %>
												Pink
											<% End if %>	
										</strong>
									</div>
									<% End If %>
									<div class="letter">
										<p>
											<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
												<% if ubound(split(arrCList(1,intCLoop),"!@#")) > 0 then %>
													<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"!@#")(1) ))%>
												<% end if %>
											<% end if %>
										</p>
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
											<span class="button btS1 btWht cBk1"><button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button></span>
										<% end if %>
										<p class="date"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span>
										<% If arrCList(8,intCLoop) <> "W" Then %> <span class="mob">모바일에서 작성</span><% end if %>
										</p>
									</div>
								</li>
							<% next %>
						</ul>
						<div class="paging">
						<% IF isArray(arrCList) THEN %>
							<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
						<% end if %>
						</div>
					<% end if %>
			</div>
		</div>
		<!-- //comment event -->
		<div id="dimmed"></div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->