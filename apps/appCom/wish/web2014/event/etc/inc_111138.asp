<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
<%
'####################################################
' Description : 2021 홀맨, 너와 나의 하트 점수가 궁금해!
' History : 2021-05-07 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "105356"
	moECode = "105355"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "111138"
	moECode = "111137"
    mktTest = True
Else
	eCode = "111138"
	moECode = "111137"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-05-17")		'이벤트 시작일
eventEndDate 	= cdate("2021-05-30")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-05-17")
else
    currentDate = date()
end if

%>
<style>
.mEvt111138 .topic {position:relative;}
.mEvt111138 .topic h2 img {position:absolute; left:50%; top:8rem; width:72vw; transform: translate(-50%,0); opacity:0; transition:all 1s;}
.mEvt111138 .topic h2 img.on {opacity:1; top:12rem;}

.mEvt111138 .section-top {position:relative;}
.mEvt111138 .section-top .holeman {position:absolute; left:50%; top:0; width:70.67vw; margin-left:-35.33vw; }
.mEvt111138 .section01 {position:relative;}
.mEvt111138 .section01 .txt01 {width:60.27vw; position:absolute; left:50%; top:2%; margin-left:-30.13vw;}
.mEvt111138 .section01 .txt02 {width:58.93vw; position:absolute; left:50%; top:16%; margin-left:-29.46vw;}
.mEvt111138 .section01 .input-event {position:absolute; left:50%; top:68%; transform:translate(-50%,0); width:64.67vw; height:13.47vw; background:#e5e5e5;}
.mEvt111138 .section01 .input-event input {width:100%; height:100%; line-height: 13.47vw; background:#e5e5e5; border:0; color:#111; font-size:1.65rem; text-align:center;}
.mEvt111138 .section01 .input-event input::placeholder {color:#b8b8b8; font-size:1.65rem; text-align:center;}
.mEvt111138 .section01 .btn-apply {width:100%; height:8rem; position:absolute; left:0; bottom:15%; background:transparent;}
.mEvt111138 .section01 .num-banner {width:33.47vw; position:absolute; right:0; top:39%; animation:updown 1s ease-in-out alternate infinite;}

.mEvt111138 .section02 {position:relative;}
.mEvt111138 .section02 .character-area {position:absolute; left:50%; top:49%; transform:translate(-50%,0); width:84.27vw; height:61vw;}
.mEvt111138 .section02 .character-area button {background:transparent;}
.mEvt111138 .section02 .character-area div {display:none; position:relative;}
.mEvt111138 .section02 .character-area div.on {display:block;}
.mEvt111138 .section02 .character-area .btn-ch01 {width:34vw; height:59.73vw; position:absolute; left:0; top:0; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_ch_off01.png) no-repeat 0 0; background-size:100%;}
.mEvt111138 .section02 .character-area .btn-ch02 {width:25.9vw; height:38vw; position:absolute; left:45%; top:34%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_ch_off02.png) no-repeat 0 0; background-size:100%;}
.mEvt111138 .section02 .character-area .btn-ch03 {width:16vw; height:27.07vw; position:absolute; right:0; top:53%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_ch_off03.png) no-repeat 0 0; background-size:100%;}
.mEvt111138 .section02 .character-area .btn-ch04 {width:22vw; height:15.93vw; position:absolute; right:0; top:0; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_ch_off04.png) no-repeat 0 0; background-size:100%;}
.mEvt111138 .section02 .character-area .btn-ch01.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_ch_on01.png) no-repeat 0 0; background-size:100%;}
.mEvt111138 .section02 .character-area .btn-ch02.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_ch_on02.png) no-repeat 0 0; background-size:100%;}
.mEvt111138 .section02 .character-area .btn-ch03.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_ch_on03.png) no-repeat 0 0; background-size:100%;}
.mEvt111138 .section02 .character-area .btn-ch04.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_ch_on04.png) no-repeat 0 0; background-size:100%;}
.mEvt111138 .section02 .img-click {position:absolute; left:47%; top:55%; width:12.40vw; animation: twk 1s ease alternate infinite;}
.mEvt111138 .section02 .img-click02 {position:absolute; left:78%; top:67%; width:12.40vw; animation: twk 1s .5s ease alternate infinite;}
.mEvt111138 .character-info div {display:none;}
.mEvt111138 .character-info div.on {display:block;}
@keyframes twk {
    0% {opacity:0;}
    100% {opacity:1;}
}

