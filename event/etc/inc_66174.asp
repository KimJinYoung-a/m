<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  러브하우스
' History : 2015.09.17 유태욱
'####################################################
%> 
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/contest/classes/contestCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event66174Cls.asp" -->

<%
Dim vGubun, i, evt_code, modifycode
dim myidx, mydiv, myimgFile2, myimgFile3, myimgFile4, myimgFile5, myopt, myimgContent

g_Contest = CStr(requestCheckVar(request("g_Contest"),10))

IF application("Svr_Info") = "Dev" THEN
	evt_code   =  64888
	modifycode	=	64890
Else
	evt_code   =  66174
	modifycode	=	66351								''''''''''''''''''''실섭 어드민에 등록 후 코드수정
End If

IF application("Svr_Info") = "Dev" THEN
	g_Contest = "con56"
Else
	g_Contest = "con62"
End If

if g_Contest="" then
	Response.Write "<script language='javascript'>"
	Response.Write "	alert('정상적인 페이지가 아닙니다.');"
	Response.Write "</script>"
	dbget.close()	:	Response.End
end if

dim vPageSize, vPage, vArrList, vTotalCount, vTotalPage, iCPerCnt, vIsPaging
	vPage = getNumeric(requestCheckVar(Request("page"),5))
	If vPage = "" Then vPage = 1 End If

	vIsPaging = requestCheckVar(Request("paging"),1)
	vPageSize = 3
	iCPerCnt = 4
