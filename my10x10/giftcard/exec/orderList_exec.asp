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
<script type="text/javascript">
function linkToDetail(idx){
    var link
    <% if isapp = 1 then %>
        link = "/apps/appCom/wish/web2014/my10x10/giftcard/giftcardOrderDetail.asp?idx="+idx
    <% else %>
        link = "/my10x10/giftcard/giftcardOrderDetail.asp?idx="+idx
    <% end if %>
    location.href = link;
}
$(function(){
	//첫페이지 접수
	getList();

	//스크롤 이벤트 시작
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 350){
          if (isloading==false){
            isloading=true;
			var pg = $("#orderfrm input[name='cpg']").val();
			pg++;
			$("#orderfrm input[name='cpg']").val(pg);
            setTimeout("getList()",500);
          }
      }
    });
});
function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/my10x10/giftcard/exec/orderList_act.asp",
	        data: $("#orderfrm").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#orderfrm input[name='cpg']").val()=="1") {
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
</script>
    <div class="myOrderMain">                    
        <ul class="myOdrList" id="lySearchResult"></ul>                                        
    </div>
    <form id="orderfrm" name="orderfrm" method="get" style="margin:0px;">
        <input type="hidden" name="cpg" value="1" />				            														
    </form>	                
