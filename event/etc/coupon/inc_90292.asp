<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2018 서프라이즈 쿠폰
' History : 2018-11-08 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, couponcnt
dim getbonuscoupon1, getbonuscoupon2, getbonuscoupon3, couponcnt1
dim totalbonuscouponcountusingy1, totalbonuscouponcountusingy2, totalbonuscouponcountusingy3

IF application("Svr_Info") = "Dev" THEN
	eCode = 89187
	getbonuscoupon1 = 2824
	getbonuscoupon2 = 2825
	getbonuscoupon3 = 2798
Else
	eCode = 90292
	getbonuscoupon1 = 1101	'5000/40000
	getbonuscoupon2 = 1102	'10000/70000
	getbonuscoupon3 = 1103  '30000/200000
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0
totalbonuscouponcountusingy2=0
totalbonuscouponcountusingy3=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" Or userid="leelee49" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
	totalbonuscouponcountusingy3 = getbonuscoupontotalcount(getbonuscoupon3, "", "Y","")
end if
%>
<style type="text/css">
.mEvt90292 .coupon {position:relative;}
.mEvt90292 .coupon .only-app {position:absolute; top:-0.85rem; right:3.07%; width:20.93%;}
.mEvt90292 h2 {position:relative;}
.mEvt90292 h2 .btn-go {position:absolute; bottom:0; left:0; width:100%; height:20%; text-align:center; text-indent:-999em; color:transparent;}
.mEvt90292 .soldout {position:absolute; top:0; left:0; width:100%; text-align:center;}
.mEvt90292 .soldout img {width:86.67%; margin:0 auto;}
.evtNoti {padding:3.6rem 0; background:#4bc3dd;}
.evtNoti h3 {padding-bottom:2.4rem; font-size:1.6rem; font-weight:bold; color:#fff; text-align:center;}
.evtNoti h3 span {border-bottom:0.14rem solid #fff;}
.evtNoti ul {padding:0 6.6%;}
.evtNoti li {position:relative; font-family:'AppleSDGothicNeo-Regular'; font-size:1.11rem; line-height:1.87rem; color:#fff; padding-left:1.6rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.8rem; width:0.6rem; height:0.14rem; background-color:#fff;}
</style>
<script type="text/javascript">
    function fnMoveRecommendItemEvent90292() {
        var offset = $("#lyrRecommendItem90292Col").offset();
        $("html, body").animate({scrollTop : offset.top}, 400);
    }
</script>

<div class="mEvt90292">
    <% If isapp="1" then %>
        <h2 class="mApp">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90292/m/a_tit.jpg" alt="서프라이즈 쿠폰">
            <a href="" onclick="fnMoveRecommendItemEvent90292();return false;" class="btn-go">추천상품 보러가기</a>
        </h2>
        <div class="coupon">
            <p class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90292/m/a_coupon.jpg" alt=""></p>
            <a href="" onclick="fnAPPpopupBrowserURL('사용가능한 쿠폰','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/couponbook.asp','right','','sc');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90292/m/a_btn.jpg" alt="쿠폰함으로 가기"></a>
        </div>        
    <% else %>
        <h2 class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90292/m/m_tit.jpg" alt="서프라이즈 쿠폰"></h2>
        <div class="coupon">
            <p class="mWeb">
                <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90292/m/m_coupon.jpg" alt="">
                <span class="only-app"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90292/m/img_app.png" alt=""></span>
            </p>
            <a href="http://m.10x10.co.kr/apps/link/?12820181105" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90292/m/m_btn.jpg" alt="APP에서 쿠폰받으러 받기"></a>
        </div>        
    <% end if %>

    <div class="evtNoti">
        <h3><span>이벤트 유의사항</span></h3>
        <ul>
            <li>본 이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
            <li>지급된 쿠폰은 텐바이텐 APP에서만 사용 가능 합니다.</li>
            <li>쿠폰은 11/13(화) 23시 59분 59초에 종료됩니다.</li>
            <li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
            <li>이벤트는 조기 마감될 수 있습니다.</li>
        </ul>
    </div>
</div>
<p>&nbsp;</p>
<p>&nbsp;</p>
<% if isapp="1" then %>
    <%'// 추천상품 노출 %>
    <script type="text/javascript">
        $.ajax({
            url: "/event/etc/coupon/act_evt90292recommenditem.asp",
            cache: false,
            async: true,
            success: function(vRst) {
                if(vRst!="") {
                    $("#lyrRecommendItem90292Col").empty().html(vRst);
                }
                else
                {
                    $('#lyrRecommendItem90292Col').hide();
                }
            }
            ,error: function(err) {
                //alert(err.responseText);
                $('#lyrRecommendItem90292Col').hide();
            }
        });
    </script>
    <div id="lyrRecommendItem90292Col"></div>
<% end if %>
<%
    if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" Or userid="leelee49" then
        response.write couponcnt&"-발행수량<br>"
        response.write totalbonuscouponcountusingy1&"-사용수량(5,000/40,000)<br>"
        response.write totalbonuscouponcountusingy2&"-사용수량(10,000/70,000)<br>"
        response.write totalbonuscouponcountusingy3&"-사용수량(30,000/200,000)<br>"        
    end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->