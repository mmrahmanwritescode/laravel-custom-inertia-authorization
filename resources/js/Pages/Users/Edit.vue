<template>
    <SideNavLayout>
        <div class="container-fluid">
            <div class="row">
                <div class="col-12">
                    <div class="page-header">
                        <h1 class="page-title">Edit User</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><Link :href="route('users.index')">Users</Link></li>
                                <li class="breadcrumb-item active" aria-current="page">Edit User</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">User Information</h5>
                        </div>
                        <div class="card-body">
                            <form @submit.prevent="updateUser">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="name" class="form-label fw-bold">Name *</label>
                                            <input 
                                                type="text" 
                                                id="name"
                                                v-model="form.name" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.name }"
                                                required
                                            >
                                            <span v-if="form.errors.name" class="text-danger mt-2 d-block">
                                                {{ form.errors.name }}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="email" class="form-label fw-bold">Email *</label>
                                            <input 
                                                type="email" 
                                                id="email"
                                                v-model="form.email" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.email }"
                                                required
                                            >
                                            <span v-if="form.errors.email" class="text-danger mt-2 d-block">
                                                {{ form.errors.email }}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="password" class="form-label fw-bold">Password</label>
                                            <input 
                                                type="password" 
                                                id="password"
                                                v-model="form.password" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.password || errors.password }"
                                                placeholder="Leave blank to keep current password"
                                            >
                                            <span v-if="form.errors.password" class="text-danger mt-2 d-block">
                                                {{ form.errors.password }}
                                            </span>
                                            <span v-else-if="errors.password" class="text-danger mt-2 d-block">
                                                {{ errors.password }}
                                            </span>
                                            <small class="form-text text-muted">Minimum 8 characters required (leave blank to keep current)</small>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="password_confirmation" class="form-label fw-bold">Confirm Password</label>
                                            <input 
                                                type="password" 
                                                id="password_confirmation"
                                                v-model="form.password_confirmation" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.password_confirmation || errors.password_confirmation || passwordMismatch }"
                                                placeholder="Confirm new password"
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
                                    </div>
                                </div>

                                <div class="form-group mb-4">
                                    <label class="form-label fw-bold">Roles</label>
                                    <div class="row">
                                        <div v-for="role in roles" :key="role.id" class="col-md-4 mb-2">
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
                                    <div v-if="form.errors.roles" class="text-danger mt-1">
                                        {{ form.errors.roles }}
                                    </div>
                                </div>

                                <div class="">
                                    <button type="submit" class="btn btn-edit me-2" :disabled="form.processing">
                                        <i class="fa fa-save me-2"></i>
                                        {{ form.processing ? 'Updating...' : 'Update User' }}
                                    </button>                                    
                                    <Link href="/users" class="btn btn-secondary">
                                        <i class="fa fa-arrow-left me-2"></i>Back to Users
                                    </Link>

                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">User Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="user-info">
                                <p><strong>Created:</strong> {{ formatDate(user.created_at) }}</p>
                                <p><strong>Last Updated:</strong> {{ formatDate(user.updated_at) }}</p>
                                <p><strong>Current Roles:</strong></p>
                                <div v-if="user.roles && user.roles.length > 0" class="role-badges">
                                    <span v-for="role in user.roles" :key="role.id" class="badge bg-primary me-1 mb-1">
                                        {{ role.name }}
                                    </span>
                                </div>
                                <span v-else class="text-muted">No roles assigned</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </SideNavLayout>
</template>

<script setup>
import { Link, useForm, router, usePage } from '@inertiajs/vue3';
import { defineProps, ref, computed, watch } from 'vue';
import SideNavLayout from '@/Layout/SideNavLayout.vue';
import { createToaster } from "@meforma/vue-toaster";

const page = usePage();
const toaster = createToaster({
  duration: 4000
});

// Validation Errors
const errors = ref({});

const props = defineProps({
    user: Object,
    roles: Array
});

const form = useForm({
    name: props.user.name,
    email: props.user.email,
    password: '',
    password_confirmation: '',
    roles: props.user.roles ? props.user.roles.map(role => role.id) : []
});



// Password validation computed properties
const passwordMatch = computed(() => {
  return form.password && form.password_confirmation && form.password === form.password_confirmation;
});

const passwordMismatch = computed(() => {
  return form.password && form.password_confirmation && form.password !== form.password_confirmation;
});

const isPasswordValid = computed(() => {
  return !form.password || form.password.length >= 8;
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

const updateUser = () => {

    form.put(route('users.update', props.user.id), {
        onSuccess: () => {
          if (page.props.flash.status === true) {
              toaster.success(page.props.flash.message);
              router.get(route('users.edit', props.user.id));
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

const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
};
</script>

<style scoped>
.role-badges .badge {
    font-size: 0.875rem;
}

.user-info p {
    margin-bottom: 0.5rem;
}

.user-info strong {
    color: #495057;
}
</style>
