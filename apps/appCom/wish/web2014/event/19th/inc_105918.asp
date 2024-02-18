<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/19th/105918Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'#################################################################
' Description : 19주년 그림일기장 이벤트 
' History : 2020-09-24 정태훈
'#################################################################
%>
<%
Dim userid, currentDate, eventStartDate, eventEndDate, evtdiv, arrbest
currentDate =  now()
userid = GetEncLoginUserID()
eventStartDate  = cdate("2020-10-05")		'이벤트 시작일
eventEndDate 	= cdate("2020-10-18")		'이벤트 종료일
evtdiv = requestcheckvar(request("evtdiv"),5)
if evtdiv="" then evtdiv="evt1"

if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="cjw0515" or userid="thensi7" or userid = "motions" or userid = "jj999a" or userid = "phsman1" or userid = "jjia94" or userid = "seojb1983" or userid = "kny9480" or userid = "bestksy0527" or userid = "mame234" or userid = "corpse2" or userid = "starsun726" then
	currentDate = #10/18/2020 09:00:00#
end if

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode = 103233
Else
	eCode = 105918
End If

dim cEvtBBC, arrTOP3List, intCLoop
'데이터 가져오기
set cEvtBBC = new ClsEvtBBS
	cEvtBBC.FECode 		= eCode
    arrTOP3List = cEvtBBC.fnGetBBSTOP3List		'TOP3 리스트 가져오기
set cEvtBBC = nothing

function WeekKor(weeknum)
    if weeknum="1" then
        WeekKor="일"
    elseif weeknum="2" then
        WeekKor="월"
    elseif weeknum="3" then
        WeekKor="화"
    elseif weeknum="4" then
        WeekKor="수"
    elseif weeknum="5" then
        WeekKor="목"
    elseif weeknum="6" then
        WeekKor="금"
    elseif weeknum="7" then
        WeekKor="토"
    end if
