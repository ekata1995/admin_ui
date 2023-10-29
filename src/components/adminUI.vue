<template>
  <div class="todo-list">
    <div class="title">
      <h1>Admin UI </h1>
    </div>
    <div class="search">
      <div class="search-icon">
        <img width="20" height="20" src="https://img.icons8.com/ios/50/search--v1.png" alt="search--v1"/>
      </div>
      <input
        class="input-text"
        type="text"
        name="Search Text"
        v-model="searchInput"
        id=""
        @input="search"
      />
    </div>
    <div class="deleted-button">
      <button class="button" @click="deleteSelectedItem()">
        <div class="delete-selected-button">
            <div class="text">
            Delete Selected
        </div>
        <img
          width="20"
          height="20"
          src="https://img.icons8.com/material-rounded/24/filled-trash.png"
          alt="filled-trash"
        />
        </div>
      </button>
    </div>
    <div class="list-item">
      <table>
        <thead>
          <tr>
            <th></th>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in getData" :key="item.id">
            <td>
              <input
                type="checkbox"
                name="checkbox"
                :id="item.id"
                @change="updateSelection(item.id)"
              />
            </td>
            <td>{{ item.name }}</td>
            <td>{{ item.email }}</td>
            <td>{{ item.role }}</td>
            <td>
              <div class="action">
                <div class="edit">
                  <button class="button" @click="showModalItem(item.id)">
                    <img width="24" height="24" src="https://img.icons8.com/ios/50/edit--v1.png" alt="edit--v1"/>
                  </button>
                </div>
                <div class="delete">
                  <button class="button" @click="deleteItem(item.id)">
                    <img
                      width="24"
                      height="24"
                      src="https://img.icons8.com/material-rounded/24/filled-trash.png"
                      alt="filled-trash"
                    />
                  </button>
                </div>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="pagination">
      <div>
        <button @click="changePage(-1)" :disabled="currentPage === 1">
          Previous
        </button>
        <button @click="changePage(1)" :disabled="currentPage === totalPages">
          Next
        </button>
      </div>
    </div>
    <modal :show="showModal" @close="showModal = false">
      <div class="edit-page">
        <div class="heading">Edit the Admin Field</div>
        <div class="container" v-if="emplydata">
          <div class="col">
            <label for="username">Name:</label>
            <input
              type="text"
              id="username"
              name="username"
              v-model="emplydata[0].name"
            />
          </div>
          <div class="col">
            <label for="username">Email:</label>
            <input type="email" name="" id="" v-model="emplydata[0].email" />
          </div>
          <div class="col">
            <label for="username">Role:</label>
            <input type="text" name="" id="" v-model="emplydata[0].role" />
          </div>
          <button class="save-button" @click="saveData()">Save</button>
        </div>
      </div>
    </modal>
  </div>
</template>

<script>
import axios from "axios";
import modal from "./modal.vue";

