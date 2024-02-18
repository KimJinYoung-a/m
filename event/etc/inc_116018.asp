<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 연말 선물 100원 이벤트
' History : 2021.12.13 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest
dim eCode, currentDate, moECode

IF application("Svr_Info") = "Dev" THEN
	eCode = "109433"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "116018"
    mktTest = True
Else
	eCode = "116018"
    mktTest = False
End If

eventStartDate  = cdate("2021-12-15")		'이벤트 시작일
eventEndDate 	= cdate("2021-12-28")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-12-15")
else
    currentDate = date()
end if

%>
<style type="text/css">
.mEvt116018 section{position:relative;}

.mEvt116018 .section{position: relative;}
.mEvt116018 .section01_02 .top img{position:absolute;height: 100%;top:0; left: 50%;transform: translateX(-50%);width: auto;}
.mEvt116018 .section01_05 .scroll img{position:absolute;top: 0; width: 73vw;left: 50%;margin-left: -36.5vw;opacity:0;transform:translateY(20vw);transition:ease-in-out 1s;}
.mEvt116018 .section01_06 .scroll img{position:absolute;top: 0; width: 63vw;left: 50%;margin-left: -31.5vw;opacity:0;transform:translateY(20vw);transition:ease-in-out 1s .5s;}
.mEvt116018 .section .scroll img.on{opacity:1;transform:translateY(0);}

