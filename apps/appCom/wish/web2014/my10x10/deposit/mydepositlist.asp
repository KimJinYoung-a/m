<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 나의 예치금
' History : 2018-11-30 이종화 생성
'####################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<%
dim userid, page, dType
userid	= getEncLoginUserID
page	= requestCheckvar(request("page"),9)

if page="" then page=1

dim oTenCash
set oTenCash = new CTenCash
oTenCash.FRectUserID = userid

if (userid<>"") then
	oTenCash.getUserCurrentTenCash
end if

dim oTenCashLog
set oTenCashLog = New CTenCash
oTenCashLog.FPageSize=10
oTenCashLog.FCurrPage= page
oTenCashLog.FRectUserid = userid

if (userid<>"") then
	oTenCashLog.gettenCashLog
end if

dim i,lp

if (GetLoginCurrentTenCash() <> oTenCash.Fcurrentdeposit) then
	Call SetLoginCurrentTenCash(oTenCash.Fcurrentdeposit)
end if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">
function goPage(pg){
	var frm = document.researchForm;
	frm.page.value = pg;
	frm.submit();
}
</script>
</head>
<body>
	<div id="content" class="content my-own-detail">
        <div class="own-info">
            <h2>현재 나의 예치금</h2>
            <p><em><%= FormatNumber(oTenCash.Fcurrentdeposit,0) %></em>원</p>
            <div class="btn-group">
                <a href="" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','right','',''); return false;" class="btn-half">예치금 안내</a>
                <a href="" onclick="fnAPPpopupBrowserURL('예치금 반환 신청','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/deposit/depositapply.asp','bottom','',''); return false;" class="btn-half">예치금 반환 신청</a>
            </div>
        </div>
        <div class="own-history">
            <ul>
                <%
                if (oTenCashLog.FTotalCount > 0) then
                    for i=0 to oTenCashLog.FResultCount-1
                %>
                <li>
                    <span class="date">
                        <span class="day"><%= Replace(Left(oTenCashLog.FItemList(i).Fregdate,10), "-", ".") %></span>
                        <span class="time"><%=Mid(oTenCashLog.FItemList(i).Fregdate,12) %></span>
                    </span>
                    <span class="desc">
                        <em><%= oTenCashLog.FItemList(i).Fjukyo %></em>
                        <span class="price color-<%=chkiif(instr(oTenCashLog.FItemList(i).Fdeposit,"-"),"red","blue")%>"><%=chkiif(instr(oTenCashLog.FItemList(i).Fdeposit,"-"),"","+")%><%= FormatNumber(oTenCashLog.FItemList(i).Fdeposit,0) %>원</span>
                    </span>
                </li>
                <%
                    next
                else
                %>
                <li class="no-data">
                    <span class="no-data">예치금 적립/사용 내역이 없습니다.</span>
                </li>
                <% end if %>
               
            </ul>
            <% if (oTenCashLog.FTotalCount > 0) then %>
            <%=fnDisplayPaging_New(oTenCashLog.FcurrPage, oTenCashLog.FtotalCount, oTenCashLog.FPageSize, 10, "goPage")%>
            <% end if %>
        </div>
	</div>
<form name="researchForm" method="get" action="">
    <input type="hidden" name="page" value="">
    <input type="hidden" name="dType" value="<%= dType %>">
</form>
</body>
</html>
<%
    Set oTenCash = Nothing
    Set oTenCashLog = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->