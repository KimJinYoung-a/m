<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 매일리지
' History : 2021.06.29 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<%
	'// 기본은 매일 출석체크
	Dim userid, vQuery, currenttime, vEventStartDate, vEventEndDate, mobileEventCode, eCode
	Dim i, numTimes, TodayCount, TotalMileage, TodayDateCheck, mktTest, ix

	IF application("Svr_Info") = "Dev" THEN
		eCode  = 108375             '// 매일리지 코드
        mobileEventCode = 108374    '// 모바일 이벤트 코드
	    mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode  = 112590             '// 매일리지 코드
        mobileEventCode = 112589    '// 모바일 이벤트 코드
        mktTest = True
    Else
		eCode  = 112590             '// 매일리지 코드
        mobileEventCode = 112589    '// 모바일 이벤트 코드
        mktTest = False
	End If

	Dim gaparamChkVal
	gaparamChkVal = requestCheckVar(request("gaparam"),30) 
	userid = GetEncLoginUserID()

	'// 현재시간
	currenttime = now()

	if mktTest then
		currenttime=request("checkday")
	end if

	vEventStartDate = "2021-07-07"
	vEventEndDate = "2021-07-26"

	If isapp <> "1" Then 
		Response.redirect "/event/eventmain.asp?eventid="&mobileEventCode&"&gaparam="&gaparamChkVal
		Response.End
	End If

	'// 연속출석 체크
	TodayCount = 0
	numTimes = datediff("d", vEventStartDate, currenttime)
	'Response.write "numTimes : "&datediff("d", vEventStartDate, currenttime)&"<br>"

	If IsUserLoginOK() Then
		'현재날짜를 기준으로 이벤트 시작일로 부터 몇일째인지 가져온다.
        vQuery = "SELECT count(sub_opt3) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"'"
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
        IF Not(rsget.Bof Or rsget.Eof) Then
            TodayCount = rsget(0)
        Else
            TodayCount = 0
        End If
        'Response.write TodayCount&"<br>"
        rsget.close

		' 현재까지 발급받은 총 마일리지값을 가져온다.
		vQuery = "SELECT isnull(sum(sub_opt2), 0) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		TotalMileage = rsget(0)
		rsget.close

		' 오늘 출석체크를 했는지 확인한다.
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And CONVERT(VARCHAR(10), regdate, 120) = '"&Left(currenttime, 10)&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		TodayDateCheck = rsget(0)
		rsget.close
	End If
