let apiurl;
const this_url = unescape(location.href);
if( this_url.startsWith('http://localhost') ) {
    console.log('local');
    apiurl = "//localhost:8080/api/web/v1";
} else if( this_url.startsWith('http://testm') ) {
    console.log('develop');
    apiurl = "//testfapi.10x10.co.kr:8080/api/web/v1";
} else if( this_url.startsWith('http://stgm') ) {
    console.log('staging');
    apiurl = "//stgfapi.10x10.co.kr:8080/api/web/v1";
} else if( this_url.startsWith('http://m') || this_url.startsWith('https://m') ) {
    console.log('master');
    apiurl = "//fapi.10x10.co.kr/api/web/v1";
} else {
    console.log('error');
    alert('api url error');
    apiurl = "//testfapi.10x10.co.kr:8080/api/web/v1";
}
let event_dataurl = apiurl + "/search/eventSearch";

// Decode Base64
function decodeBase64(str) {
    if( str != null && str != '' )
        return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
    else
        return '';
}
String.prototype.replaceAll = function(searchStr, replaceStr) {
    return this.split(searchStr).join(replaceStr);
}

var store = new Vuex.Store({
    state : {
        params : { // 파라미터
            keywords : '룩북'
        },
        events : []
    },
    getters : {
        events : function(state) {
            return state.events;
        }
    },
    mutations : {
        SET_EVENTS : function(state, payload) { // Set 이벤트 리스트
            let events = [];
            for( let idx=0 ; idx < payload.length ; idx++ ) {
                let temp_event = payload[idx];

                // Decode Base64
                temp_event.banner_img = decodeBase64(temp_event.banner_img);
                temp_event.move_url = decodeBase64(temp_event.move_url);

                events.push(temp_event);
            }
            state.events = events;
        }
    },
    actions : {
        GET_EVENTS : function(context) { // 이벤트리스트 state에 저장
            var _url = event_dataurl + '?keywords=' + context.state.params.keywords;

            $.ajax({
                type : "GET",
                url: _url,
                ContentType : "json",
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                },
                success: function(data) {
                    console.log(data);
                    context.commit('SET_EVENTS', data.items);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                }
            });
        }
    }
});