<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<%
response.charset = "utf-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%


%>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script language='javascript'>
function iSubmit(){
    var frm = document.frmAct;
    if (frm.deviceid.value.length<10){
        alert('디바이스 ID를 입력하세요.');
        frm.deviceid.focus();
        return;
    }

    if (frm.deviceid.value.length<10){
        alert('디바이스ID를 입력하세요.');
        frm.deviceid.focus();
        return;
    }

    if (frm.message.value.length<1){
        alert('메세지 내용을 입력하세요.');
        frm.message.focus();
        return;
    }

    if (confirm('발송하시겠습니까?')){
        frm.submit();
    }
}

</script>

<form name="frmAct" action="pushTEST_process.asp" method="post">
<table width="800" border="1">
<tr>
    <td>앱선택</td>
    <td>
        <select name="appkey"  >
        <option value="6">wishApp(android)
        <option value="5">wishApp(ios)

        <option value="4">colorApp(android)
        <option value="3">colorApp(ios)
        </select>
    </td>
    <td></td>
    <td>필수</td>
</tr>
<tr>
    <td>deviceid</td>
    <td colspan="2"><input type="text" name="deviceid" value="" size="60"></td>
    <td>필수,디바이스ID</td>
</tr>
<tr>
    <td>param</td>
    <td>
        <input type="text" name="param0" value="message" readonly>
    </td>
    <td><textarea name="message" value="" cols="40" rows="3"></textarea></td>
    <td>필수,alert메세지</td>
</tr>
<tr>
    <td>추가param</td>
    <td>
        <input type="text" name="params" value="type" >
    </td>
    <td><input type="text" name="paramvalue" value="event" size="40"></td>
    <td>param명/param값</td>
</tr>
<tr>
    <td>추가param</td>
    <td>
        <input type="text" name="params" value="" >
    </td>
    <td><input type="text" name="paramvalue" value="" size="40"></td>
    <td></td>
</tr>
<tr>
    <td>추가param</td>
    <td>
        <input type="text" name="params" value="" >
    </td>
    <td><input type="text" name="paramvalue" value="" size="40"></td>
    <td></td>
</tr>
<tr>
    <td>추가param</td>
    <td>
        <input type="text" name="params" value="" >
    </td>
    <td><input type="text" name="paramvalue" value="" size="40"></td>
    <td></td>
</tr>
<tr>
    <td align="center" colspan="4">
    <input type="button" value="전송" onClick="iSubmit();">
    </td>
</tr>
</form>
</table>
<!-- #include virtual="/lib/db/dbclose.asp" -->