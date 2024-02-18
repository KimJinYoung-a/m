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
' Description : 2019 추석 보너스 이벤트
' History : 2019-08-14 원승현
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim drawEvt, isParticipation
dim numOfParticipantsPerDay, i
dim prd1, prd2, prd3, prd4, prd5, prd6, prd7, prd8, prd9, prd10

IF application("Svr_Info") = "Dev" THEN
	eCode = "90368"	
Else
	eCode = "96682"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30) 

If isapp <> "1" Then 
	Response.redirect "/event/eventmain.asp?eventid=96681&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2019-08-19")		'이벤트 시작일 
eventEndDate 	= cdate("2019-09-04")		'이벤트 종료일
currentDate 	= date()
'currentDate = cdate("2019-08-19")'테스트
LoginUserid		= getencLoginUserid()

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg , appfblink
snpTitle	= Server.URLEncode("[추석 보너스 천만 원 드려요!]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=96681")
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/96682/share.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid=96681"


''head.asp에서 출력
'strOGMeta = strOGMeta & "<meta property=""og:title"" content=""[100원 자판기]"">" & vbCrLf
'strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
'strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/event/eventmain.asp?eventid=95314"" />" & vbCrLf
'strOGMeta = strOGMeta & "<meta property=""og:image"" content=""http://webimage.10x10.co.kr/fixevent/event/2019/95316/share.jpg"">" & vbCrLf
'strOGMeta = strOGMeta & "<meta property=""og:description"" content=""다시 돌아온 100원의 기적에 도전하고, 시원한 여름을 준비해 보세요!"">" & vbCrLf

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[추석 보너스 천만 원 드려요!]"
Dim kakaodescription : kakaodescription = "텐바이텐이 총 천만 원의 추석 보너스를 드립니다. 클릭 한번으로 도전해보세요!"
Dim kakaooldver : kakaooldver = "[텐바이텐] 텐바이텐이 총 천만 원의 추석 보너스를 드립니다. 클릭 한번으로 도전해보세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/96682/share.jpg"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=96681"
End If

