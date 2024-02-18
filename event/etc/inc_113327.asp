<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 페이백 이벤트
' History : 2021.08.09 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest
dim eCode, currentDate

IF application("Svr_Info") = "Dev" THEN
	eCode = "108386"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "113327"
    mktTest = True
Else
	eCode = "113327"
    mktTest = False
End If

eventStartDate  = cdate("2021-08-11")		'이벤트 시작일
eventEndDate 	= cdate("2021-08-25")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-08-11")
else
    currentDate = date()
end if

dim iniRentalInfoData, tmpRentalInfoData, iniRentalMonthLength
dim sqlstr, iniRentalMonthPrice, orderPrice, myOrderSerial
dim myorder, i
set myorder = new CMyOrder

myorder.FPageSize = 100
myorder.FCurrpage = 1
myorder.FRectUserID = LoginUserid
myorder.FRectSiteName = "10x10"
myorder.FRectStartDate = FormatDateTime("2021-07-01",2)
myorder.FRectEndDate = FormatDateTime("2021-08-01",2)
myorder.GetMyOrderListProc

if LoginUserid<>"" then
	sqlstr = "select top 1 sub_opt1"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"'"
    sqlstr = sqlstr & " and sub_opt3='try'"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		myOrderSerial = rsget("sub_opt1")
	END IF
	rsget.close
end if
%>

<style>
/* common */
.mEvt113327 .section{position:relative;}

/* section01 */
.mEvt113327 .section01 .coin{width:100%;}
.mEvt113327 .section01 .coin .coin01{width:32.7vw;position:absolute;top:11rem;left:18vw;animation:updown 0.8s ease-in-out alternate infinite;}
.mEvt113327 .section01 .coin .coin02{width:13.5vw;position:absolute;top:2rem;left:20vw;animation:updown 0.9s ease-in-out alternate infinite;}
.mEvt113327 .section01 .coin .coin03{width:13.1vw;position:absolute;top:37rem;animation:updown 0.7s ease-in-out alternate infinite;}
.mEvt113327 .section01 .coin .coin04{width:16.5vw;position:absolute;top:28rem;right:0;animation:updown 1s ease-in-out alternate infinite;}

.mEvt113327 .section01 .text{position:absolute;top:35rem;width:100%;}
.mEvt113327 .section01 .text .txt01{width:51.5vw;position:absolute;left:50%;margin-left:-25.75vw;opacity:0; transform:translateY(50%); transition:all 1s;}
.mEvt113327 .section01 .text .txt01.on{opacity:1; transform:translateY(0); }
.mEvt113327 .section01 .text .txt02{width:56.3vw;position:absolute;left:50%;margin-left:-28.15vw;top:21rem;}
.mEvt113327 .section01 .text .txt03{width:51.3vw;position:absolute;left:50%;margin-left:-25.65vw;top:49rem;}
.mEvt113327 .section01 .text .txt04{width:47.5vw;position:absolute;left:50%;margin-left:-23.75vw;top:55rem;}
.mEvt113327 .section01 .text .line{width:86.7vw;position:absolute;left:50%;margin-left:-43.35vw;top:63rem;}
.mEvt113327 .section01 .text .txt05{width:60.5vw;position:absolute;left:50%;margin-left:-30.25vw;top:68rem;}
.mEvt113327 .section01 .text .txt06{width:57.7vw;position:absolute;left:50%;margin-left:-28.85vw;top:77rem;}
.mEvt113327 .animate {opacity:0; transform:translateY(50%); transition:all 1s; }
.mEvt113327 .animate.on {opacity:1; transform:translateY(0); }

