<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/drawevent/DrawEventCls.asp" -->
<%
'####################################################
' Description : 2019 크리스박스
' History : 2019-12-04 이종화
'####################################################
dim eCode , shareEventCode
dim currentDate , userId
dim eventStartDate , eventEndDate
Dim isTest , testParam

IF application("Svr_Info") = "Dev" THEN
	eCode = "90437"
    shareEventCode = "90362"
Else
	eCode = "99225"
    shareEventCode = "99224"
End If

Dim gaParam : gaParam = requestCheckVar(request("gaparam"),30)

IF application("Svr_Info") <> "Dev" THEN
    If isapp <> "1" Then
        Response.redirect "/event/eventmain.asp?eventid="& shareEventCode &"&gaparam="&gaParam
        Response.End
    End If
END IF

eventStartDate  = cdate("2019-12-09")		'이벤트 시작일
eventEndDate 	= cdate("2019-12-22")		'이벤트 종료일
currentDate = date()
userId      = getencLoginUserid()

if userId="ley330" or userId="greenteenz" or userId="rnldusgpfla" or userId="cjw0515" or userId="thensi7" or userId = "motions" or userId = "jj999a" or userId = "phsman1" or userId = "jjia94" or userId = "seojb1983" or userId = "kny9480" or userId = "bestksy0527" or userId = "mame234" then
    isTest = chkiif(requestCheckVar(request("isTest"),1) = "1" , true , false)
END IF

IF isTest THEN 
    IF currentDate < eventStartDate THEN
        eventStartDate = currentDate
    END IF
END IF

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[돌아온 크리스박스 이벤트!]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& shareEventCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/99225/m/kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& shareEventCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[돌아온 크리스박스 이벤트!]"
Dim kakaodescription : kakaodescription = "배송비 2,500원만 내면, 푸짐한 상품이 쏟아집니다! 지금 도전해보세요."
Dim kakaooldver : kakaooldver = "배송비 2,500원만 내면, 푸짐한 상품이 쏟아집니다! 지금 도전해보세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/99225/m/kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& shareEventCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& shareEventCode

'// 응모
dim drwEvt
dim isSecondTried
dim isFirstTried
dim triedNum : triedNum = 0
dim isShared : isShared = False
isSecondTried = false

if userId <> "" then
    set drwEvt = new DrawEventCls
    drwEvt.evtCode = eCode
    drwEvt.userid = userId
    isSecondTried = drwEvt.isParticipationDayBase(2)
    isFirstTried = drwEvt.isParticipationDayBase(1)
    isShared = drwEvt.isSnsShared
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)

%>
<style type="text/css">
.mEvt99225,.mEvt99225>div {position: relative;}
.mEvt99225 .pos {position: absolute;}
.mEvt99225 button {background-color:transparent;}
.mEvt99225 .bounce {animation:bounce .7s 30;}
.mEvt99225 .topic .bounce {top: 35%; right: 2%; width: 30%;}
.mEvt99225 .topic .btn-more {display: block; top: 47%; width: 100%; padding-bottom: 46%; background-size: contain; text-indent: -999rem; animation: bg_change 1.5s infinite steps(1);}
.mEvt99225 .topic .btn-apply {bottom: 0; left: 0; width: 100%; animation: shake .7s 40;}
.mEvt99225 .prd-area .btn-more {bottom: 8%; left: 50%; width: 50%;}
.mEvt99225 .share .pos {display: flex; top: 0; left: 50%; width: 41%; height: 77%; }
.mEvt99225 .share .pos button {width: 50%; padding-bottom: 18%; text-indent: -999rem;}
.mEvt99225 .share .pos a {width: 50%;}
.mEvt99225 .noti {padding:3.2rem 6.67% ; background-color:#3c3a3a; color: #fff; }
.mEvt99225 .noti h3 {margin-bottom: 1.55rem; font-weight: bold; font-size: 1.55rem; text-align: center;}
.mEvt99225 .noti li {padding-left: .7rem; margin:.68rem 0; font-size:1.11rem; line-height:1.6; word-break: keep-all}
.mEvt99225 .noti li:before {content: '-'; display: inline-block; width: .7rem; margin-left: -.7rem;}
.mEvt99225 .lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.7); display: none;}
.mEvt99225 .lyr .inner {position: relative; width: 32rem; margin: 2.5rem auto;}
.mEvt99225 .lyr .inner .btn-close {position: absolute; top: 0; right: 0; width: 6rem; height: 5rem;}
.mEvt99225 .lyr .inner .btn-buy {position: absolute; bottom: 0; width: 100%; padding-bottom: 25%; text-indent: -999rem;}
.mEvt99225 .lyr .inner .sns {display: flex; top: 41%; width: 100%; }
.mEvt99225 .lyr .inner .sns button {width: 50%; height: 8rem; background: none; text-indent: -999rem;}
.mEvt99225 .lyr .inner .btn-evt {position: absolute; bottom: 0; display: block; width: 100%; height: 8rem; text-indent: -999rem;}
.mEvt99225 .lyr .prd-wrap {top: 4rem; left: 3rem; width: 26rem; height: 33rem; overflow-y: scroll;}
.mEvt99225 .prd-wrap::-webkit-scrollbar {width: 1rem; height: 1rem; }
.mEvt99225 .prd-wrap::-webkit-scrollbar-track {background: #338e46; -webkit-box-shadow: none; border-radius:1rem; }
.mEvt99225 .prd-wrap::-webkit-scrollbar-thumb { background: #fff831; -webkit-box-shadow: none; border-radius:1rem; }
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
@keyframes bg_change {
    from,to{background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99225/m/img_top_prd_1.png)}
    33%{background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99225/m/img_top_prd_2.png)}
    66%{background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99225/m/img_top_prd_3.png)}
}
@keyframes shake {
	from, to {transform:translateX(3px);}
	50% {transform:translateX(-3px);}
}
</style>
<script type="text/javascript">
$(function(){
    $('.mEvt99225 .btn-more').click(function(){
        $('.lyr-more').fadeIn();
        return false;
    })
    $('.mEvt99225 .lyr .btn-close').click(function(){
        $(this).closest('.lyr').fadeOut();
    })
});

