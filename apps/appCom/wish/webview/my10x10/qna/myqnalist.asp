<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<% const MenuSelect = "" %>
<!-- #include virtual="/apps/appcom/wish/webview/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/webview/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/myqnacls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/designfingersCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/dfCommentCls.asp" -->
<%
dim page
dim i, j, lp

page = request("page")
if (page = "") then page = 1
        
dim boardqna
set boardqna = New CMyQNA
boardqna.FCurrPage = page
boardqna.FPageSize = 10
boardqna.FScrollCount = 3

if IsUserLoginOK() then
    boardqna.FRectUserID = GetLoginUserID()
elseif IsGuestLoginOK() then
    boardqna.FRectOrderSerial = GetGuestLoginOrderserial()
end if

if (IsUserLoginOK() or IsGuestLoginOK()) then
	boardqna.GetMyQnaList
end if

strPageTitle = "생활감성채널, 텐바이텐 > 1:1 상담"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script>
	function goPage(page){
		location.href = "?page=" + page;
	}

	//qna 삭제
	function DelQna(id){
		if (confirm('삭제 하시겠습니까?\n답변이 완료된 경우 답변까지 삭제됩니다.')){
			document.delfrm.mode.value='DEL';
			document.delfrm.id.value=id;
			document.delfrm.submit();
		}
	}
