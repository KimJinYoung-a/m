<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 안녕? 난 고양이 띠야
' History : 2022.01.13 정태훈 생성
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
	eCode = "109446"
    moECode = "109402"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "116675"
    moECode = "116674"
    mktTest = True
Else
	eCode = "116675"
    moECode = "116674"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid=" & moECode & "&gaparam=" & gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2022-01-26")		'이벤트 시작일
eventEndDate 	= cdate("2022-02-28")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2022-01-26")
else
    currentDate = date()
end if

dim iandOrIos, iappVer, vProcess
iappVer = getAppVerByAgent(iandOrIos)

if (iandOrIos="a") then
    if (FnIsAndroidKiKatUp) then
        if (iappVer>="1.48") then
            ''신규 업노드    
            vProcess = "A"
        else
            ''어플리케이션 1.48 이상 버전업이 필요하다.
            vProcess = "I"
        end if
    else
        '' 기존
        vProcess = "I"
    end if
else
    ''기존.
    vProcess = "I"
end If

Dim vImgURL
vImgURL = staticImgUrl & "/event/116675/userimg/"

'// 카카오 링크
Dim kakaotitle : kakaotitle = "지금 고양이 띠 인증 카드를 발급해보세요"
Dim kakaodescription : kakaodescription = "나만의 고양이 띠 전용 키트를 9,900원에 구매 할 수 있는 기회!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.mEvt116675 .topic {position:relative;}
.mEvt116675 .txt-hidden {font-size:0; text-indent:-9999px;}
.mEvt116675 .topic h2 {width:21.63rem; position:absolute; left:50%; top:5rem; margin-left:-10.82rem; opacity:0; transform:translateY(50%); transition:all 1s;}
.mEvt116675 .topic .img01 {width:23.55rem; position:absolute; left:50%; top:25.5rem; margin-left:-11.78rem; z-index:5; opacity:0; transform:translateY(50%); transition:all 1s .3s;}
.mEvt116675 .topic h2.on,
.mEvt116675 .topic .img01.on {opacity:1; transform:translateY(0);}
.mEvt116675 .animate {opacity:0; transform:translateY(2rem); transition:all 1s;}
.mEvt116675 .animate.on {opacity:1; transform:translateY(0);}
.mEvt116675 .fade-swiper {width:100%; position:absolute; left:0; top:33rem;}
.mEvt116675 .section-01,
.mEvt116675 .section-02 {position:relative;}
.mEvt116675 .section-01 .txt01 {width:25rem; position:absolute; left:50%; top:6rem; margin-left:-12.5rem;}
.mEvt116675 .section-01 .txt02 {width:24.02rem; position:absolute; left:50%; top:13rem; margin-left:-12.01rem; transition-delay:0.2s;}
.mEvt116675 .section-01 .txt03 {width:24.79rem; position:absolute; left:50%; top:36rem; margin-left:-12.40rem; transition-delay:0.4s;}
.mEvt116675 .section-01 .btn-card {width:100%; height:6rem; position:absolute; left:0; bottom:9rem; background:transparent;}
.mEvt116675 .section-02 .btn-item {display:inline-block; width:100%; height:9rem; position:absolute; left:0; bottom:0;}
.mEvt116675 .page {position:fixed; left:0; top:0; width:100%; height:100vh; padding-bottom:7rem; z-index:20; background:#fff; overflow-y:scroll;}
.mEvt116675 .page.page02 {z-index:25; padding-bottom:7rem;}
.mEvt116675 .page.page03 {z-index:30;}
.mEvt116675 .list-card {padding:0 2.35rem;}
.mEvt116675 .list-card .bar {height:2.13rem;}
.mEvt116675 .list-card .card {width:100%; height:16.21rem; font-size:0; text-indent:-9999px;}
.mEvt116675 .list-card .card.card01 {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_card01.png?v=3.1) no-repeat 0 0; background-size:100%;}
.mEvt116675 .list-card .card.card02 {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_card02.png?v=3.1) no-repeat 0 0; background-size:100%;}
.mEvt116675 .list-card .card.card03 {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_card03.png?v=3.1) no-repeat 0 0; background-size:100%;}
.mEvt116675 .list-card .card.card01.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_card01_on.png?v=2.1) no-repeat 0 0; background-size:100%;}
.mEvt116675 .list-card .card.card02.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_card02_on.png?v=2.1) no-repeat 0 0; background-size:100%;}
.mEvt116675 .list-card .card.card03.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_card03_on.png?v=2.1) no-repeat 0 0; background-size:100%;}
.mEvt116675 .card-outer {margin: 0.85rem 2.35rem 0;}
.mEvt116675 .card-info {position:relative; width:100%; border-radius:1.3rem;}
.mEvt116675 .card-info.card-view img {border-radius:1.3rem;}
.mEvt116675 .card-info.card-view .photo {border-radius:0;}
.mEvt116675 .card-info .name {width:13.34rem; position:absolute; left:50%; top:5.5rem; margin-left:-12rem; text-align:center; font-size:1.20rem; color:#121212; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';overflow:hidden;height: 1.5rem;line-height: 1.5rem;}
.mEvt116675 .card-info .birth {position:absolute; left:6rem; top:7.3rem; font-size:1.07rem; color:#121212; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt116675 .card-info .txt {position:absolute; left:1rem; top:9.5rem; font-size:0.98rem; color:#121212; line-height:1.5; text-align:center;}
.mEvt116675 .card-info .photo {position:absolute; right:4vw; top:2.45rem; width:30.6vw; height:30.6vw; overflow:hidden;}
.mEvt116675 .card-info .photo img {width:100%; height:100%; object-fit:cover;}
.mEvt116675 .card-info .empty-container {position:absolute; left:0; top:0; width:100%; height:100%; z-index:10;}
.mEvt116675 .input-area {position:relative;}
.mEvt116675 .input-area input {width:24.15rem; height:4.61rem; position:absolute; left:50%; top:3.5rem; margin-left:-12.08rem; border:0; font-size:1.20rem; color:#b6b6b6; text-align:center; background:transparent; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt116675 .input-area .input-birth {top:9.2rem;}
.mEvt116675 .input-area input::placeholder {font-size:1.20rem; color:#b6b6b6;}
.mEvt116675 .btn-photo {width:21.15rem; height:4.61rem; position:absolute; left:50%; top:15rem; margin-left:-12.08rem; background:transparent;}
.mEvt116675 .btn-delete {width:3rem; height:2.61rem; position:absolute; right:3.8rem; bottom:2.2rem; background:transparent;}
.mEvt116675 .confirm-area {position:relative;}
.mEvt116675 .confirm-area .btn-prev {width:5rem; height:5rem; position:absolute; left:2rem; bottom:1rem; background:transparent;}
.mEvt116675 .confirm-area .btn-next {width:5rem; height:5rem; position:absolute; right:2rem; bottom:1rem; background:transparent;}
.mEvt116675 .page.page03 .id {display:flex; align-items:flex-end; justify-content:center; width:80%; position:absolute; left:50%; top:5.2rem; transform:translateX(-50%); font-size:2.22rem; color:#ef0f49; line-height:1; vertical-align:top; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt116675 .page.page03 .id span {display:inline-block; margin-right:0.8rem; border-bottom:0.2rem solid #ef0f49; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;}
.mEvt116675 .page.page03 .card-info {position:absolute; left:50%; top:23rem; width:calc(100% - 4.7rem); margin:0; transform:translateX(-50%);}
.mEvt116675 .link-area {position:relative;}
.mEvt116675 .link-area .kakao {display:inline-block; width:8rem; height:8rem; position:absolute; left:7rem; top:31rem;}
.mEvt116675 .link-area .url {background:transparent; width:8rem; height:8rem; position:absolute; left:17rem; top:31rem;}
.mEvt116675 .link-area .btn-item {display:inline-block; width:100%; height:9rem; position:absolute; left:0; bottom:0;}
.mEvt116675 .page.page02 .btn-cardback {width:8rem; height:8rem; position:absolute; left:0; top:0; background:transparent;}
.mEvt116675 .page.page03 .btn-goback {width:100%; height:6rem; position:absolute; left:0; bottom:42vw; background:transparent;}
.mEvt116675 .page.page03 .btn-share {width:100%; height:6rem; position:absolute; left:0; bottom:21vw; background:transparent;}
.mEvt116675 .loadingV19 {position:absolute; top:50%; left:50%; transform:translate(-50%,-50%);}
.mEvt116675 .loadingV19 p {font-size:1.37rem; color:#000000;}
</style>
<script src="/apps/appcom/wish/web2014/event/etc/catGangi/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<script>
$(function() {
    $('.topic h2,.topic .img01,.topic .img02').addClass('on');
    /* 글자,이미지 스르륵 모션 */
    $(window).scroll(function(){
        $('.animate').each(function(){
        var y = $(window).scrollTop() + $(window).height() * 1;
        var imgTop = $(this).offset().top;
        if(y > imgTop) {
            $(this).addClass('on');
        }
        });
    });
    /* slick slider */
    $('.fade-swiper .slider').slick({
        slidesToShow: 2,
        slidesToScroll: 1,
        autoplay: true,
        autoplaySpeed: 0,
        speed: 5000,
        pauseOnHover: false,
        pauseOnFocus: false,
        cssEase: 'linear',
        arrows:false,
        dots:false
    });
    // popup 위치조절
    var headerTop = $('#header').height();
    $('.page').css('top',headerTop);
    // page 1 item 선택
    $('.list-card .card').on('click',function(){
        $(this).addClass('on').siblings().removeClass('on');
    });
});

function fnCheckCameraPermission(scriptFunc) {
	console.log("fnCheckCameraPermission");	
    callNativeFunction('checkCameraPermission', {
        "scriptFunc" : scriptFunc
    });
}

function checkPermission(){		
	fnCheckCameraPermission("runFileUpload()");	
}

function fnMakeCatCard(){
    <% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $("#cardselect").show();
    <% else %>
        calllogin();
		return false;
    <% end if %>
}

function fnCardSelect(obj){
    _selBgImg = obj;
    $("#bgcard").empty().append("<img src='/apps/appcom/wish/web2014/event/etc/catGangi/img_card0" + obj + ".png?v=3.2'>");
    $("#makecard").show();
}

function fnMoveBack(){
    $("#cardselect").show();
    $("#makecard").hide();
}

function fnMoveFirstBack(){
    $("#cardselect").hide();
    $("#makecard").hide();
    $("#certifydivcard").hide();
}

function fnWriteName(){
    if($("#wname").val().length<=12){
        $(".name").html($("#wname").val());
    }
}

function fnWriteBirth(obj){
    var dateStr = obj.replace(/[./-]/gi,"");
    var month = dateStr.substr(0,2); // 입력한 값의 4번째 자리부터 2자리 숫자 (월)
    var day = dateStr.substr(2,2); // 입력한 값 6번째 자리부터 2자리 숫자 (일)
    $("#mm").html(month);
    $("#dd").html(day);
}

function fnCertifyCard() {
    html2canvas(document.getElementById("container"))
    .then(function (canvas) {
        //이미지 저장
        var myImg = canvas.toDataURL("image/jpeg");
        //myImg = myImg.replace("data:image/jpeg;base64,", "");
        popLoading($('#makecard'));
        $.ajax({
            type : "POST",
            data : {
                "imgSrc" : myImg
            },
            dataType : "JSON",
            url : "<%=staticImgUpUrl%>/linkweb/event/event116675_image_upload.asp",
            success : function(data) {
                if(data.response == "ok"){
                    
                    $("#makecard").hide();
                    $("#certifydivcard").show();
                    $('#certifyCard').html("<img src='" + data.message + "'>");
                    $("#uploadimg").val(data.message);
                    
                    fnJoinEvent();
                }else{
                    alert(data.message);
                }
            },
            error : function(a, b, c) {
                alert("error");
            }
        });
    }).catch(function (err) {
        console.log(err);
    });
}

function fnCertifyCardAndroid() {
    var birthday = $("#wbirth").val();
    var dateStr = birthday.replace(/[./-]/gi,"");
    var month = dateStr.substr(0,2); // 입력한 값의 4번째 자리부터 2자리 숫자 (월)
    var day = dateStr.substr(2,2); // 입력한 값 6번째 자리부터 2자리 숫자 (일)
    $("#mm2").html(month);
    $("#dd2").html(day);
    $("#makecard").hide();
    $("#certifydivcard").show();
    $('#image_container2').html("<img src='" + _selImage + "'>");
    fnJoinEvent();
}

function fnJoinEvent() {
    $.ajax({
        type : "POST",
        data : {
            mode: 'add',
            imgSrc : $("#uploadimg").val()
        },
        dataType : "JSON",
        url:"/apps/appcom/wish/web2014/event/etc/catGangi/doEventSubscript116675.asp",
        success : function(data) {
            if(data.response == "ok"){
                console.log(data.response);
            }else{
                console.log(data.response);
            }
        },
        error : function(a, b, c) {
            alert("error");
        }
    });
}

function setThumbnail(event){
    var reader = new FileReader();
    reader.onload = function(event) {
        var img = document.createElement("img");
        img.setAttribute("src", event.target.result);
        var container = document.getElementById("image_container");
        while(container.hasChildNodes()){
            container.removeChild(container.firstChild);
        }
        document.querySelector("div#image_container").appendChild(img);
    };
    reader.readAsDataURL(event.target.files[0]);
}

function fnSelectImgCancel(){
    $("#image_container").empty();
}

function fnUrlCopy(){
    const clipboard = new Clipboard('#urlCopy');
    clipboard.on('success', function() {
        alert('URL이 복사 되었습니다.');
        return false;
    });
    clipboard.on('error', function() {
        alert('URL을 복사하는 도중 에러가 발생했습니다.');
        return false;
    });
}

function snschk(snsnum) {
<% if isapp then %>
    fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
    return false;
<% else %>
    event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
<% end if %>
}

// 카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){
    Kakao.Link.sendDefault({
        objectType: 'feed',
        content: {
            title: label,
            description : description,
            imageUrl: imageurl,
            link: {
            mobileWebUrl: linkurl
            }
        },
        buttons: [
            {
            title: '웹으로 보기',
            link: {
                mobileWebUrl: linkurl
            }
            }
        ]
    });
}

function doAlarm() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/catGangi/doEventSubscript116675.asp",
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

//-----------------------------------AOS upload-----------------------------------
var _selComp;
var _selImage;
var _selBgImg;

function fnAPPuploadImage(comp) {
    _selComp = comp;
    var paramname = comp.name;
    var upurl = "<%=staticImgUpUrl%>/linkweb/event/event116675_android_image_upload.asp?paramname="+paramname;
    callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish});
    return false;
}

function _appUploadFinish(ret){
    $("#name").html($("#wname").val());
    $("#bgcard2").empty().append("<img src='/apps/appcom/wish/web2014/event/etc/catGangi/img_card0" + _selBgImg + ".png?v=3.1'>");
    $("#image_container").html("<img src='<%=vImgURL%>" + ret.name + "'>");
    _selImage = "<%=vImgURL%>" + ret.name;
}

function appUploadFinish(ret){	
    _appUploadFinish(ret);
}

function popLoading(lyr) {
	var loading = '<div class="loadingV19"><i></i><p>고양이 카드 발급 중</p></div>';
	lyr.children('.inner').hide();
	lyr.prepend(loading);
	lyr.fadeIn(function() {
		lyr.children('.inner').delay(2000).fadeIn();
	});
}
</script>
			<div class="mEvt116675 ">
				<div class="topic">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/main.jpg?v=2" alt="고양이띠 인증 카드 event">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/tit_txt01.png?v=2" alt="안녕? 난 고양이띠야"></h2>
                    <div class="img01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/tit_txt02.png?v=2" alt="고양이띠 인즈 카드를 받으면, 코양이띠 키트를 단 9,900원에 드립니다."></div>
                    <div class="fade-swiper">
                        <!-- slide -->
                        <div class="slider">
                            <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/card_slide01.png?v=2" alt="인증 카드"></div>
                            <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/card_slide02.png?v=2" alt="인증 카드"></div>
                            <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/card_slide03.png?v=2" alt="인증 카드"></div>
                        </div>
                    </div>
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/bg_sub.jpg?v=3" alt="고양이띠 인증카드 event">
                    <div class="txt01 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/txt_sub01.png" alt="다들 호랑이의 해라고 떠드는 와중, 그간 억울했던 고양이들이 들고 일어났는데.."></div>
                    <div class="txt02 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/txt_sub02.png" alt="고양이의 해는 왜 없냥!"></div>
                    <div class="txt03 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/txt_sub03.png?v=2" alt="그동안, 고양이띠가 없어서 속상했던 분들께 텐바이냥이 공양이띠 인증 카드를 드립니다."></div>
                    <button type="button" class="btn-card txt-hidden" onclick="fnMakeCatCard()">나만의 인증 카드 만들기</button>
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/sub02.jpg?v=2" alt="고양이띠 키트를 드려요">
                </div>
                <div class="link-area">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_share.jpg?v=2" alt="친구에게도 알려주기">
                    <a href="#" class="kakao txt-hidden" onclick="snschk('ka');return false;">카카오 공유하기</a>
                    <button type="button" class="url txt-hidden" id="urlCopy" onclick="fnUrlCopy();" data-clipboard-text="https://m.10x10.co.kr/event/eventmain.asp?eventid=<%=eCode%>">url 공유하기</button>
                    <a href="" class="btn-item txt-hidden" onclick="fnAPPpopupSearchOnNormal('고양이','product');return false;">나에게 맞는 냥냥템 보러 가기</a>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/notice.jpg?v=3" alt="유의사항 자세히 보기">
                <div class="page" id="cardselect" style="display:none;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/tit01.jpg" alt="인증 카드 배경을 선택해주세요">
                    <div class="list-card">
                        <button type="button" class="card card01" onclick="fnCardSelect(1);">고양이띠 인증 카드</button>
                        <div class="bar"></div>
                        <button type="button" class="card card02" onclick="fnCardSelect(2);">고양이띠 인증 카드</button>
                        <div class="bar"></div>
                        <button type="button" class="card card03" onclick="fnCardSelect(3);">고양이띠 인증 카드</button>
                    </div>
                </div>
                <div class="page page02" id="makecard" style="display:none;">
                    <div class="inner">
                    <button type="button" class="btn-cardback txt-hidden" onclick="fnMoveBack();">뒤로</button>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/tit02.jpg?v=2" alt="카드에 들어갈 정보를 입력해주세요">
                    <div class="card-outer">
                        <div class="card-info" id='container'>
                            <div id="bgcard"><img src="/apps/appcom/wish/web2014/event/etc/catGangi/img_card01.png?v=3.2" alt="card-type01"></div>
                            <div class="name">김텐텐</div>
                            <div class="birth"><span id="mm">08</span>월 <span id="dd">17</span>일</div>
                            <div class="txt">위 사람은 텐바이냥 1조 1항에 따라<br/>고양이띠 임을 증명합니다.</div>
                            <div class="photo" id="image_container"></div>
                        </div>
                    </div>
                    <div class="input-area">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_input.jpg" alt="입력창">
                        <input type="text" id="wname" class="input-name" placeholder="닉네임을 입력해 주세요" maxlength="12" onkeyup="fnWriteName();">
                        <input type="text" id="wbirth" class="input-birth" placeholder="생일을 입력해 주세요" maxlength="4" onkeyup="fnWriteBirth(this.value);">
                        <% if vProcess="A" then 'Android %>
                        <label class="btn-photo txt-hidden" onClick="fnAPPuploadImage(document.frmUpload.fileupload);">이미지를 선택해 주세요</label>
                        <button type="button" class="btn-delete txt-hidden" onclick="fnSelectImgCancel()">선택 취소</button>
                            <form name="frmUpload" style="display:none; height:0px;width:0px;">
                            <input type="file" id="fileupload"  name="fileupload" accept="image/*"/>
                            </form>
                        <% else 'IOS %>
                        <label for="fileupload" class="btn-photo txt-hidden">이미지를 선택해 주세요</label>
                        <button type="button" class="btn-delete txt-hidden" onclick="fnSelectImgCancel()">선택 취소</button>
                            <form name="frmUpload" id="ajaxform" style="display:none; height:0px;width:0px;">
                            <% If iappVer < "2.36"Then %>
                            <input type="file" id="fileupload"  name="fileupload" accept="image/*" onchange="setThumbnail(event);"/>
                            <% Else %>
                            <input type="file" id="fileupload"  name="fileupload" accept="image/*" onclick="checkPermission()" onchange="setThumbnail(event);"/>
                            <% End if %>
                            </form>
                        <% End if %>
                    </div>
                    <div class="confirm-area">
                        <% if vProcess="A" then 'Android %>
                        <button type="button" onclick="fnCertifyCardAndroid();">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_confirm.jpg?v=3.1" alt="버튼을 누르면 나만의 고양이띠 인증카드가 발급된다냥">
                        </button>
                        <% else %>
                        <button type="button" onclick="fnCertifyCard();">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_confirm.jpg?v=3.1" alt="버튼을 누르면 나만의 고양이띠 인증카드가 발급된다냥">
                        </button>
                        <% End if %>
                    </div>
                    </div>
                </div>
                <div class="page page03" id="certifydivcard" style="display:none;">
                    <div class="top" style="position:relative;">
                        <% if vProcess="A" then 'Android %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/tit03.jpg?v=2" alt="고양이띠 인증 카드 발급 완료">
                        <div class="card-info card-view">
                            <div id="bgcard2"></div>
                            <div class="name" id="name">김텐텐</div>
                            <div class="birth"><span id="mm2">08</span>월 <span id="dd2">17</span>일</div>
                            <div class="txt">위 사람은 텐바이냥 1조 1항에 따라<br/>고양이띠 임을 증명합니다.</div>
                            <div class="photo" id="image_container2"></div>
                        </div>
                        <% else %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/tit03_type2.jpg?v=2" alt="고양이띠 인증 카드 발급 완료">
                        <div class="card-info card-view" id="certifyCard"></div>
                        <% End if %>
                        <button type="button" class="btn-goback txt-hidden" onclick="fnMoveFirstBack();">처음으로</button>
                        <button type="button" class="btn-share txt-hidden" onclick="snschk('ka');">공유하기</button>
                        <input type="hidden" id="uploadimg">
                    </div>
                    <a href="" onclick="doAlarm();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116675/m/img_alram.jpg" alt="알림 신청하기"></a>
                </div>
			</div>
<% 'AOS
function getAppVerByAgent(byref iosOrAnd)
    dim agnt : agnt =  Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    dim pos1 : pos1 = Instr(agnt,"tenapp ")
    dim buf 
    dim retver : retver=""
    getAppVerByAgent = retver
    
    if (pos1<1) then exit function
    buf = Mid(agnt,pos1,255)
    
    iosOrAnd = MID(agnt,pos1 + LEN("tenapp "),1)
    getAppVerByAgent = Trim(MID(agnt,pos1 + LEN("tenapp ")+1,4))
end function

function FnIsAndroidKiKatUp()
    dim iiAgent : iiAgent= Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    FnIsAndroidKiKatUp = (InStr(iiAgent,"android 4.4")>0)
    FnIsAndroidKiKatUp = FnIsAndroidKiKatUp or (InStr(iiAgent,"android 5")>0) or (InStr(iiAgent,"android 6")>0) or (InStr(iiAgent,"android 7")>0) or (InStr(iiAgent,"android 8")>0) or (InStr(iiAgent,"android 9")>0) or (InStr(iiAgent,"android 10")>0) or (InStr(iiAgent,"android 11")>0) or (InStr(iiAgent,"android 12")>0)
end function

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->