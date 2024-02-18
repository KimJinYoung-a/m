<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리 스토리 2020 다꾸톡톡 주문리스트
' History : 2019-09-09 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2020/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2020/lib/classes/daccutoktokCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
    dim LoginUserid, i, vPrevRegDate, pageSize, currPage, posX, posY, MasterIdxUseItem
    posX = request("posX")
    posY = request("posY")
    MasterIdxUseItem = request("MasterIdxUseItem")

    LoginUserid = getEncLoginUserID()

    '// 로그인시에만 작성가능
    If not(IsUserLoginOK()) Then
        Response.Write "<script>alert('로그인이 필요한 서비스 입니다.');fnAPPclosePopup();</script>"
        Response.End
    End If


    pageSize = 1000
    currPage = 1

    dim oDaccuTokTokMyOrder
    set oDaccuTokTokMyOrder = new CDaccuTokTok
    oDaccuTokTokMyOrder.FPageSize = pageSize
    oDaccuTokTokMyOrder.FCurrPage = currPage
    oDaccuTokTokMyOrder.FRectUserID = LoginUserid
    oDaccuTokTokMyOrder.GetDaccuTokTokMyOrderList

%>
<link rel="stylesheet" type="text/css" href="/lib/css/diary2020.css?v=1.13" />
<script type="text/javascript">

	$(function(){
        //창 타이틀 변경
        setTimeout(function(){
            fnAPPchangPopCaption("구매 리스트");
        }, 100);

		getMyViewList();
	});

    function daccuMyorderPopupClose() {
        $("#markposition_<%=posX&posY%>").remove();
        fnCloseModal();
    }

	function getMyViewList()
	{
		$.ajax({
			type:"POST",
			url:"/diarystory2020/act_daccu_toktok_myorder.asp",
			data: $("#frmDaccuTokTokMyOrderFrm").serialize(),
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
					//$str = $(Data);
					res = Data.split("||");
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								$("#oldRegDate").val(res[1]);
								if($("#currpage").val()=="1") {
									$('#orderListTok').empty().html(res[0]);
									vScrl=true;
								} else {
									$('#orderListTok').append(res[0]);
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
				//alert(str);
				//document.location.reload();
				return false;
			}
		});
	}

    function clickOrderList(itemid,itemoption) {
        $("#buttonProductTagInsert").addClass("on");
        $("#clickInsertItemId").val(itemid);
        $("#clickInsertItemOption").val(itemoption);
    }

    function buttonProductInsert() {
        if($("#buttonProductTagInsert").hasClass("on")===true) {
            $.ajax({
                type:"POST",
                url:"/diarystory2020/ajaxDaccuTokTok.asp",
                data: $("#frmDaccuTokTokMyOrderItemInsert").serialize(),
                dataType: "text",
                async:false,
                cache:true,
                success : function(Data, textStatus, jqXHR){
                    if (jqXHR.readyState == 4) {
                        if (jqXHR.status == 200) {
                            if(Data!="") {
                                var result = JSON.parse(Data)
                                if(result.response == "ok"){
                                    <%'// 앱에선 opener 같은걸로 컨트롤 해줘야됨 %>
                                    fnAPPopenerJsCallClose("daccuTokTokAfterDetailProc('<%=posX%>','<%=posY%>')");
                                    return false;
                                }else{
                                    alert(result.faildesc);
                                    return false;
                                }
                            } else {
                                alert("잘못된 접근 입니다.");
                                document.location.reload();
                                return false;
                            }
                        }
                    }
                },
                error:function(jqXHR, textStatus, errorThrown){
                    alert("잘못된 접근 입니다.");					
                    // document.location.reload();
                    return false;
                }
            });
        }
        else {
            return;
        }
    }



	<%'// 스크롤시 추가페이지 접수%>
    /*
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-1200){
			if(vScrl) {
				vScrl = false;
				$("#currpage").val((parseInt($("#currpage").val())+1));
				getMyViewList();
			}
		}
	});
    */

	// 로딩중 표시
    /*
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
    */
</script>
</head>
<body class="default-font body-popup diary2020">
    <form name="frmDaccuTokTokMyOrderFrm" id="frmDaccuTokTokMyOrderFrm" method="post">
        <input type="hidden" name="currpage" id="currpage" value="1">
        <input type="hidden" name="pagesize" id="pagesize" value="<%=pagesize%>">
        <input type="hidden" name="oldRegDate" id="oldRegDate" value="">
    </form>
    <form name="frmDaccuTokTokMyOrderItemInsert" id="frmDaccuTokTokMyOrderItemInsert" method="post">
        <input type="hidden" name="clickInsertItemId" id="clickInsertItemId">
        <input type="hidden" name="clickInsertItemOption" id="clickInsertItemOption">
        <input type="hidden" name="MasterIdxUseItem" id="MasterIdxUseItem" value="<%=MasterIdxUseItem%>">
        <input type="hidden" name="daccuTokModeTemp" id="daccuTokModeTemp" value="DetailItemProc">
        <input type="hidden" name="posX" id="posX" value="<%=posX%>">
        <input type="hidden" name="posY" id="posY" value="<%=posY%>">
    </form>
    <div id="content" class="content diary-sub">
        <div class="talk order-list">
            <p class="noti">최근 6개월의 구매내역만 표시됩니다.</p>
            <ul class="my-list" id="orderListTok"></ul>
        </div>
    </div>
    <div class="btn-area">
        <button class="btn btn-xlarge btn-block color-black" id="buttonProductTagInsert" onclick="buttonProductInsert();">상품 태그 등록하기</button>
    </div>
</body>
</html>
<%
    set oDaccuTokTokMyOrder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->