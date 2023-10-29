<template id="modal-template">
  <div class="modal" v-show="show">
    <div class="modal-wrapper">
      <div class="modal-container">
        <content select=".modal-header">
          <div class="modal-header">
            <div class="close">
              <button @click="closeModal()">
                <img width="10" height="10" src="https://img.icons8.com/ios-glyphs/30/delete-sign.png" alt="delete-sign"/>
            </button>
            </div>
          </div>
        </content>
        <div class="modal-body">
          <slot />
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "my-modal",
  props: {
    show: {
      type: Boolean,
      required: true,
      default: true,
    },
  },
  methods: {
    closeModal() {
      this.$emit("close");
    },
  },
};
</script>
<style lang="less">
.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  display: table;
  transition: opacity 0.3s ease;

  .modal-wrapper {
    display: table-cell;
    vertical-align: middle;
  }

  .modal-container {
    background: #fff;
    width: 450px;
    border-radius: 5px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
    transition: all 0.3s ease;
    margin: 0 auto;
    padding: 20px 30px;
  }

  .modal-footer {
    margin-top: 15px;
  }

  .modal-enter,
  .modal-leave {
    opacity: 0;
  }

  .modal-enter .modal-container,
  .modal-leave .modal-container {
    -webkit-transform: scale(1.1);
    transform: scale(1.1);
  }
  .close{
    display:flex;
    justify-content: end;
  }
}
</style>
