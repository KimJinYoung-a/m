<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 94 MA
' 세상에 하나뿐인, 널 위한 마카롱
' History : 2017-11-07 유태욱 생성
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
dim currenttime
	currenttime =  now()
'	currenttime = #11/10/2017 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  67458
Else
	eCode   =  81716
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

if userid = "baboytw" or userid = "chaem35" or userid = "answjd248" then
	currenttime = #11/10/2017 09:00:00#
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
	iCPageSize = 3		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 3		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
.finishEvt {display:none;}
.heySomethingV17 .hsp-buy {background-color:#f4f2e8;}
.heySomethingV17 .hsp-buy .option {font-family:'AvenirNext-Regular', 'AppleSDGothicNeo-Regular', 'RobotoRegular', 'Noto Sans', sans-serif;}
.heySomethingV17 .hsp-buy .option .price s {display:inline-block;}
.heySomethingV17 .hsp-buy .option .txt {font-size:1.1rem; line-height:1;}

.heySomethingV17 .article .btn-go {margin-top:1.5rem;}
.heySomethingV17 .hsp-finish .txt1 {font-size:1.7rem; line-height:1.2; letter-spacing:0.1rem;}
.heySomethingV17 .comment-evt .ico {width:6rem; height:6rem; margin-right:0.4rem; background-repeat:no-repeat; background-position:0 0; background-size:100% 100%; border-radius:50%; text-indent:-999em;}
.heySomethingV17 .comment-evt .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/bg_ico_1.png);}
.heySomethingV17 .comment-evt .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/bg_ico_2.png);}
.heySomethingV17 .comment-evt .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/bg_ico_3.png);}
.heySomethingV17 .comment-evt .comment-list .ico {left:0.5rem; margin-top:-3rem;}
.heySomethingV17 .comment-evt .comment-list li {min-height:9rem;}
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
		<% If not( left(currenttime,10)>="2017-11-08" and left(currenttime,10)<"2017-11-16" ) Then %>
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
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/img_represent.jpg" alt="" /></div>
						</div>

						<!-- about -->
						<div class="swiper-slide hsp-about">
							<h3>About</h3>
							<p class="txt1">Hey,<br />something<br />project</p>
							<p class="txt2">텐바이텐만의 시각으로<br />주목해야 할 상품을 선별해 소개하고<br />새로운 트렌드를 제안하는<br />ONLY 텐바이텐만의 프로젝트</p>
						</div>

						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/txt_brand.jpg" alt="에다케이커리는 천연 식용색소를 사용하여 메시지, 로고 또는 다양한 사진 이미지 등을 마카롱 위에 직접 프린팅 하여 만들어주는 목동의 한 카페 입니다. 생일, 기념일, 아기 돌잔치, 연예인 팬클럽, 기업 행사 등 여러 곳에서 사랑 받고 있는 에다케이커리 마카롱으로 마음을 전해보세요" /></p>
						</div>

						<!-- buy -->
						<%
						Dim itemid, oItem
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1827940
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
						%>
						<div class="swiper-slide hsp-buy">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1827940&amp;pEtr=81716'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1827940&amp;pEtr=81716">
							<% End If %>	
								<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/img_item.gif" alt="" /></div>
								<div class="option">
									<p class="name">에다케이커리 주문제작 마카롱</p>
									<p class="txt">구성 : 5구, 10구</p>
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
									<div class="btn-go">구매하러 가기<i></i></div>
								</div>
							</a>
						</div>
						<% Set oItem = Nothing %>

						<!-- story -->
						<div class="swiper-slide hsp-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/img_story_1.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/txt_desc_1.png" alt="#사랑해 언제나 내 편이 되어주는 너에게 하고 싶은 말" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/img_story_2.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/txt_desc_2.png" alt="#축하해 오늘 가장 축하 받아야 할 너에게 하고 싶은 말" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/img_story_3.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/txt_desc_3.png" alt="#응원해 공부하느라 지쳐있을 너에게 하고 싶은 말" /></p>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1827940&pEtr=81716" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/img_cut.jpg" alt="에다케이커리 프린트 마카롱" /></a>
							<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1827940&pEtr=81716" onclick="fnAPPpopupProduct('1827940&pEtr=81716');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/img_cut.jpg" alt="에다케이커리 프린트 마카롱" /></a>
						</div>
						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/81716/m/img_finish_v2.jpg" alt="달콤한 마카롱 위에 사랑의 메시지 받는 사람의 사진이나 캐릭터 등이 그려진 나만의 마카롱을 제작하여 특별한 날을 더욱 특별하게 기념해보세요!" /></p>
						</div>

						<!-- comment Evt -->
						<div class="swiper-slide hsp-finish">
							<p class="txt1"><span>Hey, something project</span>마카롱으로 전하는 메시지</p>
							<p class="txt2">에다케이커리 마카롱에 어떤 메시지를 적어<br />누구에게 선물하고 싶으신가요?<br />정성껏 코멘트를 남겨주신 5분을 추첨하여<br />에다케이커리 머랭쿠키를 선물로 드립니다.</p>
							<p class="txt3">기간 : <b>2017.11.08 ~ 11.15</b> / 발표 : <b>11.16</b></p>
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
			<!-- edacakery 브랜드 페이지로 연결 -->
			<% If isApp="1" Then %>
				<div class="btn-get"><a href="" onclick="fnAPPpopupBrand('edacakery'); return false;">BRAND SHOP<i></i></a></div>
			<% Else %>
				<div class="btn-get"><a href="/street/street_brand.asp?makerid=edacakery">BRAND SHOP<i></i></a></div>
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
						<h3><span>Hey, something project</span>마카롱으로 전하는 메시지</h3>
						<p class="txt">에다케이커리 마카롱에 어떤 메시지를 적어<br />누구에게 선물하고 싶으신가요?<br />정성껏 코멘트를 남겨주신 5분을 추첨하여<br />에다케이커리 머랭쿠키를 선물로 드립니다.</p>
						<p class="date">기간 : <b>2017.11.08 ~ 11.15</b> / 발표 : <b>11.16</b></p>
						<div class="inner">
							<ul class="choice">
								<li class="ico ico1" value="1">
									<button type="button">#사랑해</button>
								</li>
								<li class="ico ico2" value="2">
									<button type="button">#축하해</button>
								</li>
								<li class="ico ico3" value="3">
									<button type="button">#응원해</button>
								</li>
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
												#사랑해
											<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
												#축하해
											<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
												#응원해
											<% Else %>
												#사랑해
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