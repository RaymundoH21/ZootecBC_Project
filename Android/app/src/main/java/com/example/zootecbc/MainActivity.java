package com.example.zootecbc;

import static com.example.zootecbc.R.color.color_actionbar;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {

    Button Login;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Login=(Button) findViewById(R.id.btn_Login);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(color_actionbar)));

        Login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent i = new Intent(MainActivity.this, menu_captura.class);
                startActivity(i);
            }
        });
    }
}