<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls106513.asp" -->
<%
'####################################################
' Description : 19주년 이벤트 - 비밀의 책
' History : 2020.10.20 이종화
'####################################################
%>
<style>
.body-sub .content {padding-bottom:0;}
.mEvt106513 .topic,
.mEvt106513 .btn-try {background-color:#ffb841;}

.mEvt106513 .winner {background-color:#ffe2a7;}
.mEvt106513 .winner .rank-list {position:relative; width:89.33%; margin:0 auto; padding:2.43rem 0 1.58rem; background-color:#fff; border-radius:.85rem;}
.mEvt106513 .winner .rank-list table {position:relative; z-index:2; width:100%; text-align:center;}
.mEvt106513 .winner .rank-list th {padding-bottom:1.28rem; font-size:1.45rem; color:#f3a511; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt106513 .winner .rank-list td {padding:.85rem 0; font-size:1.45rem; color:#ff601b; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt106513 .winner .rank-list td:first-child {color:#000;}
</style>
<script>
$(function() {
    getWinners();
});

function getWinners(){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/RealtimeEvent106513Proc.asp",
		dataType: "JSON",
		data: { mode: "winnerrank" },
		success : function(res){
			renderWinners(res.data)
		},
		error:function(err){
			alert("잘못된 접근 입니다.[0]");
			return false;
		}
	});
}

function printUserName(name, num, replaceStr){
	<% if GetLoginUserLevel = "7" then %>
		return name
	<% else %>
		return name.substr(0,name.length - num) + replaceStr.repeat(num)
	<% end if %>
}

function renderWinners(data){
    var $rootEl = $("#winners");
    var itemEle = tmpEl = ""
    $rootEl.empty();

    var i = 0;
    data.forEach(function(winner){
        tmpEl = '<tr>\
                    <td>'+ winner.ranking +'</td>\
                    <td>'+ printUserName(winner.userid, 2, "*") +'님' +'</td>\
                    <td>'+ winner.code +'</td>\
                </tr>\
        '
        itemEle += tmpEl
        i += 1
    })

    if ( i < 5 ) {
        for( ii = i ; ii < 5 ; ii++) {
            tmpEl = '<tr>\
                    <td>'+ parseInt(ii+1) +'</td>\
                    <td>-</td>\
                    <td>-</td>\
                </tr>'
            
            itemEle += tmpEl
        }
    }
    
    $rootEl.append(itemEle);
}
</script>
<div class="mEvt106513">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/tit_book_mw.jpg" alt="비밀의 책"></h2>
        <a href="https://tenten.app.link/xWxpndSwzab?%24deeplink_no_attribution=true"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/btn_install.jpg" alt="APP 다운받고 참여하기"></a>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/txt_info_mw_v2.jpg" alt="이벤트 정보"></div>
    </div>

    <%'1등 당첨 리스트 %>
    <div class="winner">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/tit_rank.jpg" alt="나의 순위는?"></h3>
        <div class="rank-list">
            <table>
                <colgroup>
                    <col width="33.33%">
                    <col width="*">
                    <col width="33.33%">
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">순위</th>
                        <th scope="col">아이디</th>
                        <th scope="col">캐릭터 개수</th>
                    </tr>
                </thead>
                <tbody id="winners"></tbody>
            </table>
        </div>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/txt_caution.jpg" alt=""></p>
    </div>

    <div class="notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/txt_noti_v2.jpg" alt="유의사항"></div>
    <a href="/event/19th/">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/bnr_19th.jpg" alt="19주년">
    </a>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->