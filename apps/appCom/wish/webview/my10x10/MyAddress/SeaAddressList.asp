<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/orderCls/clsMyAddress.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/lib/util/pageformlib.asp" -->
<%
Dim openerYN	: openerYN	= req("openerYN","N")

Dim tabListURL	: tabListURL = "popOldAddressList.asp"
Dim conListURL	: conListURL = "popSeaAddressList.asp"
Dim conSaveURL	: conSaveURL = "popSeaAddressSave.asp"
Dim conProcURL	: conProcURL = "popAddressProc.asp"

Dim i

Dim page		: page			= req("page",1)

Dim qString
qString = "openerYN=" & openerYN
conProcURL = conProcURL & "?" & qString & "&page=" & page
conSaveURL = conSaveURL & "?" & qString & "&page=" & page
conListURL = conListURL & "?" & qString
tabListURL = tabListURL & "?" & qString
    
Dim obj	: Set obj = new clsMyAddress

obj.CurrPage	= page

obj.GetList "", ""

strPageTitle = "생활감성채널, 텐바이텐 > 나의 주소록:해외 주소록"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script>
	function jsDelete(idx) {
		if (confirm("이 주소를 삭제하시겠습니까?")) {
			location.href = "<%=conProcURL%>&mode=DEL&openerYN=N&idx=" + idx;
		}
	}

	function popMyAddress(url) {
		location.href = url;
	}

	// 페이지 이동
	function goPage(pg){
		var frm = document.frmsearch;
		frm.page.value=pg;
		frm.submit();
	}
</script>
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
        <!-- #header -->
        <header id="header">
            <div class="tabs type-c">
                <a href="MyAddressList.asp">국내 주소록</a>
                <a href="SeaAddressList.asp" class="active">해외 주소록</a>
            </div>
        </header><!-- #header -->

        <!-- #content -->
        <div id="content">
			<form name="frmsearch" method="post" action="SeaAddressList.asp">
			<input type="hidden" name="page" value="1">
			</form>
            <div class="inner">
                <div class="main-title">
                    <h1 class="title"><span class="label">나의 해외  주소록 </span></h1>
                </div>
            </div>
            <div class="well filled">
                <ul class="txt-list">
                    <li>자주 사용하시는 배송지를 주소록에 등록해두면 편리합니다.</li>
                    <li>10개까지 주소록을 등록하실 수 있습니다. </li>
                </ul>
            </div>
            <div class="inner">
			<%If UBound(obj.Items) = 0 Then %>
				<div class="no-data">등록하신 주소록이 없습니다.</div>
			<%Else%>
                <ul class="address-list">
					<%For i = 1 To UBound(obj.Items) %>
                    <li class="bordered-box">
                        <h3 class="address-title">
                            <%=obj.Items(i).reqPlace%> 
                        </h3>
                        <div class="address-info">
                            <p class="name">
                                <%=obj.Items(i).reqName%>
                            </p>
                            <p class="phone">
                                <%=obj.Items(i).reqPhone%>
                            </p>
                            <p class="address">
                                <%=obj.Items(i).countryNameEn%><br><%=obj.Items(i).reqZipaddr%><br><%=obj.Items(i).reqAddress%>
                            </p>
                            <div class="actions">
                                <button class="btn type-e small" onclick="popMyAddress('<%=conSaveURL%>&idx=<%=obj.Items(i).idx%>&openerYN=N');">수정</button>
                                <button class="btn type-e small" onclick="jsDelete(<%=obj.Items(i).idx%>);"><i class="icon-trash"></i>삭제</button>
                            </div>
                        </div>
                    </li>
					<%Next%>
                </ul>
            <%End If%>

                <div class="clear"></div>
				<%= fnDisplayPaging_New(page, obj.TotalCount, obj.PageSize, obj.PageBlock,"goPage") %>
                <div class="diff"></div>

            </div>
            <div class="form-actions highlight">
                <button class="btn type-a full-size" onclick="popMyAddress('<%=conSaveURL%>&openerYN=N');">해외 주소록 신규등록</button>
            </div>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
        
    </div><!-- wrapper -->

	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<%
Set obj = Nothing 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->