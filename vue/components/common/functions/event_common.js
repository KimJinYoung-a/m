/*
* 2021-11-03 김형태
* 이벤트 관련 공통 스크립트
* */

const give_coupon = function(coupon_type, coupon_code, event_code){
    /*
    *---coupon_type---
    * prd    : 상품쿠폰
    * event  : 이벤트 쿠폰
    * evtsel : 선택이벤트 쿠폰
    *
    *---coupon_code---
    * 콤마로 이어써도 split으로 처리된다. But!! stype과 pair로 써줘야한다.
    * ex) coupon_type : prd,prd
    *     coupon_code : 123,456
    *
    *     pair가 아니면 에러발생
    * */
    const ajax_data = {"stype" : coupon_type, "idx" : coupon_code};

    $.ajax({
        type: "POST"
        , url: "/shoppingtoday/act_couponshop_process.asp"
        , data: ajax_data
        , cache: false
        , success: function(message) {
            fnAmplitudeEventMultiPropertiesAction('click_coupon_btn','evtcode', event_code);

            if(typeof(message)=="object") {
                if(message.response=="Ok") {
                    console.log("쿠폰 발급 완료");
                } else {
                    alert(message.message);
                }
            } else {
                alert("처리중 오류가 발생했습니다.");
            }
        }
        , error: function(err) {
            console.log(err.responseText);
        }
    });
}


/*
* ---- SNS 공유 ---
* */

// URL 복사
const copy_clipboard_app = function(url, event_code, title){
    callNativeFunction('copyurltoclipboard', {
        'url': url
        , 'message' : '링크가 복사되었습니다. 원하시는 곳에 붙여넣기 하세요.'
        , 'itemid': event_code
        , 'itemname' : title
        , 'kind' : "event"
    });
}

const kakao_share_event_app = function(title, appurl, imageurl, desc){
    fnAPPshareKakao('etc',title,'','', "url=" + appurl, imageurl,'','','', desc);
}

const insta_share_event_app = function (imageurl, event_code, title){
    fnAPPShareInstagram(imageurl, '', title, "event");
}

const twitter_share_event_app = function (title, appurl, event_code){
    fnAPPShareTwitter(title, appurl, event_code, title, "event");
}

const facebook_share_event_app = function(appurl, event_code, title){
    fnAPPShareSNS("fb", appurl, event_code, title, "event");
}
