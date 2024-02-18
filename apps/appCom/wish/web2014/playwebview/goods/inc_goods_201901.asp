<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
    Response.Charset="UTF-8"
    Response.AddHeader "Cache-Control","no-cache"
    Response.AddHeader "Expires","0"
    Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 플레이 goods 행운의 복덩이
' History : 2018-12-27 이종화
'####################################################
dim eCode
Dim actdate : actdate = Date()
dim LoginUserid : LoginUserid	= getLoginUserid()
Dim sqlStr , arrEvtResult
dim sqlStr2 , arrWinResult

IF application("Svr_Info") = "Dev" THEN
	eCode   =  90203
Else
	eCode   =  91505
End If

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐 Play] 복덩이 즉시 당첨 이벤트"
Dim kakaodescription : kakaodescription = "배송비만 내고 복주머니를 가져가세요!\n복주머니에는 최대 100만원 기프트카드가 들어 있어요\n복주머니는 총 2019개!\n복주머니의 주인공이 되세요."
Dim kakaooldver : kakaooldver = "[텐바이텐 Play]\n복덩이 즉시 당첨 이벤트!\n\n배송비만 내고 복주머니를 가져가세요!\n복주머니에는 최대 100만원 기프트카드가 들어 있어요\n복주머니는 총 2019개!\n복주머니의 주인공이 되세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/play/goods/674/img_share_kakao.jpg"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=91505"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=91505"
End If

if (LoginUserid = "ppono2") or (LoginUserid = "motions") or (LoginUserid = "greenteenz") then '// 통계용
	sqlStr = "SELECT "
	sqlStr = sqlStr & " convert(varchar(10),regdate,120) as dd "
	sqlStr = sqlStr & " , count(*) as totcnt "
	sqlStr = sqlStr & " , count(case when sub_opt3 = 'ka' then userid end) as sharecnt "
	sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript "
	sqlStr = sqlStr & " WHERE evt_code = "& eCode &" " 
	sqlStr = sqlStr & " GROUP BY convert(varchar(10),regdate,120)"
	sqlStr = sqlStr & " ORDER BY dd asc"

	rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		arrEvtResult = rsget.getRows()
	End IF
	rsget.close()

	sqlStr2 = "SELECT "
	sqlStr2 = sqlStr2 & " convert(varchar(10),regdate,120) as dd "
	sqlStr2 = sqlStr2 & " , count(case when value3 = '행운의 복덩이' then userid end) as wincnt "
	sqlStr2 = sqlStr2 & " , count(case when value3 = '100만원 행운의 복덩이' then userid end) as fstcnt "
	sqlStr2 = sqlStr2 & " FROM db_log.dbo.tbl_caution_event_log "
	sqlStr2 = sqlStr2 & " WHERE evt_code = "& eCode &" " 
	sqlStr2 = sqlStr2 & " AND regdate > '2019-01-01 00:00:000' " 
	sqlStr2 = sqlStr2 & " GROUP BY convert(varchar(10),regdate,120)"
	sqlStr2 = sqlStr2 & " ORDER BY dd asc"

	rsget.Open sqlStr2,dbget,adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		arrWinResult = rsget.getRows()
	End IF
	rsget.close()
