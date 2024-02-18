<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<script>
//'팝업닫고 부모창 스크립트 실행
//setTimeout(function(){ 
	//parent.fnAPPopenerJsCallClose('jsgotest99(\'\')');
	parent.js_gotest();
	//parent.location.replace('<%= wwwUrl %>/apps/appcom/wish/web2014/offshop/point/mileagelist.asp');
//}, 1000);
</script>