export default {
  components: {
    modal,
  },
  data() {
    return {
      searchInput: null,
      searchResults: null,
      itemsPerPage: 10,
      currentPage: 1,
      showModal: false,
      emplydata: null,
      storedData: [],
      selctedData: [],
    };
  },
  computed: {
    totalPages() {
      return Math.ceil(this.storedData.length / this.itemsPerPage);
    },
    getData() {
      const startIndex = (this.currentPage - 1) * this.itemsPerPage;
      const endIndex = startIndex + this.itemsPerPage;
      let dataItem = this.searchResults
        ? this.searchResults.slice(startIndex, endIndex)
        : this.storedData.slice(startIndex, endIndex);
      return dataItem;
    },
  },
  created() {
    axios
      .get(
        "https://geektrust.s3-ap-southeast-1.amazonaws.com/adminui-problem/members.json"
      )
      .then((data) => {
        let apiData = data.data;
        localStorage.setItem("apiData", JSON.stringify(apiData));
      });
  },
  mounted() {
    const stored = localStorage.getItem("apiData");
    if (stored) {
      this.storedData = JSON.parse(stored);
    }
  },
  methods: {
    updateSelection(id) {
      this.selctedData.push(id);
    },
    deleteSelectedItem() {
      var filteredArray = this.storedData.filter(
        (item) => !this.selctedData.includes(item.id)
      );
      this.storedData = filteredArray;
      localStorage.setItem("apiData", JSON.stringify(this.storedData));
    },
    saveData() {
      const indexToUpdate = this.storedData.findIndex(
        (item) => item.id === this.emplydata[0].id
      );
      if (indexToUpdate !== -1) {
        this.storedData[indexToUpdate] = this.emplydata[0];

        localStorage.setItem("apiData", JSON.stringify(this.storedData));
      }
      this.showModal = false;
    },
    deleteItem(id) {
      const indexToDelete = this.storedData.findIndex((item) => item.id === id);
      if (indexToDelete !== -1) {
        this.storedData.splice(indexToDelete, 1);

        localStorage.setItem("apiData", JSON.stringify(this.storedData));
      }
    },

    showModalItem(id) {
      this.showModal = true;
      this.emplydata = this.storedData.filter((item) => {
        if (item.id == id) {
          return item;
        }
      });
    },
    search() {
      this.searchResults = this.storedData.filter((item) => {
        const searchValue = this.searchInput.replace(/\s/g, "").toLowerCase();
        if (
          item.name.replace(/\s/g, "").toLowerCase().includes(searchValue) ||
          item.role.replace(/\s/g, "").toLowerCase().includes(searchValue) ||
          item.email.replace(/\s/g, "").toLowerCase().includes(searchValue)
        ) {
          return item;
        }
      });
    },
    changePage(step) {
      this.currentPage += step;
    },
  },
};
</script>

<style lang="scss">
.todo-list {
  background-color: rgb(221, 231, 221);
  width: 100%;
  height: 100%;
  .title{
    display:flex;
    justify-content: center;
  }
  .search {
    position: relative;
    display: flex;
    flex-direction: row;
    width: 100%;
    justify-items: center;
    justify-content: center;
    .search-icon {
      position: absolute;
      top: 5px;
      left: --40px;
      @media screen and (min-width: 480px) {
        top: 7px;
        left: 9%;
      }
    }
    .input-text {
      width: 80%;
      height: 35px;
      border-radius: 4px;
      border: 1px solid black;
      padding-left: 30px;
    }
  }
  .list-item {
    display: flex;
    justify-content: center;
    table {
      width: 80%;
      border-collapse: collapse;
      margin: 20px 0;
    }

    th,
    td {
      padding: 10px;
      text-align: center;
    }

    thead {
      background-color: #f2f2f2;
    }

    th {
      background-color: #333;
      color: #fff;
    }

    tr:nth-child(even) {
      background-color: #f2f2f2;
    }

    tr:nth-child(odd) {
      background-color: #fff;
    }

    /* Add hover effect on rows */
    tr:hover {
      background-color: #ddd;
    }
  }
  .pagination {
    display: flex;
    justify-content: center;
  }
  .action {
    display: flex;
    flex-direction: row;
    justify-content: center;
    margin: 10px;
  }
  .button {
    border: none;
    background-color:rgb(227, 234, 228);
    cursor: pointer;
  }
  .edit-page {
    display: flex;
    flex-direction: column;
    justify-content: center;
    .heading {
      display: flex;
      justify-content: center;
      font-size: 20px;
      font-weight: 600;
    }
    .container {
      display: flex;
      flex-direction: column;
      justify-content: center;
      margin: auto;
      width: 70%;
    }
    .col {
      margin-top: 10px;
      display: flex;
      justify-content: space-between;
      width: 80%;
    }
  }
  .save-button {
    margin-top: 10px;
    background-color: rgb(219, 209, 209);
    color: black;
    height: 30px;
  }
  .deleted-button{
    margin-left:10%;
    margin-top:10px;
  }
  .delete-selected-button{
    margin-left:10%;
    display:flex;
    flex-direction: row;
    align-items: center;
    width:100%;
    
    .text{
        color:red;
        margin-right:7px;
    }

  }

}
</style>
