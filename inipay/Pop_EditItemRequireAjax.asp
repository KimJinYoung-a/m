<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<%
'' 사이트 구분
Const sitename = "10x10"

dim userid, guestSessionID
userid = GetLoginUserID
guestSessionID = GetGuestSessionKey

dim oShoppingBag
set oShoppingBag = new CShoppingBag
oShoppingBag.FRectUserID    = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename

oshoppingbag.GetShoppingBagDataDB


dim itemid, itemoption, itemea, imageList, itemname, brandname, itemoptionname, i
dim requiredetail, eqNum
dim mode, requiredetailedit

itemid      = requestCheckVar(request("itemid"),9)
itemoption  = requestCheckVar(request("itemoption"),4)
requiredetail = oShoppingBag.getRequireDetailByItemID(itemid,itemoption)
itemea      = oShoppingBag.getItemNoByItemID(itemid,itemoption)
imageList	= oShoppingBag.getListImageByItemID(itemid)
itemname	= oShoppingBag.getItemNameByItemID(itemid)
itemoptionname = oShoppingBag.getItemOptionNameByItemID(itemid,itemoption)
brandname	= oShoppingBag.getItemBrandByItemID(itemid)
eqNum		= requestCheckVar(request("eqno"),4)				'화면상의 수정 index

if (itemea<1) then 
    response.write "<script type=""text/javascript"">alert('해당 상품이 없습니다.');fnCloseModal();</script>"
    dbget.close() : response.end
end if

mode = request.form("mode")
requiredetailedit = (request.form("requiredetailedit"))

dim ret
if mode="edit" then
    if (itemea>1) then
        requiredetailedit = ""
        for i=1 to itemea
            if (request.form("requiredetailedit")(i)<>"") then
            requiredetailedit = requiredetailedit & request.form("requiredetailedit")(i) & CAddDetailSpliter
            end if
        next
        if Right(requiredetailedit,2)=CAddDetailSpliter then
            requiredetailedit = Left(requiredetailedit,Len(requiredetailedit)-2)
        end if
    end if
    ret = oShoppingBag.EditShoppingRequireDetail(itemid, itemoption, Html2DB(requiredetailedit))

	if (ret) then
	    response.write "OK." & Replace(requiredetailedit,CAddDetailSpliter,"<br/><br/>")
	    dbget.close() : response.end
	else
	    response.write "ERR"
	    dbget.close() : response.end
	end if
end if

set oShoppingBag = Nothing
%>
<script type='text/javascript'>
function editRequire(frm){
    var detailArr='';
    var itemea=frm.requiredetailedit.length;

	if (itemea==1) {
		if (frm.requiredetailedit.value.length < 1) {
			alert('주문 제작 상품 문구를 작성해 주세요.');
			//myScroll.scrollToElement("#"+$(frm.requiredetailedit).attr("id"),50);
			//frm.requiredetailedit.focus();
			return;
		}

		if(GetByteLength(frm.requiredetailedit.value) > 500) {
			alert('문구 입력은 최대 250자(한글 기준) 까지 가능합니다.\n\n현재 글자수 : ' + frm.requiredetailedit.value.length);
			//frm.requiredetailedit.focus();
			return;
		}
	} else {
	    if(itemea > 1) {
	        for (var i = 0; i < itemea; i++) {
				var obj = frm.requiredetailedit[i];

				if (obj.value.length < 1) {
					alert('주문 제작 상품 문구를 작성해 주세요.');
					return false;
				}

	            if (GetByteLength(obj.value) > 500) {
	    			alert('문구 입력은 최대 250자(한글 기준) 까지 가능합니다.\n\n현재 글자수 : ' + obj.value.length);
	    			return false;
	    		}

	            detailArr = detailArr + obj.value + '||';
	        }

	        if(GetByteLength(detailArr) > 800) {
				alert('문구 입력합계는 최대 400자(한글 기준) 까지 가능합니다.\n\n현재 글자수 : ' + detailArr.length);
				return false;
			}
        }
	}

	if (confirm('수정 하시겠습니까?')) {
	    frm.mode.value = "edit";
	    var vParam = $(frm).serialize();

		$.ajax({
			url: "Pop_EditItemRequireAjax.asp",
			type: "POST",
			data: vParam,
			dataType: "text",
			cache: false,
			async: false,
			success: function(message) {
				if(message.substr(0,2)=="OK") {
				    alert('수정 되었습니다.');
				    $(".reqrText").eq(<%=eqNum%>).html(message.substr(3,message.length));
				    fnCloseModal();
				} else {
					alert("처리중 오류가 발생했습니다.");
				}
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	}
}
</script>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>상품 주문 제작문구</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="layerScroll">
			<div id="scrollarea">
				<div class="editWordsV16a">
					<div class="bxLGy2V16a notiV16a">
						<ul>
							<li>같은 상품을 2개 이상 주문하신 경우 제작문구가 다를 시, 각각 입력해 주시기 바랍니다.</li>
						</ul>
					</div>
					<div class="bxWt1V16a">
						<div class="pdtWrapV16a">
							<p class="pdtPicV16a">
								<span>품절</span>
								<a href="">
									<img src="<%=imageList%>" alt="<%=replace(itemname,"""","")%>" />
								</a>
							</p>
							<div class="pdtInfoV16a">
								<p class="pdtBrandV16a"><%=brandname%></p>
								<div class="pdtNameV16a">
									<h2><%=itemname%></h2>
								</div>
								<% if trim(itemoptionname)<>"" then %>
								<p class="pdtOptionV16a">
									<span class="fs1-1r cLGy1V16a"><%=itemoptionname%></span>
								</p>
								<% end if %>
							</div>
						</div>
						<form name="reqEditfrm" method="post" onSubmit="return false;">
						<input type="hidden" name="mode" value="">
						<input type="hidden" name="itemid" value="<%= itemid %>">
						<input type="hidden" name="itemoption" value="<%= itemoption %>">
						<fieldset>
							<legend>제작 상품 문구 수정</legend>
						<% if (itemea=1) then %>
							<textarea name="requiredetailedit" id="requiredetailedit" cols="60" rows="4" title="수정할 문구 입력" style="width:100%;"><%= Replace(requiredetail,CAddDetailSpliter,VbCrlf) %></textarea>
						<% else %>
						<%		for i=0 to itemea-1 %>
							<h3><%= i+1 %>번 상품</h3>
							<textarea name="requiredetailedit" id="requiredetailedit" cols="60" rows="4" title="수정할 문구 입력" style="width:100%;"><%= splitValue(requiredetail,CAddDetailSpliter,i) %></textarea>
						<%		next %>
						<% end if %>
						</fieldset>
						</form>
					</div>
					<div class="btnAreaV16a">
						<p><button type="button" class="btnV16a btnRed2V16a" onclick="editRequire(document.reqEditfrm);">수정</button></p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->