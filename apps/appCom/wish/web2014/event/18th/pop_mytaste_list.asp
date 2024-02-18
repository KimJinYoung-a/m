<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 18주년 메인 취향 이벤트 나의 취향 리스트
' History : 2019-09-26 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/18th/lib/classes/tasteCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
    If Not(IsUserLoginOK()) Then
        response.write "<script>alert('로그인 후 확인하실 수 있는 페이지 입니다.');fnAPPclosePopup();</script>"
        response.end
    End If

    Dim todayDate : todayDate = Left(now(), 10) '// 오늘일자

    Dim loginUserId, i
    '// 사용자 아이디
    loginUserId = getEncLoginUserId

    dim oTasteMyHistory
    set oTasteMyHistory = new CTaste
    oTasteMyHistory.FRectUserID = LoginUserid
    oTasteMyHistory.GetTasteUserHistoryList

%>
<script type="text/javascript">
    function fnMyTasteInputMove(cdt) {
        fnAPPopenerJsCallClose("fnMyTasteHistoryParent('"+cdt+"')");
        return false;
    }
</script>
</head>
<body class="default-font body-popup diary2020">
    <%' contents %>
    <div id="content" class="content anniversary18th pop-taste-history" >
        <!-- #include virtual="/event/18th/lib/head18th.asp" -->
        <div class="inner">
            <div class="headline">
                <h2><span class="name"><%=getLoginUserName%></span>님의 취향 일기</h2>
                <span class="sub">매일 참여 하지 않았어도 괜찮아요.<br/>빈 곳을 클릭해서 당신의 취향을 완성하세요.</span>
            </div>
            <div class="gift">
                <strong>GIFT</strong>
                <div>30개의 취향을 모두 등록해주신 분 중 <strong>10명에게 텐바이텐 기프트카드 100만원</strong>을 선물로 드립니다.</div>
            </div>
        </div>
        <ul class="my-history">
            <%' for dev msg 취향선택 했을 경우 : selcted / 선택하지 않았을 경우 : not-selcted / 오픈되지 않았을 경우 : coming-selct %>
            <% If oTasteMyHistory.FResultCount > 0 Then  %>
                <% FOR i = 0 to oTasteMyHistory.FResultCount-1 %>
                    <%
                        Dim viewLiOpenStatusClass, chasuToDate
                        chasuToDate = CDate(Left(oTasteMyHistory.FItemList(i).Fchasu, 4)&"-"&mid(oTasteMyHistory.FItemList(i).Fchasu, 5, 2)&"-"&Right(oTasteMyHistory.FItemList(i).Fchasu, 2))
                        'response.write datediff("d",chasuToDate, todayDate)
                        'response.write oTasteMyHistory.FItemList(i).FDetailIdx&"TT"
                        IF oTasteMyHistory.FItemList(i).FDetailIdx = "" Or ISNULL(oTasteMyHistory.FItemList(i).FDetailIdx) Or oTasteMyHistory.FItemList(i).FDetailIdx="0" Then
                            viewLiOpenStatusClass = "not-selcted"
                        Else
                            viewLiOpenStatusClass = "selcted"
                        End If

                        If datediff("d",chasuToDate, todayDate) < 0 Then
                            viewLiOpenStatusClass = "coming-selct"
                        End If
                    %>
                    <% Select Case Trim(viewLiOpenStatusClass) %>
                        <% Case "selcted" %>
                            <li class="<%=viewLiOpenStatusClass%>">
                                <%' for dev msg 상품 상세로 이동 , thumbnail : 320*320 %>
                                <a href="" onclick="fnAPPpopupProduct('<%=oTasteMyHistory.FItemList(i).FDetailItemId%>');return false;">
                                    <span class="thumbnail"><img src="<%=oTasteMyHistory.FItemList(i).FBasicImage%>?cmd=thumb&w=320&h=320&fit=true&ws=false" alt=""></span>
                                </a>
                                <div class="series">
                                    <span class="series-num"><%=Right(oTasteMyHistory.FItemList(i).Fchasu, 2)%></span><span class="series-item"><%=oTasteMyHistory.FItemList(i).FMainKeyWord%></span>
                                </div>
                            </li>
                        <% Case "not-selcted" %>
                            <li class="not-selcted">
                                <span class="thumbnail">
                                    <%' for dev msg 해당 참여 페이지로 이동 %>
                                    <!--a href="" onclick="fnAPPselectGNBMenu('taste','<%=wwwUrl%>/apps/appCom/wish/web2014/event/18th/?currentdate=<%=chasuToDate%>');return false;"-->
                                    <a href="" onclick="fnMyTasteInputMove('<%=chasuToDate%>');return false;">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_dashed1.png" alt="">
                                        <button class="btn-selct"><i class="icon-cross"></i><span>취향이 궁금해요</button>
                                    </a>
                                </span>
                                <div class="series"><span class="series-num"><%=Right(oTasteMyHistory.FItemList(i).Fchasu, 2)%></span><span class="series-item"><%=oTasteMyHistory.FItemList(i).FMainKeyWord%></span></div>
                            </li>                
                        <% Case "coming-selct" %>
                            <li class="coming-selct">
                                <span class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_dashed1.png" alt=""></span>
                                <div class="series"><span class="series-num"><%=Right(oTasteMyHistory.FItemList(i).Fchasu, 2)%></span><span class="series-item"></span></div>
                            </li>                        
                        <% Case Else %>
                            <li class="coming-selct">
                                <span class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_dashed1.png" alt=""></span>
                                <div class="series"><span class="series-num"><%=Right(oTasteMyHistory.FItemList(i).Fchasu, 2)%></span><span class="series-item"></span></div>
                            </li>                            
                    <% End Select %>
                <% Next %>
            <% End if %>
        </ul>
        <%' 토스트 팝업 %>
        <div class="bnr-evtV19 evt-toast3">
            <a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97629');return false;">APP 알림 켜고 나의 취향 알림 받기 <span class="icon-chev"></span></a>
        </div>
        <div id="gotop" class="btn-top"><button type="button">맨위로</button></div>
    </div>
	<!-- //contents -->
</body>
</html>
<%
	Set oTasteMyHistory = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->