end function
%>
<style>
@font-face {
	font-family:'KyoboHand';
	src:url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_20-04@1.0/KyoboHand.woff') format('woff');
	font-weight:normal;
	font-style:normal;
}
.mEvt105918 {position:relative; overflow:hidden; width:100vw; background:#fff;}
.mEvt105918 button {background:none;}
.mEvt105918 .topic {position:relative;}
.mEvt105918 .topic h2 {position:absolute; top:7.8%; left:0; width:100%;}
.mEvt105918 .topic span {position:absolute; left:6.7%; top:45.6%; width:46.7%;}
.mEvt105918 .topic.on h2 {animation:reveal 3s both; transition:1s;}
.mEvt105918 .topic.on span {animation:headShake 1s 1.5s 2 ease;}
.mEvt105918 .topic span:last-child {left:53.5%; animation-delay:2s;}
@keyframes headShake {
	0% {transform:translateX(0);}
	6.5% {transform:translateX(-6px) rotateY(-9deg);}
	18.5% {transform:translateX(5px) rotateY(7deg);}
	31.5% {transform:translateX(-3px) rotateY(-5deg);}
	43.5% {transform:translateX(2px) rotateY(3deg);}
	50% {transform:translateX(0);}
}
@keyframes reveal {
	0% {
		-webkit-mask-image:linear-gradient(.85turn, transparent 0%, transparent 40%, #fff 100%);
		mask-image:linear-gradient(.85turn, transparent 0%, transparent 40%, #fff 100%);
		-webkit-mask-size:300% 300%; mask-size:300% 300%; -webkit-mask-position:right; mask-position:right;
		}
	100% {-webkit-mask-position:inherit; mask-position:inherit;}
}

.section-diary {padding-bottom:12%;}
.diary-wrap {font-family:'KyoboHand'; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/bg_write_top.png) no-repeat center top / 100% auto;}
.diary-wrap input[type=text], .diary-wrap textarea {width:100%; font-family:inherit; font-size:5.3vw; color:#444; letter-spacing:1px; background:none; border:0;}
.diary-wrap input[type=text]::placeholder, .diary-wrap textarea::placeholder {color:#999;}
.diary-wrap input[type=text] {height:100%;}
.diary-wrap textarea {overflow:hidden; display:block; width:79vw; height:47vw; line-height:9.5vw; margin:0 auto; padding:0; resize:none; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/bg_underline.png) no-repeat center bottom / 100% auto;}

.diary-head {position:relative; height:0; padding-top:27.2%; margin:0 5.6%;}
.diary-head .name {position:absolute; top:18%; left:20%; width:33%; height:30%;}
.diary-head .date {display:flex; position:absolute; top:64%; left:3%; font-size:5.6vw; text-align:right;}
.diary-head .date em {width:7vw; margin-right:4vw;}
.diary-head .weather {display:flex; position:absolute; top:58%; right:4.2%;}
.diary-head .weather em {position:relative;}
.diary-head .weather label {display:block; height:8vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/ico_weather.png) no-repeat 0 0 / auto 200%;}
.diary-head .w1 label {width:8.5vw;}
.diary-head .w2 label {width:9.3vw; background-position-x:37%;}
.diary-head .w3 label {width:8.5vw; background-position-x:74%;}
.diary-head .w4 label {width:6.7vw; background-position-x:100%;}
.diary-head .weather input[type=radio] {overflow:hidden; position:absolute; width:1px; height:1px; margin:-1px; clip:rect(0,0,0,0);}
.diary-head .weather input:checked + label {background-position-y:100%;}
.diary-head .weather input:checked + label::after {content:' '; position:absolute; top:0; left:50%; width:9.3vw; height:100%; transform:translateX(-50%); background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/ico_weather_checked.png) no-repeat center / contain;}
.diary-pic {position:relative; margin:0 5.6%;}
.diary-pic .swiper-slide {width:100%;}
.diary-pic .fraction {position:absolute; top:4%; right:2%; z-index:5; padding:.3em .6em .1em; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:4vw; color:#999; background:rgba(255,255,255,.6); border-radius:.5em;}
.diary-pic [class*="swiper-button"] {top:0; width:8vw; height:100%; font-size:0; background:no-repeat center / 100% auto;}
.diary-pic .swiper-button-prev {left:0; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/ico_slider_prev.png);}
.diary-pic .swiper-button-next {right:0; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/ico_slider_next.png);}
.diary-foot .tit {height:10.9vw; padding-left:19%; margin:0 5.6%;}
.diary-foot .con {padding:3% 5.6% 9%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/bg_write_bot.png) no-repeat center bottom / 100% auto;}
.diary-foot .btn-submit {display:block; width:100%; margin:6vw 0 -2vw;}

