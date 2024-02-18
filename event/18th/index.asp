<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
    Dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1) '// gnb사용여부

    If gnbflag = "" Then '// gnb 표시여부
        gnbflag = true
        strHeadTitleName = ""
    Else
        gnbflag = False
        strHeadTitleName = "오늘의 취향"
    End if        
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script>
$(function(){
    // 취향 day nav
	dateSwiper = new Swiper('.day-nav .swiper-container',{
		initialSlide:0,
		slidesPerView:'auto',
		speed:300
	});
	$('.day-nav .swiper-slide.coming').on('click', function(e){
		e.preventDefault();
		alert("coming soon :)");
    });

    // 타인의 취향 도형 랜덤 바인딩
    $('.othr-list li:nth-child(8n-5)').addClass('figure'); // 3번째
    $('.othr-list li:nth-child(8n)').addClass('figure'); // 8번째
    $( ".figure" ).each(function() {
        var random10 = Math.floor(Math.random() * 10) + 1;
        $(this).css({'background-image': 'url(//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_fg'+ random10 +'.png)' })
     });

    $('.lyr-taste').show();
});
// 취향 팝업 레이어 닫기
function ClosePopLayer() {
    $('.lyr-taste').hide();
}
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->	
	<div id="content" class="content">
		<div class="evtContV15">
            <div class="anniversary18th main bg-random">
                <!-- #include virtual="/event/18th/lib/head18th.asp" -->
                <!-- intro -->
                <div class="intro">
                    <div class="inner">
                        <span class="anniversary">18th</span>
                        <h2>Your 10X10</h2>
                        <div class="intro-sub">18번째 생일,<br>텐바이텐과 함께 해주셔서 고맙습니다.</div>
                        <ul class=evt-list>
                            <li><a href="/event/eventmain.asp?eventid=97589">스누피의 선물 <span class="icon-chev"></span></a></li>
                            <li><a href="/event/eventmain.asp?eventid=97588">나에게 텐바이텐은? <span class="icon-chev"></span></a></li>
                        </ul>
                    </div>
                </div>
                <!--// intro -->

                <!-- taste -->
                <div class="taste">
                    <div class="top">
                        <div class="inner">
                            <!-- mw 변경 -->
                            <% If IsUserLoginOK Then %>
                                <h3>오늘, <br><span class="name"><%=getLoginUserName%></span>님의 취향<span class="only-app">APP 전용</span></h3>
                            <% Else %>
                                <h3>오늘, <br><span class="name">당신</span>의 취향<span class="only-app">APP 전용</span></h3>
                            <% End If %>
                            <!--// mw 변경 -->
                            <div class="taste-sub">당신이<br>좋아하는 것들을 알려주세요.</div>
                            <div class="taste-date">기간 : 10.01 – 31 | 당첨자 발표 : 11.04</div>
                            <div class="bnfit">
                                <div class="bnfit-item">
                                    <div class="bnfit-date">EVERY<br>DAY</div>
                                    <div class="bnfit-conts"><span>SPECIAL GIFT</span><p>매일 오픈하는 오늘의 취향을  등록해 주신 분께 <strong>스페셜 선물</strong>을 드립니다. (당일 참여자에 한함) </p></div>
                                </div>
                                <div class="bnfit-item">
                                    <div class="bnfit-date">LAST<br>DAY</div>
                                    <div class="bnfit-conts"><span>100만원 기프트 카드</span><p>매일 참여하지 않아도 30개의 취향을 모두 등록해주신 분 중 <strong>10명에게 텐바이텐 기프트카드 100만원</strong>을 선물로 드립니다.</p></div>
                                </div>
                            </div>

                            <!-- mw 변경 -->
                            <!-- for dev msg 모웹에서만 노출되는 버튼입니다. 앱스토어 혹은 텐텐앱으로 이동시켜주세요. -->
                            <button class="btn-app" onclick="location.href='https://tenten.app.link/tg8oonbDh0'">APP에서 참여하기<span class="icon-chev"></span></button>
                            <!--// mw 변경 -->
                        </div>
                    </div>
                </div>
                <!--// taste -->
            </div>        
        </div>
	</div>	
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->