<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 컬쳐 이벤트 시시한 일상 MA
' History : 2017-11-01 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim oItem, pagereload, classboxcol, cmtYN
dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#
	cmtYN = "Y"
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  67448
Else
	eCode   =  81569
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

if date() < "2017-11-02" then
	if userid="baboytw" or userid="bjh2546" then
		currenttime = #11/02/2017 09:00:00#
	end if
end if

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, ecc
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),10)

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
.swiper {background:url(http://webimage.10x10.co.kr/eventIMG/2017/81569/m/bg_slide.png) 0 0; background-size:100% 100%;}
.swiper button {position:absolute; top:28%; z-index:10; width:6.66%; background-color:transparent;}
.swiper button.btnPrev {left:9%;}
.swiper button.btnNext {right:9%;}
.swiper .pagination {position:absolute; left:0; bottom:16%; z-index:30; width:100%; padding-top:0;}
.swiper .pagination .swiper-pagination-switch {width:0.8rem; height:0.8rem; margin:0 0.5rem; border:0; background:#63789f;}
.swiper .pagination .swiper-active-switch {background:#e6a891;}
.comment-write {padding:0 9.3%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/81569/m/bg_cmt.png) 0 0; background-size:100% auto;}
.comment-write textarea {display:inline-block; width:100%; height:12rem; margin:0; font-size:1.17rem; vertical-align:top; border:1px solid #7d7d7d; border-radius:0;}
.comment-write .btn-submit {width:100%; vertical-align:top;}
.comment-list {padding-bottom:4.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/81569/bg_noise_2.png) 0 0 repeat; background-size:40% auto;}
.comment-list li {margin-bottom:1.28rem; padding:1.45rem 9.6%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/81569/m/bg_cmt.png) 0 0 repeat; background-size:100% auto;}
.comment-list li .writer {position:relative; padding-bottom:1.7rem; font-size:1.1rem; font-weight:600; color:#2d4c72;}
.comment-list li .writer i {display:inline-block; width:1.02rem; height:1.28rem; margin-right:0.4rem; text-indent:-999em; background:url(http://webimage.10x10.co.kr/eventIMG/2017/81569/m/ico_mobile.png) 0 0 repeat; background-size:100% 100%; vertical-align:top;}
.comment-list li .writer strong {display:inline-block; line-height:1.3rem; font-weight:600;}
.comment-list li .writer span {position:absolute; right:0; top:0;}
.comment-list li p {font-size:1.28rem; line-height:1.3; color:#333;}

.noti {padding:3.3rem 7.2%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/81569/m/bg_noti.png) 0 0; background-size:100% auto;}
.noti h3 {padding-bottom:1.88rem; text-align:center; font-size:1.7rem; color:#dfd2c8;}
.noti h3 strong {border-bottom:0.15rem solid #dfd2c8;}
.noti li {position:relative; color:#fff; font-size:1.2rem; line-height:1.5; padding-left:1.4rem;}
.noti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.6rem; width:0.5rem; height:0.15rem; background:#fff;}

.pagingV15a {margin-top:2.22rem; text-align:center;}
.pagingV15a span {display:inline-block; width:2.35rem; height:2.35rem; margin:0 0.77rem; color:#fff; border:0;}
.pagingV15a span.arrow {position:relative; top:0.4rem; width:1.54rem; height:1.54rem; border:0; background-image:url(http://fiximage.10x10.co.kr/m/2017/common/bg_sp_arrow.png?v=1.57); background-position:-7.55rem -9.56rem; background-repeat:no-repeat; background-size:17.07rem auto; text-indent:-9999em; background-color:transparent;}
.pagingV15a span a {display:block; width:100%; height:100%; padding-top:0; color:#fff !important; font:1.37rem/2.4rem 'AvenirNext-Regular', 'RobotoRegular', sans-serif;}
.pagingV15a .prevBtn {margin-right:0.09rem; transform:rotateY(180deg); -webkit-transform:rotateY(180deg);}
.pagingV15a .nextBtn {margin-left:0.26rem;}
.pagingV15a span.current {position:relative; color:#fff; font-family:'AvenirNext-DemiBold'; font-weight:normal; background:#2d4c72; border-radius:50%;}
</style>
<script type="text/javascript">
$(function(){
	slideTemplate = new Swiper('.swiper .swiper-container',{
		loop:true,
		autoplay:3000,
		speed:700,
		pagination:".swiper .pagination",
		nextButton:'.swiper .btnNext',
		prevButton:'.swiper .btnPrev',
		effect:'fade'
	});
});

$(function(){
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",300);
	<% else %>
		setTimeout("pagup()",300);
	<% end if %>
});

function pagup(){
	window.$('html,body').animate({scrollTop:$(".mEvt81569").offset().top}, 0);
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
		<% If not( left(currenttime,10)>="2017-11-02" and left(currenttime,10)<"2017-11-14" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("한 ID당 최대 5번까지 참여할 수 있습니다.");
				return false;
			<% else %>
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 600 || frm.txtcomm1.value == '띄어쓰기 포함 최대 한글 300자 이내로 적어주세요'){
					alert("띄어쓰기 포함\n최대 한글 300자 이내로 적어주세요.");
					frm.txtcomm1.focus();
					return false;
				}
				frm.txtcomm.value = frm.txtcomm1.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	}
}

function jsevtchk(){
	<% If not( left(currenttime,10)>="2017-11-02" and left(currenttime,10)<"2017-11-14" ) Then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
		var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript81569.asp",
			data: "mode=1mon",
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="11")
				{
					alert('응모가 완료 되었습니다.');
				}
				else if (result.resultcode=="44")
				{
					<% If isapp="1" Then %>
						parent.calllogin();
						return;
					<% else %>
						parent.jsevtlogin();
						return;
					<% End If %>
				}
				else if (result.resultcode=="77")
				{
					alert('이미 응모 하셨습니다.');
					return false;
				}
				else if (result.resultcode=="88")
				{
					alert("이벤트 기간이 아닙니다.");
					return;
				}
			}
		});
	<% end if %>
}
</script>
	<div class="mEvt81569">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/tit_poem.png" alt="詩詩한 일상 With. 박성우 시인" /></h2>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/img_book.jpg" alt="쓸쓸한 밤에 닿아도 우리는 웃을 수 있다" /></div>
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/txt_slide_1.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/txt_slide_2.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/txt_slide_3.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/txt_slide_4.png" alt="" /></div>
				</div>
				<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/btn_next.png" alt="다음" /></button>
				<div class="pagination"></div>
			</div>
		</div>
		<div class="event1">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/tit_event_1.png" alt="컬쳐콘서트에 초대합니다" /></h3>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/txt_book_talk.jpg" alt="도처에서 반짝거리는 일상을 한편의 시로 만드는 시인 박성우" /></div>
			<h4><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/txt_comment_event.png" alt="COMMENT EVENT - 가장 좋아하는 시를 소개해주세요!" /></h4>

			<!-- 코멘트 작성 -->
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
			<div class="comment-write">
				<textarea cols="30" rows="5" name="txtcomm1" id="txtcomm1" placeholder="한글 300자 이내로 입력해주세요!" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
				<button type="submit" class="btn-submit" onclick="jsSubmitComment(document.frmcom); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/btn_comment.png" alt="코멘트 응모하기" /></button>
			</div>
			</form>
			<form name="frmdelcom" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="pagereload" value="ON">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= eCode %>">
			<input type="hidden" name="isApp" value="<%= isApp %>">
			</form>
			
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/bg_box.png" alt="" /></div>
			<!-- 코멘트 목록 -->
			<% if cmtYN = "Y" then %>
				<% IF isArray(arrCList) THEN %>
					<div class="comment-list" id="commentevt">
						<ul>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
								<li>
									<div class="writer">
										<strong>
											<% If arrCList(8,intCLoop) <> "W" Then %><i>모바일에서 작성</i><% end if %>
											<%=printUserId(arrCList(2,intCLoop),2,"*")%>
											<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
												<a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="btnDel"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68254/m/boxtape_cmt_del.png" alt="삭제" style="width:1rem;" /></a>
											<% end if %>
										</strong>
										<span class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span>
									</div>
									<p><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
								</li>
							<% next %>
						</ul>
						<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
					</div>
				<% end if %>
			<% end if %>
		</div>
		<div class="event2">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/tit_event_2.png" alt="시요일 이용권을 선물로 드립니다." /></h3>
			<button type="submit" onclick="jsevtchk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/btn_1month.png" alt="1개월 이용권 응모하기" /></button>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/txt_siyoil.jpg" alt="세상의 모든 시 당신을 위한 시 한편 詩 날마다 시요일" /></p>
		</div>
		<div class="item">
			<a href="/category/category_itemPrd.asp?itemid=1825013&pEtr=81569" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/img_sale.jpg" alt="시요일 1년 이용권 + 특별판 시집 5권 구매하기" /></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1825013&pEtr=81569" onclick="fnAPPpopupProduct('1825013&pEtr=81569');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/81569/m/img_sale.jpg" alt="시요일 1년 이용권 + 특별판 시집 5권 구매하기" /></a>
		</div>
		<div class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>오직 텐바이텐 회원님을 위한 이벤트 입니다.<br />(로그인 후 참여가능, 비회원 참여 불가)</li>
				<li>이벤트 경품은 내부 사정에 의해 변경될 수 있습니다.</li>
				<li>당첨자와 수령자는 동일해야 하며, 양도는 불가합니다.</li>
				<li>정확한 발표를 위해 마이텐바이텐의 개인정보를 업데이트 해주세요.</li>
				<li>이벤트 종료 후 당첨된 경품의 교환 및 변경은 불가 합니다.</li>
			</ul>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->