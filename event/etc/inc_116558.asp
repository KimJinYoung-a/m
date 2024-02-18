<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  더블 마일리지
' History : 2022.01.11 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
dim eCode, vUserID, cMil, vMileValue, vMileArr
dim eventStartDate, eventEndDate, currentDate, mktTest
vUserID = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
    mktTest = True
Else
    mktTest = False
End If
eventStartDate  = cdate("2022-01-12")		'이벤트 시작일
eventEndDate 	= cdate("2022-01-18")		'이벤트 종료일

if mktTest then
currentDate = cdate("2022-01-12")
else
currentDate = date()
end if

If currentDate >= eventStartDate And currentDate <= eventEndDate Then
    vMileValue = 400
Else
    vMileValue = 100
End If

Set cMil = New CEvaluateSearcher
cMil.FRectUserID = vUserID
cMil.FRectMileage = vMileValue

If vUserID <> "" Then
    vMileArr = cMil.getDoubleEvtEvaluatedTotalMileCnt
End If
Set cMil = Nothing
%>
<style type="text/css">
.double-mileage {position:relative; background:#11aaf1;}
.my-mileage {position:relative; width:86%; margin:0 auto 4.27rem; padding:3.5rem 2.6rem 2.6rem; background:#fff; border-radius:0.85rem;}
.my-mileage h3 {font-size:1.37rem; line-height:1.5; color:#555; text-align:center; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.my-mileage .user-id {display:inline-block; color:#222; font-family:'CoreSansCMedium'; vertical-align:text-bottom; border-bottom:1px solid #222;}
.my-mileage h3 b {color:#111;}
.my-mileage h3 em {color:#a234dd;}
.my-mileage ul {padding:1.8rem 0 2.1rem;}
.my-mileage li {position:relative; overflow:hidden; margin:1.1rem 0; font-size:1.1rem; color:#3a3a3a;}
.my-mileage li .tit {position:absolute; left:0; top:50%; -webkit-transform:translateY(-40%); transform:translateY(-40%); font-size:1.13rem;}
.my-mileage li .tit span {display:inline-block; margin:0.5rem 0 0 0.6rem; font-size:0.91rem; color:#696969;}
.my-mileage li .num {float:right; min-width:9.6rem; height:2.43rem; line-height:2.43rem; padding:0.2rem 1.37rem 0; background:#ededed; border-radius:0.64rem; text-align:right; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.47rem;}
.my-mileage li .num b {display:inline-block; line-height:1; font-family:'CoreSansCBold'; margin-right:0.4rem;}
.my-mileage li.m02 {padding-bottom:2rem; margin-bottom:0;}
.my-mileage li.m02 .tit {transform:translateY(-50%);}
.my-mileage li.m01 b {color:#686868;}
.my-mileage li.m02 b {margin-right:0.7rem; color:#f6424a;}
.my-mileage .btn-group {padding:0 0.5rem;}
.double-mileage .sec-aram {position:relative;}
.double-mileage .sec-aram button {width:100%; height:10rem; position:absolute; left:0; top:74%; background:transparent;}
</style>
<script>
function jsSubmitComment(){
	<% If isapp="1" Then %>
		calllogin();
		return;
	<% else %>
		jsevtlogin();
		return;
	<% End If %>
}

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
		var returnCode, itemid, data
		var data={
			mode: "add"
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/doEventSubscript116558.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							alert('신청이 완료되었습니다.\n1월 19일에 마일리지가 지급되면 알림톡이 발송됩니다.');
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
			alert("이벤트 참여기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}
</script>
			<div class="mEvt88837 double-mileage">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/116558/m/img_main.jpg" alt="더블 마일리지"></h2>
				<div class="my-mileage">
					<% If IsUserLoginOK Then %>
                    <h3>지금 <span class="user-id"><%= vUserID %></span> 님이<br><em>후기 작성하면 받을 수 있는 혜택</em></h3>
                    <% Else %>
					<h3><b>나의 예상 적립 마일리지</b>를<br>확인하세요!</h3>
					<% End If %>
					<ul>
						<li class="m01">
							<strong class="tit">&middot; 작성 가능한 후기 개수</strong>
							<span class="num"><b><% If IsUserLoginOK Then %><%=vMileArr(0,0)%><% else %>0<% End if %></b>개</span>
						</li>
						<li class="m02">
							<strong class="tit">&middot; 최대 예상 마일리지<br/><span>*포토 후기일 경우</span></strong>
							<span class="num"><b><% If IsUserLoginOK Then %><%=FormatNumber(vMileArr(1,0),0)%><% else %>0<% End if %></b>P</span>
						</li>
					</ul>
					<div class="btn-group">
						<% If IsUserLoginOK Then %>
                        <a href="/my10x10/goodsusing.asp" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116558/m/btn_goprd.png" alt="상품후기 쓰러 가기"></a>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsusing.asp');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114763/m/btn_goprd.png" alt="상품후기 쓰러 가기"></a>
                        <% Else %>
                        <a href="" onclick="jsSubmitComment(); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111791/m/btn_gologin.png" alt="로그인 하기">
                        <% End If %>
					</div>
				</div>
                <div class="sec-aram">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116558/m/img_aram.jpg" alt="이벤트 안내">
                    <button type="button" onclick="eventTry();"></button>
                </div>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/116558/m/img_noti.jpg" alt="이벤트 유의사항"></p>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->