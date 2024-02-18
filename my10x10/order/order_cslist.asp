<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'####################################################
' Description : 마이텐바이텐 - 내가신청한서비스
' History : 2018-10-17 원승현 생성
'####################################################
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "내가신청한서비스"

Dim IsBiSearch   : IsBiSearch   = False   '''비회원 주문인가.

dim i,lp
dim page

page = requestCheckvar(request("page"), 32)
if (page="") then page = 1


dim userid
userid = getEncLoginUserID

dim mycslist
set mycslist = new CCSASList

mycslist.FPageSize = 10
mycslist.FCurrpage = page
mycslist.FRectUserID = userid

dim orderSerial	: orderSerial = requestCheckvar(req("orderSerial",""), 11)
dim divCd		: divCd = requestCheckvar(req("divCd",""), 32)

if IsUserLoginOK() then
    mycslist.FRectOrderserial	= orderSerial
    mycslist.FRectDivCd			= divCd

    mycslist.GetCSASMasterList
elseif IsGuestLoginOK() then
	orderserial = GetGuestLoginOrderserial()
    mycslist.FRectOrderserial = orderserial
    mycslist.FRectDivCd			= divCd

	mycslist.GetCSASMasterList
	IsBiSearch = True
end if


dim currstatecolor
dim popJsName

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<meta name="format-detection" content="telephone=no" />
<title>10x10: 내가신청한서비스</title>
<script type='text/javascript'>
function goPage(pg){
	var frm = document.frmsearch;
	frm.page.value=pg;
	frm.submit();
}

function goLink(page){
    location.href="?page=" + page;
}

function popCsDetail(){
	fnOpenModal("/my10x10/orderPopup/popCsDetail.asp?CsAsID="+idx);
}
</script>
</head>
<body class="default-font body-sub body-1depth bg-grey">
	<form name="frmsearch" method="post" action="order_cslist.asp" style="margin:0px;">
	<input type="hidden" name="page" value="1">
	</form>
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
		<div class="returnWrap">
			<div class="returnNoti3">고객님이 신청하신 CS 처리 리스트입니다.</div>
            <% if mycslist.FResultCount > 0 Then %>
                <ul class="myOdrList">
                    <% for i = 0 to (mycslist.FResultCount - 1) %>
                        <li>
                            <a href="/my10x10/order/order_csdetail.asp?CsAsID=<%=mycslist.FItemList(i).Fid%>">
                                <div class="odrInfo">
                                    <p>접수일 <%= Replace(Left(mycslist.FItemList(i).Fregdate, 10), "-", ".") %></p>
                                    <p>주문번호(<%= mycslist.FItemList(i).Forderserial %>)</p>
                                </div>
                                <div class="odrCont">
                                    <% if (mycslist.FItemList(i).Fcurrstate = "B007") and Not IsNull(mycslist.FItemList(i).Ffinishdate) then %>
                                        <p class="type">[완료 - <%= Replace(Left(mycslist.FItemList(i).Ffinishdate, 10), "-", ".") %>]</p>
                                    <% else %>
                                        <p class="type">[진행중]</p>
                                    <% End If %>
                                    <p class="stat1"><%= mycslist.FItemList(i).FdivcdName %></p>
                                    <p class="stat2"><%= mycslist.FItemList(i).Fopentitle %></p>
                                </div>
                            </a>
                        </li>
                    <% next %>
                </ul>
                <%=fnDisplayPaging_New(mycslist.FcurrPage,mycslist.FtotalCount,mycslist.FPageSize,4,"goPage")%>
            <% Else %>
                <div class="nodata-list">
                    <h2>반품 신청 가능한 주문 내역이 없습니다.</h2>
                    <p>불량, 파손 등의 반품 문의나 더 궁금하신 사항은<br>1:1 상담을 이용해주세요.</p>
                    <a href="/my10x10/qna/myqnalist.asp" class="btn-counsel">1:1 상담하기</a>
                </div>
            <% End If %>
		</div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%

set mycslist = Nothing

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
