<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
'####################################################
' Description : 2022 코멘트 이벤트
' History : 2021.12.16 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, vQuery, commentcount

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "109436"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "115624"
    mktTest = True
Else
	eCode = "115624"
    mktTest = False
End If

eventStartDate  = cdate("2021-12-20")		'이벤트 시작일
eventEndDate 	= cdate("2022-01-10")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-12-20")
else
    currentDate = date()
end if

dim cEComment, cdl, com_egCode, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	isMyComm	= requestCheckVar(request("isMC"),1)

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
iCPageSize = 4		'메뉴가 있으면 10개		'/수기이벤트 둘다 강제 12고정

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = LoginUserid
	cEComment.FTotCnt 		= iCTotCnt      '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt            '리스트 총 갯수
set cEComment = nothing
%>
<style>
.mEvt115624 section{position:relative;}

.mEvt115624 .section01 .float{position:absolute;top:6rem;left:50%;width:78vw;margin-left:-39vw;opacity:0; transform:translateY(15vw); transition:ease-in-out 1s;}
.mEvt115624 .section01 .float.on{opacity:1; transform:translateY(0);}
.mEvt115624 .section01 .comment{width:70vw;height:5rem;display:block;position:absolute;bottom:5.5rem;left:50%;margin-left:-35vw;}

.mEvt115624 .section02 a{width:82.7vw;height:82.7vw;display:block;position:absolute;left:50%;margin-left:-41.35vw;}
.mEvt115624 .section02 a.friend01{top:59.5vw;}
.mEvt115624 .section02 a.friend02{top:149vw;}
.mEvt115624 .section02 a.friend03{top:238vw;}
.mEvt115624 .section02 a.friend04{top:327.5vw;}

