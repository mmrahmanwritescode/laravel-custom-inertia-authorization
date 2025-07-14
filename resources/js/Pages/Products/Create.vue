<template>
    <SideNavLayout>
        <div class="container-fluid">
            <div class="row">
                <div class="col-12">
                    <div class="page-header">
                        <h1 class="page-title">Create Product</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><Link :href="route('products.index')">Products</Link></li>
                                <li class="breadcrumb-item active" aria-current="page">Create Product</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Product Information</h5>
                        </div>
                        <div class="card-body">
                            <form @submit.prevent="submit">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="name" class="form-label fw-bold">Product Name *</label>
                                            <input 
                                                type="text" 
                                                id="name"
                                                v-model="form.name" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.name }"
                                                placeholder="Enter product name"
                                            >
                                            <div v-if="form.errors.name" class="invalid-feedback">
                                                {{ form.errors.name }}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="price" class="form-label fw-bold">Price *</label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <input 
                                                    type="number" 
                                                    id="price"
                                                    v-model="form.price" 
                                                    class="form-control"
                                                    :class="{ 'is-invalid': form.errors.price }"
                                                    placeholder="0.00"
                                                    step="0.01"
                                                    min="0"
                                                >
                                                <div v-if="form.errors.price" class="invalid-feedback">
                                                    {{ form.errors.price }}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group mb-3">
                                    <label for="description" class="form-label fw-bold">Description</label>
                                    <textarea 
                                        id="description"
                                        v-model="form.description" 
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.description }"
                                        rows="4"
                                        placeholder="Enter product description"
                                    ></textarea>
                                    <div v-if="form.errors.description" class="invalid-feedback">
                                        {{ form.errors.description }}
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="sku" class="form-label fw-bold">SKU</label>
                                            <input 
                                                type="text" 
                                                id="sku"
                                                v-model="form.sku" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.sku }"
                                                placeholder="Product SKU"
                                            >
                                            <div v-if="form.errors.sku" class="invalid-feedback">
                                                {{ form.errors.sku }}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="stock" class="form-label fw-bold">Stock Quantity</label>
                                            <input 
                                                type="number" 
                                                id="stock"
                                                v-model="form.stock" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.stock }"
                                                placeholder="0"
                                                min="0"
                                            >
                                            <div v-if="form.errors.stock" class="invalid-feedback">
                                                {{ form.errors.stock }}
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group mb-4">
                                    <div class="form-check">
                                        <input 
                                            type="checkbox" 
                                            id="is_active"
                                            v-model="form.is_active"
                                            class="form-check-input"
                                        >
                                        <label for="is_active" class="form-check-label fw-bold">
                                            Active Product
                                        </label>
                                    </div>
                                    <small class="form-text text-muted">
                                        Active products will be visible to customers
                                    </small>
                                </div>

                                <div class="">
                                    <button type="submit" class="btn btn-edit me-2" :disabled="form.processing">
                                        <i class="fa fa-plus me-2"></i>
                                        {{ form.processing ? 'Creating...' : 'Create Product' }}
                                    </button>                                    
                                    <Link :href="route('products.index')" class="btn btn-secondary">
                                        <i class="fa fa-arrow-left me-2"></i>Back to Products
                                    </Link>

                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Product Guidelines</h5>
                        </div>
                        <div class="card-body">
                            <div class="guidelines">
                                <h6><i class="fa fa-info-circle text-info me-2"></i>Product Information</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fa fa-check text-success me-2"></i>Use descriptive product names</li>
                                    <li><i class="fa fa-check text-success me-2"></i>Set competitive pricing</li>
                                    <li><i class="fa fa-check text-success me-2"></i>Add detailed descriptions</li>
                                    <li><i class="fa fa-check text-success me-2"></i>Use unique SKU codes</li>
                                </ul>

                                <h6 class="mt-3"><i class="fa fa-exclamation-triangle text-warning me-2"></i>Required Fields</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fa fa-asterisk text-danger me-2"></i>Product Name</li>
                                    <li><i class="fa fa-asterisk text-danger me-2"></i>Price</li>
                                </ul>
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
import { route } from 'ziggy-js';

const page = usePage();
const toaster = createToaster({
  duration: 4000
});
// Validation Errors
const errors = ref({});

const form = useForm({
    name: '',
    price: '',
    description: '',
    sku: '',
    stock: 0,
    is_active: true
});

const submit = () => {

  form.post(route('products.store'), {
    onSuccess: () => {
      if (page.props.flash.status === true) {
        toaster.success(page.props.flash.message);
        router.get(route('products.index'));
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

.input-group-text {
    background-color: #f8f9fa;
    border-color: #ced4da;
}
</style>
