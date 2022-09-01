package com.example.zootecbc;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class menu_captura extends AppCompatActivity {

    Button subir;
    Button editar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu_captura);
        subir=(Button) findViewById(R.id.btn_nueva_captura);
        editar=(Button) findViewById(R.id.btn_editar_captura);

        subir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(menu_captura.this, nueva_captura.class);
                startActivity(i);
            }
        });

        editar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent e = new Intent(menu_captura.this, editar_captura.class);
                startActivity(e);
            }
        });
    }
}