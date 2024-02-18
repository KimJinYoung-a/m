<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 플랜B용 타임 세일
' History : 2020-02-04 이종화 생성 - eventid = 100436
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/timesale/timesaleCls.asp" -->
<%
dim evtDate : evtDate = Cdate("2021-12-20") '// 이벤트일
dim isTeaser , isAdmin : isAdmin = false
dim currentType , currentTime
dim LoginUserid : LoginUserid = GetEncLoginUserID()
dim addParam , eCode , loopInt
dim isItem
dim totalPrice , salePercentString , couponPercentString , totalSalePercent

dim oTimeSale , isSoldOut , RemainCount
set oTimeSale = new TimeSaleCls
    oTimeSale.Fepisode = 5
    oTimeSale.getTimeSaleItemLists

IF application("Svr_Info") = "Dev" THEN
	eCode = "90459"	
Else
	eCode = "100436"
End If

'// 티져 여부
if date() = Cdate(evtDate) then 
    isTeaser = false 
else 
    isTeaser = true 
end If 

'// TEST
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" then
    if date() < Cdate(evtDate) then
        isTeaser = chkiif(requestCheckVar(request("isTeaser"),1) = "1" or requestCheckVar(request("isTeaser"),1) = "" , true , false) '// true 티져 / false 본 이벤트
        currentType = requestCheckVar(request("currentType"),1) '// 1.pm5
        isAdmin = true
        addParam = "&isAdmin=1"
    end if
end if

'// setTimer
if isTeaser then 
    currentTime = evtDate '// 내일기준시간
else
    currentTime = fnGetCurrentSingleTime(fnGetCurrentSingleType(isAdmin,currentType))
