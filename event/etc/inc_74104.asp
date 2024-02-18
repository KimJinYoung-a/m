<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [컬쳐] 도서만찬
' History : 2016-11-08 원승현 생성
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
	eCode   =  66229
Else
	eCode   =  74104
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
img {vertical-align:top;}

.mainTit {background-color:#f1e4ba;}

.mApp {display:none;}
.swiper {position:relative;}
.swiper .pagination {position:absolute; bottom:4.56%; padding:0; z-index:20; width:100%; text-align:center; height:0.5rem;}
.swiper .pagination .swiper-pagination-switch {width:0.5rem; height:0.5rem; margin:0 0.32rem; background-color:#dec591;}
.swiper .pagination .swiper-active-switch {background-color:#f26927;}
.swiper button {position:absolute; top:28.5%; z-index:10; width:8.28%; height:6.95%; background-color:transparent; text-indent:-999em;}
.swiper .btnPrev {left:3.12%;}
.swiper .btnNext {right:3.12%;}

.form {background:#115a4f;}
.form .inner {width:81.25%; margin:0 auto;}
.form legend {visibility:hidden; width:0; height:0;}
.form .choice {overflow:hidden; position:relative; z-index:5; width:27.75rem; margin:0 auto 1.85rem;}
.form .choice li {float:left; width:7.5rem; height:7.8rem; margin:0 0.675rem;}
.form .choice li.ico1{margin-left:17.30%}
.form .choice li.ico3 {clear:left;}
.form .choice li.ico1 button{display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre01.png) no-repeat 0 0; background-size:100%; font-size:11px; text-indent:-999em;}
.form .choice li.ico1 button.on {background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre01_over.png) no-repeat 0 0; background-size:100%;}
.form .choice li.ico2 button{display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre02.png) no-repeat 0 0; background-size:100%; font-size:11px; text-indent:-999em;}
.form .choice li.ico2 button.on {background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre02_over.png) no-repeat 0 0; background-size:100%;}
.form .choice li.ico3 button{display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre03.png) no-repeat 0 0; background-size:100%; font-size:11px; text-indent:-999em;}
.form .choice li.ico3 button.on {background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre03_over.png) no-repeat 0 0; background-size:100%;}
.form .choice li.ico4 button{display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre04.png) no-repeat 0 0; background-size:100%; font-size:11px; text-indent:-999em;}
.form .choice li.ico4 button.on {background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre04_over.png) no-repeat 0 0; background-size:100%;}
.form .choice li.ico5 button{display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre05.png) no-repeat 0 0; background-size:100%; font-size:11px; text-indent:-999em;}
.form .choice li.ico5 button.on {background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre05_over.png) no-repeat 0 0; background-size:100%;}

