<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리 스토리 2020 다꾸톡톡
' History : 2019-09-03 원승현 생성
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
<%
Dim vDate, vRankingCount, vCateType, sqlStr, vDaccuType, i, gnbflag, j
Dim UserPageSize, UserCurrPage

gnbflag = RequestCheckVar(request("gnbflag"),1)

    gnbflag = False
    strHeadTitleName = "다이어리 스토리"

Dim oDaccuTalk, oDaccuTalkDetail, oDaccuTalkUserList
set oDaccuTalk = new CDaccuTokTok
oDaccuTalk.FPageSize = 1000
oDaccuTalk.FCurrPage = 1
oDaccuTalk.GetDaccuTokTokManagerList

set oDaccuTalkDetail = new CDaccuTokTok
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2020.css?v=1.20" />
<script type="text/javascript" src="/lib/js/jquery.masonry.min.js"></script>
<script type="text/javascript">

var vScrl=true;
$(window).load(function(){
    // masonry layout
    $('.best-list').masonry({
        itemSelector:".best-list li"
    });
});
// slide autoheight
function resizeSwiper() {
    var innerH = $('.swiper-slide-active img').outerHeight();
    calcH = "calc(" + innerH +"px +" + " 10.14rem)"
    $('.md-rolling .swiper-container').css('height' , calcH);
}
$(function() {
    // md rolling
    var $total = $('.md-rolling').find(".swiper-slide").length;
	var $initScale = 1 / $total;
	var $progressFill = $('.md-rolling').find(".pagination-fill");
	function mdswiper(){
        mdSwiper = new Swiper('.md-rolling .swiper-container',{
            loop:true,
            autoplay:false,
            speed:800,
            effect:'fade',
            onSlideChangeStart: function (mdSwiper) {
                resizeSwiper();
                $('.mark-list').removeClass('on');
                $('.dctem-alert').css('display','block');
                // progress bar
                var $current = mdSwiper.activeIndex;
                if ($current == 0) {
                    var $scale = 1;
                } else if ($current > $total) {
                    var $scale = $initScale;
                } else {
                    var $scale = $initScale * $current;
                }
                $progressFill.css("transform", "scaleX(" + $scale + ")");
            }
        });
    }
    mdswiper();
    $(window).resize(function () {mdswiper();});

    // 다꾸템 등록 버튼 노출
    $(window).scroll(function () {
        var scrollT = $(window).scrollTop();
        var contsT = $('.best-dctalk').offset().top;
        if(scrollT > contsT-200) {
            $('.btn-regist-daccutem').css('right','0');
        } else {
            $('.btn-regist-daccutem').css('right','-12rem');
        }
        if ($(window).scrollTop() >= ($(document).height()-$(window).height())-100) {
			if(vScrl) {
				vScrl = false;
                $("#userCurrPage").val(parseInt($("#userCurrPage").val())+1);
                getUserDaccuMasterList();
			}            
        }
    });

    // 태그 위치
   function posTag() {
        $('.mark').each(function () {
            var posX = Math.floor($(this).css('left').replace('px', ''));
            var imgW = $("div").outerWidth();
            var calcX = Math.floor(posX / imgW * 100);
            if (calcX > 50) {
                $(this).find('.box').addClass('l-dir');
            } else {
                $(this).find('.box').addClass('r-dir');
            }
        });
    }

    // 클릭시 태그 노출
   $('.md-dctalk .swiper-slide .thumbnail img').click(function (e) {
        e.preventDefault();
        $('.dctem-alert').css('display','none');
        var markList= $('.md-dctalk .mark-list');
        $(markList).toggleClass('on');
        if(markList.hasClass('on')){
            posTag();
        }
    });
    vScrl = true;
    getUserDaccuMasterList();
    fnAmplitudeEventMultiPropertiesAction('view_diary_daccutoktok','','');

});

function daccuTokWrite() {
    <% If IsUserLoginOK() Then %>
        location.href="daccu_toktok_write.asp";
    <% Else %>
        <% if isApp=1 then %>
            parent.calllogin();
            return false;
        <% else %>
            parent.jsChklogin_mobile('','<%=Server.URLencode("/diarystory2020/daccu_toktok.asp")%>');
            return false;
        <% end if %>
    <% End If %>
}