%>
<style>
.mEvt112590 {position:relative; overflow:hidden; background:#fff;}
.mEvt112590 .topic {position:relative;}
.mEvt112590 .topic .tit {width:53.87vw; position:absolute; left:50%; top:6.52rem; margin-left:-26.93vw; opacity:0; transform:translateY(15%); transition:all 1s;}
.mEvt112590 .topic .tit.on {opacity:1; transform:translateY(0);}
.mEvt112590 .topic .icon-float {width:28.93vw; position:absolute; right:.8rem; top:61%; z-index:10; animation: updown 1s linear alternate infinite;}
.mEvt112590 .topic .icon-float.fixed {position:fixed; top:10%;}
.mEvt112590 .topic .icon-float.hides {position: absolute; top:385%;}
.mEvt112590 .topic .icon-float a {display:inline-block; width:100%; height:100%;}
.mEvt112590 .section-01 {position:relative;}
.mEvt112590 .section-01 .txt-01 {width:73.47vw; position:absolute; left:50%; top:4%; margin-left:-36.73vw;}
.mEvt112590 .section-01 .txt-02 {width:54.13vw; position:absolute; left:50%; top:33.5%; margin-left:-27.06vw;}
.mEvt112590 .section-01 .txt-03 {width:70.40vw; position:absolute; left:50%; top:67%; margin-left:-35.20vw;}
.mEvt112590 .section-01 .txt-04 {width:59.87vw; position:absolute; left:50%; top:89%; margin-left:-29.93vw;}
.mEvt112590 .section-02 {position:relative;}
.mEvt112590 .section-02 .day-point {display:flex; flex-wrap:wrap; position:absolute; left:50%; top:47%; width:76.67vw; margin-left:-38.33vw;}
.mEvt112590 .section-02 .day-point div {width:20.13vw; height:27.73vw; margin-bottom:2.60rem;}
.mEvt112590 .section-02 .day-point div:nth-child(2),
.mEvt112590 .section-02 .day-point div:nth-child(5),
.mEvt112590 .section-02 .day-point div:nth-child(8) {margin:0 8vw;}
.mEvt112590 .section-02 .day-point div.on {animation: flap 1s ease;}
.mEvt112590 .section-02 .day-point div:nth-child(1) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day1_off.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div:nth-child(2) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day2_off.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div:nth-child(3) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day3_off.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div:nth-child(4) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day4_off.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div:nth-child(5) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day5_off.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div:nth-child(6) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day6_off.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div:nth-child(7) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day7_off.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div:nth-child(8) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day8_off.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div:nth-child(9) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day9_off.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div.on:nth-child(1) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day1_on.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div.on:nth-child(2) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day2_on.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div.on:nth-child(3) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day3_on.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div.on:nth-child(4) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day4_on.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div.on:nth-child(5) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day5_on.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div.on:nth-child(6) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day6_on.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div.on:nth-child(7) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day7_on.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div.on:nth-child(8) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day8_on.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-02 .day-point div.on:nth-child(9) {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/cup_day9_on.png) no-repeat 0 0; background-size:20.13vw 27.73vw;}
.mEvt112590 .section-03 {position:relative;}
.mEvt112590 .section-03 .price-box {position:absolute; left:0; top:31%; width:100%; text-align:center;}
.mEvt112590 .section-03 .price-box .name {padding-bottom:2.47rem; font-size:1.73rem; color:#008aff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt112590 .section-03 .price-box .name span {text-decoration:underline; text-decoration-color:#008aff;}
.mEvt112590 .section-03 .price-box .price,
.mEvt112590 .section-03 .price-box .day {font-size:1.39rem; color:#111; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt112590 .section-03 .price-box .price {padding-bottom:1.04rem;}
.mEvt112590 .section-03 .price-box .txt-login {width:13.57rem; margin:0 auto;}
.mEvt112590 .section-03 .price-box a {display:inline-block; width:100%; height:100%;}
.mEvt112590 .sec-link a {display:inline-block;}
.mEvt112590 .area-apply {position:relative;}
.mEvt112590 .area-apply .btn-apply {width:100%; height:10rem; position:absolute; left:0; top:10%; background:transparent;}
.mEvt112590 .btn-detail {position:relative;}
.mEvt112590 .btn-detail span {position:absolute; right:29%; top:.5rem; width:3.07vw; height:1.87vw; margin-right:-1.53vw;}
.mEvt112590 .detail-info {display:none;}
.mEvt112590 .detail-info.on {display:block;}
.mEvt112590 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.6); z-index:150;}
.mEvt112590 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt112590 .pop-container .pop-inner a {display:inline-block;}
.mEvt112590 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.78rem; height:1.78rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/112590/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt112590 .pop-contents {position:relative;}
.mEvt112590 .pop-contents .name {width:100%; text-align:center; position:absolute; left:50%; top:11%; transform:translate(-50%,0); font-size:2.17rem; color:#fff; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt112590 .pop-contents .name.type02 {top:18%;}
.mEvt112590 .pop-contents .name span {padding-right:1rem;}
.mEvt112590 .pop-contents a {width:100%; height:10rem; position:absolute; left:0; bottom:0;}
.mEvt112590 .pop-contents .btn-alram {height:14rem;}
.mEvt112590 .check-mg {width:100%; position:absolute; left:0; top:62%; text-align:center;}
.mEvt112590 .check-mg p {padding-bottom:0.86rem; font-size:1.30rem; color:#111;}
.mEvt112590 .check-mg p:nth-child(2) {padding-bottom:1.52rem;}
.mEvt112590 .check-mg span {font-size:1.30rem; color:#008aff; text-decoration:underline; text-decoration-color:#008aff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt112590 .sec-video .video-inner {position:relative; padding-bottom:56.25%; height:0;}
.mEvt112590 .sec-video .video-inner iframe {position:absolute; top:0; left:0; width:100%; height:100%;}

.mEvt112590 .animate {opacity:0; transform:translateY(15%); transition:all 1s;}
.mEvt112590 .animate.on {opacity:1; transform:translateY(0);}
@keyframes flap {
    0% {transform: rotateY(0);}
    100% {transform: rotateY(360deg);}
}
@keyframes turn {
    0% {transform: rotate(0);}
    100% {transform: rotate(360deg);}
}
@keyframes updown {
    0% {transform:translateY(-1rem);}
    100% {transform:translateY(1rem);}
}
</style>
<script>
$(function() {
    $('.topic .tit').addClass('on');
    $(window).scroll(function(){
        $('.animate').each(function(){
			var y = $(window).scrollTop() + $(window).height() * 1;
			var imgTop = $(this).offset().top;
			if(y > imgTop) {
				$(this).addClass('on');
			}
		});
        var height = $(document).scrollTop();
        var topsec = $('.tit').offset().top + 256.06;
        var bottomsec = $('.section-02').offset().top;
        if(height > topsec){ 
            $('.icon-float').addClass('fixed'); 
        }else { 
            $('.icon-float').removeClass('fixed'); 
        }

        if(height > bottomsec){
            $('.icon-float').addClass('hides'); 
        }else { 
            $('.icon-float').removeClass('hides'); 
        }
    });
    $('.btn-detail').on('click',function(){
        if($(this).next('.detail-info').hasClass('on')) {
            $(this).next('.detail-info').removeClass('on');
            $(this).children('.arrow').css('transform','rotate(0)');
        } else {
            $(this).next('.detail-info').removeClass('on');
            $(this).next('.detail-info').addClass('on');
            $(this).children('.arrow').css('transform','rotate(180deg)');
        }
    });
    // 푸시알림 팝업
    $('.mEvt112590 .btn-push').click(function(){
        
    })
    // 팝업 닫기
    $('.mEvt112590 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    });
});
function jsMaeilageSubmit(){

    fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|mileageok','');

    <% If not(IsUserLoginOK) Then %>
        parent.calllogin();
        return false;
    <% end if %>

    <% If not( left(trim(currenttime),10)>=trim(vEventStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) ) Then %>
        alert("이벤트 응모기간이 아닙니다.");
        return false;
    <% end if %>

    $.ajax({
        type:"GET",
        <% if mktTest then %>
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript112590.asp?mode=add&checkday=<%=request("checkday")%>",
        <% else %>
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript112590.asp?mode=add",
        <% end if %>
        dataType: "text",
        async:false,
        cache:true,
        success : function(Data, textStatus, jqXHR){
            if (jqXHR.readyState == 4) {
                if (jqXHR.status == 200) {
                    if(Data!="") {
                        var str;
                        for(var i in Data)
                        {
                                if(Data.hasOwnProperty(i))
                            {
                                str += Data[i];
                            }
                        }
                        //str = str.replace("undefined","");
                        res = Data.split("|");
                        if (res[0]=="OK")
                        {
                            $("#day"+res[2]).addClass("on");
                            $("#totalm").empty().html(res[3]);
                            $("#totalday").empty().html(res[2]);
                            $("#nowmile").empty().html(res[4]);
                            $("#tomile").empty().html(res[1]);
                            $('.pop-container.apply').fadeIn();
                        }
                        else
                        {
                            errorMsg = res[1].replace(">?n", "\n");
                            alert(errorMsg);
                            return false;
                        }
                    } else {
                        alert("잘못된 접근 입니다[0].");
                        document.location.reload();
                        return false;
                    }
                }
            }
        },
        error:function(jqXHR, textStatus, errorThrown){

                alert("잘못된 접근 입니다[1].");
                var str;
                for(var i in jqXHR)
                {
                        if(jqXHR.hasOwnProperty(i))
                    {
                        str += jqXHR[i];
                    }
                }
                alert(str);
                document.location.reload();
                return false;

        }
    });
}
function fnApplyPopClose(){
    $(".pop-container.apply").fadeOut();
}

function jsMaeilagePushSubmit(){

    fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|alarm','');

    <% If not(IsUserLoginOK) Then %>
        parent.calllogin();
        return false;
    <% end if %>

    <% If not( left(trim(currenttime),10)>=trim(vEventStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) ) Then %>
        alert("이벤트 응모기간이 아닙니다..");
        return false;
    <% end if %>

    $.ajax({
        type:"GET",
        <% if mktTest then %>
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript112590.asp?mode=pushadd&checkday=<%=request("checkday")%>",
        <% else %>
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript112590.asp?mode=pushadd",
        <% end if %>
        dataType: "text",
        async:false,
        cache:true,
        success : function(Data, textStatus, jqXHR){
            if (jqXHR.readyState == 4) {
                if (jqXHR.status == 200) {
                    if(Data!="") {
                        var str;
                        for(var i in Data)
                        {
                                if(Data.hasOwnProperty(i))
                            {
                                str += Data[i];
                            }
                        }
                        //str = str.replace("undefined","");
                        res = Data.split("|");
                        if (res[0]=="OK")
                        {
                            $('.pop-container.push').fadeIn();
                        }
                        else
                        {
                            errorMsg = res[1].replace(">?n", "\n");
                            alert(errorMsg);
                            return false;
                        }
                    } else {
                        alert("잘못된 접근 입니다[2].");
                        document.location.reload();
                        return false;
                    }
                }
            }
        },
        error:function(jqXHR, textStatus, errorThrown){

                alert("잘못된 접근 입니다[3].");
                var str;
                for(var i in jqXHR)
                {
                        if(jqXHR.hasOwnProperty(i))
                    {
                        str += jqXHR[i];
                    }
                }
                alert(str);
                document.location.reload();
                return false;

        }
    });
}
</script>
			<div class="mEvt112590">
				<div class="topic">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/bg_main.jpg" alt="다짐 프로젝트 01">
                    <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/tit_main.png?v=2" alt="하루에 한잔 더"></div>
                    <div class="icon-float">
                        <a href="#btnCheck">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/icon_float.png" alt="이벤트 확인하기">
                        </a>
                    </div>
				</div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/bg_sub01.jpg" alt="">
                    <div class="txt-01 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/txt_sub01.png" alt="나도 물 2리터 마시기 해볼래"></div>
                    <div class="txt-02 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/txt_sub02.png" alt="하루에 딱 한 잔만 더 마시기"></div>
                    <div class="txt-03 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/txt_sub03.png" alt="나에게는 어떤 순간이 좋을지 떠올려보세요."></div>
                    <div class="txt-04 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/txt_sub04.png" alt="우리 좀 더 활기찬 여름을 보내보아요."></div>
                </div>
                <div id="btnCheck" class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/tit_event.jpg" alt="하루에 한번씩 물을 마시면 점점 불어나는 마일리지를 드려요!">
                    <div class="day-point">
                    <% for ix=1 to 9 %>
                        <% if ix <= TodayCount then %>
                        <div class="on" id="day<%=ix%>" title="day<%=ix%>"></div>
                        <% else %>
                        <div id="day<%=ix%>" title="day<%=ix%>"></div>
                        <% end if %>
                    <% next %>
                    </div>
                </div>
                <!-- 마일리지 받기 버튼 -->
                <button type="button" class="btn-apply" <% If TodayDateCheck > 0 Then %>onclick="alert('이미 참여하셨습니다.');"<% Else %>onclick="jsMaeilageSubmit();"<% End If %>>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/btn_drink.jpg" alt="오늘의 물 마시기">
                </button>
                <div class="section-03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/img_log.jpg" alt="본 마일리지는 스페셜 마일리지 입니다.">
                    <div class="price-box">
                        <!-- 비 로그인 일때 : 클릭시 로그인 페이지로 이동 -->
                        <!-- 로그인 일때 : 클릭시 마일리지 페이지로 이동 -->
                        <% If IsUserLoginOK() Then %>
                        <a href="#">
                            <div class="name">
                                <span><%=GetLoginUserName()%></span>님의 기록
                            </div>
                            <div>
                                <div class="price">
                                    현재까지 받은 금액:<span id="totalm"><%=FormatNumber(TotalMileage,0)%></span>
                                </div>
                                <div class="day">
                                    현재까지 성공한 날:<span id="totalday"><%=TodayCount%></span>일
                                </div>
                            </div>
                        </a>
                        <% else %>
                        <a href="javascript:parent.calllogin();return false;">
                            <div class="name">
                                나의 기록
                            </div>
                            <div class="txt-login">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/txt_logincheck.png" alt="로그인하고 확인하세요!">
                            </div>
                        </a>
                        <% end if %>
                    </div>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/bg_wave.jpg?v=2" alt="">
                <% if left(currenttime,10)<"2021-07-26" then %>
                <button type="button" class="btn-push" onclick="jsMaeilagePushSubmit();return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/img_alram02.jpg?v=2" alt="내일 알람 신청하기">
                </button>
                <% end if %>
                <button type="button" class="btn-detail">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/btn_detail.jpg" alt="이벤트 유의사항 자세히 보기">
                    <span class="arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/icon_arrow.png" alt="화살표"></span>
                </button>
                <div class="detail-info">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/img_detail_info.jpg" alt="응모방법">
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/tit_cup.jpg" alt="귀여워서 자꾸 마시고 싶어져요">   
                <div class="sec-link">
                    <a href="#" onclick="fnAPPpopupProduct('3279440&pEtr=112590'); return false;" class=""><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/img_cup01.jpg" alt="link01"></a>
                    <a href="#" onclick="fnAPPpopupProduct('3893658&pEtr=112590'); return false;" class=""><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/img_cup02.jpg" alt="link02"></a>
                    <a href="#" onclick="fnAPPpopupProduct('3746840&pEtr=112590'); return false;" class=""><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/img_cup03.jpg" alt="link03"></a>
                    <a href="#" onclick="fnAPPpopupProduct('2560528&pEtr=112590'); return false;" class=""><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/img_cup04.jpg" alt="link04"></a>
                    <a href="#" onclick="fnAPPpopupProduct('3817453&pEtr=112590'); return false;" class=""><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/img_cup05.jpg" alt="link05"></a>
                    <a href="#" onclick="fnAPPpopupProduct('3881988&pEtr=112590'); return false;" class=""><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/img_cup06.jpg" alt="link06"></a>
                </div>
                <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112414');return false;" class=""><img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/btn_gocup.jpg" alt="추천 컵 보러 가기"></a>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/tit_video.jpg" alt="영상을 재생해보세요.">
                <div class="sec-video">
                    <div class="video-inner">
                        <iframe width="" height="" src="https://www.youtube.com/embed/0tUtNMGM_qY" title="컵 켄텐츠" frameborder="0" allowfullscreen></iframe>
                    </div>
                </div>
                <% if TodayCount < 8 and left(currenttime,10)<"2021-07-26" then %>
                <div class="pop-container apply">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <div class="check-mg">
                                <p><span id="nowmile">100</span>가 적립되었어요!</p>
                                <p>내일 받을 마일리지는 <span id="tomile">200</span>입니다.</p>
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/pop_point.jpg" alt="응모완료">
                            <a href="" onclick="jsMaeilagePushSubmit();fnApplyPopClose();return false;" class="btn-alram"></a>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <% else %>
                <div class="pop-container apply">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <!-- 마일리지 내역 -->
                            <div class="check-mg">
                                <p><span id="nowmile">100</span>가 적립되었어요!</p>
                                <% if left(currenttime,10)="2021-07-26" then %>
                                <p>이벤트에 참여해주셔서 감사합니다. :)</p>
                                <p>이제 본격적으로 물을 마셔볼까요!</p>
                                <% else %>
                                <p>9일간 첨여해주셔서 감사합니다. :)</p>
                                <p>이제 본격적으로 물을 마셔볼까요!</p>
                                <% end if %>
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/pop_last.jpg" alt="응모완료">
                            <!-- 유리컵 구경하러 가기 -->
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112414');return false;" class="btn-alram"></a>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <% end if %>
                <div class="pop-container push">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112590/m/pop_push.jpg" alt="푸시 알림 신청 완료">
                            <a href="" onclick="fnAPPpopupSetting();return false;" class="btn-alram"></a>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->