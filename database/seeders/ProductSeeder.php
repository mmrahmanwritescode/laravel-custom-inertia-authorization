<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Product::create([
            'name' => 'Laptop',
            'sku' => 'LP001',
            'price' => 999.99,
            'stock' => 50,
        ]);
        
        Product::create([
            'name' => 'Mouse',
            'sku' => 'MS001',
            'price' => 29.99,
            'stock' => 100,
        ]);
        
        Product::create([
            'name' => 'Keyboard',
            'sku' => 'KB001',
            'price' => 79.99,
            'stock' => 75,
        ]);
        
        Product::create([
            'name' => 'Monitor',
            'sku' => 'MN001',
            'price' => 299.99,
            'stock' => 30,
        ]);
    }
}
