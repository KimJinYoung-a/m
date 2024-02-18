const isLocal = function() {
    return unescape(location.href).includes('//localhost') || unescape(location.href).includes('//localm');
}();
const isDevelop = function() {
    return unescape(location.href).includes('//localhost') || unescape(location.href).includes('//testm') || unescape(location.href).includes('//localm');
}();
const isStaging = function() {
    return unescape(location.href).includes('//stgm');
}();
const isProduction = function() {
    return unescape(location.href).includes('//m');
}();

const apiurl = function() {
    let apiUrl;
    if( isLocal ) {
        apiUrl =  '//localfapi.10x10.co.kr:8080/api/web/v1';
    } else if( isDevelop ) {
        apiUrl =  '//testfapi.10x10.co.kr/api/web/v1';
    } else if( isProduction || isStaging ) {
        apiUrl =  '//fapi.10x10.co.kr/api/web/v1';
    }

    return apiUrl;
}();
const apiurlv2 = function() {
    let apiUrl
    if( isLocal ) {
        apiUrl =  '//localfapi.10x10.co.kr:8080/api/web/v2';
    } else if( isDevelop ) {
        apiUrl =  '//testfapi.10x10.co.kr/api/web/v2';
    } else if( isProduction || isStaging ) {
        apiUrl =  '//fapi.10x10.co.kr/api/web/v2';
    }

    return apiUrl;
}();

const mUrl = function() {
    let mUrl;
    if( isDevelop ) {
        //mUrl =  'http://localm.10x10.co.kr';
        mUrl =  'http://testm.10x10.co.kr';
    } else if( isProduction || isStaging ) {
        mUrl =  'http://m.10x10.co.kr';
    }

    return mUrl;
}();

const isApp = function() {
    let isapp = false;
    if ( unescape(location.href.toLowerCase()).includes('/apps/appcom/')) {
        isapp = true;
    } else {
        isapp = false;
    }

    return isapp;
}();

const vueAppUrl = function() {
    let domain;
    if( isDevelop ) {
        domain = 'http://testm.10x10.co.kr';
    } else if( isStaging ) {
        domain = 'http://stgm.10x10.co.kr';
    } else if( isProduction ) {
        domain = 'http://m.10x10.co.kr';
    }
    return domain + '/apps/appcom/wish/web2014';
}();
const vueAppUrlSsl = function() {
    let domain;
    if( isDevelop ) {
        domain = 'https://testm.10x10.co.kr';
    } else if( isStaging ) {
        domain = 'https://stgm.10x10.co.kr';
    } else if( isProduction ) {
        domain = 'https://m.10x10.co.kr';
    }
    return domain + '/apps/appcom/wish/web2014';
}();

const uploadUrl = function() {
    let uploadUrl
    if( isDevelop ) {
        uploadUrl =  '//testupload.10x10.co.kr'
    } else {
        uploadUrl =  '//upload.10x10.co.kr'
    }

    return uploadUrl;
}();

// Amplitude용 정렬 값
const amplitudeSort = function (sort_method) {
    let sort_name = ''
    switch (sort_method) {
        case 'rc': sort_name = 'recommend'; break; // 추천순
        case 'new': sort_name = 'new'; break; // 신규순
        case 'bs': sort_name = 'topsales'; break; // 판매량순
        case 'best': sort_name = 'best'; break; // 인기순
        case 'ws': sort_name = 'wish'; break; // 위시순
        case 'hs': sort_name = 'sale'; break; // 할인율순
        case 'hp': sort_name = 'highprice'; break; // 높은 가격순
        case 'lp': sort_name = 'lowprice'; break; // 낮은 가격순
        case 'br': sort_name = 'review'; break; // 평가 좋은순
        case 'duedate': sort_name = 'close'; break; // 마감 임박순
    }

    return sort_name;
};

// Amplitude용 필터 - 배송
const amplitudeFilterDelivery = function (deliTypes) {
    if( deliTypes == null )
        return [];

    let delivery = [];
    deliTypes.forEach(d => {
        switch (d) {
            case 'FD' : delivery.push('free'); break;
            case 'TN' : delivery.push('tenbyten'); break;
            case 'DT' : delivery.push('direct_global'); break;
            case 'WD' : delivery.push('global'); break;
        }
    });
    return delivery;
}

// Amplitude용 필터 - 추천
const amplitudeFilterRecommend = function (recommends) {
    if( recommends == null )
        return [];

    let recommend = [];
    recommends.forEach(r => {
        switch (r) {
            case 'TD' : recommend.push('deal'); break;
            case 'SP' : recommend.push('packing'); break;
            case 'PS' : recommend.push('soldout'); break;
        }
    });
    return recommend;
}

// 카테고리메인 - Chrome Localstorage 저장용
// Amplitude용 필터 -> deliType배열
const amplitudeFilterToDeliType = (deliArr, recomArr) => {
    if( deliArr == null || recomArr == null )
        return [];

    const deliTypes = [];
    // 배송
    deliArr.forEach(d => {
        switch(d) {
            case 'free' : deliTypes.push('FD'); break;
            case 'tenbyten' : deliTypes.push('TN'); break;
            case 'direct_global' : deliTypes.push('DT'); break;
            case 'global' : deliTypes.push('WD'); break;
        }
    });
    // 추천
    recomArr.forEach(r => {
        switch (r) {
            case 'deal' : deliTypes.push('TD'); break;
            case 'packing' : deliTypes.push('SP'); break;
            case 'soldout' : deliTypes.push('PS'); break;
        }
    });

    return deliTypes;
}

// Amplitude용 뷰타입
const amplitudeListType = function (listType) {
    if( listType == null || listType.trim() === '' ) {
        return '';
    } else if( listType === 'photo' ) {
        return 'photo';
    } else {
        return 'list';
    }
}

// 앱 버전 확인
const appVersion = function() {
    const version_arr = navigator.appVersion.split('tenapp');
    if( version_arr.length <= 1 ) {
        return 0;
    } else {
        return Number(version_arr[1]
            .replace('A','')
            .replace('I','')
            .trim());
    }
}();

// API 호출
const getFrontApiData = function(method, uri, data, success, error) {
    if( error == null ) {
        error = function(xhr) {
            console.log(xhr.responseText);
        }
    }

    $.ajax({
        type: method,
        url: apiurl + uri,
        data: data,
        ContentType: "json",
        crossDomain: true,
        xhrFields: {
            withCredentials: true
        },
        success: success,
        error: error
    });
}
const getFrontApiDataV2 = function(method, uri, data, success, error) {
    if( error == null ) {
        error = function(xhr) {
            console.error(xhr.responseText);
        }
    }

    $.ajax({
        type: method,
        url: apiurlv2 + uri,
        data: data,
        ContentType: "json",
        crossDomain: true,
        xhrFields: {
            withCredentials: true
        },
        success: success,
        error: error
    });
}

function call_api(method, uri, data, success, error) {
    if( error == null ) {
        error = function(xhr) {
            console.log(xhr.responseText);
        }
    }

    $.ajax({
        type: method,
        url: apiurl + uri,
        data: data,
        ContentType: "json",
        crossDomain: true,
        xhrFields: {
            withCredentials: true
        },
        success: success,
        error: error
    });
}