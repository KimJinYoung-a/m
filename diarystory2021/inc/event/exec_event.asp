<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 2021 이벤트 리스트
' History : 2020-08-27 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/diarystory2021/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls_B.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<%
dim selOp, scType, CurrPage, mktevent, i
scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
CurrPage 	= requestCheckVar(request("cpg"),9)
if CurrPage="" then CurrPage=1
set mktevent = new cdiary_list
    mktevent.fnGetDiaryMKTEvent
%>
<script>
var _vPg=1, _vScrl=true;
var _scType="";
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(_vScrl) {
                if(_scType!="P"){
                    _vScrl = false;
                    _vPg++;
                    $.ajax({
                        url: "/diarystory2021/api/diaryevent.asp?scT="+_scType+"&cpg="+_vPg,
                        cache: false,
                        success: function(message) {
                            if(message!="") {
                                $("#mdevt").append(message);
                                _vScrl=true;
                            } else {
                                $(window).unbind("scroll");
                            }
                        }
                        ,error: function(err) {
                            alert(err.responseText);
                            $(window).unbind("scroll");
                        }
                    });
                }
			}
		}
	});
    fnSortView('all');
});

function fnSortView(scType){
    _scType=scType;
        $.ajax({
            url: "/diarystory2021/api/diaryevent.asp?scT=" + _scType + "&cpg=1",
            cache: false,
            success: function(message) {
                if(message!="") {
                    $("#mdevt").empty().append(message);
                    _vScrl=true;
                } else {
                    $(window).unbind("scroll");
                }
            }
            ,error: function(err) {
                alert(err.responseText);
                $(window).unbind("scroll");
            }
        });
        if(_scType=="all"){
            $("#mktevt").show();
        }
        else{
            $("#mktevt").hide();
        }
        $('#all').removeClass('on');
        $('#sale').removeClass('on');
        $('#gift').removeClass('on');
        $('#ips').removeClass('on');
        $('#'+scType).addClass('on');
        _vPg=1;
}
</script>
<div id="content" class="content diary2021 dr_list_evt">
	<!-- for dev msg 기획전('주목해야 할 기획전') 클릭시 노출 페이지 -->
	<section class="dr_top">
		<header class="sect_head">
			<h2 class="ttl">주목해야 할<br/>기획전</h2>
		</header>
		<div class="cate_evt">
			<ul>
                <li id="all"><a href="javascript:fnSortView('all');">전체</a></li>
				<li id="sale"><a href="javascript:fnSortView('sale');">할인이벤트</a></li>
				<li id="gift"><a href="javascript:fnSortView('gift');">사은이벤트</a></li>
				<li id="ips"><a href="javascript:fnSortView('ips');">참여이벤트</a></li>
			</ul>
		</div>
	</section>
	<!-- 기획전 리스트 (무한 스크롤) -->
	<section class="sect_evt" id="mktevt">
        <% if mktevent.FOneItem.FEvt_code<>"" then %>
        <!-- mkt -->
		<article class="dr_evt_item dr_evt_mkt">
			<figure class="dr_evt_img"><img src="<%=mktevent.FOneItem.FEvt_bannerimg%>" alt=""></figure>
			<div class="dr_evt_info">
				<div class="dr_evt_badge">
					<span class="badge_type1">쇼핑꿀팁</span>
				</div>
				<p class="dr_evt_name"><%=mktevent.FOneItem.FEvt_name%></p>
			</div>
            <% if isapp = 1 then %>
                <a href="javascript:fnAPPpopupEvent('<%=mktevent.FOneItem.FEvt_code%>');" class="dr_evt_link">
            <% else %>
                <a href="/event/eventmain.asp?eventid=<%=mktevent.FOneItem.FEvt_code%>" class="dr_evt_link">
            <% end if %>
			<span class="blind">이벤트바로가기</span></a>
		</article>
        <% end if %>
    </section>
    <section class="sect_evt" id="mdevt"></section>
</div>
<%
set mktevent = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->