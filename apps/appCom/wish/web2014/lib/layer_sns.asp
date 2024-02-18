<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : sns
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim itemid	: itemid = requestCheckVar(request("itemid"),9)

if itemid="" or itemid="0" then
	Call Alert_Return("상품번호가 없습니다.")
	response.End
elseif Not(isNumeric(itemid)) then
	Call Alert_Return("잘못된 상품번호입니다.")
	response.End
else
	'정수형태로 변환
	itemid=CLng(getNumeric(itemid))
end if

dim oItem, ItemContent
set oItem = new CatePrdCls
oItem.GetItemData itemid

if oItem.FResultCount=0 then
	Call Alert_Return("존재하지 않는 상품입니다.")
	response.End
end if

if oItem.Prd.Fisusing="N" then
	Call Alert_Return("판매가 종료되었거나 삭제된 상품입니다.")
	response.End
end if

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode(oItem.Prd.FItemName)
snpLink = Server.URLEncode("http://10x10.co.kr/" & itemid)
snpPre = Server.URLEncode("텐바이텐 HOT ITEM!")
snpImg = Server.URLEncode(oItem.Prd.FImageBasic)
Select Case itemid
Case 429052
	'시크릿가든 상품
	snpTag = Server.URLEncode("텐바이텐 시크릿가든 secret garden 하지원 현빈 " & Replace(oItem.Prd.FItemName," ",""))
	snpTag2 = Server.URLEncode("#10x10 #secretgarden #시크릿가든_")
Case Else
	'기본 태그
	snpTag = Server.URLEncode("텐바이텐 " & Replace(oItem.Prd.FItemName," ",""))
	snpTag2 = Server.URLEncode("#10x10")
End Select
%>
<!-- modal#modalQNAWrite -->
<div class="modal" id="modalQNAWrite">
    <form action="">
    <div class="box no-footer">
        <header class="modal-header">
            <h1 class="modal-title">이 상품을 공유합니다.</h1>
            <a href="#modalQNAWrite" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">  
            <div class="iscroll-area">
	            <ul class="share-list">
	                <li onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');">                        
	                    <h2 class="share-name"><i class="facebook"></i> Facebook</h2>
	                    <div class="share-form inner">
	                        <p class="x-small">
	                            카카오톡 친구에게 링크 공유하는 방법 !<br>
	                            메시지 작성 후 ‘확인’ 버튼을 누릅니다. <br>
	                            메시지 보낼 친구를 선택 후 ‘완료’를 누르면 메시지 전송 완료! 
	                        </p>
	                        <div class="diff-10"></div>
	                        <textarea name="" id="" cols="30" rows="10" class="form bordered full-size"></textarea>
	                        <div class="diff-10"></div>
	                        <button class="btn type-a full-size">확인</button>
	                    </div>
	                </li>
	                <li onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');">                        
	                    <h2 class="share-name"><i class="twitter"></i> Twitter</h2>
	                    <div class="share-form inner">
	                        <p class="x-small">
	                            카카오톡 친구에게 링크 공유하는 방법 !<br>
	                            메시지 작성 후 ‘확인’ 버튼을 누릅니다. <br>
	                            메시지 보낼 친구를 선택 후 ‘완료’를 누르면 메시지 전송 완료! 
	                        </p>
	                        <div class="diff-10"></div>
	                        <textarea name="" id="" cols="30" rows="10" class="form bordered full-size"></textarea>
	                        <div class="diff-10"></div>
	                        <button class="btn type-a full-size">확인</button>
	                    </div>
	                </li>
	                <li onclick="kakaoLink('item','<%=itemid%>');">                        
	                    <h2 class="share-name"><i class="kakaotalk"></i> Kakaotalk</h2>
	                    <div class="share-form inner">
	                        <p class="x-small">
	                            카카오톡 친구에게 링크 공유하는 방법 !<br>
	                            메시지 작성 후 ‘확인’ 버튼을 누릅니다. <br>
	                            메시지 보낼 친구를 선택 후 ‘완료’를 누르면 메시지 전송 완료! 
	                        </p>
	                        <div class="diff-10"></div>
	                        <textarea name="" id="" cols="30" rows="10" class="form bordered full-size"></textarea>
	                        <div class="diff-10"></div>
	                        <button class="btn type-a full-size">확인</button>
	                    </div>
	                </li>
	                <li onclick="pinit('<%=snpLink%>','<%=snpImg%>');">                        
	                    <h2 class="share-name"><i class="pinterest"></i> Pinterest</h2>
	                    <div class="share-form inner">
	                        <p class="x-small">
	                            카카오톡 친구에게 링크 공유하는 방법 !<br>
	                            메시지 작성 후 ‘확인’ 버튼을 누릅니다. <br>
	                            메시지 보낼 친구를 선택 후 ‘완료’를 누르면 메시지 전송 완료! 
	                        </p>
	                        <div class="diff-10"></div>
	                        <textarea name="" id="" cols="30" rows="10" class="form bordered full-size"></textarea>
	                        <div class="diff-10"></div>
	                        <button class="btn type-a full-size">확인</button>
	                    </div>
	                </li>
	            </ul>
			</div>
        </div>
    </div>
    </form>
</div><!-- modal#modalQNAWrite -->

<script>
    $('.share-form').hide();
    //$('.share-name').on('click', function(){
    //    var shareForm = $(this).next();
    //    $('.share-form').removeClass('active').slideUp();
    //    if (shareForm.hasClass('active')) {
    //        shareForm.removeClass('active').slideUp();
    //    } else {
    //        shareForm.addClass('active').slideDown();
    //    }
    //});
</script>

<%
set oItem = nothing
%>
