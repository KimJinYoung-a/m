<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 안녕? 난 고양이 띠야
' History : 2022.01.13 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/ordercls/event_myordercls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest, rsMem, img
dim eCode, currentDate, moECode, sqlstr, myJoinCheck, arrItemList

IF application("Svr_Info") = "Dev" THEN
	eCode = "109446"
    moECode = "109402"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "116675"
    moECode = "116674"
    mktTest = True
Else
	eCode = "116675"
    moECode = "116674"
    mktTest = False
End If
img = request("img")
Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid=" & moECode & "&gaparam=" & gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2022-01-26")		'이벤트 시작일
eventEndDate 	= cdate("2022-02-08")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2022-01-26")
else
    currentDate = date()
end if
%>
<script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
<script>
function partShot() {
    //특정부분 스크린샷
    html2canvas(document.querySelector(".container"))
    .then(function (canvas) {
        //이미지 저장
        saveAs(canvas.toDataURL('image/jpeg'), 'file-name.jpg');
    }).catch(function (err) {
        console.log(err);
    });
}

function saveAs(uri, filename) {
    var link = document.createElement('a');
    try{
        link.href = uri;
        link.download = filename;
        document.body.appendChild(link);
        link.click();
    } catch(e){
        console.log('코드의 실행 흐름이 catch 블록으로 옮겨집니다.');
        alert(`다음과 같은 에러가 발생했습니다: ${e.name}: ${e.message}`);
    }

}
</script>
<button onclick="partShot()">파일 다운로드</button>
<div style="position:relative;" class="container" id='container'>
<div><img src="/apps/appcom/wish/web2014/event/etc/catGangi/B004292174.jpg"></div>
<div id="image_container" style="position:absolute; left:0; top:0; z-index:10; width:100px; height:100px;"><img src="<%=img%>"></div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->