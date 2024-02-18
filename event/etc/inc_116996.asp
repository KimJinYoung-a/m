<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  선착순 마일리지
' History : 2022.02.15 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim eCode, vUserID
dim eventStartDate, eventEndDate, currentDate, mktTest
vUserID = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
    eCode = "109492"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
    eCode = "116996"
    mktTest = True
Else
    eCode = "116996"
    mktTest = False
End If
eventStartDate  = cdate("2022-02-16")		'이벤트 시작일
eventEndDate 	= cdate("2022-02-17")		'이벤트 종료일

if mktTest then
currentDate = cdate("2022-02-16")
else
currentDate = date()
end if
%>
<style>
.mEvt116996 .txt-hidden {font-size:0; text-indent:-9999px;}
.mEvt116996 .topic {position:relative;}
.mEvt116996 .topic .btn-milige {width:100%; height:10rem; position:absolute; left:0; bottom:9%; background:transparent;}
</style>
<script>
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
			url:"/event/etc/doEventSubscript116996.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							alert('마일리지가 지급 되었습니다.');
							return false;
						}else{
							alert(res.message);
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
			<div class="mEvt116996">
				<div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116996/m/img_main.jpg" alt="선착순 마일리지 지급!">
                    <button type="button" onclick="eventTry();" class="btn-milige txt-hidden">마일리지 받기</button>
                </div>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','https://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116996/m/bnr_01.jpg" alt="첫 구매 혜택"></a>
                <a href="/event/benefit" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116996/m/bnr_01.jpg" alt="첫 구매 혜택"></a>
            </div>
<%
if vUserID="corpse2" or vUserID="greenteenz" or vUserID="rnldusgpfla" or vUserID="wldbs4086" then
dim sqlstr, CheckCNT
sqlstr = "SELECT mileageCount FROM [db_temp].[dbo].[tbl_event_116996] with(nolock)"
rsget.Open sqlstr, dbget, 1
IF Not rsget.Eof Then
    CheckCNT = rsget("mileageCount")
end if
rsget.close
%>
<script>
function fnCancelEventStaff(){
    if(confirm("마일리지 지급 수량을 변경 하시겠습니까?")){
        fnEventCancel();
    }
}
function fnEventCancel(){
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
			mode: "cancel",
            setcount: $("#setcount").val() 
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/doEventSubscript116996.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							alert('마일리지 지급 수량 셋팅 완료.');
							return false;
						}else{
							alert(res.message);
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
마일리지 남은 카운트 : <%=FormatNumber(CheckCNT,0)%>
<br><br><br>
<input type="text" id="setcount">&nbsp;<button type="button" onclick="fnCancelEventStaff();" class="btn-milige txt-hidden">마일리지 카운트 셋팅</button>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->