.section-contest {position:relative; padding-bottom:9%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/bg_pat.jpg) repeat 0 0 / 6%;}
.section-contest .best-wrap {position:relative;}
.best-wrap .swiper-container {overflow:visible; margin-bottom:1em;}
.best-wrap .medal {position:absolute; top:-5%; left:0; z-index:10; width:6.5rem; height:6.8rem; font-size:0; background:no-repeat center / contain;}
.best-wrap .medal1 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_medal_01.png);}
.best-wrap .medal2 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_medal_02.png);}
.best-wrap .medal3 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_medal_03.png);}
.best-wrap .medal4 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_medal_04.png);}
.best-wrap .medal5 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_medal_05.png);}
.best-wrap .medal6 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_medal_06.png);}
.best-wrap .medal7 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_medal_07.png);}
.best-wrap .medal8 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_medal_08.png);}
.best-wrap .medal9 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_medal_09.png);}
.best-wrap .medal10 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_medal_10.png);}
.section-contest .pic-list-wrap {position:relative;}
.pic-list-wrap input, .pic-list-wrap select {width:100%; height:100%; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:4.8vw; color:#444; background:none; border:0;}
.pic-list-wrap input {padding:0 0 0 10%;}
.pic-list-wrap input::placeholder {color:#999;}
.pic-list-wrap select {padding:0 0 0 16%; outline:none; background:none;}
.pic-list-wrap .filter {display:flex; justify-content:space-between; position:absolute; left:0; top:29vw; width:100%; height:10vw; padding:0 5%;}
.pic-list-wrap .search {position:relative; width:71%; padding-right:13%;}
.pic-list-wrap .sort {width:27%;}
.pic-list-wrap .btn-sch {position:absolute; top:0; right:3%; width:10vw; height:100%;}
.section-contest .pic-list {display:flex; flex-wrap:wrap; padding:0 4%;}
.section-contest .pic-list li {float:left; width:50%; padding:0 1.5%;}

.section-contest .pic-item {position:relative;}
.section-contest .pic-item > a {display:block;}
.section-contest .best-wrap .pic-item {padding:0 5%;}
.section-contest .thumbnail {position:relative; overflow:hidden; height:0; padding-top:100%;}
.section-contest .thumbnail img {position:absolute; top:0; right:0; bottom:0; left:0; width:100%; height:100%; object-fit:cover; border-radius:.85rem;}
.section-contest .thumbnail::after {content:' '; position:absolute; top:0; left:0; width:100%; height:100%; z-index:5; background:no-repeat center / 100% 100%;}
.section-contest .best-wrap .thumbnail::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/bg_thumb_670.png);}
.section-contest .pic-list-wrap .thumbnail::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/bg_thumb_320.png);}
.section-contest .desc {text-align:center;}
.section-contest .best-wrap .desc {padding:1rem 0 0rem;}
.section-contest .pic-list-wrap .desc {padding:1rem 0 2rem;}
.section-contest .desc .tit {padding-bottom:.5rem; font-family:'KyoboHand'; word-break:break-all;}
.section-contest .best-wrap .tit {font-size:2.39rem;}
.section-contest .pic-list-wrap .tit {font-size:1.71rem;}
.section-contest .desc .userid {padding-bottom:.8rem; color:#888;}
.section-contest .best-wrap .userid {font-size:1.37rem;}
.section-contest .pic-list-wrap .userid {font-size:1.28rem;}
.section-contest .desc .stamp {position:relative; display:flex; justify-content:center; align-items:center; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.45rem; color:#ff4f4f;}
.section-contest .desc .stamp::before {content:' '; display:inline-block; width:1.71rem; height:2.56rem; margin-right:.3em; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/ico_stamp.png) no-repeat center / contain;}
.section-contest .btn-del {position:absolute; top:0; z-index:10; width:10vw; height:10vw; font-size:0; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/ico_del.png) no-repeat center / 8.5vw;}
.section-contest .best-wrap .btn-del {right:5%;}
.section-contest .pic-list-wrap .btn-del {right:3%;}

.section-contest .paging {display:flex; text-align:center; justify-content:center; margin-top:5%;}
.section-contest .paging a {display:inline-block; width:8vw; height:8vw; margin:0 2vw; line-height:8vw; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:4.5vw; color:#ccc;}
.section-contest .paging .active {color:#222;}
.section-contest .paging a[class*="page"] {margin:0; font-size:0; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/ico_page_arrow.png) no-repeat center / 2.7vw;}
.section-contest .paging .page-prev {transform:scale(-1);}
.section-contest .bnr-evt {margin-top:10%;}

.section-notice {padding:9% 0; line-height:1.4; color:#fff; background:#444;}
.section-notice h3 {text-align:center; font-size:6.4vw; letter-spacing:1px;}
.section-notice ul {padding:0 5% 0 8%;}
.section-notice li {position:relative; padding-top:.8em; text-align:left; font-size:3.8vw; word-break:keep-all; letter-spacing:-.3px;}
.section-notice li::before {position:absolute; content:'-'; left:-3%;}

.mEvt105918 .popup {display:none; position:fixed; top:0; left:0; z-index:50; width:100%; height:100%; background:rgb(255,255,255);}
.mEvt105918 .popup .btn-close {position:absolute; top:0; right:0; z-index:10; width:16vw; height:16vw; font-size:0; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/ico_close.png) no-repeat center / contain;}
.mEvt105918 .popup .inner {overflow:hidden auto; height:100%;}
.mEvt105918 .popup-diary .inner {padding-bottom:10%;}
.mEvt105918 .popup-contest .inner {position:relative; padding:15% 0 10%;}
.mEvt105918 .popup-contest [class*="post"] {position:absolute; top:50%; width:14vw; height:14vw; margin-top:-3vw; font-size:0; background:no-repeat center / contain;}
.mEvt105918 .popup-contest .post-prev {left:0; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/pop_ico_prev.png);}
.mEvt105918 .popup-contest .post-next {right:0; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/pop_ico_next.png);}
.mEvt105918 .popup-contest .btn-stamp {position:fixed; bottom:5%; right:0; z-index:10; width:17.8%; transform:translateX(0); animation:shake 1s ease;}
.mEvt105918 .popup-contest .stamp {display:none; position:absolute; bottom:5%; right:9.8%; width:29.3%;}
.mEvt105918 .popup-contest .stamp.on {display:block; animation:stamp .5s ease-in-out;}
@keyframes shake {
	0%, 100% {transform:translateX(0);}
	20%, 60% {transform:translateX(1vw);}
	40%, 80% {transform:translateX(-1vw);}
}
@keyframes stamp {
	0% {opacity:0; transform:scale(1);}
	30% {opacity:1; transform:scale(1.5);}
	100% {opacity:1; transform:scale(1);}
}
</style>
<script>
var _selectedWeather=1;
var _selectedPicture=1;

