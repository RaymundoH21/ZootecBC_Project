package com.example.zootecbc;

import static com.example.zootecbc.R.color.color_actionbar;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;

public class menu_animales extends AppCompatActivity {
    ImageButton editar;
    Button regresar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu_animales);
        editar=(ImageButton) findViewById(R.id.img_btn_editar_1);
        regresar=(Button) findViewById(R.id.btn_regresar);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(color_actionbar)));

        editar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(menu_animales.this, editar_captura.class);
                startActivity(i);
            }
        });

        regresar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent r = new Intent(menu_animales.this, menu_captura.class);
                startActivity(r);
            }
        });
    }
}