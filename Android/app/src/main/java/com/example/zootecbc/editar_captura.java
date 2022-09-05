package com.example.zootecbc;

import static com.example.zootecbc.R.color.color_actionbar;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class editar_captura extends AppCompatActivity {

    Button siguiente;
    Button cancelar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_editar_captura);
        siguiente=(Button) findViewById(R.id.btn_Guardar2);
        cancelar=(Button) findViewById(R.id.btn_Cancelar2);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(color_actionbar)));

        siguiente.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(editar_captura.this, menu_captura.class);
                startActivity(i);
            }
        });

        cancelar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent e = new Intent(editar_captura.this, menu_animales.class);
                startActivity(e);
            }
        });
    }
}