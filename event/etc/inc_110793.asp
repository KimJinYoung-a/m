<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 오늘도 달콤한 텐몽카페!
' History : 2021.04.23 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim currentDate, eventStartDate, eventEndDate
dim eCode, userid, mktTest, subscriptcount, sqlstr, myTeaSet

IF application("Svr_Info") = "Dev" THEN
	eCode = "105351"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "110793"
    mktTest = true    
Else
	eCode = "110793"
    mktTest = false
End If

if mktTest then
    currentDate = #04/28/2021 09:00:00#
else
    currentDate = date()
end if

eventStartDate = cdate("2021-04-28")		'이벤트 시작일
eventEndDate = cdate("2021-05-11")		'이벤트 종료일

userid = GetEncLoginUserID()

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currentDate,10), 2, "")
	sqlstr = "select top 1 sub_opt2"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& userid &"'"
    sqlstr = sqlstr & " and sub_opt1='"& left(currentDate,10) &"'"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		myTeaSet = rsget("sub_opt2")
	END IF
	rsget.close
end if
%>
<style>
.mEvt110793 {background:#fff;}
.mEvt110793 .topic {position:relative;}
.mEvt110793 .topic h2 {width:42.26vw; position:absolute; left:50%; top:9%; margin-left:-21.13vw; transform: translateY(1rem); transition:all 1s; opacity:0;}
.mEvt110793 .topic h2.on {transform: translateY(0); opacity:1;}
.mEvt110793 .topic p {width:69.06vw; position:absolute; left:50%; top:15%; margin-left:-34.53vw; transform: translateY(1rem); transition:all 1s .3s; opacity:0;}
.mEvt110793 .topic p.on {transform: translateY(0); opacity:1;}
.mEvt110793 .section-01 {position:relative;}
.mEvt110793 .section-01 .item-01 {width:22.13vw; position:absolute; left:63%; top:21%; animation: circle 2.5s linear infinite;}
.mEvt110793 .section-01 .item-02 {width:19.20vw; position:absolute; left:7%; top:45%; animation: circle 2s linear infinite reverse;}
.mEvt110793 .section-01 .item-03 {width:22.13vw; position:absolute; left:76%; top:67%; animation: circle 1.8s linear infinite;}
.mEvt110793 .section-02 {position:relative;}
.mEvt110793 .section-02 .event-sec {position:relative;}
.mEvt110793 .section-02 .event-sec .item-04 {width:26.40vw; position:absolute; right:5%; top:-5%; animation: updown 1s ease-in-out infinite alternate;}
.mEvt110793 .section-02 .event-sec .item-kit01 {width:31.60vw; position:absolute; left:13%; top:14%; opacity:0; transform:translateY(1.5rem); transition: all 1s;}
.mEvt110793 .section-02 .event-sec .item-kit01.on {opacity:1; transform:translateY(0);}
.mEvt110793 .section-02 .event-sec .item-kit02 {width:31.60vw; position:absolute; left:57%; top:14%; opacity:0; transform:translateY(1.5rem); transition: all 1s;}
.mEvt110793 .section-02 .event-sec .item-kit02.on {opacity:1; transform:translateY(0);}
.mEvt110793 .section-02 .event-sec .btn-grp {width:100%; position:absolute; left:0; top:56%;}
.mEvt110793 .section-02 .event-sec .btn-grp button {position:relative; display:inline-block; width:100%; height:6rem; margin-bottom:1rem; background:transparent; -webkit-tap-highlight-color:transparent;}
.mEvt110793 .section-02 .event-sec .btn-grp button::before {content:""; position:absolute; left:16%; top:32%; display:inline-block; width:10vw; height:9.60vw; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110793/m/icon_check.png) no-repeat 0 0; background-size:100%; opacity:0;}
.mEvt110793 .section-02 .event-sec .btn-grp button.on::before {opacity:1;}
.mEvt110793 .section-02 .event-sec .btn-grp button:nth-child(2):before {left:16%; top:22%;}
.mEvt110793 .section-02 .event-sec .btn-grp button:nth-child(3):before {left:16%; top:12%;}
.mEvt110793 .section-02 .event-sec .btn-apply {width:100%; height:9rem; position:absolute; left:0; bottom:8%; background:transparent;}
.mEvt110793 .section-02 .event-sec .icon-click {width:16vw; position:absolute; right:16%; bottom:16.5%; animation: updown 1s ease-in-out infinite alternate;}
.mEvt110793 .section-03,
.mEvt110793 .section-03 .time-select {position:relative;}
.mEvt110793 .section-03 .time-select,
.mEvt110793 .section-03 .time-more {display:none;}
.mEvt110793 .section-03 .time-more.on {display:block;}
.mEvt110793 .section-03 .time-select .user-name {position:absolute; left:50%; top:24.5%; transform: translate(-79%,0); font-size:2.34rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt110793 .section-03 .btn-look {display:inline-block; width:100%; height:9rem; position:absolute; left:0; top:81%; background:transparent; -webkit-tap-highlight-color:transparent;}
.mEvt110793 .section-03 .btn-look .icon-arrow {display:inline-block; width:4.40vw; height:2.66vw; position:absolute; right:20%; top:41%;}
.mEvt110793 .section-03 .btn-look .icon-arrow.on {transform: rotate(180deg);}
.mEvt110793 .section-04 {position:relative;}
.mEvt110793 .section-04 .icon-mong {width:21.86vw; position:absolute; left:50%; top:-7%; transform: translate(-50%,0);}
.mEvt110793 .section-05 .event-sec {position:relative;}
.mEvt110793 .section-05 .event-sec .item-01 {width:26.40vw; position:absolute; right:5%; top:26%; animation: updown 1s ease-in-out infinite alternate;}
.mEvt110793 .section-05 .event-sec .item-kit01 {width:70.93vw; position:absolute; left:16%; top:34%; opacity:0; transform:translateY(1.5rem); transition: all 1s;}
.mEvt110793 .section-05 .event-sec .item-kit01.on {opacity:1; transform:translateY(0);}
.mEvt110793 .section-05 .event-sec .item-kit02 {width:69.06vw; position:absolute; left:15%; top:72%; opacity:0; transform:translateY(1.5rem); transition: all 1s;}
.mEvt110793 .section-05 .event-sec .item-kit02.on {opacity:1; transform:translateY(0);}
.mEvt110793 .section-05 .event-sec .btn-goprd {width:100%; height:5rem; position:absolute; left:0; top:63%; background:transparent;}
.mEvt110793 .section-06 .event-sec {position:relative;}
.mEvt110793 .section-06 .event-sec .item-01 {width:26.40vw; position:absolute; right:5%; top:56%; animation: updown 1s ease-in-out infinite alternate;}
.mEvt110793 .section-06 .event-sec .item-kit01 {width:32.53vw; position:absolute; left:11%; top:68%; opacity:0; transform:translateY(1.5rem); transition: all 1s;}
.mEvt110793 .section-06 .event-sec .item-kit01.on {opacity:1; transform:translateY(0);}
.mEvt110793 .section-06 .event-sec .item-kit02 {width:31.86vw; position:absolute; left:57%; top:68%; opacity:0; transform:translateY(1.5rem); transition: all 1s;}
.mEvt110793 .section-06 .event-sec .item-kit02.on {opacity:1; transform:translateY(0);}
@keyframes updown {
    0% {transform: translateY(.5rem);}
    100% {transform: translateY(-.5rem);}
}
@keyframes circle {
    0% {transform:rotate(0);}
    100% {transform:rotate(360deg);}
}
</style>
<script>
$(function(){
    $('.topic h2,.topic p').addClass('on');
    /* 글자,이미지 스르륵 모션 */
    $(window).scroll(function(){
        $('.item-kit01,.item-kit02').each(function(){
        var y = $(window).scrollTop() + $(window).height() * 1;
        var imgTop = $(this).offset().top;
        if(y > imgTop) {
            $(this).addClass('on');
        }
        });
    });
    /* event 버튼 선택 */
    $('.btn-grp button').on("click",function(){
        $(this).toggleClass("on").siblings().removeClass("on");
    });
    /* 다른 컨셉 티타임 구경하기 */
    $('.btn-look').on('click',function(){
        $('.time-more').addClass('on');
        $('.icon-arrow').addClass('on');
    });
    <% if myTeaSet <> "" then %>
    $("#teaImg").attr("src","//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_event_select0<%=myTeaSet%>.jpg");
    $("#teaRest").attr("src","//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_event0<%=myTeaSet%>.jpg");
    $('.time-select').show();
    <% end if %>
});

function fnSelectTeaTime(num){
    $("#teaTimeNum").val(num);
    $("#teaImg").attr("src","//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_event_select0"+num+".jpg");
    $("#teaRest").attr("src","//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_event0"+num+".jpg");
}

var numOfTry="<%=subscriptcount%>";
function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        if(numOfTry == "1"){
			alert("오늘의 이벤트 참여는 완료되었습니다. 내일 또 참여해주세요!");
			return false;
		};
        if($("#teaTimeNum").val()==""){
			alert("티타임을 즐기고 싶은 상황을 골라주세요!");
			return false;
		};
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubscript110793.asp",
            data: {
                mode: 'add',
                teaTimeNum: $("#teaTimeNum").val()
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option','<%=eCode%>|'+$("#teaTimeNum").val())
                    $('.time-select').show();
                }else if(data.response == "retry"){
                    alert("오늘의 이벤트 참여는 완료되었습니다. 내일 또 참여해주세요!");
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
			<div class="mEvt110793">
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_main.jpg?v=2" alt="기분 좋은 티타임을 즐기고 싶은 따스한 봄 날!">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/tit_logo.png" alt="tenbyten x 몽쉘"></h2>
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/tit_sub.png" alt="오늘도 달콤한 텐.몽카페"></p>
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_sub01.jpg" alt="여러분도 다양한 텐.몽카페 티타임을 즐겨보세요!">
                    <div class="item-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_01.png" alt=""></div>
                    <div class="item-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_02.png" alt=""></div>
                    <div class="item-03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_01.png" alt=""></div>
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_event_info.jpg" alt="event 1 컬러풀해진 몽쉘과 함께 하는 달콤한 디저트 시간, 여러분이 티타임을 즐기고 싶은 상황을 알려주세요!">
                    <div class="event-sec">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_sub02.jpg" alt="여러분이 티타임을 즐기고 싶은 상황을 골라주세요!">
                        <div class="item-04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_03.png" alt="당첨자 100명"></div>
                        <div class="item-kit01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_gift01.png" alt="미녀와 야수"></div>
                        <div class="item-kit02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_gift02.png" alt="몽쉘 솔티피넛"></div>
                        <div class="btn-grp">
                            <button type="button" onClick="fnSelectTeaTime(1);"<% if myTeaSet="1" then response.write " class='on'" %>></button>
                            <button type="button" onClick="fnSelectTeaTime(2);"<% if myTeaSet="2" then response.write " class='on'" %>></button>
                            <button type="button" onClick="fnSelectTeaTime(3);"<% if myTeaSet="3" then response.write " class='on'" %>></button>
                            <input type="hidden" id="teaTimeNum">
                        </div>
                        <a href="#go-mytype" class="btn-apply" onClick="doAction();"></a>
                        <div class="icon-click"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/icon_click.png" alt="click"></div>
                    </div>
                </div>
                <div class="section-03">
                    <div id="go-mytype" class="time-select">
                        <img src="" id="teaImg">
                        <p class="user-name"><%=GetLoginUserName()%></p>
                        <button type="button" class="btn-look"><span class="icon-arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/icon_arrow.png" alt=""></span></button>
                    </div>
                    <div class="time-more">
                        <img src="" id="teaRest">
                    </div>
                </div>
                <div class="section-04">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_sub03.jpg" alt="텐.몽카페에서 알려주는 몽쉘을 더 맛있게 먹는 tip">
                    <div class="icon-mong"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_04.png" alt=""></div>
                </div>
                <div class="section-05">
                    <div class="event-sec">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_sub04.jpg" alt="event 2">
                        <div class="item-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_05.png" alt="선착순 증정"></div>
                        <div class="item-kit01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_gift03.png" alt="피넛"></div>
                        <div class="item-kit02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_gift04.png" alt="몽쉘"></div>
                        <a href="#group364759" class="btn-goprd"></button>
                    </div>
                </div>
                <div class="section-06">
                    <div class="event-sec">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_sub05.jpg" alt="event 3">
                        <div class="item-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_06.png" alt="선착순 증정"></div>
                        <div class="item-kit01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_gift05.png" alt="미녀와 야수"></div>
                        <div class="item-kit02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/item_gift06.png" alt="몽쉘"></div>
                    </div>
                </div>
                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110793/m/img_noti.jpg?v=1.01" alt="유의사항"></div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->