/* section02 */
.mEvt113327 .section02{background:#000d48;}
.mEvt113327 .section02 .user{position:absolute;top:8rem;color:#6efcba;text-align:center;width:100%;font-size:2rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt113327 .section02 .user span{text-decoration: underline;}
.mEvt113327 .section02 .order{position:relative;width:86.7vw;height:12rem;display:block;margin-left:6.65vw;background:url(//webimage.10x10.co.kr/fixevent/event/2021/113327/m/order.png)no-repeat 0 0;background-size:100%;}
.mEvt113327 .section02 .order.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/113327/m/order_on.png)no-repeat 0 0;background-size:100%;}
.mEvt113327 .section02 .order .order_info01{position:absolute;top:1.5rem;width:100%;}
.mEvt113327 .section02 .order .order_info01 p{float:left;font-size:1.1rem;width:50%;font-size:1.1rem;}
.mEvt113327 .section02 .order .order_info01 p.order_date{text-align:center;}
.mEvt113327 .section02 .order .order_info02{position:absolute;top:4rem;width:100%;color:#000d48;}
.mEvt113327 .section02 .order .order_info02 .order_name{padding:0 5vw;font-size:1.2rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt113327 .section02 .order .order_info02 .order_price{margin-top:1rem;padding:0 9vw;font-size:1.8rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';text-align:right;}
.mEvt113327 .section02 .submit{display:block;}
.mEvt113327 .section02 .logout{position:relative;}
.mEvt113327 .section02 .logout .go_login{position:absolute;width:100%;height:8rem;bottom:7rem;display:block;}
.mEvt113327 .section02 .order_one{position:relative;}
.mEvt113327 .section02 .order_one .user{position:absolute;top:8rem;color:#6efcba;text-align:center;width:100%;font-size:2rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt113327 .section02 .order_one .user span{text-decoration: underline;}

/* section04 */
.mEvt113327 .section4 a.go_alert{position:absolute;width:100%;height:8rem;bottom:7rem;display:block;}

/* popup */
.mEvt113327 .popup{display:none;}
.mEvt113327 .popup.popup02{display:block;}
.mEvt113327 .popup .bg_dim{position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.6);z-index:100;}
.mEvt113327 .popup .pop.win {width:100%; padding: 2.47rem 1.73rem 4.17rem; top:0; left:0; margin:0; z-index:150;}
.mEvt113327 .popup .pop{position:fixed;top:20rem;width:86.7vw;left:50%;margin-left:-43.35vw;z-index:10;}
.mEvt113327 .popup .pop .final{position:absolute;top:13rem;width:100%;text-align:center;font-size:1.8rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt113327 .popup .pop .final .name{font-size:1.5rem;letter-spacing:-0.08rem;}
.mEvt113327 .popup .pop .final .name span{text-decoration: underline;}
.mEvt113327 .popup .pop .final .price{margin-top:1.5rem;}
.mEvt113327 .popup .btn_alert{width:100%;position:absolute;bottom:3rem;height:7rem;display:block;}
.mEvt113327 .popup .btn_close{position:absolute;top:0;right:0;width:13vw;height:5rem;display:block;}
.mEvt113327 .popup .btn_close02{position:absolute;top:6%;right:6%;width:13vw;height:5rem;display:block; background:transparent;}
.mEvt113327 .popup .go_link {display:inline-block; width:100%; height:16rem; position:absolute; left:0; bottom:0;}

@keyframes updown {
    0% {transform: translateY(-0.5rem);}
    100% {transform: translateY(0.5rem);}
}
</style>

<script>
$(function() {
    $('.txt01').addClass('on');
    $(window).scroll(function(){
        $('.animate').each(function(){
			var y = $(window).scrollTop() + $(window).height() * 1;
			var imgTop = $(this).offset().top;
			if(y > imgTop) {
				$(this).addClass('on');
			}
		});
    });
    
    $('.order').click(function(){
        $('.order').removeClass('on');
        $(this).toggleClass('on');
    });

    $('.btn_close').click(function(){
        $('.popup').css('display','none');
        return false;
    });
    
    $('.btn_close02').click(function(){
        $('.popup02').css('display','none');
        return false;
    });
});
function fnOrderSelect(orderserial,orderprice){
    $("#orderserial").val(orderserial);
    $("#orderprice").val(orderprice);
}
function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>

        if($("#orderserial").val()==""){
			alert("주문을 선택해 주세요.");
			return false;
		};
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubscript113327.asp",
            data: {
                mode: 'add',
                orderserial: $("#orderserial").val()
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>');
                    $("#myorderprice").html($("#orderprice").val());
                    $('.popup').css('display','block');
                }else if(data.response == "retry"){
                    alert('이미 신청하셨습니다.');
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
function doAlarm() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubscript113327.asp",
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
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
        <% end if %>
		return false;
    <% end if %>
}
function jsSubmitlogin(){
    <% if isApp="1" then %>
        calllogin();
    <% else %>
        jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
    <% end if %>
    return false;
}
</script>
			<div class="mEvt113327">
            <input type="hidden" id="orderserial" value="<%=myOrderSerial%>">
            <input type="hidden" id="orderprice">
				<section class="section section01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/top.jpg?v=2" alt="">
                    <div class="coin">
                        <p class="coin01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/coin01.png" alt=""></p>
                        <p class="coin02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/coin02.png" alt=""></p>
                        <p class="coin03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/coin03.png" alt=""></p>
                        <p class="coin04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/coin04.png" alt=""></p>
                    </div>
                    <div class="text">
                        <p class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/txt01.png" alt=""></p>
                        <p class="txt02 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/txt02.png" alt=""></p>
                        <p class="txt03 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/txt03.png" alt=""></p>
                        <p class="txt04 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/txt04.png" alt=""></p>
                        <p class="line animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/line.png" alt=""></p>
                        <p class="txt05 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/txt05.png" alt=""></p>
                        <p class="txt06 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/txt06.png" alt=""></p>
                    </div>
                <section class="section section02">
                <% if LoginUserid<>"" then %>
                    <% if myorder.FResultCount > 0 then%>
                    <div class="login">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/receipt.jpg" alt="">
                        <p class="user"><span><%=LoginUserid%></span>님의</p>
                        <% for i = 0 to (myorder.FResultCount - 1) %>
                            <%
                                If myorder.FItemList(i).Faccountdiv="150" Then
                                    iniRentalInfoData = fnGetIniRentalOrderInfo(myorder.FItemList(i).FOrderSerial)
                                    If instr(lcase(iniRentalInfoData),"|") > 0 Then
                                        tmpRentalInfoData = split(iniRentalInfoData,"|")
                                        iniRentalMonthLength = tmpRentalInfoData(0)
                                        iniRentalMonthPrice = tmpRentalInfoData(1)
                                    Else
                                        iniRentalMonthLength = ""
                                        iniRentalMonthPrice = ""
                                    End If
                                    orderPrice = FormatNumber(iniRentalMonthPrice,0)
                                Else
                                    orderPrice = FormatNumber(myorder.FItemList(i).FSubTotalPrice,0)
                                End If
                            %>
                        <div class="order <% if myOrderSerial=myorder.FItemList(i).FOrderSerial then %>on<% end if %>" onclick="fnOrderSelect('<%= myorder.FItemList(i).FOrderSerial %>','<%=orderPrice%>');">
                            <div class="order_info01">
                                <p class="order_date">주문일 : <span><%= Left(CStr(myorder.FItemList(i).Fregdate),10) %></span></p>
                                <p class="order_num">주문번호 : <span><%= myorder.FItemList(i).FOrderSerial %></span></p>
                            </div>
                            <div class="order_info02">
                                <p class="order_name"><%=myorder.FItemList(i).GetItemNames%></p>
                                <% If myorder.FItemList(i).Faccountdiv="150" Then %>
                                <p class="order_price"><span><%=iniRentalMonthLength%>개월간 월 <%=FormatNumber(iniRentalMonthPrice,0)%></span></p>
                                <% Else %>
                                <p class="order_price"><span><%=FormatNumber(myorder.FItemList(i).FSubTotalPrice,0)%></span></span></p>
                                <% End If %>
                            </div>                           
                        </div>
                        <% next %>
                        <a href="" onclick="doAction();return false;" class="submit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/submit.jpg" alt=""></a>
                    </div>
                    <% else %>
                    <div class="order_one">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/order01.jpg" alt="">
                        <p class="user"><span><%=LoginUserid%></span>님의</p>
                    </div>
                    <% end if %>
                <% else %>
                    <div class="logout">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/login.jpg" alt="">
                        <a href="" class="go_login" onclick="jsSubmitlogin();return false;"></a>
                    </div>
                <% end if %>
                </section>
                <section class="section section03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/notice.jpg" alt="">
                </section>
                <section class="section section4">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/alert.jpg" alt="">
                    <a href="" class="go_alert" onclick="doAlarm();return false;"></a>
                </section>
                <div class="popup">
                    <div class="bg_dim"></div>
                    <div class="pop">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/popup.png" alt="">
                        <div class="final">
                            <p class="name"><span><%=LoginUserid%></span>님의 응모 금액</p>
                            <p class="price"><span id="myorderprice">999,999,999</span>원</p>
                        </div>
                        <a href="" class="btn_alert" onclick="doAlarm();return false;"></a>
                        <a href="" class="btn_close"></a>
                    </div>
                </div>
                <!-- 당첨안내 팝업 -->
                <div class="popup popup02">
                    <div class="bg_dim"></div>
                    <div class="pop win">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113327/m/pop_winner.jpg?v=2" alt="당첨자 발표">
                        <button type="button" class="btn_close02"></button>
                        <a href="https://m.10x10.co.kr/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt" target="_blank" class="mWeb go_link"></a>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','https://m.10x10.co.kr/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt'); return false;" class="mApp go_link"></a>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->