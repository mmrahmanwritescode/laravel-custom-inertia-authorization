<template>
    <SideNavLayout>
        <div class="container-fluid">
            <div class="row">
                <div class="col-12">
                    <div class="page-header">
                        <h1 class="page-title">Edit Role</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><Link :href="route('roles.index')">Roles</Link></li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Role</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Role Information</h5>
                        </div>
                        <div class="card-body">
                            <form @submit.prevent="updateRole">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="name" class="form-label">Role Name *</label>
                                            <input 
                                                type="text" 
                                                id="name"
                                                v-model="form.name" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.name }"                                                
                                            >
                                            <div v-if="form.errors.name" class="invalid-feedback">
                                                {{ form.errors.name }}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="display_name" class="form-label">Display Name</label>
                                            <input 
                                                type="text" 
                                                id="display_name"
                                                v-model="form.display_name" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.display_name }"
                                            >
                                            <div v-if="form.errors.display_name" class="invalid-feedback">
                                                {{ form.errors.display_name }}
                                            </div>
                                            <small class="form-text text-muted">
                                                Human-readable name for this role
                                            </small>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group mb-4">
                                    <label for="description" class="form-label">Description</label>
                                    <textarea 
                                        id="description"
                                        v-model="form.description" 
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.description }"
                                        rows="3"
                                    ></textarea>
                                    <div v-if="form.errors.description" class="invalid-feedback">
                                        {{ form.errors.description }}
                                    </div>
                                </div>

                                <div class="form-group mb-4">
                                    <label class="form-label">Permissions</label>
                                    <div v-if="permissions.length > 0" class="permissions-grid">
                                        <div v-for="permission in permissions" :key="permission.id" class="permission-item">
                                            <div class="form-check">
                                                <input 
                                                    type="checkbox" 
                                                    :id="`permission_${permission.id}`"
                                                    :value="permission.id"
                                                    v-model="form.permissions"
                                                    class="form-check-input"
                                                >
                                                <label :for="`permission_${permission.id}`" class="form-check-label">
                                                    <strong>{{ permission.name }}</strong>
                                                    <div v-if="permission.description" class="permission-description">
                                                        {{ permission.description }}
                                                    </div>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <div v-else class="text-muted">
                                        No permissions available
                                    </div>
                                    <div v-if="form.errors.permissions" class="text-danger mt-2">
                                        {{ form.errors.permissions }}
                                    </div>
                                </div>

                                <div class="">
                                    <button type="submit" class="btn btn-edit me-2" :disabled="form.processing">
                                        <i class="fa fa-save me-2"></i>
                                        {{ form.processing ? 'Updating...' : 'Update Role' }}
                                    </button>                                    
                                    <Link :href="route('roles.index')" class="btn btn-secondary me-2">
                                        <i class="fa fa-arrow-left me-2"></i>Back to Roles
                                    </Link>
                                    <button type="button" @click="selectAllPermissions" class="btn btn-outline-primary me-2">
                                        <i class="fa fa-check-double me-2"></i>Select All
                                    </button>
                                    <button type="button" @click="clearAllPermissions" class="btn btn-outline-secondary me-2">
                                        <i class="fa fa-times me-2"></i>Clear All
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Role Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="role-info">
                                <p><strong>Created:</strong> {{ formatDate(role.created_at) }}</p>
                                <p><strong>Last Updated:</strong> {{ formatDate(role.updated_at) }}</p>
                                <p><strong>Users with this role:</strong> {{ role.users_count || 0 }}</p>
                                <div class="mt-3">
                                    <p><strong>Current Permissions:</strong></p>
                                    <div v-if="role.permissions && role.permissions.length > 0" class="current-permissions">
                                        <span v-for="permission in role.permissions" :key="permission.id" class="badge bg-secondary me-1 mb-1">
                                            {{ permission.name }}
                                        </span>
                                    </div>
                                    <span v-else class="text-muted">No permissions assigned</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card mt-3">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Selected Permissions</h5>
                        </div>
                        <div class="card-body">
                            <div v-if="selectedPermissions.length > 0" class="selected-permissions">
                                <span v-for="permission in selectedPermissions" :key="permission.id" class="badge bg-primary me-1 mb-1">
                                    {{ permission.name }}
                                </span>
                            </div>
                            <div v-else class="text-muted">
                                No permissions selected
                            </div>
                        </div>
                    </div>

                    <div v-if="role.users_count > 0" class="card mt-3">
                        <div class="card-header bg-warning">
                            <h5 class="card-title mb-0 text-dark">
                                <i class="fa fa-exclamation-triangle me-2"></i>Warning
                            </h5>
                        </div>
                        <div class="card-body">
                            <p class="mb-0 small">
                                This role is currently assigned to {{ role.users_count }} user(s). 
                                Changes to permissions will affect all users with this role.
                            </p>
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
    role: Object,
    permissions: Array
});

const form = useForm({
    name: props.role.name,
    display_name: props.role.display_name || '',
    description: props.role.description || '',
    permissions: props.role.permissions ? props.role.permissions.map(p => p.id) : []
});

const selectedPermissions = computed(() => {
    return props.permissions.filter(permission => 
        form.permissions.includes(permission.id)
    );
});

const updateRole = () => {
    form.put(route('roles.update', props.role.id), {
        onSuccess: () => {
          if (page.props.flash.status === true) {
              toaster.success(page.props.flash.message);
              router.get(route('roles.edit', props.role.id));
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

const selectAllPermissions = () => {
    form.permissions = props.permissions.map(p => p.id);
};

const clearAllPermissions = () => {
    form.permissions = [];
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
.permissions-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1rem;
    max-height: 300px;
    overflow-y: auto;
    border: 1px solid #dee2e6;
    border-radius: 0.375rem;
    padding: 1rem;
    background-color: #f8f9fa;
}

.permission-item {
    padding: 0.5rem;
    border: 1px solid #e9ecef;
    border-radius: 0.25rem;
    background-color: white;
}

.permission-description {
    font-size: 0.75rem;
    color: #6c757d;
    margin-top: 0.25rem;
}

.role-info p {
    margin-bottom: 0.5rem;
}

.role-info strong {
    color: #495057;
}

.current-permissions .badge,
.selected-permissions .badge {
    font-size: 0.75rem;
}
</style>
