<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 2020 첫 구매 혜택 2
' History : 2020-11-16 허진원 생성
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, vQuery, i, itemid(4), soldoutcheck

IF application("Svr_Info") = "Dev" THEN
    eCode = "103267"
    mktTest = true
    itemid(0) = "3324406"
    itemid(1) = "3297090"
    itemid(2) = "3218030"
ElseIf application("Svr_Info")="staging" Then
    eCode = "107535"
    mktTest = true
    itemid(0) = "3421395" '알린 계산기
    itemid(1) = "3721834" '고양이 피규어
    itemid(2) = "3861334" '리유저블 컵
Else
    eCode = "107535"
    mktTest = false
    itemid(0) = "3421395" '알린 계산기
    itemid(1) = "3721834" '고양이 피규어
    itemid(2) = "3861334" '리유저블 컵
End If

eventStartDate      = cdate("2020-11-18")		'이벤트 시작일
eventEndDate 	    = cdate("2021-12-31")		'이벤트 종료일(소진시 종료)
LoginUserid		    = getencLoginUserid()
if mktTest then
    '// 테스트용
    currentDate = cdate("2021-05-13")
else
    currentDate = date()
end if

%>
<style type="text/css">
.mEvt107535 {position:relative; overflow:hidden; background:#161616;}
.mEvt107535 .topic,.mEvt107535 .notice {position:relative;}
.mEvt107535 .topic .link {position:absolute; left:0; bottom:0; width:100%; height:30%; font-size:0;}
.mEvt107535 .notice .link {position:absolute; left:0; bottom:8%; width:100%; height:20%; font-size:0;}
</style>
<script type="text/javascript">

function goDirOrdItem(ino) {
    <% If Not(IsUserLoginOK) Then %>
        <% if isApp=1 then %>
            calllogin();
            return false;
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
            return false;
        <% end if %>
    <% else %>
        <% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>    
            $.ajax({
                type:"GET",
                url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript107535.asp",
                data: "mode=order&ino="+ino,
                dataType: "text",
                async:false,
                cache:true,
                success: function(resultData) {
                    var reStr = resultData.split("|");
                    if(reStr[0]=="OK"){
                        fnAmplitudeEventMultiPropertiesAction('click_event_buy','itemid',reStr[1])
                        $("#itemid").val(reStr[1]);
                        setTimeout(function() {
                            document.directOrd.submit();
                        },300);
                        return false;
                    }else if(reStr[0]=="Err"){
                        var errorMsg = reStr[1].replace(">?n", "\n");
                        alert(errorMsg);										
                    }			
                },
                error: function(err) {
                    console.log(err.responseText);
                }
            });
        <% Else %>
            alert("이벤트 응모 기간이 아닙니다.");
            return;
        <% End If %>        
    <% End IF %>
}
</script>

<%
    ''<!-- MKT 첫구매 shop (A) -->
    IF isApp=1 THEN
%>
<div class="mEvt107535">
    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0412/tit_app.jpg" alt="첫 구매 SHOP"></h2>
    <ul>
        <%'<!-- 리유저블 컵 3861334 -->%>
        <li>
            <% If getitemlimitcnt(itemid(2)) < 1 Then %>
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0705/img_item6_out.jpg" alt="Sold Out">
            <% Else %>
            <a href="" onclick="goDirOrdItem(3);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0705/img_item6.jpg" alt="바로 구매하기"></a>
            <% End if %>
        </li>
        <%'<!-- 알린 계산기 3421395 -->%>
        <li>
            <% If getitemlimitcnt(itemid(0)) < 1 Then %>
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0412/img_item1_out.jpg" alt="Sold Out">
            <% Else %>
            <a href="" onclick="goDirOrdItem(1);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0412/img_item1.jpg" alt="바로 구매하기"></a>
            <% End if %>
        </li>
        <%'<!-- 고양이 피규어 3721834 -->%>
        <li>
            <% If getitemlimitcnt(itemid(1)) < 1 Then %>
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0412/img_item3_out.jpg" alt="Sold Out">
            <% Else %>
            <a href="" onclick="goDirOrdItem(2);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0412/img_item3.jpg" alt="바로 구매하기"></a>
            <% End if %>
        </li>
    </ul>
    <div class="notice">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0412/txt_notice.jpg?v=2" alt="유의사항">
    </div>
</div>
<%
    ELSE
    ''<!-- MKT 첫구매 shop (M) -->
%>
<div class="mEvt107535">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0412/tit_mw.jpg" alt="첫 구매 SHOP"></h2>
        <a href="https://tenten.app.link/7ekQpk1Ajbb" class="link">APP 다운받고 구매하러 가기</a>
    </div>
    <ul>
        <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0705/img_item6_mw.jpg" alt="리유저블 컵"></li>
        <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0412/img_item1_mw.jpg" alt="알린 계산기"></li>
        <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0412/img_item3_mw.jpg" alt="고양이 피규어"></li>
    </ul>
    <div class="notice">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107535/m/0412/txt_notice.jpg?v=2" alt="유의사항">
    </div>
</div>
<% END IF %>

<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->