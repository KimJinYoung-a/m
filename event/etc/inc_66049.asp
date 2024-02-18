<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 1
' History : 2015.09.08 한용민 생성
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
	'currenttime = #09/09/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64880
Else
	eCode   =  66049
End If

dim userid, i
	userid = GetEncLoginUserID()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1274641
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload, page
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

	page	= requestCheckVar(Request("page"),10)	'헤이썸띵 메뉴용 페이지 번호

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

/* buy */
.heySomething .swiper-slide-buy .option {position:absolute; top:20%; left:0; width:100%; text-align:center;}

/* item */
.heySomething .item {overflow:hidden; position:absolute; top:15%; left:50%; z-index:100; width:97.6%; margin-left:-48.8%;}
.heySomething .item li {float:left; width:50%; margin-bottom:2.5%;}
.heySomething .item li a {overflow:hidden; display:block; position:relative; height:0; margin:0 5%; padding-bottom:80.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.heySomething .item li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter: alpha(opacity=0); cursor:pointer;}

/* comment */
.heySomething .form .choice li.ico5 {clear:left;}
</style>
<script type='text/javascript'>

$(function(){
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% else %>
		setTimeout("pagup()",500);
	<% end if %>

	<% '헤이썸띵 메뉴용 %>
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
	<% '// 헤이썸띵 메뉴용 %>
});