end if 
%>
<style>
.goods-674 button {background-color:transparent;}
.intro {position:relative; padding-bottom:3.5rem; background-color:#6cfffd;}
.intro h2, .intro .txt {position:absolute; top:6.19rem; left:0; z-index:3; width:100%;}
.intro .txt {top:21.54rem;}
.intro .btn-pick {width:100%; margin:50.77rem 0 2.86rem; animation:moveX .8s 100;}
.intro .btn-pick , .intro .btn-below {position:relative; z-index:3;}
.intro .bg {position:absolute; top:0; left:0; z-index:1;}
.ly-result {display:none; position:fixed; top:50%; left:50%; z-index:100000; width:100%; transform:translate(-50%,-50%);}
.ly-result .mask {z-index:99999; background-color:rgba(0,0,0,.8);}
.ly-result > div {position:relative; z-index:15; width:26.19rem; margin:0 auto;}
.ly-result a {display:inline-block; position:absolute; left:0; width:100%; padding:0 12.3%;}
.ly-result .btn-get {top:12.14rem;}
.ly-result .share {bottom:0; z-index:19; padding:0;}
.ly-result .luckbag {position:absolute; bottom:-4.1%; left:50%; z-index:17; width:67.2%; height:21.34rem; margin-left:-33.6%;}
.ly-result .luckbag.animation span {display:inline-block; position:absolute; top:12rem; left:50%; z-index:15; width:3rem; height:3.09rem; margin-left:-1.9rem; }
.ly-result .luckbag.animation span {animation-name:explosion; animation-duration:.7s; animation-iteration-count:2; animation-timing-function:ease-in-out; transform-origin:-8.96rem -1.9rem;}
.ly-result .luckbag.animation span i {display:inline-block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/fixevent/play/goods/674/img_coin_1.png) no-repeat 50% 0; background-size:100% auto; animation:explosion-reverse .7s .2s 1 forwards ease-in;}
.ly-result .luckbag.animation span.l2 {top:8rem; margin-left:-1rem; animation-delay:.25s;}
.ly-result .luckbag.animation span.l3 {top:10rem; margin-left:-2.9rem; animation-delay:.3s;}
.ly-result .luckbag.animation span.l4 {top:12rem; margin-left:-1.5rem; animation-delay:.35s;}
.ly-result .luckbag.animation span.l5 {top:9rem; margin-left:-1.9rem; animation-delay:.4s;}
/*.ly-result .luckbag.animation span.l-coin {display:none;}*/
.ly-result .luckbag.animation span.r-coin {display:inline-block; top:7rem; animation-name:explosion2; transform-origin:9.89rem -2.4rem;}
.ly-result .luckbag.animation span.r-coin i {animation-name:explosion2-reverse;}
.ly-result .luckbag.animation span.r1 {animation-delay:.2s;}
.ly-result .luckbag.animation span.r2 {top:6rem; margin-left:1rem; animation-delay:.25s;}
.ly-result .luckbag.animation span.r3 {top:7rem; margin-left:-1rem; animation-delay:.3s;}
.ly-result .luckbag.animation span.r4 {top:6rem; margin-left:1rem; animation-delay:.35s;}
.ly-result .luckbag.animation span.r5 {top:8rem; margin-left:-1rem; animation-delay:.4s;}
.ly-result .loser + .luckbag span i {background-image:url(http://webimage.10x10.co.kr/fixevent/play/goods/674/img_coin_2.png)}
.ly-result .loser .btn-get {top:29.87rem; padding:0 10.74%;}
.ly-result .bg-luckbag {position:relative; z-index:17; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/fixevent/play/goods/674/img_luck_bag.png) no-repeat 50% 0; background-size:100% auto;}
.ly-result .btn-close {display:inline-block; position:absolute; top:-1.19rem; left:50%; z-index:17; width:3.2rem; height:3.2rem; margin-left:11rem; background:url(http://webimage.10x10.co.kr/fixevent/play/goods/674/btn_close.png) no-repeat 50% 0; background-size:100% auto;}
.luckbag-rolling .btn-below {position:absolute; bottom:3.84rem; left:0; z-index:10; width:100%;}
.luckbag-rolling .pagination {position:absolute; bottom:13.35rem; z-index:10; width:100%; height:.94rem; padding-top:0;}
.luckbag-rolling .pagination .swiper-pagination-switch {width:0.94rem; height:.94rem; margin:0 .43rem; background-color:#6e6e6e;}
.luckbag-rolling .pagination .swiper-active-switch {background-color:#ff24e8;}
.noti {padding:2.69rem 0 2.56rem; background-color:#5c5c5c;}
.noti h3 {width:5.08rem; margin:0 auto;}
.noti ul {padding:0 3.75rem; margin-top:1.45rem;}
.noti ul li {position:relative; color:#f4f4f4; font-size:1.11rem; line-height:2.13rem; word-break:keep-all;}
.noti ul li:before {display:inline-block; position:absolute; top:.8rem; left:-1.11rem; width:.35rem; height:.35rem; border-radius:50%; background-color:#f4f4f4; content:'';}
.result-conts {position:relative;}
.ly-result .code {position:absolute; top:0; left:0; width:100%; padding-left:10px; height:10px; color:#e47d70; font-size:10px;}
@keyframes explosion {
	0% {transform:rotate(0deg); opacity:1}
	80% {transform:rotate(-110deg); opacity:1;}
	100% {transform:rotate(-110deg); opacity:0;}
}
@keyframes explosion-reverse {
	0% {transform:rotate(0deg);}
	80% {transform:rotate(110deg);}
	100% {transform:rotate(110deg);}
}
@keyframes explosion2 {
	0% {transform:rotate(0deg); opacity:1}
	80% {transform:rotate(150deg); opacity:1;}
	100% {transform:rotate(150deg); opacity:0;}
}
@keyframes explosion2-reverse {
	0% {transform:rotate(0deg);}
	80% {transform:rotate(-150deg);}
	100% {transform:rotate(-150deg);}
}
@keyframes moveX {
	from,to {transform:translateX(0);}
	50% {transform:translateX(10px);}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.rolling .swiper-container',{
        effect:'fade',
		loop:true,
		autoplay:2500,
		speed:800,
		pagination:".rolling .pagination",
		paginationClickable:true
	});
    $("#btnBelow1").click(function(event){
        event.preventDefault();
        window.parent.$('html,body').animate({scrollTop:$(".luckbag-rolling").offset().top},600);
    });
    $("#btnBelow2").click(function(event){
        event.preventDefault();
        window.parent.$('html,body').animate({scrollTop:$(".evt-list").offset().top},600);
    });
	$(".btn-close").click(function(event){
        $('.ly-result').hide();
		$('.mask').hide();
    });
	
	titleAnimation();
	$(".intro h2").css({"margin-top":"10px","opacity":"0"});
	$(".intro .txt").css({"margin-top":"10px","opacity":"0"});
	function titleAnimation() {
		$(".intro h2").delay(100).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
		$(".intro .txt").delay(300).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
	}
	if ( $('.result-conts').children().hasClass("loser")) {
		$('.luckbag span i').css('background-image', 'url("http://webimage.10x10.co.kr/fixevent/play/goods/674/img_coin_2.png")');
	}
});
// gogogo
function checkmyprize() {
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<%' If Now() > #12/30/2018 00:00:00# And Now() < #01/09/2019 23:59:59# Then '테스트용 %>
		<% If Now() > #01/01/2019 23:59:59# And Now() < #01/09/2019 23:59:59# Then %>
			$.ajax({
				type: "POST",
				url: "/apps/appcom/wish/web2014/playwebview/goods/goods_201901_proc.asp",
				data: "mode=add",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							//console.log(Data);
							if(Data!="") {
								var str;
								for(var i in Data){
									 if(Data.hasOwnProperty(i)){
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								//console.log(res[1]);
								if (res[0]=="OK"){
									$("#resulthtml").empty().html(res[1]);
                                    $('.ly-result').show();
        							$('.mask').show();
									$('#lyrResult').fadeIn();
									window.parent.$('html,body').animate({scrollTop:$('#lyrResult').offset().top-30}, 600);
                                    $('.luckbag').addClass('animation');
									return false;
								} else {
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg);
									document.location.reload();
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
					document.location.reload();
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;				
		<% End If %>
	<% End If %>
}

function sharesns(snsnum) {
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		var reStr;
		var str = $.ajax({
			type: "POST",
			url:"/apps/appcom/wish/web2014/playwebview/goods/goods_201901_proc.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "text",
			async: false
		}).responseText;
			reStr = str.split("|");
			if(reStr[1]=="ka"){
				<% if isapp then %>
				fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
				<% else %>
				event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
				<% end if %>
				return false;
			}else if(reStr[1] == "none"){
				alert('참여 이력이 없습니다.\n응모후 이용 하세요');
				return false;
			}else if(reStr[1] == "end"){
				alert('공유는 하루에 1회만 가능합니다.');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
	<% End If %>
}

function goDirOrdItem(tm) {
<% If IsUserLoginOK() Then %>
	<%' If Now() > #12/30/2018 23:59:59# And Now() < #01/09/2019 23:59:59# Then '테스트용 %>
	<% If Now() > #01/01/2019 23:59:59# And Now() < #01/09/2019 23:59:59# Then %>
		$("#itemid").val(tm);
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% Else %>
	if(confirm("로그인을 하셔야 응모할 수 있습니다.")){
		top.location.href="/login/loginpage.asp?vType=G";
		return false;
	}
<% End IF %>
}

function coupondown() {
    var str = $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/playwebview/goods/goods_201901_proc.asp",
        data: "mode=coupondown",
        dataType: "text",
        async: false
    }).responseText;
    var reStr = str.split("||");
    if (reStr[0] == "11"){
        alert('쿠폰이 발급 되었습니다.\n1월 9일 자정까지 사용하세요. ');
        return false;
    }else{
        alert('쿠폰함을 확인 해주세요.');
        return false;
    }
}
</script>
<%'!-- PLAY.GOODS 674 행운의 복덩이 --%>
<% 
	if (LoginUserid = "ppono2") or (LoginUserid = "motions") or (LoginUserid = "greenteenz") then '// 통계용
		dim ercnt , wncnt
		response.write "<div>응모 정보</div>"
		if isArray(arrEvtResult) then 
			for ercnt=0 to uBound(arrEvtResult,2)
				response.write "<div>"& arrEvtResult(0,ercnt) &" : 전체응모 :"& arrEvtResult(1,ercnt) &" / 공유 :"& arrEvtResult(2,ercnt) &"</div>"
			next 
		end if
		response.write "<div>당첨 정보</div>"
		if isArray(arrWinResult) then 
			for wncnt=0 to uBound(arrWinResult,2)
				response.write "<div>"& arrWinResult(0,wncnt) &" : 당첨자 :"& arrWinResult(1,wncnt) &" / 1등당첨자 :"& arrWinResult(2,wncnt) &"</div>"
			next 
		end if
	end if
%>
<div class="goods-674">
    <div class="intro">
        <h2><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/tit_luck.png" alt="행운의 복덩이 데려가세요!" /></h2>
        <p class="txt"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/txt_intro.png" alt="배송비만 내면 최대 100만원이 들어있는	복덩이를 받을 수 있는 기회!	2019개의 복덩이와 함께하는	돼지띠 새해, 행운의 주인공이 되세요!" /></p>
        <%' 응모버튼 %>
        <button class="btn-pick" id="actbtn" onclick="checkmyprize();"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/btn_pick.png" alt="복덩이 뽑기" /></button>
        <!--<div id="endbtn"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/btn_comp.png" alt="뽑기완료" /></div>-->
        <%' 응모버튼 %>
        <a href="" class="btn-below" id="btnBelow1"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/btn_below_1.png" alt="아래로이동" /></a>
        <div class="bg"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/bg_intro.jpg" alt=""></div>

        <%'!-- 뽑기 결과 --%>
        <div class="ly-result" id="lyrResult" style="display:none;">
            <div class="inner">
                <div class="result-conts" id="resulthtml"></div>
                <div class="luckbag">
                    <span class="l-coin l1"><i></i></span>
                    <span class="l-coin l2"><i></i></span>
                    <span class="l-coin l3"><i></i></span>
                    <span class="l-coin l4"><i></i></span>
                    <span class="l-coin l5"><i></i></span>
                    <span class="r-coin r1"><i></i></span>
                    <span class="r-coin r2"><i></i></span>
                    <span class="r-coin r3"><i></i></span>
                    <span class="r-coin r4"><i></i></span>
                    <span class="r-coin r5"><i></i></span>
                    <div class="bg-luckbag"></div>
                </div>
            </div>
            <button class="btn-close"></button>
        </div>
        <div class="mask"></div>
        <%'!--// 뽑기 결과 --%>
    </div>

    <%'!-- 복덩이이용팁 --%>
    <div class="luckbag-rolling rolling">
        <div class="swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/img_tip_1.jpg" alt="랜덤으로 들어있는 기프트 카드를 품고있어요!" /></div>
                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/img_tip_2.jpg" alt="이 돼지복덩이에 돈을 넣으면 돈이 배가 생긴다는 속설이 있어요! 배를 두둑하게 해줄 수록 더 귀여워 질 테니 복덩이에게 밥을 많이 주세요!" /></div>
                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/img_tip_3.jpg" alt="복덩이 안에 소중한 물건들을 넣어 파우치로 이용하면 물건이 깨지지 않게 소중하게 품어줄거에요!" /></div>
                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/img_tip_4.jpg" alt="우리 복덩이를 방에 걸어 놓고 자면 귀여운 돼지가 꿈에 나오게 해줘요! 새해 소망을 적어 걸어두면 귀여운 돼지복덩이가 뿅 나타날거에요." /></div>
            </div>
            <div class="pagination"></div>
            <a href="" class="btn-below" id="btnBelow2"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/btn_below_2.png" alt="아래로 이동" /></a>
        </div>
    </div>
    <%'!--// 복덩이이용팁 --%>

    <div class="evt-list">
        <img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/img_luckbag.jpg" alt="행운의 복덩이를 잘 부탁해요">
        <a href="/event/eventmain.asp?eventid=91548" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/bnr_evt1.jpg" alt="새해 행운의  복 아이템"></a>
        <a href=""  onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91548');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/bnr_evt1.jpg" alt="새해 행운의  복 아이템"></a>
        <!--<a href="/event/eventmain.asp?eventid=91397" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/bnr_evt2.jpg" alt="새해선물 이벤트"></a>
        <a href=""  onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=91397');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/bnr_evt2.jpg" alt="새해선물 이벤트"></a>-->
    </div>

    <div class="noti">
        <h3><img src="http://webimage.10x10.co.kr/fixevent/play/goods/674/tit_noti.png" alt="유의사항" /></h3>
        <ul>
            <li>본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
            <li>ID당 1일 1회만 응모가능합니다.</li>
            <li>이벤트는 즉시 결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
            <li>당첨된 상품은 이벤트 종료일(2019년 1월 9일)까지 구매하셔야 결제 가능합니다.</li>
			<li>본 제품은 수량 제한 상품으로 조기 종료 될 수 있습니다.</li>
        </ul>
    </div>
</div>
<%'!--// 컨텐츠 영역 --%>
<% if isapp then %>
	<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
		<input type="hidden" name="itemid" id="itemid" value="">
		<input type="hidden" name="itemoption" value="0000">
		<input type="hidden" name="itemea" readonly value="1">
		<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
		<input type="hidden" name="isPresentItem" value="" />
		<input type="hidden" name="mode" value="DO3">
	</form>
<% else %>
	<form method="post" name="directOrd" action="/inipay/shoppingbag_process.asp">
		<input type="hidden" name="itemid" id="itemid" value="">
		<input type="hidden" name="itemoption" value="0000">
		<input type="hidden" name="itemea" readonly value="1">
		<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
		<input type="hidden" name="isPresentItem" value="" />
		<input type="hidden" name="mode" value="DO1">
	</form>
<% end if %>
<%'!--// 컨텐츠 영역 --%>