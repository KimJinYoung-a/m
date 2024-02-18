<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 바꿔방 이벤트
' History : 2020-02-06 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
    Dim todayDate : todayDate = Left(now(), 10) '// 오늘일자
    Dim loginUserId, i, eCode, sqlStr, vSub_Idx
    Dim confirmCheck '// 응모확인 상태값
    Dim sumofItemValue '// 참여 했을 경우 사용자가 담은 총 상품의 금액
    Dim tableItemId, tableItemPrice, tableItemImage
    Dim lightItemId, lightItemPrice, lightItemImage
    Dim wardrobeItemId, wardrobeItemPrice, wardrobeItemImage
    Dim bedItemId, bedItemPrice, bedItemImage
    Dim beddingItemId, beddingItemPrice, beddingItemImage
    Dim chairItemId, chairItemPrice, chairItemImage

    If Instr(request.servervariables("HTTP_HOST"), "localm") > 0 Then
        wwwUrl = "http://localm.10x10.co.kr"
    End If

    IF application("Svr_Info") = "Dev" THEN
        eCode = "90464"	
    Else
        eCode = "100420"
    End If

    confirmCheck = False '// 사용자 응모여부
    sumofItemValue = 0 '// 응모했다면 담은 상품의 총 금액
    
    '// 사용자 아이디
    loginUserId = getEncLoginUserId

    If IsUserLoginOK() Then
        '// 로그인을 했다면 사용자 응모정보를 불러온다.
        sqlstr = " SELECT * FROM db_event.dbo.tbl_event_subscript WITH(NOLOCK) "
        sqlstr = sqlstr & " WHERE evt_code='"&eCode&"'  AND userid='"&LoginUserid&"' "
        rsget.Open sqlstr, dbget, adOpenForwardOnly,adLockReadOnly
        If Not rsget.Eof Then
            confirmCheck = True
            sumofItemValue = rsget("sub_opt2")
            vSub_Idx = rsget("sub_idx")
        End If
        rsget.Close        

        If confirmCheck Then
            '// 응모정보가 있다면 사용자가 등록한 바꿔방 상품들을 불러온다.
            sqlStr = ""
            sqlStr = sqlStr & " SELECT TOP 6 "
            sqlStr = sqlStr & "	 ei.evt_code	"
            sqlStr = sqlStr & "	 , ei.itemid	"
            sqlStr = sqlStr & "  , ei.sub_idx	"
            sqlStr = sqlStr & "  , ei.category	"            
            sqlStr = sqlStr & "  , ei.sellcash	"                        
            sqlStr = sqlStr & "  , i.itemid AS itemTableItemID "
            sqlStr = sqlStr & "  , i.itemname "
            sqlStr = sqlStr & "  , i.dispcate1 "
            sqlStr = sqlStr & "  , i.sellcash "
            sqlStr = sqlStr & "  , i.buycash "
            sqlStr = sqlStr & "  , i.orgprice "
            sqlStr = sqlStr & "  , i.orgsuplycash "
            sqlStr = sqlStr & "  , i.smallimage "
            sqlStr = sqlStr & "  , i.listimage "
            sqlStr = sqlStr & "  , i.listimage120 "
            sqlStr = sqlStr & "  , i.basicimage "
            sqlStr = sqlStr & "  , i.icon1image "
            sqlStr = sqlStr & "  , i.icon2image "
            sqlStr = sqlStr & "  FROM db_temp.dbo.tbl_EventUserItemSelect ei WITH(NOLOCK) "
            sqlStr = sqlStr & "  LEFT JOIN db_item.dbo.tbl_item i WITH(NOLOCK) ON ei.itemid = i.itemid "
            sqlStr = sqlStr & "  WHERE ei.evt_code='"&eCode&"' AND sub_idx='"&vSub_Idx&"' And userid='"&loginUserId&"' "
            rsget.CursorLocation = adUseClient
            rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
            if not rsget.EOF then
                Do Until rsget.Eof
                    If trim(rsget("category"))="table" Then
                        tableItemId     = rsget("itemid")
                        tableItemPrice  = rsget("sellcash")
                        tableItemImage  = "//webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage")
                    End If
                    If trim(rsget("category"))="light" Then
                        lightItemId     = rsget("itemid")
                        lightItemPrice  = rsget("sellcash")
                        lightItemImage  = "//webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage")
                    End If
                    If trim(rsget("category"))="wardrobe" Then
                        wardrobeItemId     = rsget("itemid")
                        wardrobeItemPrice  = rsget("sellcash")
                        wardrobeItemImage  = "//webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage")
                    End If                    
                    If trim(rsget("category"))="bed" Then
                        bedItemId     = rsget("itemid")
                        bedItemPrice  = rsget("sellcash")
                        bedItemImage  = "//webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage")
                    End If                                        
                    If trim(rsget("category"))="bedding" Then
                        beddingItemId     = rsget("itemid")
                        beddingItemPrice  = rsget("sellcash")
                        beddingItemImage  = "//webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage")
                    End If
                    If trim(rsget("category"))="chair" Then
                        chairItemId     = rsget("itemid")
                        chairItemPrice  = rsget("sellcash")
                        chairItemImage  = "//webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage")
                    End If                         
                rsget.moveNext
                loop
            end if
            rsget.close
        End If

    End If

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style>
.mEvt100420 button {width:100%; background:transparent;}
.change-room {text-align:center; background:#60f2ab;}
.select-item {overflow:hidden; width:29.9rem; margin:0 auto; padding-right:1.1rem;}
.select-item li {overflow:hidden; position:relative; float:left; width:8.5rem; height:8.5rem; margin:0 0 1.28rem 1.1rem; border:.13rem dashed #ff4622; border-radius:.42rem;  background:url(//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_cate_1.png) 50% 50% no-repeat; background-size:100% auto;}
.select-item li.lightAreaClass {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_cate_2.png)}
.select-item li.wardrobeAreaClass {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_cate_3.png)}
.select-item li.bedAreaClass {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_cate_4.png)}
.select-item li.beddingAreaClass {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_cate_5.png)}
.select-item li.chairAreaClass {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_cate_6.png)}
.select-item .thumbnail {position:absolute; left:0; top:0; width:100%;}
.select-item .thumbnail:before {display:none;}
.select-item .btn-select {display:block; height:100%; text-indent:-999em; }
.select-item .btn-delete {position:absolute; right:0; top:0; z-index:10; width:2.56rem; height:2.56rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_delete.png) 50% 50% no-repeat; background-size:100%; text-indent:-999em;}
.total {display:inline-block; margin:1.4rem 0 1.7rem; padding:0 .341rem; font-size:1.54rem; line-height:.5; font-family:'NotoSansKRBold'; border-bottom:.42rem solid #fff;}
.total span { font-size:1rem;}
.total b {font-size:1.8rem; font-family:'CoreSansCBold';}
.total.over b {color:#ff1d1d;}
.process {color:#116c40; font-size:1rem;}
.process h3 {padding-bottom:.5rem; font-size:1.2rem; font-family:'NotoSansKRBold'; }
.process li {padding-top:.77rem;}
.process li:last-child {padding-top:1.38rem; font-size:1.2rem; font-family:'NotoSansKRBold';}
.evt-bnr {overflow:hidden;}
.evt-bnr li {float:left; width:50%;}
.evt-bnr li:last-child {width:100%;}
.noti {padding:3.4rem 2.5rem; color:#b2f0db; background:#1c9c70;}
.noti h3 {padding-bottom:2rem; font-size:1.61rem; font-family:'NotoSansKRBold'; color:#bdf4e1; text-align:center;}
.noti li {position:relative; padding:0 0 .5rem .7rem; font-size:1.11rem; line-height:1.8; letter-spacing:-.03rem;}
.noti li:after {content:''; position:absolute; left:0; top:.7rem; width:.128rem; height:.128rem; background:#b2f0db;}
.others {padding-bottom:2.7rem; background:#b4ffda;}
.others ul {overflow:hidden; width:90%; padding:0 2.8% 2.13rem; margin:0 auto; border:.28rem dashed #30d182; border-radius:.42rem; background:#fff;}
.others li {float:left; width:50%; font-size:1.1rem; padding:2.13rem 2.8% 0; text-align:center;}
.others .thumbnail {overflow:hidden; margin-bottom:.94rem; border:.28rem solid #f87942; border-radius:50%;}
.others li p {white-space:nowrap;}
.others li b {font-weight:bold;}
.ly-finish {display:none; position:fixed; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.6); z-index:10;}
.ly-finish .inner {overflow:hidden; position:absolute; left:6%; width:88%; top:50%; transform:translateY(-50%); text-align:center; background:#fff; border-radius:.42rem;}
.ly-finish .txt {padding:3.33rem 0;}
.ly-finish .txt b {display:inline-block; border-bottom:.43rem solid #60f2ab; font:normal 2rem/.7 'NotoSansKRBold';}
.ly-finish .txt b:first-child {margin-bottom:.8rem;}
.ly-finish .txt p {padding-top:2.4rem; font-size:1.2rem; color:#444; line-height:1.4;}
.ly-finish .txt strong {display:block; color:#ff1515; font-family:'CoreSansCMedium','NotoSansKRMedium';}
.ly-finish .btn-close {position:absolute; right:0; top:0; width:5.12rem; height:5.12rem; text-indent:-999em;}
.ly-finish .btn-close:before,
.ly-finish .btn-close:after {content:''; position:absolute; left:50%; top:50%; width:.3rem; height:2.2rem; margin:-1.1rem 0 0 -.15rem; background:#555; transform: rotate(-45deg);}
.ly-finish .btn-close:after {transform: rotate(45deg);}
</style>
<script type="text/javascript">
    var vScrl=true;

    $(function(){
        $(".ly-finish .btn-close").click(function(){
            $(".ly-finish").hide();
        });        
        vScrl = true;
        getUserChangeRoomList();
    });

    <%'// 바꿔방 스크롤 이벤트 %>
    $(window).scroll(function () {
        if ($(window).scrollTop() >= ($(document).height()-$(window).height())-900) {
            if(vScrl) {
                vScrl = false;
                $("#currpage").val(parseInt($("#currpage").val())+1);
                setTimeout(function () {
                    getUserChangeRoomList();
                }, 150);
            }
        }
    });

    <%'// 상품 등록 팝업 %>
    function fnChangeRoomPopupSubmit(vType) {
        <% IF application("Svr_Info") = "Dev" THEN %>
            window.open("<%=wwwUrl%>/apps/appCom/wish/web2014/event/etc/popChangeRoomEvent100420.asp?vType="+vType);
        <% Else %>
            <% If IsUserLoginOK() Then %>
                fnAPPpopupBrowserURL("상품등록","<%=wwwUrl%>/apps/appCom/wish/web2014/event/etc/popChangeRoomEvent100420.asp?vType="+vType);
            <% Else %>
                <% if isApp=1 then %>
                    parent.calllogin();
                    return false;
                <% else %>
                    parent.jsChklogin_mobile('','<%=Server.URLencode("/apps/appCom/wish/web2014/event/eventmain.asp?eventid=")%>');
                    return false;
                <% end if %>
            <% End If %>
        <% End If %>
    }

    <%'// 상품 등록 팝업에서 상품을 선택하면 해당 function 호출 %>
    function fnSetChangeRoomArea(imgurl, itemid, sellprice, vtype) {
        $("#"+vtype+"Area").empty().html("<div class='thumbnail'><img src='"+imgurl+"'><button class='btn-delete' onclick='fnRemoveChageRoomArea(\""+vtype+"\");'>상품 삭제</button></div>");
        $("#"+vtype+"ItemId").val(itemid);
        $("#"+vtype+"ItemPrice").val(sellprice);
        fnChangeRoomSubmitButtonCheck();
        fnCalculationItemPrice();
    }

    <%'// 등록시 사용자가 상품이미지 우측상단 X를 클릭시에 발생할 이벤트 %>
    function fnRemoveChageRoomArea(vtype) {
        var areaName;
        switch (vtype) {
            case "table":
                areaName = "테이블";
                break;
            case "light":
                areaName = "조명";
                break;                

            case "wardrobe":
                areaName = "옷장";
                break;                

            case "bed":
                areaName = "침대";
                break;                

            case "bedding":
                areaName = "페브릭";
                break;                

            case "chair":
                areaName = "의자";
                break;                
        }
        $("#"+vtype+"Area").empty().html("<button class='btn-select' onclick='fnChangeRoomPopupSubmit(\""+vtype+"\");return false;'>"+areaName+" 상품 선택하기</button>");
        $("#"+vtype+"ItemId").val("");
        $("#"+vtype+"ItemPrice").val("0");
        fnChangeRoomSubmitButtonCheck();
        fnCalculationItemPrice();        
    }

    <%'// 응모하기 버튼 활성화 체크 %>
    function fnChangeRoomSubmitButtonCheck() {
        if ( $.trim($('#tableItemId').val()) != '' && $.trim($('#lightItemId').val()) != '' && $.trim($('#wardrobeItemId').val()) != '' && $.trim($('#bedItemId').val()) != '' && $.trim($('#beddingItemId').val()) != '' && $.trim($('#chairItemId').val()) != '' ) {
            $("#submitButtonArea").empty().html("<img src='//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_submit.png' alt='응모하기'>");
        } else {
            $("#submitButtonArea").empty().html("<img src='//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_ready.png' alt='응모하기'>");
        }
    }

    <%'// 담은 금액 계산 %>
    function fnCalculationItemPrice() {
        var totalItemPrice;
        totalItemPrice = Number($("#tableItemPrice").val())+Number($("#lightItemPrice").val())+Number($("#wardrobeItemPrice").val())+Number($("#bedItemPrice").val())+Number($("#beddingItemPrice").val())+Number($("#chairItemPrice").val());
        $("#sumofItemValueArea").empty().html(numberWithCommas(totalItemPrice));
        <%'// 금액이 80만원 초과일 경우 class 추가 %>
        if ( totalItemPrice > 800000 ) {
            $("#totalSumOverCheckArea").addClass("over");
        } else {
            $("#totalSumOverCheckArea").removeClass("over");
        }
    }


    <%'// 사용자가 응모하기 버튼을 클릭하면 등록 %>
    function changeRoomProc() {
        if ( $.trim($('#tableItemId').val()) != '' && $.trim($('#lightItemId').val()) != '' && $.trim($('#wardrobeItemId').val()) != '' && $.trim($('#bedItemId').val()) != '' && $.trim($('#beddingItemId').val()) != '' && $.trim($('#chairItemId').val()) != '' ) {
            var totalItemPrice;
            totalItemPrice = Number($("#tableItemPrice").val())+Number($("#lightItemPrice").val())+Number($("#wardrobeItemPrice").val())+Number($("#bedItemPrice").val())+Number($("#beddingItemPrice").val())+Number($("#chairItemPrice").val());            
            if ( totalItemPrice > 800000 ) {
                alert("상품은 총 80만 원까지만 담을 수 있습니다.");
                return;
            } else {
                $.ajax({
                    type:"POST",
                    url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript100420.asp",
                    data: $("#changeRoomInsert").serialize(),
                    dataType: "text",
                    async:false,
                    cache:true,
                    success : function(Data, textStatus, jqXHR){
                        if (jqXHR.readyState == 4) {
                            if (jqXHR.status == 200) {
                                if(Data!="") {
                                    var result = JSON.parse(Data)
                                    if(result.response == "ok"){
                                        $(".ly-finish").show();
                                        $('button').remove('.btn-delete');
                                        $("#submitButtonArea").empty().html("<img src='//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_finish.png' alt='응모완료'>");
                                        $("#submitButtonArea").removeAttr("onclick");
                                        $("#submitButtonArea").attr("onclick", "return false;");
                                        setTimeout(function(){fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>');}, 100);
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
        } else {
            alert("상품을 모두 선택해주세요.");
            return;
        }
    }

    <%'// 바꿔방 다른유저 리스트 불러오기 %>
    function getUserChangeRoomList() {
        $.ajax({
            type:"GET",
            url:"/apps/appCom/wish/web2014/event/etc/act_event_100420_user_list.asp",
            data:$("#changeRoomUserList").serialize(),
            dataType: "text",
            async:false,
            cache:true,
            success : function(Data, textStatus, jqXHR){
                if (jqXHR.readyState == 4) {
                    if (jqXHR.status == 200) {
                        if(Data!="") {
                            if($("#currpage").val()==1) {
                                res = Data.split("||");
                                $("#changeRoomUserListArea").empty().html(res[0]);
                                vScrl=true;
                            } else {
                                setTimeout(function () {
                                    res = Data.split("||");
                                    if (res[1]==0) {
                                        return false;
                                    }
                                    $('#changeRoomUserListArea').append(res[0]);
                                    vScrl=true;
                                }, 150);
                            }
                        } else {
                            //alert("잘못된 접근 입니다.");
                            //document.location.reload();
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

    function numberWithCommas(x) {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

</script>
</head>
<%' 100420 바꿔 방!(A) %>
<div class="mEvt100420">
    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/100420/m/tit_room.png" alt="바꿔 방"></h2>
    <div class="change-room">
        <form method="post" name="changeRoomInsert" id="changeRoomInsert">
        <input type="hidden" name="mode" id="mode" value="add">        
        <ul class="select-item">
            <% If confirmCheck Then %>
                <li class="tableAreaClass">
                    <div class='thumbnail'>
                        <img src="<%=tableItemImage%>">
                    </div>
                </li>
                <li>
                    <div class='thumbnail'>
                        <img src="<%=lightItemImage%>">
                    </div>
                </li>
                <li>
                    <div class='thumbnail'>
                        <img src="<%=wardrobeItemImage%>">
                    </div>
                </li>
                <li>
                    <div class='thumbnail'>
                        <img src="<%=bedItemImage%>">
                    </div>
                </li>                
                <li>
                    <div class='thumbnail'>
                        <img src="<%=beddingItemImage%>">
                    </div>
                </li>                                
                <li>
                    <div class='thumbnail'>
                        <img src="<%=chairItemImage%>">
                    </div>
                </li>                
            <% Else %>
                <li id="tableArea" class="tableAreaClass">
                    <button class="btn-select" onclick="fnChangeRoomPopupSubmit('table');return false;">테이블 상품 선택하기</button>
                </li>
                <input type="hidden" name="tableItemId" id="tableItemId" value="">
                <input type="hidden" name="tableItemPrice" id="tableItemPrice" value="0">

                <li id="lightArea" class="lightAreaClass">
                    <button class="btn-select" onclick="fnChangeRoomPopupSubmit('light');return false;">조명 상품 선택하기</button>
                </li>
                <input type="hidden" name="lightItemId" id="lightItemId" value="">
                <input type="hidden" name="lightItemPrice" id="lightItemPrice" value="0">
                
                <li id="wardrobeArea" class="wardrobeAreaClass">
                    <button class="btn-select" onclick="fnChangeRoomPopupSubmit('wardrobe');return false;">옷장 상품 선택하기</button>
                </li>
                <input type="hidden" name="wardrobeItemId" id="wardrobeItemId" value="">
                <input type="hidden" name="wardrobeItemPrice" id="wardrobeItemPrice" value="0">
                
                <li id="bedArea" class="bedAreaClass">
                    <button class="btn-select" onclick="fnChangeRoomPopupSubmit('bed');return false;">침대 상품 선택하기</button>
                </li>
                <input type="hidden" name="bedItemId" id="bedItemId" value="">
                <input type="hidden" name="bedItemPrice" id="bedItemPrice" value="0">
                
                <li id="beddingArea" class="beddingAreaClass">
                    <button class="btn-select" onclick="fnChangeRoomPopupSubmit('bedding');return false;">패브릭 상품 선택하기</button>
                </li>
                <input type="hidden" name="beddingItemId" id="beddingItemId" value="">
                <input type="hidden" name="beddingItemPrice" id="beddingItemPrice" value="0">

                <li id="chairArea" class="chairAreaClass">
                    <button class="btn-select" onclick="fnChangeRoomPopupSubmit('chair');return false;">의자 상품 선택하기</button>
                </li>
                <input type="hidden" name="chairItemId" id="chairItemId" value="">
                <input type="hidden" name="chairItemPrice" id="chairItemPrice" value="0">                
            <% End If %>
        </ul>
        <% If confirmCheck Then %>
            <%' for dev msg : 한도80 초과할 경우 클래스 over %>
            <p class="total <% If sumofItemValue > 800000 Then %>over<% End If %>">담은 금액 : <span><b><%=Formatnumber(sumofItemValue,0)%></b>원</span></p>
        <% Else %>
            <p class="total" id="totalSumOverCheckArea">담은 금액 : <span><b id="sumofItemValueArea">0</b>원</span></p>
        <% End If %>

        <div class="process">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/100420/m/txt_process.png" alt="참여방법">
        </div>
        
        <% If confirmCheck Then %>        
            <button class="btn-finish" onclick="return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_finish.png" alt="응모완료"></button>
        <% Else %>
            <button class="btn-submit" id="submitButtonArea" onclick="changeRoomProc();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100420/m/btn_ready.png" alt="응모하기"></button>
        <% End If %>
        </form>

        <%' 응모완료 레이어 %>
        <div class="ly-finish">
            <div class="inner">
                <button class="btn-close">닫기</button>
                <div class="txt">
                    <b>응모가</b><br><b>완료되었습니다!</b>
                    <p><strong>2월 26일 수요일</strong>당첨일을 기다려 주세요!</p>
                </div>
                <a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100349');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100420/m/bnr_ly_evt.jpg" alt=""></a>
            </div>
        </div>
        <%'// 응모완료 레이어 %>
    </div>
    <ul class="evt-bnr">
        <li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100368');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100420/m/bnr_evt_1.jpg" alt="새집 아이템 기획전"></a></li>
        <li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100349');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100420/m/bnr_evt_2.jpg" alt="자취 BEST 아이템"></a></li>
        <li><a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100452');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100420/m/bnr_evt_3.jpg" alt="토스로 결제하면 10,000원 즉시 할인!"></a></li>
    </ul>
    <div class="noti">
        <h3>유의사항</h3>
        <ul>
            <li>본 이벤트는 텐바이텐 APP에서 ID 당 1회만 참여 가능합니다.</li>
            <li>응모 완료 시 상품 수정이 불가합니다.</li>
            <li>당첨자는 총 5명이며, 공지사항 기재 및 개별 안내 예정입니다.</li>
            <li>당첨자에게는 세무 신고를 위해 개인 정보를 요청할 예정이며, 제세공과금은 텐바이텐 부담입니다.</li>
            <li>상품 지급 관련 구체적인 내용은 당첨자에게 별도 안내 예정입니다.</li>
        </ul>
    </div>
    <div class="others">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/100420/m/tit_others.png" alt="다른 사람들의 방 구경하기"></h3>
        <ul id="changeRoomUserListArea"></ul>
    </div>
</div>

<%'// 바꿔방 유저 리스트 %>
<form method="GET" name="changeRoomUserList" id="changeRoomUserList">
    <input type="hidden" name="currpage" id="currpage" value="1">
    <input type="hidden" name="eventcode" id="eventcode" value="<%=eCode%>">
</form>
<%' // 100420 바꿔 방! %>
<!-- #include virtual="/lib/db/dbclose.asp" -->