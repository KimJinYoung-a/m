<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	:  2019.03.20 정태훈 생성
'	Description : culturestation
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/culturestation/culture_stationcls.asp" -->
<!-- #include virtual="/lib/classes/event/viewculturestationCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<%
Dim isMyComm, i, eName, cultype, pagereload
Dim arrUserid, bdgUid, bdgBno
dim oevent , idx_ix , eventstats, oeventtop
dim page, evt_code, evt_type, appevturl
dim cEvent, eCode, cEventadd
'	page = getNumeric(requestCheckVar(request("page"),5))
	if page = "" then page = 1
	evt_code = getNumeric(requestCheckVar(request("evt_code"),10))
	pagereload	= requestCheckVar(request("pagereload"),2)

'// 이벤트코드가 숫자인지 체크 아니면 팅겨냄
if evt_code = ""  or not(IsNumeric(evt_code)) then
	response.write "<script>"
	response.write "alert('이벤트코드가 없거나 승인된 페이지가 아닙니다.');"
	response.write "history.go(-1);"
	response.write "</script>"
	dbget.close()	:	response.End
end if

dim vSArray, vSArray2, vSArray3, intSL
'// 이벤트 세부내용
set oevent = new cevent_list
	oevent.frectevt_type = evt_type
	oevent.frectevt_code =  evt_code
	oevent.frectevent_limit = 1
	oevent.fevent_view()

'// 이벤트 시작전이면 STAFF를 제외한 이벤트 메인으로 리다이렉션
if datediff("d",oevent.FOneItem.fstartdate,date)<0 and GetLoginUserLevel<>"7" then
	response.redirect("/culturestation/index.asp")
	dbget.close()   :   response.End
end If

if oevent.FOneItem.fevt_state<7 and GetLoginUserLevel<>"7" then
	response.redirect("/culturestation/index.asp")
	dbget.close()   :   response.End
end If

if oevent.ftotalcount = 0 then
	response.write "<script>"
	response.write "alert('존재 하지 않는 이벤트 입니다');"
	response.write "history.go(-1);"
	response.write "</script>"
	dbget.close()	:	response.End
end if
eCode = evt_code
	set cEvent = new ClsEvtCont
		cEvent.FECode = eCode

	vSArray = oevent.fnGetEventMultiContentsMaster

    If isArray(vSArray) THEN
        For intSL = 0 To UBound(vSArray,2)
            oevent.FMenuIDX = vSArray(0,intSL)
            if vSArray(1,intSL)="1" then
                vSArray2 = oevent.fnGetEventMultiContentsSwife
            end if
            if vSArray(1,intSL)="2" then
                vSArray3 = oevent.fnGetEventMultiContentsVideo
            end if
        Next
	end if

set oeventtop = new cevent_list
	oeventtop.frectevt_code=evt_code
	oeventtop.fevent_top5_list()

dim oip_comment
	set oip_comment = new cevent_list
	oip_comment.FPageSize = 5
	oip_comment.FCurrPage = page
	oip_comment.frectevt_code = evt_code
	if isMyComm="Y" then oip_comment.frectUserid = GetLoginUserID
	oip_comment.fevent_comment()
	
eventstats = datediff("d",oevent.FOneItem.fenddate,date())
evt_type= oevent.FOneItem.fevt_type
ename	= oevent.FOneItem.fevt_name

if evt_type = 0 then
	cultype="느껴봐"
elseif evt_type = 1 then
	cultype="읽어봐"
elseif evt_type = 2 then
	cultype="들어봐"
else
	cultype="컬쳐"
end if

If isapp = "1" Then
	appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
Else
	appevturl = "/event/eventmain.asp?"
End If 

