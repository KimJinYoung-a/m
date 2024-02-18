<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/instagrameventCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : [SNS] #자랑스타그램
' History : 2017-11-23 정태훈
'####################################################
Dim eCode, userid, pagereload, i
dim iCCurrpage, iCTotCnt, eCC, iCPageSize, iCTotalPage
IF application("Svr_Info") = "Dev" THEN
	eCode   =  67464
Else
	eCode   =  82223
End If

iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	
IF iCCurrpage = "" THEN iCCurrpage = 1
IF iCTotCnt = "" THEN iCTotCnt = -1

eCC = requestCheckVar(Request("eCC"), 1)
pagereload	= requestCheckVar(request("pagereload"),2)
userid		= GetEncLoginUserID()

iCPageSize = 4		'한 페이지의 보여지는 열의 수

dim oinstagramevent
set oinstagramevent = new Cinstagrameventlist
	oinstagramevent.FPageSize	= iCPageSize
	oinstagramevent.FCurrPage	= iCCurrpage
	oinstagramevent.FTotalCount		= iCTotCnt  '전체 레코드 수
	oinstagramevent.FrectIsusing = "Y"
	oinstagramevent.FrectEcode = eCode
	oinstagramevent.fnGetinstagrameventList

	iCTotCnt = oinstagramevent.FTotalCount '리스트 총 갯수
	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>
