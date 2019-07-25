<template>
  <div>
    <section>
      <b-field hidden>
        <b-input :value="currentEmployee.id" v-model="currentEmployee.id"></b-input>
      </b-field>

      <b-field label="Name">
        <b-input :value="currentEmployee.name" v-model="currentEmployee.name"></b-input>
      </b-field>

      <b-field label="Email">
        <b-input
          type="email"
          :value="currentEmployee.email"
          :disabled="editing"
          v-model="currentEmployee.email"
          required
        ></b-input>
      </b-field>

      <b-field label="Department">
        <b-input :value="currentEmployee.department" v-model="currentEmployee.department" required></b-input>
      </b-field>

      <b-button type="is-info" @click="handleSubmit">{{ editing ? 'Update' : 'Create' }}</b-button>
    </section>

    <hr />

    <b-table :data="employees">
      <template slot-scope="props">
        <b-table-column field="id" label="ID">{{ props.row.id }}</b-table-column>
        <b-table-column field="name" label="Name">{{ props.row.name }}</b-table-column>
        <b-table-column field="email" label="Email">{{ props.row.email }}</b-table-column>
        <b-table-column field="department" label="Department">{{ props.row.department }}</b-table-column>

        <b-table-column field="update" label="Update">
          <b-button type="is-info" @click="handleUpdate(props.row.id)">
            <b-icon icon="pencil" size="is-small"></b-icon>
          </b-button>
        </b-table-column>

        <b-table-column field="delete" label="Delete">
          <b-button type="is-danger" @click="deleteEmployee(props.row.email)">
            <b-icon icon="trash-can" size="is-small"></b-icon>
          </b-button>
        </b-table-column>
      </template>
    </b-table>
  </div>
</template>

<script>
import axios from "axios";

const endpoint = "http://127.0.0.1:8000/employee";

async function listEmployees() {
  const response = await axios.get(endpoint);
  const employees = response.data;

  return employees;
}

async function createEmployee(employee) {
  const headers = {
    "Content-Type": "application/json"
  };

  const response = await axios.post(endpoint, employee, { headers });

  return response.data;
}

async function updateEmployee(email, employee) {
  const headers = {
    "Content-Type": "application/json"
  };

  const response = await axios.put(`${endpoint}/${email}`, employee, {
    headers
  });

  return response.data;
}

async function deleteEmployee(email) {
  const response = await axios.delete(`${endpoint}/${email}`);

  return response.data;
}

export default {
  name: "Home",
  data() {
    return {
      employees: [],
      editing: false,
      currentEmployee: {}
    };
  },

  async mounted() {
    try {
      this.employees = await listEmployees();
    } catch (err) {
      this.danger(err.message);
      this.danger(err.response.data.error);
    }
  },

  methods: {
    async handleSubmit() {
      try {
        if (this.editing) {
          await this.updateEmployee();
        } else {
          await this.createEmployee();
        }
      } catch (err) {
        this.danger(err.message);
        this.danger(err.response.data.error);
      }
    },
    handleUpdate(id) {
      this.currentEmployee = this.employees.find(e => e.id === id) || {};
      this.editing = !!this.currentEmployee;
    },
    async createEmployee() {
      try {
        const employee = { ...this.currentEmployee };
        delete employee.id;

        const created = await createEmployee(employee);

        this.currentEmployee = {};

        this.employees.push(created);
        this.success(`Employee ${created.name} created with success`);
      } catch (err) {
        this.danger(err.message);
        this.danger(err.response.data.error);
      }
    },
    async updateEmployee() {
      try {
        const employee = { ...this.currentEmployee };
        delete employee.id;

        const updated = await updateEmployee(employee.email, employee);

        const idx = this.employees.findIndex(e => e.email === employee.email);
        this.employees[idx] = updated;

        this.currentEmployee = {};
        this.editing = false;

        this.success(`Employee ${employee.name} updated with success`);
      } catch (err) {
        this.danger(err.message);
        this.danger(err.response.data.error);
      }
    },
    async deleteEmployee(email) {
      try {
        await deleteEmployee(email);

        this.employees = this.employees.filter(e => e.email !== email);
        this.success(`Employee with email: ${email} was deleted`);
      } catch (err) {
        this.danger(err.message);
        this.danger(err.response.data.error);
      }
    },
    success(message) {
      this.$toast.open({
        message,
        type: "is-success",
        position: "is-bottom"
      });
    },
    danger(message) {
      this.$toast.open({
        message,
        duration: 5000,
        position: "is-bottom",
        type: "is-danger"
      });
    }
  }
};
</script>