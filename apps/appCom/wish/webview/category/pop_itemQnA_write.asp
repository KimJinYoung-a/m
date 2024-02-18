<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 상품문의하기
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim itemid, page, IX, i, LoginUserid
	itemid = requestCheckVar(request("itemid"),16)

LoginUserid = getLoginUserid()

if itemid="" then itemid="0"

'상품기본정보 접수
dim oItem, ItemContent
set oItem = new CatePrdCls
	oItem.GetItemData itemid

if oItem.FResultCount=0 then
	Call Alert_Return("존재하지 않는 상품입니다.")
	response.End
end if
%>

<script type="text/javascript">

	$(document).ready(function(){
		//close
		$('#modalCont .modal .btn-close').one('click', function(){
			$("#modalCont").fadeOut();
			$('body').css({'overflow':'auto'});
			clearInterval(loop);
			loop = null;
			return false;
		});
	});
	
	function jsCheckLimit() {
		if ("<%=IsUserLoginOK%>"=="False") {
			alert('로그인을 해주세요.');
			return;
		}
	}

	// 상품 문의 등록
	function GotoItemQnA(){
		var frm = document.qnaform;

		if((frm.emailok.checked)&&(!validEmail(frm.usermail))){
			return false;
		}
		if(frm.contents.value == "문의하실 내용을 입력하세요."){
			frm.contents.value = "";
		}
		if(frm.contents.value.length < 1){
			alert("내용을 적어주셔야 합니다.");
			frm.contents.focus();
			return false;
		}

		if(confirm("상품에 대해 문의 하시겠습니까?")){
			frm.action = "/apps/appcom/wish/webview/my10x10/doitemqna.asp";
			frm.submit();
			return true;
		} else {
			return false;
		}
	}

</script>

<!-- modal#modalQNAWrite -->
<div class="modal" id="modalQNAWrite">
    <div class="box">
		<form name="qnaform" method="post" onsubmit="return false;">
		<input type="hidden" name="id" value="">
		<input type="hidden" name="itemid" value="<% = itemid %>">
		<input type="hidden" name="cdl" value="<%= oItem.Prd.FcdL %>">
		<input type="hidden" name="qadiv" value="02">
		<input type="hidden" name="mode" value="write">
		<input type="hidden" name="userid" value="<%= LoginUserid %>">
		<input type="hidden" name="UserName" value="<%= GetLoginUserName %>" >
        <header class="modal-header">
            <h1 class="modal-title">상품 문의하기</h1>
            <a href="#modalQNAWrite" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">
            <div class="inner">
                <!--<div class="bordered-box filled">
                    <div class="product-info gutter">
                        <div class="product-img">
                            <img src="<%'=oitem.Prd.FImageList%>" alt="<%'= oItem.Prd.FItemName %>">
                        </div>
                        <div class="product-spec">
                            <p class="product-brand">[<%'= UCase(oItem.Prd.FBrandName) %>] </p>
                            <p class="product-name"><%'= oItem.Prd.FItemName %></p>
                        </div>
                    </div>
                </div>
                <div class="diff"></div>-->
                <label for="agree">
                    <input type="checkbox" name="emailok" value="Y" checked id="agree" class="form">
                    답변메일 받기
                </label>
                <div class="diff-10"></div>
                <div class="input-block">
                    <label for="email" class="input-label">이메일</label>
                    <div class="input-controls">
                        <input type="email" name="usermail" value="<% = GetLoginUserEmail %>" id="email" class="form full-size">
                    </div>
                </div>
                <textarea name="contents" id="content" class="form bordered full-size" placeholder="문의하실 내용을 입력하세요." style="height:150px; margin-bottom:5px;"></textarea>
            </div>
        </div>
        </form>
        <footer class="modal-footer">
            <div class="two-btns">
                <div class="col"><button onclick="GotoItemQnA();" class="btn type-b">등록</button></div>
                <div class="col"><button class="btn type-a btn-close">취소</button></div>
            </div>
            <div class="clear"></div>
        </footer>
    </div>
</div><!-- modal#modalQNAWrite -->

<% set oItem = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->