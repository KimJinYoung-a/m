<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : hey, something project 시리즈 99
' 미키와 미니의 양말셋트
' History : 2017-12-12 정태훈 생성
'###########################################################
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
	eCode   =  67491
Else
	eCode   =  82986
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

if userid = "baboytw" or userid = "baboytwtest1" or userid = "baboytw55" or userid = "baboytw56" or userid = "baboytw1" or userid = "chaem35" or userid = "answjd248" or userid = "corpse2" or userid = "jinyeonmi" then
	currenttime = #12/13/2017 09:00:00#
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
.finish-event {display:none;}
.hsp-buy {font-family:'AvenirNext-Regular', 'AppleSDGothicNeo-Regular', 'RobotoRegular', 'Noto Sans', sans-serif;}
.hsp-buy a {display:block;}
.hsp-buy .name {display:block; color:#000; font-size:1.7rem; font-weight:normal !important; line-height:1.7rem;}
.hsp-buy .price {font-size:1.6rem;}
.hsp-buy .price s {display:inline !important;}

.heySomethingV17 .hsp-desc p {position:relative; margin-bottom:0; opacity:1; transition:none;}

.heySomethingV17 .hsp-finish {padding-top:9.9rem;}
.heySomethingV17 .article .btn-go {margin-top:2.6rem;}

.heySomethingV17 .comment-write .txt {padding-right:0;}
.choice li:nth-child(n+5) {margin-top:0.55rem;}
.heySomethingV17 .comment-evt .ico {width:5.2rem; height:9.5rem; margin-right:1.9rem; background-repeat:no-repeat; background-position:0 0; background-size:100% 100%; text-indent:-999em;}
.heySomethingV17 .comment-evt .ico1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/ico_comment_01_off.png);}
.heySomethingV17 .comment-evt .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/ico_comment_02_off.png);}
.heySomethingV17 .comment-evt .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/ico_comment_03_off.png);}
.heySomethingV17 .comment-evt .on,
.heySomethingV17 .comment-list .ico {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/ico_comment_01_on.png);}
.heySomethingV17 .comment-evt .ico2.on,
.heySomethingV17 .comment-list .ico2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/ico_comment_02_on_v1.png);}
.heySomethingV17 .comment-evt .ico3.on,
.heySomethingV17 .comment-list .ico3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/ico_comment_03_on_v1.png);}
.heySomethingV17 .comment-write .choice li.on:after,
.heySomethingV17 .comment-write .choice li.on:before {background:none;}
.heySomethingV17 .comment-evt .comment-list .ico {left:0.5rem; margin-top:-4.75rem;}
.heySomethingV17 .comment-evt .comment-list li {min-height:12rem;}
.heySomethingV17 .comment-evt strong {font-weight:normal;}
</style>
<script type="text/javascript">
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

	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
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
		<% If not( left(currenttime,10)>="2017-12-06" and left(currenttime,10)<"2017-12-26" ) Then %>
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
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/img_represent.jpg" alt="" /></div>
								</div>

								<!-- about -->
								<div class="swiper-slide hsp-about">
									<h3>About</h3>
									<p class="txt1">Hey,<br />something<br />project</p>
									<p class="txt2">텐바이텐만의 시각으로<br />주목해야 할 상품을 선별해 소개하고<br />새로운 트렌드를 제안하는<br />ONLY 텐바이텐만의 프로젝트</p>
								</div>
								<%
								Dim itemid, oItem
								IF application("Svr_Info") = "Dev" THEN
									itemid = 786868
								Else
									itemid = 1855690
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
								%>
								<!-- buy -->
								<div class="swiper-slide hsp-buy">
								<% If isApp = 1 Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1855690&amp;pEtr=82986'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1855690&amp;pEtr=82986">
								<% End If %>
										<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/img_item.jpg" alt="" /></div>
										<div class="option">
											<p class="name">Mickey &amp; Minnie<br /> Socks Set</p>
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
								<div class="swiper-slide">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/img_visual.jpg" alt="DISNEY Mickey &amp; Minnie Socks Set" /></p>
								</div>
								<div class="swiper-slide">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/img_brand.jpg" alt="DISNEY and 텐바이텐 크리스마스에 더욱 어울리는 커플양말 셋트, 우정양말로도 좋아요. 특별한 날 신으면 더욱 특별해 보이는 미키와 미니의 양말 셋트를 만나보세요! 산타를 기다리며 걸어두는 것도 좋겠죠?" /></p>
								</div>
								<div class="swiper-slide">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/img_gift_01.jpg" alt="GIFT FOR LOVE" /></p>
								</div>
								<div class="swiper-slide">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/img_gift_02.jpg" alt="Happy Christmas with" /></p>
								</div>

								<!-- story -->
								<div class="swiper-slide hsp-desc">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/img_story_01.jpg" alt="크리스마스, 트리에 걸고 싶은 소원은 무엇인가요?" /></p>
								</div>
								<div class="swiper-slide hsp-desc">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/img_story_02.jpg" alt="#사랑 새해에는 진정한 사랑을 만나게 해주세요! 내 사람과 진정한 사랑을 하고 싶어요!" /></p>
								</div>
								<div class="swiper-slide hsp-desc">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/img_story_03.jpg" alt="#건강 새해에는 에너지 넘치는 나, 건강한 나를 만나고 싶어요!!" /></p>
								</div>
								<div class="swiper-slide hsp-desc">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/img_story_04.jpg" alt="#돈 새해에는 돈 많이 많이~ 벌게 해주세요!" /></p>
								</div>

								<div class="swiper-slide">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/82986/m/img_finish.jpg" alt="텐바이텐의 감성과 만난 디즈니의 귀여운 미키와 미니!" /></p>
								</div>

								<!-- comment Evt -->
								<div class="swiper-slide hsp-finish">
									<p class="txt1"><span>Hey, something project</span> 트리에 걸고 싶은 소원</p>
									<p class="txt2">새해에 원하는 소원 하나 골라주세요!<br /> 코멘트 써주신 분 5분을 뽑아<br /> 디즈니 양말셋트를 드립니다.</p>
									<p class="txt3">기간 : <b>2017.12.13 ~ 12.19</b> / 발표 : <b>12.22</b></p>
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
					<% If isApp = 1 Then %>
					<div class="btn-get"><a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1855690&amp;pEtr=82986'); return false;" title="Mickey &amp; Minnie Socks Set">BUY<i></i></a></div>
					<% Else %>
					<div class="btn-get"><a href="/category/category_itemPrd.asp?itemid=1855690&amp;pEtr=82986" title="Mickey &amp; Minnie Socks Set">BUY<i></i></a></div>
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
								<h3><span>Hey, something project</span> 트리에 걸고 싶은 소원</h3>
								<p class="txt">정성껏 코멘트를 남겨주신 5분을 추첨하여<br /> 디즈니 양말 셋트를 선물로 드립니다.</p>
								<p class="date">기간 : <b>2017.12.13 ~ 12.19</b> / 발표 : <b>12.22</b></p>
								<div class="inner">
									<ul class="choice">
										<li class="ico ico1" value="1"><button type="button">사랑</button></li>
										<li class="ico ico2" value="2"><button type="button">건강</button></li>
										<li class="ico ico3" value="3"><button type="button">돈</button></li>
									</ul>
									<div class="field">
										<textarea title="코멘트 작성" cols="60" rows="5" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> title="코멘트 작성" cols="60" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
										<input type="submit" value="응모하기" class="btnsubmit" onclick="jsSubmitComment(document.frmcom); return false;" />
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
								<div class="ico ico<%= split(arrCList(1,intCLoop),"!@#")(0) %>"><strong>
								<% If split(arrCList(1,intCLoop),"!@#")(0)="1" Then %>
								사랑
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>
								건강
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>
								돈
								<% Else %>
								사랑
								<% End if %>	
								</strong></div>
								<% End if %>
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
									<p class="date"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span> / <span><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></span><% If arrCList(8,intCLoop) <> "W" Then %> <span class="mob">모바일에서 작성</span><% end if %></p>
								</div>
							</li>
							<% next %>
						</ul>
						<% end if %>
						<div class="paging pagingV15a">
							<% IF isArray(arrCList) THEN %>
							<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
							<% end if %>
						</div>
					</div>
				</div>
				<div id="dimmed"></div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->