$(function() {
	$('.mEvt105918 .topic').addClass('on');
	// 그림 선택
	function return_index(){
		var r_index = Math.floor(Math.random() * $(".diary-pic .swiper-slide").length);
		return parseInt(r_index);
	}
	var swiper = new Swiper('.diary-pic .swiper-container', {
		speed: 700,
		loop: true,
		prevButton:'.swiper-button-prev',
		nextButton:'.swiper-button-next',
		initialSlide : return_index(),
		onSlideChangeStart: function (swiper) {
		var active = swiper.activeIndex % 10 || 10;
            $('.diary-pic .current').text(active);
            _selectedPicture=active;
		}
	});
	// BEST 그림일기
	var swiper = new Swiper('.best-wrap .swiper-container', {
		speed: 700,
		loop: true,
		autoplay: 3300
	});
	// 팝업 닫기
	$('.mEvt105918 .popup .btn-close').on('click', function(e) {
		$(this).closest('.popup').fadeOut();
	});

	// 다른 사람 팝업 보기
	$('.mEvt105918 .pic-item a').on('click', function(e) {
		e.preventDefault();
		$('.popup-contest').fadeIn();
	});
	// 도장 (추천)
	$('.mEvt105918 .btn-stamp').on('click', function(e) {
		$(this).next('.stamp').addClass('on');
	});

	// 날씨 선택 체크
	$('input:radio[name="weather"]').on('click', function(e) {
        _selectedWeather=$(this).val();
    });
    jsGoComPage(1,1,'');
});

