<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  기프트카드 사용내역
' History : 2019-06-21 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<%
dim oGiftcard, currentCash : currentCash = 0
dim userid: userid = getEncLoginUserID ''GetLoginUserID

userid = getEncLoginUserID

dim vIsOnOff

vIsOnOff = requestCheckVar(request("isonoff"),1)

'// 기프트카드 잔액 확인
set oGiftcard = new myGiftCard
    oGiftcard.FRectUserid = userid
    currentCash = oGiftcard.myGiftCardCurrentCash
set oGiftcard = Nothing
%>
<script>
var isloading=true;

$(function(){
	getList();

	//스크롤 이벤트 시작
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 350){
          if (isloading==false){
            isloading=true;
			var pg = $("#giftfrm input[name='cpg']").val();
            pg++;
			$("#giftfrm input[name='cpg']").val(pg);
            setTimeout("getList()",500);
          }
      }
    });
    $(".grid2 li").click(function(){
        $(".grid2 li a").removeClass('on')
        $('a', this).addClass('on')
        $('#lySearchResult').empty()
        $("#giftfrm input[name='cpg']").val(1);
        $("#giftfrm input[name='isonoff']").val($(this).attr("tab"));        
        getList();            
    })
});
function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/my10x10/giftcard/exec/usageHistory_act.asp",
	        data: $("#giftfrm").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#giftfrm input[name='cpg']").val()=="1") {
        	//내용 넣기
        	$('#lySearchResult').html(str);
        } else {
       		$str = $(str)
       		$('#lySearchResult').append($str)
        }
        isloading=false;
    } else {
    	//더이상 자료가 없다면 스크롤 이벤트 종료
    	$(window).unbind("scroll");
    }
}
function linkToUsageNotice(){
    <% if isapp = 1 then %>
        fnAPPpopupBrowserURL('기프트카드 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/giftcard/usageNotice.asp','right','','sc');return false;
    <% else %>
        location.href="/my10x10/giftcard/usageNotice.asp"
    <% end if %>
}
function linkToCardList(){
    <% if isapp = 1 then %>
        fnAPPpopupBrowserURL('기프트카드','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/giftcard/giftCardList.asp','right','','sc');return false;
    <% else %>
        location.href="/my10x10/giftcard/giftCardList.asp";
    <% end if %>
}
function linkRegistCard(){
    <% if isapp = 1 then %>
        fnAPPpopupBrowserURL('카드등록','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/giftcard/giftcardRegist.asp','right','','sc');return false;
    <% else %>
        location.href="/my10x10/giftcard/giftcardRegist.asp";
    <% end if %>
}
function linkBarcode(){
    <% if isapp = 1 then %>
        fnAPPpopupBrowserURL('바코드','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/giftcard/giftcardBarcode.asp');return false;        
    <% else %>
        location.href="/my10x10/giftcard/giftcardBarcode.asp";
    <% end if %>
}
</script>
	<div id="content" class="content my-own-detail giftcard-index">
        <div class="own-info">
            <h2>현재 나의 기프트카드</h2>
            <p><em><%=FormatNumber(currentCash,0)%></em>원</p>
            <div class="btn-group">            
                <a href="javascript:linkToUsageNotice()" class="btn-half">기프트카드  안내</a>
                <a href="javascript:linkToCardList()" class="btn-half">주문&#47;등록 내역</a>
            </div>
            <div class="btn-giftcard">
                <a href="javascript:linkBarcode()">텐바이텐 멤버십카드 보기</a>
            </div>
            <div class="btn-regist">
                <a href="javascript:linkRegistCard()">
                    <span class="icon-plus icon-plus-white"></span>
                </a>
            </div>
        </div>
        <div class="nav nav-stripe nav-stripe-default nav-stripe-red">
            <ul class="grid2">
                <li tab="T"><a href="javascript:void(0)" class="on"><span class="name">온라인</span></a></li>
                <li tab="S"><a href="javascript:void(0)"><span class="name">오프라인 매장</span></a></li>
            </ul>
        </div>
        <div class="own-history">
            <ul id="lySearchResult"></ul>
        </div>
	</div>
    <form id="giftfrm" name="giftfrm" method="get" style="margin:0px;">
        <input type="hidden" name="cpg" value="1" />
        <input type="hidden" name="isonoff" value="T" />
    </form>