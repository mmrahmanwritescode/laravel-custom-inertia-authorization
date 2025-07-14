<template>
  <SideNavLayout>
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-8 mx-auto">
          <div class="card admin-card">
            <div class="card-header">
              <h3 class="card-title">Create New User</h3>
            </div>
            <div class="card-body">
              <form @submit.prevent="submit">
                <div class="mb-4">
                  <label for="name" class="form-label fw-bold">Full Name</label>
                  <input 
                    type="text" 
                    id="name"
                    v-model="form.name" 
                    class="form-control"
                    :class="{ 'is-invalid': errors.name }"
                  >
                    <span v-if="form.errors.name" class="text-danger mt-2 d-block">
                          {{ form.errors.name }}
                      </span>
                </div>

                <div class="mb-4">
                  <label for="email" class="form-label fw-bold">Email Address</label>
                  <input 
                    type="email" 
                    id="email"
                    v-model="form.email" 
                    class="form-control"
                    :class="{ 'is-invalid': errors.email }"
                  >
                    <span v-if="form.errors.email" class="text-danger mt-2 d-block">
                          {{ form.errors.email }}
                      </span>
                </div>

                <div class="mb-4">
                  <label for="password" class="form-label fw-bold">Password *</label>
                  <input 
                    type="password" 
                    id="password"
                    v-model="form.password" 
                    class="form-control"
                    :class="{ 'is-invalid': form.errors.password || errors.password }"
                  >
                  <span v-if="form.errors.password" class="text-danger mt-2 d-block">
                    {{ form.errors.password }}
                  </span>
                  <span v-else-if="errors.password" class="text-danger mt-2 d-block">
                    {{ errors.password }}
                  </span>
                  <small class="form-text text-muted">Minimum 8 characters required</small>
                </div>

                <div class="mb-4">
                  <label for="password_confirmation" class="form-label fw-bold">Confirm Password *</label>
                  <input 
                    type="password" 
                    id="password_confirmation"
                    v-model="form.password_confirmation" 
                    class="form-control"
                    :class="{ 'is-invalid': form.errors.password_confirmation || errors.password_confirmation || passwordMismatch }"
                  >
                  <span v-if="form.errors.password_confirmation" class="text-danger mt-2 d-block">
                    {{ form.errors.password_confirmation }}
                  </span>
                  <span v-else-if="errors.password_confirmation" class="text-danger mt-2 d-block">
                    {{ errors.password_confirmation }}
                  </span>
                  <span v-else-if="passwordMismatch" class="text-danger mt-2 d-block">
                    Passwords do not match
                  </span>
                  <span v-else-if="passwordMatch && form.password && form.password_confirmation" class="text-success mt-2 d-block">
                    <i class="fa fa-check me-1"></i>Passwords match
                  </span>
                </div>

                <div class="mb-4">
                  <label class="form-label fw-bold">Assign Roles</label>
                  <div class="row">
                    <div v-for="role in roles" :key="role.id" class="col-md-6 mb-2">
                      <div class="form-check">
                        <input 
                          type="checkbox" 
                          :id="`role_${role.id}`"
                          :value="role.id"
                          v-model="form.roles"
                          class="form-check-input"
                        >
                        <label :for="`role_${role.id}`" class="form-check-label">
                          {{ role.name }}
                        </label>
                      </div>
                    </div>
                  </div>
                  <div v-if="errors.roles" class="text-danger">{{ errors.roles }}</div>
                </div>

                <div class="mb-3">
                  <button type="submit" class="btn btn-edit me-2" :disabled="form.processing">
                    <i class="fa fa-save me-1"></i> 
                    {{ form.processing ? 'Creating...' : 'Create User' }}
                  </button>                  
                  <Link :href="route('users.index')" class="btn btn-secondary">
                    <i class="fa fa-arrow-left me-1"></i> Back to Users
                  </Link>

                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </SideNavLayout>
</template>

<script setup>
import { defineProps, ref, computed, watch } from 'vue';
import { router, Link, useForm, usePage } from '@inertiajs/vue3';
import SideNavLayout from '@/Layout/SideNavLayout.vue';
import { createToaster } from "@meforma/vue-toaster";

const page = usePage();
const toaster = createToaster({
  duration: 4000
});

// Validation Errors
const errors = ref({});

const props = defineProps({
  roles: {
    type: Array,
    default: () => []
  }
});

const form = useForm({
  name: '',
  email: '',
  password: '',
  password_confirmation: '',
  roles: []
});



// Password validation computed properties
const passwordMatch = computed(() => {
  return form.password && form.password_confirmation && form.password === form.password_confirmation;
});

const passwordMismatch = computed(() => {
  return form.password && form.password_confirmation && form.password !== form.password_confirmation;
});

const isPasswordValid = computed(() => {
  return form.password && form.password.length >= 8;
});

// Watch for password changes to show real-time validation
watch([() => form.password, () => form.password_confirmation], () => {
  // Clear previous password-related errors when user types
  if (form.password && form.password.length >= 8) {
    if (errors.value.password) {
      delete errors.value.password;
    }
  }
  if (form.password_confirmation && form.password === form.password_confirmation) {
    if (errors.value.password_confirmation) {
      delete errors.value.password_confirmation;
    }
  }
});

const submit = () => {

  form.post(route('users.store'), {
    onSuccess: () => {
      if (page.props.flash.status === true) {
        toaster.success(page.props.flash.message);
        router.get(route('users.index'));
      } else {
        toaster.error(page.props.flash.message);
      }
    },
    onError: (errors) => {
      Object.keys(errors).forEach(key => {
        if (errors[key]) {
          toaster.error(errors[key]);
        }
      });
    }
  });
};
</script>
