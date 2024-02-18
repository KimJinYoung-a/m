Vue.component('banner-list', {
    template: '\
    <div class="bnr-list">\
        <ul>\
            <li\
                v-if="addonEventImage1 != \'\'"\
            >\
                <a @click="eventLink(addonEventCode1)">\
                    <img :src="addonEventImage1" alt="">\
                </a>\
            </li>\
            <li\
                v-if="addonEventImage2 != \'\'"\
            >\
                <a @click="eventLink(addonEventCode2)">\
                    <img :src="addonEventImage2" alt="">\
                </a>\
            </li>\
            <li\
                v-if="addonEventImage3 != \'\'"\
            >\
                <a @click="eventLink(addonEventCode3)">\
                    <img :src="addonEventImage3" alt="">\
                </a>\
            </li>\
            <li\
                v-if="addonEventImage4 != \'\'"\
            >\
                <a @click="eventLink(addonEventCode4)">\
                    <img :src="addonEventImage4" alt="">\
                </a>\
            </li>\
            <li\
                v-if="addonEventImage5 != \'\'"\
            >\
                <a @click="eventLink(addonEventCode5)">\
                    <img :src="addonEventImage5" alt="">\
                </a>\
            </li>\
        </ul>\
    </div>\
    ',
    props: {
        addonEventImage1: String,
        addonEventImage2: String,
        addonEventImage3: String,
        addonEventImage4: String,
        addonEventImage5: String,
        addonEventCode1: Number,
        addonEventCode2: Number,
        addonEventCode3: Number,
        addonEventCode4: Number,
        addonEventCode5: Number
    },
    methods: {
        eventLink: function(eventCode){
            if(isapp == 1){
                fnAPPpopupEvent_URL('m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+eventCode);
            }else{
                window.location.href = "/event/eventmain.asp?eventid="+eventCode
            }
            return false;
        }
    }
})
