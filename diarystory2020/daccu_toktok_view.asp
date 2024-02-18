<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리 스토리 2020 다꾸톡톡 보기
' History : 2019-09-05 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2020/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2020/lib/classes/daccutoktokCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
    Dim userid, referer, refip, masterIdx, i

    referer = request.ServerVariables("HTTP_REFERER")
    refip = request.ServerVariables("REMOTE_ADDR")

    if InStr(referer,"10x10.co.kr")<1 Then
        'Response.Write "<script>alert('잘못된 접속입니다.');history.back();</script>"
        'Response.End
    end If

    masterIdx = request("masterIdx")

    '// viewCountUpdate
    Dim oDaccuTalkViewCount
    set oDaccuTalkViewCount = new CDaccuTokTok
    oDaccuTalkViewCount.FRectMasterIdx = masterIdx
    oDaccuTalkViewCount.UpdDaccuTokTokUserMaster

    '// 사용자 작성 정보
    Dim oDaccuTalkMasterOne
    set oDaccuTalkMasterOne = new CDaccuTokTok
    oDaccuTalkMasterOne.FRectMasterIdx = masterIdx
    oDaccuTalkMasterOne.GetDaccuTokTokUserMasterOne

    '// 사용자 작성 상품 리스트
    Dim oDaccuTalkDetailList
    set oDaccuTalkDetailList = new CDaccuTokTok
    oDaccuTalkDetailList.FRectMasterIdx = masterIdx
    oDaccuTalkDetailList.GetDaccuTokTokDetailUserList
%>

<link rel="stylesheet" type="text/css" href="/lib/css/diary2020.css?v=1.17" />
<script type="text/javascript" src="/lib/js/iscroll.js"></script>
<script type="text/javascript">

    var myScroll;
    var vScrl=true;

    function loaded() {
        myScroll = new iScroll('scrollarea', {
            onBeforeScrollStart: function (e) {
                var target = e.target;
                while (target.nodeType != 1) target = target.parentNode;
            }
        });
    }
    document.addEventListener('touchmove', function (e) { 
        e.preventDefault();
    }, false);
    document.addEventListener('DOMContentLoaded', function () { 
        setTimeout(loaded, 200);
    }, false);

    $(function() {
        // 태그 위치
        function posTag() {
            $('.mark').each(function () {
                var posX = Math.floor($(this).css('left').replace('px', ''));
                var imgW = $("div").outerWidth();
                var calcX = Math.floor(posX / imgW * 100);
                if (calcX > 50) {
                    $(this).find('.box').addClass('l-dir');
                } else {
                    $(this).find('.box').addClass('r-dir');
                }
            });
        }

        // 클릭시 태그 노출
        $('.dctem-thumb img').click(function (e) {
            var markList= $('.mark-list');
            $(markList).toggleClass('on');
            if(markList.hasClass('on')){
                posTag();
            }
        });
    });

</script>

</head>        
<div class="layerPopup default-font">
    <header class="tenten-header header-popup">
        <div class="title-wrap">
            <h1>다꾸톡톡 보기</h1>
            <button type="button" class="btn-close" onclick="fnCloseModal();">닫기</button>
        </div>
    </header>
    <div id="layerScroll">
        <div class="scroll" id="scrollarea">
            <div class="layerCont diary-sub">
                <div class="talk talk-view">
                    <!-- 다꾸템 이미지 -->
                    <div class="dctem-top">
                        <div class="dctem-thumb">
                            <img src="<%=oDaccuTalkMasterOne.FOneItem.FUserMasterImage%>" alt="">
                            <ul class="mark-list">
                                <% If oDaccuTalkDetailList.FResultCount > 0 Then  %>
                                    <% FOR i = 0 to oDaccuTalkDetailList.FResultCount-1 %>
                                        <li class="mark" style="top:<%=oDaccuTalkDetailList.FItemList(i).FUserDetailYValue%>%; left:<%=oDaccuTalkDetailList.FItemList(i).FUserDetailXValue%>%;">
                                            <% If isApp="1" Then %>
                                                <a href="" onclick="fnAPPpopupProduct('<%=oDaccuTalkDetailList.FItemList(i).FUserDetailItemID%>');return false;">
                                            <% Else %>
                                                <a href="/category/category_itemprd.asp?itemid=<%=oDaccuTalkDetailList.FItemList(i).FUserDetailItemID%>" target="_blank">
                                            <% End If %>
                                                <i class="ico-plus"></i>
                                                <div class="box">
                                                    <p class="name ellipsis"><%=oDaccuTalkDetailList.FItemList(i).FUserDetailItemName%></p>
                                                </div>
                                            </a>
                                        </li>
                                    <% Next %>
                                <% End If %>
                            </ul>
                        </div>
                    </div>

                    <%' 다꾸템 텍스트 %>
                    <div class="dctem-conts">
                        <div class="dctem-head">
                            <h2><%=oDaccuTalkMasterOne.FOneItem.FUserMasterTitle%></h2>
                            <p class="user-id"><%=printUserId(oDaccuTalkMasterOne.FOneItem.FUserMasterUserId,2,"*")%></p>
                        </div>
                        <ul class="dctem-list">
                            <% If oDaccuTalkDetailList.FResultCount > 0 Then  %>
                                <% FOR i = 0 to oDaccuTalkDetailList.FResultCount-1 %>
                                    <li>
                                        <% If isApp="1" Then %>
                                            <a href="" onclick="fnAPPpopupProduct('<%=oDaccuTalkDetailList.FItemList(i).FUserDetailItemID%>');return false;">
                                        <% Else %>
                                            <a href="/category/category_itemprd.asp?itemid=<%=oDaccuTalkDetailList.FItemList(i).FUserDetailItemID%>" target="_blank">
                                        <% End If %>
                                            <div class="item-wrap">
                                                <span class="thumbnail"><img src="<%=oDaccuTalkDetailList.FItemList(i).FUserDetailListImage120%>?cmd=thumbnail&w=400&h=400&fit=true&ws=false" alt=""></span>
                                                <div class="desc">
                                                    <div class="name"><%=oDaccuTalkDetailList.FItemList(i).FUserDetailItemName%></div>
                                                    <div class="brand"><%=oDaccuTalkDetailList.FItemList(i).FUserDetailBrandName%></div>
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                <% Next %>
                            <% End If %>
                        </ul>
                    </div>
                </div>                    
            </div>
        </div>
    </div>
</div>
</body>
</html>
<%
    Set oDaccuTalkViewCount = Nothing
    Set oDaccuTalkMasterOne = Nothing
    Set oDaccuTalkDetailList = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->