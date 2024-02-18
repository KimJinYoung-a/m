Vue.component('Event-Image',{
    template : '\
                <!-- 이벤트 이미지 -->\
                <figure class="evt_img">\
                    <img :src="image_url" alt="">\
                </figure>\
    ',
    props : {
        image_url   : String   // 이미지 url
    }
})