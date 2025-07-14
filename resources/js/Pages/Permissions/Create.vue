<template>
    <SideNavLayout>
        <div class="container-fluid">
            <div class="row">
                <div class="col-12">
                    <div class="page-header">
                        <h1 class="page-title">Create Permission</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><Link :href="route('permissions.index')">Permissions</Link></li>
                                <li class="breadcrumb-item active" aria-current="page">Create Permission</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Permission Information</h5>
                        </div>
                        <div class="card-body">
                            <form @submit.prevent="createPermission">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="name" class="form-label">Permission Name *</label>
                                            <input 
                                                type="text" 
                                                id="name"
                                                v-model="form.name" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.name }"
                                                placeholder="e.g., view-user, edit-product"
                                            >
                                            <div v-if="form.errors.name" class="invalid-feedback">
                                                {{ form.errors.name }}
                                            </div>
                                            <small class="form-text text-muted">
                                                Use lowercase with hyphens (kebab-case)
                                            </small>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <button type="submit" class="btn btn-edit me-2" :disabled="form.processing">
                                        <i class="fa fa-plus me-2"></i>
                                        {{ form.processing ? 'Creating...' : 'Create Permission' }}
                                    </button>                                    
                                    <Link href="/permissions" class="btn btn-secondary">
                                        <i class="fa fa-arrow-left me-2"></i>Back to Permissions
                                    </Link>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Permission Guidelines</h5>
                        </div>
                        <div class="card-body">
                            <div class="guidelines">
                                <h6><i class="fa fa-info-circle text-info me-2"></i>Naming Conventions</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fa fa-check text-success me-2"></i>Use action-resource format</li>
                                    <li><i class="fa fa-check text-success me-2"></i>Use lowercase with hyphens</li>
                                    <li><i class="fa fa-check text-success me-2"></i>Be specific and clear</li>
                                    <li><i class="fa fa-check text-success me-2"></i>Avoid spaces and special chars</li>
                                </ul>

                                <h6 class="mt-3"><i class="fa fa-lightbulb text-warning me-2"></i>Common Examples</h6>
                                <div class="example-permissions">
                                    <div class="example-category">
                                        <strong>User Management:</strong><br>
                                        <small class="text-muted">
                                            view-user, create-user<br>
                                            edit-user, delete-user
                                        </small>
                                    </div>
                                    <div class="example-category mt-2">
                                        <strong>Product Management:</strong><br>
                                        <small class="text-muted">
                                            view-product, create-product<br>
                                            edit-product, delete-product
                                        </small>
                                    </div>
                                    <div class="example-category mt-2">
                                        <strong>System Admin:</strong><br>
                                        <small class="text-muted">
                                            manage-roles, manage-permissions<br>
                                            view-logs, backup-system
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card mt-3">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Permission Preview</h5>
                        </div>
                        <div class="card-body">
                            <div class="permission-preview">
                                <div class="preview-item">
                                    <strong>System Name:</strong><br>
                                    <code class="preview-name">{{ form.name || 'permission-name' }}</code>
                                </div>
                                <!-- <div class="preview-item mt-2">
                                    <strong>Display Name:</strong><br>
                                    <span class="preview-display">{{ form.display_name || 'Display Name' }}</span>
                                </div>
                                <div v-if="form.description" class="preview-item mt-2">
                                    <strong>Description:</strong><br>
                                    <small class="text-muted">{{ form.description }}</small>
                                </div> -->
                            </div>
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

const form = useForm({
    name: '',
    // display_name: '',
    // description: ''
});

const createPermission = () => {

  form.post(route('permissions.store'), {
    onSuccess: () => {
      if (page.props.flash.status === true) {
        toaster.success(page.props.flash.message);
        router.get(route('permissions.index'));
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

<style scoped>
.guidelines h6 {
    font-size: 0.9rem;
    font-weight: 600;
    color: #495057;
}

.guidelines ul li {
    font-size: 0.875rem;
    margin-bottom: 0.25rem;
    color: #6c757d;
}

.example-permissions {
    background-color: #f8f9fa;
    padding: 0.75rem;
    border-radius: 0.25rem;
    margin-top: 0.5rem;
}

.example-category {
    margin-bottom: 0.5rem;
}

.example-category:last-child {
    margin-bottom: 0;
}

.permission-preview {
    background-color: #f8f9fa;
    padding: 1rem;
    border-radius: 0.25rem;
    border: 1px solid #e9ecef;
}

.preview-item {
    margin-bottom: 0.75rem;
}

.preview-item:last-child {
    margin-bottom: 0;
}

.preview-name {
    background-color: #e9ecef;
    padding: 0.25rem 0.5rem;
    border-radius: 0.25rem;
    font-size: 0.875rem;
    color: #495057;
}

.preview-display {
    font-weight: 500;
    color: #495057;
}

.form-text {
    font-size: 0.875rem;
}
</style>
