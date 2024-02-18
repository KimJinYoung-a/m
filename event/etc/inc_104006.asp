<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 2020 고민을 들어줘!
' History : 2020-07-01 원승현 생성
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, userApplyCountData, vQuery, i, openStatus, currentStatus, userLastEventApplyDate
dim userOpenData, userEventApplyData, userEventArrayData, itemimage1, itemimage2, userPushCheck

IF application("Svr_Info") = "Dev" THEN
	eCode = "102189"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "104006"
    mktTest = true    
Else
	eCode = "104006"
    mktTest = false
End If

eventStartDate      = cdate("2020-07-06")		'이벤트 시작일
eventEndDate 	    = cdate("2020-07-19")		'이벤트 종료일
LoginUserid		    = getencLoginUserid()
userApplyCountData  = 0                         '사용자별 이벤트 참여 갯수 초기화
userOpenData        = 0                         '사용자별 탭 컨트롤 값 초기화
userPushCheck       = 0                         '사용자 푸시 동의 여부
userEventApplyData  = ""                        '사용자 참여 데이터 초기화
if mktTest then
    '// 테스트용
    currentDate = cdate("2020-07-12")
else
    currentDate = date()
end if

If LoginUserid <> "" Then
    '// 접속한 유저가 참여한 숫자, 마지막 참여일자 가져옴
    vQuery = "SELECT count(*) as cnt, MAX(regdate) as regdate FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&LoginUserid&"' And sub_opt1='evt' "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    IF Not rsget.Eof Then
        userApplyCountData = rsget("cnt")
        userLastEventApplyDate = rsget("regdate")
    End IF
    rsget.close

    '// 사용자가 참여 이력이 있으면
    If userApplyCountData > 0 Then
        '// 현재 일자가 마지막 참여일자보다 크면
        If Trim(Left(currentDate,10)) > Trim(Left(userLastEventApplyDate,10)) Then
            '// 탭 컨트롤을 위해 userOpenData에 값을 넣어준다.
            userOpenData = userApplyCountData
        Else
            '// 탭은 0부터 시작하기 때문에 실제 해당 유저 응모수에 -1을 해준다.
            userOpenData = userApplyCountData - 1
        End If

        '// 사용자 참여 갯수가 5개 이상이면 탭을 가장 마지막에 놔두기 위해 강제로 값을 넣어준다.
        If userOpenData > 4 Then
            userOpenData = 4
        End If
    End If

    '// 사용자의 푸시 수신 허용 여부
    vQuery = "SELECT COUNT(*) FROM [db_contents].[dbo].[tbl_app_reginfo] WITH (NOLOCK) WHERE isusing='Y' AND ISNULL(pushyn,'') <> 'N' AND userid='"&LoginUserid&"' "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    userPushCheck = rsget(0)
    rsget.close
