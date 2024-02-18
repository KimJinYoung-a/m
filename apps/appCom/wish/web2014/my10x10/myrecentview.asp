<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbevtopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/todayshoppingcls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "최근 본 컨텐츠"

'####################################################
' Description : 마이텐바이텐 - 최근 본 컨텐츠
' History : 2017-05-12 원승현 
'			2018-09-04 최종원 장바구니 스크립트 추가
'####################################################
Dim page, pagesize, RMaxId, sqlStr
Dim vTypeItem, vTypeEvt, vTypeMkt, vTypeBrand, vTypeRect


'// 현재 들어온 기준 해당 회원의 가장 마지막 idx값을 가져온다.
sqlStr = "select max(idx) "
sqlStr = sqlStr + " from [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] with (nolock) "
sqlStr = sqlStr + " where userid = '"&getEncLoginUserID&"' "
rsEVTget.Open sqlStr,dbEVTget,1
	RMaxId = rsEVTget(0)
rsEVTget.close

'// 페이지 사이즈
pagesize = 30

'// 상단 Type탭 선택노출관련 파라미터 받음
vTypeItem = requestCheckVar(request("Rtypeitem"),10)
vTypeEvt = requestCheckVar(request("Rtypeevt"),10)
vTypeMkt = requestCheckVar(request("Rtypemkt"),10)
vTypeBrand = requestCheckVar(request("Rtypebrand"),10)
vTypeRect = requestCheckVar(request("Rtyperect"),10)
If vTypeItem = "" Then
	vTypeItem = true
End If
If vTypeEvt = "" Then
	vTypeEvt = true
End If
If vTypeMkt = "" Then
	vTypeMkt = true
End If
If vTypeBrand = "" Then
	vTypeBrand = true
End If
If vTypeRect = "" Then
	vTypeRect = true
