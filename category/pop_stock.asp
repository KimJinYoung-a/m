<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 상품상세 - 품절상품입고알림
' History : 2018-01-03 원승현
'####################################################

	Dim stockItemId
	Dim oItem, ItemContent, oItemOption, oItemOptionMultiple, IsMultipleOption, i, optionSoldOutFlag, myUserInfo, oItemOptionMultipleType, j, strSql
	Dim multiOptionValue, alarmType

	stockItemId = requestCheckVar(request("itemid"),9)
	
	'// 상품정보를 가져온다.
	set oItem = new CatePrdCls
	oItem.GetItemData stockItemId

	'// 옵션정보를 가져온다.
    set oItemOption = new CItemOption
    oItemOption.FRectItemID = stockItemId
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

	'// 사용자정보를 가져온다.
	set myUserInfo = new CUserInfo
	myUserInfo.FRectUserID = getEncLoginUserID
	if (getEncLoginUserID<>"") then
		myUserInfo.GetUserData
	end If

	'// 지금은 자동설정이지만 왠지 유저가 선택하게 해달라고 할꺼 같아 따로 빼놓는다.
	If isApp="1" Then
		alarmType = "appPush"
	Else
		alarmType = "LMS"
	End If

%>
<script>
$(function() {
	$(".depth1.multi-select a").on("click", function(){
		$(this).toggleClass("on");
		if ($(this).hasClass('on')) {
			$("#optselectconutStock").text(parseInt($("#optselectconutStock").text())+1);
		} else {
			$("#optselectconutStock").text(parseInt($("#optselectconutStock").text())-1);
		}
		return false;
	});
	var optionSwiper = new Swiper(".panelcont .swiper-container", {
		scrollbar: '.swiper-scrollbar',
		direction: 'vertical',
		slidesPerView:'auto',
		mousewheelControl: true,
		freeMode: true,
		simulateTouch:true
	});
});

