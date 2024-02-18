<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 18주년 메인 취향 이벤트
' History : 2019-09-23 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/18th/lib/classes/tasteCls.asp" -->
<%
    Dim Dv '// 하단 날짜 히스토리 표시시 루프돌 변수
    Dim Mv '// 하단 날짜 히스토리 표시 관련 월숫자값
    Dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1) '// gnb사용여부
    Dim currentDate : currentDate = RequestCheckVar(request("currentdate"),15) '// 오픈해야될 취향 데이터 일자
    Dim todayDate : todayDate = Left(now(), 10) '// 오늘일자
    Dim tabType '// 하단 날짜 히스토리 css 타입
    Dim initialSlideNumber '// 스와이퍼 날짜 부분 타겟 영역 값
    Dim chasu '// currentDate값을 기준으로 만든 변수(해당 페이지 표시 데이터의 키값)
    Dim loginUserId
    Dim FrontViewNumber '// 프론트에 표시될 회차
    Dim i

    '// 사용자 지정 일자가 없을경우 오늘 날짜로 셋팅
    If Trim(currentDate) = "" Then
        currentDate = todayDate
    End If

    '// 2019년 10월 31일 일 경우 페이지는 보여주는데 데이터는 30일 데이터를 보여줘야됨
    If (currentDate = "2019-10-31" Or todayDate = "2019-10-31") and RequestCheckVar(request("currentdate"),15) = "" Then
        currentDate = "2019-10-30"
    End If
    
    '// chasu 생성
    chasu = replace(Trim(currentDate),"-","")
    
    '// 사용자 아이디
    loginUserId = getEncLoginUserId

    If gnbflag = "" Then '// gnb 표시여부
        gnbflag = true
    Else
        gnbflag = False
        strHeadTitleName = "오늘의 취향"
    End if

    '// 스와이퍼 날짜셋 위치 잡기
    If Cint(day(cdate(currentdate)))-2 < 0 Then
        initialSlideNumber = 0
    Else
        If Cint(month(cdate(currentdate))) < 10 Or Cint(month(cdate(currentdate))) > 10 Then
            initialSlideNumber = 0
        Else
            initialSlideNumber = Cint(day(cdate(currentdate)))-2
        End If
    End If

    '// currentDate를 통한 chasu로 취향 이벤트 마스터 불러옴
    Dim oTasteMaster
    set oTasteMaster = new CTaste
    oTasteMaster.FRectChasu = chasu
    oTasteMaster.GetTasteMasterOne

    If IsUserLoginOK() Then
        '// masteridx와 chasu를 기반으로 로그인한 사용자가 등록한 오늘의 취향이 있는지 확인
        Dim oTasteUserDetail
        Set oTasteUserDetail = new CTaste
        oTasteUserDetail.FRectMasterIdx = oTasteMaster.FOneItem.FIdx
        oTasteUserDetail.FRectChasu     = chasu
        oTasteUserDetail.FRectUserID    = loginUserId
        oTasteUserDetail.GetTasteDetailUserOne
    End If

    '// 해당일자 주년 사용자가 입력한 취향 데이터 중 가장 최근에 등록한 상품 1개 불러옴
    Dim oTasteDetailTopOne
    Set oTasteDetailTopOne = new CTaste
    oTasteDetailTopOne.FRectMasterIdx = oTasteMaster.FOneItem.FIdx
    oTasteDetailTopOne.FRectChasu     = chasu
    If IsUserLoginOK() Then
        oTasteDetailTopOne.FRectUserID    = LoginUserid
    End If
    oTasteDetailTopOne.GetTasteDetailTopOne

    '// 나의 취향 상단 히스토리 Nav메뉴 불러오기(사용자가 입력했을경우 값 포함)
    dim oTasteMyHistoryNav
    set oTasteMyHistoryNav = new CTaste
    oTasteMyHistoryNav.FRectUserID = LoginUserid
    oTasteMyHistoryNav.getTasteUserHistoryNavList

    '// 일자 = 회차(프론트 표시에 사용될 회차 )
    If Len(CInt(day(cdate(currentdate)))) = 1 Then
        FrontViewNumber = "# 00"&CInt(day(cdate(currentdate)))
    Else
        FrontViewNumber = "# 0"&CInt(day(cdate(currentdate)))
    End If

    '// SNS 공유용
    Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink, snpTag2, kakaourl

    snpTitle	= "[텐바이텐 18주년] 오늘, 당신의 취향"
    snpLink		= "http://m.10x10.co.kr/event/18th/index.asp?gnbflag=1"
    snpPre		= "10x10 이벤트"
    snpImg		= "http://webimage.10x10.co.kr/eventIMG/2019/97587/etcitemban20190930155434.JPEG"
    appfblink	= "http://m.10x10.co.kr/event/18th/index.asp?gnbflag=1"
    kakaourl	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/18th/index.asp?gnbflag=1"
    snpTag 		= "[텐바이텐 18주년] 오늘, 당신의 취향"
    snpTag2 = "#10x10"

    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = "[텐바이텐 18주년] 오늘, 당신의 취향"
    Dim kakaodescription : kakaodescription = "나의 취향 등록하고 100만원 받자"
    Dim kakaooldver : kakaooldver = "나의 취향 등록하고 100만원 받자"
    Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2019/97587/etcitemban20190930155434.JPEG"
    Dim kakaolink_url

    If isapp = "1" Then '앱일경우
	    kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/18th/index.asp?gnbflag=1"
    Else '앱이 아닐경우
        kakaolink_url = "http://m.10x10.co.kr/event/18th/index.asp?gnbflag=1"
    End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
    '// Master데이터가 없는 일자로 들어올시에는 튕겨냄
    If Trim(oTasteMaster.FOneItem.FIdx) = "" Then
        If gnbflag Then
            Response.Write "<script>alert('정상적인 경로로 접근해 주세요.');history.back();</script>"
        Else
            Response.Write "<script>alert('정상적인 경로로 접근해 주세요.');fnAPPclosePopup();</script>"
        End If
        Response.End
    End If