.field {position:relative;}
.field textarea {width:100%; height:10rem; padding:1.5rem 1.5rem; border:0; border-radius:0.45rem; background-color:#f4f4f4; color:#333; font-size:1.2rem;}
.field input {width:100%; margin:1rem 0 2.5rem;} 

.commentlist ul {margin: 1.5rem 1.3rem 0;}
.commentlist ul li {position:relative; min-height:11rem; padding:0 0 1.75rem 0; margin-bottom:1.2rem; color:#fff; font-size:1rem; line-height:1.5em; border-radius:1rem;}
.commentlist li.genre01 {background:#33a0ac;}
.commentlist li.genre02 {background:#dc6f49;}
.commentlist li.genre03 {background:#d5b32a;}
.commentlist li.genre04 {background:#4977c2;}
.commentlist li.genre05 {background:#ed6f80;}
.commentlist ul li .num{display:block; font-size:1rem; color:#fff; font-weight:bold; letter-spacing:0.5px; padding:0.55rem 0 0 1.3rem;}
.commentlist ul li .genre {position:absolute; top:2.95rem; left:5.08%; display:inline-block;  width:7.25rem; height:6.15rem;}
.commentlist ul li.genre01 .genre {background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre01_list_v2.png) no-repeat 0 0; background-size:100%; text-indent:-999em;}
.commentlist ul li.genre02 .genre {background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre02_list_v3.png) no-repeat 0 0; background-size:100%; text-indent:-999em;}
.commentlist ul li.genre03 .genre {background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre03_list_v2.png) no-repeat 0 0; background-size:100%; text-indent:-999em;}
.commentlist ul li.genre04 .genre {background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre04_list_v2.png) no-repeat 0 0; background-size:100%; text-indent:-999em;}
.commentlist ul li.genre05 .genre {background:url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/ico_genre05_list_v2.png) no-repeat 0 0; background-size:100%; text-indent:-999em;}
.commentlist ul li .letter {width:93.71%; padding:0.8rem 0 0.5rem 9rem;}
.commentlist ul li .wirter {padding-left:9rem;}
.commentlist ul li .btnDel {position:absolute; top:0.5rem; right:0.5rem; width:1.45rem; height:1.45rem; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2016/74104/m/btn_delete.png) no-repeat 0 0; background-size:100%; text-indent:-999em;}
</style>
<script type='text/javascript'>

$(function(){
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% else %>
		setTimeout("pagup()",500);
	<% end if %>

	mySwiper = new Swiper("#rolling .swiper-container",{
		loop:true,
		autoplay:2500,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		prevButton:'#rolling .btnPrev',
		nextButton:'#rolling .btnNext',
		spaceBetween:"5%",
		effect:"fade",
		onInit: function (mySwiper) {
			$(".pagination span:nth-child(1)").addClass("p01");
			$(".pagination span:nth-child(2)").addClass("p02");
			$(".pagination span:nth-child(3)").addClass("p03");
			$(".pagination span:nth-child(4)").addClass("p04");
			$(".pagination span:nth-child(5)").addClass("p05");
			$(".choice li.ico1").click(function(){
				frmcom.gubunval.value = '1';
				$(".pagination span.p01").click();
			});
			$(".choice li.ico2").click(function(){
				frmcom.gubunval.value = '2';
				$(".pagination span.p02").click();
			});
			$(".choice li.ico3").click(function(){
				frmcom.gubunval.value = '3';
				$(".pagination span.p03").click();
			});
			$(".choice li.ico4").click(function(){
				frmcom.gubunval.value = '4';
				$(".pagination span.p04").click();
			});
			$(".choice li.ico5").click(function(){
				frmcom.gubunval.value = '5';
				$(".pagination span.p05").click();
			});
		}
	});
	$(".choice li button").click(function(){
		$(".choice li button").removeClass("on");
		$(this).addClass("on");
	});

});

function pagup(){
	window.$('html,body').animate({scrollTop:$("#toparticle").offset().top}, 0);
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
		<% If not( left(currenttime,10)>="2016-11-08" and left(currenttime,10)<"2016-11-18" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("최대로 응모하셨습니다. 11월 18일 당첨자\n발표를 기대해주세요!");
				return false;
			<% else %>
				if (frm.gubunval.value == ''){
					alert('원하는 메뉴를 선택해 주세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 1600){
					alert("이 메뉴가 땡기는 이유를 작성해주세요.\n한글 800자 까지 작성 가능합니다.");
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
</script>

<div class="evtCont">

	<div class="mEvt74104">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/74104/m/tit_book.jpg" alt="텐바이텐 도서 풀코스 도서 만찬 원하는 메뉴를 선택하고 주문하면 250명에게 도서 선물을 드려요! 당첨자 발표 : 2016년 11월 18일" /></h3>
		<div id="rolling" class="rolling">
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74104/m/txt_slide01.jpg" alt="인문" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74104/m/txt_slide02.jpg" alt="에세이" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74104/m/txt_slide03.jpg" alt="취미" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74104/m/txt_slide04.jpg" alt="여행" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74104/m/txt_slide05.jpg" alt="소설" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btnPrev">이전</button>
				<button type="button" class="btnNext">다음</button>
			</div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74104/m/txt_evnt_inro.jpg" alt="※ 이벤트 당첨시 해당 장르의 다른 도서가 랜덤 발송 될 수 있습니다" /></p>
		<div id="commentevt" class="section commentevt">
			<div class="form">
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
					<legend>코멘트 쓰기</legend>
						<div class="inner">
							<ul class="choice">
								<li class="ico1">
									<button type="button" value="1">#인문</button>
								</li>
								<li class="ico2">
									<button type="button" value="2">#에세이</button>
								</li>
								<li class="ico3">
									<button type="button" value="3">#취미</button>
								</li>
								<li class="ico4">
									<button type="button" value="4">#여행</button>
								</li>
								<li class="ico5">
									<button type="button" value="5">#소설</button>
								</li>
							</ul>
							<div class="field">
								<textarea title="코멘트 작성" cols="60" rows="5" placeholder="이 메뉴가 땡기는 이유는?"name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
								<input type="image" value="주문하기" class="btnsubmit" src="http://webimage.10x10.co.kr/eventIMG/2016/74104/m/btn_go_buy_v2.png" onclick="jsSubmitComment(document.frmcom); return false;" />
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
			<%' for dev msg : comment list %>
			<div class="commentlist">
			<% IF isArray(arrCList) THEN %>
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
						<%' for dev msg : 상단 장르 선택에 따라 클래스 genre01~05 붙여주세요 %>
						<% If isarray(split(arrCList(1,intCLoop),"!@#")) Then %>
							<li class="genre0<%= split(arrCList(1,intCLoop),"!@#")(0) %>">
								<span class="num">No. <%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span>
								<% If split(arrCList(1,intCLoop),"!@#")(0)="1" Then %>
									<div class="genre">#인문</div>
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="2" Then %>								
									<div class="genre">#에세이</div>								
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="3" Then %>								
									<div class="genre">#취미</div>				
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="4" Then %>								
									<div class="genre">#여행</div>				
								<% ElseIf split(arrCList(1,intCLoop),"!@#")(0)="5" Then %>								
									<div class="genre">#소설</div>																	
								<% End If %>
								<div class="letter">
									<p>
										<% if ubound(split(arrCList(1,intCLoop),"!@#")) > 0 then %>
											<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"!@#")(1) ))%>
										<% end if %>
									</p>
								</div>
								<div class="wirter"><%=printUserId(arrCList(2,intCLoop),2,"*")%></div>
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
									<a href="" class="btnDel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</a>
								<% End If %>
							</li>
						<% End If %>
					<% Next %>

				</ul>
				<% End If %>
				<% IF isArray(arrCList) THEN %>
					<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
				<% end if %>
			</div>
		</div>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->