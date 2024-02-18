<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 반려견 코멘트 이벤트
' History : 2019-07-22
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim evtStartDate, evtEndDate, currentDate
	currentDate =  date()
    evtStartDate = Cdate("2019-07-23")
    evtEndDate = Cdate("2019-08-06")

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  90350
Else
	eCode   =  96191
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
%>
<style type="text/css">
.mEvt95609 .cmt-evt {background-color:#85dbff; text-align:center;}
.mEvt95609 .input-area {width:27.05rem; margin:0 auto 2.56rem; background-color:#fff; border-radius:.43rem;}
.mEvt95609 .input-area label {display:block; padding:2.56rem; border-top:solid 1px #dedede; font-size:1.28rem; font-weight:bold; font-family:'Roboto', 'malgun Gothic', '맑은고딕', sans-serif;}
.mEvt95609 .input-area label:first-child {border-top:0;}
.mEvt95609 .input-area label span {display:inline-block; width:19.6%; vertical-align:middle; text-align:left;}
.mEvt95609 .input-area label .unit {display:inline-block; margin-left:.6rem; color:#0022a0; vertical-align:middle;}
.mEvt95609 .input-area input {display:inline-block; width:75.9%; height:auto; padding:0; border:0; font-size:1.5rem; text-align:right;}
.mEvt95609 .input-area input[type=number] {width:67.3%;}
</style>
<script type="text/javascript" src="/lib/js/TweenMax.min.js"></script>
<script type="text/javascript">
function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( currentDate >= evtStartDate and currentDate <= evtEndDate ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
            if(frm.txtcomm1.value == ""){
                alert('이름을 입력해주세요!')
                frm.txtcomm1.focus()
                return false;
            }
			if(frm.txtcomm2.value == ""){
                alert('나이를 입력해주세요!')
                frm.txtcomm2.focus()
                return false;
            }
			if(frm.txtcomm3.value == ""){
                alert('견종를 입력해주세요!')
                frm.txtcomm3.focus()
                return false;
            }
			if(frm.txtcomm4.value == ""){
                alert('몸무게를 입력해주세요!')
                frm.txtcomm4.focus()
                return false;
            }
            
            frm.txtcomm.value = frm.txtcomm1.value + '||' + frm.txtcomm2.value + '||' + frm.txtcomm3.value + '||' + frm.txtcomm4.value
            frm.action = "/event/lib/doEventComment.asp";
            frm.submit();
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}
}
</script>
<% If currentDate >= evtStartDate and currentDate <= evtEndDate Then %>
<div class="mEvt95609">
    <div class="cmt-evt">
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/95609/m/txt_cmt_evt.png" alt="여러분과 반려견에게 행복한 호캉스를 보내드려요! 아래의 멍견정보를 입력해주신 분 중 추첨을 통해   호텔 카푸치노 1박 숙박권(17만원 상당)  을 드립니다!">
        <div class="input-area">
            <form name="frmcom" method="post" onSubmit="return false;">
            <input type="hidden" name="mode" value="add">
            <input type="hidden" name="iCC" value="1">
            <input type="hidden" name="eventid" value="<%= eCode %>">
            <input type="hidden" name="linkevt" value="<%= eCode %>">
            <input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
            <input type="hidden" id="spoint" name="spoint" value="1">
            <input type="hidden" name="txtcomm">
            <input type="hidden" name="isApp" value="<%= isApp %>">

            <label for="pet-name"><span>이름</span><input type="text" id="pet-name" placeholder="토토" name="txtcomm1" onkeyup="chkword(this,10);" autocomplete="off" onClick="jsCheckLimit();"></label>
            <label for="pet-age"><span>나이</span><input type="number" id="pet-age" placeholder="7" name="txtcomm2" onkeyup="chkword(this,10);" autocomplete="off" onClick="jsCheckLimit();"><em class="unit">살</em></label>
            <label for="pet-breed"><span>견종</span><input type="text" id="pet-breed" placeholder="말티즈" name="txtcomm3" onkeyup="chkword(this,10);" autocomplete="off" onClick="jsCheckLimit();"></label>
            <label for="pet-weight"><span>몸무게</span><input type="number" id="pet-weight" placeholder="3.2" name="txtcomm4" onkeyup="chkword(this,10);" autocomplete="off" onClick="jsCheckLimit();"><em class="unit">kg</em></label>

            </form>
        </div>
        <button type="button" onclick="jsSubmitComment(document.frmcom);"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95609/m/btn_submit.png" alt=""></button>
    </div>
</div>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->