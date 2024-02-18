<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 방가방가 첫 구매&연속구매 진입 페이지
' History : 2016.03.11 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>
<%
Dim userid : userid = getencloginuserid()
	If userid = "baboytw" Or userid = "greenteenz" Or userid = "cogusdk" Or userid = "helele223" Then
		Dim arrList, strSql
		strSql = " select cnt"
		strSql = strSql & "	from db_temp.[dbo].[tbl_event_69627] "
		rsget.Open strSql,dbget,1
		'Response.write strSql
		IF Not rsget.Eof Then
			arrList = rsget.getRows()
		End IF
		rsget.close()
	End If
%>
<style type="text/css">
img {vertical-align:top;}
.door {overflow:hidden;}
.door div {float:left; width:50%;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt69627").offset().top+25}, 0);
});

function jsevtgo(e){
	var str = $.ajax({
		type: "POST",
		url: "/event/etc/doeventsubscript/doEventSubscript69627.asp",
		data: "mode=evtgo&ecode="+e,
		dataType: "text",
		async: false
	}).responseText;
	var str1 = str.split("||")
	if (str1[0] == "11"){
	<% If isapp="1" Then %>
		document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid="+e;
	<% else %>
		document.location.href = "/event/eventmain.asp?eventid="+e;
	<% end if %>		
		return false;
	}else if (str1[0] == "01"){
		alert('잘못된 접속입니다.');
		return false;
	}else if (str1[0] == "00"){
		alert('정상적인 경로가 아닙니다.');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}

</script>
<div class="mEvt69627">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69627/m/tit_shout_spell.png" alt="주문을 외쳐방" /></h2>
	<div class="door">
		<div class="room01"><a href="" onclick="jsevtgo('69628'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69627/m/img_door_first.png" alt="열려라 첫 구매! - 한번도 구매하지 않았다면 이 문을 열어방" /></a></div>
		<div class="room02"><a href="" onclick="jsevtgo('69634'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69627/m/img_door_again.png" alt="열려라 또 구매! - 주문내역이 있다면 이 문을 열어방" /></a></div>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69627/m/txt_open.gif" alt="" /></p>
	<% If userid = "baboytw" Or userid = "greenteenz" Or userid = "cogusdk" Or userid = "helele223" Then %>
		첫구매[<%= arrList(0,0) %>]/연속구매[<%= arrList(0,1) %>]
	<% end if %>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->