dim C66174
set C66174 = new Cevent66174_list
	C66174.FPageSize = vPageSize
	C66174.FCurrPage = vPage
	C66174.FRectEventID = evt_code
	C66174.FRectUserid = userid
	C66174.fnEvent_66174_List
	vTotalCount = C66174.FTotalCount

	sqlstr = "select top 1 idx, div, imgFile2, imgFile3, imgFile4, imgFile5, opt, imgContent "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_contest_entry]"
	sqlstr = sqlstr & " where userid='"& userid &"' And optText='"& evt_code &"' And div='"&g_Contest&"' "
	sqlstr = sqlstr & " order by idx desc "
	rsget.Open sqlstr, dbget, 1

	If Not rsget.Eof Then
		myidx = rsget(0)
		mydiv = rsget(1)
		myimgFile2 = rsget(2)
		myimgFile3 = rsget(3)
		myimgFile4 = rsget(4)
		myimgFile5 = rsget(5)
		myopt = rsget(6)
		myimgContent = rsget(7)
	End IF
	rsget.close
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt66174 h2 {position:relative;}
.mEvt66174 h2:after {content:' '; display:inline-block; position:absolute; left:0; top:0; width:100%; height:14px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bg_lace.png) 0 0 repeat-x; background-size:53px 14px;}
.swiperWrap {position:relative; padding:1% 6.25% 12.5%; background:#f8dcde;}
.swiper {padding:5px;background:#fff;}
.swiper button {display:inline-block; position:absolute; top:32%; width:8.75%; background:transparent; z-index:50;}
.swiper .prev {left:2%;}
.swiper .next {right:2%;}
.swiper .bPagination {position:absolute; bottom:11%; left:0; width:100%; height:7px; text-align:center; z-index:100;}
.swiper .bPagination span {display:inline-block; width:7px; height:7px; margin:0 4px; cursor:pointer; vertical-align:top; background:#fff; border-radius:50%;}
.swiper .bPagination .swiper-active-switch {background:#f8675a;}
.styleTxt01 {background-position:0 0;}
.styleTxt02 {background-position:0 25%;}
.styleTxt03 {background-position:0 50%;}
.styleTxt04 {background-position:0 75%;}
.styleTxt05 {background-position:0 100%;}
#styleNum {position:absolute; left:27.5%; top:-4%; width:45%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/66174/m/txt_style.png); background-repeat:no-repeat; background-size:100% 500%; z-index:100;}
.aboutWoozoo {position:relative;}
.aboutWoozoo a {display:block; position:absolute; left:28%; bottom:12%; width:44%; height:18%; font-size:0; line-height:0; color:transparent;}
.applyLoveHouse {position:relative;}
.applyLoveHouse a {display:block; position:absolute; left:18%; bottom:19%; width:64%; height:26%; font-size:0; line-height:0; color:transparent;}
.houseList {background:#f4f7f7;}
.houseList ul {overflow:hidden; padding:20px 0 15px;}
.houseList li {position:relative; width:264px; height:235px; padding-top:75px; margin:0 auto 25px; text-align:center; background-position:0 0; background-repeat:no-repeat; background-size:100% 100%;}
.houseList li.h01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bg_house_01.gif);}
.houseList li.h02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bg_house_02.gif);}
.houseList li.h03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bg_house_03.gif);}
.houseList li .writer {width:121px; height:21px; text-align:center; color:#666; font-size:11px; line-height:24px; margin:0 auto 15px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bg_writer.png) 0 0 no-repeat; background-size:100% 100%;}
.houseList li .writer img {vertical-align:middle; width:6px; margin:-2px 3px 0;}
.houseList li .story {overflow-y:auto; width:75%; height:90px; margin:0 auto; font-size:11px; line-height:18px; color:#000; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bg_note.gif) 0 0 repeat; background-size:2px 126px; -webkit-overflow-scrolling:touch;}
.houseList li .num {padding-top:10px; color:#666; font-size:11px; line-height:11px;}
.houseList li .num span {padding:0 10px;}
.houseList li .num span:first-child {position:relative;}
.houseList li .num span:first-child:after {content:' '; display:inline-block; position:absolute; right:0; top:1px; width:1px; height:9px; background:#666;}
.houseList li .btnDel {position:absolute; left:198px; top:75px; width:22px; z-index:30; background:transparent;}
@media all and (min-width:375px){
	.houseList li {width:310px; height:275px; padding-top:75px; margin:0 auto 25px;}
	.houseList li .story {height:126px;}
	.houseList li .btnDel {left:220px;}
}
@media all and (min-width:480px){
	.mEvt66174 h2:after {height:21px; background-size:80px 21px;}
	.swiper .bPagination {height:11px;}
	.swiper .bPagination span {width:11px; height:11px; margin:0 6px;}
	.houseList ul {padding:30px 0 23px;}
	.houseList li {width:396px; height:352px; padding-top:113px; margin:0 auto 38px;}
	.houseList li .writer {width:181px; height:31px; font-size:17px; line-height:38px; margin:0 auto 23px;}
	.houseList li .writer img {width:9px; margin:-3px 4px 0;}
	.houseList li .story {height:127px; font-size:17px; line-height:25px; padding-top:2px; background-size:3px 177px;}
	.houseList li .num {padding-top:15px; font-size:17px; line-height:17px;}
	.houseList li .num span {padding:0 15px;}
	.houseList li .num span:first-child:after {height:13px;}
	.houseList li .btnDel {left:297px; top:113px; width:33px;}
}
</style>
<script type="text/javascript">
function jsGoPage(a) {
	frmGubun2.page.value = a;
	frmGubun2.submit();
}

$(function(){
	$('#styleNum').addClass('styleTxt01');
	showSwiper= new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.bPagination',
		paginationClickable:true,
		autoplay:false,
		speed:400,
		nextButton: '.next',
		prevButton: '.prev',
		onSlideChangeStart: function(swiper){
			$('#styleNum').removeClass();
			if ($('.swiper-slide-active').is(".space01")) {
				$('#styleNum').addClass('styleTxt01');
			}
			if ($('.swiper-slide-active').is(".space02")) {
				$('#styleNum').addClass('styleTxt02');
			}
			if ($('.swiper-slide-active').is(".space03")) {
				$('#styleNum').addClass('styleTxt03');
			}
			if ($('.swiper-slide-active').is(".space04")) {
				$('#styleNum').addClass('styleTxt04');
			}
			if ($('.swiper-slide-active').is(".space05")) {
				$('#styleNum').addClass('styleTxt05');
			}
		}
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		showSwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		showSwiper.swipeNext()
	});
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
		showSwiper.reInit();
		clearInterval(oTm);
		}, 1);
	});
});

function jsDelComment(idx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.mode.value = 'del';
		document.frmdelcom.idx.value = idx;
   		document.frmdelcom.submit();
	}
}