'// Facebook 오픈그래프 메타태그 작성 (head.asp에서 출력)
strOGMeta = strOGMeta & "<meta property=""og:title"" content=""[텐바이텐] " & replace(ename,"""","") & """ />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/culturestation/culturestation_event.asp?evt_code=" & evt_code & """ />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:image"" content=""" & oevent.FOneItem.Fimage_barner2 & """ />" & vbCrLf
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
$(function(){
	$('.evt-sliderV19 .pagination-progressbar-fill').css('background', '<%=oevent.FOneItem.fnEventThemeColorCode%>'); // for dev msg : 테마색상 등록

	// 다른 컬쳐스테이션
	var swiper1 = new Swiper("#other-cult-evt .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
	});

	// 상세 상단 bg
	var posterImg = $('.cult-poster img').attr('src');
	$('.cult-bg .bg-img').css('background-image','url('+posterImg+')');

	// I형 이미지 슬라이더
	$('.evt-sliderV19').each(function(index, slider) {
		var slider = $(this).find('.swiper-container');
		var amt = slider.find('.swiper-slide').length;
		var progress = $(this).find('.pagination-progressbar-fill');
		if (amt > 1) {
			var evtSwiper = new Swiper(slider, {
				autoplay: 1700,
				loop: true,
				speed: 800,
				autoplayDisableOnInteraction: false,
				onInit: function(evtSwiper) {
					var init = (1 / amt).toFixed(2);
					progress.css('transform', 'scaleX(' + init + ') scaleY(1)');
				},
				onSlideChangeStart: function(evtSwiper) {
					var activeIndex = evtSwiper.activeIndex;
					var realIndex = parseInt(evtSwiper.slides.eq(activeIndex).attr('data-swiper-slide-index') || activeIndex, 10);
					var calc = ( (realIndex+1) / amt ).toFixed(2);
					progress.css('transform', 'scaleX(' + calc + ') scaleY(1)');
				}
			});
		} else {
			var evtSwiper = new Swiper(slider, {
				noSwiping: true,
				noSwipingClass: '.noswiping'
			});
			$(this).find('.pagination-progressbar').hide();
		}
	});
});

$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",300);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#replyList").offset().top}, 0);
}
//코맨트 삭제
function DelComments(cmtidx){
	<% IF not(IsUserLoginOK) THEN %>
		if(confirm("로그인을 하셔야 삭제할 수 있습니다.\n로그인 하시겠습니까?") == true) {
			parent.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=/culturestation/culturestation_event.asp?evt_code=<%=evt_code%>";
			return true;
		} else {
			return false;
		}
	<% end if %>

	if(confirm("선택한 댓글을 삭제하시겠습니까?") == true) {
		//'코멘트 idx 추가
		document.frmactNew.Cidx.value = cmtidx;
	
		var str = $.ajax({
			type: "GET",
	        url: "/culturestation/doEventComment.asp",
	        data: $("#frmactNew").serialize(),
	        dataType: "text",
	        async: false
		}).responseText;
		
		if (str.length=='2'){
			if (str=='d1'){
				location.href = "/culturestation/culturestation_event.asp?evt_code=<%=evt_code%>&pagereload=ON";
			}else if (str=='99'){
				alert('로그인을 해주세요.');
				return;
			}
		}else{
			alert('정상적인 경로가 아닙니다.');
			return;
		}
	} else {
		return false;
	}
}

