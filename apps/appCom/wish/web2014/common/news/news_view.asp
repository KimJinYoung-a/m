<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
response.charset = "utf-8"
%>
<%
'####################################################
' Description :  공지사항 보기
' History : 2019-04-17 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/BoardNoticecls.asp" -->

<%
'해더 타이틀
strHeadTitleName = "공지사항"

dim oBoardNotice, noticeFix ,idx, ntype, iPg, page, ibb, iTotCnt, isDirectView
	idx = requestCheckVar(request("idx"),9)
	page = requestCheckVar(request("page"),9)
	ntype = requestCheckVar(request("type"),2)			'(A: 전체, E:당첨안내, 01:전체공지,02:상품공지,03:이벤트공지,04:배송공지,05:당첨자공지,06:CultureStation)
    isDirectView = request("direct")

if page = "" then page=1

IF (idx<>"") and (Not IsNumeric(idx)) then response.end

'// 공지사항 한개
dim readnotice
set readnotice = New cBoardNotice
	if idx <> "" then
	    readnotice.FRectid = idx
	    readnotice.getOneNotics()
	end if

dim ntypeText

	Select Case readnotice.FOneItem.Fnoticetype
		Case "02"
            ntypeText = "안내"
		Case "04"
            ntypeText = "배송"
		Case "05"
            ntypeText = "당첨자"
		Case "03"
            ntypeText = "이벤트"
		Case "06"
            ntypeText = "컬쳐스테이션"
        case else
            ntypeText = "공지사항"
    end select    
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title>10x10: <%=ntypeText%></title>
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
<script>
// 내용내 팝업 링크(app용)
function fnOpenPopupLink(tit,url) {
	fnAPPpopupBrowserURL(tit,'<%=wwwUrl%>/apps/appcom/wish/web2014'+url);
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">			
                <!-- contents -->
                <div class="content" id="content">
                    <div class="news-view">
                        <h2 class="hidden">공지사항</h2>
                        <% if readnotice.FResultCount > 0 then %>
                            <% if readnotice.FOneItem.Fyuhyostart<=cStr(date()) and readnotice.FOneItem.Fyuhyoend>=cStr(date()) or GetLoginUserLevel=7 then %>
                                <div class="top">
                                    <span><%=ntypeText%></span>
                                    <h3><%=readnotice.FOneItem.Ftitle%></h3>
                                    <p class="date"><%=FormatDate(readnotice.FOneItem.Fyuhyostart,"0000.00.00")%></p>
                                </div>
                                <div class="specific-conts">
                                    <p>
                                        <%= nl2br(readnotice.FOneItem.Fcontents) %>
                                    </p>				
                                </div>
                            <% else %>
                                <h3>공지기간이 아직 안되었거나 이미 지난 글입니다.</h3>
                            <% end if %>    
                        <% end if %>
                    </div>                    
                </div>
                <!-- //contents -->
		</div>
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->