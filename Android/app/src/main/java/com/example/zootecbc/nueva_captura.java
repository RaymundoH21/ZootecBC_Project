package com.example.zootecbc;

import static com.example.zootecbc.R.color.color_actionbar;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;

public class nueva_captura extends AppCompatActivity {

    Button siguiente;
    Button cancelar;
    ImageButton camara;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_nueva_captura);
        siguiente=(Button) findViewById(R.id.btn_subir);
        cancelar=(Button) findViewById(R.id.btn_Cancelar);
        camara=(ImageButton) findViewById(R.id.img_btn_camara);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(color_actionbar)));

        siguiente.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(nueva_captura.this, confirmar_captura.class);
                startActivity(i);
            }
        });

        cancelar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent e = new Intent(nueva_captura.this, menu_captura.class);
                startActivity(e);
            }
        });

        camara.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    Intent intent = new Intent();
                    intent.setAction(MediaStore.ACTION_IMAGE_CAPTURE);
                    startActivity(intent);
                }
                catch (Exception e){
                    e.printStackTrace();
                }
            }
        });
    }
}