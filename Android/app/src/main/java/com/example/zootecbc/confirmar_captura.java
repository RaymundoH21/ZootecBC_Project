package com.example.zootecbc;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class confirmar_captura extends AppCompatActivity {
    Button subir;
    Button nueva;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_confirmar_captura);
        subir=(Button) findViewById(R.id.btn_subir_captura2);
        nueva=(Button) findViewById(R.id.btn_nueva_captura2);

        subir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(confirmar_captura.this, menu_captura.class);
                startActivity(i);
            }
        });

        nueva.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent e = new Intent(confirmar_captura.this, nueva_captura.class);
                startActivity(e);
            }
        });
    }
}