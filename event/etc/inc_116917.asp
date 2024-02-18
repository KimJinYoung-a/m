<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 리뷰텐텐 이벤트
' History : 2022.02.09 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim eCode, LoginUserid, itemArr
dim eventStartDate, eventEndDate, currentDate, mktTest
LoginUserid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode = "109486"
    mktTest = True
    itemArr = "3279814,3204557,3262244,3308296"
ElseIf application("Svr_Info")="staging" Then
	eCode = "116917"
    mktTest = True
    itemArr = "4406119,4406118,4406117,4406116"
Else
	eCode = "116917"
    mktTest = False
    itemArr = "4406119,4406118,4406117,4406116"
End If

eventStartDate  = cdate("2022-02-11")		'이벤트 시작일
eventEndDate 	= cdate("2022-02-15")		'이벤트 종료일

if mktTest then
    currentDate = cdate("2022-02-11")
else
    currentDate = date()
end if
%>
<link
  rel="stylesheet"
  href="https://unpkg.com/swiper@8/swiper-bundle.min.css"
/>
<style>
.mEvt116917 .section{position:relative;}
.mEvt116917 button{background:transparent;}

.mEvt116917 .section02{background:#fff0c8;}
.mEvt116917 .section02 .item_list{display:flex;flex-wrap: wrap;justify-content: space-evenly;margin-bottom:3.47vw;}
.mEvt116917 .section02 .item_list li{width:42.67vw;height:66vw;position:relative;}
.mEvt116917 .section02 .item_list li .thumbnail{width:42.67vw;height:42.67vw;margin-bottom:3vw;}
.mEvt116917 .section02 .item_list li .desc .price{font-size:1.5rem;font-weight:bold;margin-bottom:2vw;display:flex;align-items:flex-end;}
.mEvt116917 .section02 .item_list li .desc .price s{font-size:1.2rem;color:#888;font-weight:normal;margin-right:2vw;}
.mEvt116917 .section02 .item_list li .desc .price span{font-size:1rem;color:#ff7a31;margin-left:1vw;}
.mEvt116917 .section02 .item_list li .desc .name{font-size:1.2rem;line-height:1.4;}
.mEvt116917 .section02 .item_list li .wish{z-index:999;display:block !important;width:5.47vw;height:4.9vw;position:absolute;background:url(//webimage.10x10.co.kr/fixevent/event/2022/116917/m/heart_off.png?v=1.01)no-repeat 0 0;background-size:100%;text-indent: -99999px;top:35.5vw;right:2vw;}
.mEvt116917 .section02 .item_list li .wish.on{background:url(//webimage.10x10.co.kr/fixevent/event/2022/116917/m/heart.png)no-repeat 0 0;background-size:100%;}
.mEvt116917 .section02 button{width:72vw;position:relative;top:0;left:50%;margin-left:-36vw;margin-bottom:16.67vw;}
.mEvt116917 .section02 button.btn_finish{display:none;}

.mEvt116917 .section03 .swiper-pagination{bottom:8vw;}
.mEvt116917 .section03 .swiper-pagination .swiper-pagination-bullet{background:#fff;opacity:0.5;}
.mEvt116917 .section03 .swiper-pagination .swiper-pagination-bullet.swiper-pagination-bullet-active{background:#fff;opacity:1;}

.mEvt116917 .popup{display:none;}
.mEvt116917 .popup .bg_dim{position:fixed;top:0;left:0;right:0;bottom:0;background:#000;opacity: 0.8;z-index:10000;}
.mEvt116917 .popup .pop{position:fixed;top:30vw;left:50%;transform: translateX(-50%);z-index: 10001;width:93.6vw;}
.mEvt116917 .popup .pop .user_id{position:relative;bottom:90vw;width:100%;text-align: center;padding-right:8vw;}
.mEvt116917 .popup .pop .user_id span{position:relative;width:fit-content;font-size:1.7rem;color:#fff;text-decoration:underline;}
.mEvt116917 .popup .pop .user_id span::after{background:url(//webimage.10x10.co.kr/fixevent/event/2022/116917/m/min.png)no-repeat 0 0;content:'';position:absolute;right:-7vw;bottom:0;width:6.4vw;height:7.07vw;background-size:100%;}
.mEvt116917 .popup .pop .btn_close{width:10vw;height:10vw;position:absolute;top:-1vw;right:3vw;}
.mEvt116917 .popup .pop .btn_alert{width:75vw;height:19vw;position:absolute;bottom:13vw;left:50%;transform:translateX(-50%);}
</style>
<script src="https://unpkg.com/swiper@8/swiper-bundle.min.js"></script>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js?v=1.01"></script>
<script>
$(function(){
    var swiper = new Swiper(".mySwiper", {
        autoplay:true,
        loop:true,
        speed:500,
        pagination: {
          el: ".swiper-pagination",
        },
    });

    $('.btn_close').click(function(){
        $('.popup').hide();
        return false;
    });

    fnWishCheck();

    codeGrp = [<%=itemArr%>];
    var $rootEl = $("#itemlist01");
    var itemEle = tmpEl = "";
    $rootEl.empty();
    codeGrp.forEach(function(item){
        tmpEl = '<li class="swiper-slide">\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="thumbnail"><img src="" alt=""></div>\
                        <div class="desc">\
                            <div class="name">상품명</div>\
                            <div class="price"><s>정가</s> 할인가</div>\
                        </div>\
                    </a>\
                    <div class="wish" id="wish'+item+'" onclick="fnWishAdd('+item+');return false;"></div>\
                </li>\
                '
        itemEle += tmpEl;
    });
    $rootEl.append(itemEle);
    fnApplyItemInfoList({
        items:codeGrp,
        target:"itemlist01",
        fields:["image","name","price","sale","wish"],
        unit:"none",
        saleBracket:false
    });
});

function goProduct(itemid) {
	<% if isApp then %>
		fnAPPpopupProduct(itemid);
	<% else %>
		parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
	<% end if %>
	return false;
}

function fnWishAdd(itemid){
	<% If Not(IsUserLoginOK) Then %>
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
        <% end if %>
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
		var data={
			mode: "wish",
            itemcode: itemid
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/doEventSubscript116917.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							$('#wish'+itemid).toggleClass('on');
                            if(!res.wishcheck){
                                $("#wishcheck").val("N");
                            }else{
                                $("#wishcheck").val("Y");
                            }
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
			alert("이벤트 참여기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function fnWishCheck(){
	<% If IsUserLoginOK Then %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
		var data={
			mode: "wishload"
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/doEventSubscript116917.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
                            if(res.wish1){
                                $('#wish'+res.wishitem1).addClass('on');
                                $("#wishcheck").val("Y");
                            }else{
                                $('#wish'+res.wishitem1).removeClass('on');
                            }
                            if(res.wish2){
                                $('#wish'+res.wishitem2).addClass('on');
                                $("#wishcheck").val("Y");
                            }else{
                                $('#wish'+res.wishitem2).removeClass('on');
                            }
                            if(res.wish3){
                                $('#wish'+res.wishitem3).addClass('on');
                                $("#wishcheck").val("Y");
                            }else{
                                $('#wish'+res.wishitem3).removeClass('on');
                            }
                            if(res.wish4){
                                $('#wish'+res.wishitem4).addClass('on');
                                $("#wishcheck").val("Y");
                            }else{
                                $('#wish'+res.wishitem4).removeClass('on');
                            }
                            if(res.wishcheck){
                                $('.btn_submit').show();
                                $('.btn_finish').hide();
                            }else{
                                $('.btn_submit').hide();
                                $('.btn_finish').show();
                            }
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
		<% End If %>
	<% End If %>
}

function fnReviewTenTenAdd(){
	<% If Not(IsUserLoginOK) Then %>
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
        <% end if %>
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
        if($("#wishcheck").val()!="Y"){
            alert("WISH 후 응모해주세요!");
			return false;
        }
		var data={
			mode: "add"
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/doEventSubscript116917.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
					if(res!="") {
						if(res.response == "ok"){
                            fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>');
							$('.btn_submit').hide();
                            $('.btn_finish').show();
                            $('.popup').show();
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
			alert("이벤트 참여기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function doAlarm(){
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/event/etc/doEventSubscript116917.asp",
            data: {
                mode: 'alarm'
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    alert("알림 신청이 완료되었습니다.\n당첨자는 2/16에 확인해 주세요.");
                }else{
                    alert("이미 응모 완료되었어요!\n당첨자는 2/16에 확인해 주세요.");
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
</script>
			<div class="mEvt116917">
				<section class="section section01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116917/m/section01.jpg" alt="">
                </section>
                <section class="section section02 prd_area">
                    <ul id="itemlist01" class="item_list"></ul>
                    <div class="submit">
                        <input type="hidden" id="wishcheck">
                        <button class="btn_submit" onclick="fnReviewTenTenAdd();"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116917/m/btn_on.png" alt=""></button>
                        <button class="btn_finish"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116917/m/btn_off.png" alt=""></button>
                    </div>
                </section>
                <section class="section section03">
                    <div class="swiper mySwiper">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116917/m/m01.png" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116917/m/m02.png" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116917/m/m03.png" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116917/m/m04.png" alt=""></div>
                        </div>
                        <div class="swiper-pagination"></div>
                    </div>                    
                </section>
                <section class="section section04">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2022/116917/m/section02.jpg" alt="">
                </section>
                <section class="popup">
                    <div class="bg_dim"></div>
                    <div class="pop">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2022/116917/m/popup.png?v=1.02" alt="">
                        <p class="user_id"><span><%=LoginUserid%></span></p>
                        <a href="" class="btn_close"></a>
                        <button class="btn_alert" onclick="doAlarm();"></button>
                    </div>
                </section>
			</div>