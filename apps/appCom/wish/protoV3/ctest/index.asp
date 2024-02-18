<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim apiurl : apiurl = ""
    IF application("Svr_Info") = "Dev" THEN
        apiurl = "http://testfapi.10x10.co.kr/api/web/v1/best/steady"
    ElseIf application("Svr_Info")="staging" Then
        apiurl = "https://fapi.10x10.co.kr/api/web/v1/best/steady"
    Else
        apiurl = "https://fapi.10x10.co.kr/api/web/v1/best/steady"
    End If

    response.write session("isAdult") &"////<br/>"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script>
function fnTest() {
    $.ajax({
            type : "GET",
            url: '<%=apiurl%>',
            ContentType : "json",
            crossDomain: true,
            xhrFields: {
                withCredentials: true
            },
            success: function(message) {
                if(message!="") {
                    console.log(message);
                }
            },
            error: function (xhr) {
                 console.log(xhr.responseText);
            }
        });
}

fnTest();
</script>
</body>
</html>