.mEvt111138 .result-type {position:relative;}
.mEvt111138 .result-type .name {display:flex; align-items:center; justify-content:space-between; width:100%; position:absolute; left:0; top:28%; padding:0 2.56rem;}
.mEvt111138 .result-type .name p {font-size:2.26rem; color:#fe45a3; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt111138 .result-type .name p.blue-txt {color:#57a6ff;}
.mEvt111138 .result-type .num {display:flex; align-items:center; justify-content:space-between; width:100%;}
.mEvt111138 .result-type .num p {color:#000; font-size:2.39rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt111138 .result-type .count01 {position:absolute; left:0; top:35%; padding:0 2.9rem;}
.mEvt111138 .result-type .count02 {position:absolute; left:0; top:58%; padding:0 7rem;}
.mEvt111138 .result-type .count03 {position:absolute; left:0; top:81%; padding:0 11rem;}
.mEvt111138 .result-type .count03 p {color:#d40006;}
.mEvt111138 .result-type.type02 .name {top:28%;}
.mEvt111138 .result-type.type02 .count01 {top:35.5%;}
.mEvt111138 .result-type.type02 .count02 {top:51%; padding:0 6rem;}
.mEvt111138 .result-type.type02 .count03 {top:66%; padding:0 9rem;}
.mEvt111138 .result-type.type02 .count03 p {color:#000;}
.mEvt111138 .result-type.type02 .count04 {position:absolute; left:0; top:81%; padding:0 12rem;}
.mEvt111138 .result-type.type02 .count04 p {color:#d40006;}
.mEvt111138 .result-type.type03 .name {top:28%;}
.mEvt111138 .result-type.type03 .count01 {top:35.5%;}
.mEvt111138 .result-type.type03 .count02 {top:48%; padding:0 5.2rem;}
.mEvt111138 .result-type.type03 .count03 {top:59%; padding:0 8rem;}
.mEvt111138 .result-type.type03 .count03 p {color:#000;}
.mEvt111138 .result-type.type03 .count04 {position:absolute; left:0; top:70%; padding:0 10.5rem;}
.mEvt111138 .result-type.type03 .count04 p {color:#000;}
.mEvt111138 .result-type.type03 .count05 {position:absolute; left:0; top:81%; padding:0 13rem;}
.mEvt111138 .result-type.type03 .count05 p {color:#d40006;}

.mEvt111138 .noti-area {position:relative;}
.mEvt111138 .noti-area .noti-info {width:100%; position:absolute; left:50%; top:2%; transform:translate(-50%,0); text-align:center;}
.mEvt111138 .noti-area .noti-info .tit {font-size:2.17rem; color:#000; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt111138 .noti-area .noti-info p {font-size:1.43rem; color:#000;}
.mEvt111138 .noti-area .noti-info p:nth-child(2) {padding:1.60rem 0;}
.mEvt111138 .noti-area .noti-info p:nth-child(3) {padding-bottom:0.73rem;}
.mEvt111138 .noti-area .noti-info .name {color:#fe45a3; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt111138 .noti-area .noti-info .c-name {color:#57a6ff; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';} 
.mEvt111138 .noti-area .noti-info .num {color:#d40006; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt111138 .noti-area .noti-info .txt-bold {font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt111138 .noti-area .talk-num {width:24.13rem; height:3.82rem; line-height:3.82rem; position:absolute; left:50%; top:20.3%; transform:translate(-50%,0); text-align:center; font-size:1.56rem; color:#000;}
.mEvt111138 .noti-area a {display:inline-block; width:100%; height:5rem; position:absolute; left:0; bottom:60%;}
.mEvt111138 .noti-area.half-down .noti-info {top:7%;}
.mEvt111138 .noti-area.half-down .noti-info p {line-height:1.5;}
.mEvt111138 .noti-area.half-down .noti-info p:nth-child(2) {padding:0.6rem 0;}

.mEvt111138 .sec-video {width:100%; height:119.60vw; padding:51.47vw 2.60rem 0; background: url(//webimage.10x10.co.kr/fixevent/event/2021/111138/m/bg_videojpg.jpg) no-repeat 0 0; background-size:100%;}
.mEvt111138 .sec-video .video-inner {position:relative; padding-bottom:56.25%; height:0;}
.mEvt111138 .sec-video .video-inner iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
.mEvt111138 .animate {opacity:0; transform:translateY(15%); transition:all 1s;}
.mEvt111138 .animate.on {opacity:1; transform:translateY(0%);}
.mEvt111138 .animateImg {opacity:0; transform:translateY(0%); transition:all 1s .3s;}
.mEvt111138 .animateImg.on {opacity:1; transform:translateY(100%);}
@keyframes updown {
    0% {transform: translateY(-1rem);}
    100% {transform: translateY(1rem);}
}
</style>
<script src="/apps/appcom/wish/web2014/event/lib/nameCal.js?v=1.14"></script>
<script>
$(function(){
    $('.topic h2 img').addClass('on');
    $(window).scroll(function(){
        $('.animate').each(function(){
			var y = $(window).scrollTop() + $(window).height() * 1;
			var imgTop = $(this).offset().top;
			if(y > imgTop) {
				$(this).addClass('on');
			}
		});
    });
    $(window).scroll(function(){
        $('.animateImg').each(function(){
			var y = $(window).scrollTop();
			var imgTop = $(this).offset().top;
			if(y > imgTop) {
				$(this).addClass('on');
			}
		});
    });
    // 캐릭터 선택하기
    $('.character-area button').on('click',function(){
        $(this).addClass('on').siblings().removeClass('on');
        if($('.btn-ch01').hasClass('on')) {
            $('.character-info').children('div:nth-child(1)').addClass('on').siblings().removeClass('on');
        }
        if($('.btn-ch02').hasClass('on')) {
            $('.character-info').children('div:nth-child(2)').addClass('on').siblings().removeClass('on');
        }
        if($('.btn-ch03').hasClass('on')) {
            $('.character-info').children('div:nth-child(3)').addClass('on').siblings().removeClass('on');
        }
        if($('.btn-ch04').hasClass('on')) {
            $('.character-info').children('div:nth-child(4)').addClass('on').siblings().removeClass('on');
        }
    });

    <% If IsUserLoginOK Then %>
    fnCheckEvent();
    <% End If %>
});

function fnCheckName(){
    var offset1 = $("#name-ch").offset();
    var offset2 = $("#choice-ch").offset();
    
    var name = $("#name1").val();
    // 한글 이름 2~4자 이내
    var re = /^[가-힣]{2,5}$/;
    // 영문 이름 2~10자 이내 : 띄어쓰기(\s)가 들어가며 First, Last Name 형식
    // var re = /^[a-zA-Z]{2,10}\s[a-zA-Z]{2,10}$/;
    // 한글 또는 영문 사용하기(혼용X)
    //  var reg = /^[가-힣]{2,4}|[a-zA-Z]{2,10}\s[a-zA-Z]{2,10}$/; // "|"를 사용
	if (name == '' || !re.test(name)) {
        $('html, body').animate({scrollTop : offset1.top}, 400);
		alert("올바른 이름의 형식을 입력하세요");
		return false;
	}

    if(GetByteLength($("#name1").val()) < 3){
        $('html, body').animate({scrollTop : offset1.top}, 400);
        alert("이름은 2~3글자만 입력해주세요.");
        return false;
    }
    else if(GetByteLength($("#name1").val()) > 6){
        $('html, body').animate({scrollTop : offset1.top}, 400);
        alert("이름은 2~3글자만 입력해주세요.");
        return false;
    }
    else{
        $('html, body').animate({scrollTop : offset2.top}, 400);
        alert("이름 등록 완료!");
        return false;
    }
}

function fnSelectCharacter(cname){
    $("#name2").val(cname);
}

function fnCheckEvent(){
    var data={
        mode: "view"
    }
    $.ajax({
        type:"POST",
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript111138.asp",
        data: data,
        dataType: "JSON",
        success : function(res){
            if(res!="") {
                // console.log(res)
                if(res.response == "ok"){
                    $("#name1").attr("readonly",true);
                    $("#cbtn").attr("disabled",true);
                    $("#rbtn").attr("disabled",true);
                    $("#name1").val(res.name1);
                    $("#name2").val(res.name2);
                    $("#couponCode").val(res.couponCode);
                    calculateView();
                    return false;
                }else{
                    return false;
                }
            } else {
                alert("잘못된 접근 입니다.");
                document.location.reload();
                return false;
            }
        },
        error:function(err){
            //console.log(err)
            alert("잘못된 접근 입니다.");
            return false;
        }
    });
}

function eventTry(score,sumname){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
		var returnCode, itemid, data
        var offset = $("#view-result").offset();
		var data={
			mode: "add",
            name1: $("#name1").val().replace(/ /g,''),
            name2: $("#name2").val(),
            point: score
		}
		$.ajax({
			type:"POST",
			url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript111138.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|'+score)
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
                            if(sumname==4){
                                $("#type01").show();
                            }
                            else if(sumname==5){
                                $("#type02").show();
                            }
                            else if(sumname==6){
                                $("#type03").show();
                            }
                            if(score>=50){
                                $("#winPop").show();
                                $("#couponCode").val(res.couponCode);
                            }else{
                                $("#failPop").show();
                            }
                            $("#name1").attr("readonly",true);
                            $("#tPoint").val(score);
                            $('html, body').animate({scrollTop : offset.top}, 400);
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.");
						document.location.reload();
						return false;
					}
			},
			error:function(err){
				console.log(err)
				alert("잘못된 접근 입니다.");
				return false;
			}
		});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}
</script>
			<div class="mEvt111138">
                <div class="topic">
                    <h2>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/tit_txt.png" alt="홀맨, 너와 나의 하트 점수가 궁금해!">
                    </h2>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/bg_sub01.jpg" alt="tenbyten x holeman"></div>
                </div>
                <div class="section-top">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/bg_sub02.jpg" alt="">
                    <div class="holeman animateImg"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_holeman.png" alt="홀맨"></div>
                </div>
                <div class="section01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/bg_sub03.jpg" alt="">
                    <div class="txt01 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/txt_sub01.png" alt="2022년 cf 스타 홀맨!"></div>
                    <div class="txt02 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/txt_sub02.png" alt="18년 만에 잠에서 꺠어나다."></div>
                    <div class="input-event" id="name-ch"><input type="text" placeholder="당신의 이름을 적어주세요." name="name1" id="name1"></div>
                    <span class="num-banner"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_banner.png" alt="선착순 2만명"></span>
                    <button type="button" class="btn-apply" id="cbtn" onClick="fnCheckName();"></button>
                    <input type="hidden" name="name2" id="name2" value="홀맨">
                    <input type="hidden" name="tPoint" id="tPoint">
                </div>
                <div class="section02" id="choice-ch">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/bg_event.jpg?v=2" alt="이름점을 치고 싶은 캐릭터를 선택해주세요!">
                    <!-- 캐릭터 선택버튼 -->
                    <div class="character-area">
                        <button type="button" class="btn-ch01 on" onclick="fnSelectCharacter('홀맨');"></button>
                        <button type="button" class="btn-ch02" onclick="fnSelectCharacter('아지');"></button>
                        <button type="button" class="btn-ch03" onclick="fnSelectCharacter('무너');"></button>
                        <button type="button" class="btn-ch04" onclick="fnSelectCharacter('충저니');"></button>
                    </div>
                    <div class="img-click"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/icon_click.png" alt="click"></div>
                    <div class="img-click02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/icon_click02.png" alt="click"></div>
                </div>
                <!-- 캐릭터 정보 -->
                <div class="character-info">
                    <div class="on"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_info_01.jpg" alt="홀맨"></div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_info_02.jpg" alt="아지"></div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_info_03.jpg" alt="무너"></div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_info_04.jpg" alt="충저니"></div>
                </div>
                <!-- 이름점 결과 보기 버튼 -->
                <div>
                    <button type="button" class="btn-result" id="rbtn" onclick="btnClick();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/btn_result.jpg" alt="이름점 결과 보기"></button>
                    <div class="result-wrap" id="view-result">
                        <!-- 응모자 이름 2자 + 캐릭터 이름 2자 -->
                        <div class="result-type" id="type01" style="display:none">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_event_enter01.jpg" alt="2자+2자">
                            <div class="name">
                                <p id="name1_1"></p>
                                <p id="name2_1" class="blue-txt"></p>
                                <p id="name1_2"></p>
                                <p id="name2_2" class="blue-txt"></p>
                            </div>
                            <div class="count01 num">
                                <p id="namePoint1_1"></p>
                                <p id="namePoint1_2"></p>
                                <p id="namePoint1_3"></p>
                                <p id="namePoint1_4"></p>
                            </div>
                            <div class="count02 num">
                                <p id="sumPoint10_0"></p>
                                <p id="sumPoint10_1"></p>
                                <p id="sumPoint10_2"></p>
                            </div>
                            <div class="count03 num">
                                <p id="sumPoint11_0"></p>
                                <p id="sumPoint11_1"></p>
                            </div>
                        </div>
                        <!-- 응모자 이름 3자 + 캐릭터 이름 2자 -->
                        <div class="result-type type02" id="type02" style="display:none">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_event_enter02.jpg" alt="3자+2자">
                            <div class="name">
                                <p id="name3_1"></p>
                                <p id="name4_1" class="blue-txt"></p>
                                <p id="name3_2"></p>
                                <p id="name4_2" class="blue-txt"></p>
                                <p id="name3_3"></p>
                            </div>
                            <div class="count01 num">
                                <p id="namePoint2_1"></p>
                                <p id="namePoint2_2"></p>
                                <p id="namePoint2_3"></p>
                                <p id="namePoint2_4"></p>
                                <p id="namePoint2_5"></p>
                            </div>
                            <div class="count02 num">
                                <p id="sumPoint20_0"></p>
                                <p id="sumPoint20_1"></p>
                                <p id="sumPoint20_2"></p>
                                <p id="sumPoint20_3"></p>
                            </div>
                            <div class="count03 num">
                                <p id="sumPoint21_0"></p>
                                <p id="sumPoint21_1"></p>
                                <p id="sumPoint21_2"></p>
                            </div>
                            <div class="count04 num">
                                <p id="sumPoint22_0"></p>
                                <p id="sumPoint22_1"></p>
                            </div>
                        </div>
                        <!-- 응모자 이름 3자 + 캐릭터 이름 3자 -->
                        <div class="result-type type03" id="type03" style="display:none">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_event_enter03.jpg" alt="3자+3자">
                            <div class="name">
                                <p id="name5_1"></p>
                                <p id="name6_1" class="blue-txt"></p>
                                <p id="name5_2"></p>
                                <p id="name6_2" class="blue-txt"></p>
                                <p id="name5_3"></p>
                                <p id="name6_3" class="blue-txt"></p>
                            </div>
                            <div class="count01 num">
                                <p id="namePoint3_1"></p>
                                <p id="namePoint3_2"></p>
                                <p id="namePoint3_3"></p>
                                <p id="namePoint3_4"></p>
                                <p id="namePoint3_5"></p>
                                <p id="namePoint3_6"></p>
                            </div>
                            <div class="count02 num">
                                <p id="sumPoint30_0"></p>
                                <p id="sumPoint30_1"></p>
                                <p id="sumPoint30_2"></p>
                                <p id="sumPoint30_3"></p>
                                <p id="sumPoint30_4"></p>
                            </div>
                            <div class="count03 num">
                                <p id="sumPoint31_0"></p>
                                <p id="sumPoint31_1"></p>
                                <p id="sumPoint31_2"></p>
                                <p id="sumPoint31_3"></p>
                            </div>
                            <div class="count04 num">
                                <p id="sumPoint32_0"></p>
                                <p id="sumPoint32_1"></p>
                                <p id="sumPoint32_2"></p>
                            </div>
                            <div class="count05 num">
                                <p id="sumPoint33_0"></p>
                                <p id="sumPoint33_1"></p>
                            </div>
                        </div>
                        <div class="noti-area" id="winPop" style="display:none">
                            <!-- 50점 이상 -->
                            <div class="noti-info">
                                <p class="tit">축하합니다!</p>
                                <p><span class="name" id="vName1"></span>님과 <span class="c-name" id="vName2"></span>의 하트 점수는 <span class="num" id="vPoint1"></span> 입니다.</p>
                                <p>하트 점수가 50점 이상으로</p>
                                <p>'카카오톡 홀맨티콘'을 선물로 드립니다!</p>
                            </div>
                            <input class="talk-num" id="couponCode" readonly>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_ok_noti.jpg" alt="축하합니다!">
                            <!-- 홀맨티콘 등록 링크 -->
                            <a href="http://kko.to/coupon" target="_blank" class="mWeb"></a>
                            <a href="#" onclick="fnAPPpopupExternalBrowser('http://kko.to/coupon'); return false;" class="mApp"></a>
                        </div>
                        <div class="noti-area half-down" id="failPop" style="display:none">
                            <!-- 50점 이하 -->
                            <div class="noti-info">
                                <p><span class="name" id="vName3"></span>님과 <span class="c-name" id="vName4"></span>의 하트 점수는<br/>아쉽게도<span class="num" id="vPoint2"></span> 입니다.</p>
                                <p>하트 점수가 50점 이상인 분들께는<br/>'카카오톡 홀맨티콘'을 드리고 있으니<br/><span class="txt-bold">내일 잊지 말고 또 참여해주세요!</span></p>
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_no_noti.jpg" alt="내일 또 참여해주세요!">
                        </div>
                        <div class="sec-video">
                            <div class="video-inner">
                                <iframe width="560" height="315" src="https://www.youtube.com/embed/140kmOZ7cdg" title="YouTube video player" frameborder="0" allowfullscreen></iframe>
                            </div>
                        </div>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111138/m/img_noty.jpg" alt="유의사항">
                    </div>
                </div>
                
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->