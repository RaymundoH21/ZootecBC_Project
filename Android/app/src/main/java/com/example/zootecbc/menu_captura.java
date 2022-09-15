package com.example.zootecbc;

import static com.example.zootecbc.R.color.color_actionbar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

public class menu_captura extends AppCompatActivity {

    private FirebaseAuth mAuth;
    private DatabaseReference mDatabase;

    private TextView mtextViewName;
    private TextView mtextViewEmail;

    Button subir;
    Button editar;
    private Button mButtonSignOut;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu_captura);
        subir=(Button) findViewById(R.id.btn_nueva_captura);
        editar=(Button) findViewById(R.id.btn_editar_captura);

        mtextViewName=(TextView) findViewById(R.id.textViewName);
        mtextViewEmail=(TextView) findViewById(R.id.textViewEmail);

        mAuth = FirebaseAuth.getInstance();
        mDatabase = FirebaseDatabase.getInstance().getReference();

        mButtonSignOut = (Button) findViewById(R.id.btnSignout);

        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(color_actionbar)));

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
                Intent e = new Intent(menu_captura.this, menu_animales.class);
                startActivity(e);
            }
        });

        mButtonSignOut.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mAuth.signOut();
                startActivity(new Intent(menu_captura.this, MainActivity.class));
                finish();
            }
        });
        getUserInfo();
    }
    private void getUserInfo(){
        String id_usuario = mAuth.getCurrentUser().getUid();
        mDatabase.child("Usuarios").child(id_usuario).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if (snapshot.exists()){
                    String username = snapshot.child("username").getValue().toString();
                    String email = snapshot.child("email").getValue().toString();

                    mtextViewName.setText(username);
                    mtextViewEmail.setText(email);
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }
}