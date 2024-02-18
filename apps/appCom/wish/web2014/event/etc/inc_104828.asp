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
' Description : 2020 첫 구매 혜택 에어팟 2세대.
' History : 2020-08-06 원승현 생성
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, eMobileCode
dim mktTest, vQuery, i, gaparamChkVal, itemid, soldoutcheck

IF application("Svr_Info") = "Dev" THEN
    eCode = "102208"
    eMobileCode = "104780"
    mktTest = true
    itemid = "2891188"
ElseIf application("Svr_Info")="staging" Then
    eCode = "104828"
    eMobileCode = "104780"    
    mktTest = true
    itemid = "3076446"
Else
    eCode = "104828"
    eMobileCode = "104780"
    mktTest = false
    itemid = "3076446"
End If

'// 해당 이벤트는 앱만 진행함
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& eMobileCode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate      = cdate("2020-08-10")		'이벤트 시작일
eventEndDate 	    = cdate("2020-08-30")		'이벤트 종료일
LoginUserid		    = getencLoginUserid()
if mktTest then
    '// 테스트용
    currentDate = cdate("2020-08-10")
else
    currentDate = date()
end if

%>
<style type="text/css">
.mEvt104828 {background-color:#000;}
.mEvt104828 .noti {position:relative;}
.mEvt104828 .noti a {position:absolute; bottom:0; left:0; height:35%; width:100%; color:transparent;}
</style>
<script type="text/javascript">

function goDirOrdItem() {
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
                url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript104828.asp",
                data: "mode=order",
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

<% '<!-- MKT 첫 구매 혜택 104828 --> %>
<div class="mEvt104828">
    <div class="mApp">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/104828/m/tit_evt.jpg" alt="첫 구매 혜택"></h2>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/104828/m/img_gift.jpg" alt="애플 에어팟 2세대 유선충전"></div>
		<% If getitemlimitcnt(itemid) < 1 Then %>
            <div class="soldout"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104828/m/btn_soldout.jpg" alt="솔드아웃"></div>
        <% Else %>
            <a href="" onclick="goDirOrdItem();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104828/m/btn_get.jpg" alt="구매하기"></a>
        <% End If %>
        <div class="noti">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/104828/m/txt_noti.jpg" alt="유의사항">
            <a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2365294&pEtr=104828"  onclick="fnAPPpopupProduct('2365294&pEtr=104828');">확인하러가기</a>
        </div>
    </div>
</div>
<% '<!-- MKT 첫 구매 혜택 104828 --> %>

<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->