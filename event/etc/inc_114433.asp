<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 2021 타임세일 티저
' History : 2021-10-06 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim currentTime '// 현재 시간
dim mktTest '// 테스트 여부
dim LoginUserid : LoginUserid = GetEncLoginUserID()
dim eCode, evtCode
dim currentDate
dim currentType
dim evtDate, ingdate

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "109397"
    evtCode = "109398"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "114433"
    evtCode = "114434"
    mktTest = true    
Else
	eCode = "114433"
    evtCode = "114434"
    mktTest = false
End If

if mktTest then
    '// 테스트용
    if request("setting_time")<>"" then
        currentDate = CDate(request("setting_time"))
    else
        currentDate = CDate("2021-10-11 01:00:00")
    end if
    currentTime = Cdate("01:00:00")
else
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    currentTime = time()    
end if

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

'// 2021년 06월 06일 이후엔 해당 페이지로 접근 하면 실제 이벤트 페이지로 자동으로 redirect 시켜줌
If Left(currentDate,10) >= "2021-10-12" and Left(currentDate,10) < "2021-10-15" Then
    If isApp="1" Then
        response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=" & evtCode
        response.end
    Else
        response.redirect "/event/eventmain.asp?eventid=" & evtCode
        response.end
    End If
End If

evtDate = DateAdd("h",9,Cdate("2021-10-12"))

