<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 탐구생활 문구
' History : 2019-02-22 최종원
'####################################################
'gnb 구분자
dim gnbFlag
dim nowUrl, eventStartDate, eventEndDate

nowUrl = request.servervariables("HTTP_url")

eventStartDate = Cdate("2019-02-22")
eventEndDate = Cdate("2019-03-27")
dim oItem
dim currenttime
	currenttime =  now()

dim returnUrl

Dim eCode , userid , pagereload , vPIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  89172
Else
	eCode   =  92810 
End If

dim commentcount, i
	userid = GetEncLoginUserID()

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

vPIdx = request("pidx")

if InStr(nowUrl,"/apps/appcom/wish/web2014/playwebview/detail.asp") > 0 then
	returnUrl = appUrlPath & "/playwebview/detail.asp?pidx=" & vPIdx & "&pagereload=ON"
else 
	returnUrl = appUrlPath & "/subgnb/life/?pagereload=ON"
end if


dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 5		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 6		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 6		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
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
<style>
.topic {position: relative;}
.topic h2 {position:absolute; top:7rem;}
.topic h2 p {margin-bottom: 1rem;}
.topic h2 span {display:block;}
.swiper1 .swiper-slide {width: 100%;}
.swiper1 button {position: absolute; width: 14%; z-index: 999; top: 40%;}
.swiper1 button.btn-prev {left: 0; }
.swiper1 button.btn-next {right: 0; }
.pagingNo {position: absolute; z-index: 999; bottom: 2rem; width: 100%;}
.pagingNo .page {color: #5a5a5a; font-weight: 600; font-size: 1.1rem; text-align: center;}
.pagingNo .page strong {color: #000;}
.pagingNo .page i {margin: 0 .2rem; font-weight: normal;}
.cmt-area {background-color: #fff7e0}
.input-box {width: 27rem; margin: 0 auto 4rem;}
.input-box .textarea-wrap {position: relative; }
.input-box .textarea-wrap textarea {position: absolute; overflow:hidden; top: 0; left: 0; width:100%; height:100%; padding: 2rem 3rem; border:0; background-color:transparent; color:#000; font-size:1.61rem; line-height:2.64rem; font-weight:600; text-align:left;}
.input-box .textarea-wrap textarea:focus::-webkit-input-placeholder {opacity: 0;}
.input-box .textarea-wrap textarea::-webkit-input-placeholder {color: #ccc;}
.input-box .textarea-wrap textarea::-moz-input-placeholder {color: #ccc;}
.input-box .textarea-wrap textarea:-moz-placeholder {color: #ccc;}
.input-box .textarea-wrap textarea:-ms-input-placeholder {color: #ccc}
.cmt-area .cmt-list ul {padding:2.99rem 6.6% 0;background-color:#ffa336;}
.cmt-area .cmt-list ul li {position: relative; display:table; width:100%; margin-top:1.28rem; padding:1.9rem; background-color:#fff;}
.cmt-area .cmt-list ul .num {position: absolute; top: 2rem; right: 1.58rem; font-size:.75rem; font-weight:500; text-align:right;}
.cmt-area .cmt-list ul .writer {display: block; padding-bottom: 1rem; color: #633a0a; font-size:.95rem; }
.cmt-area .cmt-list ul .writer em {color:#c75742;}
.cmt-area .cmt-list ul .conts {padding-top:1rem; font-size:1.37rem; line-height:1.7; font-weight:bold; word-wrap:break-word; word-break:break-all; text-align:left; border-top: 0.09rem solid #f0f0f8;}
.cmt-area .cmt-list .delete {display:inline-block; position:absolute; top:-.43rem; right:-.43rem; width:1.66rem; height:1.66rem; background:url(//webimage.10x10.co.kr/fixevent/play/life/702/btn_close.png) no-repeat 50% 50%; background-size:contain; text-indent:-999em}
.cmt-area .pagingV15a {margin-top:0rem; padding-top:2.99rem; padding-bottom:3.62rem; background-color:#ffa336;}
.cmt-area .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#fff; font-size:1.28rem; line-height:2.9rem; font-weight:600;}
.cmt-area .pagingV15a a {padding-top:0;}
.cmt-area .pagingV15a .current {color:#f76347; background:#fff192; border-radius:50%;}
.cmt-area .pagingV15a .arrow a:after {left:0; top:0; width:2.77rem; height:2.77rem; margin:0; background:url(//webimage.10x10.co.kr/fixevent/play/life/702/btn_next.png) 0 0 no-repeat; background-size:100% 100%;}
</style>
<script type="text/javascript">
    $(function(){
        var position = $('.life-728').offset();
		<% if InStr(nowUrl,"/apps/appcom/wish/web2014/playwebview/detail.asp") > 0 then %>
		$('html,body').animate({ scrollTop :position.top },300); // 이동
		<% end if %>                
		//상단
		$('h2 p, h2 span').css({'margin-top':'-2rem','opacity':'0'})
		$('h2 p').animate({'margin-top':'0','opacity':'1'},800)
		$('h2 span').delay('500').animate({'margin-top':'0','opacity':'1'},800)
		//슬라이드
		mySwiper = new Swiper(".swiper1 .swiper-container",{
	        loop:true,
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
            }
        });
        $('.swiper1 .page strong').text(1);
        $('.swiper1 .page span').text(mySwiper.slides.length-2);
    });
</script>
<script type="text/javascript">
    <% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>        
function pagedown(){
	window.$('html,body').animate({scrollTop:$("#comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('<%=returnUrl%>&iCC=' + iP);
}

function jsSubmitComment(frm){		
	<% If IsUserLoginOK() Then %>	
		<% if date() >= eventStartDate and date() <= eventEndDate then %>
			<% if commentcount > 4 and userid <> "cjw0515" then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("텍스트를 입력해주세요.");					
					frm.txtcomm.focus();
					return false;
				}				
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=returnUrl%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=returnUrl%>');
			return false;
		<% end if %>	
	}
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}
function setStar(rate){    
    var frm = document.frmcom;
    frm.spoint.value=rate;    
}
function pickCategory(categoryIdx){
    var frm = document.frmcom;
    frm.com_egC.value=categoryIdx;    
}
function displayCategory(){
    var objs = $(".bestCategory");
    // console.log(objs)
    objs.each(function(idx, value){        
        var cateIdx = $(this).text();
        var mycateObj = $(".mycate li span")[cateIdx];
        var txt = mycateObj.innerHTML.replace("amp;","");    
        $(this).text(txt);        
    })
}
</script>
            <!-- PLAY 탐구생활 728 -->
            <div class="life-728">
                <div class="topic">
					<p><img src="//webimage.10x10.co.kr/fixevent/play/life/728/img_top.jpg" alt="마스킹테이프 120% 즐기는 방법"></p>
					<h2>
						<p><img src="//webimage.10x10.co.kr/fixevent/play/life/728/tit_mungu_01.png" alt="문구"></p>
						<span><img src="//webimage.10x10.co.kr/fixevent/play/life/728/tit_mungu_02.png" alt="탐구생활"></span>
					</h2>
				</div>
                <p><img src="//webimage.10x10.co.kr/fixevent/play/life/728/img_mt.jpg" alt="마스킹 테이프 활용법"></p>
                <div class="swiper1">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/img_slide_01.jpg?v=1.01" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/img_slide_02.jpg?v=1.01" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/img_slide_03.jpg?v=1.01" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/img_slide_04.jpg?v=1.01" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/img_slide_05.jpg?v=1.01" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/img_slide_06.jpg?v=1.01" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/img_slide_07.jpg?v=1.01" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/img_slide_08.jpg?v=1.01" alt=""></div>
                        </div>
                        <button class="btn-prev" onfocus="this.blur();"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/btn_prev.png?v=1.01" alt="이전"></button>
                        <button class="btn-next" onfocus="this.blur();"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/btn_next.png" alt="다음"></button>
                        <div class="pagingNo">
                            <p class="page"><strong></strong><i>/</i><span></span></p>
                        </div>
                    </div>
                </div>
                <% if isApp = 1 then %>
                    <a href="javascript:void(0)" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=92810');"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/bnr_more.jpg" alt="마스킹테이프 더보러가기"></a>
                <% else %>
                    <a href="/event/eventmain.asp?eventid=92810" ><img src="//webimage.10x10.co.kr/fixevent/play/life/728/bnr_more.jpg" alt="마스킹테이프 더보러가기"></a>
                <% end if %>
                
                

                <!-- 코멘트영역 -->
                <div class="cmt-area" >
                    <p><img src="//webimage.10x10.co.kr/fixevent/play/life/728/img_comment.jpg" alt=""></p>
                    <div class="input-box">
						<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
						<input type="hidden" name="mode" value="add">
						<input type="hidden" name="pagereload" value="ON">
						<input type="hidden" name="iCC" value="1">
						<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
						<input type="hidden" name="eventid" value="<%= eCode %>">
						<input type="hidden" name="linkevt" value="<%= eCode %>">
						<input type="hidden" name="blnB" value="">
						<input type="hidden" name="returnurl" value="<%=returnUrl%>">
						<input type="hidden" name="isApp" value="<%= isApp %>">	
						<input type="hidden" name="com_egC">	                
						<input type="hidden" name="spoint"/>					                    
                        <div class="textarea-wrap">
                            <p><img src="//webimage.10x10.co.kr/fixevent/play/life/728/bg_input.jpg" alt=""></p>
                            <textarea name="txtcomm" id="txtcomm" placeholder="50자 이내로 입력" maxlength="50" onClick="jsCheckLimit();"></textarea>
                        </div>
                        <button class="submit" onclick="jsSubmitComment(document.frmcom);return false;"><img src="//webimage.10x10.co.kr/fixevent/play/life/728/btn_input.jpg" alt="등록"></button>
                        </form>
						<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
						<input type="hidden" name="mode" value="del">
						<input type="hidden" name="pagereload" value="ON">
						<input type="hidden" name="Cidx" value="">
						<input type="hidden" name="returnurl" value="<%=returnUrl%>">
						<input type="hidden" name="eventid" value="<%= eCode %>">
						<input type="hidden" name="linkevt" value="<%= eCode %>">
						<input type="hidden" name="isApp" value="<%= isApp %>">
						</form>                 						                        
                    </div>
                    <!-- 코멘트리스트 6개씩 노출-->
                    <div class="cmt-list" id="comment">
					<% If isArray(arrCList) Then %>				                    
                        <ul>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
                            <li>
                                <p class="writer"><em><%=printUserId(arrCList(2,intCLoop),2,"*")%></em>님의 마스킹테이프 활용법</p>
                                <p class="num">No. <%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
                                <p class="conts"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
                                
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
                                <button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button>
								<% End If %>
                            </li>
							<% Next %>
                        </ul>
					<% End If %>	                            	
                    </div>
                    <% If isArray(arrCList) Then %>
                    <div class="paging pagingV15a">
                        <%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
                    </div>
                    <% end if %>					
                                    
                </div>
			</div>
			<!--// 컨텐츠 영역 -->