<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 이왕 이렇게 된 거! 코멘트 이벤트
' History : 2021.07.22 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest
dim eCode, currentDate

IF application("Svr_Info") = "Dev" THEN
	eCode = "108379"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "113032"
    mktTest = True
Else
	eCode = "113032"
    mktTest = False
End If

eventStartDate  = cdate("2021-07-26")		'이벤트 시작일
eventEndDate 	= cdate("2021-08-08")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-07-26")
else
    currentDate = date()
end if


%>
<style>
/* common */
.mEvt113032 .section{position:relative;}
.mEvt113032 .float{width:26.3vw;position:absolute;top:50rem;left:72vw;animation:updown 0.8s ease-in-out alternate infinite;z-index:9;}
.mEvt113032 .float.active{position:fixed;top:7rem;}
.mEvt113032 .float.finish{position:absolute;top:382rem;}

/* section01 */
.mEvt113032 .title_slide{position:absolute;top:17rem;}
.mEvt113032 .title_slide .slide01 img{width:51.7vw;margin-left:22.15vw;margin-top:0.5rem;}
.mEvt113032 .title_slide .slide02 img{width:65.9vw;margin-left:15.05vw;margin-top:1rem;}
.mEvt113032 .title_slide .slide03 img{width:60.5vw;margin-left:20.75vw;margin-top:3rem;}
.mEvt113032 .title_slide .slide04 img{width:63.6vw;margin-left:15.2vw;margin-top:0.5rem;}
.mEvt113032 .click{width:7.7vw;position:absolute;top:35.5rem;right:17vw;z-index:5;}
.mEvt113032 .click.on{transform: scale(1.5);}

/* section03 */
.mEvt113032 .smile{position:absolute;top:6rem;right:5vw;width:13.6vw;height:4.5rem;background-image:url("//webimage.10x10.co.kr/fixevent/event/2021/113032/m/smile01.png?");background-size:100%;background-repeat: no-repeat;}
.mEvt113032 .smile.left{background-image:url("//webimage.10x10.co.kr/fixevent/event/2021/113032/m/smile02.png?");}
.mEvt113032 .twinkle{position:absolute;bottom:0.35rem;left:5vw;width:16vw;}
.mEvt113032 .twinkle.left{left:15vw;}

/* section04 */
.mEvt113032 .section04 .eunji{position:absolute;width:33.3vw;top:29.8rem;right:7vw;}
.mEvt113032 .section04 .eunji .swiper-slide{width:33.3vw;}

/* section05 */
.mEvt113032 .section05 .jihye{position:absolute;width:33.3vw;top:28.3rem;left:7vw;}
.mEvt113032 .section05 .jihye .swiper-slide{width:33.3vw;}

/* section06 */
.mEvt113032 .section06 .star{position:absolute;width:33.3vw;top:28.3rem;right:7vw;}
.mEvt113032 .section06 .star .swiper-slide{width:33.3vw;}

/* section07 */
.mEvt113032 .section07 .hyunji{position:absolute;width:33.3vw;top:28rem;left:7vw;}
.mEvt113032 .section07 .hyunji .swiper-slide{width:33.3vw;}