%>
<style type="text/css">
.teaser-main {position:relative;}
.teaser-main .btn-more {display:block; width:100%; background-color:rgba(0,0,10,0.5);}
.teaser-main .list-wrap a {position:relative; display:inline-block; width:100%; height:100%;}
.teaser-main .txt01 {position:absolute; left:7%; top:11%; width:42.53vw; z-index:10;}
.teaser-main .txt02 {position:absolute; left:32%; top:45.5%; width:44.26vw; z-index:10;}
.teaser-main .show-days {position:absolute; left:6%; top:45.2%; font-size:11.60vw; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.teaser-main .show-days span {font-size:10vw;}
.teaser-main .item-area {position:absolute; right:9%; top:15%; opacity:0.8;}
.teaser-main .item-area .thumb .item1,
.teaser-main .item-area .thumb .item2,
.teaser-main .item-area .thumb .item3,
.teaser-main .item-area .thumb .item4 {width:17.33vw; transition: .5s ease-in;}

.teaser-timer {position:relative;}
.teaser-timer .sale-timer {position:absolute; bottom:49%; left:7%; color:#fff; font-size:4.78rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.teaser-timer .btn-push {width:21.74rem; height:6.08rem; position:absolute; left:3%; bottom:9%; background:transparent;}

.list-wrap {width:32rem; margin:0 auto;}
.list-wrap .special-item a {display:inline-block; position:relative;}
.list-wrap .special-item a:before, 
.teaser .list-wrap a:before {display:inline-block; position:absolute; top:-1.1vw; left:0; z-index:10; width:26%; height:9.84vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/104371/m/badge_spc.png) no-repeat 50% 50%/100%; content:'';}

.lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
.lyr .btn-close {position:absolute; top:2.77rem; right:8%; width:1.92rem; height:1.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_close.png) 50% 50%/100%;}
.lyr-alarm p {padding-top:7.98rem;}
.lyr-alarm .input-box {display:flex; justify-content:space-between; align-items:center; width:70.67%; margin-left:8%; margin-top:5.97rem;}
.lyr-alarm .input-box input {width:100%; height:3rem; padding:0; background-color:transparent; border:0; border-bottom:solid 3px #acfe25; border-radius:0; color:#fff; font-size:1.56rem; text-align:left;}
.lyr-alarm .input-box .btn-submit {width:4.69rem; height:3rem; margin-left:-1px; color:#acfe25; border-bottom:solid 3px #acfe25; font-size:1.47rem; background:transparent;}
.lyr-alarm .input-box input::placeholder {font-size:1.47rem; color:#b7b7b7; text-align:left;}

.product-list {background:#fff;}
.product-list .product-inner {position:relative; margin-left:2.60rem;}
.product-list .product-inner .num-limite {position:absolute; top:-3%; right:0; z-index:10; width:8.78rem; height:2.78rem; padding-left:0.6rem; font-size:1.39rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#fff; text-align:center; line-height:3rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_limit_sold02.png) no-repeat 0 0; background-size:100%; content:'';}
.product-list .product-inner .num-limite em {font-size:1.65rem;}
.product-list .desc .name {position:absolute; left:1.73rem; top:19.5rem; width:90%; overflow:hidden; font-size:1.60rem; line-height:1.2; color:#111; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; white-space:nowrap; text-overflow:ellipsis;}
.product-list .desc .price {display:flex; align-items:baseline; position:absolute; left:1.73rem; top:24rem; font:normal 2.17rem 'CoreSansCBold','NotoSansKRBold'; color:#111;}
.product-list .desc .price s {position:absolute; left:0; top:-1.5rem; font-size:1.51rem; font-family:'CoreSansCLight','NotoSansKRRegular'; color:#888;}
.product-list .desc .price span {display:inline-block; margin-left:1.1rem; color:#ff0943; font-size:2.60rem;}
.product-list .desc .price .p-won {margin-left:0.60rem; font-size:1.30rem; font-weight:500; color:#111; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}

.noti-area{padding-top:15%;background:#fff;}
.noti-area .btn-noti {position:relative;}
.noti-area .btn-noti.on span img {transform:rotate(180deg);}
.noti-area .btn-noti span {display:inline-block; width:1.04rem; height:0.56rem; position:absolute; left:50%; top:4.3rem; transform:translate(590%,0);}
.noti-area .noti-info {display:none;}
.noti-area .noti-info.on {display:block;}
</style>
<script type="text/javascript" src="/event/lib/countdown24.js?v=1.0"></script>
<script type="text/javascript">
countDownTimer("<%=Year(evtDate)%>"
                , "<%=TwoNumber(Month(evtDate))%>"
                , "<%=TwoNumber(Day(evtDate))%>"
                , "<%=TwoNumber(hour(evtDate))%>"
                , "<%=TwoNumber(minute(evtDate))%>"
                , "<%=TwoNumber(Second(evtDate))%>"
                , new Date(<%=Year(currentDate)%>, <%=Month(currentDate)-1%>, <%=Day(currentDate)%>, <%=Hour(currentDate)%>, <%=Minute(currentDate)%>, <%=Second(currentDate)%>)
                );
$(function () {
    // 시간 롤링
    changingImg();
	function changingImg(){
		var i=1;
		var repeat = setInterval(function(){
			i++;
			if(i>10){i=1;}
            $('.teaser-main .item-area .thumb img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_time0'+ i +'.png?v=2').attr('class','item' + i);
            /* if(i == 5) {
                clearInterval(repeat);
            } */
        },1000);
    }
    // 알림받기 팝업
    $('.btn-push').click(function (e) { 
        $('.lyr-alarm').show();
    });
    // 팝업 닫기
    $('.btn-close').click(function (e) {
        $('.lyr').hide();
    });
    //유의사항 버튼
    $('.btn-noti').on("click",function(){
        $('.noti-info').toggleClass("on");
        $(this).toggleClass("on");
    });
});

//maxlength validation in input type number
function maxLengthCheck(object){
    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
    }
}

function fnSendToKakaoMessage() {
    if ($("#phone").val() == '') {
        alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
        $("#phone").focus();
        return;
    }
    var phoneNumber;
    if ($("#phone").val().length > 10) {
        phoneNumber = $("#phone").val().substring(0,3)+ "-" +$("#phone").val().substring(3,7)+ "-" +$("#phone").val().substring(7,11);
    } else {
        phoneNumber = $("#phone").val().substring(0,3)+ "-" +$("#phone").val().substring(3,6)+ "-" +$("#phone").val().substring(6,10);
    }

    $.ajax({
        type:"GET",
        url:"/event/etc/doeventSubscript114433.asp",
        data: "mode=kamsg&phoneNumber="+btoa(phoneNumber),
        <% if mktTest then %>
        testdate: "<%=currentDate%>",
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
                        str = str.replace("undefined","");
                        res = str.split("|");
                        if (res[0]=="OK") {
                            alert('신청이 완료되었습니다.');
                            $("#phone").val('')
                            $('.lyr').hide();
                            return false;
                        }else{
                            errorMsg = res[1].replace(">?n", "\n");
                            alert(errorMsg );
                            return false;
                        }
                    } else {
                        alert("잘못된 접근 입니다.");
                        document.location.reload();
                        return false;
                    }
                }
            }
        },
        error:function(jqXHR, textStatus, errorThrown){
            alert("잘못된 접근 입니다.");					
            return false;
        }
    });
}
</script>
			<div class="mEvt111786">
                <!-- 티저 main -->
                <div class="teaser-main">
                    <div>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/img_teaser_main.jpg?v=2.1" alt="타임세일 티저">
                        <div class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/tit_teaser_txt01.png" alt="이건 기회야"></div>
                        <div class="item-area">
                            <div class="thumb item1"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/time_1.png" alt="item" class="item1"></div>
                        </div>
                    </div>
                </div>
                
                <div class="time-ing">
                    <div class="list-wrap">
                        <div class="product-list">
                            <ul id="list1" class="list list1">
                            <% If currentDate >= #10/11/2021 00:00:00# and currentDate < #10/12/2021 00:00:00# Then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/time_header_01.png" alt="오전 9시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/eventIMG/deal_mTzImage/202110/deal_mTzImage20211005171743.jpg" alt="LG 올레드 OLED TV 55인치">
                                        <span class="num-limite"><em>1</em>개 한정</span>
                                    </div>
                                </li>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/time_header_02.png" alt="오후 12시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/eventIMG/deal_mTzImage/202110/deal_mTzImage20211005171919.jpg" alt="[Peanuts] 스누피 샌드위치/와플메이커 TBT-0002">
                                        <span class="num-limite"><em>30</em>개 한정</span>
                                    </div>
                                </li>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/time_header_03.png" alt="오후 3시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/eventIMG/deal_mTzImage/202110/deal_mTzImage20211005172107.jpg" alt="삼성전자 갤럭시탭S7 FE 12.4 WIFI 128GB 블랙">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/time_header_04.png" alt="오후 6시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/eventIMG/deal_mTzImage/202110/deal_mTzImage20211005172226.jpg" alt="PS5 플레이스테이션5 플스5 디스크에디션">
                                        <span class="num-limite"><em>1</em>개 한정</span>
                                    </div>
                                </li>
                            <% end if %>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- 유의사항 -->
                <div class="noti-area">
                    <button type="button" class="btn-noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/tit_noti.jpg" alt="유의사항 확인하기"><span class="arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/icon_noti_arrow.png" alt=""></span></button>
                    <div class="noti-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/img_noti_info.jpg?v=2" alt="유의사항"></div>
                </div>

                <div class="teaser-timer">
                    <div>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/img_left_time.jpg" alt="타임세일 시작까지">
                        <div class="sale-timer">
                            <div><span>-</span><span id="countdown">00:00:00</span></div>
                        </div>
                        <button type="button" class="btn-push"></button>
                    </div>
                </div>

				<div class="lyr lyr-alarm" style="display:none;">
					<div class="inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/txt_push.png?v=2" alt="기회를 놓치지 않는 가장 확실한 방법"></p>
						<div class="input-box"><input type="number" id="phone" maxlength="11" oninput="maxLengthCheck(this)" placeholder="휴대폰 번호를 입력해주세요"><button type="button" class="btn-submit"  onclick="fnSendToKakaoMessage()">확인</button></div>
						<button class="btn-close"></button>
					</div>
				</div>
                
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->