function getUserDaccuMasterList() {
    $.ajax({
        type:"GET",
        url:"/diarystory2020/act_daccu_toktok_usermasterlist.asp",
        data:$("#daccuUserMaster").serialize(),
        dataType: "text",
        async:false,
        cache:true,
        success : function(Data, textStatus, jqXHR){
            if (jqXHR.readyState == 4) {
                if (jqXHR.status == 200) {
                    if(Data!="") {
                        if($("#userCurrPage").val()==1) {
                            $("#userMasterList").empty().html(Data);
                            vScrl=true;
                        } else {
                            $str = $(Data);

                            setTimeout(() => {
                                $('#userMasterList').append($str).masonry('appended',$str);
                                $('.best-list').masonry({
                                    itemSelector:".best-list li"
                                });
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

function daccutoktokView(midx) {
    fnOpenModal('/diarystory2020/daccu_toktok_view.asp?masterIdx='+midx);
}

<%'// 사용자가 등록한 다꾸 삭제 %>
function fnDeleteDaccu(midx) {
	if (confirm('등록하신 다꾸톡톡을 삭제하시겠습니까?')) {
		$.ajax({
            type:"GET",
            url:"/diarystory2020/ajaxDaccuTokTok.asp?daccuTokMode=daccuDelete&daccuTokMasterIdx="+midx,
            //data: ,
            dataType: "text",
            async:false,
            cache:true,
            success : function(Data, textStatus, jqXHR){
                if (jqXHR.readyState == 4) {
                    if (jqXHR.status == 200) {
                        if(Data!="") {
                            var result = JSON.parse(Data)
                            if(result.response == "ok"){									
                                document.location.href='/diarystory2020/daccu_toktok.asp'									
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
</script>
</head>
<body class="default-font body-sub diary2020">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
    <div id="content" class="content diary-sub">
        <div class="talk talk-main">
            <div class="md-dctalk">
                <div class="swiper md-rolling" id="md-rolling">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <% If oDaccuTalk.FResultCount > 0 Then  %>
                                <% FOR i = 0 to oDaccuTalk.FResultCount-1 %>
                                    <%
                                        oDaccuTalkDetail.FRectMasterIdx = oDaccuTalk.FItemList(i).FMasterIdx
                                        oDaccuTalkDetail.GetDaccuTokTokDetailManagerList
                                    %>
                                    <div class="swiper-slide">
                                        <div class="thumbnail">
                                            <img src="<%=oDaccuTalk.FItemList(i).FMasterImage%>" alt="" />
                                            <ul class="mark-list">
                                                <% If oDaccuTalkDetail.FResultCount > 0 Then %>
                                                    <% For j = 0 to oDaccuTalkDetail.FResultCount-1 %>
                                                        <li class="mark" style="top:<%=oDaccuTalkDetail.FItemList(j).FDetailYValue%>%; left:<%=oDaccuTalkDetail.FItemList(j).FDetailXValue%>%;">
                                                            <a href="/category/category_itemprd.asp?itemid=<%=oDaccuTalkDetail.FItemList(j).FDetailItemId%>" target="_blank">
                                                                <i class="ico-plus"></i>
                                                                <div class="box">
                                                                    <p class="name ellipsis"><%=oDaccuTalkDetail.FItemList(j).FDetailItemName%></p>
                                                                </div>
                                                            </a>                                                        
                                                        </li>
                                                    <% Next %>
                                                <% End If %>
                                            </ul>
                                        </div>
                                        <div class="desc">
                                            <div class="tit multi-ellipsis"><%=oDaccuTalk.FItemList(i).FMasterRegUserFrontName%>의 다꾸템!</div>
                                            <div class="md-info">
                                                <%' 이미지 144*144 %>
                                                <span class="thumbnail"><img src="<%=oDaccuTalk.FItemList(i).FMasterRegUserImage%>" alt=""></span>
                                                <p class="name">텐바이텐 <%=oDaccuTalk.FItemList(i).FMasterRegUserFrontName%></p>
                                            </div>
                                        </div>
                                    </div>
                                <% Next %>
                            <% End If %>
                        </div>
                        <div class="pagination"><span class="pagination-fill"></span></div>
                    </div>
                </div>
                <p class="dctem-alert">이미지를 클릭 하시면 더 자세한 정보를 볼 수 있어요 :)</p>
            </div>

            <div class="best-dctalk">
                <h2>나두 한 다꾸 한다면<br><strong>베스트 다꾸러 도전!</strong></h2>
                <%' 20190906 사은품 이미지 수정 %>
                <div class="intro">
                    <div class="txt">
                        <strong>나만의 다이어리를 자랑해주세요!</strong><br>다꾸 부터 데스크테리어까지 다이어리와 함께 한 모든 순간을 남겨주세요.
                    </div>
                </div>
                <%'// 20190906 사은품 이미지 수정 %>
                <ul class="best-list" id="userMasterList"></ul>
            </div>
            <a href="" onclick="daccuTokWrite();return false;" class="btn-regist-daccutem">다꾸템 등록하기</a>
        </div>
	</div>
    <form name="daccuUserMaster" id="daccuUserMaster" method="post">
        <input type="hidden" name="userCurrPage" id="userCurrPage" value="1">
    </form>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incfooter.asp" -->	
</body>
</html>
<%
    Set oDaccuTalk = Nothing
    Set oDaccuTalkDetail = Nothing
    Set oDaccuTalkUserList = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->