End If
%>
<style type="text/css">
.mEvt104006 {overflow:hidden; position:relative; background:#fff;}
.mEvt104006 button {background:none;}
.mEvt104006 .gomin {padding-top:12%; background:#b8bfff;}
.mEvt104006 .gomin .box {overflow:hidden; width:86.7%; margin:0 auto; background:#fff; border:0.5vw solid #0015b3; border-radius:1.3vw;}
.mEvt104006 .gomin .tab {display:flex; height:17.6vw; border-bottom:0.5vw solid #0015b3;}
.mEvt104006 .gomin .tab button {flex:1; font-size:0; color:transparent; background:#bebebe url(//webimage.10x10.co.kr/fixevent/event/2020/104006/m/txt_tab.png) 0 0 no-repeat; background-size:auto 200%; border-left:0.5vw solid #0015b3;}
.mEvt104006 .gomin .tab button:first-child {border-left:none;}
.mEvt104006 .gomin .tab button:nth-child(2) {background-position-x:25%;}
.mEvt104006 .gomin .tab button:nth-child(3) {background-position-x:50%;}
.mEvt104006 .gomin .tab button:nth-child(4) {background-position-x:75%;}
.mEvt104006 .gomin .tab button:nth-child(5) {background-position-x:100%;}
.mEvt104006 .gomin .tab button.open {background-color:#6575ed;}
.mEvt104006 .gomin .tab button.current {background-position-y:100%;}
.mEvt104006 .gomin .con {display:none; padding-bottom:7%;}
.mEvt104006 .gomin .items {display:flex; justify-content:center; position:relative; text-align:center; background:url(//webimage.10x10.co.kr/fixevent/event/2020/104006/m/txt_click.png) 50% 98% no-repeat; background-size:98% auto;}
.mEvt104006 .gomin .items.selected {background:none;}
.mEvt104006 .gomin .items:before {content:' '; position:absolute; left:0; top:0; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/104006/m/txt_vs.png) 50% 10vw no-repeat; background-size:12vw auto;}
.mEvt104006 .gomin .items .item {flex:1;}
.mEvt104006 .gomin .items.selected .item {background:#fff;}
.mEvt104006 .gomin .items .thumbnail {display:block; width:32vw; height:32vw; margin:0 auto; border-radius:50%;}
.mEvt104006 .gomin .items .thumbnail img {height:100%; border-radius:50%;}
.mEvt104006 .gomin .items .desc {display:block; padding-top:2.4vw; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:4vw; color:#111; opacity:0;}
.mEvt104006 .gomin .items.selected .desc {opacity:1;}
.mEvt104006 .gomin .items .item.on .thumbnail {border:0.8vw solid #ff2020;}
.mEvt104006 .gomin .items .item.on .desc {color:#fe2020;}
.mEvt104006 .btn-push {display:block; width:100%;}
.mEvt104006 .lyr {display:none; position:fixed; top:0; left:0; z-index:10; width:100%; height:100%; background:rgba(0,0,0,0.7);}
.mEvt104006 .lyr-push .inner {display:flex; flex-direction:column; justify-content:center; width:28rem; height:100%; margin:0 auto;}
.mEvt104006 .lyr-gomin .inner {position:absolute; top:50%; left:50%; width:27.8rem; transform:translate(-50%,-50%);}
.mEvt104006 .lyr-gomin .btn-close {position:absolute; top:0; right:0; width:5rem; height:5rem; font-size:0; color:transparent;}
</style>
<script type="text/javascript">
$(function(){
	<%'// 최종 참여 고민 또는 일자가 바뀌면 다음날 표시 해야 될 고민 %>
	$('.mEvt104006 .con').eq(<%=userOpenData%>).show();

	<%'// 탭 클릭 %>
	$('.mEvt104006 .tab button').click(function(e){
		if ( $(this).hasClass('disabled') ) {
			alert('하루에 한 개의 고민만 볼 수 있어요 :)');
		} else {
			$(this).addClass('current').siblings('button').removeClass('current');
			var idx = $(this).index();
			$('.mEvt104006 .con').hide();
			$('.mEvt104006 .con').eq(idx).show();
		}
	});

	<%'// 상품 선택 %>
	$('.mEvt104006 .con .item').click(function(e){
		<%'// 이미 풀었으면 상품 상세로 이동 %>
		var isEnded = $(this).parent('.items').hasClass('selected');
		if ( isEnded ) {
            var itemid = $(e.currentTarget).attr('data-itemid');
            <% If isApp="1" Then %>
                fnAPPpopupProduct(itemid+'&pEtr=<%=eCode%>');
            <% Else %>
                window.open('/category/category_itemPrd.asp?itemid='+itemid+'&pEtr=<%=eCode%>');
            <% End If %>
		} else {
            <% If Not(IsUserLoginOK) Then %>
                <% if isApp=1 then %>
                    calllogin();
                    return false;
                <% else %>
                    jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
                    return false;
                <% end if %>
            <% else %>
                <% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
                    var data={
                        mode: "evt",
                        itemid: $(this).attr("data-itemid"),
                        qnum: $(this).attr("data-num"),
                        subnum: $(this).attr("data-subnum")
                    }
                    $.ajax({
                        type: "GET",
                        url: "/event/etc/doEventSubscript104006.asp",				
                        data: data,
                        cache: false,
                        context: this,
                        success: function(resultData) {
                            var reStr = resultData.split("|");
                            var selCnt;
                            if(reStr[0]=="OK"){
                                fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>');
                                if (reStr[1]>=5) {
                                    $('.lyr-gomin').eq(2).fadeIn();
                                } else {
                                    <% If Left(currentDate,10) > "2020-07-18" Then %>
                                        $('.lyr-gomin').eq(1).fadeIn();
                                    <% Else %>
                                        $('.lyr-gomin').eq(0).fadeIn();                                    
                                    <% End If %>
                                }
                                $(this).addClass('on').siblings('.item').removeClass('on');
                                $(this).parent('.items').addClass('selected');
                                selCnt = parseInt($(this).find('span.cnt').html());
                                $(this).find('span.cnt').empty().html(selCnt+1);
                            }else if(reStr[0]=="Err"){
                                var errorMsg = reStr[1].replace(">?n", "/n");
                                alert(errorMsg);										
                            }			
                        },
                        error: function(err) {
                            console.log(err.responseText);
                        }
                    });
                <% Else %>
                    alert("이벤트 응모 기간이 아닙니다.");
                    return;
                <% End If %>
            <% End If %>
		}
	});
	// 푸시 팝업
	$('#btnPush').click(function(){
        <% If Not(IsUserLoginOK) Then %>
            <% if isApp=1 then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
                return false;
            <% end if %>
        <% else %>
            <% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
                <% If userPushCheck > 0 Then %>
                    var data={
                        mode: "alarm"
                    }
                    $.ajax({
                        type: "GET",
                        url: "/event/etc/doEventSubscript104006.asp",				
                        data: data,
                        cache: false,
                        context: this,
                        success: function(resultData) {
                            var reStr = resultData.split("|");
                            if(reStr[0]=="OK"){
                                $('#lyrPush').fadeIn();
                            }else if(reStr[0]=="Err"){
                                var errorMsg = reStr[1].replace(">?n", "/n");
                                alert(errorMsg);										
                            }			
                        },
                        error: function(err) {
                            console.log(err.responseText);
                        }
                    });
                <% Else %>
                    $('#lyrPush').fadeIn();
                <% End If %>
            <% Else %>
                alert("이벤트 응모 기간이 아닙니다.");
                return;
            <% End If %>
        <% End If %>                        
	});
	// 팝업 닫기
	$('.mEvt104006 .btn-close').click(function(){
		$('.mEvt104006 .lyr').fadeOut();
	});
});

// 푸시 설정
function fnCheckAlarmPopup() {
	$('#lyrPush').fadeOut();
	fnAPPpopupSetting();
	return false;
}
</script>

<%' MKT 연속 로그인 104006 (7/6 ~ 7/19) %>
<div class="mEvt104006">
    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/104006/m/tit_gomin.jpg" alt="고민을 들어줘"></h2>
    <div class="gomin">
        <div class="box">
            <div class="tab">
                <%' for dev msg : 참여 열린 탭 open / 현재 탭 current / 아직 안 열린 탭 disabled (alert용) %>
                <% for i = 0 To 4 %>
                    <% 
                        '// 사용자가 참여한 수보다 크거나 같으면 오픈처리 아니면 disabled 처리
                        If userOpenData >= i Then
                            openStatus = "open"
                        Else
                            openStatus = "disabled"
                        End If

                        '// 오늘일자 기준으로 참여했거나 참여해야될 탭에 current 처리
                        If userOpenData = i Then
                            currentStatus = "current"
                        Else
                            currentStatus = ""
                        End If
                    %>
                    <button type="button" class="<%=openStatus&" "&currentStatus%>"><%=i+1%>번째</button>
                <% next %>
            </div>
            <%
                '<!-- for dev msg : 고민 txt_gomin_01~05.png
                    '상품코드
                    '1번째 고민		2882149		2778447
                    '2번째 고민		2901865		2377341
                    '3번째 고민		2527576		2933939
                    '4번째 고민		2938050		2081738
                    '5번째 고민		2934654		2100756 
                '-->
                vQuery = "SELECT w.idx, w.evt_code, w.qnum, w.data_itemid1, w.data_itemid1Count "
                vQuery = vQuery & " , w.data_itemid2, w.data_itemid2Count, w.lastupdate "
                vQuery = vQuery & " , e.userid, e.sub_opt2, e.sub_opt3 "
                vQuery = vQuery & " , (SELECT TOP 1 basicimage FROM [db_item].[dbo].[tbl_item] WITH (NOLOCK) WHERE itemid = w.data_itemid1) AS itemimage1 "
                vQuery = vQuery & " , (SELECT TOP 1 basicimage FROM [db_item].[dbo].[tbl_item] WITH (NOLOCK) WHERE itemid = w.data_itemid2) AS itemimage2 "
                vQuery = vQuery & " FROM [db_temp].[dbo].[tbl_worryEventData] w WITH (NOLOCK) "
                vQuery = vQuery & " LEFT JOIN [db_event].[dbo].[tbl_event_subscript] e WITH (NOLOCK) "
                vQuery = vQuery & " ON w.evt_code = e.evt_code AND w.qnum = e.sub_opt2 AND e.sub_opt1 = 'evt' AND e.userid = '"&LoginUserid&"' "
                vQuery = vQuery & " WHERE w.evt_code = '" & eCode & "' "
                rsget.CursorLocation = adUseClient
                rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
                If Not(rsget.bof Or rsget.eof) Then
                    Do Until rsget.eof
            %>
                        <div class="con">
                            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/104006/m/txt_gomin_0<%=rsget("qnum")%>.png" alt="고민 <%=rsget("qnum")%>"></p>
                            <%'<!-- for dev msg : 참여 완료 상태일 때 클래스 selected -->%>
                            <div class="items<% If Trim(rsget("sub_opt3")) <> "" Then %> selected<% End IF %>">
                                <%'<!-- for dev msg : 선택된 item 클래스 on (data-itemid 에 상품코드) -->%>
                                <button type="button" class="item<% If Trim(rsget("data_itemid1")) = Trim(rsget("sub_opt3")) Then %> on<% End If %>" data-itemid="<%=rsget("data_itemid1")%>" data-num="<%=rsget("qnum")%>" data-subnum="1">
                                    <span class="thumbnail"><img src="//webimage.10x10.co.kr/image/basic/<%=GetImageSubFolderByItemid(Trim(rsget("data_itemid1")))%>/<%=rsget("itemimage1")%>" alt=""></span>
                                    <span class="desc"><span class="cnt"><%=rsget("data_itemid1Count")%></span>명</span>
                                </button>
                                <button type="button" class="item<% If Trim(rsget("data_itemid2")) = Trim(rsget("sub_opt3")) Then %> on<% End If %>" data-itemid="<%=rsget("data_itemid2")%>" data-num="<%=rsget("qnum")%>" data-subnum="2">
                                    <span class="thumbnail"><img src="//webimage.10x10.co.kr/image/basic/<%=GetImageSubFolderByItemid(Trim(rsget("data_itemid2")))%>/<%=rsget("itemimage2")%>" alt=""></span>
                                    <span class="desc"><span class="cnt"><%=rsget("data_itemid2Count")%></span>명</span>
                                </button>
                            </div>
                        </div>
            <%
                    rsget.movenext
                    loop
                End If
                rsget.close
            %>
        </div>
        <%'!-- 선물의 참견 이동 링크 -->%>
        <a href="/gift/gifttalk/" target="_blank" class="mWeb">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/104006/m/btn_go.jpg" alt="선물의 참견">
        </a>
        <a href="" onclick="fnAPPpopupBrowserURL('기프트','<%=wwwUrl%>/apps/appCom/wish/web2014/gift/gifttalk/index.asp','right','','sc');return false;" class="mApp">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/104006/m/btn_go.jpg" alt="선물의 참견">
        </a>
    </div>

    <%'!-- 참여시 팝업 1. 7/18 까지, 즉, 7월 18일까지 참여한 모든 사람에게 보여주는 팝업 -->%>
    <div id="" class="lyr lyr-gomin" style="display:;">
        <div class="inner">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/104006/m/pop_gomin_ing.png?v=1.0" alt="">
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>

    <%'<!-- 참여시 팝업 2. 7/19 (실패), 즉, 마지막날 5번째 까지 완료되지 않은 사람에게 보여줌 -->%>
    <div id="" class="lyr lyr-gomin" style="display:;">
        <div class="inner">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/104006/m/pop_gomin_fail.png" alt="">
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>

    <%'<!-- 참여시 팝업 3. 참여 완료 (성공), 7월 19일 이전까지 5번째 까지 완료되었으면 해당 팝업 노출 -->%>
    <div id="" class="lyr lyr-gomin" style="display:;">
        <div class="inner">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/104006/m/pop_gomin_fin.png" alt="">
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>

    <% If isApp="1" Then %>
    <%'<!-- 푸시 알림 신청 -->%>
    <button type="button" id="btnPush" class="btn-push">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/104006/m/btn_push.jpg" alt="알림 신청하기">
    </button>

    <%'<!-- 푸시 팝업 -->%>
    <div id="lyrPush" class="lyr lyr-push">
        <div class="inner">
            <% If userPushCheck > 0 Then %>
                <%'<!-- 로그인 + 푸시 수신 동의자 -->%>
                <button type="button" class="btn-close"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104006/m/pop_push_fin.png" alt="완료"></button>
            <% Else %>
                <%'<!-- 로그인 + 푸시 수신 비동의자 -->%>
                <button type="button" onclick="fnCheckAlarmPopup();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104006/m/pop_push_set.png" alt="설정"></button>
            <% End If %>
        </div>
    </div>
    <% End If %>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/104006/m/txt_noti.jpg" alt="유의사항"></p>
</div>
<%'<!-- // MKT 연속 로그인 104006 -->%>
<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.5"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->