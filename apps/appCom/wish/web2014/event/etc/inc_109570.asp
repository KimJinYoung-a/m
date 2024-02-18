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
' Description : 2021 두번째 구매샵
' History : 2021.02.16 정태훈 생성
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, vQuery, i, itemid, soldoutcheck

IF application("Svr_Info") = "Dev" THEN
    eCode = "104317"
    mktTest = true
    itemid = "3324406"
ElseIf application("Svr_Info")="staging" Then
    eCode = "109570"
    mktTest = true
    itemid = "3628566"
Else
    eCode = "109570"
    mktTest = false
    itemid = "3628566"
End If

eventStartDate = cdate("2021-02-17")        '이벤트 시작일
eventEndDate = cdate("2021-12-31")          '이벤트 종료일(소진시 종료)
LoginUserid		    = getencLoginUserid()
if mktTest then
    '// 테스트용
    currentDate = cdate("2021-02-17")
else
    currentDate = date()
end if
%>
<style>
.mEvt109570 {position:relative; overflow:hidden; background:#ffd3cd;}
.mEvt109570 li + li {margin-top:8%;}
.mEvt109570 .item-list {padding-bottom:15%;}
.mEvt109570 .item-list li + li {margin-top:9%;}
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
                url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript109570.asp",
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
<% IF isApp=1 THEN %>
			<div class="mEvt109570">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109570/m/tit_shop.jpg" alt="반짝 SHOP"></h2>
				<ul class="item-list">
                    <%'<!-- 히치하이커 매거진 Vol.85 3628566 -->%>
					<li>
						<% If getitemlimitcnt(itemid) < 1 Then %>
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/109570/m/img_item2_out.jpg?v=2" alt="Sold Out">
						<% Else %>
						<a href="" onclick="goDirOrdItem(1);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109570/m/img_item2.jpg?v=2" alt="바로 구매하기"></a>
						<% End if %>
					</li>
				</ul>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/109570/m/txt_notice.jpg?v=2" alt="유의사항"></p>
			</div>
<% ELSE %>
			<div class="mEvt109570">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109570/m/tit_shop.jpg" alt="반짝 SHOP"></h2>
				<ul>
					<li><img src="//webimage.10x10.co.kr/fixevent/event/2021/109570/m/img_item2_mw.jpg?v=2" alt="히치하이커 매거진 Vol.85 안녕"></li>
				</ul>
				<a href="https://tenten.app.link/BdrcfDObJdb?%24deeplink_no_attribution=true"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109570/m/btn_app.jpg" alt="APP 다운받고 구매하기"></a>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/109570/m/txt_notice.jpg?v=2" alt="유의사항"></p>
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