.mEvt116018 .section02 .login .txt{font-weight:600; width:100%;position: absolute;top: 0; left: 50%; transform: translateX(-50%);font-family:'CoreSansCBold', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular';font-size: 1.85rem;text-align: center;}
.mEvt116018 .section02 .login .txt span{text-decoration:underline;text-decoration-color: #8b8b8b;}
.mEvt116018 .section02 .login .txt02{line-height: 2;}

.mEvt116018 .section03 div{position: relative;}
.mEvt116018 .section03 p{position: absolute;font-family:'CoreSansCLight', 'AppleSDGothicNeo-Light', 'NotoSansKRLight'; color: #8e8e8e;left:10.6vw;bottom: 4.1vw;}
.mEvt116018 .section03 .prd01 p{left:11vw;bottom: 5.2vw;}
.mEvt116018 .section03 div div:nth-of-type(2) p{left:56vw;}

.mEvt116018 .section04 .btn-apply{position:absolute;top:39.5%;left:50%;width:86.7vw;height:20.5vw;margin-left:-43.35vw;text-indent: -999999999px;background:transparent;}
.mEvt116018 .section04 .noti_wrap .noti{position:absolute;width: 100%;height:10vw;top:73vw;}
.mEvt116018 .section04 .noti_wrap .noti::after{content:'';display:block;background:url(//webimage.10x10.co.kr/fixevent/event/2021/116018/m/arrow.png) no-repeat 0 0;transform: rotate(0deg);position:absolute;bottom:1.8vw;left:71.3vw;background-size:100%;width:3.1vw;height:1rem;}
.mEvt116018 .section04 .noti_wrap .noti.on::after{transform: rotate(180deg);top:3vw;}
.mEvt116018 .section04 .noti_wrap .notice{display:none;}

@keyframes updown {
    0% {transform: translateY(0px);}
    50% {transform: translateY(-0.5rem);}
    100% {transform: translateY(0.5rem);}
}

</style>
<script type="text/javascript">
$(function(){
    // top 이미지 변경
    var i=1;
	setInterval(function(){
		i++;
        if(i>5){i=1;}
		$('.section01_02 .top img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/116018/m/top_img0'+ i +'.png');
	},1000);

    // 스크롤 시 나타나기
    $(window).scroll(function(){
        $('.mEvt116018 .section .scroll img').each(function(){
        var y = $(window).scrollTop() + $(window).height() * 1;
        var imgTop = $(this).offset().top;
        if(y > imgTop) {
            $(this).addClass('on');
        }
        });
    });

    // noti
    $('.noti_wrap .noti').click(function(){
		if($(this).hasClass('on')){
			$(this).removeClass('on');
			$('.notice').css('display','none');
		}else{
			$(this).addClass('on');
			$('.notice').css('display','block');
		}
	});
    fnEventItemInfo();
})
function fnEventItemInfo(){
    $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116017.asp",
        data: {
            mode: 'item'
        },
        dataType: "JSON",
        success: function(data){
            if(data.response == "ok"){
                $("#item1").empty().html(comma(data.item1));
                $("#item2").empty().html(comma(data.item2));
                $("#item3").empty().html(comma(data.item3));
                $("#item4").empty().html(comma(data.item4));
                $("#item5").empty().html(comma(data.item5));
                $("#item6").empty().html(comma(data.item6));
                $("#item7").empty().html(comma(data.item7));
                $("#item8").empty().html(comma(data.item8));
                $("#item9").empty().html(comma(data.item9));
            }else if(data.response == "retry"){
                alert('이미 신청하셨습니다.');
            }
        },
        error: function(data){
            alert('시스템 오류입니다.');
        }
    });
}
function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
</script>
			<div class="mEvt116018">
				<section class="section01">
                    <div class="section section01_01">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section01_01.jpg" alt="">
                    </div>
                    <div class="section section01_02">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section01_02.jpg" alt="">
                        <div class="top">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/top_img01.png" alt="" class="top01">
                        </div>
                    </div>
                    <div class="section section01_04">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section01_04.jpg" alt="">
                    </div>
                    <div class="section section01_05">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section01_05.jpg" alt="">
                        <div class="scroll">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/scroll_img01.png" alt="" class="scroll_img01">
                        </div>
                    </div>
                    <div class="section section01_06">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section01_06.jpg" alt="">
                        <div class="scroll">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/scroll_img02.png" alt="" class="scroll_img02">
                        </div>
                    </div>
                </section>

                <section class="section02">
                    <div class="login">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section02.jpg" alt="">
                        <a href="https://tenten.app.link/DY1jB7gAWlb?%24deeplink_no_attribution=true">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section02_btn.jpg" alt="">
                        </a>
                    </div> 
                </section>
                
                <section class="section03">
                    <div class="prd01">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section03_01.jpg" alt=""> 
                        <p><span id="item1">00,000</span>명 응모중</p>
                    </div>
                    <div class="prd02">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section03_02.jpg" alt=""> 
                        <div class="prd02_01">
                            <p><span id="item2">00,000</span>명 응모중</p>
                        </div>
                        <div class="prd02_02">
                            <p><span id="item3">00,000</span>명 응모중</p>
                        </div>
                    </div>
                    <div class="prd03">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section03_03.jpg" alt=""> 
                        <div class="prd03_01">
                            <p><span id="item4">00,000</span>명 응모중</p>
                        </div>
                        <div class="prd03_02">
                            <p><span id="item5">00,000</span>명 응모중</p>
                        </div>
                    </div>
                    <div class="prd04">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section03_04.jpg" alt=""> 
                        <div class="prd04_01">
                            <p><span id="item6">00,000</span>명 응모중</p>
                        </div>
                        <div class="prd04_02">
                            <p><span id="item7">00,000</span>명 응모중</p>
                        </div>
                    </div>
                    <div class="prd05">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section03_05.jpg" alt=""> 
                        <div class="prd05_01">
                            <p><span id="item8">00,000</span>명 응모중</p>
                        </div>
                        <div class="prd05_02">
                            <p><span id="item9">00,000</span>명 응모중</p>
                        </div>
                        <div class="background">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section03_06.jpg" alt=""> 
                        </div>
                    </div>
                </section>
                <section class="section04">  
                    <div class="noti_wrap">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section04.jpg" alt=""> 
						<p class="noti"></p>
						<p class="notice"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/info.jpg" alt="" class="info"></p>
					</div>
                </section>
                <section class="section05">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section04_02.jpg" alt=""> 
                    <a href="http://m.10x10.co.kr/event/benefit/index.asp">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116018/m/section05.jpg" alt="">
                    </a>
                </section>
		    </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->