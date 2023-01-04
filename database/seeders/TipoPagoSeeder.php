<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class TipoPagoSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('tipo_pagos')->insert([
            'descripcion' => 'EFECTIVO'
        ]);
        DB::table('tipo_pagos')->insert([
            'descripcion' => 'TARJETA'
        ]);
    }
}
