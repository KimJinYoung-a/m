<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 텐텐단독 상품상세
' History : 2021-09-27 김형태 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
    dim gnbflag, vGaparam

    If gnbflag <> "" Then '//gnb 숨김 여부
        gnbflag = true
    Else
        gnbflag = False
        strHeadTitleName = "매일리지"
    End if
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<style>
.mEvt116696 section{position:relative;}

.mEvt116696 .section01 p{position:absolute;top:63%;left:50%;margin-left:-35vw;width:70vw;animation:updown 1s ease-in-out alternate infinite;}
.mEvt116696 .section01 .btn_check{position:absolute;top:75%;left:50%;width:86.7vw;height:20.5vw;margin-left:-43.35vw;text-indent: -999999999px;background:transparent;}

.mEvt116696 .section02 .content01_01{position:relative;}
.mEvt116696 .section02 .content01_02{position:relative;}
.mEvt116696 .section02 p.user_id{position:absolute;top:20vw;font-size:2.1rem;width:100%;text-align: center;color:#fff;letter-spacing:0rem;font-family: 'CoreSansC', 'AppleSDGothicNeo', 'NotoSansKR';}
.mEvt116696 .section02 p.user_id span{text-decoration: underline;}
.mEvt116696 .section02 .user_id2{position:absolute;top:31vw;font-size:2.8rem;width:100%;text-align: center;color:#fff;letter-spacing: 0rem;font-family: 'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt116696 .section02 .mileage{position:absolute;bottom:33vw;right:0;margin-right:19.3vw;font-size:9vw;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#000;letter-spacing: -0.1rem;line-height:2;}
.mEvt116696 .section02 .content01_01{position:relative;}
.mEvt116696 .section02 .content01_02{position:relative;}
.mEvt116696 .section02 .myMileage{position: absolute;bottom:35vw;right:0;margin-right:12vw;display:block;width:6vw;height:13vw;}

.mEvt116696 .section03 .btnWrap{position:absolute;top:0;left:0;width: 100%;height: 100%;}
.mEvt116696 .section03 .btnWrap div{position:absolute;}
.mEvt116696 .section03 .btnWrap img{position:absolute;width:27vw;}
.mEvt116696 .section03 .btn01{top:0;left:50%;margin-left:-42.6vw;}
.mEvt116696 .section03 .btn02{top:0;left:50%;margin-left:-13.5vw;}
.mEvt116696 .section03 .btn03{top:0;left:50%;margin-left:15.7vw;}
.mEvt116696 .section03 .btn04{top:29vw;left:50%;margin-left:-42.6vw;}
.mEvt116696 .section03 .btn05{top:29vw;left:50%;margin-left:-13.5vw;}
.mEvt116696 .section03 .btn06{top:29vw;left:50%;margin-left:15.7vw;}
.mEvt116696 .section03 .btn07{top:58.5vw;left:50%;margin-left:-42.6vw;}
.mEvt116696 .section03 .btn08{top:58.5vw;left:50%;margin-left:-13.5vw;}
.mEvt116696 .section03 .btn09{top:58.5vw;left:50%;margin-left:15.7vw;}
.mEvt116696 .section03 .btn_on{display:none;}
.mEvt116696 .section03 .btn_off{display:none;}

.mEvt116696 .section04 .btn-apply{position:absolute;top:39.5%;left:50%;width:86.7vw;height:20.5vw;margin-left:-43.35vw;text-indent: -999999999px;background:transparent;}
.mEvt116696 .section04 .noti_wrap .noti{position:absolute;width: 100%;height:10vw;top:93vw;}
.mEvt116696 .section04 .noti_wrap .noti::after{content:'';display:block;background:url(//webimage.10x10.co.kr/fixevent/event/2022/116696/arrow_off.png) no-repeat 0 0;transform: rotate(0deg);position:absolute;bottom:1.8vw;left:73.3vw;background-size:100%;width:3.1vw;height:1rem;}
.mEvt116696 .section04 .noti_wrap .noti.on::after{transform: rotate(180deg);bottom:3.4vw;}
.mEvt116696 .section04 .noti_wrap .notice{display:none;}

.mEvt116696 .section05 .bg_dim{position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.4);z-index:5;display:none;}
.mEvt116696 .section05 .popup01{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display:none;}
.mEvt116696 .section05 .popup01 .pop_img{position:absolute;top:39vw;left:50%;}
.mEvt116696 .section05 .popup01 .day{position:absolute;top:44vw;right:22.9vw;font-size:4.5vw;letter-spacing: -0.1rem;color:#fff;}
.mEvt116696 .section05 .popup01 .point{text-align: center;position:absolute;top:79vw;width:100%;font-size:1.5rem;letter-spacing: -0.1rem;line-height: 1.5;}
.mEvt116696 .section05 .popup01 .point span{color:#df2031;}
.mEvt116696 .section05 .point span{text-decoration: underline;}
.mEvt116696 .section05 .popup01 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt116696 .section05 .popup01 .btn_alert{width:80vw;height:19vw;display:block;position:absolute;bottom:6vw;left:50%;margin-left:-40vw;}

.mEvt116696 .section05 .popup02{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display: none;}
.mEvt116696 .section05 .popup02 .day{position:absolute;top:42.5vw;right:22.9vw;font-size:4.5vw;letter-spacing: -0.1rem;color:#fff;}
.mEvt116696 .section05 .popup02 .point{text-align: center;position:absolute;top:77vw;width:100%;font-size:1.5rem;letter-spacing: -0.1rem;line-height: 1.5;}
.mEvt116696 .section05 .popup02 .point span{color:#df2031;}
.mEvt116696 .section05 .today{text-decoration: underline;}
.mEvt116696 .section05 .popup02 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt116696 .section05 .popup02 .btn_alert{width:80vw;height:20vw;display:block;position:absolute;bottom:17vw;left:50%;margin-left:-40vw;background: transparent;text-indent: -999999999px;}

.mEvt116696 .section05 .popup03{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display:none;}
.mEvt116696 .section05 .popup03 .day{position:absolute;top:44vw;right:22.9vw;font-size:4.5vw;letter-spacing: -0.1rem;color:#fff;}
.mEvt116696 .section05 .popup03 .point{text-align: center;position:absolute;top:79vw;width:100%;font-size:1.5rem;letter-spacing: -0.1rem;line-height: 1.5;}
.mEvt116696 .section05 .popup03 .point span{color:#df2031;}
.mEvt116696 .section05 .today{text-decoration: underline;}
.mEvt116696 .section05 .popup03 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt116696 .section05 .popup03 .btn_alert{width:80vw;height:19vw;display:block;position:absolute;bottom:6vw;left:50%;margin-left:-40vw;}

.mEvt116696 .section05 .popup04{position:fixed;top:30vw;left:50%;width:86.7vw;margin-left:-43.35vw;z-index:6;display:none;}
.mEvt116696 .section05 .popup04 .btn_close{width:16vw;height:16vw;display:block;position:absolute;top:0;right:0;}
.mEvt116696 .section05 .popup04 .btn_alert{width:80vw;height:19vw;display:block;position:absolute;bottom:4rem;left:50%;margin-left:-40vw;background: transparent;text-indent: -999999999px;}

@keyframes updown {
    0% {transform: translateY(-5px);}
    100% {transform: translateY(5px);}
}

</style>

<div id="app"></div>

<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js" ></script>
<script>
    let isLoginOk = false;
    <% IF IsUserLoginOK THEN %>
        isLoginOk = true;
    <% END IF %>

    const userid = "<%= GetLoginUserID %>";
    <%
        IF application("Svr_Info") = "Dev" THEN
    %>
        let event_code = 109447;
        let start_date = "2022-01-14";
        let end_date = "2022-01-17";
    <%
        ELSE

        Dim gaparamChkVal
        gaparamChkVal = requestCheckVar(request("gaparam"),30)

        If application("Svr_Info") <> "staging" AND isapp <> "1" Then
            Response.redirect "/event/eventmain.asp?eventid=116697&gaparam="&gaparamChkVal
            Response.End
        End If

    %>
        let event_code = 116696;
        let start_date = "2022-01-18";
        let end_date = "2022-01-31";
    <%
        END IF
    %>

    const loginUserLevel = "<%= GetLoginUserLevel %>";
    const rd_sitename = "<%= session("rd_sitename") %>";
    const server_info = "<%= application("Svr_Info") %>";
</script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>

<!-- Common Components -->
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/item_module_header.js?v=1.0"></script>
<script src="/vue/components/common/modal2.js?v=1.0"></script>
<script src="/vue/components/common/no_data.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<!-- //Common Components -->

<!-- Core -->
<script src="/vue/event/everyday_mileage/index_app.js?v=1.00"></script>
<!-- //Core -->