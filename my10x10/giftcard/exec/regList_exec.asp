<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  기프트카드 등록내역
' History : 2019-06-21 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<script type="text/javascript">
$(function(){
	//첫페이지 접수
	getList();

	//스크롤 이벤트 시작
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 350){
          if (isloading==false){
            isloading=true;
			var pg = $("#regfrm input[name='cpg']").val();
			pg++;
			$("#regfrm input[name='cpg']").val(pg);
            setTimeout("getList()",500);
          }
      }
    });
});
function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/my10x10/giftcard/exec/regList_act.asp",
	        data: $("#regfrm").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#regfrm input[name='cpg']").val()=="1") {
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
    <div class="own-history">                    
        <ul id="lySearchResult"></ul>                                        
    </div>
    <form id="regfrm" name="regfrm" method="get" style="margin:0px;">
        <input type="hidden" name="cpg" value="1" />				            														
    </form>	                
