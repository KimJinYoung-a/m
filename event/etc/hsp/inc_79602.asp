<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 81 Re:air
' History : 2017-08-01 유태욱 생성
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
	'currenttime = #10/07/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66407
Else
	eCode   =  79602
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

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
.finishEvt {display:none;}
.heySomethingV17 .hsp-buy .option {position:absolute; left:0; top:53%; width:100%;}
.heySomethingV17 .hsp-buy .option .price s {display:inline-block; padding-right:0.3rem;}
.heySomethingV17 .hsp-buy .option .txt {font-weight:500;}
.heySomethingV17 .hsp-buy .option .txt span {padding:0 0.7rem;}
.heySomethingV17 .hsp-buy .btn-go {margin-top:1.5rem;}
.heySomethingV17 .hsp-buy .option .noti {padding-top:3rem; color:#777; font-size:1.1rem;}
.heySomethingV17 .hsp-feature div {position:absolute; left:10%; top:30%; width:80%;}
.heySomethingV17 .video {position:absolute; left:0; top:50%; width:100%; height:44%; margin-top:-32%;}
.heySomethingV17 .video video {width:100%; height:100%;}
.heySomethingV17 .comment-evt .ico {width:5.5rem; height:5.5rem; margin-right:1rem; padding-top:0.08rem; font-size:1rem; line-height:1.2; color:#fff; font-weight:600; background-color:#a5b857; border-radius:0.7rem;}
.heySomethingV17 .comment-evt .ico2 {background-color:#4e9eb5;}
.heySomethingV17 .comment-evt .ico3 {background-color:#53b298;}
.heySomethingV17 .comment-evt .ico4 {background-color:#d4b445;}
.heySomethingV17 .comment-evt .comment-list .ico {width:5rem; height:5rem;margin-top:-2.5rem;}
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
		<% If not( left(currenttime,10)>="2017-08-01" and left(currenttime,10)<"2017-08-09" ) Then %>
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
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/img_represent.jpg" alt="" /></div>
						</div>

						<!-- about -->
						<div class="swiper-slide hsp-about">
							<h3>About</h3>
							<p class="txt1">Hey,<br />something<br />project</p>
							<p class="txt2">텐바이텐만의 시각으로<br />주목해야 할 상품을 선별해 소개하고<br />새로운 트렌드를 제안하는<br />ONLY 텐바이텐만의 프로젝트</p>
						</div>

						<div class="swiper-slide">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/txt_brand.png" alt="지속 가능한 제품과 사용성으로 가치를 만들어가는 250 디자인" /></p>
						</div>

						<!-- buy -->
						<%
							Dim itemid, oItem
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1761951
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
							<div class="swiper-slide hsp-buy">
								<% If isApp = 1 Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1761951&amp;pEtr=79602'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1761951&amp;pEtr=79602">
								<% End If %>								
									<div class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/img_item_v2.jpg" alt="" /></div>
									<div class="option">
										<%' for dev msg : 상품코드 1761951 할인기간 08.02~08.08 %>
										<p class="name">Re:air</p>
										<p class="txt"><b>SIZE :</b> 180 x 180 x 287 (mm)<span>|</span><b>COLOR :</b> White<br /><b>Composition :</b> 본체, 아답터, 제습 / 가습필터</p>
										<% If oItem.FResultCount > 0 then %>
											<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong>
												</div>
											<% else %>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% end if %>
										<% end if %>
										<div class="btn-go">구매하러 가기<i></i></div>
										<p class="noti">※ 예약배송 상품으로 8/18 (금) 일괄 배송됩니다.</p>
									</div>
								</a>
							</div>
						<% Set oItem = Nothing %>

						<div class="swiper-slide hsp-feature">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/txt_feature.png" alt="리에어는 상단에 있는 팬 모듈을 뒤집어서 공기의 흐름을 바꿔줄 수 있습니다. 그 원리를 이용해 가습과 제습을 할 수 있는 제품입니다." /></p>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/img_feature.gif" alt="" /></div>
						</div>

						<!-- story -->
						<div class="swiper-slide hsp-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/img_story_1.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/txt_desc_1.png" alt="#뒤집다" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/img_story_2.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/txt_desc_2.png" alt="#안전하다" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/img_story_3.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/txt_desc_3.png" alt="#재사용하다" /></p>
						</div>
						<div class="swiper-slide hsp-desc">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/img_story_4.jpg" alt="" /></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/txt_desc_4.png" alt="#편리하다" /></p>
						</div>

						<div class="swiper-slide">
							<div class="video">
								<video poster="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/img_preview.jpg" src="http://webimage.10x10.co.kr/video/vid770.mp4" controls="true"></video>
							</div>
						</div>

						<div class="swiper-slide">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79602/m/txt_finish.jpg" alt="250 DESIGN 지속 가능한 제품과 사용성으로 가치를 만들어가다." /></div>
						</div>

						<!-- comment Evt -->
						<div class="swiper-slide hsp-finish">
							<p class="txt1"><span>Hey, something project</span>당신이 갖고 싶은 것</p>
							<p class="txt2">Re:air의 기능 중 가장 마음에 드는<br />기능을 적어주세요!<br /><br />정성껏 코멘트를 남겨주신 20분을 추첨하여<br />250디자인의 벽걸이형 자연제습기를<br />선물로 드립니다. (색상랜덤)</p>
							<p class="txt3">기간 : <b>2017.08.02 ~ 08.08</b> / 발표 : <b>08.09</b></p>
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
			<!-- 구매버튼 -->
			<% If isApp="1" Then %>
				<div class="btn-get"><a href="" onclick="fnAPPpopupBrand('dsa250'); return false;">BRAND SHOP<i></i></a></div>
			<% Else %>
				<div class="btn-get"><a href="/street/street_brand.asp?makerid=dsa250">BRAND SHOP<i></i></a></div>
			<% End If %>			
		</div>
		<!-- //main contents -->

		<!-- comment event -->
		<div id="comment-evt" class="section comment-evt">
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
						<h3><span>Hey, something project</span>당신이 갖고 싶은 것</h3>
						<p class="txt">Re:air의 기능 중 가장 마음에 드는 기능을 적어주세요!<br />정성껏 코멘트를 남겨주신 20분을 추첨하여 250디자인의<br />벽걸이형 자연제습기를 선물로 드립니다. (색상랜덤)</p>
						<p class="date">기간 : <b>2017.08.02 ~ 08.08</b> / 발표 : <b>08.09</b></p>
						<div class="inner">
							<ul class="choice">
								<li class="ico ico1" value="1">
									<button type="button">#뒤집다</button>
								</li>
								<li class="ico ico2" value="2">
									<button type="button">#안전하다</button>
								</li>
								<li class="ico ico3" value="3">
									<button type="button">#재사용<br />하다</button>
								</li>
								<li class="ico ico4" value="4">
									<button type="button">#편리하다</button>
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
											#뒤집다
										<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
											#안전하다
										<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
											#재사용<br />하다
										<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>
											#편리하다
										<% Else %>
											#뒤집다
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
									<p class="date">
										<span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span> 
										<% If arrCList(8,intCLoop) <> "W" Then %><span class="mob">모바일에서 작성</span><% end if %>
									</p>
								</div>
							</li>
						<% next %>
					</ul>
					<% IF isArray(arrCList) THEN %>
						<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
					<% end if %>
				<% end if %>
			</div>
		</div>
		<div id="dimmed"></div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->