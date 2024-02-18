<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 개인정보의 위탁 현황 - 그 외 협력사
' History : 2020.07.03 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/partner/private_cls.asp" -->

<%
'해더 타이틀
strHeadTitleName = "개인정보의 위탁 현황 - 그 외 협력사"

dim page, opartner, i
    page = requestCheckVar(getNumeric(request("page")),10)

if page="" then page=1

set opartner = New Cprivate
    opartner.FPageSize = 30
    opartner.FCurrPage = page
    opartner.Getprivate_partner_companyList
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 개인정보의 위탁 현황 - 그 외 협력사</title>
<script type="text/javascript">

function goPage(page){
	location.replace("/common/private_partner_company.asp?page="+page);
}

</script>
</head>
<body>
<div class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
        <h2 class="hidden">개인정보의 위탁 현황 - 그 외 협력사</h2>
		<div  class="news-list">
            <div class="sortingbar ">
                <div class="option-left">
                    <p class="total">협력사명</p>
                </div>
            </div>
            <ul>
                <% if opartner.FResultCount > 0 then %>            
                    <% for i=0 to opartner.FResultCount -1 %>
                    <li><% = opartner.FItemList(i).fcompany_name %></li>      
                    <% next %>
                    <%=fnDisplayPaging_New(opartner.FcurrPage,opartner.FtotalCount,opartner.FPageSize,4,"goPage")%>            
                <% else %>
                    <li>내역이 없습니다.</li>
                <% end if %>
            </ul>
        </div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>

<%
set opartner=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->