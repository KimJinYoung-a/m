Vue.component('Exhibition-Image',{
    template : '\
                <!-- 기획전 리스트 이미지 영역 -->\
                <figure class="evt_img">\
					<img :src="banner_img" alt="">\
				</figure>\
    ',
    props : {
        banner_img : String
    }
})