set drawEvt = new DrawEventCls
drawEvt.evtCode = eCode
drawEvt.userid = LoginUserid	
%>
<style type="text/css">
.mEvt96682 {background-color: #111;}
.mEvt96682 ,.mEvt96682 > div {position: relative;}
.mEvt96682 .pos {position: absolute; top: 0; width: 100%;}
.mEvt96682 button {background-color: transparent;}
.topic span {transform: scale(0); opacity: 0; transition-duration: .7s; transform-origin: center 70%; transition-timing-function: cubic-bezier(0.68, -0.55, 0.27, 1.55);}
.topic.on span {transform: scale(1);  opacity: 1;}
.delay1 {transition-delay: .3s}
.delay2 {transition-delay: .6s}
.sns-area .pos {padding-left: 55%;}
.sns-area .pos a {display: inline-block; width: 40%; padding-bottom: 50%; text-indent: -999rem;}
.winner-area {width: 32rem; margin: 0 auto;}
.winner-area .pos {top: 7.9rem; left: 50%; width: 26.45rem; margin-left: -13.22rem; }
.winner-area ul {float: left; width: 50%; }
.winner-area ul li {height: 2rem; padding-left: 3.8rem; margin-bottom: .9rem; box-sizing: border-box;}
.winner-area li div {color: #beffcf; line-height: 2rem;  background-color: #111;}
.winner-area li div b {color: #47ff77;}
.noti {padding:3.2rem 6.67% ; background-color:#444; color: #fff; }
.noti h3 {margin-bottom: 1.55rem; font-weight: bold; font-size: 1.7rem; text-align: center;}
.noti li {padding-left: .7rem; margin:.68rem 0; font-size:1.11rem; line-height:1.6; word-break: keep-all}
.noti li:before {content: '-'; display: inline-block; width: .7rem; margin-left: -.7rem;}
.layerPopup {background-color: rgba(0, 0, 0, 0.65);}
.layerPopup > div {position: absolute; top: 50%; left: 50%; width: 28.16rem; transform: translate3d(-50%,-50%,0);}
.layerPopup > div .btn-close {position: absolute; top: 0; right: 0; width: 4.5rem; height: 4.5rem; text-indent: -999rem;}
.share,.bnr-area {position: absolute; bottom: 0; width: 100%; }
.share a {display: inline-block; width: 48%; padding-bottom: 10rem;  text-indent: -999rem;}
.bnr-area a {display: block; width: 100%; padding-bottom: 7rem; text-indent: -999rem;x}
</style>
<script type="text/javascript">
$(function(){
    $('.topic').addClass('on');
    //레이어팝업
    $('.layerPopup').hide();
    $('.layerPopup .btn-close').click(function(){
        $(this).closest('.layerPopup').hide();
        return false;
    })
    //열어보기
    $('.btn-open').click(function(){
        //$('.layerPopup').show();
    })
}); 
</script>
<script style="text/javascript">
var numOfTry = 0;
<% if drawEvt.isParticipationDayBase(1) then %>
    numOfTry = 1
<% end if %>
<% if drawEvt.isParticipationDayBase(2) then %>
    numOfTry = 2
<% end if %>

$(document).ready(function(){	
	getWinner();	
})

function printUserName(name, num, replaceStr){	
	return name.substr(0,name.length - num) + replaceStr.repeat(num)
}

function checkmyprize(){
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>	
        if (numOfTry >= 2) {
            $("#layer-no-chance").show();
            return false;
        }
		var returnCode, md5value, itemid
			$.ajax({
				type:"GET",
				url:"/event/etc/drawevent/mileageEventProc.asp",
				data: "mode=add",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>');									
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var result = JSON.parse(Data)
								if(result.response == "ok"){									
									//console.log(result.result)
									returnCode = result.result
									md5value = result.md5userid
									//itemid = result.winItemid	
									popResult(returnCode, md5value);						
									getWinner();																			
									return false;
								}else{
									alert(result.faildesc);
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

function popResult(returnCode, md5value){	
	if(returnCode[0] == "B"){ 
		numOfTry++				
		if(numOfTry == 1){			
			$("#layer-lose-first").show();
		}else{			
			$("#layer-lose-last").show();
		}
	}else if(returnCode[0] == "A"){ 
		if(returnCode == "A02"){			
			<% if currentDate < eventEndDate then  %>
                $("#layer-no-chance").show();
				//alert("오늘의 응모는 모두 완료!\n내일 또 도전해 주세요!");
			<% else %>
				alert("오늘의 기회를 모두 사용하셨습니다.\n(하루 최대 2회 응모 가능)");
			<% end if %>			
		}else{
            $("#layer-not-snsshare").show();	
		}
	}else if(returnCode[0] == "C"){
        numOfTry++
		$("#layer-win").show();
	}	
}

function sharesns(snsnum) {		
		var reStr;
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/drawevent/mileageEventProc.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "text",
			async: false
		}).responseText;
			reStr = str.split("|");
			if(reStr[1] == "tw") {
				popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
			}else if(reStr[1]=="fb"){
				<% if isapp then %>
				fnAPPShareSNS('fb','<%=appfblink%>');
				<% else %>
				popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
				<% end if %>
			}else if(reStr[1]=="pt"){
				popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
			}else if(reStr[1]=="ka"){
				<% if isapp then %>
				fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','http://www.10x10.co.kr/event/eventmain.asp?eventid=<%=eCode%>','http://m.10x10.co.kr/event/eventmain.asp?eventid=<%=eCode%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
				<% else %>
				event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
				<% end if %>
				return false;
			}else if(reStr[1]=="비로그인"){
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
}

function getWinner() {	
		var reStr;
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/drawevent/mileageEventProc.asp",
			data: "mode=winner",
			dataType: "text",
			async: false
		}).responseText;
		var resultData = JSON.parse(str).data;		
		var winnerLength = resultData.length;
		//var $rootEl = $("#winnerList")
		//$rootEl.empty();
		//var emptyEl;
        for(var winnerI=0; winnerI<resultData.length; winnerI++) {
            //consol.log(resultData[winnerI].userid);
            if (resultData != "") 
            {
                //alert(resultData.length);
                if (resultData[winnerI].userid != "")
                {
                    <% if GetLoginUserLevel = "7" then %>
                        $("#winnerView"+winnerI).empty().html("<div><b>"+resultData[winnerI].userid+"</b> 님</div>");
                    <% Else %>
                        $("#winnerView"+winnerI).empty().html("<div><b>"+printUserName(resultData[winnerI].userid, 2, "*")+"</b> 님</div>");
                    <% End If %>
                }
            }
        }
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

<div class="mEvt96682">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/img_top.jpg" alt="추석 보너스 1,000만원"></h2>
        <div class="pos">
            <span class="delay1 pos"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/img_top_1.png" alt=""></span>
            <span class="pos"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/img_top_2.png" alt=""></span>
            <span class="delay2 pos"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/txt_top.png" alt="추석 보너스가 도착했습니다 봉투를 열어보세요"></span>
        </div>
    </div>
    <button class="btn-open" type="button" onclick="checkmyprize();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/btn_open.jpg" alt="열어보기"></button>
    <div class="winner-area">
        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/bg_winner.jpg" alt="보너스 당첨자 명단"></span>
        <div class="pos" id="winnerList">
            <ul>
                <li id="winnerView0"></li>
                <li id="winnerView1"></li>
                <li id="winnerView2"></li>
                <li id="winnerView3"></li>
                <li id="winnerView4"></li>
            </ul>
            <ul>
                <li id="winnerView5"></li>
                <li id="winnerView6"></li>
                <li id="winnerView7"></li>
                <li id="winnerView8"></li>
                <li id="winnerView9"></li>
            </ul>
        </div>
    </div>
    <div class="sns-area">
        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/bnr_sns.jpg" alt="추석보너스 소문내면 한 번 더 기회를 드려요!"></span>
        <div class="pos">
            <a href="" onclick="sharesns('fb');return false;">페이스북으로 공유</a>
            <a href="" onclick="sharesns('ka');return false;">카카오톡으로 공유</a>
        </div>
    </div>
    <a href="/event/eventmain.asp?eventid=96459" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96459');return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/bnr_evt_V1.jpg" alt="추석 선물로 딱 좋은 아이템 모두 여기에! ">
    </a>
    <a href="/event/eventmain.asp?eventid=96367" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96367');return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/bnr_evt2.jpg" alt="텐바이텐 인스타그램 팔로우하면 귀염뽀짝 선물이!">
    </a>
    <div class="noti">
        <h3>이벤트 유의사항</h3>
        <ul>
            <li>본 이벤트는 텐바이텐 APP에서 로그인 후 참여 가능합니다. </li>
            <li>ID 당 1일 1회만 응모 가능하며, SNS에 공유 시 한 번 더 응모 기회가 주어집니다. (하루 최대 2번 응모 가능) </li>
            <li>모든 상품의 당첨자가 결정되면 이벤트는 조기 마감됩니다. </li>
            <li>당첨 상품은 텐바이텐에서 사용 가능한 마일리지 1,000,000P 입니다. </li>
            <li>당첨자 10분께는 9월 5일에 마일리지 1,000,000P를 일괄 지급할 예정입니다. </li>
            <li>지급된 마일리지는 9월 15일 자정까지만 사용이 가능하며, 해당일까지 사용되지 않은 마일리지 잔액은 소멸될 예정입니다. </li>
            <li>5만 원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있으며, 제세공과금은 텐바이텐 부담입니다.</li>
        </ul>
    </div>
    <div class="layerPopup-area">
        <%' 1. 당첨 시 팝업 %>
        <div class="layerPopup" id="layer-win" style="display:none;">
            <div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/layer_win.jpg" alt="축하합니다!  텐바이텐이 드리는 추석 보너스에 당첨되셨습니다.!">
                <button type="button" class="btn-close">닫기</button>
            </div>
        </div>
        <%' 2. 1차 꽝 팝업 %>
        <div class="layerPopup" id="layer-lose-first" style="display:none;">
            <div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/layer_fail_1.jpg" alt="아쉽게도 당첨되지 않았습니다.">
                <button type="button" class="btn-close">닫기</button>
                <div class="share">
                    <a href="" onclick="sharesns('fb');return false;">페이스북으로 공유</a>
                    <a href="" onclick="sharesns('ka');return false;">카카오톡으로 공유</a>
                </div>
            </div>
        </div>
        <%' 3. 2차 꽝 팝업 %>
        <div class="layerPopup" id="layer-lose-last" style="display:none;">
            <div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/layer_fail_2.jpg" alt="아쉽게도 당첨되지 않았습니다. 대신 보너스 쿠폰을 드릴게요!">
                <button type="button" class="btn-close">닫기</button>
                <div class="bnr-area">
                    <a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96459');return false;">추석선물 미리 골라보기!</a>
                </div>
            </div>
        </div>
        <%' 4. 1차 꽝 이후 sns 공유하지 않고 응모 버튼 클릭 시 팝업 %>
        <div class="layerPopup" id="layer-not-snsshare" style="display:none;">
            <div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/layer_more.jpg" alt="이미 1번 도전하였습니다.">
                <button type="button" class="btn-close">닫기</button>
                <div class="share">
                    <a href="" onclick="sharesns('fb');return false;">페이스북으로 공유</a>
                    <a href="" onclick="sharesns('ka');return false;">카카오톡으로 공유</a>
                </div>
            </div>
        </div>
        <%' 5. 2차 꽝 이후 응모 버튼 클릭 시 팝업 %>
        <div class="layerPopup" id="layer-no-chance" style="display:none;">
            <div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/96682/m/layer_all.jpg" alt="오늘의 기회는 모두 사용하였습니다. 내일 다시 도전해주세요!">
                <button type="button" class="btn-close">닫기</button>
                <div class="bnr-area">
                    <a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96459');return false;">추석선물 미리 골라보기!</a>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->