<style type="text/css">
.section {position:relative;}
.section a {overflow:hidden; display:block; position:absolute;}
.topic a {right:0; bottom:24%; width:28.13%;}
.item a {left:5%; top:25%; width:90%; height:37%; text-indent:-999em;}
.howto a {left:5%; top:14%; width:90%; height:22%; text-indent:-999em;}
.instagram {padding-bottom:3.1rem; background-color:#fff;}
.instagram ul {overflow:hidden; width:29.2rem; margin:0 auto;}
.instagram ul li {float:left; width:13.1rem; margin:1.15rem 0.75rem;}
.instagram ul li img {width:13.1rem; height:13.1rem;}
.instagram ul li .id {display:block; height:1.6rem; margin-top:1.02rem; padding:0 0.5rem; color:#767676; font-size:1rem; line-height:1.313em; text-align:center;}
.instagram ul li .id span {overflow:hidden; display:inline-block; max-width:40%; text-overflow:ellipsis; white-space:nowrap; color:#f93e75; vertical-align:top;}
.pagingV15a .current {color:#f93e75;}
.noti {padding:2.5rem 2.43rem 2.4rem; background-color:#eee; text-align:center;}
.noti h3 {display:inline-block; position:relative; padding-bottom:0.5rem; color:#9441bf; font-size:1.54rem; font-weight:bold; line-height:1em;}
.noti h3:after {content:' '; display:block; position:absolute; top:100%; left:0; width:100%; height:0.13rem; background-color:#9441bf;}
.noti ul {margin-top:2.13rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#333; font-size:1.19rem; line-height:1.5em; text-align:left;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.4rem; height:0.1rem; background-color:#333;}
</style>
<script type="text/javascript">
$(function(){
	<% if Request("eCC")<>"" then %>
		setTimeout("pagedown()",300);
	<% end if %>
});

$(function(){
	mySwiper = new Swiper('#rolling .swiper-container',{
		loop:true,
		autoplay:3000,
		speed:600,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		effect:"fade"
	});
});


function pagedown(){
	window.$('html,body').animate({scrollTop:$("#instagramlist").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}
</script>
			<div class="mEvt82223">
				<div class="section topic">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/82223/m/tit_boastagram.jpg" alt="인스타그램 인증샷 이벤트 #자랑스타그램" /></h2>
					<a href="https://www.instagram.com/your10x10/" title="텐바이텐  공식 인스타그램으로 이동" target="_blank" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82223/m/ico_instargram.png"  alt="텐바이텐 공식 인스타그램 @your10x10 으로 이동" /></a>
					<a href="javascript:fnAPPpopupExternalBrowser('https://www.instagram.com/your10x10/');" title="텐바이텐  공식 인스타그램으로 이동" target="_blank" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82223/m/ico_instargram.png"  alt="텐바이텐 공식 인스타그램 @your10x10 으로 이동" /></a>
				</div>
				<div class="section item">
					<a href="/category/category_itemprd.asp?itemid=1812564&pEtr=82223" title="모나미 플러스펜 24색 세트" target="_blank" class="mWeb">모나미 플러스펜 24색 세트</a>
					<a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1812564&pEtr=82223" onclick="fnAPPpopupProduct('1812564&amp;pEtr=82223');return false;" title="모나미 플러스펜 24색 세트" target="_blank" class="mApp">모나미 플러스펜 24색 세트</a>
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/82223/m/img_boastagram_item.jpg" alt="2018 다이어리 사은품을 인스타그램에 자랑해주세요! 추첨을 통해 모나미 플러스펜 24색 세트를 20분께 드립니다." />
				</div>
				<div class="section howto">
					<a href="/diarystory2018/?pEtr=82223" title="텐바이텐에서 다이어리 구매하기" target="_blank" class="mWeb">텐바이텐에서 다이어리 구매하기</a>
					<a href=""" title="텐바이텐에서 다이어리 구매하기" onclick="fnAPPpopupBrowserURL('2018 다이어리','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2018/?pEtr=82223');" target="_blank" class="mApp">텐바이텐에서 다이어리 구매하기</a>
					<!--a href="javascript:fnAPPpopupBrowserURL('2018 다이어리','/apps/appCom/wish/web2014/diarystory2018/?pEtr=82223');" title="텐바이텐에서 다이어리 구매하기" target="_blank" class="mApp">텐바이텐에서 다이어리 구매하기</a-->
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/82223/m/img_boastagram_howto.jpg" alt="이벤트 참여방법 : 텐텐에서 다이어리구매하기 - [2018 다이어리 스토리] 사으품 사진찍기 - 필수 해시태그 포함하여 인스타그램에 업로드하기" />
				</div>
				<div>
					<a href="/diarystory2018/gift.asp?pEtr=82223" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82223/m/img_boastagram_gift.jpg" alt="텐바이텐 X 문라잇 펀치 로맨스 2018 Diary Story 구매사은품 : 마스킹테이프 / 홀로그램 파일 / 메모판 + 자석" /></a>
					<a href="" onclick="fnAPPpopupBrowserURL('사은품','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2018/gift.asp');" target="_blank" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82223/m/img_boastagram_gift.jpg" alt="텐바이텐 X 문라잇 펀치 로맨스 2018 Diary Story 구매사은품 : 마스킹테이프 / 홀로그램 파일 / 메모판 + 자석" /></a>
					<!--a href="javascript:fnAPPpopupBrowserURL('사은품','/apps/appCom/wish/web2014/diarystory2018/?pEtr=82223');" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82223/m/img_boastagram_gift.jpg" alt="텐바이텐 X 문라잇 펀치 로맨스 2018 Diary Story 구매사은품 : 마스킹테이프 / 홀로그램 파일 / 메모판 + 자석" /></a-->

					

				</div>
				<!-- instagram -->
				<% if oinstagramevent.fresultcount > 0 then %>
				<div class="instagram" id="instagramlist">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/82223/m/tit_boastagram_totenten.png" alt="텐바이텐에 도착한 #자랑스타그램" /></h3>
					<p class="ct">
						<a href="https://www.instagram.com/your10x10/" title="텐바이텐  공식 인스타그램으로 이동" target="_blank" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82223/m/btn_go_instargram.png" alt="텐바이텐 X 문라잇 펀치 로맨스 2018 Diary Story 구매사은품 : 마스킹테이프 / 홀로그램 파일 / 메모판 + 자석" style="width:50%;" /></a>
						<a href="javascript:fnAPPpopupExternalBrowser('https://www.instagram.com/your10x10/');" title="텐바이텐  공식 인스타그램으로 이동" target="_blank" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82223/m/btn_go_instargram.png" alt="텐바이텐 X 문라잇 펀치 로맨스 2018 Diary Story 구매사은품 : 마스킹테이프 / 홀로그램 파일 / 메모판 + 자석" style="width:50%;" /></a>
					</p>
					<ul>
						<% for i = 0 to oinstagramevent.fresultcount-1 %>
						<li>
							<img src="<%= oinstagramevent.FItemList(i).Fimgurl %>" alt="" />
							<!-- for dev msg : 아이디 ** 처리해주세요  -->
							<span class="id"><span><%=printUserId(left(oinstagramevent.FItemList(i).Fuserid,10),2,"*")%></span>님의<br />자랑스타그램</span>
						</li>
						<% next %>
					</ul>
					<!-- pagination -->
					<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,5,"jsGoComPage")%>
				</div>
				<% end if %>
				<div class="noti">
					<h3>이벤트 유의사항</h3>
					<ul>
						<li>인스타그램 계정이 비공개 일 경우 이벤트 참여에 제외됩니다.</li>
						<li>이벤트에 참여한 인증샷은 고객 동의 없이 이벤트 페이지 내에 노출될 수 있습니다.</li>
						<li>이벤트 페이지 내에 노출되는 SNS인증샷은 실시간 적용되지 않습니다.</li>
						<li>SNS 이벤트에 참여하였더라도 이벤트 페이지 내에 노출되지 않을 수 있습니다.</li>
						<li>이벤트 페이지 내에 SNS인증샷 노출여부는 이벤트 당첨 여부와 무관합니다.</li>
						<li>이벤트 일정 및 당첨 상품 등은 당사 사정에 따라 부득이하게 변경 될 수 있습니다.</li>
					</ul>
				</div>
			</div>
<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
<input type="hidden" name="iCTot" value=""/>
<input type="hidden" name="eCC" value="1">
</form>
<% set oinstagramevent = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->