</script>
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
		<% If  IsGuestLoginOK()  Then %>
		 <!-- #header -->
        <header id="header">
            <div class="tabs type-c">
                <a href="/apps/appcom/wish/webview/my10x10/order/myorderlist.asp">주문배송 조회</a>
                <a href="/apps/appcom/wish/webview/my10x10/qna/myqnalist.asp" class="active">1:1 상담</a>
            </div>
        </header><!-- #header -->
        <div class="well type-b">
            <ul class="txt-list">
				<li>한번 등록한 상담내용은 수정이 불가능합니다. 수정을 원하시는 경우, 삭제 후 재등록 하셔야 합니다.</li>
				<li>1:1 상담은 24시간 신청가능하며 접수된 내용은 빠른 시간내에 답변을 드리도록 하겠습니다.</li>
				<li>문의하신 1:1 상담은 고객님의 메일로도 확인하실 수 있습니다.</li>
				<li>고객행복센터 답변가능시간 : 오전 9시~오후 6시(토/일/공휴일 제외)</li>
            </ul>
        </div>
		<% End If %>

        <!-- #content -->
        <div id="content">
			<form name="delfrm" method="post" action="myqna_process.asp" onsubmit="return false;">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="id" value="">
			</form>

			<% If IsUserLoginOK() Then %>
            <div class="inner">
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label"><%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1 상담</span></h1>
                </div>
            </div>
            <div class="well type-b">
                <ul class="txt-list">
				<li>한번 등록한 상담내용은 수정이 불가능합니다. 수정을 원하시는 경우, 삭제 후 재등록 하셔야 합니다.</li>
				<li>1:1 상담은 24시간 신청가능하며 접수된 내용은 빠른 시간내에 답변을 드리도록 하겠습니다.</li>
				<li>문의하신 1:1 상담은 고객님의 메일로도 확인하실 수 있습니다.</li>
				<li>고객행복센터 답변가능시간 : 오전 9시~오후 6시(토/일/공휴일 제외)</li>
                </ul>
            </div>
			<% End If %>

            <div class="inner">
                <a href="myqnawrite.asp" class="btn type-e full-size"><%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1: 상담 신청하기</a>
            </div>
            <div class="diff"></div>
            <div class="inner"> 
				<% if boardqna.FResultCount < 1 then %>
				<p class="t-c" style="padding:30px 0">문의하신 <%=CHKIIF(IsVIPUser()=True,"VIP","")%> 1:1 상담 내역이 없습니다.</p>
				<% Else %>
                <ul class="inquiry-list">
					<% for i = 0 to (boardqna.FResultCount - 1) %>
                    <li class="bordered-box">
                        <div class="box-meta">
                            <span class="date"><%=Formatdate(boardqna.FItemList(i).Fregdate,"0000.00.00")%></span>
                            <span class="box-title"><strong><%= nl2br(boardqna.FItemList(i).Ftitle) %></strong></span>
                        </div>
                        <div class="qna-box">
                            <div class="q">
                                <div class="qna-type <%=chkiif(boardqna.FItemList(i).Freplyuser <> "","complete","ing")%>"><span class="label"><%=chkiif(boardqna.FItemList(i).Freplyuser <> "","답변완료","답변대기")%></span></div>
                                <div class="qna-meta">
                                    <span class="category"><%= boardqna.code2name(boardqna.FItemList(i).Fqadiv) %></span>
                                </div>
                                <p class="qna-content">
                                    <%= nl2br(boardqna.FItemList(i).Fcontents) %>
                                </p>
	                            <button class="btn type-e small btn-delete" onclick="DelQna('<%= boardqna.FItemList(i).Fid %>');"><i class="icon-trash"></i> 삭제</button>
                            </div>
							<% if (boardqna.FItemList(i).Freplyuser <> "") then %>
                            <div class="a">
                                <div class="qna-type"></div>
                                <p class="qna-content">
                                    <%= nl2br(boardqna.FItemList(i).Freplytitle) %><br><br><%= nl2br(boardqna.FItemList(i).Freplycontents) %>
                                </p>
                            </div>
							<% End If %>
                        </div>
						<% IF boardqna.FItemList(i).Freplydate<>"" and boardqna.FItemList(i).Freplydate>"2008-07-18" Then %>
						<form name="teneval" action="myqna_process.asp" method="post">
						<input type="hidden" name="mode" value="PNT">
						<input type="hidden" name="id" value="<%= boardqna.FItemList(i).Fid %>">     
						<input type="hidden" name="md5key" value="<%'= boardqna.FItemList(i).Fmd5Key %>">
						<input type="hidden" name="evalPoint" value="" id="evalPoint">
						<div class="rating no-border t-c">
							<div class="stars">
								<a href="#" class="<%=chkiif(boardqna.FItemList(i).Fevalpoint="5" Or boardqna.FItemList(i).Fevalpoint="4" Or boardqna.FItemList(i).Fevalpoint="3" Or boardqna.FItemList(i).Fevalpoint="2" Or boardqna.FItemList(i).Fevalpoint="1" ,"active","")%>">★</a>
								<a href="#" class="<%=chkiif(boardqna.FItemList(i).Fevalpoint="5" Or boardqna.FItemList(i).Fevalpoint="4" Or boardqna.FItemList(i).Fevalpoint="3" Or boardqna.FItemList(i).Fevalpoint="2","active","")%>">★</a>
								<a href="#" class="<%=chkiif(boardqna.FItemList(i).Fevalpoint="5" Or boardqna.FItemList(i).Fevalpoint="4" Or boardqna.FItemList(i).Fevalpoint="3","active","")%>">★</a>
								<a href="#" class="<%=chkiif(boardqna.FItemList(i).Fevalpoint="5" Or boardqna.FItemList(i).Fevalpoint="4","active","")%>">★</a>
								<a href="#" class="<%=chkiif(boardqna.FItemList(i).Fevalpoint="5","active","")%>">★</a>
							</div>
							<small>별을 터치하여 별점을 매겨주세요. </small>
							<% IF (boardqna.FItemList(i).FEvalPoint="0" or isnull(boardqna.FItemList(i).FEvalPoint)) Then %>
							 <button class="btn type-b small btn-rating" onclick="teneval.submit();">평가하기</button>
							<% End IF %>
						</div>
						</form>
						<% End If %>
                    </li>
					<% Next %>
                </ul>
				<% End If %>
            </div>
            <div class="pagination">
                <%=fnPaging_Apps("page", boardqna.FtotalCount, boardqna.FcurrPage, boardqna.FPageSize, 10)%>
            </div>
        </div><!-- #content -->
		<script>
			$('.stars a').each(function(index){
				$(this).on('click', function(){
					$('.stars a').addClass('active');
					$('.stars a:gt('+index+')').removeClass('active');
					var rate = index+1;
					console.log(rate);

					$('#evalPoint').attr("value",rate);
					return false;
				});
			});
		</script>

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
        
    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>

<%
	set boardqna = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->