function pagup(){
	window.$('html,body').animate({scrollTop:$(".mEvt66049").offset().top}, 0);
}

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#commentevt").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-09-09" and left(currenttime,10)<"2015-09-17" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.gubunval.value == ''){
					alert('원하는 것을 선택해 주세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 100){
					alert("코맨트는 100자 까지만 작성이 가능합니다. 코맨트를 남겨주세요.");
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

<% '헤이썸띵 메뉴용 %>
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
<% '// 헤이썸띵 메뉴용 %>

</script>
<div class="heySomething">
	<%'햄버거 메뉴%>
	<a href="#navHey" title="Hey something project 메뉴" id="hamburger" class="hamburger">
		<span>
			<i></i>
			<i></i>
			<i></i>
		</span>
	</a>
	<div id="HSPHeaderNew"></div>
	<%'//햄버거 메뉴%>
	<!-- main contents -->
	<div class="section article">
		<!-- swiper -->
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_01.jpg" alt="Hey, something project DESIGN FINGERS VOL.2" /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_02.jpg" alt="텐바이텐만의 시각으로 주목해야 할 상품을 선별해 소개하고 새로운 트렌드를 제안하는 ONLY 텐바이텐만의 프로젝트" /></p>
					</div>

					<!-- for dev msg : 9/9~9/16까지 할인 -->
					<div class="swiper-slide swiper-slide-buy">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_03.jpg" alt="" />
						<div class="option">
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupProduct('1274641'); return false;">
							<% else %>
								<a href="/category/category_itemPrd.asp?itemid=1274641">
							<% end if %>

								<img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_animation.gif" alt="" />
								<%
								'<!-- for dev msg : 9/9~9/16까지 할인 / 종료 후 <strong class="discount">....</strong>숨겨 주시고 
								'<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <del>....<del>숨겨주세요 -->
								%>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<% If oItem.Prd.FOrgprice = 0 Then %>
										<% else %>											
											<strong class="discount">단, 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<% end if %>
										
										<em class="name">다용도 수납박스 <span>W370 x D370 x H320mm</span></em>
										<div class="price">
											<del><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></del>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% else %>
										<em class="name">다용도 수납박스 <span>W370 x D370 x H320mm</span></em>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% end if %>
								<% end if %>

								<div class="btnbuy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_buy.png" alt="구매하러 가기" /></div>
							</a>
						</div>
					</div>

					<div class="swiper-slide siwper-slide-item">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_04_v1.jpg" alt="당신의 소중한 것을 차곡차곡 이 네모난 상자가 당신의 라이프에 어떠한 좋은 변화를 선물하는지 확인하세요." />
						<ul class="item">
							<% if isApp then %>
								<li><a href="" onclick="fnAPPpopupProduct('1274648'); return false;"><span></span>HACOBO 조립세트</a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1274649'); return false;"><span></span>HACOBO 바퀴세트</a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1274646'); return false;"><span></span>HACOBO 스툴용 쿠션시트</a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1274647'); return false;"><span></span>HACOBO 테이블용 우드커버</a></li>
							<% else %>
								<li><a href="/category/category_itemPrd.asp?itemid=1274648"><span></span>HACOBO 조립세트</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1274649"><span></span>HACOBO 바퀴세트</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1274646"><span></span>HACOBO 스툴용 쿠션시트</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1274647"><span></span>HACOBO 테이블용 우드커버</a></li>
							<% end if %>
						</ul>
					</div>

					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_05.jpg" alt="COLOR RED YELLOW GREEN LIGHT BLUE IVORY BROWN" />
					</div>
					<div class="swiper-slide swiper-slide-brand">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_06_v1.jpg" alt="" />
						<div class="brand">
							<p class="letter1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/txt_plan_01.png" alt="HACOBO" /></p>
							<p class="letter2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/txt_plan_02.png" alt="밖으로만 쏟아내는 소진시대에 사는 우리는 어쩌면, 나와 그리고 주변의 것들을 어떻게 정리하며 살 수 있을까 늘 고민합니다. 좋아하는 것들을 차곡차곡! HACOBO 수납박스는 여섯 가지 컬러와 쌓을 수 있는 구조로 당신의 즐거운 수납생활을 도와줍니다. " /></p>
							<p class="letter3"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/txt_plan_03.png" alt="네모난 수납박스와 함께 편리한 이동을 위한 바퀴, 테이블, 스툴용으로 변신을 도와줄 옵션들을 함께 사용해보세요. 더욱 편리하고 기분 좋은 활.용.도를 선보입니다." /></p>
						</div>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_07.jpg" alt="내 방 한 공간, 자꾸 보고 싶은 것들을 차곡차곡 정리하고 채워 넣을 수 있어요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_08.jpg" alt="정리에 대한 정리. 아끼는 것들을 박스 안 공간에 잘 담으세요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_09.jpg" alt="하던 일을 멈추고 잠시 앉아 오로지 나만의 쉬는 시간을 보내세요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_10.jpg" alt="가장 편한 공간에서 내려놓기 연습 침대 옆 또는 거실 가운데 작은 테이블을 두세요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_11.jpg" alt="버리는 습관, 때로는 비워내는 것이 또 다른 좋은 것을 가져다 주기도 해요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_12.jpg" alt="바퀴로 어디든 빠르게 다가갈 수 있어요. 무거운 어떤 것도 쉽게 이동시킬 수 있어요." /></p>
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_13.jpg" alt="사람들과 좋아하는 시간을 공유하는 것 실내에서도 야외에서도 언제나 당신과 함께 해요." /></p>
					</div>
					<div class="swiper-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_14.jpg" alt="당신과 함께하는 즐거운 수납생활 HACOBO" />
					</div>
					<div class="swiper-slide">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_slide_15.png" alt="정성껏 코멘트를 남겨주신 5분을 추첨하여 HACOBO 수납박스를 선물로 드립니다. 기간은 2015년 9월 9일부터 9월 16일까지며, 발표는 9월 17일 입니다." /></p>
						<a href="#commentevt" class="btngo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_go_v1.gif" alt="응모하러 가기" /></a>
					</div>
				</div>
			</div>
			<div class="pagingNo">
				<p class="page"><strong></strong>/<span></span></p>
			</div>

			<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_next.png" alt="다음" /></button>
		</div>
	
		<div class="btnget">
			<% if isApp then %>
				<% IF application("Svr_Info") = "Dev" THEN %>
					<a href="" onclick="fnAPPpopupBrowserURL('구매하기','http://testm.10x10.co.kr/event/etc/inc_66049_item.asp?isApp=<%= isApp %>'); return false;" >
				<% Else %>
					<a href="" onclick="fnAPPpopupBrowserURL('구매하기','http://m.10x10.co.kr/event/etc/inc_66049_item.asp?isApp=<%= isApp %>'); return false;" >
				<% End If %>
			<% else %>
				<a href="/event/etc/inc_66049_item.asp?isApp=<%= isApp %>" target="_blank" >
			<% end if %>
			
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/btn_get.png" alt="BUY" /></a>
		</div>
	</div>
	<!-- //main contents -->

	<!-- comment event -->
	<div id="commentevt" class="section commentevt">
		<!-- for dev msg : form -->
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
		<div class="form">
			<fieldset>
			<legend>갖고 싶은 활용도 선택하고 코멘트 쓰기</legend>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/txt_comment_v1.png" alt="정성껏 코멘트를 남겨주신 5분을 추첨하여 HACOBO 수납박스를 선물로 드립니다. 기간은 2015년 9월 9일부터 9월 16일까지며, 발표는 9월 17일 입니다." /></p>
				<div class="inner">
					<ul class="choice">
						<li class="ico1"><button type="button" value="1">채우기</button></li>
						<li class="ico2"><button type="button" value="2">담기</button></li>
						<li class="ico3"><button type="button" value="3">여유갖기</button></li>
						<li class="ico4"><button type="button" value="4">쉬어가기</button></li>
						<li class="ico5"><button type="button" value="5">비우기</button></li>
						<li class="ico6"><button type="button" value="6">다가가기</button></li>
						<li class="ico7"><button type="button" value="7">시간보내기</button></li>
					</ul>
					<div class="field">
						<textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
						<input type="submit" onclick="jsSubmitComment(document.frmcom); return false;" value="응모하기" class="btnsubmit" />
					</div>
				</div>
			</fieldset>
		</div>
		</form>
		<form name="frmactNew" method="post" action="/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON" style="margin:0px;">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/etc/inc_66049_comment.asp?isApp=<%=isApp %>">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="isApp" value="<%= isApp %>">
		</form>

		<!-- for dev msg : comment list -->
		<div class="commentlist" id="commentlist">
			<div class="total">total <%= iCTotCnt %></div>
			
			<% IF isArray(arrCList) THEN %>
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
					<li>
						<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
							<strong class="ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
								<% if split(arrCList(1,intCLoop),"!@#")(0)="1" then %>
									채우기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="2" then %>
									담기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="3" then %>
									여유갖기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="4" then %>
									쉬어가기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="5" then %>
									비우기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="6" then %>
									다가가기
								<% elseif split(arrCList(1,intCLoop),"!@#")(0)="7" then %>
									시간보내기
								<% end if %>																																																					
							</strong>
						<% end if %>

						<div class="letter">
							<p>
								<% if isarray(split(arrCList(1,intCLoop),"!@#")) then %>
									<% if ubound(split(arrCList(1,intCLoop),"!@#")) > 0 then %>
										<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"!@#")(1) ))%>
									<% end if %>
								<% end if %>
							</p>
							
							<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
								<span class="button btS1 btWht cBk1"><button onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;" type="button">삭제</button></span>
							<% end if %>
						</div>
						<div class="date">
							<span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span>

							<% If arrCList(8,i) <> "W" Then %>
								 <span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성"></span>
							<% end if %>
						</div>
					</li>
					<% Next %>
				</ul>

				<% IF isArray(arrCList) THEN %>
					<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
				<% end if %>
			<% end if %>
		</div>
	</div>
	<!-- //comment event -->

	<div id="dimmed"></div>
