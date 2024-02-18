<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 천원의 기적2
' History : 2018-11-16 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = "[천원의 기적]"
    Dim kakaodescription : kakaodescription = "지금 에어팟을 1,000원에 구매할 수 있는\n이벤트에 도전하세요!"
    Dim kakaooldver : kakaooldver = "지금 에어팟을 1,000원에 구매할 수 있는\n이벤트에 도전하세요!"
    Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2018/90519/etcitemban20181115102351.JPEG"
    Dim kakaolink_url 
    If isapp = "1" Then '앱일경우
        kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=90519"
    Else '앱이 아닐경우
        kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=90519"
    End If

    '// 일자별 상품코드 변경
    Dim miracleProductCode
    miracleProductCode = ""
    If left(now(),10)>="2018-11-19" and left(now(),10) < "2018-11-20" Then
        miracleProductCode = "2145838"
    End If
    If left(now(),10)>="2018-11-20" and left(now(),10) < "2018-11-21" Then
        miracleProductCode = "2145984"
    End If
    If left(now(),10)>="2018-11-21" and left(now(),10) < "2018-11-22" Then
        miracleProductCode = "2146034"
    End If        

    Dim userAirPotEventOrderCount
    userAirPotEventOrderCount = 0
    If IsUserLoginOK() Then
        If Trim(miracleProductCode) <> "" Then
            '// 사용자의 해당일자 상품의 결제내역을 확인한다.
            Dim sqlstr
            sqlStr = ""
            sqlStr = sqlStr & " select count(m.userid) from db_order.dbo.tbl_order_master as m " &VBCRLF
            sqlStr = sqlStr & " 	inner join db_order.dbo.tbl_order_detail as d " &VBCRLF
            sqlStr = sqlStr & " 	on m.orderserial=d.orderserial " &VBCRLF
            sqlStr = sqlStr & " 	where m.jumundiv<>'9' and m.ipkumdiv > 3 and m.cancelyn = 'N' " &VBCRLF
            sqlStr = sqlStr & " 	and d.cancelyn<>'Y' and d.itemid<>'0' And m.userid='"&GetEncLoginUserId&"' " &VBCRLF
            sqlStr = sqlStr & " 	and d.itemid='"&miracleProductCode&"' " &VBCRLF
            rsget.Open sqlStr, dbget, 1
            userAirPotEventOrderCount = rsget(0)
            rsget.Close
        End If
    End If
