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
'####################################################
Dim page, pagesize, RMaxId, sqlStr


'// 현재 들어온 기준 해당 회원의 가장 마지막 idx값을 가져온다.
sqlStr = "select max(idx) "
sqlStr = sqlStr + " from [db_EVT].dbo.[tbl_itemevent_userLogData_FrontRecent] with (nolock) "
sqlStr = sqlStr + " where userid = '"&getEncLoginUserID&"' "
rsEVTget.Open sqlStr,dbEVTget,1
	RMaxId = rsEVTget(0)
rsEVTget.close

'// 페이지 사이즈
pagesize = 30

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
/*.heightGrid:after {content:' '; position:absolute; top:0; bottom:0; left:1.55rem; width:1px; height:100%; background-color:#d9d9d9;}*/
</style>
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
			url:"_act_recentview.asp",
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
			url:"_act_recentview.asp",
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
									$('#timelineDiv').append(res[0]);
									vScrl=true;
								}
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

</script>
</head>
<body style="background-color:#ededed; background-color:#fff;">
<form name="frmRecentViewVal" id="frmRecentViewVal" method="post">
	<input type="hidden" name="Rtypeitem" id="Rtypeitem" value="true">
	<input type="hidden" name="Rtypeevt" id="Rtypeevt" value="true">
	<input type="hidden" name="Rtypemkt" id="Rtypemkt" value="true">
	<input type="hidden" name="Rtypebrand" id="Rtypebrand" value="true">
	<input type="hidden" name="Rtyperect" id="Rtyperect" value="true">
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
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content mypage" id="contentArea">
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
				<a href="" class="item on" typeval="Rtypeitem">상품</a>
				<a href="" class="exhibition on" typeval="Rtypeevt">기획전</a>
				<a href="" class="event on" typeval="Rtypemkt">이벤트</a>
				<a href="" class="brand on" typeval="Rtypebrand">브랜드</a>
				<a href="" class="searchword on" typeval="Rtyperect">검색어</a>
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