<?php

use App\Http\Controllers\DashboardController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\RegisterController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\PermissionController;
use Illuminate\Support\Facades\Route;
use App\Http\Middleware\SessionAuthenticate;

// Public routes
Route::get('/', fn() => redirect()->route('LoginPage') );

Route::controller(LoginController::class)->group(function () {
    Route::get('/login', 'LoginPage')->name('LoginPage');
    Route::post('/login', 'login')->name('login');
    Route::get('/logout', 'logout')->name('logout');
});

Route::controller(RegisterController::class)->group(function () {
    Route::get('/register', 'RegistrationPage')->name('RegistrationPage');
    Route::post('/register', 'register')->name('register');
});


// Protected routes
Route::middleware([SessionAuthenticate::class])->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('DashboardPage');
    
    // Resource routes with permission middleware
    Route::resource('users', UserController::class)->middleware('permission:view-user,create-user,edit-user,delete-user');
    Route::resource('products', ProductController::class)->middleware('permission:view-product,create-product,edit-product,delete-product');
    Route::resource('roles', RoleController::class)->middleware('permission:view-role,create-role,edit-role,delete-role');
    Route::resource('permissions', PermissionController::class)->middleware('permission:view-permission,create-permission,edit-permission,delete-permission');

});