end if 
%>
<style type="text/css">
.time-sale {position:relative; background:#fff;}
.time-sale button {background-color:transparent !important;}
.time-sale .inner {width:32rem; margin:0 auto;}

.time-top {position:relative; background-color:#d0378f;}
.time-top .sale-timer {position:absolute; top:64.95%; padding-left:8%; font-size:5.14rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.time-top .sale-timer p {margin-bottom:1.28rem; font-size:2.43rem;}

.time-items ul {display:flex; justify-content:flex-end; flex-wrap:wrap; width:32rem; padding:0 0 4.26rem 8%; margin-top:-4.48rem; margin-left:auto;}
.time-items ul li {flex-basis:29.44rem; margin-top:4.26rem;}
.time-items ul li:first-child {margin-top:0;}
.time-items .thumbnail {position:relative; width:100%; height:29.44rem;}
.time-items .thumbnail img {width:100%; height:100%;}
.time-items .thumbnail .label-box {position:absolute; bottom:-.8rem; right:1.71rem; z-index:10;}
.time-items .thumbnail .label {display:inline-block; height:2.09rem;}
.time-items .desc {margin-top:2.47rem;}
.time-items .name {font-size:1.58rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.time-items .price {display:flex; justify-content:flex-start; align-items:flex-end; margin-top:.5rem; font-size:1.15rem;}
.time-items .price p b {display:inline-block; width:auto; margin-right:.5rem; margin-bottom:0; font-size:1.48rem; color:#888; text-decoration:line-through;}
.time-items .price em {font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:2.13rem; letter-spacing:-.08rem;}
.time-items .price em span {display:inline-block; margin-left:.2rem; font-size:1.28rem; font-weight:bold;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-weight:normal;}
.time-items .price .sale {display:inline-block; margin-right:.8rem; margin-bottom:-.3rem; margin-left:1.71rem; color:#ff3823; font-size:2.57rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}

.time-items .sold-out {position:relative;}
.time-items .sold-out:after,
.time-items .sold-out:before {display:inline-block; position:absolute; top:0; left:0; z-index:10; width:100%; height:100%; background-color:rgba(255,255,255,.55); content:'';}
.time-items .sold-out:before {width:9.4rem; height:9.43rem; top:9.97rem; left:50%; z-index:20; margin-left:-4.72rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/100414/m/txt_sold_out.png)no-repeat 50% 50% / 100% 100%;}

.lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
.lyr .btn-close {position:absolute; top:2.77rem; right:8%; width:1.92rem; height:1.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_close.png) 50% 50%/100%;}
.lyr-fair {display:none;}
.lyr-fair .inner {position:relative;}
.lyr-fair p {padding-top:7.98rem;}
.lyr-fair .input-box1, 
.lyr-fair .btn-get1 {position:absolute; top:0; left:0;}
.lyr-fair #notRobot1 {display:none;} 
.lyr-fair #notRobot1 + label {display:inline-block; position:relative; width:17.45rem; height:2.86rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_chck.png); background-repeat:no-repeat; background-size:100% 100%;}
.lyr-fair #notRobot1:checked + label {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_chck_on.png);}
.lyr-fair .btn-get1 {width:26.53%;}

.ten-sns {position:relative;}
.ten-sns ul {display:flex; position:absolute; top:0; right:5%; width:30%; height:100%;}
.ten-sns ul li {width:50%; height:100%;}
.ten-sns ul li a {display:block; height:100%; text-indent:-999em;}

.related-evt {background-color:#ff76a0;}
</style>
<script type="text/javascript" src="/event/lib/countdown.js"></script>
<script>
    countDownTimer("<%=Year(currentTime)%>"
                    , "<%=TwoNumber(Month(currentTime))%>"
                    , "<%=TwoNumber(Day(currentTime))%>"
                    , "<%=TwoNumber(hour(currentTime))%>"
                    , "<%=TwoNumber(minute(currentTime))%>"
                    , "<%=TwoNumber(Second(currentTime))%>"
                    , new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>));

    $(function() {
        //  페어플레이 레이어
        $('.time-items li').click(function (e) {
            <% if fnGetCurrentSingleType(isAdmin,currentType) > 0 then %>
            if ($(this).hasClass("sold-out")) {
                return false;
            }
            var str = $.ajax({
                type: "GET",
                url: "/apps/appcom/wish/web2014/event/timesale/timesale_proc.asp",
                data: "mode=fair&selectnumber="+$(this).index()+"&sendCount=<%=fnGetCurrentSingleType(isAdmin,currentType)%><%=addParam%>",
                dataType: "text",
                async:false,
                cache:true,
            }).responseText;

            if(str!="") {
                $("#fairplay").empty().html(str);
                $('.lyr-fair').fadeIn();
            }
            <% else %>
            alert("타임세일 오픈 시간은 오후 5시 입니다.");
            <% end if %>
        });
        
        // 레이어 닫기
        $('.btn-close').click(function (e) {
            $('html, body').removeClass('not-scroll');
            $('.lyr').fadeOut();
            $(this).find('.time-items').fadeOut();
        });
    });

    function fnBtnClose(e) {
        $('.lyr').fadeOut();
        $(this).find('.time-items').fadeOut();
    }

    function goDirOrdItem(n) {
        <% If Not(IsUserLoginOK) Then %>
            <% if isApp=1 then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode("/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"")%>');
                return false;
            <% end if %>
        <% else %>
                if (!document.getElementById("notRobot1").checked) {
                    alert("'나는 BOT이 아닙니다.'를 체크해주세요.");
                    return false;
                }

                $.ajax({
                    type:"GET",
                    url:"/apps/appcom/wish/web2014/event/timesale/timesale_proc.asp",
                    data: "mode=order&selectnumber="+n+"&sendCount=<%=fnGetCurrentSingleType(isAdmin,currentType)%><%=addParam%>",
                    dataType: "text",
                    async:false,
                    cache:true,
                    success : function(Data, textStatus, jqXHR){                        
                        if (jqXHR.readyState == 4) {
                            if (jqXHR.status == 200) {
                                if(Data!="") {
                                    var result = JSON.parse(Data);
                                    if(result.response == "ok"){
                                        fnAmplitudeEventMultiPropertiesAction('click_timesale_item','idx|itemid','1|'+result.message)
                                        $("#itemid").val(result.message);
                                        setTimeout(function() {
                                            document.directOrd.submit();
                                        },300);
                                        return false;
                                    }else{
                                        console.log(result.faildesc);
                                        return false;
                                    }
                                } else {
                                    alert("잘못된 접근 입니다.1");
                                    document.location.reload();
                                    return false;
                                }
                            }
                        }
                    },
                    error:function(jqXHR, textStatus, errorThrown){
                        console.log("접근 실패!");
                        return false;
                    }
                });   
        <% End IF %>
    }
</script>
<div class="mEvt100436 time-sale">
    <div class="time-ing">
        <div class="time-top">
            <div class="inner">
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/tit_time.jpg" alt="시작합니다. 달콤한 발렌 타임 세일"></h2>
                <div class="sale-timer"><span>-</span><span id="countdown">00:00:00</span></div>
            </div>
        </div>
        <div class="time-items">
            <ul>
            <%
                FOR loopInt = 0 TO oTimeSale.FResultCount - 1
                    call oTimeSale.FitemList(loopInt).fnItemLimitedState(isSoldOut,RemainCount)
                    call oTimeSale.FitemList(loopInt).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
            %>
                <li <%=chkiif(isSoldOut , "class=""sold-out""", "")%>>
                    <div class="thumbnail">
                        <img src="<%=oTimeSale.FitemList(loopInt).FprdImage%>" alt="">
                        <div class="label-box">
                                <span class="label" style="width:7.34rem;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/txt_limited<%=loopInt+1%>.png" alt="10개한정"></span>
                        </div>
                    </div>
                    <div class="desc">
                        <div class="name"><%=oTimeSale.FitemList(loopInt).FcontentName%></div>
                        <div class="price"><p><b><%=formatnumber(oTimeSale.FitemList(loopInt).Forgprice,0)%></b><em><%=totalPrice%><span>원</span></em></p><% if totalSalePercent <> "0" then %><i class="sale"><%=totalSalePercent%></i><% end if %></div>
                    </div>
                </li>
            <%
                NEXT
            %>   
            </ul>
        </div>
    </div>

    <%'!-- 페어플레이 레이어 --%>
    <div class="lyr lyr-fair" id="fairplay" style="display:none;"></div>

    <div class="ten-sns">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/img_share.png" alt="텐바이텐 sns">
        <ul>
            <li><a href="https://tenten.app.link/e/1eJ63xXVL3">텐바이텐 인스타 바로가기</a></li>
            <li><a href="https://tenten.app.link/e/wgVJICPVL3">텐바이텐 페이스북 바로가기</a></li>
        </ul>
    </div>
    
    <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐텐딜', [BtnType.SHARE, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/deal/deal.asp?itemid=2706487&pEtr=100436');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/bnr_peng.jpg" alt="펭수의 옷장을 공개합니다!"></a>

    <div class="related-evt">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/tit_evt.png" alt="잠깐 찬스, 하나더 아니, 세개 더"></p>
        <ul>
            <li><a href="/event/eventmain.asp?eventid=100067" onclick="jsEventlinkURL(100067);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/img_evt1.jpg" alt="직접 만드는 초콜릿  인기DIY 세트! ~54%"></a></li>
            <li><a href="/event/eventmain.asp?eventid=100148" onclick="jsEventlinkURL(100148);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/img_evt2.jpg" alt="초콜릿 대신  달달한 향수는 어때요? ~70%"></a></li>
            <li><a href="/event/eventmain.asp?eventid=100228" onclick="jsEventlinkURL(100228);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/img_evt3.jpg" alt="발렌타인 꽃다발 에디션 특가!"></a></li>
        </ul>
    </div>
    <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/txt_noti.png" alt="이벤트 유의사항"></div>
</div>

<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<%
    set oTimeSale = nothing    
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->