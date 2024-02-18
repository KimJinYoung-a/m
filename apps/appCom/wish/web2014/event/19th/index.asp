<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'###########################################################
' Description : 19주년 10월 이벤트 메인
' History : 2020-09-14 원승현
'###########################################################
%>
<%
    Dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1) '// gnb사용여부

    If gnbflag = "" Then '// gnb 표시여부
        gnbflag = False
        strHeadTitleName = "이벤트"    
    Else
        gnbflag = true
        strHeadTitleName = ""
    End if

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	dim snpTitle, snpLink, snpPre, snpImg , snpTag , snpTag2 , kakaourl
	snpTitle = "10x10 19주년"
	snpLink = wwwUrl&"/event/19th/index.asp"
	snpPre = "10x10 이벤트"
	snpImg = "http://webimage.10x10.co.kr/eventIMG/2020/106375/banMoList20201005160808.JPEG"
	'기본 태그
	snpTag = "텐바이텐 19주년"
	snpTag2 = "#10x10"
	kakaourl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/19th/index.asp"

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
$(function() {
    //fnAPPchangPopCaption("<%=strHeadTitleName%>");
});
// SNS 공유 팝업
function fnAPPRCVpopSNS(){
    $("#lySns").show();
    $("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
    return false;
}
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%> bg-grey">
	<div id="content" class="content">
		<div class="evtContV15">
            <% server.Execute("/event/19th/index_exc.asp") %>
        </div>
	</div>
    <!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->    
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->