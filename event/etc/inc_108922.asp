<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 1억 복주머니
' History : 2021-01-08 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "104291"
	moECode = "103238"
Else
	eCode = "108923"
	moECode = "108922"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

eventStartDate  = cdate("2021-01-11")		'이벤트 시작일
eventEndDate 	= cdate("2021-01-20")		'이벤트 종료일
%>
<style>
.mEvt108923 .topic {position:relative;}
.mEvt108923 .coin-area .item01 {width:20vw; height:auto; position:absolute; left:-3%; top:0; opacity:0; transition:1s;}
.mEvt108923 .coin-area .item01.on {opacity:1; top:17%; }
.mEvt108923 .coin-area .item02 {width:14vw; height:auto; position:absolute; left:15%; top:-2%; opacity:0; transition:1.3s;}
.mEvt108923 .coin-area .item02.on {opacity:1; top:-2%}
.mEvt108923 .coin-area .item03 {width:16vw; height:auto; position:absolute; left:28%; top:0; opacity:0; transition:1s;}
.mEvt108923 .coin-area .item03.on {opacity:1; top:5%;}
.mEvt108923 .coin-area .item04 {width:17vw; height:auto; position:absolute; left:52%; top:0; opacity:0; transition:1.4s;}
.mEvt108923 .coin-area .item04.on {opacity:1; top:8%;}
.mEvt108923 .coin-area .item05 {width:14vw; height:auto; position:absolute; left:60%; top:-2%; opacity:0; transition:1s;}
.mEvt108923 .coin-area .item05.on {opacity:1; top:-2%;}
.mEvt108923 .coin-area .item06 {width:20vw; height:auto; position:absolute; left:79%; top:0; opacity:0; transition:1.5s;}
.mEvt108923 .coin-area .item06.on {opacity:1; top:16%;}
.mEvt108923 .topic .go-app {position:absolute; left:0; bottom:10%; width:100%; height:18vh;}
.mEvt108923 .section-01 {position:relative;}
.mEvt108923 .section-02 {position:relative;}
.mEvt108923 .section-02 .price {width:100%; padding:0 5%; position:absolute; left:50%; top:22%; transform:translate(-50%,0); font-size:2.69rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; text-align:center; word-break:break-all;}
</style>
<script>
$(function() {
	$('.mEvt108923 .coin-area > span').addClass('on');
    getApplyCnt();
});
function getApplyCnt(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/realtimeEvent108923Proc.asp",
		data: "mode=evtcnt",
		dataType: "json",
		success: function(res){
			// console.log(res.data)
            $("#applycnt").html(res.totalcnt);
		}
	})
}
</script>
			<div class="mEvt108923">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_tit02.jpg" alt="새해 1억 많이 받으세요!"></h2>
                    <div class="coin-area">
                        <span class="item01"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin01.png" alt=""></span>
                        <span class="item02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin02.png" alt=""></span>
                        <span class="item03"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin03.png" alt=""></span>
                        <span class="item04"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin04.png" alt=""></span>
                        <span class="item05"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin05.png" alt=""></span>
                        <span class="item06"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin06.png" alt=""></span>
                    </div>
                    <!--  app 설치하고 참여하기 -->
                    <a href="https://tenten.app.link/QNiDgVEoOcb?%24deeplink_no_attribution=true" class="go-app mWeb" target="_blank"></a>
				</div>
				<div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_sub03.jpg" alt="복덩이 안에는? 1등(1명) 마일리지 1,000,000원 2등(5명) 마일리지 500,000원 3등 (96,500명) 마일리지 1,000원">
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_sub02.jpg" alt="현재 남은 금액">
                    <!-- for dev msg : 당첨자가 받은 마일리지 제외한 남은 금액 표기 -->
                    <span class="price" id="applycnt"></span>
                </div>
                <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_noti.jpg" alt="유의사항"></div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->