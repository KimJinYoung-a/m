<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 케이크 만들기 (매일리지)
' History : 2021.10.07 정태훈
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
		eCode  = 109400             '// 매일리지 코드
        mobileEventCode = 109401    '// 모바일 이벤트 코드
	    mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode  = 114597             '// 매일리지 코드
        mobileEventCode = 114596    '// 모바일 이벤트 코드
        mktTest = True
    Else
		eCode  = 114597             '// 매일리지 코드
        mobileEventCode = 114596    '// 모바일 이벤트 코드
        mktTest = False
	End If

	Dim gaparamChkVal
	gaparamChkVal = requestCheckVar(request("gaparam"),30) 
	userid = GetEncLoginUserID()
    Response.redirect "/apps/appcom/wish/web2014/event/eventmain.asp?eventid=115359&gaparam="&gaparamChkVal
    Response.End
	'// 현재시간
	currenttime = now()

	if mktTest then
		currenttime=request("checkday")
	end if

	vEventStartDate = "2021-10-11"
	vEventEndDate = "2021-10-24"

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
.mEvt114597 section{position:relative;}

.mEvt114597 .section01 .txt01{position:absolute;top:33.3vw;width:73.2vw;left:50%;margin-left:-36.6vw;opacity:0; transform:translateY(-15vw); transition:ease-in-out 1s;}
.mEvt114597 .section01 .txt01.on{opacity:1; transform:translateY(0);}
.mEvt114597 .section01 .txt02{position:absolute;top:85.3vw;width:77.5vw;left:50%;margin-left:-38.75vw;opacity:0;transition:ease-in-out 1s .7s;}
.mEvt114597 .section01 .txt02.on{opacity:1;}

.mEvt114597 .section02 .cake{position:absolute;top:0;width:100%;}
.mEvt114597 .section02 .cake .cake01{position:absolute;top:20vw;width:4.3vw;left:50%;margin-left:4vw;}
.mEvt114597 .section02 .cake .cake02{position:absolute;top:13.1vw;width:4.3vw;left:50%;margin-left:-15.9vw;}
.mEvt114597 .section02 .cake .cake03{position:absolute;top:8.7vw;width:12.3vw;left:50%;margin-left:25.2vw;}
.mEvt114597 .section02 .cake .cake04{position:absolute;top:55.6vw;width:19.2vw;left:50%;margin-left:-44.9vw;}
.mEvt114597 .section02 .cake .cake05{position:absolute;top:13.1vw;width:4.3vw;left:50%;margin-left:11.6vw;}
.mEvt114597 .section02 .cake .cake06{position:absolute;top:8.7vw;width:12.3vw;left:50%;margin-left:-37.5vw;}
.mEvt114597 .section02 .cake .cake07{position:absolute;top:8.7vw;width:4.3vw;left:50%;margin-left:-2.15vw;}
.mEvt114597 .section02 .cake .cake08{position:absolute;top:66vw;width:34.5vw;left:50%;margin-left:7.9vw;}
.mEvt114597 .section02 .cake .cake09{position:absolute;top:20vw;width:4.3vw;left:50%;margin-left:-8.3vw;}
.mEvt114597 .section02 .cake p{opacity:0;transition:ease-in-out 1s;}
.mEvt114597 .section02 .cake p.on{opacity:1;}

.mEvt114597 .section03 .check{position:absolute;top:8.4vw;left:50%;width:86.7vw;height:20.1vw;margin-left:-43.35vw;text-indent: -999999999px;background:transparent;}

