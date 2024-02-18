<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 19주년 댓글 이벤트
' History : 2020-10-05
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
    Dim currentDate, evtStartDate, evtEndDate, eCode, userid
    Dim eventCoupons, isCouponShow, vQuery
    Dim PresentItemViewFlag
    Dim shinhanEventViewFlag
    Dim jubjubEventViewFlag
    Dim pictureDiaryViewFlag
    Dim watchaEventViewFlag
    Dim kakaoPayEventViewFlag
    Dim tenQuizEventViewFlag
    Dim profitItemEventViewFlag
    Dim giftEventViewFlag
    Dim chaiEventViewFlag
    Dim photoCommentViewFlag
    Dim updownEventViewFlag
    Dim bcCardEventViewFlag
    Dim mileage2222ViewFlag

    currentDate =  date()
    evtStartDate = Cdate("2020-10-05")
    evtEndDate = Cdate("2020-10-29")

    'test
    'currentDate = Cdate("2020-10-05")

    IF application("Svr_Info") = "Dev" THEN
        eCode   =  "103232"
        eventCoupons = "22264,22263,22262,22261,22260,22259,22258"	
    Else
        eCode   =  "106375"
        eventCoupons = "112772,112771,112770,112769,112768,112767,112766"
    End If

    userid = GetEncLoginUserID()

    isCouponShow = True

    If IsUserLoginOK Then
        vQuery = "select count(1) from [db_item].[dbo].[tbl_user_item_coupon] where userid = '" & getencLoginUserid() & "'"
        vQuery = vQuery + " and itemcouponidx in ("&eventCoupons&") "
        vQuery = vQuery + " and usedyn = 'N' "
        rsget.CursorLocation = adUseClient
        rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
        If rsget(0) = 7 Then	' 
            isCouponShow = False
        Else
            isCouponShow = True        
        End IF
        rsget.close    
    End If