%>
<script src="/apps/appCom/wish/web2014/lib/js/adultAuth.js?v=1.3"></script>
<script type="text/javascript">
    var vScrl=true;

    $(function(){
        <% If gnbflag <> "" Then %>
            fnAPPchangPopCaption("오늘의 취향");
        <% End If %>

        dateSwiper = new Swiper('.day-nav .swiper-container',{
            initialSlide:<%=initialSlideNumber%>,
            slidesPerView:'auto',
            speed:300
        });
        $('.day-nav .swiper-slide.coming').on('click', function(e){
            e.preventDefault();
            alert("coming soon :)");
        });

        <% If oTasteDetailTopOne.FOneItem.FDetailIdx <> "" Then %>
            vScrl = true;
            getUserTasteList();
        <% End If %>
        setTimeout(function(){fnAmplitudeEventMultiPropertiesAction("view_18thtaste","chasu18th","<%=chasu%>","");}, 100);
    });

    <%'// 타인의 취향 스크롤 이벤트 %>
    $(window).scroll(function () {
        <% If oTasteDetailTopOne.FOneItem.FDetailIdx <> "" Then %>
            if ($(window).scrollTop() >= ($(document).height()-$(window).height())-500) {
                if(vScrl) {
                    vScrl = false;
                    $("#currpage").val(parseInt($("#currpage").val())+1);
                    setTimeout(function () {
                        getUserTasteList();
                    }, 150);
                }
            }
        <% End If %>
    });

    <%'// 취향 등록 팝업 %>
    function fnTasteSubmit() {
        <% If IsUserLoginOK() Then %>
            fnAPPpopupBrowserURL("취향등록","<%=wwwUrl%>/apps/appCom/wish/web2014/event/18th/pop_taste_search_list.asp?rect=<%=Server.URLEncode(oTasteMaster.FOneItem.FSearchKeyWord)%>&fnumber=<%=Server.URLEncode(FrontViewNumber)%>&fviewText=<%=Server.URLEncode(oTasteMaster.FOneItem.FMainKeyWord)%>");
            setTimeout(function(){fnAmplitudeEventMultiPropertiesAction("click_18thtastepopup","chasu18th","<%=Trim(chasu)%>","");}, 100);
        <% Else %>
            <% if isApp=1 then %>
                parent.calllogin();
                return false;
            <% else %>
                parent.jsChklogin_mobile('','<%=Server.URLencode("/event/18th/")%>');
                return false;
            <% end if %>
        <% End If %>
    }

    <%'// 취향 등록 팝업에서 상품을 선택하면 해당 function 호출 %>
    function fnSetTasteArea(imgurl, itemid, viewIdx) {
        $("#selectedThumbArea").addClass('selected-taste');
        $("#thumbBtn").empty().html('<button class="btn-remove" onclick="fnRemoveTasteArea();return false;">삭제</button>');
        $("#thumbImg").empty().html('<img src="'+imgurl+'">');
        $("#tasteItemId").val(itemid);
		$("#tasteviewIdx").val(viewIdx);
        $("#tasteConfirmBtn").addClass("on");
    }

    <%'// 등록시 사용자가 취향 상품이미지 우측상단 X를 클릭시에 발생할 이벤트 %>
    function fnRemoveTasteArea() {
        $("#selectedThumbArea").addClass('not-selected');
        $("#thumbBtn").empty().html('<button class="btn-selct" onclick="fnTasteSubmit();return false;"><i class="icon-cross"></i><span>취향 등록하기</button>');
        $("#thumbImg").empty();
        $("#tasteItemId").val("");
		$("#tasteviewIdx").val("");
        $("#tasteConfirmBtn").removeClass("on");
    }

    <%'// 사용자가 취향 등록하기 버튼을 클릭하면 등록 %>
    function tasteProc() {
        if($("#tasteConfirmBtn").hasClass("on")===true) {
            if($("#tasteItemId").val()=="") {
                alert("상품을 선택해주세요.");
                return;
            }
            $.ajax({
                type:"POST",
                url:"/event/18th/lib/ajaxTaste.asp",
                data: $("#tasteInsert").serialize(),
                dataType: "text",
                async:false,
                cache:true,
                success : function(Data, textStatus, jqXHR){
                    if (jqXHR.readyState == 4) {
                        if (jqXHR.status == 200) {
                            if(Data!="") {
                                var result = JSON.parse(Data)
                                if(result.response == "ok"){
                                    //document.location.reload();
                                    //fnAPPselectGNBMenu("taste","<%=wwwUrl%>/apps/appCom/wish/web2014/event/18th/?currentdate='+result.currentdate+'#dayNavArea");
                                    //document.location.href='<%=wwwUrl%>/apps/appCom/wish/web2014/event/18th/?currentdate='+result.currentdate+'#dayNavArea';
                                    $("#thumbBtn").empty();
                                    $("#tasteConfirmBtn").removeClass("on");
                                    if(result.rewardstatus == "1") {
                                        $("#saleValueFirst").empty().html('<i>추가</i>'+result.rewardvalue+'%');
                                        $("#saleValueSecond").empty().html('추가'+result.rewardvalue+'%쿠폰');
                                        $(".lyr-taste").show();
                                        setTimeout(function(){fnAmplitudeEventMultiPropertiesAction("click_18thtastecomplete","itemid|chasu18th",$("#tasteItemId").val()+"|<%=Trim(chasu)%>","");}, 100);
                                    } else if(result.rewardstatus == "0") {
                                        alert("취향 등록 완료!\n아쉽지만, SPECIAL GIFT는\n당일에 한함");
                                        setTimeout(function(){fnAmplitudeEventMultiPropertiesAction("click_18thtastecomplete","itemid|chasu18th",$("#tasteItemId").val()+"|<%=Trim(chasu)%>","");}, 100);
                                    }
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
        } else {
            return;
        }
    }

    // 취향 팝업 레이어 닫기
    function ClosePopLayer() {
        $('.lyr-taste').hide();
    }

    <%'// 나의 취향 히스토리 팝업 %>
    function myTasteHistoryPop() {
        <% If IsUserLoginOK() Then %>
            fnAPPpopupBrowserURL("나의 취향","<%=wwwUrl%>/apps/appCom/wish/web2014/event/18th/pop_mytaste_list.asp");
        <% Else %>
            <% if isApp=1 then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode("/event/18th/")%>');
                return false;
            <% end if %>
        <% End If %>
    }

    <%'// 나의 취향 히스토리 팝업에서 입력 안된 부분 클릭하면 호출하는 function %>
    function fnMyTasteHistoryParent(cdt) {
        document.location.href='<%=wwwUrl%>/apps/appCom/wish/web2014/event/18th/?currentdate='+cdt+'<% If Not(gnbflag) Then %>&gnbflag=1<% End If %>#historyTargetArea';
    }

    <%'// 타인의 취향 리스트 불러오기 %>
    function getUserTasteList() {
        $.ajax({
            type:"GET",
            url:"/apps/appCom/wish/web2014/event/18th/act_taste_user_list.asp",
            data:$("#tasteOtherUser").serialize(),
            dataType: "text",
            async:false,
            cache:true,
            success : function(Data, textStatus, jqXHR){
                if (jqXHR.readyState == 4) {
                    if (jqXHR.status == 200) {
                        if(Data!="") {
                            if($("#currpage").val()==1) {
                                res = Data.split("||");
                                $("#otherUserList").empty().html(res[0]);
                                $("#othertasteusercnt").empty().html(res[1]);
                                vScrl=true;
                            } else {
                                setTimeout(function () {
                                    res = Data.split("||");
                                    if (res[1]==0) {
                                        return false;
                                    }
                                    $('#otherUserList').append(res[0]);
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

    <%'// 타인의 취향 위시 등록/삭제 %>
   function fnOtherTasteWishAct(iid, t) {
        <% If IsUserLoginOK() Then %>
            $("#tasteItemId").val(iid);

            if($(t).hasClass('on')===true) {
                $("#mode").val('otherWishDelete');
                $.ajax({
                    type:"POST",
                    url:"/event/18th/lib/ajaxTaste.asp",
                    data: $("#tasteInsert").serialize(),
                    dataType: "text",
                    async:false,
                    cache:true,
                    success : function(Data, textStatus, jqXHR){
                        if (jqXHR.readyState == 4) {
                            if (jqXHR.status == 200) {
                                if(Data!="") {
                                    var result = JSON.parse(Data)
                                    if(result.response == "ok"){
                                        $(t).toggleClass("on");
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
            } else {
                $("#mode").val('otherWishAdd');
                $.ajax({
                    type:"POST",
                    url:"/event/18th/lib/ajaxTaste.asp",
                    data: $("#tasteInsert").serialize(),
                    dataType: "text",
                    async:false,
                    cache:true,
                    success : function(Data, textStatus, jqXHR){
                        if (jqXHR.readyState == 4) {
                            if (jqXHR.status == 200) {
                                if(Data!="") {
                                    var result = JSON.parse(Data)
                                    if(result.response == "ok"){
                                        $(t).toggleClass("on");
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
        <% Else %>
            <% if isApp=1 then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode("/event/18th/")%>');
                return false;
            <% end if %>
        <% End If %>
    }

    function fnAPPRCVpopSNS(){
        //fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
        $("#lySns").show();
        $("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
        return false;
    }
</script>

</head>
<body  class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
<div id="content" class="content">
    <div class="evtContV15">
        <%' 18주년 메인 %>
        <div class="anniversary18th main bg-random">
            <!-- #include virtual="/event/18th/lib/head18th.asp" -->
            <%' intro %>
            <div class="intro">
                <div class="inner">
                    <span class="anniversary">18th</span>
                    <h2>Your 10X10</h2>
                    <div class="intro-sub">18번째 생일,<br>텐바이텐과 함께 해주셔서 고맙습니다.</div>
                    <ul class=evt-list>
                        <li><a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97589');return false;">스누피의 선물 <span class="icon-chev"></span></a></li>
                        <li><a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97588');return false;">나에게 텐바이텐은? <span class="icon-chev"></span></a></li>
                    </ul>
                </div>
            </div>
            <%'// intro %>

            <%' taste %>
            <div class="taste">
                <div class="top">
                    <div class="inner">
                        <% If IsUserLoginOK Then %>
                            <h3>오늘, <br><span class="name"><%=getLoginUserName%></span>님의 취향<span class="icon-chev"></span></h3>
                        <% Else %>
                            <h3>오늘, <br><span class="name">당신</span>의 취향<span class="icon-chev"></span></h3>
                        <% End If %>
                        <div class="taste-sub">당신이<br>좋아하는 것들을 알려주세요.</div>
                        <div class="taste-date">기간 : 10.01 – 31 | 당첨자 발표 : 11.04</div>
                        <div class="bnfit">
                            <%'// 변경 여지 있음(쿠폰 리워드) %>
                            <div class="bnfit-item">
                                <div class="bnfit-date">EVERY<br>DAY</div>
                                <div class="bnfit-conts"><span>SPECIAL GIFT</span><p>매일 오픈하는 오늘의 취향을  등록해 주신 분께 <strong>스페셜 선물</strong>을 드립니다. (당일 참여자에 한함) </p></div>
                            </div>
                            <div class="bnfit-item">
                                <div class="bnfit-date">LAST<br>DAY</div>
                                <div class="bnfit-conts"><span>100만원 기프트 카드</span><p>매일 참여하지 않아도 30개의 취향을 모두 등록해주신 분 중 <strong>10명에게 텐바이텐 기프트카드 100만원</strong>을 선물로 드립니다.</p></div>
                            </div>
                            <span id="historyTargetArea"></span>
                        </div>
                    </div>
                </div>
                <div class="conts" id="dayNavArea">
                    <div class="day-nav">
                        <div class="month">OCT</div>
                        <div class="swiper-container">
                            <ul class="swiper-wrapper">
                                <%' for dev msg 오픈된 탭 : open / 현재 탭 : current / 오픈예정 : coming %>
                                <%' for dev msg 오픈된 탭(취향선택 한 탭) : open / 취향선택 안한 탭 : not / 현재 탭 : current / 오픈예정 : coming  (2019년 10월 4일 요청으로 변경) ㅡ.ㅡ.%>
                                <% If oTasteMyHistoryNav.FResultCount > 0 Then  %>
                                    <% FOR i = 0 to oTasteMyHistoryNav.FResultCount-1 %>
                                        <%
                                            Dv = i+1
                                            '// 현재 일자 기준
                                            If Dv > day(cdate(todayDate)) Then
                                                tabType = "coming"
                                            Else
                                                If Isnull(oTasteMyHistoryNav.FItemList(i).FDetailIdx) Then
                                                    tabType = "not"
                                                Else
                                                    tabType = "open"
                                                End If
                                            End If

                                            '// 현재 탭(currentdate 데이터 기준)
                                            If Dv = day(cdate(currentdate)) Then
                                                tabType = "current"
                                            End If

                                            If Len(Trim(Dv)) = 1 Then
                                                Dv = "0"&Dv
                                            End If
                                            '// 18주년 진행달인 10월 이전과 이후로만 구분하여 이전 coming 이후 open으로 셋팅
                                            If Cint(month(cdate(currentdate))) < 10 Then
                                                tabType = "coming"
                                            End If
                                            If Cint(month(cdate(currentdate))) > 10 Then
                                                tabType = "open"
                                            End If
                                        %>
                                        <li class="swiper-slide <%=tabType%>"><a href="/apps/appCom/wish/web2014/event/18th/?currentdate=2019-10-<%=Dv%><% If Not(gnbflag) Then %>&gnbflag=1<% End If %>#dayNavArea"><span><%=Dv%></span></a></li>
                                    <% Next %>
                                <% End If %>
                            </ul>
                        </div>
                    </div>
                    <%' 나의 취향 %>
                    <div class="my-taste" id="my-taste">
                        <div class="inner">
                            <div class="series">
                                <span class="series-num"><%=FrontViewNumber%></span>
                                <h4 class="series-item"><%=oTasteMaster.FOneItem.FMainKeyWord%></h4>
                                <span class="series-sub"><%=oTasteMaster.FOneItem.FSubText%></span>
                            </div>
                            <%' 기존에 오늘의 취향을 등록했을경우 %>
                            <% If IsUserLoginOK() Then %>
                                <% If Trim(oTasteUserDetail.FOneItem.FDetailIdx) <> "" Then %>
                                    <div class="not-selcted">
                                        <span class="thumbnail"><img src="<%=oTasteUserDetail.FOneItem.FBasicImage%>?cmd=thumb&w=400&h=400&fit=true&ws=false"></span>
                                    </div>
                                <% Else %>
                                    <%
                                        ' 취향등록 사진이 등록되면 not-selected->selected-taste 클래스로 변경
                                        ' thumbBtn 부분을 <button class="btn-remove">삭제</button> 태그로 변경
                                        ' thumbImg 부분을 사용자가 선택상 상품 BasicImage로 삽입
                                        ' 이미지 태그 <img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/237/B002374186-2.jpg?cmd=thumb&w=400&h=400&fit=true&ws=false" alt="">
                                        ' 등록된 후 페이지 로드시엔 삭제버튼과 등록완료버튼 숨기고 사진만 보여줌
                                    %>
                                    <div class="not-selcted" id="selectedThumbArea">
                                        <span class="thumbnail" id="thumbImg"></span>
                                        <span id="thumbBtn"><button class="btn-selct" onclick="fnTasteSubmit();return false;"><i class="icon-cross"></i><span>취향 등록하기</button></span>
                                    </div>
                                <% End If %>
                            <% Else %>
                                <div class="not-selcted" id="selectedThumbArea">
                                    <span class="thumbnail" id="thumbImg"></span>
                                    <span id="thumbBtn"><button class="btn-selct" onclick="fnTasteSubmit();return false;"><i class="icon-cross"></i><span>취향 등록하기</button></span>
                                </div>
                            <% End if %>
                            <%
                                ' 취향등록 ing
                                ' 상품을 선택했을 경우에만 btn-cmp on 클래스 추가
                            %>
                            <button class="btn-cmp" id="tasteConfirmBtn" onclick="tasteProc();">등록 완료<span class="icon-chev"></span></button>
                            <div class="taste-history">
                                <a href="" onclick='myTasteHistoryPop();return false;'><span>나의 취향</span></a>
                                <a href="" onclick="fnAPPpopupBrowserURL('위시','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/myWish/myWish.asp','right','','sc'); return false;"><p class="sub">등록한 상품은 <em>[마이텐바이텐 > 위시]</em>에서도 확인 가능합니다.</p> </a>
                            </div>
                        </div>
                    </div>
                    <%'// 나의 취향 %>

                    <%' 타인의 취향 %>
                    <% If oTasteDetailTopOne.FOneItem.FDetailIdx <> "" Then %>
                        <div class="othr-taste">
                            <div class="othr-top">
                                <!--<span class="taste-item">fixed text</span>-->
                                <%' for dev msg 아래 thumbnail 은 가장 최신에 올린 이미지를 보여주세요. / thumbnail : 420*420%>
                                <span class="thumbnail"><img src="<%=oTasteDetailTopOne.FOneItem.FBasicImage%>?cmd=thumb&w=420&h=420&fit=true&ws=false" alt=""></span>
                                <span class="total-num"><i id="othertasteusercnt"></i>명의<br/><%=oTasteMaster.FOneItem.FMainKeyWord%></span>
                                <h4><span class="t1">오늘,</span><br/><span class="t2">타인의 취향</span></h4>
                                <p class="othr-sub">마음에 드는 타인의 취향에 하트를 눌러보세요! 등록한 상품은<br><em><a href="" onclick="fnAPPpopupBrowserURL('위시','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/myWish/myWish.asp','right','','sc'); return false;">[마이텐바이텐 > 위시]</a></em> 에서 확인 가능해요! </p>
                            </div>
                            <div class="othr-list-wrap">
                                <ul class="othr-list" id="otherUserList"></ul>
                            </div>
                        </div>
                    <% End If %>
                    <%'// 타인의 취향 %>
                </div>

                <%' 취향 쿠폰 레이어 팝업 %>
                <div class="lyr-taste" style="display:none;" onclick="ClosePopLayer();">
                    <div class="inner">
                        <p class="only-today"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_coupon_v2.png" alt="단, 24시간만!"></p>
                        <div class="coupon-info">
                            <strong class="sale" id="saleValueFirst"></strong>
                            <div class="gift">등록하신 <span><%=oTasteMaster.FOneItem.FMainKeyWord%></span>취향을 응원하는 <b class="sale" id="saleValueSecond"></b>을 선물로 드립니다.</div>
                            <p class="check">발급시간 24시간만 사용가능한 쿠폰입니다. <br>쿠폰은 <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/mymain.asp','right','','sc'); return false;">마이텐바이텐</a>에서 확인할 수 있습니다</p>
                        </div>
                        <button class="btn-close" onclick="ClosePopLayer();">닫기</button>
                        <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/couponbook.asp');return false;" class="btn-coupon">쿠폰함 바로 가기<span class="icon-chev"></span></a>
                    </div>
                </div>
                <%'// 취향 쿠폰 레이어 팝업 %>
            </div>
            <%'// taste %>
        </div>
        <%'// 18주년 메인 %>
    </div>
    <%'// 나의/타인의 취향 등록/삭제 %>
    <form method="post" name="tasteInsert" id="tasteInsert">
        <input type="hidden" name="mode" id="mode" value="add">
        <input type="hidden" name="tasteItemId" id="tasteItemId">
		<input type="hidden" name="tasteviewIdx" id="tasteviewIdx">
        <input type="hidden" name="masterIdx" id="masterIdx" value="<%=oTasteMaster.FOneItem.FIdx%>">
        <input type="hidden" name="chasu" id="chasu" value="<%=chasu%>">
        <input type="hidden" name="currentdate" id="currentdate" value="<%=currentDate%>">
    </form>
    <%'// 타인의 취향 리스트 %>
    <form method="GET" name="tasteOtherUser" id="tasteOtherUser">
        <input type="hidden" name="currpage" id="currpage" value="1">
        <input type="hidden" name="otherchasu" id="otherchasu" value="<%=chasu%>">
        <input type="hidden" name="otherMasterIdx" id="otherMasterIdx" value="<%=oTasteMaster.FOneItem.FIdx%>">
    </form>
<!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<%
    Set oTasteMaster = Nothing
    Set oTasteUserDetail = Nothing
    Set oTasteDetailTopOne = Nothing
    Set oTasteMyHistoryNav = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