.mEvt114597 .section04 p.user_id{position:absolute;top:20.5vw;font-size:2.56rem;width:100%;text-align: center;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#2a255d;letter-spacing: -0.2rem;}
.mEvt114597 .section04 p.user_id span{text-decoration: underline;}
.mEvt114597 .section04 p{position:absolute;top:31.5vw;font-size:3.41rem;width:100%;text-align: center;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#2a255d;letter-spacing: -0.2rem;}

.mEvt114597 .section05 .button{position:absolute;top:0;width:100%;display:block;}
.mEvt114597 .section05 .button button{width:33.3%;float:left;height:22.8vw;display:none;}
.mEvt114597 .section05 .button button.on{display:block;}
.mEvt114597 .section05 .mileage{position:absolute;bottom:21.2vw;font-size:2.56rem;width:100%;text-align: center;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#000;letter-spacing: -0.2rem;line-height:2;}
.mEvt114597 .section05 .line{position:absolute;top:0;width:100%;}
 
.mEvt114597 .section06 .noti_wrap .noti{position:relative;}
.mEvt114597 .section06 .noti_wrap .noti::after{content:'';display:block;background:url(//webimage.10x10.co.kr/fixevent/event/2021/114597/m/ic_arrow.png) no-repeat 0 0;transform: rotate(0deg);position:absolute;top:30.9vw;left:73.3vw;background-size:100%;width:3.1vw;height:1rem;}
.mEvt114597 .section06 .noti_wrap .noti.on::after{transform: rotate(180deg);top:29.9vw;}
.mEvt114597 .section06 .noti_wrap .noti_on{display:none;}

.mEvt114597 .section07 a.go_brand{width:80vw;height:20vw;position:absolute;top:9;left:50%;margin-left:-40vw;display:block;}
 
.mEvt114597 .section09 .bg_dim{position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.4);z-index:5;display:none;}
.mEvt114597 .section09 .popup01{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display:none;}
.mEvt114597 .section09 .popup01 .pop_img{position:absolute;top:39vw;left:50%;}
.mEvt114597 .section09 .popup01 .pop_img .pop01{width:4.7vw;margin-left:-2.35vw;}
.mEvt114597 .section09 .popup01 .pop_img .pop02{width:4.7vw;margin-left:-2.35vw;}
.mEvt114597 .section09 .popup01 .pop_img .pop03{width:18.7vw;margin-left:-9.35vw;margin-top:7vw;}
.mEvt114597 .section09 .popup01 .pop_img .pop04{width:22vw;margin-left:-11vw;}
.mEvt114597 .section09 .popup01 .pop_img .pop05{width:4.7vw;margin-left:-2.35vw;}
.mEvt114597 .section09 .popup01 .pop_img .pop06{width:18.7vw;margin-left:-9.35vw;margin-top:7vw;}
.mEvt114597 .section09 .popup01 .pop_img .pop07{width:4.7vw;margin-left:-2.35vw;}
.mEvt114597 .section09 .popup01 .pop_img .pop08{width:39.7vw;margin-left:-19.85vw;}
.mEvt114597 .section09 .popup01 .pop_img .pop09{width:4.7vw;margin-left:-2.35vw;}
.mEvt114597 .section09 .popup01 .point{text-align: center;position:absolute;bottom:39.1vw;width:100%;font-size:1.5rem;letter-spacing: -0.1rem;line-height: 1.5;}
.mEvt114597 .section09 .popup01 .point span{color:#df2031;}
.mEvt114597 .section09 .popup01 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt114597 .section09 .popup01 .btn_alert{width:80vw;height:19vw;display:block;position:absolute;bottom:4rem;left:50%;margin-left:-40vw;}

.mEvt114597 .section09 .popup02{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display:none;}
.mEvt114597 .section09 .popup02 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt114597 .section09 .popup02 .btn_alert{width:80vw;height:20vw;display:block;position:absolute;bottom:2rem;left:50%;margin-left:-40vw;}

.mEvt114597 .section09 .popup03{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display:none;}
.mEvt114597 .section09 .popup03 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt114597 .section09 .popup03 .btn_alert{width:80vw;height:20vw;display:block;position:absolute;bottom:2rem;left:50%;margin-left:-40vw;}

.mEvt114597 .section09 .popup04{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display:none;}
.mEvt114597 .section09 .popup04 .pop_img{position:absolute;top:39vw;left:50%;}
.mEvt114597 .section09 .popup04 .pop_img .pop01{width:4.7vw;margin-left:-2.35vw;}
.mEvt114597 .section09 .popup04 .pop_img .pop02{width:4.7vw;margin-left:-2.35vw;}
.mEvt114597 .section09 .popup04 .pop_img .pop03{width:18.7vw;margin-left:-9.35vw;margin-top:7vw;}
.mEvt114597 .section09 .popup04 .pop_img .pop04{width:22vw;margin-left:-11vw;}
.mEvt114597 .section09 .popup04 .pop_img .pop05{width:4.7vw;margin-left:-2.35vw;}
.mEvt114597 .section09 .popup04 .pop_img .pop06{width:18.7vw;margin-left:-9.35vw;margin-top:7vw;}
.mEvt114597 .section09 .popup04 .pop_img .pop07{width:4.7vw;margin-left:-2.35vw;}
.mEvt114597 .section09 .popup04 .pop_img .pop08{width:39.7vw;margin-left:-19.85vw;}
.mEvt114597 .section09 .popup04 .pop_img .pop09{width:4.7vw;margin-left:-2.35vw;}
.mEvt114597 .section09 .popup04 .point{text-align: center;position:absolute;bottom:48.1vw;width:100%;font-size:1.5rem;letter-spacing: -0.1rem;line-height: 1.5;}
.mEvt114597 .section09 .popup04 .point span{color:#df2031;}
.mEvt114597 .section09 .popup04 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt114597 .section09 .popup04 .btn_alert{width:80vw;height:19vw;display:block;position:absolute;bottom:3rem;left:50%;margin-left:-40vw;}
</style>
<script>
$(function() {
	$('.mEvt114597 .section01 p').addClass('on');

	// $('.check').click(function(){
	// 	$('.mEvt114597 .section02 .cake .cake01').addClass('on'); // 첫 번 째 출석 날.
	// });
    <% for ix=1 to TodayCount %>
        $('.mEvt114597 .section02 .cake .cake0<%=ix%>').addClass('on');
    <% next %>
	$('.noti_wrap .noti').click(function(){
		$(this).toggleClass('on');
        if ($('.noti_wrap .noti').hasClass('on')){
            $('.noti_on').show();
        } else {
            $('.noti_on').hide();
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
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript114597.asp?mode=add&checkday=<%=request("checkday")%>",
        <% else %>
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript114597.asp?mode=add",
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
                                $('.mEvt114597 .section02 .cake .cake0'+res[2]).addClass('on');
                                $("#day"+res[2]).addClass("on");
                                $("#totalm").empty().html(res[3]);
                                $('.popup03').css('display','block');
                            }else{
                                $('.mEvt114597 .section02 .cake .cake0'+res[2]).addClass('on');
                                $("#candleimg4").empty().html('<p class="pop0'+res[2]+'"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/pop0'+res[2]+'.png?v=1.0.1"></p>');
                                $("#day"+res[2]).addClass("on");
                                $("#totalm").empty().html(res[3]);
                                $("#nowmile4").empty().html(res[4]);
                                $('.popup04').css('display','block');
                            }
                        <% else %>
                            if(res[2]=="9"){
                                $('.mEvt114597 .section02 .cake .cake0'+res[2]).addClass('on');
                                $("#day"+res[2]).addClass("on");
                                $("#totalm").empty().html(res[3]);
                                $('.popup03').css('display','block');
                            }
                            else{
                                $('.mEvt114597 .section02 .cake .cake0'+res[2]).addClass('on');
                                $("#candleimg").empty().html('<p class="pop0'+res[2]+'"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/pop0'+res[2]+'.png?v=1.0.1"></p>');
                                $("#day"+res[2]).addClass("on");
                                $("#totalm").empty().html(res[3]);
                                $("#nowmile").empty().html(res[4]);
                                $("#tomile").empty().html(res[1]);
                                $('.popup01').css('display','block');
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
    $('.popup01').fadeOut();
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
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript114597.asp?mode=pushadd&checkday=<%=request("checkday")%>",
        <% else %>
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript114597.asp?mode=pushadd",
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
                            $('.popup02').css('display','block');
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
			<div class="mEvt114597">
				<section class="section01">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_top.jpg" alt="">
					<p class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/tit_top.png" alt=""></p>
					<p class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/txt.png" alt=""></p>
				</section>
				<section class="section02">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_cake.jpg" alt="">
					<div class="cake">
						<p class="cake01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/cake01.png" alt=""></p>
						<p class="cake02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/cake02.png" alt=""></p>
						<p class="cake03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/cake03.png" alt=""></p>
						<p class="cake04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/cake04.png" alt=""></p>
						<p class="cake05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/cake05.png" alt=""></p>
						<p class="cake06"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/cake06.png" alt=""></p>
						<p class="cake07"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/cake07.png" alt=""></p>
						<p class="cake08"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/cake08.png" alt=""></p>
						<p class="cake09"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/cake09.png" alt=""></p>
					</div>
				</section>
				<section class="section03">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_check.jpg?v=1.01" alt="">
					<button class="check" <% If TodayDateCheck > 0 Then %>onclick="alert('이미 참여하셨습니다.');"<% Else %>onclick="jsMaeilageSubmit();"<% End If %>>출석체크하기</button>
				</section>
                <% If IsUserLoginOK() Then %>
				<section class="section04">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_user.jpg" alt="">
					<p class="user_id"><span><%=userid%></span> 님의</p>
					<p>마일리지 지급 현황</p>
				</section>
                <% else %>
                <section class="section04">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_user.jpg" alt="">
					<p class="user_id">나의 기록</p>
					<p>마일리지 지급 현황</p>
				</section>
                <% end if %>
				<section class="section05">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_button.jpg" alt="">
					<div class="button">
                    <% for ix=1 to 9 %>
                        <% if ix <= TodayCount then %>
						<button class="btn0<%=ix%> on" id="day<%=ix%>"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/btn0<%=ix%>.png" alt=""></button>
                        <% else %>
                        <button class="btn0<%=ix%>" id="day<%=ix%>"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/btn0<%=ix%>.png" alt=""></button>
                        <% end if %>
					<% next %>
                    </div>
					<div class="line">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/line.png" alt="">
					</div>
					<p class="mileage" onclick="fnAPPpopupMy10x10();return false;"><span id="totalm"><%=FormatNumber(TotalMileage,0)%></span>p</p>
				</section>
				<section class="section06">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_text.jpg" alt="">
					<button class="alert"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/img_button.jpg"  onclick="jsMaeilagePushSubmit();return false;" alt=""></button>
					<div class="noti_wrap">
						<p class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_noti.jpg" alt=""></p>
						<p class="noti_on"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_noti_on.jpg"></p>
					</div>
				</section>
				<section class="section07">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_product.jpg" alt="">
					<div class="product">
						<a href="#" onclick="fnAPPpopupProduct('4040898&pEtr=114597'); return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/prd01.jpg" alt="">
						</a>
						<a href="#" onclick="fnAPPpopupProduct('3081009&pEtr=114597'); return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/prd02.jpg" alt="">
						</a>
						<a href="#" onclick="fnAPPpopupProduct('3865997&pEtr=114597'); return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/prd03.jpg" alt="">
						</a>
						<a href="#" onclick="fnAPPpopupProduct('2846146&pEtr=114597'); return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/prd04.jpg" alt="">
						</a>
					</div>
					<div class="brand">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/button_brand.jpg" alt="">
						<a href="" onclick="fnAPPpopupBrand('pureureumdesign');return false;" class="go_brand"></a>
					</div>					
				</section>		
				<section class="section08">
					<a href="" onclick="fnAPPpopupBrowserURL('스무살♥','https://m.10x10.co.kr/apps/appcom/wish/web2014/linker/forum.asp?idx=1');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_banner.jpg" alt=""></a>
				</section>
				<section class="section09">
					<div class="bg_dim"></div>
					<div class="popup01">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_popup01.jpg" alt="">
						<div class="pop_img" id="candleimg"></div>
						<p class="point"><span class="today" id="nowmile">100P</span>가 적립되었어요!<br>내일 받을 마일리지는 <span class="tomorrow" id="tomile">200P</span>입니다.</p>
						<a href="" class="btn_close"></a>
						<a href="" onclick="jsMaeilagePushSubmit();fnApplyPopClose();return false;" class="btn_alert"></a>
					</div>
					<div class="popup02">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_popup02.jpg" alt="">
						<a href="" class="btn_close"></a>
						<a href="" onclick="fnAPPpopupSetting();return false;" class="btn_alert"></a>
					</div>
                    <div class="popup03">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_popup03.jpg" alt="">
						<a href="" class="btn_close"></a>
						<a href="" onclick="fnAPPpopupBrowserURL('스무살♥','https://m.10x10.co.kr/apps/appcom/wish/web2014/linker/forum.asp?idx=1');return false;" class="btn_alert"></a>
					</div>
                    <div class="popup04">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/114597/m/bg_popup04.jpg" alt="">
						<div class="pop_img" id="candleimg4"></div>
						<p class="point"><span class="today" id="nowmile4">100P</span>가 적립되었어요!<br>이벤트에 참여해주셔서 감사합니다. :)</p>
						<a href="" class="btn_close"></a>
						<a href="" onclick="fnAPPpopupBrowserURL('스무살♥','https://m.10x10.co.kr/apps/appcom/wish/web2014/linker/forum.asp?idx=1');return false;" class="btn_alert"></a>
					</div>
				</section>
				
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->