function DelComments(v){
    if (confirm('삭제 하시겠습니까?')){
        document.frmact.mode.value= "del";
        document.frmact.Cidx.value = v;
        document.frmact.submit();
    }
}
</script>
<% If requestCheckVar(Request("comm"),1) = "o" Then %>
<script>$('html, body').animate({ scrollTop: $(".replyList").offset().top }, 0)</script>
<% End If %>
</head>
<body class="default-font body-sub bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->

	<!-- contents -->
	<div id="content" class="content">
		<div class="section-event event-head">
			<p class="date"><%= oevent.FOneItem.fstartdate %>~<%= left(oevent.FOneItem.fenddate,10) %></p>
			<div class="btnGroup">
				<a href="" onClick="popSNSShare('<%=oevent.FOneItem.fevt_name%>','<%=wwwUrl&CurrURLQ()%>','10x10 이벤트','<%=oevent.FOneItem.Fimage_barner2%>'); return false;" class="btnShare"><span></span>공유하기</a>
			</div>
		</div>

		<!-- 컨텐츠 이미지 -->
		<div class="cult-poster">
			<div class="cult-desc">
				<span class="label"><%= oevent.FOneItem.GetEvtKindName %></span>
				<h2><%= oevent.FOneItem.fevt_name %></h2>
				<!-- for dev msg : 이미지 alt값 Event명으로 뿌려 주세요 -->
				<figure><img src="<%=oevent.FOneItem.Fimage_barner2%>" alt=""></figure>
			</div>
			<div class="cult-bg"><i class="bg-img"></i></div>
		</div>
        <% If oevent.FOneItem.fevt_html<>"" Then %>
		<div class="cult-text2"><%=oevent.FOneItem.fevt_html%></div>
        <% end if %>
        <% If oevent.FOneItem.fevt_html_mo<>"" Then %>
		<div class="cult-text2"><%=oevent.FOneItem.fevt_html_mo%></div>
        <% end if %>
		<!-- 멀티 컨텐츠 -->
		<% sbMultiContentsView %>
		<!--// 멀티 컨텐츠 -->
        <% if oevent.foneitem.fiscomment then %>
		<!-- 코멘트 이벤트 --> <!-- for dev msg : 컬쳐스테이션 에서는 comment-eventV19a 도 같이 붙여주세요 -->
		<section class="comment-eventV19 comment-eventV19a" style="background:<%=oevent.FOneItem.fnEventThemeColorCode%>;"> <!-- for dev msg : 테마색상 등록 -->
			<h3>Comment Event</h3>
			<p class="topic"><%=oevent.FOneItem.fcomm_text%></p>
			<ul>
				<li>작성기간 <span class="date"><%=formatdate(oevent.FOneItem.fcomm_start,"0000.00.00")%> ~ <%=formatdate(oevent.FOneItem.fcomm_end,"0000.00.00")%></span></li>
				<li>당첨자 발표 <span class="date"><%=formatdate(oevent.FOneItem.fevt_prizedate,"0000.00.00")%></span></li>
			</ul>
		</section>
        <% end if %>
        <div class="inner5 tMar25" id="replyList">
			<% if oevent.foneitem.fiscomment then %>
			<!-- 댓글 리스트 -->
			<%
				dim cEComment, iCTotCnt, arrCList, intCLoop

				'코멘트 데이터 가져오기
				set cEComment = new ClsEvtComment
				cEComment.FECode        = eCode   '관련코드 = 온라인 코드
				cEComment.FComGroupCode = 0
				cEComment.FEBidx        = ""
				cEComment.FCPage        = 1 '현재페이지
				cEComment.FPSize        = 5 '페이지 사이즈
				cEComment.FTotCnt       = -1  '전체 레코드 수
				arrCList = cEComment.fnGetComment
				iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
				set cEComment = nothing
			%>
            <div id="replyList" class="replyList box1 evtReplyV15">
                <p class="total">총 <%=iCTotCnt%>개의 댓글이 있습니다.</p>
                <% If Trim(oevent.FOneItem.fevt_prizedate) <> "" Then %>
                    <% If Left(oevent.FOneItem.fevt_prizedate, 10) <= Left(Now(), 10) Then %>
                        <a href="" onClick="alert('당첨자 발표일이 지난 이벤트 입니다.'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
                    <% Else %>
                        <a href="" onClick="fnOpenModal('/event/event_comment.asp?view=w&eventid=<%=eCode%>'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
                    <% End If %>
                <% Else %>
                    <a href="" onClick="fnOpenModal('/event/event_comment.asp?view=w&eventid=<%=eCode%>'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
                <% End If %>
                <%IF isArray(arrCList) THEN
                    '사용자 아이디 모음 생성(for Badge)
                    for intCLoop = 0 to UBound(arrCList,2)
                        arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(arrCList(2,intCLoop)) & "''"
                    next

                    '뱃지 목록 접수(순서 랜덤)
                    Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")
                %>
                <ul>
                    <%For intCLoop = 0 To UBound(arrCList,2)%>
                    <li>
                        <p class="num"><%=iCTotCnt-intCLoop-(Int(iCTotCnt/3)*(1-1))%><% If arrCList(8,intCLoop) <> "W" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
                        <div class="replyCont">
                            <%
                                Dim strBlog
                                'URL이 존재하고 본인 또는 STAFF가 접속해있다면 링크 표시
                                strBlog = ReplaceBracket(db2html(arrCList(7,intCLoop)))
                                if trim(strBlog)<>"" and (GetLoginUserLevel=7 or arrCList(2,intCLoop)=GetLoginUserID) then
                                    Response.Write "<p class='bMar05'><strong>URL :</strong> <a href='" & ChkIIF(left(trim(strBlog),4)="http","","http://") & strBlog & "' target='_blank'>" & strBlog & "</a></p>"
                                end if
                            %>
                            <p><%=striphtml(db2html(arrCList(1,intCLoop)))%></p>
                            <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
                            <p class="tPad05">
                                <span class="button btS1 btWht cBk1"><a href="" onClick="DelComments('<% = arrCList(0,intCLoop) %>'); return false;">삭제</a></span>
                            </p>
                            <% end if %>
                            <div class="writerInfo">
                                <p><%=FormatDate(arrCList(4,intCLoop),"0000.00.00")%> <span class="bar">/</span> <% if arrCList(2,intCLoop)<>"10x10" then %><%=printUserId(arrCList(2,intCLoop),2,"*")%><% End If %></p>
                                <p class="badge">
                                    <%=getUserBadgeIcon(arrCList(2,intCLoop),bdgUid,bdgBno,3)%>
                                </p>
                            </div>
                        </div>
                    </li>
                    <% Next %>
                </ul>
                <% ELSE %>
                    <p class="no-data ct">해당 게시물이 없습니다.</p>
                <% END IF %>
                <% If isArray(arrCList) Then %>
                <div class="btnWrap tPad15">
                    <span class="button btM1 btBckBdr cBk1 w100p"><a href="" onClick="fnOpenModal('/event/event_comment.asp?view=l&eventid=<%=eCode%>&epdate=<%=oevent.FOneItem.fevt_prizedate%>'); return false;"><em>전체보기</em></a></span>
                </%=oevent.FOneItem.fevt_prizedate%>
                <% End If %>
            </div>
			<% end if %>
			<div class="cult-station">
                <div class="other-cult">
                    <section id="other-cult-evt" class="swiperCarousel newArrivalV16">
                        <div class="hgroup">
                            <h2>다른 컬쳐스테이션</h2>
                            <a href="/culturestation/" class="btn-more btn-arrow">더보기</a>
                        </div>
                        <div class="swiper-container">
                            <div class="swiper-wrapper">
                                <% if oeventtop.FResultCount>0 Then %>
                                <% for i=0 to oeventtop.FResultCount-1 %>
                                <div class="swiper-slide">
                                    <a href="culturestation_event.asp?evt_code=<%=oeventtop.FItemList(i).fevt_code%>">
                                    <div class="thumbnail"><img src="<%=oeventtop.FItemList(i).fimage_barner2%>" alt="" /></div>
                                    <div class="des">
                                        <% If oeventtop.FItemList(i).fevt_kind="3" Then %>
                                        <span class="label musical">
                                        <% ElseIf oeventtop.FItemList(i).fevt_kind="4" Then %>
                                        <span class="label book">
                                        <% Else %>
                                        <span class="label">
                                        <% End If %><%=oeventtop.FItemList(i).GetEvtKindName%></span>
                                        <p class="tit"><%=oeventtop.FItemList(i).fevt_name%></p>
                                    </div>
                                    </a>
                                </div>
                                <% Next %>
                                <% End If %>
                            </div>
                        </div>
                    </section>
                </div>
			</div>
        </div>
        <form name="frmact" method="post" action="/event/lib/doEventComment.asp" target="iframeDB" style="margin:0px;">
        <input type="hidden" name="mode" value="del">
        <input type="hidden" name="Cidx" value="">
        <input type="hidden" name="userid" value="<%= GetLoginUserID %>">
        <input type="hidden" name="returnurl" value="/culturestation/culturestation_event.asp?evt_code=<%= eCode %>&comm=o">
        <input type="hidden" name="eventid" value="<%= eCode %>">
        </form>
		<!--// 댓글 리스트 -->
        
		<iframe src="about:blank" name="iframeDB" frameborder="0" width="0" height="0"></iframe>
	</div>
	<!-- //contents -->

	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
set oevent = nothing
set oip_comment = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->