function eventTry(){
    <% If Not(IsUserLoginOK) Then %>
        calllogin();
        return false;
    <% else %>
        <% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>

            if(!$("#userName").val()){
                alert("이름을 적어주세요!");
                return false;
            }

            if(!$("#txtSubject").val()){
                alert("제목을 적어주세요!");
                return false;
            }

            if(!$("#txtComm").val()){
                alert("코멘트를 적어주세요!");
                return false;
            }

            if (GetByteLength($("#txtComm").val()) >= 160){
                alert("최대 80자 이내로 입력해주세요.");
                return false;
            }
            var makehtml="";
            var returnCode, itemid, data
            var data={
                mode: "add",
                selectedWeather: _selectedWeather,
                selectedPicture: _selectedPicture,
                txtsubject: $("#txtSubject").val(),
                username: $("#userName").val(),
                txtcomm: $("#txtComm").val()
            }
            $.ajax({
                type:"POST",
                url:"/apps/appcom/wish/web2014/event/19th/do105918Proc.asp",
                data: data,
                dataType: "JSON",
                success : function(res){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + _selectedPicture);
                        if(res!="") {
                            // console.log(res)
                            if(res.response == "ok"){
                                $("#mytxtSubject").val($("#txtSubject").val());
                                $("#myName").val($("#userName").val());
                                $("#mytxtComm").val($("#txtComm").val());
                                $('input[name="myweather"]:radio[value="'+_selectedWeather+'"]').prop('checked',true);
								if(_selectedPicture >9){
                                	$('#mypicture').attr('src','//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_' + _selectedPicture + '.jpg');
								}
								else{
									$('#mypicture').attr('src','//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_0' + _selectedPicture + '.jpg');
								}
								$('#popup_diary').show();
								jsGoComPage(1,1,'');
								$("#txtSubject").val("");
								$("#userName").val("");
								$("#txtComm").val("");
								_selectedWeather=1;
								_selectedPicture=1;
                                return false;
                            }else{
                                alert(res.faildesc);
                                return false;
                            }
                        } else {
                            alert("잘못된 접근 입니다.1");
                            document.location.reload();
                            return false;
                        }
                },
                error:function(err){
                    console.log(err)
                    alert("잘못된 접근 입니다2.");
                    return false;
                }
            });
        <% Else %>
            alert("이벤트 응모 기간이 아닙니다.");
            return;
        <% End If %>
    <% End If %>
}

function jsGoComPage(vpage,sort,searchtxt){
    $.ajax({
        type: "POST",
        url: "/apps/appcom/wish/web2014/event/19th/list_105918.asp",
        data: {
            iCC: vpage,
            sortDiv: sort,
            searchTxt: searchtxt
        },
        success: function(Data){
            $("#diarylist").html(Data);
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.')
            //$("#listContainer").empty();
        }
    })
}

function fnDelDiary(idx){
    <% If Not(IsUserLoginOK) Then %>
        calllogin();
        return false;
	<% else %>
		if(!confirm("삭제 하시겠습니까?")){
			return false;
		}
		var data={
			mode: "del",
			bbs_idx: idx
		}
		$.ajax({
			type:"POST",
			url:"/apps/appcom/wish/web2014/event/19th/do105918Proc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				if(res!="") {
					// console.log(res)
					if(res.response == "ok"){
						jsGoComPage(1,1,'');
						return false;
					}else{
						alert(res.faildesc);
						return false;
					}
				} else {
					alert("잘못된 접근 입니다.1");
					document.location.reload();
					return false;
				}
			},
			error:function(err){
				console.log(err)
				alert("잘못된 접근 입니다2.");
				return false;
			}
		});
    <% End If %>
}

function fnViewDiary(idx, vdiv){
    $.ajax({
        type: "POST",
        url: "/apps/appcom/wish/web2014/event/19th/view_105918.asp",
        data: {
			bbs_idx: idx,
			sortdiv: $("#sortDiv").val(),
			searchtxt: $("#searchTxt").val(),
			viewdiv: vdiv
        },
        success: function(Data){
			$("#viewdiary").empty().html(Data);
			$('#popup_contest').show();
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.')
            //$("#listContainer").empty();
        }
    })
}

