<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 플레이굿즈 meaning life 
' History : 2018-10-31 최종원
'####################################################
dim oItem
dim currenttime
	currenttime =  now()

Dim eCode , userid , pagereload , vPIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  68520
Else
	eCode   =  90239
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
<%
'// SNS 공유용
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink, snpTag2, kakaourl

snpTitle	= "[텐바이텐]\n PLAY GOODS"
snpLink		= appUrlPath&"/playwebview/detail.asp?pidx="&vPIdx
snpPre		= "10x10 이벤트"
snpImg		= ""
appfblink	= appUrlPath&"/playwebview/detail.asp?pidx="&vPIdx
kakaourl	= appUrlPath&"/playwebview/detail.asp?pidx="&vPIdx
snpTag 		= "[텐바이텐]\n PLAY GOODS"
snpTag2 = "#10x10"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐]\n PLAY GOODS"
Dim kakaodescription : kakaodescription = "meaning life 텀블러 세트로 작은 환경 캠페인에 동참하세요!"
Dim kakaooldver : kakaooldver = "meaning life 텀블러 세트로 작은 환경 캠페인에 동참하세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr//play/playcontents/201810/20181031093803969.jpg?cmd=thumb&w=640"
Dim kakaolink_url 
kakaolink_url = "http://m.10x10.co.kr/" & appUrlPath & "/playwebview/detail.asp?pidx="&vPIdx
%>
<style>
.comment-head {position:relative;}
.comment-write {position:absolute; left:5%; bottom:11.3%; width:90%;}
.comment-write div {overflow:hidden; position:relative; width:100%; height:4.69rem; margin:0 auto; padding:0 9.5rem 0 1.7rem; }
.comment-write input {width:100%; height:4.69rem; line-height:4.69rem; font-size:1.62rem; font-weight:600; text-align:center; color:#666; border:0; background-color: transparent;}
.comment-write input::-webkit-input-placeholder {color:#d6d6d6;}
.comment-write input::-moz-placeholder {color:#d6d6d6;} /* firefox 19+ */
.comment-write input:-ms-input-placeholder {color:#d6d6d6;} /* ie */
.comment-write input:-moz-placeholder {color:#d6d6d6;}
.comment-write .btn-recommend {position:absolute; right:0; top:0; width:8.9rem; height:4.69rem; vertical-align:top; background: none; text-indent: -9999px}
.comment-list {padding:3.4rem 0 2.47rem; background:#f6d19c;}
.comment-list ul {padding:0 6.66%;}
.comment-list li {position:relative; margin-top:1.28rem;}
.comment-list li:first-child {margin-top:0;}
.comment-list li .cmt-area {overflow:hidden; height:4.18rem; padding:0 1.7rem; font-size:0.9rem; line-height:4.18rem; letter-spacing:-0.03rem; background:#fff;}
.comment-list li .btn-delete {position:absolute; right:-3.5rem; top:-3.5rem; width:7.66rem; padding:3rem;}
.comment-list li p {display:inline-block; float:left; height:100%;}
.comment-list li .num {width:4.2rem; color:#333;}
.comment-list li .txt {font-size:1.45rem; font-weight:600; color:#000; text-align:left;}
.comment-list li .writer {position:absolute; top:0; right:1.7rem; color:#d3953c;}
.comment-list .pagingV15a {margin-top:2.65rem;}
.comment-list .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#333; font-size:1.28rem; line-height:2.8rem; font-weight:600;}
.comment-list .pagingV15a a {padding-top:0;}
.comment-list .pagingV15a .current {color:#ffef85; background:#333; border-radius:50%;}
.comment-list .pagingV15a .arrow a:after {left:0; top:0; width:2.77rem; height:2.77rem; margin:0; background:url(http://webimage.10x10.co.kr/play/life/btn_paging_next.png) 0 0 no-repeat; background-size:100% 100%;}

.life-586{background-color:#eee;}
.life-586 .top {position:relative;}
.life-586 .top h2{position:absolute; top:7%; left:0;}
.life-586 .section{position:relative;}
.life-586 .swiper-container .btnPrev,
.life-586 .swiper-container .btnNext{display:block; position:absolute; height:13.63%; width:10.66%; top:43.5%;  z-index:84; text-indent:-9999px;}
.life-586 .swiper-container .btnPrev{left:0;}
.life-586 .swiper-container .btnNext{right:0;}
.life-586 .swiper-container .pagination{position:absolute; bottom:6%; z-index:84; width:100%;}
.life-586 .swiper-container .pagination .swiper-pagination-switch{z-index:84; width:10px; height:10px; background:url('http://webimage.10x10.co.kr/fixevent/play/life/586/btn_pagination.png') right 0 /auto 10px;}
.life-586 .swiper-container .pagination .swiper-active-switch{background-position:0 0;}
.life-586 .alink01,
.life-586 .alink02{width:29%; height:6.8%; position:absolute; top:0; text-indent:-9999px; left:35%;}
.life-586 .alink01{top:22%;}
.life-586 .alink02{bottom:3.5%; top:unset;}
.life-586 .alink02s{width: 100%; height: 33.81%; top: 49.74%; position:absolute;  text-indent:-9999px; }
.life-586 .alink03{width:70%; height:7.45%; position:absolute; bottom: 8%; text-indent:-9999px; left:15%; }
.life-586 .comment-write {position:absolute; left:5%; bottom:21%; width:90%; height:22.35%; }
.life-586 .comment-write div {overflow:hidden; position:relative; width:100%; height:100%; margin:0 auto; padding:0}
.life-586 .comment-write div p{z-index:13; position: absolute; top: 17%; left: 11%; width: 45%; }
.life-586 .comment-write div textarea{z-index:14; position:relative; background:transparent; border:0; width:67%; height:100%; line-height:3rem; font-size:1.3rem; font-weight:600; text-align:left; color:#666; border:0;  padding: 5% 10% 9% 10%; overflow:hidden;}
.life-586 .comment-write textarea::-webkit-input-placeholder {color:#d6d6d6;}
.life-586 .comment-write textarea::-moz-placeholder {color:#d6d6d6;} /* firefox 19+ */
.life-586 .comment-write textarea:-ms-input-placeholder {color:#d6d6d6;} /* ie */
.life-586 .comment-write textarea:-moz-placeholder {color:#d6d6d6;}
.life-586 .comment-write .btn-recommend {display:inline-block; width:31%; height:100%; vertical-align:top; background: none; text-indent: -9999px}
.life-586 .comment-list{text-align:center;}
.life-586 .comment-list > p{margin-bottom:2rem; padding-bottom:0.4rem; border-bottom:1px solid #d4a056; color:#1b1102; font-weight:bold; font-size:1.4rem; display:inline-block;} 
.life-586 .comment-list li .cmt-area{height:unset; padding:0.8rem 1.7rem; line-height:2rem;}
.life-586 .comment-list li .num{width:17%; text-align: left;}
.life-586 .comment-list li .txt{width:55%; font-size:1.3rem; }
.life-586 .comment-list li .writer{top:0.8rem;}

</style>
<script type="text/javascript" async defer src="//assets.pinterest.com/js/pinit.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
    $(function(){
		<% if pagereload<>"" then %>
			setTimeout("pagedown()",200);
		<% end if %>			
        var position = $('.life-586').offset(); // 위치값
        $('html,body').animate({ scrollTop : position.top },300); // 이동
    
        titleAnimation();
        $(".top h2 img").css({"margin-left":"-100px","opacity":"0"});
        function titleAnimation() {
            $(".top h2 img").delay(100).animate({"margin-left":"0px","opacity":"1"},800)
        }
    
        Swiper(".swiper01 .swiper-container",{
            loop:true,
            autoplay:false,
            speed:800,
            pagination:".swiper01 .pagination",
            paginationClickable:true,
            prevButton:'.swiper01 .btnPrev',
            nextButton:'.swiper01 .btnNext',
            effect:'fade'
        });

		$("a.alink01").click(function(event){
			$('html,body').animate({'scrollTop':$(this.hash).offset().top + 'px'},1000);
		})
    });

//공통 스크립트
function pagedown(){
	window.$('html,body').animate({scrollTop:$("#comment").offset().top}, 0);
}

function jsGoComPage(iP){
	location.replace('<%=appUrlPath%>/playwebview/detail.asp?pidx=<%=vPIdx%>&pagereload=on&iCC=' + iP);
}

function jsSubmitComment(frm){	
	<% If IsUserLoginOK() Then %>	
		<% if date() >="2018-10-31" and date() <= "2018-11-11" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if(!frm.txtcomm.value){
					alert("여러분의 의미있는 생활방법을 적어주세요.");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 30){
					alert("제한길이를 초과하였습니다. 30자 까지 작성 가능합니다.");
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
function sharePt(url,imgurl,label){
	PinUtils.pinOne({
		'url' : url,
		'media' : imgurl,
		'description' : label
	});
}
function fnAPPRCVpopSNS(){
	//fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	$("#lySns").show();
	$("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
	return false;
}
function snschk(snsnum) {
	fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
	return false;
}
function parent_kakaolink(label , imageurl , width , height , linkurl ){
	//카카오 SNS 공유
	Kakao.init('c967f6e67b0492478080bcf386390fdd');

	Kakao.Link.sendTalkLink({
		label: label,
		image: {
		src: imageurl,
		width: width,
		height: height
		},
		webButton: {
			text: '10x10 바로가기',
			url: linkurl
		}
	});
}

//카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){	
	Kakao.Link.sendDefault({
		objectType: 'feed',
		content: {
			title: label,
			description : description,
			imageUrl: imageurl,
			link: {
			mobileWebUrl: linkurl
			}
		},
		buttons: [
			{
			title: '웹으로 보기',
			link: {
				mobileWebUrl: linkurl
			}
			}
		]
	});
}
</script>
</head>
			<!-- 컨텐츠 영역 -->
            <div class="life-586">
                <div class="top">
                    <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/586/img_01.png" alt=" 조금 더 나은 지구를 위한 작은 운동, 당신의 의미 있는 실천을 텐바이텐이 응원합니다!" /></p>
                    <h2><img src="http://webimage.10x10.co.kr/fixevent/play/life/586/img_01_txt.png" alt="meaning life" /></h2>
                </div>
                <div class="section">
                    <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/586/img_02.png" alt="여러분에게 의미 있는 삶은 어떤 것인가요?" /></p>
                </div>
                <div class="section">
                    <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/586/img_03.png" alt="플라스틱으로부터 환경 지키기" /></p>
                </div>
                <div class="section swiper01">
					<a href=""  onclick="TnGotoProduct('2130233');return false;" class="mApp">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/life/586/img_04_slide_01.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/life/586/img_04_slide_02.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/life/586/img_04_slide_03.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/life/586/img_04_slide_04.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/life/586/img_04_slide_05.png" alt="" /></div>
							</div>
							<div class="pagination"></div>
							<p class="btnPrev">이전</p>
							<p class="btnNext">다음</p>
						</div>
					</a>
                </div>
                <div class="section area05">
                    <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/play/life/586/img_05.png" alt="텐바이텐이 제안하는 작은 실천" /></p>
                    <a href="#together" class="alink01">동참하기</a>                    
                    <a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2130233&pEtr=90239"  onclick="TnGotoProduct('2130233');return false;" class="mApp alink02">구매하기</a>
                    <a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2130233&pEtr=90239"  onclick="TnGotoProduct('2130233');return false;" class="mApp alink02s">구매하기</a>					
                </div>
                <!-- comment -->
                <div class="comment" id="together">
                    <div class="comment-head">
                        <h3><img src="http://webimage.10x10.co.kr/fixevent/play/life/586/img_comment.png" alt="여러분의 관심사는 무엇인가요?" /></h3>
                        <div class="comment-write">
                            <div>
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
								<input type="hidden" name="spoint"/>							
                                <textarea name="txtcomm" id="txtcomm" maxlength="30" onClick="jsCheckLimit();" placeholder="카페에 텀블러 가지고 다니기 (30자 이내)"></textarea>
								<button type="button" class="btn-recommend" onclick="jsSubmitComment(document.frmcom);return false;">캠페인 동참하기</button>															
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
                            </div>
                        </div>
						<a href="#" onclick="snschk('ka'); return false;" class="alink03 mApp">친구에게 공유하기</a>
						<a href="#" onclick="snschk('ka'); return false;" class="alink03 mWeb">친구에게 공유하기</a>
                    </div>					
					<div class="comment-list" id="comment">
						<p>총 <%=iCTotCnt%>분이 동참 해주셨습니다.</p>
						<% If isArray(arrCList) Then %>
						<ul>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<div class="cmt-area">
									<p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
									<p class="txt"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
									<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님</p>
								</div>	
									<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
									<button type="button" class="btn-delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/fixevent/play/life/577/m/btn_cmt_delete.png" alt="코멘트 삭제" /></button>
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
			<!--// 컨텐츠 영역 -->				
<!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->					