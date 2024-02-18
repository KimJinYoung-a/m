<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 미리 추석
' History : 2021.08.18 정태훈 생성
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
dim eCode, userid, mktTest, subscriptcount

IF application("Svr_Info") = "Dev" THEN
	eCode = "108390"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "113034"
    mktTest = true    
Else
	eCode = "113034"
    mktTest = false
End If

if mktTest then
    currentDate = #08/16/2021 09:00:00#
else
    currentDate = date()
end if

eventStartDate = cdate("2021-08-16")		'이벤트 시작일
eventEndDate = cdate("2021-08-22")		'이벤트 종료일

userid = GetEncLoginUserID()
%>
<style>
.mEvt113034 .alert_area{position:relative;}
.mEvt113034 .alert_area .alert{position:absolute;width:100%;height:5rem;display:block;top:35rem;}

.mEvt113034 .section{position:relative;}
.mEvt113034 .section02 .pro{position:absolute;top:0;width:100%;height:auto;}
.mEvt113034 .section02 .pro a{width:100%;height:26rem;display:inline-block;}
</style>
<script>
function jsPickingUpPushSubmit(){
<% If Not(IsUserLoginOK) Then %>
    <% if isApp="1" then %>
        calllogin();
    <% else %>
        jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
    <% end if %>
    return false;
<% else %>
    <% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>
        alert("이벤트 참여기간이 아닙니다.");
        return false;
    <% end if %>
        $.ajax({
            type:"GET",
            url:"/event/etc/doeventsubscript/doEventSubscript113034.asp?mode=pushadd",
            dataType: "json",
            success : function(result){
                if(result.response == "ok"){
                    alert("알림신청이 완료되었습니다.");
                    return false;
                }else{
                    alert(result.faildesc);
                    return false;
                }
            },
            error:function(err){
                console.log(err);
                return false;
            }
        });
<% end if %>
}
</script>
			<div class="mEvt113034">
                <section class="section section01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113034/m/top.jpg" alt="">
                </section>
                <section class="section section02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113034/m/product.jpg" alt="">
                    <div class="pro">
                        <a href="/category/category_itemprd.asp?itemid=3977897&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3977897&pEtr=113034'); return false;" class="mApp"></a>
                        <a href="/category/category_itemprd.asp?itemid=3985028&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3985028&pEtr=113034'); return false;" class="mApp"></a>
                        <a href="/category/category_itemprd.asp?itemid=3986060&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3986060&pEtr=113034'); return false;" class="mApp"></a>
                        <a href="/category/category_itemprd.asp?itemid=3965810&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3965810&pEtr=113034'); return false;" class="mApp"></a>
                        <a href="/category/category_itemprd.asp?itemid=3992137&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3992137&pEtr=113034'); return false;" class="mApp"></a>
                        <a href="/category/category_itemprd.asp?itemid=3992094&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3992094&pEtr=113034'); return false;" class="mApp"></a>
                        <a href="/category/category_itemprd.asp?itemid=3992093&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3992093&pEtr=113034'); return false;" class="mApp"></a>
                        <a href="/category/category_itemprd.asp?itemid=2172278&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('2172278&pEtr=113034'); return false;" class="mApp"></a>
                        <a href="/category/category_itemprd.asp?itemid=3985857&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3985857&pEtr=113034'); return false;" class="mApp"></a>
                        <a href="/category/category_itemprd.asp?itemid=3523266&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3523266&pEtr=113034'); return false;" class="mApp"></a>
                        <a href="/category/category_itemprd.asp?itemid=3988801&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3988801&pEtr=113034'); return false;" class="mApp"></a>
                        <a href="/category/category_itemprd.asp?itemid=3771537&pEtr=113034" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3771537&pEtr=113034'); return false;" class="mApp"></a>
                    </div>
                </section>
                <!-- 알림 부분-->
                <div class="alert_area">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113034/m/113034_m_14.gif" alt="">
                    <a href="" onclick="jsPickingUpPushSubmit();return false;" class="alert"></a>
                </div>
                <section class="section section03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113034/m/bottom.jpg" alt="">
                </section>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->