function fnGoodStemp(idx){
    <% If Not(IsUserLoginOK) Then %>
        calllogin();
        return false;
	<% else %>
		var data={
			mode: "good",
			bbs_idx: idx
		}
		$.ajax({
			type:"POST",
			url:"/apps/appcom/wish/web2014/event/19th/do105918Proc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				if(res!="") {
					// console.log(res)
					if(res.response == "ok"){
						alert("추천이 완료 되었습니다.");
						$(".btn-stamp").next('.stamp').addClass('on');
						jsGoComPage(1,1,'');
						return false;
					}else{
						alert(res.faildesc);
						return false;
					}
				} else {
					alert("잘못된 접근 입니다.1");
					document.location.reload();
					return false;
				}
			},
			error:function(err){
				console.log(err)
				alert("잘못된 접근 입니다2.");
				return false;
			}
		});
    <% End If %>
}
</script>

			<div class="mEvt105918">
				<div class="topic">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/bg_topic.jpg" alt="">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/tit_diary.png" alt="신박한 일기대회"></h2>
					<span><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_gift_01.png" alt=""></span>
					<span><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_gift_02.png" alt=""></span>
				</div>
				<section class="section-diary">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/txt_intro.png" alt="내용을 입력하세요"></h3>
					<div class="diary-wrap">
						<div class="diary-head">
							<span class="name"><input type="text" name="userName" id="userName" placeholder="입력" maxlength="10"></span>
							<!-- for dev msg : 해당 날짜 --><span class="date"><em><%=month(currentDate)%></em><em><%=day(currentDate)%></em><em><%=WeekKor(weekday(currentDate))%></em></span>
							<span class="weather">
								<em class="w1"><input type="radio" name="weather" id="w1" value="1" checked><label for="w1"></label></em>
								<em class="w2"><input type="radio" name="weather" id="w2" value="2"><label for="w2"></label></em>
								<em class="w3"><input type="radio" name="weather" id="w3" value="3"><label for="w3"></label></em>
								<em class="w4"><input type="radio" name="weather" id="w4" value="4"><label for="w4"></label></em>
							</span>
						</div>
						<div class="diary-pic">
							<div class="swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_01.jpg" alt=""></div>
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_02.jpg" alt=""></div>
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_03.jpg" alt=""></div>
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_04.jpg" alt=""></div>
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_05.jpg" alt=""></div>
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_06.jpg" alt=""></div>
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_07.jpg" alt=""></div>
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_08.jpg" alt=""></div>
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_09.jpg" alt=""></div>
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_10.jpg" alt=""></div>
								</div>
								<div class="fraction"><span class="current">1</span>/<span class="total">10</span></div>
								<div class="swiper-button-prev">이전</div>
								<div class="swiper-button-next">다음</div>
							</div>
						</div>
						<div class="diary-foot">
							<div class="tit"><input type="text" name="txtSubject" id="txtSubject" placeholder="10자 이내로 입력해주세요." maxlength="10"></div>
							<div class="con">
								<!-- for dev msg : 띄어쓰기 포함 80자 이내 -->
								<textarea name="txtComm" id="txtComm" cols="30" rows="10" placeholder="80자 이내로 입력해주세요." maxlength="80"></textarea>
								<button type="submit" class="btn-submit" onclick="eventTry();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/btn_reg.png" alt="입력 완료"></button>
							</div>
						</div>
					</div>
				</section>
				<!-- for dev msg : 내 일기 보기 팝업 -->
				<div id="popup_diary" class="popup popup-diary" style="display:none">
					<button type="button" class="btn-close">닫기</button>
					<div class="inner">
						<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/pop_tit_fin.png?v=1.0" alt="SNS에도 자랑해보세요"></h3>
						<div class="diary-wrap">
							<div class="diary-head">
								<span class="name"><input type="text" name="myName" id="myName" readonly></span>
								<!-- for dev msg : 해당 날짜 --><span class="date"><em><%=month(currentDate)%></em><em><%=day(currentDate)%></em><em><%=WeekKor(weekday(currentDate))%></em></span>
								<span class="weather">
									<em class="w1"><input type="radio" name="myweather" value="1" disabled><label for=""></label></em>
									<em class="w2"><input type="radio" name="myweather" value="2" disabled><label for=""></label></em>
									<em class="w3"><input type="radio" name="myweather" value="3" disabled><label for=""></label></em>
									<em class="w4"><input type="radio" name="myweather" value="4" disabled><label for=""></label></em>
								</span>
							</div>
							<div class="diary-pic"><img src="" id="mypicture"></div>
							<div class="diary-foot">
								<div class="tit"><input type="text" id="mytxtSubject" readonly></div>
								<div class="con">
									<textarea id="mytxtComm" cols="30" rows="10" readonly></textarea>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- for dev msg : 다른 사람의 일기 보기 팝업 -->
				<div id="popup_contest" class="popup popup-contest" style="display:none">
					<button type="button" class="btn-close">닫기</button>
					<div class="inner" id="viewdiary"></div>
				</div>
				<section class="section-contest">
					<% If isArray(arrTOP3List) Then %>
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/tit_best.png" alt="BEST 그림일기"></h3>
					<div class="best-wrap">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<% For intCLoop = 0 To UBound(arrTOP3List,2) %>
								<div class="swiper-slide pic-item">
									<span class="medal medal<% =intCLoop+1 %>"><% =intCLoop+1 %>위</span>
									<a href="" onClick="fnViewDiary(<% =arrTOP3List(0,intCLoop) %>,'best');">
										<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_<% =Format00(2,arrTOP3List(3,intCLoop)) %>.jpg" alt=""></div>
										<div class="desc">
											<div class="tit"><% =arrTOP3List(2,intCLoop) %></div>
											<div class="userid"><% =printUserId(arrTOP3List(1,intCLoop),2,"*") %></div>
											<div class="stamp"><% =FormatNumber(arrTOP3List(4,intCLoop),0) %></div>
										</div>
									</a>
									<% if ((GetLoginUserID = arrTOP3List(1,intCLoop)) or (GetLoginUserID = "10x10")) and (arrTOP3List(1,intCLoop)<>"") then %><button type="button" class="btn-del" onClick="fnDelDiary(<% =arrTOP3List(0,intCLoop) %>);">삭제</button><% end if %>
								</div>
								<% Next %>
							</div>
						</div>
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/txt_guide.png" alt=""></p>
					</div>
					<% end if %>
					<div class="pic-list-wrap">
						<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/tit_contest.png" alt="대회 출품작"></h3>
						<div class="filter">
							<span class="search">
								<input type="text" name="searchTxt" id="searchTxt" placeholder="ID, 제목 검색">
								<button type="button" class="btn-sch" onClick='jsGoComPage(1,$("#sortDiv").val(),$("#searchTxt").val())'></button>
							</span>
							<span class="sort">
								<select name="sortDiv" id="sortDiv" onChange='jsGoComPage(1,this.value,$("#searchTxt").val())'>
									<option value="1">최신순</option>
									<option value="2">인기순</option>
								</select>
							</span>
						</div>
						<div id="diarylist"></div>
					</div>
					<div class="bnr-evt">
						<!-- 인스타그램 이동 링크 -->
						<a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/explore/tags/%EC%8B%A0%EB%B0%95%ED%95%9C%EC%9D%BC%EA%B8%B0%EB%8C%80%ED%9A%8C/');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/bnr_insta.png" alt="인스타그램">
						</a>
						<!-- 다이어리스토리 이동 링크 -->
						<a href="" onclick="fnAPPpopupBrowserURL('다이어리스토리','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2021/');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/bnr_evt_01.png" alt="다이어리스토리 2021">
						</a>
					</div>
				</section>
				<section class="section-notice">
					<h3>유의사항</h3>
					<ul>
						<li>이벤트 당첨 상품은 Apple 아이패드 미니 5세대 WIFI 64G, 히치하이커 무드 다이어리입니다.</li>
						<li>아이패드 미니 당첨자는 '참! 잘했어요 도장'을 가장 많이 받은 BEST 그림일기(1~3위) 유저로 선정되며, 히치하이커 무드 다이어리는 도장 수와 상관 없이 랜덤 추첨을 통해 선정됩니다.</li>
						<li>심한 비속어와 타인을 혐오하는 표현 기재, 매크로 의심 시 삭제 처리될 수 있습니다.</li>
						<li>저장한 그림일기 이미지는 비상업적인 용도에 한해 자유롭게 사용 가능합니다.</li>
						<li>아이패드 당첨자에게는 세무 신고를 위해 개인정보를 요청할 예정이며, 제세공과금은 자사 부담입니다.</li>
						<li>당첨자는 10월 21일(수) 공지사항을 통해 발표 및 개별 연락드릴 예정입니다.</li>
						<li>비정상적인 방법으로 추천을 받은 투표 수는 삭제됩니다.</li>
					</ul>
				</section>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->