Vue.component('Toggle-Type1',{
    template : '\
            <!-- 결과 없음 -->\
            <div class="tgl_type1">\
                <i class="bg"></i>\
                <span data-label="user" class="txt active">후기사진</span>\
                <span data-label="product" class="txt">기본사진</span>\
                <a @click="change_photo(index)" class="btn" data-current="user"><span class="blind">기본사진 보기</span></a>\
            </div>\
    ',
    props : {
        index : Number,
        photo_type : { type : String, default : 'user'}  // 사진 타입 default - 후기(user) / 기본(product)
    },
    methods : {
        change_photo : function(index) { // 사진 변경(후기/기본)            
            this.$emit('change_photo', index, this.photo_type);
        }
    }
})