function jssubcon(evt){
	<% If IsUserLoginOK() Then %>
		<% if isApp then %>
			fnAPPpopupEvent(evt);
		<% else %>
			parent.location.href='/event/eventmain.asp?eventid='+evt;
		<% end if %>
	<% else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% end if %>
}

</script>
	<!-- 2015웨딩기획전 : 러브하우스 -->
	<div class="mEvt66174">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/tit_love_house_v2.gif" alt="러브하우스" /></h2>
		<div class="swiperWrap">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide space01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/img_slide01.jpg" alt="" /></div>
						<div class="swiper-slide space02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/img_slide02.jpg" alt="" /></div>
						<div class="swiper-slide space03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/img_slide03.jpg" alt="" /></div>
						<div class="swiper-slide space04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/img_slide04.jpg" alt="" /></div>
						<div class="swiper-slide space05"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/img_slide05.jpg" alt="" /></div>
					</div>
				</div>
				<div class="bPagination"></div>
				<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/btn_prev.png" alt="이전" /></button>
				<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/btn_next.png" alt="다음" /></button>
			</div>
			<p id="styleNum"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bg_slide_txt.png" alt="" /></p>
		</div>
		<div class="aboutWoozoo">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/txt_about_woozoo.gif" alt="WOOZOO" /></p>
			<a href="http://www.woozoo.kr/front/main.do" target="_blank">홈페이지 바로가기</a>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/txt_process.gif" alt="일정소개" /></div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/txt_event_noti.gif" alt="이벤트 공지사항" /></div>
		<div class="applyLoveHouse">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/txt_apply.gif" alt="당신이 주인공이 되고 싶다면 지금 바로 신청하세요!" /></p>
			<a href="" onclick="jssubcon('<%= modifycode %>'); return false;">신청하기</a>
		</div>
		<!-- 사연 목록 -->
		<a name="cmtListList"></a>
		<% If C66174.FResultCount > 0 Then %>
		<div class="houseList">
			<ul>
			<% For i = 0 to C66174.FResultCount -1 %>
				<%
				dim renloop
				randomize
				renloop=int(Rnd*3)+1
				%>
					<li class="h0<%= renloop %>">
						<p class="writer">
							<% if C66174.FItemList(i).FoptText = "M" then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/ico_mobile.gif" alt="모바일에서 작성" />
							<% end if %>
							<%=printUserId(C66174.FItemList(i).Fuserid,2,"*")%>
						</p>
						<p class="story"><%=db2html(C66174.FItemList(i).Fimgcontent)%></p>
						<p class="num">
							<span>no.<%=vTotalCount-i-(vPageSize*(VPage-1))%></span><span><%=FormatDate(C66174.FItemList(i).Fregdate,"0000.00.00")%></span>
						</p>
						<% If userid = C66174.FItemList(i).Fuserid Then %>
							<button class="btnDel" onclick="jsDelComment('<%=C66174.FItemList(i).Fidx %>')"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/btn_delete.gif" alt="삭제" /></button>
						<% end if %>
					</li>
				<% Next %>
			</ul>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bg_double_line.gif" alt="" /></div>
				<%= fnDisplayPaging_New(vPage,vTotalCount,vPageSize,iCPerCnt,"jsGoPage") %>
		</div>
		<% end if %>
		<!--// 사연 목록 -->
		<div class="tMar30"><a href="eventmain.asp?eventid=66144"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bnr_wedding_best.jpg" alt="리빙 베스트 브랜드! 최고의 혜택 보러가기" /></a></div>
	</div>
	<!-- 2015웨딩기획전 : 러브하우스 -->
<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript66174.asp" style="margin:0px;">
<input type="hidden" name="div" value="<%=g_Contest%>">
<input type="hidden" name="idx" value="">
<input type="hidden" name="ecode" value="<%=evt_code%>">
<input type="hidden" name="mode" value="">
<input type="hidden" name="isapp" value="<%=isApp %>">
</form>
<form name="frmGubun2" method="post" action="#cmtListList" style="margin:0px;">
<input type="hidden" name="page" value="<%=vPage%>">
<input type="hidden" name="paging" value="o">
</form>
<% set C66174=nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->