%>
<style>
.body-sub .content {padding-bottom:0 !important;}
.contents-comment {position:relative; padding:0 1.70rem 3rem; background:#9435ff;} /* 2020-09-29 수정 */
.comment-list .id {padding-bottom:0.68rem; font-size:1.28rem; color:#fff;}
.comment-list .list-type01,
.comment-list .list-type02 {display:flex; align-items:flex-start; justify-content:flex-start; padding-bottom:2.13rem;}
.comment-list .list-type01 {padding-right:1.40rem;}
.comment-list .list-type02 {padding-left:1.40rem;}
.comment-list .list-type01 .message-container {position:relative; width:23.68rem; padding:1.19rem; background:#79faff; border-radius:1.15rem;}
.comment-list .list-type01 .message-container:before {content:""; position:absolute; left:-0.4rem; top:0; display:block; width:1.36rem; height:1.45rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/icon_corner_01.png) no-repeat 0 0; background-size:100%;}
.comment-list .message-container .num {font-size:1.06rem; color:#666;}
.comment-list .message-container .message {padding:0.93rem 0 1.02rem; font-size:1.28rem; color:#444; line-height:1.62rem; word-break:break-all;}
.comment-list .message-container .date {font-size:1.06rem; color:#ababab; text-align:right;}
.comment-list .message-container .btn-close {position:absolute; right:0.85rem; top:0.85rem; width:1.02rem; height:1.02rem; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/icon_close.png) no-repeat 0 0; background-size:100%;}
.comment-list .list-type01 .img-character {width:2.94rem; height:2.94rem; margin-right:0.55rem;}
.comment-list .list-type02 .img-character {width:2.94rem; height:2.94rem; margin-left:0.55rem;}
.comment-list .list-type01 .img-character img,
.comment-list .list-type02 .img-character img {width:2.94rem; height:2.94rem;}
.comment-list .list-type02 .message-container:before {content:""; position:absolute; right:-0.4rem; top:0; display:block; width:1.36rem; height:1.45rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/icon_corner_02.png) no-repeat 0 0; background-size:100%;}
.comment-list .list-type02 .message-container {position:relative; width:23.68rem; padding:1.19rem; border-radius:1.15rem; background:#fff179;}
.comment-list .list-type02 .id {text-align:right;}
.comment-list li:last-child {padding-bottom:0;}
/* 2020-09-29 추가 */
.message-wrap {display:flex; align-items:flex-start; justify-content:flex-start; margin-bottom:2.34rem;}
.message-wrap .btn-enter {width:calc(100% - 84.4%); height:11rem; font-size:1.45rem; color:#fff; font-weight:bold; background:#222; border-radius:0 1.28rem 1.28rem 0;}
.message-wrap .message-area {width:84.4%; height:11rem; padding:1.76rem; background:#fff; border-radius:1.78rem 0 0 1.78rem;}
.message-wrap .message-area textarea {width:100%; height:7.68rem; padding:0; resize:none; border:0; font-size:1.28rem; color:#444;}
.message-wrap .message-area textarea::placeholder {font-size:1.36rem; color:#888;}
/* 2020-09-29 추가 */
.contents-info-section02 .coupon-area {position:relative;}
.contents-info-section02 .coupon-area button {width:20.43rem; height:4.69rem; position: absolute; left:50%; bottom:0; background:transparent; transform:translateX(-50%); background:transparent; animation: shake .6s ease-in-out alternate infinite;}
@keyframes shake {
	0% {left:48%;}
	100% {left:52%}
}
.contents-info-section02 .event-area {position:relative;}
.contents-info-section02 .event-area ul {padding-bottom:3.11rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/bg_v2_line_yellow.png) repeat 0 0; }/* 2020-10-05 수정 */
.contents-info-section02 .event-area ul li {width:28.58rem; height:17.06rem; margin:0 auto;} /* 2020-10-05 추가 */
/* .contents-info-section02 .event-area ul li:nth-child(1) {width:28.58rem; height:15.35rem;}
.contents-info-section02 .event-area ul li:nth-child(2) {width:28.58rem; height:15.91rem; margin-top:1.19rem;}
.contents-info-section02 .event-area ul li:nth-child(3) {width:28.58rem; height:15.78rem; margin-top:1.19rem;}
.contents-info-section02 .event-area ul li:nth-child(4) {width:28.58rem; height:16.04rem; margin-top:0.98rem;} */ /* 2020-10-05 삭제 */
.contents-info-section02 .event-area ul li a {display:inline-block;}
.contents-info-section03 .view-count {position:relative;}
.contents-info-section03 .view-count .btn-view,
.contents-info-section03 .view-product .btn-view {position:absolute; left:50%; bottom:6.35rem; transform:translateX(-50%); width:20.43rem; height:4.69rem;} 
.contents-info-section03 .view-count .memberCountCon {position:absolute; left:50%; bottom:22.09rem; transform:translateX(-50%); font-size:4.69rem; font-weight:bold; color:#fff; word-break:keep-all;}
.contents-info-section03 .view-product {position:relative;}
.contents-info-section03 .view-product .btn-view {top:40.53rem;}

.contents-info-section03 .list-wrap {position:absolute; left:50%; top:10.67rem; transform:translateX(-50%);}
.contents-info-section03 .list-wrap.second {top:17.93rem;}
.contents-info-section03 .list-wrap.third {top:28.39rem;}

.contents-info-section03 .list-wrap .list-product {position:relative; width:27rem;}
.contents-info-section03 .list-wrap .list-product li {opacity:0; transform-origin:center center;}
/* 2020-10-05 수정 */
.contents-info-section03 .list-wrap .list-product li a {display:inline-block; width:100%; height:100%;}
.contents-info-section03 .list-wrap.show .list-product li.list-01 {animation: product 0.4s cubic-bezier(.97,.18,.15,.52); opacity:1;}
.contents-info-section03 .list-wrap.show .list-product li.list-02 {animation: product 1.4s cubic-bezier(.97,.18,.15,.52); opacity:1;}
.contents-info-section03 .list-wrap.show .list-product li.list-03 {animation: product 0.8s cubic-bezier(.97,.18,.15,.52); opacity:1;}
.contents-info-section03 .list-wrap.show .list-product li.list-04 {animation: product 2.4s cubic-bezier(.97,.18,.15,.52); opacity:1;}

.contents-info-section03 .list-wrap.second.show .list-product li.list-01 {animation: product 1.2s cubic-bezier(.97,.18,.15,.52); opacity:1;}
.contents-info-section03 .list-wrap.second.show .list-product li.list-02 {animation: product 0.6s cubic-bezier(.97,.18,.15,.52); opacity:1;}
.contents-info-section03 .list-wrap.second.show .list-product li.list-03 {animation: product 2s cubic-bezier(.97,.18,.15,.52); opacity:1;}
.contents-info-section03 .list-wrap.second.show .list-product li.list-04 {animation: product 1.8s cubic-bezier(.97,.18,.15,.52); opacity:1;}

.contents-info-section03 .list-wrap.third.show .list-product li.list-01 {animation: product 1.6s cubic-bezier(.97,.18,.15,.52); opacity:1;}
.contents-info-section03 .list-wrap.third.show .list-product li.list-02 {animation: product 2.2s cubic-bezier(.97,.18,.15,.52); opacity:1;}
.contents-info-section03 .list-wrap.third.show .list-product li.list-03 {animation: product 1s cubic-bezier(.97,.18,.15,.52); opacity:1;}
.contents-info-section03 .list-wrap.third.show .list-product li.list-04 {animation: product 2.6s cubic-bezier(.97,.18,.15,.52); opacity:1;}

.contents-info-section03 .list-wrap .list-product li.list-01 {width:5.20rem; height:5.20rem; position:absolute; left:0; top:0;}
.contents-info-section03 .list-wrap .list-product li.list-02 {width:5.84rem; height:4.56rem; position:absolute; left:6.84rem; top:0.5rem;}
.contents-info-section03 .list-wrap .list-product li.list-03 {width:6.44rem; height:5.33rem; position:absolute; left:15.44rem; top:0;}
.contents-info-section03 .list-wrap .list-product li.list-04 {width:1.02rem; height:5.84rem; position:absolute; left:23.90rem; top:0;}
.contents-info-section03 .list-wrap.second .list-product li.list-01 {width:5.58rem; height:7.59rem; position:absolute; left:0; top:0;}
.contents-info-section03 .list-wrap.second .list-product li.list-02 {width:2.64rem; height:6.22rem; position:absolute; left:8rem; top:0.7rem;}
.contents-info-section03 .list-wrap.second .list-product li.list-03 {width:4.86rem; height:6.14rem; position:absolute; left:15rem; top:0.7rem;}
.contents-info-section03 .list-wrap.second .list-product li.list-04 {width:6.14rem; height:4.52rem; position:absolute; left:21rem; top:1.4rem;}
.contents-info-section03 .list-wrap.third .list-product li.list-01 {width:4.90rem; height:6.95rem; position:absolute; left:0; top:0;}
.contents-info-section03 .list-wrap.third .list-product li.list-02 {width:6.48rem; height:5.07rem; position:absolute; left:6.84rem; top:0.9rem;}
.contents-info-section03 .list-wrap.third .list-product li.list-03 {width:4.43rem; height:5.80rem; position:absolute; left:15.44rem; top:0.9rem;}
.contents-info-section03 .list-wrap.third .list-product li.list-04 {width:3.62rem; height:6.86rem; position:absolute; left:22rem; top:0;}
/* //2020-10-05 수정 */
@keyframes product {
	0% {opacity:0;}
	89% {transform:scale(1);}
	90% {transform:scale(1.2);}
	100% {opacity:1; transform:scale(1);}
}
.pop-container.show {display:block;}
.pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgb(255, 255, 255); opacity:0.949; z-index:150;}
.pop-container .pop-inner {position:relative; width:28.58rem; height:37.63rem; margin:3.75rem auto;}
.pop-container .pop-inner .btn-coupon {position:absolute; left:50%; top:24.5rem; width:18.68rem; height:4.26rem; transform:translateX(-50%);}
.pop-container .pop-inner .btn-close {position:absolute; right:1rem; top:1rem; width:1.70rem; height:1.70rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/icon_close02.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;} 
/* 2020-10-13 추가 */
.anniv19th .topic {position:relative;}
.anniv19th .topic .tit-area {width:24.57rem; text-align:center; overflow:hidden; position:absolute; left:44%; top:39%; transform:translate(-46%, -39%);}
.anniv19th .topic .tit-area .txt-01 {width:19.48rem; padding-bottom:1.30rem; float:left;}
.anniv19th .topic .tit-area .txt-02 {width:21.43rem; height:10.13rem;}
.anniv19th .topic .tit-area .txt-03 {width:19.07rem; height:10.13rem; animation:txt 1s ease-in; opacity:1;}
.anniv19th .topic .character-area div {display:flex; align-items:center; position:absolute; top:50%; left:50%; width:40vw; height:40vw; margin:-15vw 0 0 -15vw; animation-duration:3s; animation-timing-function:ease; animation-fill-mode:both;}
.anniv19th .topic .character-area div img {animation-duration:3s; animation-timing-function:steps(5); animation-fill-mode:both;}
.anniv19th .topic .character-area div:nth-of-type(odd) img {animation-name: tremble1;}
.anniv19th .topic .character-area div:nth-of-type(even) img {animation-name: tremble2;}
.anniv19th .topic .character-area .c1 {transform:translate(-19vw, -89vw); animation-name:c1;}
.anniv19th .topic .character-area .c2 {transform:translate(-38vw, -83vw); animation-name:c2;}
.anniv19th .topic .character-area .c3 {transform:translate(-31vw, -75vw); animation-name:c3;}
.anniv19th .topic .character-area .c4 {transform:translate(-44vw, -38vw); animation-name:c4;}
.anniv19th .topic .character-area .c5 {transform:translate(-43vw, 14vw); animation-name:c5;}
.anniv19th .topic .character-area .c6 {transform:translate(-41vw, 40vw); animation-name:c6;}
.anniv19th .topic .character-area .c7 {transform:translate(-40vw, 70vw); animation-name:c7;}
.anniv19th .topic .character-area .c8 {transform:translate(-25vw, 73vw); animation-name:c8;}
.anniv19th .topic .character-area .c9 {transform:translate(-25vw, 93vw); animation-name:c9;}
.anniv19th .topic .character-area .c10 {transform:translate(4vw, 97vw); animation-name:c10;}
.anniv19th .topic .character-area .c11 {transform:translate(16vw, 90vw); animation-name:c11;}
.anniv19th .topic .character-area .c12 {transform:translate(28vw, 98vw); animation-name:c12;}
.anniv19th .topic .character-area .c13 {transform:translate(52vw, 62vw); animation-name:c13;}
.anniv19th .topic .character-area .c14 {transform:translate(56vw, 23vw); animation-name:c14;}
.anniv19th .topic .character-area .c15 {transform:translate(57vw, -15vw); animation-name:c15;}
.anniv19th .topic .character-area .c16 {transform:translate(53vw, -47vw); animation-name:c16;}
.anniv19th .topic .character-area .c17 {transform:translate(53vw, -65vw); animation-name:c17;}
.anniv19th .topic .character-area .c18 {transform:translate(41vw, -73vw); animation-name:c18;}
.anniv19th .topic .character-area .c19 {transform:translate(41vw, -86vw); animation-name:c19;}
.anniv19th .topic .character-area .c20 {transform:translate(53vw, -86vw); animation-name:c20;}
.anniv19th .topic .character-area .c21 {transform:translate(8vw, -86vw); animation-name:c21;}
@keyframes c1 {
	0% {transform:translate(-30vw, -101vw);}
	100% {transform:translate(-25vw, -94vw);}
}
@keyframes c2 {
	0% {transform:translate(-49vw, -95vw);}
	100% {transform:translate(-43vw, -85vw);}
}
@keyframes c3 {
	0% {transform:translate(-43vw, -83vw);}
	100% {transform:translate(-27vw, -68vw);}
}
@keyframes c4 {
	0% {transform:translate(-55vw, -52vw);}
	100% {transform:translate(-50vw, -57vw);}
}
@keyframes c5 {
	0% {transform:translate(-55vw, 2vw);}
	100% {transform:translate(-50vw, -7vw);}
}
@keyframes c6 {
	0% {transform:translate(-51vw, 35vw);}
	100% {transform:translate(-38vw, 26vw);}
}
@keyframes c7 {
	0% {transform:translate(-56vw, 66vw);}
	100% {transform:translate(-46vw, 56vw);}
}
@keyframes c8 {
	0% {transform:translate(-39vw, 68vw);}
	100% {transform:translate(-18vw, 40vw);}
}
@keyframes c9 {
	0% {transform:translate(-31vw, 86vw);}
	100% {transform:translate(-31vw, 78vw);}
}
@keyframes c10 {
	0% {transform:translate(-3vw, 85vw);}
	100% {transform:translate(-1vw, 65vw);}
}
@keyframes c11 {
	0% {transform:translate(14vw, 80vw);}
	100% {transform:translate(11vw, 37vw);}
}
@keyframes c12 {
	0% {transform:translate(29vw, 86vw);}
	100% {transform:translate(21vw, 76vw);}
}
@keyframes c13 {
	0% {transform:translate(41vw, 54vw);}
	100% {transform:translate(33vw, 47vw);}
}
@keyframes c14 {
	0% {transform:translate(46vw, 16vw);}
	100% {transform:translate(32vw, 11vw);}
}
@keyframes c15 {
	0% {transform:translate(48vw, -24vw);}
	100% {transform:translate(40vw, -17vw);}
}
@keyframes c16 {
	0% {transform:translate(43vw, -56vw);}
	100% {transform:translate(28vw, -47vw);}
}
@keyframes c17 {
	0% {transform:translate(42vw, -79vw);}
	100% {transform:translate(32vw, -73vw);}
}
@keyframes c18 {
	0% {transform:translate(20vw, -87vw);}
	100% {transform:translate(4vw, -60vw);}
}
@keyframes c19 {
	0% {transform:translate(23vw, -101vw);}
	100% {transform:translate(19vw, -96vw);}
}
@keyframes c20 {
	0% {transform:translate(35vw, -101vw);}
	100% {transform:translate(31vw, -97vw);}
}
@keyframes c21 {
	0% {transform:translate(-1vw, -97vw);}
	100% {transform:translate(-1vw, -85vw);}
}
@keyframes tremble1 {
	0%, 50%, 100% {
		transform: rotate(.03turn);
	}
	25%, 75% {
		transform: none;
	}
}
@keyframes tremble2 {
	0%, 50%, 100% {
		transform: rotate(-.03turn);
	}
	25%, 75% {
		transform: none;
	}
}
@keyframes txt {
	0% {opacity:0;}
	100% {opacity:1;}
}
</style>
<script>
    var vScrl=true;
    $(document).ready(function() {
		$(window).scroll(function () {
            if ($(window).scrollTop() >= ($(document).height()-$(window).height())-100) {
                if(vScrl) {
                    vScrl = false;
                    $("#currentPage").val(parseInt($("#currentPage").val())+1);
                    get19thCommentList();
                }            
            }            
        });

        // 숫자 롤링 event
		var fired = false;
		var memberCountConTxt= 7643;
		
		window.addEventListener("scroll", function(){
			var sc_top = $(this).scrollTop() +500;
			var top_roll = $(".contents-info-section03").offset().top;
			var wrap = $(".list-wrap");
			var wrap02 = $(".list-wrap.second");
			var wrap03 = $(".list-wrap.third");

			if (sc_top > top_roll && fired === false) {
				$({ val : 0 }).animate({ val : memberCountConTxt }, {
						duration: 2000,
						step: function() {
							var num = numberWithCommas(Math.floor(this.val));
							$(".memberCountCon").text(num+'개');
						},
						complete: function() {
							var num = numberWithCommas(Math.floor(this.val));
							$(".memberCountCon").text(num+'개');
						}
					});
					function numberWithCommas(x) {
							return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					}
					wrap.addClass("show");
					wrap02.addClass("show");
					wrap03.addClass("show");
				fired = true;
			} 
        }, true)        
		$(".pop-container .btn-close").on("click",function(){
			$(".pop-container").removeClass("show");
		});
        // 상단 배너 title 문구 호출
		setTimeout(function() {
			$(".txt-02").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_tit_txt03.png?v=2.00");
			$(".txt-02").attr("class","txt-03");
		}, 2500);        
    });

    $(function() {
        get19thCommentList();
    });

    function jsSubmitComment(mode, idx){
        <% if not ( currentDate >= evtStartDate and currentDate <= evtEndDate ) then %>
            alert("이벤트 참여기간이 아닙니다.");
            return false;
        <% end if %>
        if(!chkLogin()) return false;
        if(mode == 'add'){if(!validate()) return false;}
        if(mode == 'del'){if(!confirm('삭제 하시겠습니까?')) return false;}

        var payLoad = {
            mode: mode,
            eventCode: '<%=eCode%>',
            inputCommentData: $("#txtContent").val(),
            idx: idx
        }
        $.ajax({
            type: "post",
            url: "/event/19th/act_comment.asp",
            data: payLoad,
            success: function(data){
                var res = data.split("|")
                if(res[0] == "ok"){
                    if(mode == 'add'){alert("감사합니다.\n축하메시지가 등록되었습니다.");$("#txtContent").val("");}
                    if(mode == 'del'){alert("축하메시지가 삭제되었습니다.");}
                    $("#currentPage").val(1);
                    get19thCommentList();
                    $('html, body').animate({scrollTop : $(".contents-comment").offset().top}, 100);
                }else if(res[0] == "Err") {
                    alert(res[1])
                }
                // console.log(data, mode)
            },
            error: function(e){
                console.log(e)
            }
        });
    }

    function chkLogin(){
        <% If not IsUserLoginOK() Then %>
            <% if isApp=1 then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/19th/index.asp")%>');
                return false;
            <% end if %>
        <% end if %>
        return true
    }

    function validate(){
        var chkRes;
        if($("#txtContent").val() == ''){
            alert('댓글을 적어주세요.');
            $("#txtContent").focus();
            chkRes = false
            return false;
        }
        if(GetByteLength($("#txtContent").val()) > 200){
            alert('한글 100자 까지 작성 가능합니다.');
            $("#txtContent").focus();
            chkRes = false
            return false;
        }
        chkRes = true
        return chkRes
    }

    function get19thCommentList() {
        var payLoad = {
            mode: "getlist",
            eventCode: '<%=eCode%>',
            currentPage: $("#currentPage").val()
        }
        $.ajax({
            type:"GET",
            url:"/event/19th/act_comment.asp",
            data: payLoad,
            success: function(data){
                if(data!="") {
                    if($("#currentPage").val()==1) {
                        $("#commentList").empty().html(data);
                        vScrl=true;
                    } else {
                        setTimeout(() => {
                            $('#commentList').append(data);
                            vScrl=true;
                        }, 10);
                    }
                } else {
                    //alert("잘못된 접근 입니다.");
                    //document.location.reload();
                    return false;
                }
            },
            error: function(e){
                console.log(e)
            }
        });
    }

    function jsDownCoupon(stype,idx){
        <% if not ( currentDate >= evtStartDate and currentDate <= evtEndDate ) then %>
            alert("이벤트 참여기간이 아닙니다.");
            return false;
        <% end if %>
        if(!chkLogin()) return false;
        $.ajax({
            type: "post",
            url: "/shoppingtoday/act_couponshop_process.asp",
            data: "idx="+idx+"&stype="+stype,
            cache: false,
            success: function(message) {
                if(typeof(message)=="object") {
                    if(message.response=="Ok") {
                        setTimeout(function(){$('.coupon-area').fadeOut();}, 100);					
                        $(".pop-container").addClass("show");
                    } else {
                        alert(message.message);
                    }
                } else {
                    alert("처리중 오류가 발생했습니다.");
                }
            },
            error: function(err) {
                console.log(err.responseText);
            }
        });
    }
</script>
<%'<!-- //MKT 19주년 메인 (M/A) -->%>
<div class="anniv19th">
    <div class="topic">
        <% if currentdate < "2020-10-12" then %>
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_tit_m.gif?v=1.01" alt="19주년 생일파티 올해 마지막 Big Sale">
        <% Else %>
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_tit_top.jpg" alt="19주년 생일파티 올해 마지막 Big Sale">
        <div class="tit-area">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_tit_txt01.png" alt="19주년 생일파티" class="txt-01">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_tit_txt02.png" alt="텐바이텐의 생일을 축하해주기위해 우리가 왔다." class="txt-02">
        </div>
        <div class="character-area">
            <div class="c1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_19.png?v=2.00" alt="캐릭터 01"></div>
            <div class="c2"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_05.png?v=2.00" alt="캐릭터 02"></div>
            <div class="c3"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_01.png?v=2.00" alt="캐릭터 03"></div>
            <div class="c4"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_10.png?v=2.00" alt="캐릭터 04"></div>
            <div class="c5"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_13.png?v=2.00" alt="캐릭터 05"></div>
            <div class="c6"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_02.png?v=2.00" alt="캐릭터 06"></div>
            <div class="c7"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_12.png?v=2.00" alt="캐릭터 07"></div>
            <div class="c8"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_21.png?v=2.00" alt="캐릭터 08"></div>
            <div class="c9"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_16.png?v=2.00" alt="캐릭터 09"></div>
            <div class="c10"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_17.png?v=2.00" alt="캐릭터 10"></div>
            <div class="c11"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_11.png?v=2.00" alt="캐릭터 11"></div>
            <div class="c12"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_04.png?v=2.00" alt="캐릭터 12"></div>
            <div class="c13"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_15.png?v=2.00" alt="캐릭터 13"></div>
            <div class="c14"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_09.png?v=2.00" alt="캐릭터 14"></div>
            <div class="c15"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_18.png?v=2.00" alt="캐릭터 15"></div>
            <div class="c16"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_03.png?v=2.00" alt="캐릭터 16"></div>
            <div class="c17"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_14.png?v=2.00" alt="캐릭터 17"></div>
            <div class="c18"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_20.png?v=2.00" alt="캐릭터 18"></div>
            <div class="c19"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_06.png?v=2.00" alt="캐릭터 19"></div>
            <div class="c20"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_07.png?v=2.00" alt="캐릭터 20"></div>
            <div class="c21"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_character_08.png?v=2.00" alt="캐릭터 21"></div>
        </div>
        <% End If %>
    </div>
    <div class="contents-info-section02">
        <% If isCouponShow Then %>
            <div class="coupon-area">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_event_coupon01.jpg" alt="19주년 쿠폰팩 최대50%">
                <%' <!-- for dev msg : 쿠폰 다운 --> %>
                <button type="button" class="btn-coupon-down" onclick="jsDownCoupon('prd,prd,prd,prd,prd,prd,prd','<%=eventCoupons%>');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_btn_coupon01.png" alt="쿠폰받기"></button>
            </div>
        <% End If %>
        <div class="event-area">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_event_coupon02.jpg" alt="혜택 보고 가면 안 잡아먹지">
            <%' <!-- for dev msg : 혜택 배너 --> %>
            <ul>
                <% If isApp="1" Then %>
                    <!-- #include virtual="/event/19th/inc_19thbanner_App.asp" -->
                <% Else %>
                    <!-- #include virtual="/event/19th/inc_19thbanner.asp" -->
                <% End If %>
            </ul>
        </div>
    </div>
    <div class="contents-info-section03">
        <div class="view-product">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_event_coupon04.jpg" alt="지금 769,762개 상품 할인 중">
            <!-- 2020-10-05 수정 -->
            <div class="list-wrap">
                <ul class="list-product">
                    <li class="list-01"><a href="/category/category_itemprd.asp?itemid=3171639" onclick="TnGotoProduct('3171639');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_01.png" alt="상품 icon"></a></li>
                    <li class="list-02"><a href="/category/category_itemprd.asp?itemid=2964071" onclick="TnGotoProduct('2964071');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_02.png" alt="상품 icon"></a></li>
                    <li class="list-03"><a href="/category/category_itemprd.asp?itemid=2785591" onclick="TnGotoProduct('2785591');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_03.png" alt="상품 icon"></a></li>
                    <li class="list-04"><a href="/category/category_itemprd.asp?itemid=3069797" onclick="TnGotoProduct('3069797');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_04.png" alt="상품 icon"></a></li>
                </ul>
            </div>
            <div class="list-wrap second">
                <ul class="list-product">
                    <li class="list-01"><a href="/category/category_itemprd.asp?itemid=1887286" onclick="TnGotoProduct('1887286');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_05.png" alt="상품 icon"></a></li>
                    <li class="list-02"><a href="/category/category_itemprd.asp?itemid=2722020" onclick="TnGotoProduct('2722020');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_06.png" alt="상품 icon"></a></li>
                    <li class="list-03"><a href="/category/category_itemprd.asp?itemid=3217278" onclick="TnGotoProduct('3217278');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_07.png" alt="상품 icon"></a></li>
                    <li class="list-04"><a href="/category/category_itemprd.asp?itemid=3019218" onclick="TnGotoProduct('3019218');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_08.png" alt="상품 icon"></a></li>
                </ul>
            </div>
            <div class="list-wrap third">
                <ul class="list-product">
                    <li class="list-01"><a href="/category/category_itemprd.asp?itemid=2953002" onclick="TnGotoProduct('2953002');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_09.png" alt="상품 icon"></a></li>
                    <li class="list-02"><a href="/category/category_itemprd.asp?itemid=3136367" onclick="TnGotoProduct('3136367');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_10.png" alt="상품 icon"></a></li>
                    <li class="list-03"><a href="/category/category_itemprd.asp?itemid=3095413" onclick="TnGotoProduct('3095413');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_11.png" alt="상품 icon"></a></li>
                    <li class="list-04"><a href="/category/category_itemprd.asp?itemid=3144060" onclick="TnGotoProduct('3144060');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_product_12.png" alt="상품 icon"></a></li>
                </ul>
            </div>
            <!-- //2020-10-05 수정 -->
                <a href="http://m.10x10.co.kr/shoppingtoday/shoppingchance_saleitem.asp" target="_blank" class="mWeb btn-view"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_btn_coupon06.png" alt="자세히 보러가기"></a>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/sale/saleitem.asp','right','','sc');return false;" class="mApp btn-view"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_btn_coupon06.png" alt="자세히 보러가기"></a>
        </div>
        <div class="view-count">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_event_coupon03.jpg" alt="지금 할인 중인 브랜드 769,762개 최대 할인 50%">
            <div class="memberCountCon"></div>
                <a href="/event/eventmain.asp?eventid=106390" target="_blank" class="mWeb btn-view"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_btn_coupon06.png" alt="자세히 보러가기"></a>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106390','right','','vc');return false;" class="mApp btn-view"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_btn_coupon06.png" alt="자세히 보러가기"></a>
        </div>
    </div>
    <div class="contents-info">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_v2_event_info.jpg" alt="comment event 19살이 된 텐바이텐의 생일을 축하해주세요. 정성껏 축하 메시지를 남겨주신 10분을 추첨하여 기프트카드 10,000원 권을 드립니다. 기간 : 10월 5일 ~ 10월 29일 당첨자 발표 : 11월 3일">
    </div>
    <div class="contents-comment">
        <div class="message-wrap">
            <div class="message-area"><textarea id="txtContent" name="txtContent" onclick="chkLogin()" placeholder="축하 메시지를 남겨주세요:)&#10;(100자 이내로 입력)" maxlength="100"></textarea></div>
            <button type="button" onclick="jsSubmitComment('add')" class="btn-enter">등록</button>
        </div>
        <ul class="comment-list" id="commentList">
        </ul>
        <!--<div class="message-wrap">
            <div class="message-area">
                <div class="txt-area">
                    <textarea id="txtContent" name="txtContent" onclick="chkLogin()" placeholder="축하 메시지를 남겨주세요:)&#10;(100자 이내로 입력)"></textarea>
                </div>
                <div class="btn-area">
                    <button type="button" onclick="jsSubmitComment('add')">등록</button>
                </div>
            </div>
        </div>-->
    </div>
    <%' <!-- for dev msg : 쿠폰팩 팝업 --> %>
    <div class="pop-container">
        <div class="pop-inner">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_pop_coupon.png" alt="쿠폰팩이 발급되었습니다. 최대 50% 쿠폰은 10월 29일까지 사용 할 수 있으며 사용 후 다시 발급받을 수 있습니다.">
            <a href="/my10x10/couponbook.asp?tab=3" class="mWeb btn-coupon"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_btn_coupon07.png" alt="쿠폰함으로 가기"></a>
            <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp?tab=3'); return false;" class="mApp btn-coupon"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/index/m/img_btn_coupon07.png" alt="쿠폰함으로 가기"></a>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>    
    <input type="hidden" name="currentPage" id="currentPage" value="1">
</div>
<%'<!-- //MKT 19주년 메인 (M/A) -->%>
<!-- #include virtual="/lib/db/dbclose.asp" -->