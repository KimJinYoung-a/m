<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 탐구생활 연말정산
' History : 2018-12-13 최종원
'####################################################
dim oItem
dim currenttime
	currenttime =  now()

Dim eCode , userid , pagereload , vPIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  89172
Else
	eCode   =  91298
End If

dim commentcount, i
	userid = GetEncLoginUserID()

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

vPIdx = request("pidx")

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
.life-664{background-color:#6e21ca;}
.life-664 .topic {position:relative;}
.life-664 .section {position:relative;}
.life-664 .section .bg-img img,
.life-664 .comment-head h3 img,
.life-664 span a img {margin-top: -1px;}
.life-664 .topic {position: relative;}
.life-664 .topic > div span {position: absolute; animation: titAni .8s ease-in forwards; opacity: 0;}
.life-664 .topic > div span.txt-01 {top:22.27%}
.life-664 .topic > div span.txt-02 {bottom:14%;; animation-delay: .5s;}
.life-664 .posR {position:relative;}
.life-664 .slide-area {position:relative; background-color:#7de4b2;}
.life-664 .slide-area .pagination {height:auto; padding:1.7rem 0 4.27rem;}
.life-664 .slide-area .pagination .swiper-pagination-switch {width:.9rem; height:.9rem; margin:0 .4rem; background-color:#32855d; }
.life-664 .slide-area .pagination .swiper-pagination-switch.swiper-active-switch {background-color:#fffb6d;}
@keyframes titAni {
        from {transform:translateY(100px);}
        to {opacity:1;}
}
.comment {background-color:#f1f1f1;}
.comment .starRating {background: none; background-color:#f1f1f1; padding: 0; margin: 0;}
.comment .starRating .score span {width:4.19rem; height:4.19rem; background: url(http://webimage.10x10.co.kr/fixevent/play/life/664/ico_star.png?v=1.01) left top /100% auto no-repeat;}
.comment .starRating .score span.on {background-position: left -4.45rem;}
.comment .mycate {width: 90%; margin: 0 auto; padding: .7rem 0 .7rem 1.8rem; border-radius: 2rem; box-sizing: border-box; background-color: #e3e3e3; overflow: hidden; }
.comment .mycate ul {background-color:#e3e3e3;*zoom:1} 
.comment .mycate ul:after{content:'';clear:both;display:block;} 
.comment .mycate ul li {position:relative; float:left; width:35%; color:#4a4a4a; margin:1rem 0;}
.comment .mycate ul li:nth-child(3n) {width:30%;}
.comment .mycate ul li span {display:inline-block; padding:0.72rem 0; color:#4a4a4a; font-size:1.26rem; font-family: 'Roboto','Noto Sans KR','malgun Gothic','맑은고딕',sans-serif;}
.comment .mycate ul li.on span{position:absolute; color:#8611c9; padding: 0.72rem; margin-left:-0.72rem; background-color:#e2c3f4; font-weight: bold; border-radius:1.5rem;}
.comment .icon-rating {position:relative; display:block; width:14rem; height:2.77rem;}
.comment .icon-rating:before {content:''; display:block; height:100%; background: url(http://webimage.10x10.co.kr/fixevent/play/life/664/ico_star_sm.png) left top /100% auto no-repeat;}
.comment .icon-rating i {position:absolute; display:block; height:100%; top:0; background: url(http://webimage.10x10.co.kr/fixevent/play/life/664/ico_star_sm.png) left -5.5rem / 14rem auto no-repeat;}
.comment-head {position:relative;}
.comment-write {position:absolute; bottom:2rem; width: 100%; text-align: center;}
.comment-write input {width:23.8rem; height:2.99rem; padding:2.5rem; font-size:1.7rem; font-weight:600; text-align:center; color:#000; border:0.43rem solid #000; border-radius: 0; background-color: #fff;}
.comment-write input::-webkit-input-placeholder {color:#ddd;}
.comment-write input::-moz-placeholder {color:#ddd;} 
.comment-write input:-ms-input-placeholder {color:#ddd;} 
.comment-write input:-moz-placeholder {color:#ddd;}
.comment-write button {display:block; margin-top: 3rem;}
.comment-list {padding:3.4rem 0 2.47rem; background:#b93ee7;}
.comment-list ul {padding:0 2.13em;}
.comment-list li {position:relative; margin-top:2.5rem;}
.comment-list li:first-child {margin-top:0;}
.comment-list li .cmt-area {padding:1.9rem 1.9rem 1.3rem 1.9rem; font-size:0.9rem; line-height:4.18rem; letter-spacing:-0.03rem; background:#fff;}
.comment-list li .btn-delete {position:absolute; right:-3.5rem; top:-3.5rem; width:7.66rem; padding:3rem;}
.comment-list li p {line-height:normal;}
.comment-list li .writer {float:left; font-size:1rem; color:#000; }
.comment-list li .writer em {font-weight:bold;}
.comment-list li .num {float:right; font-size:1rem; color:#7f00fe;}
.comment-list li .mytype {clear:both; padding-top:1rem;}
.comment-list li .mytype dl{height: 3.3rem; margin-bottom:0.8rem;}
.comment-list li .mytype dt,
.comment-list li .mytype dd {display:inline-block; vertical-align:middle; font-weight:bold;}
.comment-list li .mytype dt {width:38% ;font-size:1.14rem; vertical-align:top;}
.comment-list li .mytype dt.txt01 {color:#ef6d4a;}
.comment-list li .mytype dt.txt02 {color:#309e79;}
.comment-list li .mytype dt.txt03 {color:#8451a2;}
.comment-list li .mytype dt.txt04 {color:#5e5ee1;}
.comment-list li .mytype dd {font-size:1.47rem;}
.comment-list .pagingV15a {margin-top:2.65rem;}
.comment-list .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#333; font-size:1.28rem; line-height:2.8rem; font-weight:600;}
.comment-list .pagingV15a a {padding-top:0;}
.comment-list .pagingV15a .current {color:#fff; background:#000; border-radius:50%;}
.comment-list .pagingV15a .arrow a:after {left:0; top:0; width:2.77rem; height:2.77rem; margin:0; background:url(http://webimage.10x10.co.kr/play/life/btn_paging_next.png) 0 0 no-repeat; background-size:100% 100%;}
</style>
<script type="text/javascript">
    $(function(){
    displayCategory();        
    <% if pagereload<>"" then %>
		setTimeout("pagedown()",200);
	<% end if %>        
        var position = $('.life-664').offset(); // 위치값
        $('html,body').animate({ scrollTop : position.top },300); // 이동
    
		Swiper(".slide-area .swiper-container",{
            loop:true,
            autoplay:2800,
            speed:800,
            pagination:".slide-area .pagination",
            paginationClickable:true,
            effect:'fade'
        });

		$(".btn-gocomment").click(function(event){
			$('html,body').animate({'scrollTop':$(this.hash).offset().top + 'px'},1000);
		})

        //별점
        $('.score span').each(function(index){
            $(this).on('click', function(){
                jsCheckLimit();
                $('.score span').addClass('on');
                $('.score span:gt('+index+')').removeClass('on');
                var rate = index+1;
                setStar(rate);                
                //rate값이 최종 별점임
                return false;
            });
        });

		$(".mycate li").click(function () { 
            jsCheckLimit();
            var categoryIdx;
            var categoryIdx = $(this).index();
            
			$(this).addClass("on").siblings().removeClass("on")          
            pickCategory(categoryIdx);  
		})
    });
</script>
<script type="text/javascript">
function pagedown(){
	window.$('html,body').animate({scrollTop:$("#comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('<%=appUrlPath%>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=on&iCC=' + iP);
}

function jsSubmitComment(frm){	
	<% If IsUserLoginOK() Then %>	
		<% if date() >="2018-12-13" and date() <= "2018-12-31" then %>
			<% if commentcount>4 and userid <> "cjw0515" then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
                if(!frm.spoint.value){
					alert("2018년을 평가해주세요.");					
					return false;
				}
				if(!frm.txtcommURL.value){
					alert("올해 최애 아이템을 적어주세요.");					
					frm.txtcommURL.focus();
					return false;
				}
				if(!frm.com_egC.value){
					alert("텐바이텐에서 가장 많이 샀던 카테고리를 선택해주세요.");										
					return false;
				}                
				if(!frm.txtcomm.value){
					alert("사고싶었던 아이템을 적어주세요.");					
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
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playwebview/detail.asp?pidx="&vPIdx&"")%>');
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
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playwebview/detail.asp?pidx="&vPIdx&"")%>');
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
            <!-- 컨텐츠 영역 -->
            <!-- 탐구생활 664 (91298) 2018년 연말정산! -->
            <div class="life-664">
                <div class="topic">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/img_top.png" alt=""></p>
                    <div>
                        <span class="txt-01"><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/tit_01v2.png" alt="2018 연말정산"></span>
                        <span class="txt-02"><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/tit_02.png" alt="연말이 되면 한 해를 정리하곤 하죠. 텐바이텐의 연말 정산! 여러분도 한 해를 정리해 보는 건 어떨까요? 2018"></span>
                    </div>
                </div>
				<p><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/img_02.png" alt="" /></p>
				<div class="slide-area">
					<p><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/img_03.png" alt="" /></p>
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<a href="/street/street_brand.asp?makerid=0096s10x10" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/img_slide_01.png" alt="또자"></a>
								<a href="" onclick="fnAPPpopupBrand('0096s10x10'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/img_slide_01.png" alt="또자"></a>
							</div>
							<div class="swiper-slide">
								<a href="/street/street_brand.asp?makerid=popmart1" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/img_slide_02.png" alt="팜마트"></a>
								<a href="" onclick="fnAPPpopupBrand('popmart1'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/img_slide_02.png" alt="팜마트"></a>
							</div>
							<div class="swiper-slide">
								<a href="/street/street_brand.asp?makerid=ggong100" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/img_slide_03.png" alt="공백"></a>
								<a href="" onclick="fnAPPpopupBrand('ggong100'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/img_slide_03.png" alt="공백"></a>
							</div>
						</div>
						<div class="pagination"></div>
					</div>
				</div>
				<p><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/img_04.png" alt="" /></p>
				<p><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/img_05.png" alt="" /></p>
				<a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91298');"><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/btn_yearend.png" alt="" /></a>
				<a href="#comment-head" class="btn-gocomment"><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/btn_comment.png" alt="" /></a>
                <!-- comment -->
                <div class="comment">
                <form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
                <input type="hidden" name="mode" value="add">
                <input type="hidden" name="pagereload" value="ON">
                <input type="hidden" name="iCC" value="1">
                <input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
                <input type="hidden" name="eventid" value="<%= eCode %>">
                <input type="hidden" name="linkevt" value="<%= eCode %>">
                <input type="hidden" name="blnB" value="">
                <input type="hidden" name="returnurl" value="<%= appUrlPath %>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=ON">
                <input type="hidden" name="isApp" value="<%= isApp %>">	
                <input type="hidden" name="com_egC">	                
                <input type="hidden" name="spoint"/>
                    <div class="comment-head" id="comment-head">
                        <div>
							<p><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/txt_01.png" alt="나의 2018년의 평가점수는?"></p>
							<!-- 별점 -->
							<div class="starRating">
								<div class="score"><span></span><span></span><span></span><span></span><span></span></div>
							</div>
						</div>
                        <div class="posR">
							<p><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/txt_02.png" alt="이번 해의 나의 가장 최애 아이템은?"></p>
							<div class="comment-write">
								<div>
									<input type="text" onClick="jsCheckLimit();" id="txtcommURL" name="txtcommURL" title="이번 해의 나의  가장 최애 아이템은? " placeholder="다이어리" maxlength="10">
								</div>
							</div>
						</div>
                        <div>
                            <p><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/txt_03.png" alt="텐바이텐에서 가장 많이 샀던 카테고리는?"></p>
                            <div class="mycate">
								<ul>
									<li><span>디자인문구</span></li>
									<li><span>디지털/핸드폰</span></li>
									<li><span>가구/수납</span></li>
									<li><span>패브릭/생활</span></li> 
									<li><span>데코/조명</span></li>
									<li><span>캠핑/트레블</span></li>
									<li><span>키친/푸드</span></li>
									<li><span>푸드</span></li>
									<li><span>베이비/키즈</span></li>
									<li><span>패션의류/잡화</span></li>
									<li><span>주얼리/시계</span></li>
									<li><span>CAT&DOG</span></li>
									<li><span>뷰티</span></li>
									<li><span>토이</span></li>
								</ul>
							</div>
                        </div>
                        <div class="posR">
							<p><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/txt_04.png" alt="꼭 사고 싶지만 아직 사지 못했던 아이템은?"></p>
							<div class="comment-write">
								<div>
									<input type="text" onClick="jsCheckLimit();" id="txtcomm" name="txtcomm" title="꼭 사고 싶지만 아직 사지 못했던 아이템은?" placeholder="노트북" maxlength="10">
								</div>
							</div>
						</div>
						<button onclick="jsSubmitComment(document.frmcom);"><img src="http://webimage.10x10.co.kr/fixevent/play/life/664/btn_enter.png" alt="응모하기"></button>
                    </div>
                    </form>
                    <form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
                    <input type="hidden" name="mode" value="del">
                    <input type="hidden" name="pagereload" value="ON">
                    <input type="hidden" name="Cidx" value="">
                    <input type="hidden" name="returnurl" value="<%= appUrlPath %>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=ON">
                    <input type="hidden" name="eventid" value="<%= eCode %>">
                    <input type="hidden" name="linkevt" value="<%= eCode %>">
                    <input type="hidden" name="isApp" value="<%= isApp %>">
                    </form>                    
                    <!-- 코멘트 목록(6개씩 노출) -->
                    <div class="comment-list" id="comment">
                    <% If isArray(arrCList) Then %>				                    
                        <ul>
                        <% 
                        
                        dim star, bestItem, mostCategory, wishItem
                        For intCLoop = 0 To UBound(arrCList,2) 
                        star = Cint(arrCList(3,intCLoop)) * 20 'evtcom_point
                        bestItem = db2html(arrCList(7,intCLoop)) 'blogurl
                        mostCategory = arrCList(6,intCLoop) 'evtgroup_code
                        wishItem = ReplaceBracket(db2html(arrCList(1,intCLoop)))'evttxt                        
                        %>
                            <li>
                                <div class="cmt-area">
                                    <p class="writer"><em><%=printUserId(arrCList(2,intCLoop),2,"*")%></em>님의 연말정산</p>
                                    <p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
                                    <div class="mytype">
                                        <dl>
											<dt class="txt01">점수</dt>
											<dd>
												<!-- 별점 결과값 -->
												<span class="icon-rating">
													<i style="width:<%=star%>%;"></i> <!--  for dev msg : 별 하나 20% 두개 40% 세개 60% 네개 80% 다섯개 100% -->
												</span>
											</dd>
										</dl>
										<dl>
											<dt class="txt02">최애 아이템</dt>
											<dd><%=bestItem%></dd>
										</dl>
										<dl>
											<dt class="txt03">많이 산 카테고리</dt>
											<dd class="bestCategory"><%=mostCategory%></dd>
										</dl>
										<dl>
											<dt class="txt04">위시 아이템</dt>
											<dd><%=wishItem%></dd>
										</dl>
                                    </div>
                                </div>
                                <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
                                <button type="button" class="btn-delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/fixevent/play/life/621/btn_cmt_delete.png" alt="코멘트 삭제"></button>
                                <% End If %>			
                            </li>
                        <% Next %>
						</ul>
                    <% End If %>	                            
                    <% If isArray(arrCList) Then %>
                    <div class="paging pagingV15a">
                        <%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
                    </div>
                    <% end if %>
					</div>
				</div>
				<!--// comment -->
			</div>
            <!-- // 탐구생활 664 (91298) 2018년 연말정산! -->
			<!--// 컨텐츠 영역 -->