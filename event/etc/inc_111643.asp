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
' Description : 2021 캠핑 마일리지 혜택 이벤트
' History : 2021-05-20 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "106359"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "111643"
    mktTest = True
Else
	eCode = "111643"
    mktTest = False
End If

eventStartDate  = cdate("2021-05-24")		'이벤트 시작일
eventEndDate 	= cdate("2021-06-02")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-05-24")
else
    currentDate = date()
end if

dim subscriptcount
if LoginUserid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, LoginUserid, "", "", "")
end if
%>
<style>
.mEvt111585 .topic {position:relative;}
.mEvt111585 .tab {position:relative;}
.mEvt111585 .tab-link {display:flex; position:absolute; left:0; top:0; width:100%; height:100%;}
.mEvt111585 .tab-link a {display:inline-block; width:50%; height:100%;}
.mEvt111585 .tab-link a.disabled {pointer-events:none;}
.mEvt111585 .section-01 {position:relative;}
.mEvt111585 .section-01 .btn-apply {width:100%; height:10rem; position:absolute; left:0; top:3%; background:transparent;}
</style>
<script>
var numOfTry = "<%=subscriptcount%>";
function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
        <% end if %>
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
		if(numOfTry >= 1){
			// 한번 시도
			alert("이미 신청하셨습니다.");
			return false;
		}
		var returnCode, itemid, data
		var data={
			mode: "add"
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/doEventSubscript111643.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
                            numOfTry++;
							alert('신청이 완료되었습니다.\n참여방법을 자세히 확인해주세요.');
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.");
						document.location.reload();
						return false;
					}
			},
			error:function(err){
				console.log(err)
				alert("잘못된 접근 입니다.");
				return false;
			}
		});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}
</script>
			<div class="mEvt111585">
                <div class="tab">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111643/m/tab_event02.jpg" alt="tab">
                    <div class="tab-link">
                        <a href="/event/eventmain.asp?eventid=111584" class="mWeb"></a>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111585');return false;" class="mApp"></a>
                        <a href="/event/eventmain.asp?eventid=111643" class="mWeb"></a>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111643');return false;" class="mApp"></a>
                    </div>
                </div>
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111643/m/img_main.jpg" alt="캠핑 지원 10,000p">
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111643/m/img_event.jpg" alt="상세내용">
                    <button type="button" class="btn-apply" onClick="eventTry();"></button>
                </div>
                <a href="/event/eventmain.asp?eventid=111230" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111643/m/img_link01.jpg" alt=""></a>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111230');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111643/m/img_link01.jpg" alt=""></a>
                <a href="/event/eventmain.asp?eventid=111188" class="mWeb disabled"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111643/m/img_link02.jpg" alt=""></a>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111188');return false;" class="mApp disabled"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111643/m/img_link02.jpg" alt=""></a>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->