var numOfTry = '<%=triedNum%>'
var isShared = "<%=isShared%>"

function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>
		var returnCode, itemid
			$.ajax({
				type:"POST",
				url:"/event/etc/drawevent/drawEventProc2.asp",
				data: {
                    mode: "add",
                    <% if isTest then %>
                    isTest : "1",
                    <% end if %>
				},
                dataType: "JSON",
				success : function(data){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')
                    //console.log(data)
                    if (data.response == "err") {
                        alert(data.faildesc);
                        return false;
                    }
                    returnCode = data.result
                    itemid = data.winItemid
                    popResult(returnCode, itemid);
                    return false;
				},
				error:function(data){
					// console.log(data)
					// document.location.reload();
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}
function popResult(returnCode, itemid){
    $('.lyr').hide();
	if(returnCode[0] == "B"){
		numOfTry++
		if(numOfTry >= 2){
            $("#fail2").show();
			return false;
        }
        $("#fail1").show();
	}else if(returnCode[0] == "A"){
		if(returnCode == "A02"){
            $("#done").show();
		}else{
            $("#share").show();
		}
	}else if(returnCode[0] == "C"){
		$("#itemid").val(itemid);
		$("#win").show();
		numOfTry++
		if(numOfTry == 2) numOfTry = 0
	}
}
function sharesns(snsnum) {
		var reStr;
		$.ajax({
			type: "POST",
			url:"/event/etc/drawevent/drawEventProc2.asp",
			data: {
              mode: 'snschk',
              snsnum: snsnum
            },
			dataType: "JSON"
		})
		isShared = "True"

		if(snsnum=="fb"){
			<% if isapp then %>
			fnAPPShareSNS('fb','<%=appfblink%>');
			return false;
			<% else %>
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
			<% end if %>
		}else{
			<% if isapp then %>
				fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
			<% else %>
				event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
			<% end if %>
        }
        
        $('.lyr').hide();
}
function goDirOrdItem(){
<% If IsUserLoginOK() Then %>
	<% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
}
</script>
<div class="mEvt99225 크리스박스">
    <div class="topic">
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/img_tit.jpg?v=1.01" alt="2019 크리스박스">
        <p class="pos bounce"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/img_top_bounce.png" alt="당첨자 2,000명"></p>
        <a href="" class="pos btn-more">더보기</a>
        <button class="pos btn-apply" onclick="eventTry()"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/btn_apply.png" alt="응모하기"></button>
    </div>
    <div class="prd-area">
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/img_prdwrap.jpg?v=1.02" alt="상품 리스트">
        <a href="" class="pos btn-more bounce"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/btn_prd_more.png" alt="더보기"></a>
    </div>
    <div class="share">
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/bnr_share.jpg" alt="">
        <div class="pos">
            <button class="btn-sns" onclick="sharesns('fb')">페이스북으로 공유하기</button>
            <button class="btn-sns" onclick="sharesns('ka')">카카오톡으로 공유하기</button>
        </div>
    </div>
    <div class="bnr-area">
        <ul>
            <li><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99242');return false;" ><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/bnr_1.jpg" alt="지금 가장 핫한 텐바이텐 BEST 20"></a></li>
            <li><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99222');return false;" ><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/bnr_2.jpg" alt="텐바이텐이 처음이세요? 제가 도와드릴게요!"></a></li>
            <li><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" ><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/bnr_3.jpg" alt="당신이 찾고 있는 크리스마스 소품의 모든 것"></a></li>
        </ul>
    </div>
    <div class="noti">
        <h3>유의사항</h3>                    
        <ul>
            <li>본 이벤트는 텐바이텐 APP에서만 참여 가능합니다. </li>
            <li>1일 1회 응모가 가능하며, 친구에게 공유 시 한 번 더 기회가 주어집니다. (하루 최대 2회 응모 가능)  </li>
            <li>모든 상품의 당첨자가 결정되면 이벤트는 조기 마감될 수 있습니다.</li>
            <li>당첨자에 한 해, 배송비만 결제하면 1개 혹은 2개의 상품이 랜덤으로 발송됩니다.</li>
            <li>5만 원 이상 상품의 당첨자에게는 세무 신고를 위해 개인 정보를 요청할 예정이며, 제세공과금은 텐바이텐 부담입니다.</li>
        </ul>                    
    </div>

    <%'!-- 더보기 버튼 클릭 시 --%>
    <div class="lyr lyr-more">
        <div class="inner">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/lyr_more.png?v=1.04" alt="상품 리스트"></p>
            <p class="pos prd-wrap"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/lyr_prd.jpg?v=1.01" alt=""></p>
            <button class="btn-close"></button>
        </div>
    </div>
    <%'!-- 응모 버튼 클릭 시 1) 당첨 시 --%>
    <div class="lyr lyr-apply" id="win">
        <div class="inner">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/lyr_win.png" alt="축하드립니다! 크리스박스 당첨"></p>
            <!-- for dev msg 구매하러 가기 버튼 -->
            <button class="btn-buy" onclick="goDirOrdItem()">구매하러 가기</button>
            <button class="btn-close"></button>
        </div>
    </div>
    <%'!-- 응모 버튼 클릭 시 2) 꽝 팝업 1) 첫 번째 응모 시 --%>
    <div class="lyr" id="fail1">
        <div class="inner">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/lyr_fail.png" alt="아쉽게도 당첨되지 않았습니다"></p>
            <div class="pos sns">
                <button class="btn-sns" onclick="sharesns('fb')">페이스북으로 공유하기</button>
                <button class="btn-sns" onclick="sharesns('ka')">카카오톡으로 공유하기</button>
            </div>
            <button class="btn-close"></button>
        </div>
    </div>
    <%'!-- 응모 버튼 클릭 시 2-1) 꽝 팝업 1) 첫 번째 응모 시 --%>
    <div class="lyr" id="share">
        <div class="inner">
            <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/lyr_noshare.png" alt=""></div>
            <div class="pos sns">
                <button class="btn-sns" onclick="sharesns('fb')">페이스북으로 공유하기</button>
                <button class="btn-sns" onclick="sharesns('ka')">카카오톡으로 공유하기</button>
            </div>
            <button class="btn-close"></button>
        </div>
    </div>
    <%'!-- 응모 버튼 클릭 시 3) 꽝 팝업 2) 공유 후 두번째 응모 시) 기본 --%>
    <div class="lyr" id="fail2">
        <div class="inner">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/lyr_fail_cpn<%=chkiif(currentDate = eventEndDate,"_last","")%>.png" alt="아쉽게도 당첨되지 않았습니다 내일 다시 도전해보세요!"></p>
            <a class="btn-evt" href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" ></a>
            <button class="btn-close"></button>
        </div>
    </div>
    <%'!-- 응모 버튼 클릭 시 4) 이미 공유까지 해서 2번 응모 완료한 경우) 기본 --%>
    <div class="lyr" id="done">
        <div class="inner">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99225/m/lyr_allfail<%=chkiif(currentDate = eventEndDate,"_last","")%>.png" alt="오늘의 응모는 모두 완료 내일 또 도전해 주세요"></p>
            <a class="btn-evt" href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" ></a>
            <button class="btn-close"></button>
        </div>
    </div>
</div>
<% If IsUserLoginOK() Then %>
<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<% end if %>