function goStockSubmit()
{
	<% if (trim(oItem.Prd.FSellYn) = "Y") then '// 상품판매가 Y일 경우에만 옵션에 대한 선택권을 준다.%>
		<% If oItemOption.FResultCount>0 Then '// 옵션이 있으면 %>
			var tmpSelOptCode="";
			$(".depth1.multi-select a").each(function(){
				if ($(this).hasClass('on'))
				{
					if (tmpSelOptCode=="")
					{
						tmpSelOptCode = $(this).attr("value");
					}
					else
					{
						tmpSelOptCode = tmpSelOptCode +','+$(this).attr("value");
					}
				}
			});
			$("#selectOptCode").val(tmpSelOptCode);

			if (tmpSelOptCode=="")
			{
				alert("옵션을 선택한 뒤 입고 알림 신청을 해주세요.");
				return false;
			}
		<% end if %>
	<% end if %>

	if ($("#pushPeriod")=="")
	{
		alert("알림기간을 선택해주세요.");
		return false;
	}
	$("#pushPeriod").val($(":input:radio[name=alarmTime]:checked").val());

	var frmdata = $("#frmStock").serialize();

	$.ajax({
			type : "POST",
			url : "act_pop_stock.asp",
			cache : false,
			data : frmdata,
			success : function(Data){
				var res;
				res = Data.split("||");
				if (res[0]=="OK")
				{
					okMsg = res[1].replace(">?n", "\n");
					alert(okMsg);
					fnCloseModal();
					return false;
				}
				else
				{
					errorMsg = res[1].replace(">?n", "\n");
					alert(errorMsg);
					return false;
				}
			}
	});
}
</script>
</head>
	<div class="layerPopup default-font">
		<header class="tenten-header header-popup">
			<div class="title-wrap">
				<h1>입고 알림 신청</h1>
				<button type="button" class="btn-close" onclick="fnCloseModal();">닫기</button>
			</div>
		</header>
		<div class="ly-contents stock-inform">
			<div class="scrollwrap">
				<div class="items type-list">
					<div class="thumbnail"><img src="<%=oItem.Prd.FImageList120%>" alt="" /></div>
					<div class="desc">
						<span class="brand"><%=oItem.Prd.FBrandName%></span>
						<p class="name"><%=oItem.Prd.FItemName%></p>
					</div>
				</div>
				<div class="selectForm">
					<% If (trim(oItem.Prd.FSellYn) = "Y") Then '// 상품판매가 Y일 경우에만 옵션에 대한 선택권을 준다.%>
						<% If oItemOption.FResultCount>0 Then '// 옵션이 있으면 %>
							<%
								set oItemOptionMultiple = new CItemOption
								oItemOptionMultiple.FRectItemID = stockItemId
								oItemOptionMultiple.GetOptionMultipleList

								IsMultipleOption = (oItemOptionMultiple.FResultCount>0)
							%>
							<%' 단일옵션일경우 %>
							<% IF (Not IsMultipleOption) Then %>
								<p class="selected">옵션 선택 (<span class="color-blue" id="optselectconutStock">0</span>건)</p>
								<div class="textfield search-filter">
									<div class="panelcont" style="display: block;">
										<div class="swiper-container">
											<ul class="depth1 multi-select swiper-wrapper">
												<% for i=0 to oItemOption.FResultCount-1 %>
													<%' 품절만 표시 %>
													<% If ((oitem.Prd.IsSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) Then %>
														<li class="swiper-slide"><a href="" value="<%=oItemOption.FItemList(i).FitemOption%>"><%=oItemOption.FItemList(i).FOptionName%></a></li>
													<% End If %>
												<% Next %>
											</ul>
											<div class="swiper-scrollbar"></div>
										</div>
									</div>
								</div>
							<% Else %>
								<%
									set oItemOptionMultipleType = new CItemOption
									oItemOptionMultipleType.FRectItemId = stockItemId
									oItemOptionMultipleType.GetOptionMultipleTypeList

									strSql = " Select top 1 "
									strSql = strSql & "	itemid, "
									strSql = strSql & "		stuff( "
									strSql = strSql & "				( "
									strSql = strSql & "					Select ','''+substring(itemoption, 1, "&oItemOptionMultipleType.FResultCount&")+'''' "
									strSql = strSql & "					From db_item.[dbo].[tbl_item_option] "
									strSql = strSql & "					Where itemid = o.itemid And optsellyn='Y' "
									strSql = strSql & "					group by itemid, substring(itemoption, 1, "&oItemOptionMultipleType.FResultCount&")  "
									strSql = strSql & "					FOR XML PATH('') "
									strSql = strSql & "				),1,1,'' "
									strSql = strSql & "			 ) as availableOpt  "
									strSql = strSql & "	From db_item.[dbo].[tbl_item_option] o Where itemid='"&stockItemId&"' And optsellyn='Y' "
									strSql = strSql & "	group by itemid "
									rsget.Open strSql, dbget, 1
									if Not rsget.Eof Then
										multiOptionValue = rsget("availableOpt")
									End If
									rsget.close
								%>
								<p class="selected">옵션 선택 (<span class="color-blue" id="optselectconutStock">0</span>건)</p>
								<div class="textfield search-filter">
									<div class="panelcont" style="display: block;">
										<div class="swiper-container">
											<ul class="depth1 multi-select swiper-wrapper">
												<% 
													strSql = " Select * From db_item.dbo.tbl_item_option Where itemid='"&stockItemId&"' And substring(itemoption, 1, "&oItemOptionMultipleType.FResultCount&") in ("&multiOptionValue&") And "
													strSql = strSql & "		case when optlimityn='N' then  "
													strSql = strSql & "			case when optsellyn='N' then 0 "
													strSql = strSql & "			else 1 end "
													strSql = strSql & "		else "
													strSql = strSql & "			Case When optsellyn='N' then 0 "
													strSql = strSql & "			else (optlimitno-optlimitsold) end "
													strSql = strSql & "		end < 1 "
													rsget.Open strSql, dbget, 1
													if Not rsget.Eof Then
														Do Until rsget.eof
												%>
															<li class="swiper-slide"><a href="" value="<%=rsget("itemoption")%>"><%=rsget("optionname")%></a></li>
												<%
														rsget.movenext
														Loop
													End If
													rsget.close
												%>
											</ul>
											<div class="swiper-scrollbar"></div>
										</div>
									</div>
								</div>
							<% End If %>
							<%
								Set oItemOptionMultiple = Nothing
								Set oItemOptionMultipleType = Nothing
							%>
						<% End If %>
					<% End If %>

					<% If isapp<>"1" Then %>
						<%' 문자 알림 번호(web에서만 노출) %>
						<div class="textfield">
							<div class="thead">문자 알림 번호</div>
							<div class="tbody">
								<div class="formfield">
									<%= SplitValue(myUserInfo.FOneItem.Fusercell,"-",0) %>-****-<%= SplitValue(myUserInfo.FOneItem.Fusercell,"-",2) %>
								</div>
							</div>
						</div>
					<% End If %>

					<%' 알림 기간 %>
					<div class="textfield">
						<div class="thead">알림기간</div>
						<div class="tbody">
							<div class="formfield">
								<input type="radio" id="period1" name="alarmTime" class="frmRadioV16" value="d7" checked> <label for="period1">7일</label>
								<input type="radio" id="period2" name="alarmTime" class="frmRadioV16" value="m1"> <label for="period2">1개월</label>
								<input type="radio" id="period3" name="alarmTime" class="frmRadioV16" value="m3"> <label for="period3">3개월</label>
							</div>
						</div>
					</div>
				</div>
				<div class="noti">
					<% If isapp="1" Then %>
						<p class="color-blue">해당 상품(옵션 일부 등)은 일시품절되었습니다.<br />상품이 재판매 되면 알림(PUSH)로 알려드리겠습니다.</p>
						<ul>
							<li>- 마이텐바이텐 &gt; 설정 &gt; 광고성 알림(PUSH)를 설정해주세요.</li>
							<li>- iOS의 경우, 설정 &gt; 알림에서 텐바이텐의 알림을 허용해주세요.</li>
						</ul>
					<% Else %>
						<p class="color-blue">해당 상품(옵션 일부 등)은 일시품절되었습니다.<br />상품이 재판매 되면 문자메시지로 알려드리겠습니다.</p>
						<ul>
							<li>휴대폰 번호 수정을 원하시면, 마이텐바이텐 &gt; 개인정보 수정 메뉴 에서 수정하신 뒤 신청해주세요.</li>
						</ul>
					<% End If %>
					<p>※ 판매가격 또는 할인 가격은 신청하신 정보와 차이가 날 수 있으며, 구매 시점에 따라 상품 품절이 발생할 수 있습니다.</p>
				</div>
				<div class="fixed-bottom">
					<button type="submit" class="btn btn-xlarge btn-blue btn-block btn-radius" onclick="goStockSubmit();return false;"><span class="icon icon-alarm"></span>신청하기</button>
				</div>
			</div>
		</div>
	</div>
	<form method="post" name="frmStock" id="frmStock">
		<input type="hidden" name="selectOptCode" id="selectOptCode" value="">
		<input type="hidden" name="stockItemId" id="stockItemid" value="<%=stockItemid%>">
		<input type="hidden" name="alarmType" id="alarmType" value="<%=alarmType%>">
		<input type="hidden" name="pushPeriod" id="pushPeriod" value="">
	</form>

<%
	Set oItem = Nothing
	Set oItemOption = Nothing
	Set myUserInfo = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->