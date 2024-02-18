<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 새해맞이 내 장비에 새 옷 입히기
' History : 2022.01.10 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/ordercls/event_myordercls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest, rsMem
dim eCode, currentDate, moECode, sqlstr, myJoinCheck, arrItemList

IF application("Svr_Info") = "Dev" THEN
	eCode = "109442"
    moECode = "109402"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "116483"
    moECode = "116482"
    mktTest = True
Else
	eCode = "116483"
    moECode = "116482"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2022-01-12")		'이벤트 시작일
eventEndDate 	= cdate("2022-01-25")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2022-01-12")
else
    currentDate = date()
end if

sqlstr = "select top 30 sub_opt2, count(sub_opt2)"
sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] with(nolock)"
sqlstr = sqlstr & " where evt_code="& eCode &""
sqlstr = sqlstr & " and sub_opt3='join'"
sqlstr = sqlstr & " group by sub_opt2"
sqlstr = sqlstr & " order by count(sub_opt2) desc"
set rsMem = getDBCacheSQL(dbget,rsget,"Event116483",sqlstr,60*5)  ''10초
if NOT (rsMem is Nothing) then 
    IF Not (rsMem.EOF OR rsMem.BOF) THEN
        Do Until rsMem.EOF
            arrItemList = arrItemList & rsMem(0) & ","
            rsMem.MoveNext
		Loop
    END IF
    rsMem.close
end if
if arrItemList <>"" then
    arrItemList = left(arrItemList,(len(arrItemList)-1))
end if
set rsMem = Nothing
%>
<style>
.mEvt116483 section{position:relative;}

.mEvt116483 .section01 .slide-area{width:100%;position:absolute;top:47vw;left:50%;transform: translate(-50%,0);}
.mEvt116483 .section01 .slide-area .swiper-wrapper {transition-timing-function:linear;}
.mEvt116483 .section01 .slide-area .swiper-slide{width:66vw;padding:0 5vw;}
.mEvt116483 .section01 .flow{position:absolute;bottom:70vw;}

.mEvt116483 .section03 .pick{display:flex;width:86.7vw;height:29vw;position:absolute;top:0;left:50%;margin-left:-43.35vw;justify-content:space-between;}
.mEvt116483 .section03 .pick a{width:30%;}
.mEvt116483 .section03 .btn_alert{width:86.7vw;height:20vw;position:absolute;bottom:9.2vw;left:50%;margin-left:-43.35vw;}

