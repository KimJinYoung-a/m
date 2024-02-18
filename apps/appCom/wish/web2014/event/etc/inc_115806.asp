<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 매일리지 이벤트
' History : 2021.12.01 정태훈
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
		eCode  = 109428             '// 매일리지 코드
        mobileEventCode = 109409    '// 모바일 이벤트 코드
	    mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode  = 115806             '// 매일리지 코드
        mobileEventCode = 115807    '// 모바일 이벤트 코드
        mktTest = True
    Else
		eCode  = 115806             '// 매일리지 코드
        mobileEventCode = 115807    '// 모바일 이벤트 코드
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

	vEventStartDate = "2021-12-06"
	vEventEndDate = "2021-12-19"

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
.mEvt115806 section{position:relative;}

.mEvt115806 .section01 p{position:absolute;top:63%;left:50%;margin-left:-35vw;width:70vw;animation:updown 1s ease-in-out alternate infinite;}
.mEvt115806 .section01 .btn_check{position:absolute;top:75%;left:50%;width:86.7vw;height:20.5vw;margin-left:-43.35vw;text-indent: -999999999px;background:transparent;}

.mEvt115806 .section02 .content01_01{position:relative;display:none;}
.mEvt115806 .section02 .content01_02{position:relative;}
.mEvt115806 .section02 p.user_id{position:absolute;top:20vw;font-size:2.1rem;width:100%;text-align: center;color:#fff;letter-spacing:0rem;font-family: 'CoreSansC', 'AppleSDGothicNeo', 'NotoSansKR';}
.mEvt115806 .section02 p.user_id span{text-decoration: underline;}
.mEvt115806 .section02 .user_id2{position:absolute;top:31vw;font-size:2.8rem;width:100%;text-align: center;color:#fff;letter-spacing: 0rem;font-family: 'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt115806 .section02 .mileage{position:absolute;bottom:33vw;right:0;margin-right:19.3vw;font-size:9vw;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#000;letter-spacing: -0.1rem;line-height:2;}
.mEvt115806 .section02 .content01_01{position:relative;}
.mEvt115806 .section02 .content01_02{position:relative;}
.mEvt115806 .section02 .myMileage{position: absolute;bottom:35vw;right:0;margin-right:12vw;display:block;width:6vw;height:13vw;}

.mEvt115806 .section03 .btnWrap{position:absolute;top:0;left:0;width: 100%;height: 100%;}
.mEvt115806 .section03 .btnWrap div{position:absolute;}
.mEvt115806 .section03 .btnWrap img{position:absolute;width:27vw;}
.mEvt115806 .section03 .btn01{top:0;left:50%;margin-left:-42.6vw;}
.mEvt115806 .section03 .btn02{top:0;left:50%;margin-left:-13.5vw;}
.mEvt115806 .section03 .btn03{top:0;left:50%;margin-left:15.7vw;}
.mEvt115806 .section03 .btn04{top:29vw;left:50%;margin-left:-42.6vw;}
.mEvt115806 .section03 .btn05{top:29vw;left:50%;margin-left:-13.5vw;}
.mEvt115806 .section03 .btn06{top:29vw;left:50%;margin-left:15.7vw;}
.mEvt115806 .section03 .btn07{top:58.5vw;left:50%;margin-left:-42.6vw;}
.mEvt115806 .section03 .btn08{top:58.5vw;left:50%;margin-left:-13.5vw;}
.mEvt115806 .section03 .btn09{top:58.5vw;left:50%;margin-left:15.7vw;}
.mEvt115806 .section03 .btn_on{display:none;}
.mEvt115806 .section03 .btn_off{display:none;}

.mEvt115806 .section04 .btn-apply{position:absolute;top:39.5%;left:50%;width:86.7vw;height:20.5vw;margin-left:-43.35vw;text-indent: -999999999px;background:transparent;}
.mEvt115806 .section04 .noti_wrap .noti{position:absolute;width: 100%;height:10vw;top:93vw;}
.mEvt115806 .section04 .noti_wrap .noti::after{content:'';display:block;background:url(//webimage.10x10.co.kr/fixevent/event/2021/115806/arrow_off.png) no-repeat 0 0;transform: rotate(0deg);position:absolute;bottom:1.8vw;left:73.3vw;background-size:100%;width:3.1vw;height:1rem;}
.mEvt115806 .section04 .noti_wrap .noti.on::after{transform: rotate(180deg);bottom:3.4vw;}
.mEvt115806 .section04 .noti_wrap .notice{display:none;}
 
.mEvt115806 .section05 .bg_dim{position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.4);z-index:5;display:none;}
.mEvt115806 .section05 .popup01{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display:none;}
.mEvt115806 .section05 .popup01 .pop_img{position:absolute;top:39vw;left:50%;}
.mEvt115806 .section05 .popup01 .day{position:absolute;top:44vw;right:22.9vw;font-size:4.5vw;letter-spacing: -0.1rem;color:#fff;}
.mEvt115806 .section05 .popup01 .point{text-align: center;position:absolute;top:79vw;width:100%;font-size:1.5rem;letter-spacing: -0.1rem;line-height: 1.5;}
.mEvt115806 .section05 .popup01 .point span{color:#df2031;}
.mEvt115806 .section05 .point span{text-decoration: underline;}
.mEvt115806 .section05 .popup01 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt115806 .section05 .popup01 .btn_alert{width:80vw;height:19vw;display:block;position:absolute;bottom:6vw;left:50%;margin-left:-40vw;}

.mEvt115806 .section05 .popup02{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display: none;}
.mEvt115806 .section05 .popup02 .day{position:absolute;top:42.5vw;right:22.9vw;font-size:4.5vw;letter-spacing: -0.1rem;color:#fff;}
.mEvt115806 .section05 .popup02 .point{text-align: center;position:absolute;top:77vw;width:100%;font-size:1.5rem;letter-spacing: -0.1rem;line-height: 1.5;}
.mEvt115806 .section05 .popup02 .point span{color:#df2031;}
.mEvt115806 .section05 .today{text-decoration: underline;}
.mEvt115806 .section05 .popup02 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt115806 .section05 .popup02 .btn_alert{width:80vw;height:20vw;display:block;position:absolute;bottom:17vw;left:50%;margin-left:-40vw;background: transparent;text-indent: -999999999px;}

.mEvt115806 .section05 .popup03{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display:none;}
.mEvt115806 .section05 .popup03 .day{position:absolute;top:44vw;right:22.9vw;font-size:4.5vw;letter-spacing: -0.1rem;color:#fff;}
.mEvt115806 .section05 .popup03 .point{text-align: center;position:absolute;top:79vw;width:100%;font-size:1.5rem;letter-spacing: -0.1rem;line-height: 1.5;}
.mEvt115806 .section05 .popup03 .point span{color:#df2031;}
.mEvt115806 .section05 .today{text-decoration: underline;}
.mEvt115806 .section05 .popup03 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt115806 .section05 .popup03 .btn_alert{width:80vw;height:19vw;display:block;position:absolute;bottom:6vw;left:50%;margin-left:-40vw;}

.mEvt115806 .section05 .popup04{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display:none;}
.mEvt115806 .section05 .popup04 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt115806 .section05 .popup04 .btn_alert{width:80vw;height:19vw;display:block;position:absolute;bottom:4rem;left:50%;margin-left:-40vw;background: transparent;text-indent: -999999999px;}

@keyframes updown {
    0% {transform: translateY(-5px);}
    100% {transform: translateY(5px);}
}

</style>
<script>
$(function() {
	$('.noti_wrap .noti').click(function(){
		if($(this).hasClass('on')){
			$(this).removeClass('on');
			$('.notice').css('display','none');
		}else{
			$(this).addClass('on');
			$('.notice').css('display','block');
		}
	});

    $('.btn_close').click(function(){
		$('.bg_dim').css('display','none');
		$(this).parent().css('display','none');
		return false;
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
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript115806.asp?mode=add&checkday=<%=request("checkday")%>",
        <% else %>
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript115806.asp?mode=add",
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
                        <% If left(trim(currenttime),10) = trim(vEventEndDate) Then '마지막날 팝업 %>
                            if(res[2]=="9"){
                                $('.bg_dim').css('display','block');
                                $("#day"+res[2]).removeClass("btn_off");
                                $("#totalm").empty().html(res[3]);
                                $('.popup03').css('display','block');
                            }else{
                                $('.bg_dim').css('display','block');
                                $("#day"+res[2]).removeClass("btn_off");
                                $("#totalm").empty().html(res[3]);
                                $("#nowmile4").empty().html(res[4]);
                                $('.popup01').css('display','block');
                            }
                        <% else %>
                            if(res[2]=="9"){
                                $('.bg_dim').css('display','block');
                                $("#day"+res[2]).removeClass("btn_off");
                                $("#totalm").empty().html(res[3]);
                                $('.popup03').css('display','block');
                            }
                            else{
                                $('.bg_dim').css('display','block');
                                $("#day"+res[2]).removeClass("btn_off");
                                $("#totalm").empty().html(res[3]);
                                $("#nowmile").empty().html(res[4]);
                                $("#tomile").empty().html(res[1]);
                                $('.popup02').css('display','block');
                            }
                        <% end if %>
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
    $('.popup02').fadeOut();
}

function fnEventLogin(){
    parent.calllogin();
    return false;
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
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript115806.asp?mode=pushadd&checkday=<%=request("checkday")%>",
        <% else %>
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript115806.asp?mode=pushadd",
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
                            $('.bg_dim').css('display','block');
                            $('.popup04').css('display','block');
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
			<div class="mEvt115806">
				<section class="section01">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/title.jpg" alt="">
					<p>
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/title_btn.png" alt="">
					</p>
					<button class="btn_check" <% If TodayDateCheck > 0 Then %>onclick="alert('이미 참여하셨습니다.');"<% Else %>onclick="jsMaeilageSubmit();"<% End If %>>출석체크하기</button>
				</section>
				<section class="section02">
					<% If IsUserLoginOK() Then %>
					<div class="content01_02">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/content01_02.jpg" alt="">
						<p class="user_id"><span><%=userid%></span> 님의</p>
						<p class="user_id2">마일리지 지급 현황</p>
						<p class="mileage"><span id="totalm"><%=FormatNumber(TotalMileage,0)%></span>p</p>
						<a href="" onclick="fnAPPpopupMy10x10();return false;" class="mApp myMileage"></a>
					</div>
                    <% else %>
					<div class="content01_01">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/content01_01.jpg" alt="">
						<p class="user_id"><span>고객</span> 님이 받을 수 있는</p>
						<p class="user_id2">최대 마일리지</p>
						<p class="mileage"><span>4,500</span>p</p>
						<a href="" onclick="fnEventLogin();return false;" class="mApp myMileage"></a>
					</div>
                    <% end if %>
                </section>
                <section class="section03">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/content02_01.jpg" alt="">
					<div class="btnWrap">
                        <% for ix=1 to TodayCount+1 %>
						<div class="btn0<%=ix%>">
                            <% if ix <= TodayCount then %>
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/btn0<%=ix%>_off.png" id="day<%=ix%>">
                                <% If TodayCount = ix and TodayDateCheck >= 1 Then %>
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/btn_on.png">
                                <% end if %>
                            <% else %>
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/btn0<%=ix%>_off.png" id="day<%=ix%>" class="btn_off">
                                <% If TodayDateCheck < 1 Then %>
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/btn_on.png">
                                <% end if %>
                            <% end if %>
						</div>
                        <% next %>
					</div>
				</section>
				<section class="section04">
					<div class="noti_wrap">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/info01.jpg" alt="">
						<button class="btn-apply" onclick="jsMaeilagePushSubmit();return false;"></button>
						<p class="noti"></p>
						<p class="notice"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/notice.jpg" alt=""></p>
					</div>
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/info02.jpg" alt="">
				</section>
				<section class="section05">
					<div class="bg_dim"></div>
					<div class="popup01">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/popup01.png?v=1.2" alt="">
						<p class="day"><span><%=TodayCount+1%></span>일째</p>
						<p class="point"><span class="today" id="nowmile4">100</span><span>P</span>가 적립되었어요!<br>이벤트에 참여해 주셔서 감사합니다. :)</p>
						<a href="" class="btn_close"></a>
						<a href="" onclick="fnAPPpopupBrowserURL('이벤트','https://m.10x10.co.kr/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt');return false;" class="btn_alert"></a>
					</div>
					<div class="popup02">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/popup02.png?v=1.2" alt="">
						<p class="day"><span><%=TodayCount+1%></span>일째</p>
						<p class="point"><span class="today" id="nowmile">100</span><span>P</span>가 적립되었어요!<br>내일 받을 마일리지는 <span class="tomorrow" id="tomile">200P</span>입니다.<br>마지막까지 도전하세요!</p>
						<a href="" class="btn_close"></a>
						<button class="btn_alert" onclick="jsMaeilagePushSubmit();fnApplyPopClose();return false;">내일 알림 신청하기</button>
					</div>
					<div class="popup03">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/popup03.png?v=1.2" alt="">
						<p class="day"><span><%=TodayCount+1%></span>일째</p>
						<p class="point"><span class="today">900</span><span>P</span>가 적립되었어요!<br>9일간 참여해 주셔서 감사합니다. :)</p>
						<a href="" class="btn_close"></a>
						<a href="" onclick="fnAPPpopupBrowserURL('이벤트','https://m.10x10.co.kr/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt');return false;" class="btn_alert"></a>
					</div>
					<div class="popup04">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115806/popup04.png?v=1.2" alt="">
						<a href="" class="btn_close"></a>
						<button class="btn_alert" onclick="fnAPPpopupSetting();return false;">나의 설정 확인하기</button>
					</div>
				</section>
				
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->