%>
<style type="text/css">
.mEvt90519 {background-color:#143ab7;}
.mEvt90519 img {width:100%;}
.mEvt90519 .bg-img {position:relative;}
.mEvt90519 .bg-img span.ico-img {display:block; animation:bounce2 1s 100 ease-in-out; position:absolute; top:29%; right:7%; width:28%;}
.mEvt90519 .vod-area {position: relative; background-color: #000;  padding-bottom:100%; }
.mEvt90519 .vod-area iframe {position: absolute; left:0; width: 100%; height: 100%;}
.mEvt90519 .info {position:relative;}
.mEvt90519 .info a {display: block; position: absolute; top:19%; right: 0; width: 10.24rem; height: 2.99rem; text-indent: -9999px; }
.mEvt90519 .info a.after {top: 55%;}
.mEvt90519 .btn-deposit {display:block; position:absolute; left:0; bottom:0; width:100%; height:30%; text-indent:-999em; color:transparent;}
.mEvt90519 .noti {background-color: #161f47; padding:  4.47rem 0;}
.mEvt90519 .noti img {display: block; width: 6.82rem; height: 1.62rem; margin: 0 auto 2.13rem;}
.mEvt90519 .noti ul {padding: 0 2.5rem;}
.mEvt90519 .noti li {color: #e0e0e0; font: bold 1.1rem/1.8rem 'AppleSDGothicNeo-SemiBold'; margin-bottom: .5rem; letter-spacing: -.03rem}
.mEvt90519 .noti li:before {content:'·'; display:inline-block; width:10px;margin-left:-10px; }
.mEvt90519 .noti li a {padding: .1rem .5rem; margin-left: .5rem; background-color: #6a00d6; font-size: 1rem; }
@keyframes bounce2 {from, to{transform:translateY(0);} 50%{transform:translateY(10px)}}
</style>
<script>
function TnAddShoppingBag90519(){
    <% If not(IsUserLoginOK) Then %>
		<% If isApp="1" or isApp="2" Then %>    
		    alert('로그인 후 참여하실 수 있습니다.');        
            parent.calllogin();
            return false;
        <% Else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=90519")%>');
			return false;
        <% End If %>
    <% end if %>
    <% If userAirPotEventOrderCount > 0 Then %>
        alert('고객님께서는 이벤트 상품을 이미 주문하셨습니다.\n한 ID당 하루에 최대 1개까지 주문 가능');
        return false;
    <% End If %>
    <% If Trim(miracleProductCode) = "" Then %>
        alert('이벤트 기간이 아닙니다.');
        return false;
    <% End If %>
    
    var frm = document.sbagfrm;
    var optCode = "0000";

    if (!frm.itemea.value){
        alert('장바구니에 넣을 수량을 입력해주세요.');
        return;
    }
    frm.itemoption.value = optCode;
    <% If isapp="1" Then %>
        frm.mode.value = "DO3"; //2014 분기
    <% Else %>
        frm.mode.value = "DO1"; //2014 분기
    <% End If %>
    //frm.target = "_self";
    <% If isapp="1" Then %>
        frm.target = "evtFrmProc"; //2014 변경
    <% End if %>
    frm.action="<%= appUrlPath %>/inipay/shoppingbag_process.asp";
    frm.submit();

    //setTimeout("parent.top.location.replace('<% '= appUrlPath %>/event/eventmain.asp?eventid=<%'= eCode %>')",500)
    return false;

}
function snschk() {
    <% if isapp="1" then %>
        fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
        return false;
    <% else %>
        event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
    <% end if %>
}
function parent_kakaolink(label , imageurl , width , height , linkurl ){
    //카카오 SNS 공유
    Kakao.init('c967f6e67b0492478080bcf386390fdd');

    Kakao.Link.sendTalkLink({
        label: label,
        image: {
        src: imageurl,
        width: width,
        height: height
        },
        webButton: {
            text: '10x10 바로가기',
            url: linkurl
        }
    });
}

//카카오 SNS 공유 v2.0
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
</script>

<%' 90519 천원의 기적 에어팟 %>
<div class="mEvt90519">
    <div class="bg-img">
        <% If left(now(),10)>="2018-11-22" and left(now(),10) < "2018-11-26" Then %>    
            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/img_miracle_after.png" alt="천원의 기적">
            <span class="ico-img"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/img_winner_after.png" alt="당첨자 20명"></span>
        <%'이벤트 당첨자 발표(11월26일)에 보여줘야 되는 출력부 %>
        <% ElseIf left(now(),10)>="2018-11-26" Then %>
            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/tit_miracle_dday.png" alt="천원의 기적">
            <%' 영상 %>
            <div class="vod-area">
                <iframe src="https://player.vimeo.com/video/302397662"  frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
            </div>
            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/img_miracle_dday.png" alt="당첨자 20명">
        <% Else %>
            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/img_miracle.png" alt="천원의 기적">
            <span class="ico-img"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/img_winner.png" alt="당첨자 20명"></span>
        <% End If %>        
    </div>
    <%'이벤트 응모기간이 끝나고 11월 26일까지 보여줘야 되는 버튼 출력부 %>
    <% If left(now(),10)>="2018-11-22" and left(now(),10) < "2018-11-26" Then %>
        <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/btn_buy_after.png" alt="구매하러 가기">
    <%'이벤트 당첨자 발표(11월26일)에 보여줘야 되는 출력부 %>
    <% ElseIf left(now(),10)>="2018-11-26" Then %>
        <% If isApp="1" Then %>    
            <a href="" onclick="fnAPPpopupBrowserURL('공지사항','<%=wwwUrl%>/apps/appcom/wish/web2014/common/news.asp?type=E','right','','sc');return false;">
        <% Else %>
            <a href="<%=wwwUrl%>/common/news.asp?type=E">
        <% End If %>
            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/btn_buy_dday.png" alt="구매하러 가기">
        </a>
    <% Else %>
        <a href="" onclick="TnAddShoppingBag90519();return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/btn_buy.png" alt="구매하러 가기"></a>
    <% End If %>
    
    <div class="info">
        <%'이벤트 응모기간이 끝나고 11월 26일까지 보여줘야 되는 버튼 출력부 %>    
        <% If left(now(),10)>="2018-11-22" and left(now(),10) < "2018-11-26" Then %>
            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/img_info_after.png?v=1.02" alt="응모기간">
            <% If isApp="1" Then %>
                <a href="" class="after" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','bottom');return false;">예치금이란?</a>
            <% Else %>
                <a href="<%=wwwUrl%>/my10x10/popDeposit.asp" class="after">예치금이란?</a>
            <% End If %>
        <%'이벤트 당첨자 발표(11월26일)에 보여줘야 되는 출력부 %>
        <% ElseIf left(now(),10)>="2018-11-26" Then %>
            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/img_info_after.png?v=1.02" alt="응모기간">
            <% If isApp="1" Then %>
                <a href="" class="after" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','bottom');return false;">예치금이란?</a>
            <% Else %>
                <a href="<%=wwwUrl%>/my10x10/popDeposit.asp" class="after">예치금이란?</a>
            <% End If %>
        <% Else %>
            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/img_info.png?v=1.02" alt="응모기간">
            <% If isApp="1" Then %>
                <a href="" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','bottom');return false;">예치금이란?</a>
            <% Else %>
                <a href="<%=wwwUrl%>/my10x10/popDeposit.asp">예치금이란?</a>
            <% End If %>
        <% End If %>
    </div>
    <div class="noti">
        <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/txt_noti.png" alt="유의사항">
        <ul>
            <li>본 이벤트는 텐바이텐 회원만 참여할 수 있습니다.</li>
            <li>당첨자에게는 상품에 따라 세무 신고에 필요한 개인 정보를   요청할 수 있습니다. (제세공과금은 텐바이텐이 부담합니다.)</li>
            <li>본 이벤트의 상품은 즉시 결제로만 구매할 수 있으며, 해당 이벤트에 응모하신 후 당첨자 발표 이후에는 취소나 환불 처리가 되지 않습니다.</li>
            <li>예치금은 현금 반환 요청이 가능하며, 고객행복센터 또는 1:1 게시판으로 문의하시면 반환 안내를 도와드립니다.</li>
            <li>본 이벤트는 ID 당 하루에 1회만 구매(응모) 가능합니다. 이벤트 기간 동안 총 3회 구매(응모) 가능합니다.</li>
            <li>당첨자 20명은 11월 26일(월) 텐바이텐 웹사이트 하단 공지사항에 공지됩니다.
                <% If isApp="1" Then %>
                    <a href="" onclick="fnAPPpopupBrowserURL('공지사항','<%=wwwUrl%>/apps/appcom/wish/web2014/common/news.asp?type=E','right','','sc');return false;">공지사항 바로가기 ></a>
                <% Else %>
                    <a href="<%=wwwUrl%>/common/news.asp?type=E">공지사항 바로가기 ></a>
                <% End If %>
                
            </li>
        </ul>
    </div>
    <% if left(now(),10) < "2018-11-22" Then %>
        <a href="" onclick="snschk();return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90519/m/bnr_sns.png" alt="친구에게 공유해주세요!"></a>
    <% End If %>
</div>
<%' // 90519 천원의 기적 에어팟 %>
<form name="sbagfrm" method="post" action="" style="margin:0px;">
<input type="hidden" name="mode" value="add" />
<input type="hidden" name="itemid" value="<%=miracleProductCode%>" />
<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
<input type="hidden" name="itemoption" value="0000" />
<input type="hidden" name="userid" value="<%= getEncloginuserid() %>" />
<input type="hidden" name="isPresentItem" value="" />
<input type="hidden" name="itemea" readonly value="1" />
</form>	
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->