.mEvt116483 .section04 .noti{position:relative;}
.mEvt116483 .section04 .noti::after{position:absolute;top:45%;right:29%;content:'';display:block;width:2.93vw;height:1.9vw;background:url(//webimage.10x10.co.kr/fixevent/event/2022/116483/m/arrow.png)no-repeat 0 0;background-size:100%;}
.mEvt116483 .section04 .noti.on::after{transform: rotate(180deg);}
.mEvt116483 .section04 .info{display:none;}
.mEvt116483 .section04 .info.on{display:block;}

.mEvt116483 .section06{background:#e5e5e5;}
.mEvt116483 .section06 .mySwiper{width:100%;padding-bottom:10vw;}
.mEvt116483 .section06 .mySwiper .swiper-slide{width:50vw;text-align:center;}
.mEvt116483 .section06 .mySwiper .swiper-slide .desc{display:none;}
.mEvt116483 .section06 .mySwiper .swiper-slide-active .desc{display:block;}
.mEvt116483 .section06 .mySwiper .swiper-slide-active .desc .name{width:35vw;margin:5vw auto 3vw;font-size:1.6rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';line-height:2.5rem;overflow:hidden; text-overflow:ellipsis; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; word-wrap:break-word;}
.mEvt116483 .section06 .mySwiper .swiper-slide-active .desc .price{font-size:2rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';color:#0c67d8;}
.mEvt116483 .section06 .mySwiper .swiper-slide-active .desc .price s{font-size:1.5rem;color:#000;font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}

.mEvt116483 .section07 .noti{position:relative;}
.mEvt116483 .section07 .noti::after{position:absolute;top:45%;right:29%;content:'';display:block;width:2.93vw;height:1.9vw;background:url(//webimage.10x10.co.kr/fixevent/event/2022/116483/m/arrow_b.png)no-repeat 0 0;background-size:100%;}
.mEvt116483 .section07 .noti.on::after{transform: rotate(180deg);}
.mEvt116483 .section07 .info{display:none;}
.mEvt116483 .section07 .info.on{display:block;}

.mEvt116483 .section08 .bg_dim{display:none;background:rgba(0,0,0,0.8);position:fixed;top:0;left:0;right:0;bottom:0;z-index:999;}
.mEvt116483 .section08 .pop01{display:none;position:fixed;top:20vw;left:0;z-index:9999;}
.mEvt116483 .section08 .pop01 input{position:absolute;bottom:45vw;left:9vw;font-size:1.5rem;background:transparent;border:0;padding:0 1vw;width:55vw;}
.mEvt116483 .section08 .pop01 .submit{width:13vw;height:10vw;position:absolute;bottom:44vw;right:23vw;background:transparent;}
.mEvt116483 .section08 .pop01 .btn_close{width:10vw;height:10vw;position:absolute;top:5vw;right:5vw;}

.mEvt116483 .section08 .pop02{display:none;position:fixed;top:30vw;left:50%;z-index:9999;width:86.7vw;margin-left:-43.35vw;}
.mEvt116483 .section08 .pop02 .user_id{position:absolute;top:12vw;width:100%;text-align:center;font-size:2.3rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';color:#0c67d8;}
.mEvt116483 .section08 .pop02 .user_id span{text-decoration: underline;}
.mEvt116483 .section08 .pop02 .btn_alert{position:absolute;bottom:10vw;left:50%;width:80vw;margin-left:-40vw;height:19vw;}
.mEvt116483 .section08 .pop02 .btn_close{width:10vw;height:10vw;position:absolute;top:1vw;right:2vw;}

/* 당첨자 팝업레이어 */
.mEvt116483 .lyr.pop03 {display:block; overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.6);}
.mEvt116483 .lyr.pop03 .inner{width:87%;position:absolute; left:50%; top:9%; transform:translateX(-50%); max-width:32rem;padding-bottom: 12vw;}
.mEvt116483 .lyr.pop03 .inner a:nth-of-type(1) {display:block; position:absolute; top:0; right:0; width:16vw; height:5rem;}

</style>
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
<script src="https://unpkg.com/swiper@7/swiper-bundle.min.js"></script>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_116483.js?v=1.01"></script>
<script>
$(function(){
    var swiper = new Swiper(".slide-area .swiper-container", {
        autoplay: {
            delay:0,
        },
        speed: 3000,
        slidesPerView:'auto',
        loop:true
	});

    var i=1;
    setInterval(function(){
        i++;
        if(i>4){i=1;}
        $('.flow img').attr("src","//webimage.10x10.co.kr/fixevent/event/2022/116483/m/txt0"+i+".png");
    },700);

    codeGrp = [<%=arrItemList%>];
    var $rootEl = $("#itemlist01");
    var itemEle = tmpEl = "";
    $rootEl.empty();
    codeGrp.forEach(function(item){
        tmpEl = '<div class="swiper-slide">\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="thumbnail"><img src="" alt=""></div>\
                        <div class="desc">\
                            <div class="name">상품명</div>\
                            <div class="price"><s>정가</s> 할인가</div>\
                        </div>\
                    </a>\
                </div>\
                '
        itemEle += tmpEl;
    });
    
    $rootEl.append(itemEle);
    fnApplyItemInfoList({
        items:codeGrp,
        target:"itemlist01",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    var swiper = new Swiper(".mySwiper", {
        effect: "coverflow",
        grabCursor: true,
        centeredSlides: true,
        slidesPerView: "auto",
        coverflowEffect: {
          rotate: 50,
          stretch: 0,
          depth: 100,
          modifier: 1,
          slideShadows: true,
        }
    });

    $('.mEvt116483 section .noti').click(function(){
        $(this).toggleClass('on');
        $(this).siblings('.info').toggleClass('on');
    })

    $('.mEvt116483 .section08 .pop02 .btn_close').click(function(){
        $('.mEvt116483 .section08 .bg_dim').hide();
        $('.mEvt116483 .section08 .pop02').hide();
        return false;
    });

    // 당첨자 팝업레이어
    $('.mEvt116483 .pop03 .btn_close').click(function(){
        $('.pop03').css('display','none');
        return false;
	})
});

function goProduct(itemid) {
	<% if isApp then %>
		fnAPPpopupProduct(itemid);
	<% else %>
		parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
	<% end if %>
	return false;
}

function fnCouponSelect(cnum){
	<% if not (currentDate >= eventStartDate and currentDate <= eventEndDate) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        if($("#ticket").val()<1){
			alert("응모권을 모두 소진 했습니다.");
			return false;
		};
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116483.asp",
            data: {
                mode: 'add',
                couponNum: cnum
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    alert(data.message);
                }else{
                    alert(data.message);
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        calllogin();
		return false;
    <% end if %>
}

function doAction(){
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116483.asp",
            data: {
                mode: 'join'
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    $('.mEvt116483 .section08 .bg_dim').show();
                    $('.mEvt116483 .section08 .pop02').show();
                }else{
                    alert(data.message);
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        calllogin();
		return false;
    <% end if %>
}

function doPushAlarm() {
	<% if not (currentDate >= eventStartDate and currentDate <= eventEndDate) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116483.asp",
            data: {
                mode: 'pushadd'
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    alert("알림 신청이 완료되었습니다.");
                }else{
                    alert(data.message);
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        calllogin();
		return false;
    <% end if %>
}

function doAlarm() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116483.asp",
            data: {
                mode: 'alarm'
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    alert(data.message);
                }else{
                    alert(data.message);
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        calllogin();
		return false;
    <% end if %>
}
</script>
			<div class="mEvt116483">
               <section class="section01">
                   <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section01.jpg" alt="">
                   <div class="slide-area">
                        <div class="swiper-container">
                            <div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/item01.png" alt="pouch">
                                </div>
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/item02.png" alt="pouch">
                                </div>
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/item03.png" alt="pouch">
                                </div>
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/item04.png" alt="pouch">
                                </div>
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/item05.png" alt="pouch">
                                </div>
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/item06.png" alt="pouch">
                                </div>
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/item07.png" alt="pouch">
                                </div>
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/item08.png" alt="pouch">
                                </div>
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/item09.png" alt="pouch">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="flow">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/txt01.png" alt="">
                    </div>
               </section>
               <section class="section02">
                   <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section02.jpg" alt="">
               </section>
               <section class="section03">
                   <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section03.jpg" alt="">
                   <div class="pick">
                       <a href="" onclick="fnCouponSelect(1);return false;" class="pick01"></a>
                       <a href="" onclick="fnCouponSelect(2);return false;" class="pick02"></a>
                       <a href="" onclick="fnCouponSelect(3);return false;" class="pick03"></a>
                   </div>
                   <a href="" onclick="doPushAlarm();return false;" class="btn_alert"></a>
               </section>
               <section class="section04">
                   <p class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section04.jpg" alt=""></p>
                   <p class="info"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section05.jpg" alt=""></p>
               </section>
               <section class="section05">
                   <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section06.jpg?v=2" alt="">
                   <a href="" onclick="fnAPPpopupCategory('102108102111');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section07.jpg" alt=""></a>
                   <a href="" onclick="fnAPPpopupCategory('102119104101');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section08.jpg" alt=""></a>
                   <a href="" onclick="doAction();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section09.jpg" alt=""></a>
               </section>
               <section class="section06">
                   <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section10.jpg" alt="">
                   <div class="swiper mySwiper">
                       <div class="swiper-wrapper" id="itemlist01"></div>
                   </div>
               </section>
               <section class="section07">
                   <p class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section11.jpg" alt=""></p>
                   <p class="info"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section12.jpg?v=2" alt=""></p>
                   <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/section13.jpg" alt="">
               </section>
               <section class="section08">
                   <div class="bg_dim"></div>
                   <div class="pop02">
                       <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/pop02.png" alt="">
                       <p class="user_id"><span><%=LoginUserid%></span> 님</p>
                       <a href="" onclick="doAlarm();return false;" class="btn_alert"></a>
                       <a href="" class="btn_close"></a>
                   </div>
                    <!-- 당첨자 팝업레이어 -->
                   <div class="lyr pop03">
                        <div class="inner">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2022/116483/m/pop03.png" alt="">
                            <a href="" class="btn_close"></a>
                        </div>
                    </div> 
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->