.mEvt115624 section .main{position:absolute;top:116vw;left:50%;transform:translateX(-50%);width:84vw;height:45rem;display: block;}
.mEvt115624 section .main a{display:block;width:100%;height:100%;}
.mEvt115624 section .main .desc{position:absolute;bottom:12vw;width:fit-content;left:50%;transform:translateX(-50%);}
.mEvt115624 section .main .desc .price{font-size:1.7rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';letter-spacing:-0.05em;}
.mEvt115624 section .main .desc .price s{font-size:1.6rem;color:#999;text-decoration: none;	font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt115624 section .main .desc .price span{font-size:1.5rem;color:#fff;background:#ff7a7a;padding:0.1rem 1rem;border-radius: 2.85rem;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';margin-left:1rem;}

.mEvt115624 section .sub{display:flex;width:100vw;position:absolute;bottom:13vw;height:26rem;justify-content:space-evenly;}
.mEvt115624 section .sub li{width:44vw;}
.mEvt115624 section .sub li a{display:block;width:100%;height:100%;}
.mEvt115624 section .sub li .desc{position:absolute;bottom:11vw;}
.mEvt115624 section .sub li:first-child .desc{margin-left:1.5rem;}
.mEvt115624 section .sub li .desc .price{font-size:1.5rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';letter-spacing:-0.05em;}
.mEvt115624 section .sub li .desc .price s{display:block;margin-bottom:1rem;font-size:1.4rem;color:#999;text-decoration: none;	font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt115624 section .sub li .desc .price span{font-size:1.4rem;color:#fff;background:#ff7a7a;float:left;direction:ltr;padding:0.1rem 1rem;border-radius: 2.85rem;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';margin-right:0.3rem;}

.mEvt115624 .section10 .btn_zone{width:87.2vw;display:flex;position:absolute;left:50%;transform:translateX(-50%);top:3vw;height:45vw;justify-content:space-between;}
.mEvt115624 .section10 .btn_zone button{width:20vw;height:100%;background:url(//webimage.10x10.co.kr/fixevent/event/2021/115624/off.png)no-repeat 0 2.7rem;background-size: 430%;}
.mEvt115624 .section10 .btn_zone button.on{background: url(//webimage.10x10.co.kr/fixevent/event/2021/115624/on.png)no-repeat 0 2.2rem;background-size: 430%;;}
.mEvt115624 .section10 .btn_zone .btn01, .mEvt115624 .section10 .btn_zone .btn01.on{background-position-x:0;}
.mEvt115624 .section10 .btn_zone .btn02, .mEvt115624 .section10 .btn_zone .btn02.on{background-position-x:-22vw;}
.mEvt115624 .section10 .btn_zone .btn03, .mEvt115624 .section10 .btn_zone .btn03.on{background-position-x:-44vw;}
.mEvt115624 .section10 .btn_zone .btn04, .mEvt115624 .section10 .btn_zone .btn04.on{background-position-x:-66vw;}

.mEvt115624 .section10 .text_zone{width:88vw;position:absolute;left:50%;transform:translateX(-50%);bottom:27vw;}
.mEvt115624 .section10 .text_zone textarea{width:100%;height:33vw;border:none;background:transparent;resize:none;padding:1rem 5vw;font-size:1.2rem;color:#000;letter-spacing:-0.05em;}
.mEvt115624 .section10 .text_zone textarea::placeholder{color:#999;}
.mEvt115624 .section10 .text_zone .submit{width:88vw;height:14vw;position:absolute;left:50%;transform:translateX(-50%);bottom:-14vw;background:transparent;}

.mEvt115624 .section11{background:#ff7a7a;padding-bottom:10vw;}
.mEvt115624 .section11 .comment_zone{height:auto;}
.mEvt115624 .section11 .comment_zone .comment{width:87.6vw;height:48vw;margin:0 auto;position:relative;margin-bottom:5vw;}
.mEvt115624 .section11 .comment_zone .comment.disney{background:url(//webimage.10x10.co.kr/fixevent/event/2021/115624/disney.png?v=2.3)no-repeat 0 0;background-size:100%;}
.mEvt115624 .section11 .comment_zone .comment.snoopy{background:url(//webimage.10x10.co.kr/fixevent/event/2021/115624/snoopy.png?v=2.3)no-repeat 0 0;background-size:100%;}
.mEvt115624 .section11 .comment_zone .comment.bbb{background:url(//webimage.10x10.co.kr/fixevent/event/2021/115624/bbb.png?v=2.3)no-repeat 0 0;background-size:100%;}
.mEvt115624 .section11 .comment_zone .comment.sanrio{background:url(//webimage.10x10.co.kr/fixevent/event/2021/115624/sanrio.png?V=2.3)no-repeat 0 0;background-size:100%;}
.mEvt115624 .section11 .comment_zone .comment .click{display:flex;position:absolute;top:3vw;right:3vw;}
.mEvt115624 .section11 .comment_zone .comment.disney .click{background:url(//webimage.10x10.co.kr/fixevent/event/2021/115624/btn_close01.png)no-repeat 0 0;background-size:100%;}
.mEvt115624 .section11 .comment_zone .comment.snoopy .click{background:url(//webimage.10x10.co.kr/fixevent/event/2021/115624/btn_close01.png)no-repeat 0 0;background-size:100%;}
.mEvt115624 .section11 .comment_zone .comment.bbb .click{background:url(//webimage.10x10.co.kr/fixevent/event/2021/115624/btn_close01.png)no-repeat 0 0;background-size:100%;}
.mEvt115624 .section11 .comment_zone .comment.sanrio .click{background:url(//webimage.10x10.co.kr/fixevent/event/2021/115624/btn_close01.png)no-repeat 0 0;background-size:100%;}
.mEvt115624 .section11 .comment_zone .comment .click .btn_close{width:7vw;height:7vw;display:block;}
.mEvt115624 .section11 .comment_zone .comment .num{position:absolute;top:7.5vw;left:21.5vw;width:16vw;height:1.3rem;line-height:1.4rem;border-radius:1rem;text-align: center;font-size:1rem;letter-spacing:-0.02em;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt115624 .section11 .comment_zone .comment.disney .num{color:#fff;background:#53aae9;}
.mEvt115624 .section11 .comment_zone .comment.snoopy .num{color:#fff;background:#6ed722;}
.mEvt115624 .section11 .comment_zone .comment.bbb .num{color:#fff;background:#c56ff3;}
.mEvt115624 .section11 .comment_zone .comment.sanrio .num{color:#fff;background:#ffc926;}

.mEvt115624 .section11 .comment_zone .comment .user_id{position:absolute;top:14vw;left:26vw;font-size:1.3rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';letter-spacing:-0.03em;}
.mEvt115624 .section11 .comment_zone .comment .scrollbar{position:absolute;bottom:1rem;left:0;width:100%;height:22vw;overflow-y:scroll;padding:0 5vw;font-size:1.2rem;line-height:1.8rem;color:#000;letter-spacing:-0.05em;}
.mEvt115624 .section11 .comment_zone .comment .scrollbar .force-overflow{min-height:22vw;}
.mEvt115624 .section11 .comment_zone .comment .scrollbar::-webkit-scrollbar-track{background:#fff;border-radius: 1rem;height:22vw;width:2vw;}
.mEvt115624 .section11 .comment_zone .comment .scrollbar::-webkit-scrollbar{background:#fff;border-radius: 1rem;height:22vw;width:3vw;}
.mEvt115624 .section11 .comment_zone .comment.disney .scrollbar::-webkit-scrollbar-thumb{background:#6bc2ff;border-radius: 1rem;}
.mEvt115624 .section11 .comment_zone .comment.snoopy .scrollbar::-webkit-scrollbar-thumb{background:#70e470;border-radius: 1rem;}
.mEvt115624 .section11 .comment_zone .comment.bbb .scrollbar::-webkit-scrollbar-thumb{background:#cd74ff;border-radius: 1rem;}
.mEvt115624 .section11 .comment_zone .comment.sanrio .scrollbar::-webkit-scrollbar-thumb{background:#ffd041;border-radius: 1rem;}

.mEvt115624 .section11 .page_wrap{margin:0;padding:0;text-align:center;}
.mEvt115624 .section11 .page_wrap #pagination{display:flex;width:86.7vw;align-items:center;margin:0 auto;}
.mEvt115624 .section11 .page_wrap #pagination li{width:14.29%;height:9.3vw;display:flex;align-items:center;justify-content:center;}
.mEvt115624 .section11 .page_wrap #pagination li a{width:100%;height:100%;display:flex;align-items:center;justify-content:center;font-size:1.4rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';color:#fff;}
.mEvt115624 .section11 .page_wrap #pagination li a.active{color:#000;background:#afff74;width:9.3vw;height:9.3vw;border-radius:50%;}
.mEvt115624 .section11 .page_wrap #pagination li.btn_arrow img{width:2.4vw;}
.mEvt115624 .section11 .page_wrap #pagination li.next{transform: rotate(180deg);}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_115624.js?v=1.01"></script>
<script>
$(function() {
	$('.mEvt115624 .section01 .float').addClass('on');

    codeGrp = [3673690];
    var $rootEl = $("#itemlist01")
    var itemEle = tmpEl = ""
    $rootEl.empty();
    codeGrp.forEach(function(item){
        tmpEl = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="desc">\
                            <div class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></div>\
                        </div>\
                    </a>\
                </li>\
                '
        itemEle += tmpEl;
    });
    $rootEl.append(itemEle)
    fnApplyItemInfoList({
        items:codeGrp,
        target:"itemlist01",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp2 = [3590032,3794864];
    var $rootEl2 = $("#itemlist02")
    var itemEle2 = tmpEl2 = ""
    $rootEl2.empty();
    codeGrp2.forEach(function(item){
        tmpEl2 = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="desc">\
                            <p class="price"><s>정가</s><span   >할인율%</span>할인가</p>\
                        </div>\
                    </a>\
                </li>\
                '
        itemEle2 += tmpEl2;
    });
    $rootEl2.append(itemEle2)
    fnApplyItemInfoList2({
        items:codeGrp2,
        target:"itemlist02",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp3 = [4158004];
    var $rootEl3 = $("#itemlist03")
    var itemEle3 = tmpEl3 = ""
    $rootEl3.empty();
    codeGrp3.forEach(function(item){
        tmpEl3 = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="desc">\
                            <div class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></div>\
                        </div>\
                    </a>\
                </li>\
                '
        itemEle3 += tmpEl3;
    });
    $rootEl3.append(itemEle3)
    fnApplyItemInfoList3({
        items:codeGrp3,
        target:"itemlist03",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp4 = [3947421,3950903];
    var $rootEl4 = $("#itemlist04")
    var itemEle4 = tmpEl4 = ""
    $rootEl4.empty();
    codeGrp4.forEach(function(item){
        tmpEl4 = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="desc">\
                            <p class="price"><s>정가</s><span class="sale">할인율%</span>할인가</p>\
                        </div>\
                    </a>\
                </li>\
                '
        itemEle4 += tmpEl4;
    });
    $rootEl4.append(itemEle4)
    fnApplyItemInfoList4({
        items:codeGrp4,
        target:"itemlist04",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp5 = [4052212];
    var $rootEl5 = $("#itemlist05")
    var itemEle5 = tmpEl5 = ""
    $rootEl5.empty();
    codeGrp5.forEach(function(item){
        tmpEl5 = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="desc">\
                            <div class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></div>\
                        </div>\
                    </a>\
                </li>\
                '
        itemEle5 += tmpEl5;
    });
    $rootEl5.append(itemEle5)
    fnApplyItemInfoList5({
        items:codeGrp5,
        target:"itemlist05",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp6 = [4013666,3956301];
    var $rootEl6 = $("#itemlist06")
    var itemEle6 = tmpEl6 = ""
    $rootEl6.empty();
    codeGrp6.forEach(function(item){
        tmpEl6 = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="desc">\
                            <p class="price"><s>정가</s><span class="sale">할인율%</span>할인가</p>\
                        </div>\
                    </a>\
                </li>\
                '
        itemEle6 += tmpEl6;
    });
    $rootEl6.append(itemEle6)
    fnApplyItemInfoList6({
        items:codeGrp6,
        target:"itemlist06",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp7 = [4051527];
    var $rootEl7 = $("#itemlist07")
    var itemEle7 = tmpEl7 = ""
    $rootEl7.empty();
    codeGrp7.forEach(function(item){
        tmpEl7 = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="desc">\
                            <div class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></div>\
                        </div>\
                    </a>\
                </li>\
                '
        itemEle7 += tmpEl7;
    });
    $rootEl7.append(itemEle7)
    fnApplyItemInfoList7({
        items:codeGrp7,
        target:"itemlist07",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp8 = [4171151,4023017];
    var $rootEl8 = $("#itemlist08")
    var itemEle8 = tmpEl8 = ""
    $rootEl8.empty();
    codeGrp8.forEach(function(item){
        tmpEl8 = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="desc">\
                            <p class="price"><s>정가</s><span class="sale">할인율%</span>할인가</p>\
                        </div>\
                    </a>\
                </li>\
                '
        itemEle8 += tmpEl8;
    });
    $rootEl8.append(itemEle8)
    fnApplyItemInfoList8({
        items:codeGrp8,
        target:"itemlist08",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

	$('.btn_zone button').click(function() {
		$(this).siblings().removeClass('on');
		$(this).toggleClass('on');
	});

    $(".comment").click(function(e){
		e.preventDefault();
		$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
	});

    jsGoComPage(1);
});

function goProduct(itemid) {
	<% if isApp then %>
		fnAPPpopupProduct(itemid);
	<% else %>
		parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
	<% end if %>
	return false;
}

function goBrand(brandid) {
	<% if isApp then %>
		fnAPPpopupBrand(brandid);
	<% else %>
		parent.location.href='/brand/brand_detail2020.asp?brandid='+brandid;
	<% end if %>
	return false;
}

function fnCharacterChoice(cnum){
    $("#cnum").val(cnum);
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}
}

function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
            if ($("#cnum").val()<1){
                alert("캐릭터를 선택해주세요.");
                return false;
            }

            if(!$("#txtcomm").val()){
                alert("코멘트를 적어주세요!");
                return false;
            }

            if (GetByteLength($("#txtcomm").val()) < 20){
                alert("최소 10자 이상 입력해주세요.");
                return false;
            }
            var makehtml="";
            var character = ["disney","snoopy","bbb","sanrio"];
            var data={
                mode: "add",
                selectedPdt: $("#cnum").val(),
                selectedPdtIMG: '',
                txtcomm: $("#txtcomm").val()
            }
            $.ajax({
                type:"POST",
                url:"/event/lib/doEventCommentProc115624.asp",
                data: data,
                dataType: "JSON",
                success : function(res){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|character','<%=eCode%>|' + $("#cnum").val());
                        if(res!="") {
                            // console.log(res)
                            if(res.response == "ok"){
                                makehtml = '\
                                <div class="comment ' + character[$("#cnum").val()-1] + '" id="list' + res.cidx + '">\
                                    <div class="click">\
                                        <a href="" class="btn_close" onclick="fnDelComment(' + res.cidx + ');return false;"></a>\
                                    </div>\
                                    <p class="num">No. <span>'+ (parseInt($("#bnum").val())+1) +'</span></p>\
                                    <p class="user_id"><%=LoginUserid%></p>\
                                    <div class="scrollbar">\
                                        <div class="force-overflow">' + $("#txtcomm").val() + '</div>\
                                    </div>\
                                </div>\
                                '
                                $("#clist").prepend(makehtml);
                                $("#bnum").val(parseInt($("#bnum").val())+1);
                                $("#txtcomm").val("");
                                return false;
                            }else{
                                alert(res.faildesc);
                                return false;
                            }
                        } else {
                            alert("잘못된 접근 입니다.1");
                            document.location.reload();
                            return false;
                        }
                },
                error:function(err){
                    console.log(err)
                    alert("잘못된 접근 입니다2.");
                    return false;
                }
            });
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function fnDelComment(Cindex){
	<% If Not(IsUserLoginOK) Then %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
        if(confirm("삭제 하시겠습니까?")){
			var data={
				mode: "del",
				Cidx: Cindex
			}
			$.ajax({
				type:"POST",
				url:"/event/lib/doEventCommentProc115624.asp",
				data: data,
				dataType: "JSON",
				success : function(res){
					if(res!=""){
						if(res.response == "ok"){
							$("#list"+Cindex).hide();
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					}else {
						alert("잘못된 접근 입니다.");
						document.location.reload();
						return false;
					}
				},
				error:function(err){
					console.log(err)
					alert("잘못된 접근 입니다.");
					return false;
				}
			});
		}
    <% end if %>
}

function jsGoComPage(vpage){
    $.ajax({
        type: "POST",
        url: "/event/etc/inc_115624list.asp",
        data: {
            iCC: vpage
        },
        success: function(Data){
            $("#commentlist").html(Data);
        },
        error: function(e){
            console.log('데이터를 받아오는데 실패하였습니다.')
            //$("#listContainer").empty();
        }
    })
}
</script>
			<div class="mEvt115624">
				<section class="section01">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115624/section01.jpg" alt="">
					<p class="float"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115624/tit.png" alt=""></p>
					<a href="#comment" class="comment"></a>
				</section>
				<section class="section02">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115624/section02.jpg" alt="">
					<a href="" class="friend01" onclick="goBrand('disney10x10');return false;"></a>
					<a href="" class="friend02" onclick="goBrand('peanuts10x10');return false;"></a>
					<a href="" class="friend03" onclick="goBrand('bbb10x10');return false;"></a>
					<a href="" class="friend04" onclick="goBrand('sanrio10x10');return false;"></a>
				</section>
				<section class="section03">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115624/section03.jpg" alt="">
				</section>
				<section class="section04">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115624/section04.jpg" alt="">
					<div class="main item3673690" id="itemlist01"></div>
					<ul id="itemlist02" class="sub"></ul>
				</section>
				<section class="section05">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115624/section05.jpg" alt="">
					<div class="main item3673690" id="itemlist03"></div>
					<ul id="itemlist04" class="sub"></ul>
				</section>
				<section class="section06">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115624/section06.jpg" alt="">
					<div class="main item3673690" id="itemlist05"></div>
					<ul id="itemlist06" class="sub"></ul>
				</section>
				<section class="section07">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115624/section07.jpg" alt="">
					<div class="main item3673690" id="itemlist07"></div>
					<ul id="itemlist08" class="sub"></ul>
				</section>
				<section class="section08">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115624/section08.jpg" alt="">
				</section>
				<section class="section09">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115624/section09.jpg" alt="">
				</section>
				<section class="section10" id="comment">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115624/section10.jpg" alt="">
					<div class="btn_zone">
                        <input type="hidden" id="cnum">
                        <input type="hidden" id="bnum" value="<%=iCTotCnt%>">
						<button class="btn01" onclick="fnCharacterChoice(1)"></button>
						<button class="btn02" onclick="fnCharacterChoice(2)"></button>
						<button class="btn03" onclick="fnCharacterChoice(3)"></button>
						<button class="btn04" onclick="fnCharacterChoice(4)"></button>
					</div>
					<div class="text_zone">
						<textarea cols="30" rows="5" placeholder="꼭 나왔으면 좋겠는 아이템과 그 이유를 적어주세요" name="txtcomm" id="txtcomm" onClick="jsCheckLimit();"></textarea>
						<button class="submit" onclick="eventTry();"></button>
					</div>
				</section>
				<section class="section11" id="commentlist"></section>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->