End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
/*.heightGrid:after {content:' '; position:absolute; top:0; bottom:0; left:1.55rem; width:1px; height:100%; background-color:#d9d9d9;}*/
</style>
<link rel="stylesheet" type="text/css" href="/lib/css/temp_a.css" />
<script src="/apps/appCom/wish/web2014/lib/js/adultAuth.js?v=1.5"></script>
<script type="text/javascript">

	vScrl=true;
	$(function(){

		getMyViewList();

		$("#tabs a").on("click", function(e){
			if ( $(this).hasClass("on")) {
				$(this).removeClass("on");
				$('input[name='+$(this).attr("typeval")+']').val('false');
				$("#Rstdnum").val("1");
				$("#ROldRegDate").val("");
				vScrl=true;
				getMyViewList();
			} else {
				$(this).addClass("on");
				$('input[name='+$(this).attr("typeval")+']').val('true');
				$("#Rstdnum").val("1");
				vScrl=true;
				$("#ROldRegDate").val("");
				getMyViewList();
			}

			// amplitude event
			var tabName = $(this).attr("class").replace(" on", "");
			var action = $(this).hasClass("on") ? "on" : "off";
			fnAmplitudeEventMultiPropertiesAction("click_tab_in_history","tab_name|action",tabName + "|" + action);

			return false;
		});

		$(".item .fold .list").hide();
		$("#timelineGroup .btnMore").on("click", function(e){
			$(this).hide();
			$(this).next().show();
			$(this).next().find(".btnClose").show();
		});
		$("#timelineGroup .btnClose").on("click", function(e){
			$(this).hide();
			$(this).parent().hide();
			$(this).parent().parent().find(".btnMore").show();
		});
	});

	function btnDelCk(e, dival)
	{
		$("#Rmode").val("Del");
		$("#Dtype").val($(e).attr("dt"));
		$("#DItemId").val($(e).attr("dit"));
		$("#DEvtCode").val($(e).attr("devt"));
		$("#DRect").val($(e).attr("drect"));
		$("#DRegdate").val($(e).attr("dregd"));
		$.ajax({
			type:"GET",
			url:"act_recentview.asp",
			data: $("#frmRecentViewVal").serialize(),
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
					//$str = $(Data);
					res = Data.split("||");
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								if (res[0]==0)
								{
									$("#timeheadVal"+res[1]).fadeTo("fast", 0.01 /*, easing*/, function(){
										$("#timeheadVal"+res[1]).slideUp("230", function() {
											$("#timeheadVal"+res[1]).remove();
										});
									});
								}
								$("#"+dival).fadeTo("fast", 0.01 /*, easing*/, function(){
									$("#"+dival).slideUp("230", function() {
										$("#"+dival).remove();
									});
								});
							} else {
								//alert("상품이 없습니다.");
							}
						}
					}
			},
			error:function(jqXHR, textStatus, errorThrown){
				alert("잘못된 접근 입니다.");
				//var str;
				//for(var i in jqXHR)
				//{
				//	 if(jqXHR.hasOwnProperty(i))
				//	{
				//		str += jqXHR[i];
				//	}
				//}
				//alert(str);
				//document.location.reload();
				return false;
			}
		});
	}

	function getMyViewList()
	{
		$("#Rmode").val("list");
		$.ajax({
			type:"GET",
			url:"act_recentview.asp",
			data: $("#frmRecentViewVal").serialize(),
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
					//$str = $(Data);
					res = Data.split("||");
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								$("#ROldRegDate").val(res[1]);
								if($("#Rstdnum").val()=="1") {
									$('#timelineDiv').empty().html(res[0]);
									vScrl=true;
								} else {
									// amplitude event unbind
									var sectionList = $('.section');

									$('#timelineDiv').append(res[0]);
									vScrl=true;
								}

								// amplitude event bind
								var sectionList = $('.section');
							} else {
								//alert("상품이 없습니다.");
							}
						}
					}
			},
			error:function(jqXHR, textStatus, errorThrown){
				alert("잘못된 접근 입니다.");
				var str;
				for(var i in jqXHR)
				{
					 if(jqXHR.hasOwnProperty(i))
					{
						str += jqXHR[i];
					}
				}
				alert(str);
				//document.location.reload();
				return false;
			}
		});
	}


	<%'// 스크롤시 추가페이지 접수%>
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-1200){
			if(vScrl) {
				vScrl = false;
				//alert((parseInt($("#Rstdnum").val())+<%=pagesize%>));
				$("#Rstdnum").val((parseInt($("#Rstdnum").val())+<%=pagesize%>));
				if (parseInt($("#Rpagesize").val()) > 1)
				{
					if ($("#Rtypeitem").val()=="false" && $("#Rtypeevt").val()=="false" && $("#Rtypemkt").val()=="false" && $("#Rtypebrand").val()=="false" && $("#Rtyperect").val()=="false")
					{

					}
					else
					{
						getMyViewList();
					}
				}
				else
				{
					getMyViewList();
				}

			}
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
function AddShoppingBag(bool, itemid){	
	var frm = document.shoppingbagFrm;
	frm.itemid.value = itemid;
	if(bool === "True"){//옵션 있는 상품
		fnAPPpopupProduct(itemid)
	}else{//옵션 없는 상품
		frm.mode.value = "DO3";			//바로구매 (모바일웹 - 상품/장바구니 겸용)
        frm.target = "iiBagWin";
    	frm.action="/apps/appCom/wish/web2014/inipay/shoppingbag_process.asp";
    	frm.submit();
	}
}
</script>
</head>
<body style="background-color:#ededed; background-color:#fff;">
<form name="frmRecentViewVal" id="frmRecentViewVal" method="post">
	<input type="hidden" name="Rtypeitem" id="Rtypeitem" value="<%=vTypeItem%>">
	<input type="hidden" name="Rtypeevt" id="Rtypeevt" value="<%=vTypeEvt%>">
	<input type="hidden" name="Rtypemkt" id="Rtypemkt" value="<%=vTypeMkt%>">
	<input type="hidden" name="Rtypebrand" id="Rtypebrand" value="<%=vTypeBrand%>">
	<input type="hidden" name="Rtyperect" id="Rtyperect" value="<%=vTypeRect%>">
	<input type="hidden" name="Rmaxid" id="Rmaxid" value="<%=RMaxId%>">
	<input type="hidden" name="Rstdnum" id="Rstdnum" value="1">
	<input type="hidden" name="Rpagesize" id="Rpagesize" value="<%=pagesize%>">
	<input type="hidden" name="Rplatform" id="Rplatform" value="">
	<input type="hidden" name="ROldRegDate" id="ROldRegDate" value="">
	<input type="hidden" name="Rmode" id="Rmode" value="">
	<input type="hidden" name="RUserId" id="RUserId" value="<%=tenEnc(getEncLoginUserID)%>">

	<input type="hidden" name="Dtype" id="Dtype" value="">
	<input type="hidden" name="DItemId" id="DItemId" value="">
	<input type="hidden" name="DEvtCode" id="DEvtCode" value="">
	<input type="hidden" name="DRect" id="DRect" value="">
	<input type="hidden" name="DRegdate" id="DRegdate" value="">
</form>
<form name="shoppingbagFrm" method="post" action="" style="margin:0px;">
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="itemid" value="" />
	<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
	<input type="hidden" name="itemoption" value="0000" />
	<input type="hidden" name="itemea" readonly value="1" />
</form>
<!--<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>-->
<div class="heightGrid" style="background:#ededed;">
	<div class="container">
		<!-- content area -->
		<div class="content mypage" id="contentArea">
			<% response.write fnTestLoginLabel() '//  app 쿠키 테스트용 %>
			<%' for dev msg : 최근 본 컨텐츠가 없을 경우 %>
			<% If Trim(RMaxId)="" Then %>
				<div class="nodata recent">
					<p>히스토리가 없습니다.</p>
					<%' for dev msg : 투데이로 링크걸어주세요 %>
					<a href="" class="btnV16a btnRed2V16a" onclick="callmain();return false;">쇼핑하러 가기</a>
				</div>
			<% End If %>

			<%' for dev msg :  기본값은 전체 on입니다. %>
			<div id="tabs" class="tabs tabsCheck">
				<a href="" class="item<% If vTypeItem Then %> on<% End If %>" typeval="Rtypeitem">상품</a>
				<a href="" class="exhibition<% If vTypeEvt Then %> on<% End If %>" typeval="Rtypeevt">기획전</a>
				<a href="" class="event<% If vTypeMkt Then %> on<% End If %>" typeval="Rtypemkt">이벤트</a>
				<a href="" class="brand<% If vTypeBrand Then %> on<% End If %>" typeval="Rtypebrand">브랜드</a>
				<a href="" class="searchword<% If vTypeRect Then %> on<% End If %>" typeval="Rtyperect">검색어</a>
			</div>
			<div id="timelineGroup" class="timelineGroup" style="background-color:#ededed;">
				<div class="timeline" id="timelineDiv"></div>
			</div>
			<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbEVTclose.asp" -->