</div>


<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:false,
		paginationClickable:true,
		speed:1000,
		autoplay:false,
		nextButton:'.btn-next',
		prevButton:'.btn-prev',
		onSlideChangeStart: function (mySwiper) {
			var vActIdx = parseInt(mySwiper.activeIndex);
			if (vActIdx<=0) {
				vActIdx = mySwiper.slides.length-2;
			} else if(vActIdx>(mySwiper.slides.length-2)) {
				vActIdx = 1;
			}
			$(".pagingNo .page strong").text(vActIdx);
			$(".swiper-slide").find(".brand .letter1").delay(100).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide").find(".brand .letter2").delay(300).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide").find(".brand .letter3").delay(500).animate({"margin-top":"7%", "opacity":"0"},300);
			$(".swiper-slide-active").find(".brand .letter1").delay(50).animate({"margin-top":"6%", "opacity":"1"},600);
			$(".swiper-slide-active").find(".brand .letter2").delay(50).animate({"margin-top":"6%", "opacity":"1"},600);
			$(".swiper-slide-active").find(".brand .letter3").delay(50).animate({"margin-top":"6%", "opacity":"1"},600);
		}
	});
	$('.btn-prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.btn-next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	$('.pagingNo .page strong').text(1);
	$('.pagingNo .page span').text(mySwiper.slides.length-2);

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
			}, 500);
	});

	/* navigator */
	$(".heySomething .menu").click(function(){
		$("#navigator").show();
		$("#dimmed").show();
		return false;
	});
	$("#navigator .btnclose, #dimmed").click(function(){
		$("#navigator").hide();
		$("#dimmed").fadeOut();
	});

	$(".btngo").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	$(".form .choice li:first-child button").addClass("on");
	frmcom.gubunval.value = '1';

	$(".form .choice li button").click(function(){
		//alert( $(this).val() );
		frmcom.gubunval.value = $(this).val()
		$(".form .choice li button").removeClass("on");
		if ( $(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});

});
</script>

<!-- #include virtual="/lib/db/dbclose.asp" -->