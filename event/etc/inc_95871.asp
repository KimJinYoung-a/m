<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 쿠폰전 이벤트
' History : 2019-07-05 최종원
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, couponIdx1, couponIdx2, couponIdx3, couponIdx4
IF application("Svr_Info") = "Dev" THEN
	eCode = "90327"
	couponIdx1 = "2903"     
	couponIdx2 = "2903"     
	couponIdx3 = "2903"     
	couponIdx4 = "2903"     
Else
	eCode = "95871"
	couponIdx1 = "1165"
	couponIdx2 = "1166"
	couponIdx3 = "1167"
	couponIdx4 = "1168"
End If

userid = GetEncLoginUserID()

dim eventEndDate, currentDate, eventStartDate
dim subscriptcount, totalsubscriptcount 
dim evtinfo : evtinfo = getEventDate(eCode)

if not isArray(evtinfo) then
	Call Alert_Return("잘못된 이벤트번호입니다.")
	dbget.close()	:	response.End
end if

'변수 초기화
eventStartDate = cdate(evtinfo(0,0))
eventEndDate = cdate(evtinfo(1,0))
currentDate = date()
'currentDate = Cdate("2019-05-04")
eventStartDate = cdate("2019-07-05")
%>
<style type="text/css">
.layerPopup {background-color: rgba(0, 0, 0, 0.65);}
.layerPopup img {position: absolute; top: 50%; transform: translate3d(0,-50%,0);}
.bnr-area {background-color: #faeada;}
.bnr-area ul:after {content: ''; display: block; clear: both;}
.bnr-area li {float: right; width: 50%;}
</style>
<script>
$(function(){
    (function(){
        $('#issue').hide();
        $('.layerPopup').click(function(){
            $(this).hide();
            return false;
        })
    })();
})
</script>
<script>
function cstJsDownCoupon(idx){
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
	<% else %>	
	$.ajax({
		type: "post",
		url: "/apps/appCom/wish/web2014/event/etc/doEvenSubscript95871.asp",				
		data: {
			eCode: '<%=eCode%>',
			couponIdx: idx
		},
		cache: false,
		success: function(resultData) {
			fnAmplitudeEventMultiPropertiesAction('click_coupon_btn','evtcode|idx','<%=eCode%>|'+idx)
			var reStr = resultData.split("|");				
			
			if(reStr[0]=="OK"){		
				$('#issue').show();				
			}else if(reStr[0]=="ERR"){
				if(reStr[1] == "1"){					
					$('#issue2').show();				
				}else{
					var errorMsg = reStr[1].replace(">?n", "/n");
					alert(errorMsg);										
				}
			}			
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
	<% end if %>
}

function jsEventLogin(){
<% if isApp="1" then %>
	calllogin();
<% else %>
	jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=?" & eCode)%>');
<% end if %>
	return;
}
</script>
			<!-- 쿠폰전 -->
			<div class="mEvt95871">
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/tit.jpg" alt="쿠폰전"></h2>
                <div class="coupon-area">
                    <ul>
                        <li><a href="javascript:cstJsDownCoupon('<%=couponIdx1%>')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/btn_coupon_1.jpg" alt="3천원"></a></li>
                        <li><a href="javascript:cstJsDownCoupon('<%=couponIdx2%>')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/btn_coupon_2.jpg" alt="8천원"></a></li>
                        <li><a href="javascript:cstJsDownCoupon('<%=couponIdx3%>')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/btn_coupon_3.jpg" alt="4만원"></a></li>
                        <li><a href="javascript:cstJsDownCoupon('<%=couponIdx4%>')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/btn_coupon_4.jpg" alt="만오천원"></a></li>
                    </ul>
                </div>
                <div class="bnr-area">
                    <ul>
                        <li><a href="/event/eventmain.asp?eventid=95660" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95660');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/bnr_1.jpg" alt="내가 꿈꾸는 드림하우스"></a></li>
                        <li><a href="/event/eventmain.asp?eventid=95659" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95659');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/bnr_2.jpg" alt="주고받는 우리사이"></a></li>
                        <li><a href="/event/eventmain.asp?eventid=95664" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95664');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/bnr_3.jpg" alt="바람직한 쿠폰사용법"></a></li>
                    </ul>
                </div>
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/txt_notice.jpg" alt="유의사항"></p>
                
                <div class="layer-area">
                    <div class="layerPopup" id="guide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/img_guide.png" alt="쿠폰전에 초대합니다 핸드폰을 돌려서 확인해주세요"></div>
                    <div class="layerPopup" style="display:none" id="issue"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/img_issue.png" alt="쿠폰이 발급되었습니다 쿠폰함을 확인해주세요"></div>
					<div class="layerPopup" style="display:none" id="issue2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95871/m/img_issue2.png" alt="이미 쿠폰이 발급되었습니다"></div>
                </div>
			</div>
			<!-- // 쿠폰전 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->