/* section09 */
.mEvt113032 .section09 .name{position:absolute;top:21rem;margin-left:8vw;font-size:2rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';color:#fff;}
.mEvt113032 .section09 .name span{text-decoration: underline;}
.mEvt113032 .section09 form{position:absolute;top:31rem;margin-left:8vw;}
.mEvt113032 .section09 input{width:30vw;float:left;background:transparent;border:0;margin-right:13vw;margin-bottom:2.2rem;font-size:2rem;color:#2242e4;}
.mEvt113032 .section09 .btn_popup{width:88vw;height:8rem;position:absolute;top:45rem;left:50%;margin-left:-44vw;}

/* section10 */
.mEvt113032 .section10{background:#2242e4;}
.mEvt113032 .section10 .comment{position:relative;}
.mEvt113032 .section10 .name{position:absolute;top:10rem;font-size:1.7rem;left:15vw;color:#2242e4;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt113032 .section10 .name span{text-decoration: underline;}
.mEvt113032 .section10 .resolve{position:absolute;top:13rem;left:15vw;font-size:2.2rem;}
.mEvt113032 .section10 .resolve p{margin-bottom:0.8rem;color:#8999ea;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt113032 .section10 .resolve p span{color:#2242e4;text-decoration: underline;}
.mEvt113032 .section10 .delete{position:absolute;top:8rem;right:13vw;width:4.8vw;}

/* popup */
.mEvt113032 .popup{z-index: 10;}
.mEvt113032 .bg_dim{position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.6);z-index:20;}
.mEvt113032 .popup .pop{position:fixed;top:10rem;left:50%;width:84vw;margin-left:-42vw;z-index:21;}
.mEvt113032 .popup .pop .name{position:absolute;top:23.5rem;left:17vw;font-size:1.2rem;color:#2242e4;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt113032 .popup .pop .name span{text-decoration: underline;}
.mEvt113032 .popup .pop .resolve{position:absolute;top:26rem;left:17vw;font-size:1.6rem;}
.mEvt113032 .popup .pop .resolve p{margin-bottom:0.8rem;color:#8999ea;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt113032 .popup .pop .resolve p span{color:#2242e4;text-decoration: underline;}
.mEvt113032 .popup .pop .btn_close{width:16vw;height:5rem;position:absolute;top:0;right:0;}

@keyframes updown {
    0% {transform: translateY(-0.5rem);}
    100% {transform: translateY(0.5rem);}
}
</style>

<script>
$(function() {
    $(window).scroll(function(){
        var $height = $(window).scrollTop();
        if($height > 572 && $height < 4449){
            $(".float").addClass("active");
            $(".float").removeClass("finish");
        }else if($height > 4450){
            $(".float").removeClass("active");
            $(".float").addClass("finish");
        }else{
            $(".float").removeClass("active");
        }
    });

    $(".click").click(function(){
        $(this).toggleClass("on");
    });

    setInterval(function(){
        $(".smile, .twinkle").toggleClass("left");
    },1000);

    mySwiper = new Swiper('.title_slide',{
		autoplay:3000,
        loop:true,
        effect:'slide',       
    });
    mySwiper2 = new Swiper('.eunji, .jihye, .star, .hyunji',{
		autoplay:1500,
        loop:true,
        effect:'slide',       
    });

    $(".btn_close").click(function(){
        $(".popup").css("display","none");
        return false;
    });
    doViewComment();
});

function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>

        if($("#txt1").val()==""){
			alert("코멘트를 입력해 주세요.");
            $("#txt1").focus();
			return false;
		};
        if($("#txt2").val()==""){
			alert("코멘트를 입력해 주세요.");
            $("#txt2").focus();
			return false;
		};
        if($("#txt3").val()==""){
			alert("코멘트를 입력해 주세요.");
            $("#txt3").focus();
			return false;
		};
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubscript113032.asp",
            data: {
                mode: 'add',
                txt1: $("#txt1").val(),
                txt2: $("#txt2").val(),
                txt3: $("#txt3").val()
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>');
                    $(".popup").css("display","block");
                    $("#txtview1").empty().html($("#txt1").val());
                    $("#txtview2").empty().html($("#txt2").val());
                    $("#txtview3").empty().html($("#txt3").val());
                    $("#txt1").val("");
                    $("#txt2").val("");
                    $("#txt3").val("");
                    doResetViewComment();
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
        <% end if %>
        return false;
    <% end if %>
}

function doResetViewComment(){
    $.ajax({
        type: "POST",
        url:"/event/etc/inc_113032list.asp",
        data: {
            currentPage: 1
        },
        success: function(Data){
            if(Data != ""){
                $("#commentList").html(Data);
            }
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.')
        }
    });
}

function doViewComment(){
    $.ajax({
        type: "POST",
        url:"/event/etc/inc_113032list.asp",
        data: {
            currentPage: $("#page").val()
        },
        success: function(Data){
            if(Data != ""){
                $("#commentList").append(Data);
            }
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.')
        }
    });
}

function fnDelComment(obj){
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubscript113032.asp",
            data: {
                mode: 'del',
                idx: obj
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    alert("내용이 삭제되어 응모가 취소되었습니다.\n응모를 원하시면 다시 작성해주세요.");
                    $("#c"+obj).hide();
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
        <% end if %>
        return false;
    <% end if %>
}

function fnCheckLength(el,len){
    if(el.value.length > len){
        el.value = el.value.substr(0, len);
    }
}

function jsGoComPage(){
    $("#page").val(Number($("#page").val())+1);
    doViewComment();
    return false;
}
</script>
			<div class="mEvt113032">
				<section class="section section01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/app_title.gif?v=2" alt="">
                    <p class="click"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/click.png?v=4" alt=""></p>
                </section>
                <section class="section section02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/txt.jpg?v=4" alt="">
                </section>
                <section class="section section03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/staff.jpg?v=4" alt="">
                    <p class="smile"></p>
                    <p class="twinkle"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/twinkle01.png?" alt=""></p>
                </section>
                <section class="section section04">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/eunji.jpg?v=4" alt="">
                    <div class="swiper-container eunji">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3581275&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/eun01.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3581275&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/eun01.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=2783164&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/eun02.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('2783164&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/eun02.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=1628870&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/eun03.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('1628870&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/eun03.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3880254&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/eun04.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3880254&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/eun04.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=2653277&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/eun05.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('2653277&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/eun05.png?" alt=""></a>
                            </div>
                        </div>
                    </div>
                </section>
                <section class="section section05">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/jihye.jpg?v=4" alt="">
                    <div class="swiper-container jihye">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3248594&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/ji01.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3248594&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/ji01.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3852494&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/ji02.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3852494&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/ji02.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3536345&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/ji03.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3536345&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/ji03.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3726255&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/ji04.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3726255&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/ji04.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3059288&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/ji05.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3059288&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/ji05.png?" alt=""></a>
                            </div>
                        </div>
                    </div>
                </section>
                <section class="section section06">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/star.jpg?v=4" alt="">
                    <div class="swiper-container star">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3717869&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/star01.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3717869&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/star01.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3930656&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/star02.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3930656&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/star02.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3922860&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/star03.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3922860&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/star03.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3016904&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/star04.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3016904&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/star04.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3700043&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/star05.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3700043&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/star05.png?" alt=""></a>
                            </div>
                        </div>
                    </div>
                </section>
                <section class="section section07">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/hyunji.jpg?v=4" alt="">
                    <div class="swiper-container hyunji">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3568029&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/hyun01.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3568029&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/hyun01.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3728726&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/hyun02.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3728726&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/hyun02.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3823913&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/hyun03.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3823913&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/hyun03.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3646229&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/hyun04.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3646229&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/hyun04.png?" alt=""></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="/category/category_itemprd.asp?itemid=3823925&pEtr=113032" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/hyun05.png?" alt=""></a>
                                <a href="#" onclick="fnAPPpopupProduct('3823925&pEtr=113032'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/hyun05.png?" alt=""></a>
                            </div>
                        </div>
                    </div>
                </section>
                <section class="section section08" id="go_button">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/plan.jpg?v=4" alt="">
                </section>
                <section class="section section09" id="eventJoin">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/input.jpg?v=4" alt="">
                    <p class="name"><span><% if GetLoginUserName()<>"" then %><%=GetLoginUserName()%><% else %>고객<% end if %></span> 님의 다짐!</p>
                    <form action="">
                        <input type="text" id="txt1" class="input01" placeholder="달리기" onKeyUp="fnCheckLength(this,4);">
                        <input type="text" id="txt2" class="input02" placeholder="하루" onKeyUp="fnCheckLength(this,4);">
                        <input type="text" id="txt3" class="input03" placeholder="30분씩" onKeyUp="fnCheckLength(this,10);">
                    </form>
                    <a href="" onclick="doAction();return false;" class="btn_popup"></a>
                </section>
                <section class="section section10">
                    <div class="com_wrap" id="commentList"></div>
                    <div class="more" onclick="jsGoComPage();return false;">
                        <input type="hidden" id="page" value="1">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/more.jpg?v=4" alt="">
                    </div>
                </section>
                <section class="section section11">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/notice.jpg?v=4" alt="">
                </section>
                <div class="float"><a href="#go_button"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/float.png?v=2" alt=""></a></div>
                <div class="popup" style="display:none;">
                    <div class="bg_dim"></div>
                    <div class="pop">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113032/m/popup.png" alt="">
                        <p class="name"><span><%=GetLoginUserName()%></span> 님의 다짐!</p>
                        <div class="resolve">
                            <p>이왕 이렇게 된 거</p>
                            <p><span id="txtview1"></span>을/를 <span id="txtview2"></span>에</p>
                            <p><span id="txtview3"></span> 해볼까</p>
                        </div>
                        <a href="#" class="btn_close"></a>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->